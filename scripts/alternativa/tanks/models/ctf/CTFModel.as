package alternativa.tanks.models.ctf
{
   import alternativa.engine3d.core.Object3D;
   import alternativa.engine3d.materials.TextureMaterial;
   import alternativa.engine3d.objects.BSP;
   import alternativa.engine3d.objects.Mesh;
   import alternativa.init.Main;
   import alternativa.math.Vector3;
   import alternativa.model.IModel;
   import alternativa.model.IObjectLoadListener;
   import alternativa.object.ClientObject;
   import alternativa.osgi.service.dump.IDumpService;
   import alternativa.osgi.service.dump.dumper.IDumper;
   import alternativa.osgi.service.locale.ILocaleService;
   import alternativa.osgi.service.log.LogLevel;
   import alternativa.physics.Body;
   import alternativa.physics.CollisionPrimitiveListItem;
   import alternativa.physics.altphysics;
   import alternativa.physics.collision.CollisionPrimitive;
   import alternativa.register.ObjectRegister;
   import alternativa.resource.SoundResource;
   import alternativa.resource.StubBitmapData;
   import alternativa.service.IModelService;
   import alternativa.service.IResourceService;
   import alternativa.service.Logger;
   import alternativa.tanks.engine3d.MaterialSequence;
   import alternativa.tanks.engine3d.MaterialType;
   import alternativa.tanks.locale.constants.TextConst;
   import alternativa.tanks.models.battlefield.BattlefieldData;
   import alternativa.tanks.models.battlefield.BattlefieldMessages;
   import alternativa.tanks.models.battlefield.BattlefieldModel;
   import alternativa.tanks.models.battlefield.IBattleField;
   import alternativa.tanks.models.battlefield.IBattlefieldPlugin;
   import alternativa.tanks.models.battlefield.gui.IBattlefieldGUI;
   import alternativa.tanks.models.tank.ITank;
   import alternativa.tanks.models.tank.TankData;
   import alternativa.tanks.services.materialregistry.IMaterialRegistry;
   import alternativa.types.Long;
   import com.alternativaplatform.projects.tanks.client.commons.types.Vector3d;
   import com.alternativaplatform.projects.tanks.client.models.ctf.CaptureTheFlagModelBase;
   import com.alternativaplatform.projects.tanks.client.models.ctf.CaptureTheFlagSoundFX;
   import com.alternativaplatform.projects.tanks.client.models.ctf.ClientFlag;
   import com.alternativaplatform.projects.tanks.client.models.ctf.FlagsState;
   import com.alternativaplatform.projects.tanks.client.models.ctf.ICaptureTheFlagModelBase;
   import com.alternativaplatform.projects.tanks.client.models.tank.TankSpawnState;
   import com.reygazu.anticheat.variables.SecureInt;
   import flash.display.BitmapData;
   import flash.events.Event;
   import flash.events.KeyboardEvent;
   import flash.media.Sound;
   import flash.utils.Dictionary;
   import flash.utils.getTimer;
   import projects.tanks.client.battleservice.model.team.BattleTeamType;
   import scpacker.networking.INetworker;
   import scpacker.networking.Network;
   import scpacker.resource.ResourceType;
   import scpacker.resource.ResourceUtil;
   
   use namespace altphysics;
   
   public class CTFModel extends CaptureTheFlagModelBase implements ICaptureTheFlagModelBase, ICTFModel, IObjectLoadListener, IBattlefieldPlugin, IDumper
   {
      
      private static const FLAG_MIPMAP_RESOLUTION:Number = 2.5;
      
      private static var materialRegistry:IMaterialRegistry;
      
      public static const COLOR_RED:uint = 15741974;
      
      public static const COLOR_BLUE:uint = 4691967;
      
      public static const COLOR_POSITIVE:uint = 65280;
      
      public static const COLOR_NEGATIVE:uint = 16776960;
      
      private static var FLAG_LOCK_DURATION:SecureInt = new SecureInt("FLAG_LOCK_DURATION");
       
      
      private const FLAG_FRAME_WIDTH:int = 85;
      
      private const FLAG_FRAME_HEIGHT:int = 176;
      
      private const KEY_DROP_FLAG:uint = 70;
      
      private var dropCommandSent:Boolean;
      
      private var flagLockTime:SecureInt;
      
      private var guiModel:IBattlefieldGUI;
      
      private var battlefieldModel:BattlefieldModel;
      
      private var tankModel:ITank;
      
      private var bfData:BattlefieldData;
      
      private var flags:Dictionary;
      
      private var userTankData:TankData;
      
      private var ctfMessages:BattlefieldMessages;
      
      private var messages:Object;
      
      private const MESSAGE_TAKEN:String = "taken";
      
      private const MESSAGE_LOST:String = "lost";
      
      private const MESSAGE_RETURNED:String = "returned";
      
      private const MESSAGE_CAPTURED:String = "captured";
      
      private var ourFlagReturnedMessage:String;
      
      private var enemyFlagReturnedMessage:String;
      
      private var flagDropSound:Sound;
      
      private var flagReturnSound:Sound;
      
      private var flagTakeSound:Sound;
      
      private var winSound:Sound;
      
      private var pos:Vector3;
      
      private var pos3d:Vector3d;
      
      private var posRedFlag:Vector3;
      
      private var posBlueFlag:Vector3;
      
      private var locale:ILocaleService;
      
      public function CTFModel()
      {
         this.flagLockTime = new SecureInt("flagLockTime");
         this.pos = new Vector3();
         this.pos3d = new Vector3d(0,0,0);
         super();
         FLAG_LOCK_DURATION.value = 5000;
         _interfaces.push(IModel,ICaptureTheFlagModelBase,IObjectLoadListener,ICTFModel);
      }
      
      public function initObject(clientObject:ClientObject, blueFlagModelPedestalId:String, blueFlagTexturePedestalId:String, blueFlagTextureId:String, redFlagModelPedestalId:String, redFlagTexturePedestalId:String, redFlagTextureId:String, sounds:CaptureTheFlagSoundFX, posBlueFlag:Vector3, posRedFlag:Vector3) : void
      {
         materialRegistry = IMaterialRegistry(Main.osgi.getService(IMaterialRegistry));
         var redFlagData:FlagData = new FlagData(redFlagTextureId,redFlagModelPedestalId,redFlagTexturePedestalId);
         var blueFlagData:FlagData = new FlagData(blueFlagTextureId,blueFlagModelPedestalId,blueFlagTexturePedestalId);
         clientObject.putParams(CTFModel,new InitParams(redFlagData,blueFlagData));
         this.flagDropSound = ResourceUtil.getResource(ResourceType.SOUND,"flagDropSound").sound;
         this.flagReturnSound = ResourceUtil.getResource(ResourceType.SOUND,"flagReturnSound").sound;
         this.flagTakeSound = ResourceUtil.getResource(ResourceType.SOUND,"flagTakeSound").sound;
         this.winSound = ResourceUtil.getResource(ResourceType.SOUND,"winSound").sound;
         this.initMessages();
         this.posBlueFlag = posBlueFlag;
         this.posRedFlag = posRedFlag;
         this.objectLoaded(null);
         var dumpService:IDumpService = IDumpService(Main.osgi.getService(IDumpService));
         if(dumpService != null)
         {
            dumpService.registerDumper(this);
         }
      }
      
      public function initFlagsState(clientObject:ClientObject, state:FlagsState) : void
      {
         if(state == null)
         {
            Logger.log(LogLevel.LOG_ERROR,"CTFModel::initFlagsState Null state received");
            throw new ArgumentError("State cannot be null");
         }
         if(this.flags != null)
         {
            Logger.log(LogLevel.LOG_ERROR,"CTFModel::initFlagsState Called more than once");
            return;
         }
         var initParams:InitParams = InitParams(clientObject.removeParams(CTFModel));
         if(initParams == null)
         {
            Logger.log(LogLevel.LOG_ERROR,"CTFModel::initFlagsState Init params not found");
            return;
         }
         this.flags = new Dictionary();
         this.initFlag(BattleTeamType.BLUE,state.blueFlag,initParams.blueFlagData);
         this.initFlag(BattleTeamType.RED,state.redFlag,initParams.redFlagData);
      }
      
      public function objectLoaded(clientObject:ClientObject) : void
      {
         var modelService:IModelService = IModelService(Main.osgi.getService(IModelService));
         this.guiModel = Main.osgi.getService(IBattlefieldGUI) as IBattlefieldGUI;
         this.battlefieldModel = BattlefieldModel(Main.osgi.getService(IBattleField));
         this.battlefieldModel.addPlugin(this);
         this.bfData = this.battlefieldModel.getBattlefieldData();
         this.tankModel = ITank(modelService.getModelsByInterface(ITank)[0]);
         this.ctfMessages = this.battlefieldModel.messages;
         Main.stage.addEventListener(KeyboardEvent.KEY_DOWN,this.onKey);
      }
      
      public function objectUnloaded(clientObject:ClientObject) : void
      {
         var flag:CTFFlag = null;
         var dumpService:IDumpService = IDumpService(Main.osgi.getService(IDumpService));
         if(dumpService != null)
         {
            dumpService.unregisterDumper(this.dumperName);
         }
         Main.stage.removeEventListener(KeyboardEvent.KEY_DOWN,this.onKey);
         if(this.flags != null)
         {
            for each(flag in this.flags)
            {
               flag.dispose();
            }
            this.flags = null;
         }
         this.battlefieldModel.removePlugin(this);
         this.guiModel = null;
         this.battlefieldModel = null;
         this.bfData = null;
         this.userTankData = null;
      }
      
      public function flagTaken(clientObject:ClientObject, tankId:String, flagTeam:BattleTeamType) : void
      {
         var flagMessage:FlagMessage = null;
         var msg:String = null;
         if(this.flags == null)
         {
            Logger.log(LogLevel.LOG_ERROR,"CTFModel::flagTaken() flags are not initialized");
            return;
         }
         var flag:CTFFlag = this.flags[flagTeam];
         var carrierData:TankData = this.getTankData(tankId,null);
         flag.setCarrier(tankId,carrierData);
         if(this.guiModel != null)
         {
            if(this.userTankData != null)
            {
               flagMessage = this.getFlagMessage(this.MESSAGE_TAKEN,this.userTankData.teamType != flagTeam);
               if(carrierData != null)
               {
                  this.ctfMessages.addMessage(flagMessage.color,carrierData.userName + " " + flagMessage.text);
               }
               this.guiModel.logUserAction(tankId,flagMessage.text);
            }
            else if(this.battlefieldModel.spectatorMode)
            {
               if(carrierData != null)
               {
                  msg = this.locale.getText(TextConst.CTF_GOT_FLAG);
                  switch(carrierData.teamType)
                  {
                     case BattleTeamType.RED:
                        this.ctfMessages.addMessage(COLOR_RED,carrierData.userName + " " + msg);
                        break;
                     case BattleTeamType.BLUE:
                        this.ctfMessages.addMessage(COLOR_BLUE,carrierData.userName + " " + msg);
                        break;
                     case BattleTeamType.NONE:
                        this.ctfMessages.addMessage(COLOR_NEGATIVE,carrierData.userName + " " + msg);
                  }
                  this.guiModel.logUserAction(tankId,msg);
               }
            }
            this.battlefieldModel.soundManager.playSound(this.flagTakeSound,0,1);
         }
         this.guiModel.ctfShowFlagCarried(flagTeam);
         flag.takeCommandSent = false;
         CTFFlag(this.flags[flagTeam == BattleTeamType.RED ? BattleTeamType.BLUE : BattleTeamType.RED]).takeCommandSent = false;
      }
      
      public function returnFlagToBase(param1:ClientObject, param2:BattleTeamType, param3:String) : void
      {
         var _loc4_:FlagMessage = null;
         var _loc5_:String = null;
         var _loc6_:TankData = null;
         this.returnFlag(param2);
         if(this.userTankData != null)
         {
            _loc4_ = this.getFlagMessage(this.MESSAGE_RETURNED,this.userTankData.teamType == param2);
            if(param3 == null || param3 == "null")
            {
               _loc5_ = this.userTankData.teamType == param2 ? this.ourFlagReturnedMessage : this.enemyFlagReturnedMessage;
               this.ctfMessages.addMessage(_loc4_.color,_loc5_);
               this.guiModel.logAction(_loc5_);
            }
            else
            {
               _loc6_ = this.getTankData(param3,null);
               if(_loc6_ != null)
               {
                  this.ctfMessages.addMessage(_loc4_.color,_loc6_.userName + " " + _loc4_.text);
                  this.guiModel.logUserAction(param3,_loc4_.text);
               }
            }
         }
         else if(this.battlefieldModel.spectatorMode)
         {
            if(param3 == null || param3 == "null")
            {
               if(param2 == BattleTeamType.RED)
               {
                  _loc5_ = this.locale.getText(TextConst.CTF_RED_FLAG_RETURNED);
                  this.ctfMessages.addMessage(COLOR_RED,_loc5_);
               }
               else
               {
                  _loc5_ = this.locale.getText(TextConst.CTF_BLUE_FLAG_RETURNED);
                  this.ctfMessages.addMessage(COLOR_BLUE,_loc5_);
               }
               this.guiModel.logAction(_loc5_);
            }
            else
            {
               _loc6_ = this.getTankData(param3,null);
               if(_loc6_ != null)
               {
                  _loc5_ = this.locale.getText(TextConst.CTF_RETURNED_FLAG);
                  switch(_loc6_.teamType)
                  {
                     case BattleTeamType.RED:
                        this.ctfMessages.addMessage(COLOR_RED,_loc6_.userName + " " + _loc5_);
                        break;
                     case BattleTeamType.BLUE:
                        this.ctfMessages.addMessage(COLOR_BLUE,_loc6_.userName + " " + _loc5_);
                        break;
                     case BattleTeamType.NONE:
                        this.ctfMessages.addMessage(COLOR_NEGATIVE,_loc6_.userName + " " + _loc5_);
                  }
                  this.guiModel.logUserAction(param3,_loc5_);
               }
            }
         }
         this.battlefieldModel.soundManager.playSound(this.flagReturnSound,0,1);
      }
      
      public function dropFlag(clientObject:ClientObject, position:Vector3d, flagTeam:BattleTeamType) : void
      {
         var flagMessage:FlagMessage = null;
         var msg:String = null;
         if(this.flags == null)
         {
            Logger.log(LogLevel.LOG_ERROR,"CTFModel::flagTaken flags are not initialized");
            return;
         }
         var flag:CTFFlag = this.flags[flagTeam];
         if(this.guiModel != null && flag.carrierData != null)
         {
            if(this.userTankData != null)
            {
               flagMessage = this.getFlagMessage(this.MESSAGE_LOST,this.userTankData.teamType == flagTeam);
               this.ctfMessages.addMessage(flagMessage.color,flag.carrierData.userName + " " + flagMessage.text);
               this.guiModel.logUserAction(flag.carrierId,flagMessage.text);
            }
            else if(this.battlefieldModel.spectatorMode)
            {
               msg = this.locale.getText(TextConst.CTF_LOST_FLAG);
               switch(flag.carrierData.teamType)
               {
                  case BattleTeamType.RED:
                     this.ctfMessages.addMessage(COLOR_RED,flag.carrierData.userName + " " + msg);
                     break;
                  case BattleTeamType.BLUE:
                     this.ctfMessages.addMessage(COLOR_BLUE,flag.carrierData.userName + " " + msg);
                     break;
                  case BattleTeamType.NONE:
                     this.ctfMessages.addMessage(COLOR_NEGATIVE,flag.carrierData.userName + " " + msg);
               }
               this.guiModel.logUserAction(flag.carrierData.userName,msg);
            }
            this.battlefieldModel.soundManager.playSound(this.flagDropSound,0,1);
            if(flag.carrierData == this.userTankData && this.dropCommandSent)
            {
               this.dropCommandSent = false;
               this.flagLockTime.value = getTimer() + FLAG_LOCK_DURATION.value;
            }
         }
         this.pos.x = position.x;
         this.pos.y = position.y;
         this.pos.z = position.z;
         flag.dropAt(this.pos,this.bfData.collisionDetector);
         this.guiModel.ctfShowFlagDropped(flagTeam);
      }
      
      public function flagDelivered(clientObject:ClientObject, winnerTeam:BattleTeamType, delivererTankId:String) : void
      {
         var flagMessage:FlagMessage = null;
         var msg:String = null;
         if(this.flags == null)
         {
            Logger.log(LogLevel.LOG_ERROR,"CTFModel::flagTaken flags are not initialized");
            return;
         }
         var otherTeam:BattleTeamType = winnerTeam == BattleTeamType.RED ? BattleTeamType.BLUE : BattleTeamType.RED;
         this.returnFlag(otherTeam);
         var delivererData:TankData = this.getTankData(delivererTankId,null);
         if(delivererData != null)
         {
            if(this.userTankData != null)
            {
               flagMessage = this.getFlagMessage(this.MESSAGE_CAPTURED,this.userTankData.teamType == winnerTeam);
               this.ctfMessages.addMessage(flagMessage.color,delivererData.userName + " " + flagMessage.text);
               this.guiModel.logUserAction(delivererTankId,flagMessage.text);
            }
            else if(this.battlefieldModel.spectatorMode)
            {
               msg = this.locale.getText(TextConst.CTF_CAPTURED_FLAG);
               switch(delivererData.teamType)
               {
                  case BattleTeamType.RED:
                     this.ctfMessages.addMessage(COLOR_RED,delivererData.userName + " " + msg);
                     break;
                  case BattleTeamType.BLUE:
                     this.ctfMessages.addMessage(COLOR_BLUE,delivererData.userName + " " + msg);
                     break;
                  case BattleTeamType.NONE:
                     this.ctfMessages.addMessage(COLOR_NEGATIVE,delivererData.userName + " " + msg);
               }
               this.guiModel.logUserAction(delivererTankId,msg);
            }
            this.battlefieldModel.soundManager.playSound(this.winSound,0,1);
         }
      }
      
      public function get battlefieldPluginName() : String
      {
         return "Capture The Flag";
      }
      
      public function startBattle() : void
      {
      }
      
      public function restartBattle() : void
      {
         this.returnFlag(BattleTeamType.BLUE);
         this.returnFlag(BattleTeamType.RED);
      }
      
      public function finishBattle() : void
      {
         this.dropCommandSent = false;
      }
      
      public function tick(time:int, deltaMsec:int, deltaSec:Number, interpolationCoeff:Number) : void
      {
         var flag:CTFFlag = null;
         var userTeamFlag:CTFFlag = null;
         var otherTeamFlag:CTFFlag = null;
         if(this.flags == null)
         {
            return;
         }
         if(this.userTankData != null && this.userTankData.enabled)
         {
            userTeamFlag = this.flags[this.userTankData.teamType];
            otherTeamFlag = this.flags[this.userTankData.teamType == BattleTeamType.RED ? BattleTeamType.BLUE : BattleTeamType.RED];
            if(otherTeamFlag.state != CTFFlagState.CARRIED && time > this.flagLockTime.value)
            {
               this.testFlagIntersection(otherTeamFlag);
            }
            else if(otherTeamFlag.carrierData == this.userTankData && userTeamFlag.state == CTFFlagState.AT_BASE)
            {
               this.testFlagIntersection(userTeamFlag);
            }
            if(userTeamFlag.state == CTFFlagState.DROPPED)
            {
               this.testFlagIntersection(userTeamFlag);
            }
         }
         for each(flag in this.flags)
         {
            flag.update(deltaMsec);
         }
      }
      
      public function addUser(clientObject:ClientObject) : void
      {
      }
      
      public function removeUser(clientObject:ClientObject) : void
      {
      }
      
      public function addUserToField(clientObject:ClientObject) : void
      {
         var flag:CTFFlag = null;
         var tankData:TankData = this.tankModel.getTankData(clientObject);
         if(this.bfData.localUser == clientObject)
         {
            this.userTankData = tankData;
         }
         if(this.flags != null)
         {
            for each(flag in this.flags)
            {
               if(flag.state == CTFFlagState.CARRIED && flag.carrierId == clientObject.id)
               {
                  flag.setCarrier(flag.carrierId,tankData);
                  break;
               }
            }
         }
      }
      
      public function removeUserFromField(clientObject:ClientObject) : void
      {
      }
      
      public function get dumperName() : String
      {
         return "ctf";
      }
      
      public function dump(params:Vector.<String>) : String
      {
         var flag:CTFFlag = null;
         var str:String = "\n=== CaptureTheFlagModel dump ===\n";
         if(this.flags != null)
         {
            for each(flag in this.flags)
            {
               str += flag.toString() + "\n";
            }
         }
         str += "dropCommandSent=" + this.dropCommandSent + "\n";
         return str + "=== End of CaptureTheFlagModel dump ===";
      }
      
      public function isPositionInFlagProximity(position:Vector3, distanceSquared:Number, flagTeamType:BattleTeamType) : Boolean
      {
         var flag:CTFFlag = this.flags[flagTeamType];
         if(flag == null)
         {
            return false;
         }
         var flagBasePos:Vector3 = flag.basePosition;
         var dx:Number = flagBasePos.x - position.x;
         var dy:Number = flagBasePos.y - position.y;
         var dz:Number = flagBasePos.z - position.z;
         return dx * dx + dy * dy + dz * dz < distanceSquared;
      }
      
      public function isFlagCarrier(tankData:TankData) : Boolean
      {
         var flagTeamType:BattleTeamType = tankData.teamType == BattleTeamType.BLUE ? BattleTeamType.RED : BattleTeamType.BLUE;
         var ctfFlag:CTFFlag = this.flags[flagTeamType];
         return ctfFlag.carrierData == tankData;
      }
      
      private function initFlag(teamType:BattleTeamType, flagSpec:ClientFlag, flagData:FlagData) : void
      {
         var texture:BitmapData = null;
         var flag:CTFFlag = null;
         var pedestal:Object3D = null;
         var carrierData:TankData = null;
         var imageResource:BitmapData = ResourceUtil.getResource(ResourceType.IMAGE,flagData.imageResourceId).bitmapData;
         if(imageResource != null)
         {
            texture = imageResource;
         }
         else
         {
            texture = new BitmapData(this.FLAG_FRAME_WIDTH,this.FLAG_FRAME_HEIGHT,false,teamType == BattleTeamType.RED ? uint(uint(11141120)) : uint(uint(170)));
         }
         var materialSequence:MaterialSequence = materialRegistry.materialSequenceRegistry.getSequence(MaterialType.EFFECT,texture,this.FLAG_FRAME_WIDTH,FLAG_MIPMAP_RESOLUTION);
         var position:Vector3 = flagSpec.flagBasePosition;
         flag = new CTFFlag(teamType,position,this.FLAG_FRAME_WIDTH,this.FLAG_FRAME_HEIGHT,materialSequence.materials,texture,this.bfData.collisionDetector);
         this.flags[teamType] = flag;
         flag.addToContainer(this.bfData.viewport.getMapContainer());
         if(flagSpec.flagCarrierId != null)
         {
            carrierData = this.getTankData(flagSpec.flagCarrierId,this.bfData.bfObject.register);
            flag.setCarrier(flagSpec.flagCarrierId,carrierData);
            this.guiModel.ctfShowFlagCarried(teamType);
         }
         else if(flagSpec.flagPosition != null)
         {
            position.x = flagSpec.flagPosition.x;
            position.y = flagSpec.flagPosition.y;
            position.z = flagSpec.flagPosition.z;
            if(!flag.isAtBase())
            {
               flag.dropAt(position,this.bfData.collisionDetector);
            }
            else
            {
               flag.returnToBase();
            }
            this.guiModel.ctfShowFlagDropped(teamType);
         }
         pedestal = this.createPedestal(flagData.pedestalModelId,flagData.pedestalModel_img);
         var pos:Vector3 = flag.basePosition.vClone();
         pos.z -= CTFFlag.Z_DISPLACEMENT - 1;
         pedestal.x = pos.x;
         pedestal.y = pos.y;
         pedestal.z = pos.z;
         this.bfData.viewport.getMapContainer().addChild(pedestal);
      }
      
      private function createPedestal(resourceId:String, resourceImageId:String) : Object3D
      {
         var object:Mesh = ResourceUtil.getResource(ResourceType.MODEL,resourceId).mesh;
         var pedestal:BSP = new BSP();
         pedestal.createTree(object);
         var texture:BitmapData = ResourceUtil.getResource(ResourceType.IMAGE,resourceImageId).bitmapData;
         if(texture == null)
         {
            texture = new StubBitmapData(16776960);
         }
         var resolution:Number = pedestal.calculateResolution(texture.width,texture.height);
         var material:TextureMaterial = materialRegistry.textureMaterialRegistry.getMaterial(MaterialType.EFFECT,texture,resolution,false);
         pedestal.setMaterialToAllFaces(material);
         return pedestal;
      }
      
      private function returnFlag(flagTeam:BattleTeamType) : void
      {
         if(this.flags == null)
         {
            Logger.log(LogLevel.LOG_ERROR,"CTFModel::returnFlag() flags are not initialized");
            return;
         }
         var flag:CTFFlag = this.flags[flagTeam];
         flag.returnToBase();
         flag = this.flags[flag.teamType == BattleTeamType.RED ? BattleTeamType.BLUE : BattleTeamType.RED];
         flag.takeCommandSent = false;
         this.guiModel.ctfShowFlagAtBase(flagTeam);
      }
      
      private function testFlagIntersection(flag:CTFFlag) : void
      {
         var primitive:CollisionPrimitive = null;
         if(flag.takeCommandSent || this.userTankData == null || this.userTankData.spawnState == TankSpawnState.NEWCOME || this.userTankData.spawnState == TankSpawnState.SUICIDE)
         {
            return;
         }
         var body:Body = this.userTankData.tank;
         var item:CollisionPrimitiveListItem = body.collisionPrimitives.head;
         while(item != null)
         {
            primitive = item.primitive;
            if(this.bfData.collisionDetector.testCollision(primitive,flag.triggerCollisionPrimitive))
            {
               flag.takeCommandSent = true;
               this.attemptToTakeFlagCommand(this.bfData.bfObject,flag.teamType);
               return;
            }
            item = item.next;
         }
      }
      
      private function attemptToTakeFlagCommand(bfObject:ClientObject, flagTeamType:BattleTeamType) : void
      {
         var tankPos:Vector3 = this.userTankData.tank.state.pos;
         Network(Main.osgi.getService(INetworker)).send("battle;attempt_to_take_flag;" + flagTeamType.getValue() + ";" + tankPos.x + ";" + tankPos.y + ";" + tankPos.z);
      }
      
      private function getSound(resourceId:Long, resourceService:IResourceService) : Sound
      {
         var soundResource:SoundResource = resourceService.getResource(resourceId) as SoundResource;
         return soundResource == null ? null : soundResource.sound;
      }
      
      private function onStageResize(e:Event) : void
      {
         if(this.ctfMessages != null)
         {
            this.ctfMessages.x = 0.5 * Main.stage.stageWidth;
            this.ctfMessages.y = 40;
         }
      }
      
      private function initMessages() : void
      {
         if(this.messages != null)
         {
            return;
         }
         this.messages = {};
         this.locale = ILocaleService(Main.osgi.getService(ILocaleService));
         this.createFlagActionMessages(this.MESSAGE_TAKEN,this.locale,TextConst.CTF_GOT_ENEMY_FLAG,COLOR_POSITIVE,TextConst.CTF_GOT_OUR_FLAG,COLOR_NEGATIVE);
         this.createFlagActionMessages(this.MESSAGE_LOST,this.locale,TextConst.CTF_LOST_OUR_FLAG,COLOR_POSITIVE,TextConst.CTF_LOST_ENEMY_FLAG,COLOR_NEGATIVE);
         this.createFlagActionMessages(this.MESSAGE_RETURNED,this.locale,TextConst.CTF_RETURNED_OUR_FLAG,COLOR_POSITIVE,TextConst.CTF_RETURNED_ENEMY_FLAG,COLOR_NEGATIVE);
         this.createFlagActionMessages(this.MESSAGE_CAPTURED,this.locale,TextConst.CTF_CAPTURED_ENEMY_FLAG,COLOR_POSITIVE,TextConst.CTF_CAPTURED_OUR_FLAG,COLOR_NEGATIVE);
         this.ourFlagReturnedMessage = this.locale.getText(TextConst.CTF_OUR_FLAG_RETURNED);
         this.enemyFlagReturnedMessage = this.locale.getText(TextConst.CTF_ENEMY_FLAG_RETURNED);
      }
      
      private function createFlagActionMessages(messageKey:String, locale:ILocaleService, positiveKey:String, positiveColor:uint, negativeKey:String, negativeColor:uint) : void
      {
         var positiveMessage:FlagMessage = new FlagMessage(locale.getText(positiveKey),positiveColor);
         var negativeMessage:FlagMessage = new FlagMessage(locale.getText(negativeKey),negativeColor);
         this.messages[messageKey] = new FlagActionMessages(positiveMessage,negativeMessage);
      }
      
      private function getFlagMessage(action:String, positive:Boolean) : FlagMessage
      {
         var actionMessages:FlagActionMessages = this.messages[action];
         return !!positive ? actionMessages.positive : actionMessages.negative;
      }
      
      private function getTankData(userId:String, objectRegister:ObjectRegister) : TankData
      {
         var userObject:ClientObject = BattleController.activeTanks[userId];
         if(userObject == null)
         {
            return null;
         }
         var tankData:TankData = this.tankModel.getTankData(userObject);
         if(tankData == null || tankData.tank == null)
         {
            return null;
         }
         return tankData;
      }
      
      private function onKey(e:KeyboardEvent) : void
      {
         switch(e.keyCode)
         {
            case this.KEY_DROP_FLAG:
               this.doDropFlag();
         }
      }
      
      private function doDropFlag() : void
      {
         if(this.flags == null || this.bfData == null || this.userTankData == null || this.dropCommandSent || !this.tankModel.userControlsEnabled)
         {
            return;
         }
         var flag:CTFFlag = this.flags[this.userTankData.teamType == BattleTeamType.BLUE ? BattleTeamType.RED : BattleTeamType.BLUE];
         if(flag == null || flag.carrierData != this.userTankData)
         {
            return;
         }
         var pos:Vector3 = this.userTankData.tank.state.pos;
         this.pos3d.x = pos.x;
         this.pos3d.y = pos.y;
         this.pos3d.z = pos.z;
         this.dropCommandSent = true;
         this.dropFlagCommand(this.bfData.bfObject,this.pos3d);
      }
      
      private function dropFlagCommand(bfObject:ClientObject, pos3d:Vector3d) : void
      {
         var json:Object = new Object();
         json.x = pos3d.x;
         json.y = pos3d.y;
         json.z = pos3d.z;
         Network(Main.osgi.getService(INetworker)).send("battle;flag_drop;" + JSON.stringify(json));
      }
   }
}

class InitParams
{
    
   
   public var redFlagData:FlagData;
   
   public var blueFlagData:FlagData;
   
   function InitParams(redFlagData:FlagData, blueFlagData:FlagData)
   {
      super();
      this.redFlagData = redFlagData;
      this.blueFlagData = blueFlagData;
   }
}

class FlagData
{
    
   
   public var imageResourceId:String;
   
   public var pedestalModelId:String;
   
   public var pedestalModel_img:String;
   
   function FlagData(imageResourceId:String, pedestalModelId:String, pedestalModel_img:String)
   {
      super();
      this.imageResourceId = imageResourceId;
      this.pedestalModelId = pedestalModelId;
      this.pedestalModel_img = pedestalModel_img;
   }
}

class FlagMessage
{
    
   
   public var text:String;
   
   public var color:uint;
   
   function FlagMessage(text:String, color:uint)
   {
      super();
      this.text = text;
      this.color = color;
   }
}

class FlagActionMessages
{
    
   
   public var positive:FlagMessage;
   
   public var negative:FlagMessage;
   
   function FlagActionMessages(positive:FlagMessage, negative:FlagMessage)
   {
      super();
      this.positive = positive;
      this.negative = negative;
   }
}
