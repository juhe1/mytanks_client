package alternativa.tanks.models.battlefield
{
   import alternativa.console.ConsoleVarFloat;
   import alternativa.console.ConsoleVarInt;
   import alternativa.console.IConsole;
   import alternativa.engine3d.containers.KDContainer;
   import alternativa.engine3d.core.Camera3D;
   import alternativa.engine3d.core.Light3D;
   import alternativa.engine3d.core.Object3D;
   import alternativa.engine3d.core.RayIntersectionData;
   import alternativa.engine3d.materials.TextureMaterial;
   import alternativa.engine3d.objects.Decal;
   import alternativa.engine3d.objects.Mesh;
   import alternativa.engine3d.objects.SkyBox;
   import alternativa.init.Main;
   import alternativa.math.Vector3;
   import alternativa.model.IModel;
   import alternativa.model.IObjectLoadListener;
   import alternativa.object.ClientObject;
   import alternativa.osgi.service.debug.IDebugService;
   import alternativa.osgi.service.dump.IDumpService;
   import alternativa.osgi.service.dump.dumper.IDumper;
   import alternativa.osgi.service.focus.IFocusService;
   import alternativa.osgi.service.log.LogLevel;
   import alternativa.osgi.service.mainContainer.IMainContainerService;
   import alternativa.osgi.service.network.INetworkListener;
   import alternativa.osgi.service.network.INetworkService;
   import alternativa.osgi.service.storage.IStorageService;
   import alternativa.physics.Body;
   import alternativa.physics.PhysicsScene;
   import alternativa.physics.altphysics;
   import alternativa.physics.collision.CollisionPrimitive;
   import alternativa.physics.collision.IBodyCollisionPredicate;
   import alternativa.proplib.PropLibRegistry;
   import alternativa.register.ObjectRegister;
   import alternativa.register.SpaceInfo;
   import alternativa.service.IAddressService;
   import alternativa.service.IModelService;
   import alternativa.service.ISpaceService;
   import alternativa.tanks.battle.Trigger;
   import alternativa.tanks.battle.triggers.Triggers;
   import alternativa.tanks.bg.IBackgroundService;
   import alternativa.tanks.bonuses.IBonus;
   import alternativa.tanks.bonuses.IBonusListener;
   import alternativa.tanks.camera.FlyCameraController;
   import alternativa.tanks.camera.FollowCameraController;
   import alternativa.tanks.camera.GameCamera;
   import alternativa.tanks.camera.ICameraController;
   import alternativa.tanks.camera.ICameraStateModifier;
   import alternativa.tanks.camera.IFollowCameraController;
   import alternativa.tanks.camera.ProjectileHitCameraModifier;
   import alternativa.tanks.config.Config;
   import alternativa.tanks.gui.newyear.ToyLightAnimation;
   import alternativa.tanks.model.panel.IBattleSettings;
   import alternativa.tanks.model.panel.IPanel;
   import alternativa.tanks.model.panel.IPanelListener;
   import alternativa.tanks.model.panel.PanelModel;
   import alternativa.tanks.models.battlefield.decals.DecalFactory;
   import alternativa.tanks.models.battlefield.decals.FadingDecalsRenderer;
   import alternativa.tanks.models.battlefield.decals.Queue;
   import alternativa.tanks.models.battlefield.decals.RotationState;
   import alternativa.tanks.models.battlefield.dust.Dust;
   import alternativa.tanks.models.battlefield.gamemode.DayGameMode;
   import alternativa.tanks.models.battlefield.gamemode.DefaultGameModel;
   import alternativa.tanks.models.battlefield.gamemode.GameModes;
   import alternativa.tanks.models.battlefield.gamemode.IGameMode;
   import alternativa.tanks.models.battlefield.gui.IBattlefieldGUI;
   import alternativa.tanks.models.battlefield.hidableobjects.HidableGraphicObjects;
   import alternativa.tanks.models.battlefield.logic.BattleLogicUnits;
   import alternativa.tanks.models.battlefield.shadows.BattleShadow;
   import alternativa.tanks.models.battlefield.skybox.Object3DRevolver;
   import alternativa.tanks.models.effects.common.bonuscommon.BonusCommonModel;
   import alternativa.tanks.models.tank.ITank;
   import alternativa.tanks.models.tank.ITankEventDispatcher;
   import alternativa.tanks.models.tank.ITankEventListener;
   import alternativa.tanks.models.tank.TankData;
   import alternativa.tanks.models.tank.TankEvent;
   import alternativa.tanks.models.tank.TankModel;
   import alternativa.tanks.physics.CollisionGroup;
   import alternativa.tanks.physics.TanksCollisionDetector;
   import alternativa.tanks.services.materialregistry.IMaterialRegistry;
   import alternativa.tanks.services.objectpool.IObjectPoolService;
   import alternativa.tanks.sfx.IGraphicEffect;
   import alternativa.tanks.sfx.ISound3DEffect;
   import alternativa.tanks.sfx.ISpecialEffect;
   import alternativa.tanks.sfx.Sound3D;
   import alternativa.tanks.sfx.Sound3DEffect;
   import alternativa.tanks.sfx.SoundOptions;
   import alternativa.tanks.sound.ISoundManager;
   import alternativa.tanks.sound.SoundManager;
   import alternativa.tanks.utils.objectpool.ObjectPool;
   import alternativa.tanks.vehicles.tanks.Tank;
   import alternativa.tanks.vehicles.tanks.TankSkin;
   import alternativa.utils.DebugPanel;
   import com.alternativaplatform.projects.tanks.client.commons.types.Vector3d;
   import com.alternativaplatform.projects.tanks.client.models.battlefield.BattleBonus;
   import com.alternativaplatform.projects.tanks.client.models.battlefield.BattlefieldModelBase;
   import com.alternativaplatform.projects.tanks.client.models.battlefield.BattlefieldResources;
   import com.alternativaplatform.projects.tanks.client.models.battlefield.BattlefieldSoundScheme;
   import com.alternativaplatform.projects.tanks.client.models.battlefield.IBattlefieldModelBase;
   import controls.SuicideIndicator;
   import flash.display.BitmapData;
   import flash.display.Stage;
   import flash.events.Event;
   import flash.events.KeyboardEvent;
   import flash.geom.Rectangle;
   import flash.geom.Vector3D;
   import flash.media.Sound;
   import flash.media.SoundTransform;
   import flash.net.SharedObject;
   import flash.ui.Keyboard;
   import flash.utils.Dictionary;
   import flash.utils.getTimer;
   import scpacker.gui.GTanksLoaderWindow;
   import scpacker.gui.IGTanksLoader;
   import scpacker.networking.INetworker;
   import scpacker.networking.Network;
   import scpacker.resource.ResourceType;
   import scpacker.resource.ResourceUtil;
   import scpacker.resource.listener.ResourceLoaderListener;
   import scpacker.test.RenderSystem;
   import scpacker.test.anticheat.SpeedHackChecker;
   import scpacker.test.spectator.SpectatorCameraController;
   import specter.utils.Logger;
   
   use namespace altphysics;
   
   public class BattlefieldModel extends BattlefieldModelBase implements IBattlefieldModelBase, IBattleField, IObjectLoadListener, IBonusListener, INetworkListener, IPanelListener, IBodyCollisionPredicate, IDumper, ITankEventListener
   {
      
      private static const MAP_MIPMAP_RESOLUTION:Number = 5.8;
      
      private static const CONSOLE_COMMAND_ID:String = "battle";
      
      private static const PHYSICS_STEP_MILLIS:int = 30;
      
      private static const MAX_FRAMERATE:int = 60;
      
      private static const MIN_FRAMERATE:int = 10;
      
      private static const MAX_FRAME_TIME:int = 200;
      
      private static const ADAPTIVE_FPS_CHANGE_INTERVAL:int = 30;
      
      private static const CAMERA_FLY_TIME:int = 3000;
      
      private static const MAX_TEMPORARY_DECALS:int = 10;
      
      private static const DECAL_FADING_TIME_MS:int = 20000;
      
      private static const _origin3D:Vector3D = new Vector3D();
      
      private static const _direction3D:Vector3D = new Vector3D();
      
[Embed(source="766.png")]
      private static const SNOW_DUST_DATA:Class;
      
[Embed(source="893.png")]
      private static const DUST_DATA:Class;
       
      
      private var objectPoolService:IObjectPoolService;
      
      private var materialRegistry:IMaterialRegistry;
      
      private var modelsRegister:IModelService;
      
      private var adaptiveFrameCounter:int;
      
      private var adaptiveFpsEnabled:Boolean = false;
      
      private var debugPanel:DebugPanel;
      
      private var tankInterface:TankModel;
      
      private var _soundManager:ISoundManager;
      
      public var bfData:BattlefieldData;
      
      private var suicideIndicator:SuicideIndicator;
      
      private var screenSizeSteps:int = 10;
      
      public var screenSize:int;
      
      private var plugins:Vector.<IBattlefieldPlugin>;
      
      private var pluginCount:int;
      
      private var border:ViewportBorder;
      
      private var deltaSec:Number = 0;
      
      private var debugMode:Boolean;
      
      private var doRender:Boolean;
      
      private var physicsTimeStat:TimeStatistics;
      
      private var logicTimeStat:TimeStatistics;
      
      private var fullTimeStat:TimeStatistics;
      
      private var lastError:Error;
      
      private var uiLockCount:int;
      
      private var cameraUnlockCounter:int;
      
      private var activeCameraController:ICameraController;
      
      private var followCameraController:IFollowCameraController;
      
      private var flyCameraController:FlyCameraController;
      
      private var freeCameraController:SpectatorCameraController;
      
      private var cameraPosition:Vector3;
      
      private var cameraAngles:Vector3;
      
      private var startTime:int;
      
      private var logicTime:int;
      
      public var physicsTime:int;
      
      private var a3dRenderTime:int;
      
      private var gui:IBattlefieldGUI;
      
      private var throwDebugError:Boolean;
      
      private var panelUnlockCounter:int;
      
      private var tankExplosionStartPosition:ConsoleVarInt;
      
      private var tankExplosionVolume:ConsoleVarFloat;
      
      private var muteSound:Boolean;
      
      private var speedHackDetector:SpeedHackChecker;
      
      public var spectatorMode:Boolean;
      
      private var renderSystem:RenderSystem;
      
      public var logicUnits:BattleLogicUnits;
      
      private var lastLogicUnitsUpdate:Number;
      
      private var shadows:BattleShadow;
      
      private var dusts:Dust;
      
      private var decalFactory:DecalFactory;
      
      private const temporaryDecals:Queue = new Queue();
      
      private const allDecals:Dictionary = new Dictionary();
      
      public var fadingDecalRenderer:FadingDecalsRenderer;
      
      public var gameMode:IGameMode;
      
      public var shaft_freq:ConsoleVarFloat;
      
      public var shaft_vel:ConsoleVarFloat;
      
      public var shaft_avel:ConsoleVarFloat;
      
      public var objects2tank:Dictionary;
      
      private var lightings:Vector.<ToyLightAnimation>;
      
      public var hidableObjects:HidableGraphicObjects;
      
      private var skyboxRevolver:Object3DRevolver;
      
      public var animatedTracks:Boolean;
      
      private var updatePhysics:Boolean = true;
      
      private var config:Config;
      
      private var collisionDetector:TanksCollisionDetector;
      
      public var toDestroy:Vector.<Object>;
      
      public var blacklist:Vector.<Object>;
      
      private var loadedList:Vector.<String>;
      
      private var triggers:Triggers;
      
      public var messages:BattlefieldMessages;
      
      public var mapResourceId:String;
      
      public var libs:PropLibRegistry;
      
      public function BattlefieldModel()
      {
         this.screenSize = this.screenSizeSteps;
         this.border = new ViewportBorder();
         this.physicsTimeStat = new TimeStatistics();
         this.logicTimeStat = new TimeStatistics();
         this.fullTimeStat = new TimeStatistics();
         this.cameraPosition = new Vector3();
         this.cameraAngles = new Vector3();
         this.tankExplosionStartPosition = new ConsoleVarInt("tankexpl_soffset",0,0,1000);
         this.tankExplosionVolume = new ConsoleVarFloat("tankexpl_svolume",0.4,0,1);
         this.lightings = new Vector.<ToyLightAnimation>();
         this.hidableObjects = new HidableGraphicObjects();
         this.libs = new PropLibRegistry();
         super();
         _interfaces.push(IModel,IBattleField,IBattlefieldModelBase,IObjectLoadListener,IPanelListener);
         this.shaft_freq = new ConsoleVarFloat("shf",0.01,-100,100);
         this.shaft_vel = new ConsoleVarFloat("shv",0.05,-100,100);
         this.shaft_avel = new ConsoleVarFloat("shav",0.2,-100,100);
         this.toDestroy = new Vector.<Object>();
         this.blacklist = new Vector.<Object>();
         this.objectPoolService = IObjectPoolService(Main.osgi.getService(IObjectPoolService));
         this.materialRegistry = IMaterialRegistry(Main.osgi.getService(IMaterialRegistry));
         this.modelsRegister = IModelService(Main.osgi.getService(IModelService));
         this.logicUnits = new BattleLogicUnits();
         ProjectileHitCameraModifier.initVars();
         FollowCameraController.effectsEnabled = true;
         var console:IConsole = IConsole(Main.osgi.getService(IConsole));
         if(console != null)
         {
            console.addCommandHandler("toggle_debug_textures",this.onToggleTextureDebug);
         }
         PanelModel(Main.osgi.getService(IPanel)).panelListeners.push(this);
         this.triggers = new Triggers();
         this.objects2tank = new Dictionary();
      }
      
      public static function copyToVector3D(param1:Vector3, param2:Vector3D) : void
      {
         param2.x = param1.x;
         param2.y = param1.y;
         param2.z = param1.z;
      }
      
      public function bugReportOpened() : void
      {
         this.changeUILockCount(1);
      }
      
      public function bugReportClosed() : void
      {
         this.changeUILockCount(-1);
      }
      
      public function friendsOpened() : void
      {
         this.changeUILockCount(1);
      }
      
      public function friendsClosed() : void
      {
         this.changeUILockCount(-1);
      }
      
      public function settingsOpened() : void
      {
         this.changeUILockCount(1);
      }
      
      public function onCloseGame() : void
      {
         this.changeUILockCount(1);
      }
      
      public function onCloseGameExit() : void
      {
         this.changeUILockCount(-1);
      }
      
      public function settingsCanceled() : void
      {
         this.changeUILockCount(-1);
      }
      
      public function settingsAccepted() : void
      {
         var key:* = undefined;
         var t:TankData = null;
         this.changeUILockCount(-1);
         if(this.bfData == null)
         {
            return;
         }
         var settings:IBattleSettings = this.getBattleSettings();
         if(settings != null)
         {
            this.bfData.skybox.visible = settings.showSkyBox;
            this.adaptiveFPS = settings.adaptiveFPS;
            if(this.bfData.ambientChannel == null && settings.bgSound || this.bfData.ambientChannel != null && !settings.bgSound)
            {
               this.toggleAmbientSound();
            }
            if(settings.fog)
            {
               this.bfData.viewport.enableFog();
            }
            else
            {
               this.bfData.viewport.disableFog();
            }
            if(settings.useSoftParticle)
            {
               this.bfData.viewport.enableSoftParticles();
            }
            else
            {
               this.bfData.viewport.disableSoftParticles();
            }
            this.dusts.enabled = settings.dust;
            this.gameMode.applyChangesBeforeSettings(settings);
            for(key in this.bfData.activeTanks)
            {
               t = key as TankData;
               t.tank.setAnimationTracks(settings.animationTracks);
            }
            this.animatedTracks = settings.animationTracks;
            this.bfData.viewport.enableAmbientShadows(settings.shadowUnderTanks);
         }
      }
      
      public function connect() : void
      {
      }
      
      public function disconnect() : void
      {
         this.removeMainListeners();
         this.removeKeyboardListeners();
         this._soundManager.stopAllSounds();
      }
      
      public function getBattlefieldData() : BattlefieldData
      {
         return this.bfData;
      }
      
      public function initObject(clientObject:ClientObject, battlefieldResources:BattlefieldResources, battlefieldSoundScheme:BattlefieldSoundScheme, idleKickPeriodMsec:int, mapDescriptorResourceId:String, respawnInvulnerabilityPeriodMsec:int, skyboxTextureResourceId:String, spectator:Boolean, gameMode:IGameMode, loadedList:Vector.<String> = null) : void
      {
         var networkService:INetworkService = null;
         var modelService:IModelService = null;
         var dumpService:IDumpService = null;
         try
         {
            this.loadedList = loadedList;
            this.debugMode = Main.osgi.getService(IDebugService) != null;
            this.spectatorMode = spectator;
            this.gameMode = gameMode is DefaultGameModel ? new DayGameMode() : gameMode;
            this.panelUnlockCounter = 2;
            this.throwDebugError = false;
            this.tankInterface = Main.osgi.getService(ITank) as TankModel;
            networkService = Main.osgi.getService(INetworkService) as INetworkService;
            if(networkService != null)
            {
               networkService.addEventListener(this);
            }
            modelService = IModelService(Main.osgi.getService(IModelService));
            this.gui = Main.osgi.getService(IBattlefieldGUI) as IBattlefieldGUI;
            this.bfData = new BattlefieldData();
            this.bfData.bfObject = clientObject;
            this.bfData.guiContainer = (Main.osgi.getService(IMainContainerService) as IMainContainerService).contentLayer;
            this.bfData.respawnInvulnerabilityPeriod = respawnInvulnerabilityPeriodMsec;
            this.bfData.idleKickPeriod = idleKickPeriodMsec;
            if(skyboxTextureResourceId == "skybox_halloween")
            {
               battlefieldSoundScheme.ambientSound = "halloween_sound_id";
            }
            this.initSounds(battlefieldSoundScheme);
            this.mapResourceId = mapDescriptorResourceId;
            this.initPhysicsAndViewport();
            this.initMap(mapDescriptorResourceId,skyboxTextureResourceId);
            this.speedHackDetector = new SpeedHackChecker(this);
            dumpService = IDumpService(Main.osgi.getService(IDumpService));
            if(dumpService != null)
            {
               dumpService.registerDumper(this);
            }
            this.startTime = getTimer();
            this.logicTime = 0;
            this.physicsTime = 0;
            this.a3dRenderTime = 0;
         }
         catch(e:Error)
         {
            (Main.osgi.getService(IConsole) as IConsole).addLine(e.getStackTrace());
         }
      }
      
      public function initBonuses(clientObject:ClientObject, bonuses:Array) : void
      {
         var bonusData:BattleBonus = null;
         if(bonuses == null)
         {
            return;
         }
         for each(bonusData in bonuses)
         {
            this.createBonusAndAttach(clientObject.register,bonusData.id,bonusData.objectId,bonusData.position,bonusData.timeFromAppearing,false,clientObject);
         }
      }
      
      public function addBonus(clientObject:ClientObject, bonusId:String, bonusObjectId:String, position:Vector3d, disappearingTime:int = 21) : void
      {
         this.createBonusAndAttach(clientObject.register,bonusId,bonusObjectId,position,0,true,clientObject,disappearingTime);
      }
      
      public function bonusDropped(clientObject:ClientObject, bonusId:String, bonusObjectId:String, position:Vector3d, timeFromAppearing:int) : void
      {
         var bonus:IBonus = this.bfData.bonuses[bonusId];
         if(bonus == null)
         {
            bonus = this.createBonusAndAttach(clientObject.register,bonusId,bonusObjectId,position,timeFromAppearing,false,clientObject);
            if(bonus == null)
            {
               return;
            }
         }
         bonus.setRestingState(position.x,position.y,position.z);
      }
      
      public function removeBonus(clientObject:ClientObject, bonusId:String) : void
      {
         if(this.bfData == null)
         {
            return;
         }
         var bonus:IBonus = this.bfData.bonuses[bonusId];
         if(bonus != null)
         {
            bonus.setRemovedState();
         }
      }
      
      public function bonusTaken(clientObject:ClientObject, bonusId:String) : void
      {
         var sound:Sound3D = null;
         var position:Vector3 = null;
         if(this.bfData == null)
         {
            return;
         }
         var bonus:IBonus = this.bfData.bonuses[bonusId];
         if(bonus == null)
         {
            Logger.info(LogLevel.LOG_ERROR,"BattlefieldModel::bonusTaken(): bonus not found. Bonus id=" + bonusId);
         }
         else
         {
            bonus.setTakenState();
            if(this.bfData.bonusTakenSound != null)
            {
               sound = Sound3D.create(this.bfData.bonusTakenSound,SoundOptions.nearRadius,SoundOptions.farRadius,SoundOptions.farDelimiter,0.5);
               position = new Vector3();
               bonus.readBonusPosition(position);
               this.addSound3DEffect(Sound3DEffect.create(this.objectPoolService.objectPool,null,position,sound));
            }
         }
      }
      
      public function onBonusDropped(bonus:IBonus) : void
      {
         var position:Vector3 = new Vector3();
         bonus.readBonusPosition(position);
      }
      
      public function onTankCollision(bonus:IBonus) : void
      {
         if(bonus.isFalling())
         {
            this.onBonusDropped(bonus);
         }
         TankModel(Main.osgi.getService(ITank)).mandatoryUpdate();
         this.attemptToTakeBonus(this.bfData.bfObject,bonus.bonusId);
      }
      
      private function attemptToTakeBonus(bfObject:ClientObject, bonusId:String) : void
      {
         var localTankData:TankData = this.tankInterface.getTankData(this.bfData.localUser);
         var json:Object = new Object();
         json.bonus_id = bonusId;
         json.real_tank_position = new Vector3d(localTankData.tank.state.pos.x,localTankData.tank.state.pos.y,localTankData.tank.state.pos.z);
         Network(Main.osgi.getService(INetworker)).send("battle;attempt_to_take_bonus;" + JSON.stringify(json));
      }
      
      public function battleStart(clientObject:ClientObject) : void
      {
         var i:int = 0;
         if(this.plugins != null)
         {
            for(i = 0; i < this.pluginCount; i++)
            {
               IBattlefieldPlugin(this.plugins[i]).startBattle();
            }
         }
      }
      
      public function battleFinish(clientObject:ClientObject) : void
      {
         var key:* = undefined;
         var tankData:* = null;
         var bonus:IBonus = null;
         var i:int = 0;
         this.tankInterface.disableUserControls(true);
         for(tankData in this.bfData.activeTanks)
         {
            tankData.tank.title.hideIndicators();
            this.tankInterface.stop(tankData);
            tankData.enabled = false;
         }
         this.suicideIndicator.visible = false;
         this.tankInterface.resetIdleTimer(true);
         for(key in this.bfData.bonuses)
         {
            bonus = this.bfData.bonuses[key];
            bonus.destroy();
            delete this.bfData.bonuses[key];
         }
         if(this.plugins != null)
         {
            for(i = 0; i < this.pluginCount; i++)
            {
               IBattlefieldPlugin(this.plugins[i]).finishBattle();
            }
         }
      }
      
      public function battleRestart(clientObject:ClientObject) : void
      {
         var key:* = undefined;
         var i:int = 0;
         for(key in this.bfData.activeTanks)
         {
            this.removeTankFromField(key as TankData);
         }
         if(this.plugins != null)
         {
            for(i = 0; i < this.pluginCount; i++)
            {
               IBattlefieldPlugin(this.plugins[i]).restartBattle();
            }
         }
      }
      
      private function onStageResize(e:Event) : void
      {
         if(this.messages != null)
         {
            this.messages.x = 0.5 * Main.stage.stageWidth;
            this.messages.y = 40;
         }
      }
      
      public function objectLoaded(clientObject:ClientObject) : void
      {
         ResourceUtil.addEventListener(function():void
         {
            onResourcesReady(clientObject);
         });
         ResourceUtil.unloadImages(this.loadedList);
      }
      
      private function onResourcesReady(clientObject:ClientObject) : void
      {
         var key:* = undefined;
         var t:TankData = null;
         var prefix:String = !!Game.local ? "" : "resources/";
         this._soundManager = SoundManager.createSoundManager(this.bfData.ambientSound);
         var settings:IBattleSettings = this.getBattleSettings();
         this.muteSound = settings.muteSound;
         if(!this.muteSound && settings.bgSound)
         {
            this.bfData.ambientChannel = this._soundManager.playSound(this.bfData.ambientSound,0,1000000,new SoundTransform(0.5));
         }
         this.addMainListeners();
         this.addKeyboardListeners();
         this.bfData.time = getTimer();
         this.onResize(null);
         var tankEventDispatcher:ITankEventDispatcher = ITankEventDispatcher(Main.osgi.getService(ITankEventDispatcher));
         if(tankEventDispatcher != null)
         {
            tankEventDispatcher.addTankEventListener(TankEvent.KILLED,this);
            tankEventDispatcher.addTankEventListener(TankEvent.SPAWNED,this);
         }
         if(!this.spectatorMode)
         {
            Network(Main.osgi.getService(INetworker)).send("battle;get_init_data_local_tank");
         }
         else
         {
            BattleController.localTankInited = true;
            Network(Main.osgi.getService(INetworker)).send("battle;spectator_user_init");
            this.activateSpectatorCamera();
         }
         if(settings.fog)
         {
            this.bfData.viewport.enableFog();
         }
         else
         {
            this.bfData.viewport.disableFog();
         }
         if(settings.useSoftParticle)
         {
            this.bfData.viewport.enableSoftParticles();
         }
         else
         {
            this.bfData.viewport.disableSoftParticles();
         }
         this.dusts.enabled = settings.dust;
         this.gameMode.applyChangesBeforeSettings(settings);
         for(key in this.bfData.activeTanks)
         {
            t = key as TankData;
            t.tank.setAnimationTracks(settings.animationTracks);
         }
         this.animatedTracks = settings.animationTracks;
         this.bfData.viewport.enableAmbientShadows(settings.shadowUnderTanks);
         this.messages = new BattlefieldMessages(3,18,18);
         Main.contentUILayer.addChild(this.messages);
         Main.stage.addEventListener(Event.RESIZE,this.onStageResize);
         this.onStageResize(null);
         (Main.osgi.getService(IGTanksLoader) as GTanksLoaderWindow).setFullAndClose(null);
      }
      
      public function objectUnloaded(clientObject:ClientObject) : void
      {
         var b:IBonus = null;
         var bgService:IBackgroundService = null;
         var o:* = undefined;
         ResourceLoaderListener.clearListeners(true);
         ResourceUtil.loadImages();
         if(this.bfData == null)
         {
            Logger.info(LogLevel.LOG_ERROR,"BattlefieldModel::objectUnloaded Called more than once");
            return;
         }
         var networkService:INetworkService = INetworkService(Main.osgi.getService(INetworkService));
         if(networkService != null)
         {
            networkService.removeEventListener(this);
         }
         for(var i:int = 0; i < this.toDestroy.length; i++)
         {
            o = this.toDestroy[i];
            if(o != null)
            {
               if(this.blacklist.indexOf(o) == -1)
               {
                  o.destroy(true);
                  o = null;
                  i++;
               }
               else
               {
                  this.toDestroy.removeAt(i);
               }
            }
            if(i >= 200)
            {
               break;
            }
         }
         if(i < 200)
         {
            this.toDestroy = new Vector.<Object>();
         }
         Main.debug.unregisterCommand(CONSOLE_COMMAND_ID);
         this.materialRegistry.clear();
         this.removeMainListeners();
         this.removeKeyboardListeners();
         this._soundManager.stopAllSounds();
         this._soundManager.removeAllEffects();
         this.bfData.viewport.camera.view.clear();
         this.bfData.viewport.camera.view = null;
         this.bfData.viewport.clearContainers();
         this.bfData.guiContainer.removeChild(this.bfData.viewport);
         IFocusService(Main.osgi.getService(IFocusService)).clearFocus(this.bfData.viewport);
         this.bfData.guiContainer.stage.frameRate = MAX_FRAMERATE;
         if(this.freeCameraController != null)
         {
            this.freeCameraController.deactivate();
         }
         Main.contentUILayer.visible = true;
         this.setCameraTarget(null);
         this.debugPanel = null;
         for each(b in this.bfData.bonuses)
         {
            b.destroy();
            b = null;
         }
         this.bfData.collisionDetector.destroy();
         this.bfData.collisionDetector = null;
         this.bfData.physicsScene._staticCD.destroy();
         this.bfData.physicsScene._staticCD = null;
         this.bfData.physicsScene.destroy();
         this.bfData.physicsScene = null;
         this.triggers = new Triggers();
         this.bfData = null;
         this.suicideIndicator = null;
         bgService = IBackgroundService(Main.osgi.getService(IBackgroundService));
         if(bgService != null)
         {
            bgService.drawBg();
         }
         var dumpService:IDumpService = IDumpService(Main.osgi.getService(IDumpService));
         if(dumpService != null)
         {
            dumpService.unregisterDumper(this.dumperName);
         }
         var storageService:IStorageService = IStorageService(Main.osgi.getService(IStorageService));
         storageService.getStorage().data.cameraHeight = this.followCameraController.cameraHeight;
         var tankEventDispatcher:ITankEventDispatcher = ITankEventDispatcher(Main.osgi.getService(ITankEventDispatcher));
         tankEventDispatcher.removeTankEventListener(TankEvent.KILLED,this);
         tankEventDispatcher.removeTankEventListener(TankEvent.SPAWNED,this);
         Main.contentUILayer.removeChild(this.messages);
         Main.stage.removeEventListener(Event.RESIZE,this.onStageResize);
         this.messages = null;
      }
      
      public function addGraphicEffect(effect:IGraphicEffect) : void
      {
         if(effect == null || this.bfData == null)
         {
            return;
         }
         this.bfData.graphicEffects[effect] = true;
         effect.addToContainer(this.bfData.viewport.getMapContainer());
      }
      
      public function addSound3DEffect(effect:ISound3DEffect) : void
      {
         if(effect != null && !this.muteSound)
         {
            this._soundManager.addEffect(effect);
         }
      }
      
      public function setLocalUser(clinetObject:ClientObject) : void
      {
         if(this.bfData == null)
         {
            return;
         }
         this.bfData.localUser = clinetObject;
      }
      
      public function addTank(tankData:TankData) : void
      {
         var i:int = 0;
         this.bfData.tanks[tankData.tank] = tankData;
         if(tankData.enabled)
         {
            Logger.debug("addTankToField()");
         }
         this.addTankToField(tankData);
         if(this.plugins != null)
         {
            for(i = 0; i < this.pluginCount; i++)
            {
               IBattlefieldPlugin(this.plugins[i]).addUser(tankData.user);
            }
         }
         if(tankData.local)
         {
            this.updatePanelUnlockCounter();
         }
      }
      
      public function removeTank(tankData:TankData) : void
      {
         var i:int = 0;
         if(this.bfData == null)
         {
            return;
         }
         if(this.bfData.activeTanks[tankData] != null)
         {
            this.removeTankFromField(tankData);
            delete this.bfData.tanks[tankData.tank];
         }
         if(this.followCameraController.tank == tankData.tank)
         {
            this.followCameraController.deactivate();
            if(this.spectatorMode)
            {
               this.freeCameraController.playerCamera.unfocus();
            }
         }
         if(this.plugins != null)
         {
            for(i = 0; i < this.pluginCount; i++)
            {
               IBattlefieldPlugin(this.plugins[i]).removeUser(tankData.user);
            }
         }
      }
      
      public function onResize(e:Event) : void
      {
         if(this.bfData == null)
         {
            return;
         }
         var scrSize:Number = this.screenSize / this.screenSizeSteps;
         var stage:Stage = this.bfData.guiContainer.stage;
         var w:Number = stage.stageWidth;
         var h:Number = stage.stageHeight;
         var sw:int = w * scrSize;
         var sh:int = h * scrSize;
         this.bfData.viewport.resize(sw,sh);
         this.bfData.viewport.x = 0.5 * (w - sw);
         this.bfData.viewport.y = 0.5 * (h - sh);
         var bgService:IBackgroundService = Main.osgi.getService(IBackgroundService) as IBackgroundService;
         if(bgService != null)
         {
            bgService.drawBg(new Rectangle(0.5 * (w - sw),0.5 * (h - sh),sw,sh));
         }
         this.bfData.viewport.overlay.graphics.clear();
         if(this.screenSize < this.screenSizeSteps)
         {
            this.border.draw(this.bfData.viewport.overlay.graphics,sw,sh);
         }
         this.suicideIndicator.x = sw >> 1;
         this.suicideIndicator.y = sh >> 1;
      }
      
      public function getWidth() : int
      {
         if(this.bfData.viewport.stage == null)
         {
            return 1;
         }
         return this.bfData.viewport.stage.stageWidth * this.screenSize / this.screenSizeSteps;
      }
      
      public function getHeight() : int
      {
         if(this.bfData.viewport.stage == null)
         {
            return 1;
         }
         return this.bfData.viewport.stage.stageHeight * this.screenSize / this.screenSizeSteps;
      }
      
      public function getDiagonalSquared() : Number
      {
         return this.getHeight() * this.getHeight() + this.getWidth() * this.getWidth();
      }
      
      public function getObjectPool() : ObjectPool
      {
         return this.objectPoolService.objectPool;
      }
      
      public function initFlyCamera(pivotPosition:Vector3, targetDirection:Vector3) : void
      {
         if(this.activeCameraController == this.freeCameraController)
         {
            return;
         }
         this.followCameraController.deactivate();
         this.followCameraController.getCameraState(pivotPosition,targetDirection,this.cameraPosition,this.cameraAngles);
         this.flyCameraController.init(this.cameraPosition,this.cameraAngles,CAMERA_FLY_TIME);
         this.activeCameraController = this.flyCameraController;
      }
      
      public function initFollowCamera(pivotPosition:Vector3, targetDirection:Vector3) : void
      {
         this.followCameraController.activate();
         this.followCameraController.setLocked(true);
         this.followCameraController.initByTarget(pivotPosition,targetDirection);
         this.activeCameraController = this.followCameraController;
         this.incCameraUnlockCounter();
      }
      
      public function initCameraController(controller:ICameraController) : void
      {
         this.followCameraController.deactivate();
         this.activeCameraController = controller;
         TankModel(this.tankInterface).lockControls(true);
      }
      
      public function resetFollowCamera() : void
      {
         if(this.bfData != null && this.bfData.viewport != null)
         {
            this.bfData.viewport.camera.rotationY = 0;
            this.followCameraController.initCameraComponents();
         }
      }
      
      public function activateFollowCamera() : void
      {
         this.followCameraController.activate();
         this.followCameraController.setLocked(false);
         this.activeCameraController = this.followCameraController;
         TankModel(this.tankInterface).lockControls(false);
      }
      
      public function activateSpectatorCamera() : void
      {
         if(this.activeCameraController == this.followCameraController)
         {
            this.followCameraController.deactivate();
         }
         this.activeCameraController = this.freeCameraController;
         this.freeCameraController.activate();
         this.freeCameraController.setPositionFromCamera();
         TankModel(this.tankInterface).lockControls(true);
      }
      
      private function toggleFreeCamera() : void
      {
         if(this.activeCameraController != this.freeCameraController)
         {
            if(this.activeCameraController == this.followCameraController)
            {
               this.followCameraController.deactivate();
            }
            this.activeCameraController = this.freeCameraController;
            this.freeCameraController.activate();
            TankModel(this.tankInterface).lockControls(true);
         }
         else
         {
            this.freeCameraController.deactivate();
            this.followCameraController.activate();
            this.followCameraController.setLocked(false);
            this.activeCameraController = this.followCameraController;
            TankModel(this.tankInterface).lockControls(false);
         }
      }
      
      public function setCameraTarget(tank:Tank) : void
      {
         this.followCameraController.tank = tank;
      }
      
      public function showSuicideIndicator(time:int) : void
      {
         this.suicideIndicator.show(time);
      }
      
      public function hideSuicideIndicator() : void
      {
         this.suicideIndicator.visible = false;
      }
      
      public function getRespawnInvulnerabilityPeriod() : int
      {
         return this.getBattlefieldData().respawnInvulnerabilityPeriod;
      }
      
      public function removeTankFromField(tankData:TankData) : void
      {
         var i:int = 0;
         if(this.bfData.activeTanks[tankData] == null)
         {
            return;
         }
         delete this.bfData.activeTanks[tankData];
         tankData.logEvent("Removed from field");
         tankData.tank.removeFromContainer();
         this.bfData.physicsScene.removeBody(tankData.tank);
         this.bfData.collisionDetector.removeBody(tankData.tank);
         this.tankInterface.stop(tankData);
         this._soundManager.removeEffect(tankData.sounds);
         if(this.plugins != null)
         {
            for(i = 0; i < this.pluginCount; i++)
            {
               IBattlefieldPlugin(this.plugins[i]).removeUserFromField(tankData.user);
            }
         }
         if(this.followCameraController.tank == tankData.tank)
         {
            this.followCameraController.deactivate();
         }
      }
      
      public function considerBodies(body1:Body, body2:Body) : Boolean
      {
         var tankData:TankData = null;
         if(body1.postCollisionPredicate != null && body2.postCollisionPredicate == null)
         {
            tankData = this.bfData.tanks[body1];
            ++tankData.tankCollisionCount;
         }
         else if(body1.postCollisionPredicate == null && body2.postCollisionPredicate != null)
         {
            tankData = this.bfData.tanks[body2];
            ++tankData.tankCollisionCount;
         }
         return false;
      }
      
      public function printDebugValue(valueName:String, value:String) : void
      {
         this.debugPanel.printValue(valueName,value);
      }
      
      public function addPlugin(plugin:IBattlefieldPlugin) : void
      {
         if(this.plugins == null)
         {
            this.plugins = new Vector.<IBattlefieldPlugin>();
         }
         if(this.plugins.indexOf(plugin) < 0)
         {
            var _loc2_:* = this.pluginCount++;
            this.plugins[_loc2_] = plugin;
         }
      }
      
      public function removePlugin(plugin:IBattlefieldPlugin) : void
      {
         var idx:int = 0;
         if(this.plugins != null)
         {
            idx = this.plugins.indexOf(plugin);
            if(idx > -1)
            {
               this.plugins.splice(idx,1);
               --this.pluginCount;
            }
         }
      }
      
      public function get soundManager() : ISoundManager
      {
         return this._soundManager;
      }
      
      public function tankHit(tankData:TankData, direction:Vector3, power:Number) : void
      {
      }
      
      public function get dumperName() : String
      {
         return "currbattle";
      }
      
      public function dump(params:Vector.<String>) : String
      {
         var tankData:TankData = null;
         var plugin:IBattlefieldPlugin = null;
         var active:Boolean = false;
         if(this.bfData == null)
         {
            return "";
         }
         var str:String = "=== BattlefieldModel dump ===\n";
         if(this.plugins != null && this.pluginCount > 0)
         {
            str += "Plugins list:\n";
            for each(plugin in this.plugins)
            {
               str += " " + plugin.battlefieldPluginName + "\n";
            }
            str += "End of plugins list\n";
         }
         str += "Tanks list:\n";
         var counter:int = 0;
         for each(tankData in this.bfData.tanks)
         {
            active = this.bfData.activeTanks[tankData] != null;
            str += "--- Tank " + counter++ + " ---\n" + "active=" + active + "\n" + tankData.toString() + "\n";
         }
         str += "End of tanks list\n";
         return str + "=== End BattlefieldModel dump ===\n";
      }
      
      public function handleTankEvent(eventType:int, tankData:TankData) : void
      {
         switch(eventType)
         {
            case TankEvent.SPAWNED:
               this.spawnTank(tankData);
               break;
            case TankEvent.KILLED:
               this.killTank(tankData);
         }
      }
      
      public function addFollowCameraModifier(modifier:ICameraStateModifier) : void
      {
         this.followCameraController.addModifier(modifier);
      }
      
      public function setMuteSound(mute:Boolean) : void
      {
         var settings:IBattleSettings = null;
         var key:* = undefined;
         if(this.bfData == null)
         {
            return;
         }
         this.muteSound = mute;
         if(mute)
         {
            this._soundManager.stopAllSounds();
            this._soundManager.removeAllEffects();
            this.bfData.ambientChannel = null;
         }
         else
         {
            settings = this.getBattleSettings();
            if(settings.bgSound)
            {
               this.bfData.ambientChannel = this._soundManager.playSound(this.bfData.ambientSound,0,1000000,new SoundTransform(0.5));
            }
            for(key in this.bfData.activeTanks)
            {
               this._soundManager.addEffect(TankData(key).sounds);
            }
         }
      }
      
      private function spawnTank(tankData:TankData) : void
      {
         Logger.debug("spawnTank(" + this.bfData.activeTanks[tankData] + ")");
         if(this.bfData.activeTanks[tankData] != null)
         {
            return;
         }
         this.addTankToField(tankData);
         this._soundManager.addEffect(tankData.sounds);
      }
      
      private function killTank(tankData:TankData) : void
      {
         var key:* = undefined;
         var effect:* = null;
         var sound3D:Sound3D = null;
         var turretMesh:Mesh = null;
         this._soundManager.removeEffect(tankData.sounds);
         this._soundManager.killEffectsByOwner(tankData.user);
         for(effect in this.bfData.graphicEffects)
         {
            if(effect.owner == tankData.user)
            {
               effect.kill();
            }
         }
         if(this.bfData.killSound != null)
         {
            sound3D = Sound3D.create(this.bfData.killSound,SoundOptions.nearRadius,SoundOptions.farRadius,SoundOptions.farDelimiter,this.tankExplosionVolume.value);
            turretMesh = tankData.tank.skin.turretMesh;
            this.addSound3DEffect(Sound3DEffect.create(this.objectPoolService.objectPool,null,new Vector3(turretMesh.x,turretMesh.y,turretMesh.z),sound3D,0,this.tankExplosionStartPosition.value));
         }
         if(this.followCameraController.tank == tankData.tank)
         {
            this.followCameraController.setLocked(true);
         }
      }
      
      private function initSounds(battlefieldSoundScheme:BattlefieldSoundScheme) : void
      {
         this.bfData.ambientSound = ResourceUtil.getResource(ResourceType.SOUND,battlefieldSoundScheme.ambientSound).sound as Sound;
         this.bfData.bonusTakenSound = ResourceUtil.getResource(ResourceType.SOUND,"bonusTakenSound").sound as Sound;
         this.bfData.battleFinishSound = ResourceUtil.getResource(ResourceType.SOUND,"battleFinishSound").sound as Sound;
         this.bfData.killSound = ResourceUtil.getResource(ResourceType.SOUND,"killSound").sound as Sound;
      }
      
      private function initPhysicsAndViewport() : void
      {
         var physics:PhysicsScene = new PhysicsScene();
         this.bfData.physicsScene = physics;
         physics.usePrediction = true;
         if(this.gameMode == GameModes.SPACE)
         {
            if(this.mapResourceId == "map_silence_space")
            {
               physics.gravity = new Vector3(0,0,-450);
            }
            else if(this.mapResourceId == "map_satellite")
            {
               physics.gravity = new Vector3(0,0,-450);
            }
            else
            {
               physics.gravity = new Vector3(0,0,-300);
            }
         }
         else
         {
            physics.gravity = new Vector3(0,0,-1000);
         }
         physics.collisionIterations = 3;
         physics.contactIterations = 3;
         physics.maxPenResolutionSpeed = 100;
         physics.allowedPenetration = 5;
         physics.collisionDetector = this.bfData.collisionDetector = new TanksCollisionDetector();
         this.fadingDecalRenderer = new FadingDecalsRenderer(DECAL_FADING_TIME_MS,this);
         this.bfData.viewport = new BattleView3D(this.debugMode,this.bfData.collisionDetector,this);
         this.shadows = new BattleShadow(this.bfData.viewport);
         this.shadows.on();
         this.bfData.guiContainer.addChild(this.bfData.viewport);
         this.dusts = new Dust(this);
         if(this.mapResourceId.indexOf("_winter") != -1)
         {
            this.dusts.init(new SNOW_DUST_DATA().bitmapData,7000,5000,180,0.75,0.15);
         }
         else
         {
            this.dusts.init(new DUST_DATA().bitmapData,7000,5000,180,0.75,0.15);
         }
         this.suicideIndicator = new SuicideIndicator();
         this.bfData.viewport.addChild(this.suicideIndicator);
         Main.stage.focus = this.bfData.viewport;
         this.cameraUnlockCounter = 0;
         this.doRender = false;
         this.debugPanel = new DebugPanel();
         this.debugPanel.visible = false;
         this.followCameraController = new FollowCameraController(Main.stage,this.bfData.collisionDetector,this.bfData.viewport.camera,CollisionGroup.CAMERA);
         this.flyCameraController = new FlyCameraController(this.bfData.viewport.camera);
         this.freeCameraController = new SpectatorCameraController(this.bfData.viewport.camera);
         var settings:IBattleSettings = this.getBattleSettings();
         FollowCameraController(this.followCameraController).setDefaultSettings();
         var storage:IStorageService = Main.osgi.getService(IStorageService) as IStorageService;
         this.screenSize = storage.getStorage().data.screenSize;
         if(this.screenSize == 0)
         {
            this.screenSize = this.screenSizeSteps;
         }
         var cameraHeight:int = storage.getStorage().data.cameraHeight;
         if(cameraHeight != 0)
         {
            this.followCameraController.cameraHeight = cameraHeight;
         }
         this.decalFactory = new DecalFactory(this.bfData.collisionDetector);
         var stage:Stage = this.bfData.guiContainer.stage;
         var w:Number = stage.stageWidth * this.screenSize;
         var h:Number = stage.stageHeight * this.screenSize;
         this.bfData.viewport.resize(w,h);
         Logger.debug("initPhysicsAndViewport()");
      }
      
      public function addTrigger(trigger:Trigger) : void
      {
         this.triggers.add(trigger);
      }
      
      public function removeTrigger(trigger:Trigger) : void
      {
         this.triggers.remove(trigger);
      }
      
      private function initMap(mapResourceId:String, skyboxId:String) : void
      {
         var toLoad:Vector.<String> = new Vector.<String>();
         toLoad.push(skyboxId + "_1");
         toLoad.push(skyboxId + "_2");
         toLoad.push(skyboxId + "_3");
         toLoad.push(skyboxId + "_4");
         toLoad.push(skyboxId + "_5");
         toLoad.push(skyboxId + "_6");
         toLoad.push("bonus_box_details");
         toLoad.push("bonus_box_lightmap");
         ResourceUtil.addEventListener(function():void
         {
            bfData.skybox = createSkyBox(skyboxId);
            bfData.viewport.setSkyBox(bfData.skybox);
            mapResourceId = mapResourceId;
            config = new Config();
            config.load("mapsLibrary.json",mapResourceId);
         });
         ResourceUtil.loadGraphics(toLoad);
      }
      
      public function getConfig() : Config
      {
         return this.config;
      }
      
      public function removeDecal(param1:Decal) : void
      {
         this.bfData.viewport.removeDecal(param1);
      }
      
      public function addDecal(param1:Vector3, param2:Vector3, param3:Number, param4:TextureMaterial, param5:RotationState = null, param6:Boolean = false) : void
      {
         this.bfData.viewport.addDecal(param1,param2,param3,param4,param5,param6);
      }
      
      public function build(mapTree:KDContainer, c:Vector.<CollisionPrimitive>, lights:Vector.<Light3D>, lighting:Vector.<ToyLightAnimation> = null) : void
      {
         this.lightings = lighting;
         this.bfData.viewport._mapContainer = mapTree;
         this.bfData.viewport.initLights(lights);
         this.collisionDetector = TanksCollisionDetector(this.bfData.physicsScene.collisionDetector);
         this.collisionDetector.buildKdTree(c);
         this.onMapBuildingComplete(null);
      }
      
      private function createSkyBox(skyboxId:String) : SkyBox
      {
         var obj:Object = ResourceUtil.getResource(ResourceType.IMAGE,skyboxId + "_1");
         var part1:BitmapData = ResourceUtil.getResource(ResourceType.IMAGE,skyboxId + "_1").bitmapData;
         var part2:BitmapData = ResourceUtil.getResource(ResourceType.IMAGE,skyboxId + "_2").bitmapData;
         var part3:BitmapData = ResourceUtil.getResource(ResourceType.IMAGE,skyboxId + "_3").bitmapData;
         var part4:BitmapData = ResourceUtil.getResource(ResourceType.IMAGE,skyboxId + "_4").bitmapData;
         var part5:BitmapData = ResourceUtil.getResource(ResourceType.IMAGE,skyboxId + "_5").bitmapData;
         var part6:BitmapData = ResourceUtil.getResource(ResourceType.IMAGE,skyboxId + "_6").bitmapData;
         var skyBox:SkyBox = new SkyBox(200000,new TextureMaterial(part1),new TextureMaterial(part2),new TextureMaterial(part3),new TextureMaterial(part4),new TextureMaterial(part5),new TextureMaterial(part6),0);
         this.skyboxRevolver = new Object3DRevolver(skyBox,new Vector3(10,3,0),this.gameMode == GameModes.SPACE ? Number(0.04) : Number(0));
         return skyBox;
      }
      
      public function raycast(param1:Vector3, param2:Vector3, param3:Dictionary, param4:Camera3D = null) : RayIntersectionData
      {
         var _loc6_:Object3D = null;
         copyToVector3D(param1,_origin3D);
         copyToVector3D(param2,_direction3D);
         var _loc5_:RayIntersectionData = this.bfData.viewport._mapContainer.intersectRay(_origin3D,_direction3D,param3,param4);
         if(_loc5_)
         {
            _loc6_ = _loc5_.object;
            while(_loc6_ != null && !_loc6_.mouseEnabled)
            {
               _loc6_ = _loc6_.parent;
            }
            _loc5_.object = _loc6_;
         }
         return _loc5_;
      }
      
      private function onMapBuildingComplete(e:Event) : void
      {
         this.gui = Main.osgi.getService(IBattlefieldGUI) as IBattlefieldGUI;
         this.doRender = true;
         this.incCameraUnlockCounter();
         this.updatePanelUnlockCounter();
         if(this.gameMode != null)
         {
            this.gameMode.applyChanges(this.bfData.viewport);
         }
         this.objectLoaded(null);
      }
      
      private function addMainListeners() : void
      {
         if(this.bfData == null)
         {
            return;
         }
         this.bfData.guiContainer.addEventListener(Event.ENTER_FRAME,this.loop);
         this.bfData.guiContainer.stage.addEventListener(Event.RESIZE,this.onResize);
      }
      
      private function removeMainListeners() : void
      {
         if(this.bfData == null)
         {
            return;
         }
         this.bfData.guiContainer.removeEventListener(Event.ENTER_FRAME,this.loop);
         this.bfData.guiContainer.stage.removeEventListener(Event.RESIZE,this.onResize);
      }
      
      private function addKeyboardListeners() : void
      {
         if(this.bfData == null)
         {
            return;
         }
         this.bfData.guiContainer.stage.addEventListener(KeyboardEvent.KEY_DOWN,this.onKey);
         this.bfData.guiContainer.stage.addEventListener(KeyboardEvent.KEY_UP,this.onKey);
      }
      
      private function removeKeyboardListeners() : void
      {
         if(this.bfData == null)
         {
            return;
         }
         this.bfData.guiContainer.stage.removeEventListener(KeyboardEvent.KEY_DOWN,this.onKey);
         this.bfData.guiContainer.stage.removeEventListener(KeyboardEvent.KEY_UP,this.onKey);
      }
      
      private function updateTimeStat(delta:int, stat:TimeStatistics, timeMessage:String, fpsMessage:String) : void
      {
         stat.timeAccum += delta;
         if(++stat.stepCounter >= stat.numSteps)
         {
            stat.avrgTime = stat.timeAccum / stat.stepCounter;
            stat.avrgFps = 1000 / stat.avrgTime;
            stat.stepCounter = 0;
            stat.timeAccum = 0;
            if(this.debugPanel.visible)
            {
               this.debugPanel.printValue(timeMessage,stat.avrgTime.toFixed(2));
               this.debugPanel.printValue(fpsMessage,stat.avrgFps.toFixed(2));
            }
         }
      }
      
      private function loop(e:Event) : void
      {
         var la:ToyLightAnimation = null;
         var fps:Number = NaN;
         var i:int = 0;
         var runningTime:int = 0;
         var t1:int = getTimer();
         var deltaMsec:int = t1 - this.bfData.time;
         this.bfData.time = t1;
         if(deltaMsec <= 0)
         {
            return;
         }
         this.deltaSec = 0.001 * deltaMsec;
         if(this.adaptiveFpsEnabled)
         {
            if(++this.adaptiveFrameCounter == ADAPTIVE_FPS_CHANGE_INTERVAL)
            {
               this.adaptiveFrameCounter = 0;
               if(this.fullTimeStat.avrgFps < Main.stage.frameRate - 1)
               {
                  Main.stage.frameRate = this.fullTimeStat.avrgFps < MIN_FRAMERATE ? Number(Number(MIN_FRAMERATE)) : Number(Number(this.fullTimeStat.avrgFps));
               }
               else
               {
                  fps = Main.stage.frameRate + 1;
                  Main.stage.frameRate = fps > MAX_FRAMERATE ? Number(Number(MAX_FRAMERATE)) : Number(Number(fps));
               }
               if(this.debugPanel.visible)
               {
                  this.debugPanel.printValue("Stage frame rate",Main.stage.frameRate.toFixed(2));
               }
            }
         }
         t1 = getTimer();
         if(this.updatePhysics)
         {
            this.runPhysics(PHYSICS_STEP_MILLIS);
         }
         var t2:int = getTimer();
         this.physicsTime += t2 - t1;
         t1 = t2;
         if(this.activeCameraController != null)
         {
            this.activeCameraController.update(this.bfData.time,deltaMsec);
         }
         this.bfData.viewport.camera.calculateAdditionalData();
         var t:Number = 1 - (this.bfData.physTime - this.bfData.time) / PHYSICS_STEP_MILLIS;
         this.updateTanks(this.bfData.time,deltaMsec,this.deltaSec,t);
         if(this.plugins != null)
         {
            for(i = 0; i < this.pluginCount; i++)
            {
               IBattlefieldPlugin(this.plugins[i]).tick(this.bfData.time,deltaMsec,this.deltaSec,t);
            }
         }
         for each(la in this.lightings)
         {
            la.update();
         }
         this.lastLogicUnitsUpdate = this.bfData.physTime - this.lastLogicUnitsUpdate;
         this.logicUnits.update(this.bfData.physTime,deltaMsec);
         this.fadingDecalRenderer.render(getTimer(),deltaMsec);
         if(this.hidableObjects.isEnabled())
         {
            this.hidableObjects.render(getTimer(),deltaMsec);
         }
         if(this.skyboxRevolver != null)
         {
            this.skyboxRevolver.render(this.bfData.physTime,deltaMsec);
         }
         this.playSpecialEffects(deltaMsec);
         this.updateBonuses(this.bfData.time,deltaMsec,t);
         deltaMsec = getTimer() - this.bfData.time;
         t2 = getTimer();
         this.logicTime += t2 - t1;
         t1 = t2;
         if(this.doRender)
         {
            this.bfData.viewport.update();
         }
         this.dusts.update();
         if(this.debugPanel.visible)
         {
            runningTime = getTimer() - this.startTime;
            this.debugPanel.printValue("Running time",runningTime);
            this.debugPanel.printValue("Physics time",this.physicsTime,":",Number(this.physicsTime / runningTime).toFixed(4));
            this.debugPanel.printValue("Logic time",this.logicTime,":",Number(this.logicTime / runningTime).toFixed(4));
            this.debugPanel.printValue("A3D render time",this.a3dRenderTime,":",Number(this.a3dRenderTime / runningTime).toFixed(4));
         }
         this.messages.update(deltaMsec * 10);
      }
      
      private function onAlertButtonPressed(e:Event) : void
      {
         var spaceService:ISpaceService = null;
         var panelObjectId:String = null;
         var spaceInfo:SpaceInfo = null;
         if(this.debugMode)
         {
            spaceService = ISpaceService(Main.osgi.getService(ISpaceService));
            panelObjectId = "aaa";
            spaceInfo = spaceService.getSpaceByObjectId(panelObjectId);
         }
         var addressService:IAddressService = IAddressService(Main.osgi.getService(IAddressService));
         if(addressService != null)
         {
            addressService.reload();
         }
      }
      
      private function runPhysics(dt:int) : void
      {
         var key:* = undefined;
         var tankData:* = null;
         var time:int = 0;
         if(this.bfData.time - this.bfData.physTime > MAX_FRAME_TIME)
         {
            this.bfData.physTime = this.bfData.time - MAX_FRAME_TIME;
         }
         if(this.bfData.physTime < this.bfData.time)
         {
            for(tankData in this.bfData.activeTanks)
            {
               tankData.tankCollisionCount = 0;
            }
            while(this.bfData.physTime < this.bfData.time)
            {
               time = getTimer();
               this.bfData.physicsScene.update(dt);
               this.bfData.physTime += dt;
               this.updateTimeStat(getTimer() - time,this.physicsTimeStat,"Physics avrg time","Physics avrg fps");
               if(TankData.localTankData != null && TankData.localTankData.tank != null)
               {
                  this.triggers.check(TankData.localTankData.tank);
               }
            }
         }
      }
      
      private function updateTanks(time:int, deltaMillis:int, deltaSec:Number, t:Number) : void
      {
         var key:* = undefined;
         var localTankData:TankData = null;
         var camPos:Vector3 = this.bfData.viewport.camera.pos;
         for(key in this.bfData.activeTanks)
         {
            this.tankInterface.update(key as TankData,time,deltaMillis,deltaSec,t,camPos);
         }
         if(this.bfData.localUser != null)
         {
            localTankData = this.tankInterface.getTankData(this.bfData.localUser);
            if(this.bfData.activeTanks[localTankData] == null)
            {
               this.tankInterface.update(localTankData,time,deltaMillis,deltaSec,t,camPos);
            }
         }
      }
      
      private function playSpecialEffects(dt:int) : void
      {
         var camera:GameCamera = this.bfData.viewport.camera;
		 var effect:ISpecialEffect;
         for(var key:* in this.bfData.graphicEffects)
         {
			effect = key;
            if(!effect.play(dt,camera))
            {
               effect.destroy();
               delete this.bfData.graphicEffects[key];
            }
         }
         if(!this.muteSound)
         {
            this._soundManager.updateSoundEffects(dt,camera);
         }
      }
      
      private function updateBonuses(time:int, dt:int, t:Number) : void
      {
         var key:* = undefined;
         var bonus:IBonus = null;
         for(key in this.bfData.bonuses)
         {
            bonus = this.bfData.bonuses[key];
            if(!bonus.update(time,dt,t))
            {
               bonus.destroy();
               delete this.bfData.bonuses[key];
            }
         }
      }
      
      private function addTankToField(tankData:TankData) : void
      {
         var skin:TankSkin = null;
         var i:int = 0;
         Logger.debug("addTankToField()");
         try
         {
            if(this.bfData.activeTanks[tankData] != null)
            {
               return;
            }
            this.bfData.activeTanks[tankData] = true;
            tankData.tank.addToContainer(this.bfData.viewport.getMapContainer());
            tankData.tank.updateSkin(1);
            tankData.tank.setAnimationTracks(this.animatedTracks);
            tankData.logEvent("Added to field");
            this.bfData.physicsScene.addBody(tankData.tank);
            this.bfData.collisionDetector.addBody(tankData.tank);
            this._soundManager.addEffect(tankData.sounds);
            if(this.plugins != null)
            {
               for(i = 0; i < this.pluginCount; i++)
               {
                  IBattlefieldPlugin(this.plugins[i]).addUserToField(tankData.user);
               }
            }
            if(tankData.tank == this.followCameraController.tank && this.activeCameraController != this.freeCameraController)
            {
               this.followCameraController.activate();
               this.followCameraController.setLocked(false);
               this.followCameraController.initCameraComponents();
               this.activeCameraController = this.followCameraController;
            }
            this.dusts.addTank(tankData);
            skin = tankData.tank.skin;
            this.objects2tank[skin.turretMesh] = tankData.tank;
            this.objects2tank[skin.hullMesh] = tankData.tank;
            Logger.debug("addTankToField() passed");
         }
         catch(e:Error)
         {
            (Main.osgi.getService(IConsole) as IConsole).addLine(e.getStackTrace());
            Logger.warn("addTankToField() failed: " + e.getStackTrace());
         }
      }
      
      private function onKey(e:KeyboardEvent) : void
      {
         this.tankInterface.resetIdleTimer(false);
         if(e.type == KeyboardEvent.KEY_DOWN)
         {
            this.handleKeyDown(e);
         }
      }
      
      public function cheatDetected() : void
      {
         Network(Main.osgi.getService(INetworker)).send("battle;speedhack_detected");
      }
      
      private function handleKeyDown(e:KeyboardEvent) : void
      {
         var tankData:TankData = null;
         var camera:Camera3D = null;
         switch(e.keyCode)
         {
            case Keyboard.F5:
               this.toggleTextureDebug();
               break;
            case Keyboard.F6:
               FollowCameraController.effectsEnabled = !FollowCameraController.effectsEnabled;
               this.gui.logUserAction(null,"Camera effects " + (!!FollowCameraController.effectsEnabled ? "enabled" : "disabled"));
               break;
            case Keyboard.NUMPAD_ADD:
            case 187:
               this.setScreenSize(this.screenSize + 1);
               break;
            case Keyboard.NUMPAD_SUBTRACT:
            case 189:
               this.setScreenSize(this.screenSize - 1);
               break;
            case 66:
               if(this.debugMode)
               {
                  if(e.ctrlKey && this.bfData != null)
                  {
                     for each(tankData in this.bfData.tanks)
                     {
                        tankData.tank.showCollisionGeometry = !tankData.tank.showCollisionGeometry;
                     }
                     camera = this.bfData.viewport.camera;
                     camera.debug = !camera.debug;
                  }
               }
         }
      }
      
      public function isEnableDamageUpEffect() : Boolean
      {
         return this.getBattleSettings().animationDamage;
      }
      
      private function toggleTextureDebug() : Boolean
      {
         var storage:SharedObject = IStorageService(Main.osgi.getService(IStorageService)).getStorage();
         var textureDebug:Boolean = storage.data.textureDebug1;
         storage.data.textureDebug1 = !textureDebug;
         storage.flush();
         return !textureDebug;
      }
      
      private function toggleAmbientSound() : void
      {
         if(this.bfData.ambientChannel != null)
         {
            this._soundManager.stopSound(this.bfData.ambientChannel);
            this.bfData.ambientChannel = null;
         }
         else
         {
            this.bfData.ambientChannel = this._soundManager.playSound(this.bfData.ambientSound,0,100000,new SoundTransform(0.5));
         }
      }
      
      private function setScreenSize(size:int) : void
      {
         this.screenSize = size > this.screenSizeSteps ? int(int(this.screenSizeSteps)) : (size < 1 ? int(int(1)) : int(int(size)));
         var storage:IStorageService = Main.osgi.getService(IStorageService) as IStorageService;
         storage.getStorage().data.screenSize = this.screenSize;
         this.onResize(null);
      }
      
      private function createBonusAndAttach(objectRegister:ObjectRegister, bonusId:String, bonusObjectId:String, position:Vector3d, livingTime:int, isFalling:Boolean, clientObject:ClientObject, disappearingTime:int = 21) : IBonus
      {
         var bonusObject:ClientObject = clientObject;
         if(bonusObject == null)
         {
            return null;
         }
         var bonusModel:BonusCommonModel = new BonusCommonModel();
         bonusModel.initObject(clientObject,"bonus_box_" + bonusId.split("_")[0],"cords",disappearingTime,"parachute_inner","parachute");
         var bonus:IBonus = bonusModel.getBonus(bonusObject,bonusId,livingTime,isFalling);
         if(this.bfData == null || this.bfData.bonuses == null)
         {
            bonus.destroy();
            return null;
         }
         this.bfData.bonuses[bonus.bonusId] = bonus;
         bonus.attach(new Vector3(position.x,position.y,position.z),this.bfData.physicsScene,this.bfData.viewport.getMapContainer(),this);
         return bonus;
      }
      
      private function set adaptiveFPS(value:Boolean) : void
      {
         if(this.adaptiveFpsEnabled == value)
         {
            return;
         }
         this.adaptiveFpsEnabled = value;
         if(!this.adaptiveFpsEnabled)
         {
            this.bfData.guiContainer.stage.frameRate = MAX_FRAMERATE;
         }
      }
      
      private function getBattleSettings() : IBattleSettings
      {
         return IBattleSettings(Main.osgi.getService(IBattleSettings));
      }
      
      private function changeUILockCount(delta:int) : void
      {
         this.uiLockCount += delta;
         if(this.uiLockCount < 0)
         {
            this.uiLockCount = 0;
         }
      }
      
      private function incCameraUnlockCounter() : void
      {
         this.cameraUnlockCounter += 1;
         if(this.cameraUnlockCounter == 2)
         {
            this.doRender = true;
         }
      }
      
      private function updatePanelUnlockCounter() : void
      {
         var modelService:IModelService = null;
         var panelModel:IPanel = null;
         if(this.panelUnlockCounter == 0)
         {
            return;
         }
         --this.panelUnlockCounter;
         if(this.panelUnlockCounter == 0)
         {
            modelService = IModelService(Main.osgi.getService(IModelService));
            panelModel = IPanel(modelService.getModelsByInterface(IPanel)[0]);
            panelModel.partSelected(4);
         }
      }
      
      private function onToggleTextureDebug(console:IConsole, params:Array) : void
      {
         if(this.toggleTextureDebug())
         {
            console.addLine("Debug textures enabled");
         }
         else
         {
            console.addLine("Debug textures disabled");
         }
      }
   }
}

class TimeStatistics
{
    
   
   public var timeAccum:Number = 0;
   
   public var stepCounter:int;
   
   public var numSteps:int = 10;
   
   public var avrgTime:Number = 0;
   
   public var avrgFps:Number = 100;
   
   function TimeStatistics()
   {
      super();
   }
}
