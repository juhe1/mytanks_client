package
{
   import alternativa.init.BattlefieldGUIActivator;
   import alternativa.init.BattlefieldModelActivator;
   import alternativa.init.BattlefieldSharedActivator;
   import alternativa.init.Main;
   import alternativa.init.TanksWarfareActivator;
   import alternativa.math.Vector3;
   import alternativa.object.ClientObject;
   import alternativa.osgi.service.locale.ILocaleService;
   import alternativa.osgi.service.storage.IStorageService;
   import alternativa.register.ClientClass;
   import alternativa.service.IModelService;
   import alternativa.tanks.bg.IBackgroundService;
   import alternativa.tanks.locale.constants.TextConst;
   import alternativa.tanks.model.PingService;
   import alternativa.tanks.model.achievement.AchievementModel;
   import alternativa.tanks.model.achievement.IAchievementModel;
   import alternativa.tanks.model.panel.IPanel;
   import alternativa.tanks.model.panel.PanelModel;
   import alternativa.tanks.models.battlefield.BattlefieldModel;
   import alternativa.tanks.models.battlefield.IBattleField;
   import alternativa.tanks.models.battlefield.StatisticsModel;
   import alternativa.tanks.models.battlefield.effects.DamageEffect;
   import alternativa.tanks.models.battlefield.effects.graffiti.GraffitiManager;
   import alternativa.tanks.models.battlefield.effects.graffiti.GraffitiModel;
   import alternativa.tanks.models.battlefield.gamemode.GameModes;
   import alternativa.tanks.models.battlefield.gamemode.IGameMode;
   import alternativa.tanks.models.battlefield.gui.IBattlefieldGUI;
   import alternativa.tanks.models.battlefield.gui.chat.ChatModel;
   import alternativa.tanks.models.battlefield.gui.chat.SpectatorList;
   import alternativa.tanks.models.ctf.CTFModel;
   import alternativa.tanks.models.dom.DOMModel;
   import alternativa.tanks.models.dom.IDOMModel;
   import alternativa.tanks.models.dom.server.DOMPointData;
   import alternativa.tanks.models.effects.common.bonuscommon.BonusCache;
   import alternativa.tanks.models.sfx.LightDataManager;
   import alternativa.tanks.models.tank.ITank;
   import alternativa.tanks.models.tank.TankData;
   import alternativa.tanks.models.tank.TankModel;
   import alternativa.tanks.models.tank.criticalhit.ITankCriticalHitModel;
   import alternativa.tanks.models.tank.criticalhit.TankCriticalHitModel;
   import alternativa.tanks.models.tank.explosion.ITankExplosionModel;
   import alternativa.tanks.models.tank.explosion.TankExplosionModel;
   import alternativa.tanks.models.weapon.IWeaponController;
   import alternativa.tanks.models.weapon.flamethrower.FlamethrowerModel;
   import alternativa.tanks.models.weapon.flamethrower.IFlamethrower;
   import alternativa.tanks.models.weapon.freeze.FreezeModel;
   import alternativa.tanks.models.weapon.gun.SmokyModel;
   import alternativa.tanks.models.weapon.healing.HealingGunModel;
   import alternativa.tanks.models.weapon.hwthunder.HWThunderModel;
   import alternativa.tanks.models.weapon.plasma.PlasmaModel;
   import alternativa.tanks.models.weapon.pumpkingun.PumpkinModel;
   import alternativa.tanks.models.weapon.railgun.RailgunModel;
   import alternativa.tanks.models.weapon.ricochet.RicochetModel;
   import alternativa.tanks.models.weapon.shaft.ShaftModel;
   import alternativa.tanks.models.weapon.shared.shot.ShotData;
   import alternativa.tanks.models.weapon.snowman.SnowmanModel;
   import alternativa.tanks.models.weapon.terminator.TerminatorModel;
   import alternativa.tanks.models.weapon.thunder.ThunderModel;
   import alternativa.tanks.models.weapon.weakening.IWeaponWeakeningModel;
   import alternativa.tanks.models.weapon.weakening.WeaponWeakeningModel;
   import com.alternativaplatform.projects.tanks.client.commons.types.DeathReason;
   import com.alternativaplatform.projects.tanks.client.commons.types.TankParts;
   import com.alternativaplatform.projects.tanks.client.commons.types.TankSpecification;
   import com.alternativaplatform.projects.tanks.client.commons.types.TankState;
   import com.alternativaplatform.projects.tanks.client.commons.types.Vector3d;
   import com.alternativaplatform.projects.tanks.client.models.battlefield.BattlefieldSoundScheme;
   import com.alternativaplatform.projects.tanks.client.models.ctf.ClientFlag;
   import com.alternativaplatform.projects.tanks.client.models.ctf.FlagsState;
   import com.alternativaplatform.projects.tanks.client.models.ctf.ICaptureTheFlagModelBase;
   import com.alternativaplatform.projects.tanks.client.models.tank.ClientTank;
   import com.alternativaplatform.projects.tanks.client.models.tank.TankSpawnState;
   import com.alternativaplatform.projects.tanks.client.warfare.models.tankparts.weapon.healing.IsisActionType;
   import com.alternativaplatform.projects.tanks.client.warfare.models.tankparts.weapon.healing.struct.IsisAction;
   import com.alternativaplatform.projects.tanks.client.warfare.models.tankparts.weapon.railgun.IRailgunModelBase;
   import com.reygazu.anticheat.events.CheatManagerEvent;
   import com.reygazu.anticheat.managers.CheatManager;
   import controls.Label;
   import flash.filters.GlowFilter;
   import flash.utils.Dictionary;
   import forms.Alert;
   import projects.tanks.client.battlefield.gui.models.effectsvisualization.BattleEffect;
   import projects.tanks.client.battlefield.gui.models.statistics.BattleStatInfo;
   import projects.tanks.client.battlefield.gui.models.statistics.UserStat;
   import projects.tanks.client.battleservice.model.team.BattleTeamType;
   import scpacker.gui.AlertBugWindow;
   import scpacker.gui.ServerMessage;
   import scpacker.networking.INetworkListener;
   import scpacker.networking.INetworker;
   import scpacker.networking.Network;
   import scpacker.networking.commands.Command;
   import scpacker.networking.commands.Type;
   import scpacker.resource.ResourceType;
   import scpacker.resource.ResourceUtil;
   import scpacker.resource.SoundResource;
   import scpacker.server.models.bonus.ServerBonusModel;
   import scpacker.server.models.inventory.ServerInventoryData;
   import scpacker.server.models.inventory.ServerInventoryModel;
   import scpacker.server.models.mines.ServerBattleMinesModel;
   import scpacker.server.models.shaft.ServerShaftTargetData;
   import scpacker.tanks.WeaponsManager;
   
   public class BattleController implements INetworkListener
   {
      
      public static var activeTanks:Dictionary;
      
      public static var localTankInited:Boolean = false;
      
      public static var client:ClientObject;
      
      private static var railgunModel:RailgunModel;
      
      private static var railgunCsModel:RailgunModel;
      
      private static var railgunXtModel:RailgunModel;
      
      private static var terminatorModel:TerminatorModel;
      
      private static var smokyModel:SmokyModel;
      
      private static var smokyCsModel:SmokyModel;
      
      private static var railgunXTModel:RailgunModel;
      
      private static var smokyXTModel:SmokyModel;
      
      private static var flamethrowerModel:FlamethrowerModel;
      
      public static var twinsModel:PlasmaModel;
      
      public static var twinsXTModel:PlasmaModel;
      
      private static var isidaModel:HealingGunModel;
      
      private static var thunderModel:ThunderModel;
      
      private static var thunderXTModel:ThunderModel;
      
      private static var hwthunderModel:HWThunderModel;
      
      private static var frezeeModel:FreezeModel;
      
      private static var frezeeNYModel:FreezeModel;
      
      private static var ricochetModel:RicochetModel;
      
      private static var pumpkinModel:PumpkinModel;
      
      private static var shaftModel:ShaftModel;
      
      private static var snowmanModel:SnowmanModel;
       
      
      private var battle:BattlefieldModelActivator;
      
      private var preparedPos:Vector3d;
      
      private var myTank:ClientTank;
      
      private var ctfObj:ClientObject;
      
      private var graffitiModel:GraffitiModel;
      
      private var serverInventoryModel:ServerInventoryModel;
      
      private var serverMinesModel:ServerBattleMinesModel;
      
      private var bonusModel:ServerBonusModel;
      
      private var pingTime:int = 0;
      
      private var network:Network;
      
      private var clientObjectBonuses:Array;
      
      private var testLabelPing:Label;
      
      public function BattleController()
      {
         this.ctfObj = new ClientObject("ctfModel",null,"ctfModelObj",null);
         this.serverInventoryModel = new ServerInventoryModel();
         this.serverMinesModel = new ServerBattleMinesModel();
         this.bonusModel = new ServerBonusModel();
         super();
         var models:TanksWarfareActivator = new TanksWarfareActivator();
         models.start(Main.osgi);
         var gui:BattlefieldGUIActivator = new BattlefieldGUIActivator();
         gui.start(Main.osgi);
         var shared:BattlefieldSharedActivator = new BattlefieldSharedActivator();
         shared.start(Main.osgi);
         this.battle = new BattlefieldModelActivator();
         this.battle.start(Main.osgi);
         var expl:TanksWarfareActivator = new TanksWarfareActivator();
         expl.start(Main.osgi);
         Main.osgi.registerService(IBattleField,this.battle.bm);
         activeTanks = new Dictionary();
         var explosionModel:TankExplosionModel = new TankExplosionModel();
         Main.osgi.registerService(ITankExplosionModel,explosionModel);
         var criticalHitModel:TankCriticalHitModel = new TankCriticalHitModel();
         Main.osgi.registerService(ITankCriticalHitModel,criticalHitModel);
         this.network = Main.osgi.getService(INetworker) as Network;
         var tankHitCritical:TankCriticalHitModel = new TankCriticalHitModel();
         Main.osgi.registerService(ITankCriticalHitModel,tankHitCritical);
         this.clientObjectBonuses = new Array();
      }
      
      public static function getWeaponController(obj:ClientObject) : IWeaponController
      {
         var weaponController:IWeaponController = null;
         var id:String = obj.id.split("_")[0];
         var turrEntity:* = WeaponsManager.specialEntity[obj.id];
         switch(id)
         {
            case "railgun":
               if(railgunModel == null)
               {
                  railgunModel = new RailgunModel();
               }
               railgunModel.initObject(obj,1200,0.8);
               railgunModel.objectLoaded(obj);
               weaponController = railgunModel;
               break;
            case "railgun_cs":
               if(railgunCsModel == null)
               {
                  railgunCsModel = new RailgunModel();
               }
               railgunCsModel.initObject(obj,1200,0.8);
               railgunCsModel.objectLoaded(obj);
               weaponController = railgunCsModel;
               break;
            case "railgun_xt":
               if(railgunXtModel == null)
               {
                  railgunXtModel = new RailgunModel();
               }
               railgunXtModel.initObject(obj,1200,0.8);
               railgunXtModel.objectLoaded(obj);
               weaponController = railgunXtModel;
               break;
            case "terminator":
               if(terminatorModel == null)
               {
                  terminatorModel = new TerminatorModel();
               }
               terminatorModel.initObject(obj,1200,0.8);
               terminatorModel.objectLoaded(obj);
               weaponController = terminatorModel;
               break;
            case "railgunxt":
               if(railgunXTModel == null)
               {
                  railgunXTModel = new RailgunModel();
               }
               railgunXTModel.initObject(obj,1200,0.8);
               railgunXTModel.objectLoaded(obj);
               weaponController = railgunXTModel;
               break;
            case "smoky":
               if(smokyModel == null)
               {
                  smokyModel = new SmokyModel();
               }
               smokyModel.objectLoaded(obj);
               weaponController = smokyModel;
               break;
            case "smokyxt":
               if(smokyXTModel == null)
               {
                  smokyXTModel = new SmokyModel();
               }
               smokyXTModel.objectLoaded(obj);
               weaponController = smokyXTModel;
               break;
            case "flamethrower":
               if(flamethrowerModel == null)
               {
                  flamethrowerModel = new FlamethrowerModel();
                  Main.osgi.registerService(IFlamethrower,flamethrowerModel);
               }
               flamethrowerModel.initObject(WeaponsManager.getObjectFor(obj.id),turrEntity.cone_angle,turrEntity.cooling_speed,turrEntity.heat_limit,turrEntity.heating_speed,turrEntity.range,turrEntity.target_detection_interval);
               weaponController = flamethrowerModel;
               break;
            case "twins":
               if(twinsModel == null)
               {
                  twinsModel = new PlasmaModel();
               }
               twinsModel.initObject(WeaponsManager.getObjectFor(obj.id),turrEntity.shot_radius,turrEntity.shot_range,turrEntity.shot_speed);
               weaponController = twinsModel;
               break;
            case "twins_xt":
               if(twinsXTModel == null)
               {
                  twinsXTModel = new PlasmaModel();
               }
               twinsXTModel.initObject(WeaponsManager.getObjectFor(obj.id),turrEntity.shot_radius,turrEntity.shot_range,turrEntity.shot_speed);
               weaponController = twinsXTModel;
               break;
            case "twinsxt":
               if(twinsModel == null)
               {
                  twinsModel = new PlasmaModel();
               }
               twinsModel.initObject(WeaponsManager.getObjectFor(obj.id),turrEntity.shot_radius,turrEntity.shot_range,turrEntity.shot_speed);
               weaponController = twinsModel;
               break;
            case "isida":
               if(isidaModel == null)
               {
                  isidaModel = new HealingGunModel();
               }
               isidaModel.initObject(WeaponsManager.getObjectFor(obj.id),turrEntity.angle,turrEntity.capacity,turrEntity.chargeRate,turrEntity.tickPeriod,turrEntity.coneAngle,turrEntity.dischargeRate,turrEntity.radius);
               weaponController = isidaModel;
               break;
            case "thunder":
               if(thunderModel == null)
               {
                  thunderModel = new ThunderModel();
               }
               thunderModel.initObject(WeaponsManager.getObjectFor(obj.id),turrEntity.impactForce,turrEntity.maxSplashDamageRadius,turrEntity.minSplashDamagePercent,turrEntity.minSplashDamageRadius);
               weaponController = thunderModel;
               break;
            case "thunder_xt":
               if(thunderXTModel == null)
               {
                  thunderXTModel = new ThunderModel();
               }
               thunderXTModel.initObject(WeaponsManager.getObjectFor(obj.id),turrEntity.impactForce,turrEntity.maxSplashDamageRadius,turrEntity.minSplashDamagePercent,turrEntity.minSplashDamageRadius);
               weaponController = thunderXTModel;
               break;
            case "hwthunder":
               if(hwthunderModel == null)
               {
                  hwthunderModel = new HWThunderModel();
               }
               hwthunderModel.initObject(WeaponsManager.getObjectFor(obj.id),turrEntity.impactForce,turrEntity.maxSplashDamageRadius,turrEntity.minSplashDamagePercent,turrEntity.minSplashDamageRadius);
               weaponController = hwthunderModel;
               break;
            case "frezee":
               if(frezeeModel == null)
               {
                  frezeeModel = new FreezeModel();
               }
               frezeeModel.initObject(WeaponsManager.getObjectFor(obj.id),turrEntity.damageAreaConeAngle,turrEntity.damageAreaRange,turrEntity.energyCapacity,turrEntity.energyDischargeSpeed,turrEntity.energyRechargeSpeed,turrEntity.weaponTickMsec);
               weaponController = frezeeModel;
               break;
            case "frezeeny":
               if(frezeeNYModel == null)
               {
                  frezeeNYModel = new FreezeModel();
               }
               frezeeNYModel.initObject(WeaponsManager.getObjectFor(obj.id),turrEntity.damageAreaConeAngle,turrEntity.damageAreaRange,turrEntity.energyCapacity,turrEntity.energyDischargeSpeed,turrEntity.energyRechargeSpeed,turrEntity.weaponTickMsec);
               weaponController = frezeeNYModel;
               break;
            case "ricochet":
               if(ricochetModel == null)
               {
                  ricochetModel = new RicochetModel();
               }
               ricochetModel.initObject(WeaponsManager.getObjectFor(obj.id),turrEntity.energyCapacity,turrEntity.energyPerShot,turrEntity.energyRechargeSpeed,turrEntity.shotDistance,turrEntity.shotRadius,turrEntity.shotSpeed);
               weaponController = ricochetModel;
               break;
            case "pumpkingun":
               if(pumpkinModel == null)
               {
                  pumpkinModel = new PumpkinModel();
               }
               pumpkinModel.initObject(WeaponsManager.getObjectFor(obj.id),turrEntity.energyCapacity,turrEntity.energyPerShot,turrEntity.energyRechargeSpeed,turrEntity.shotDistance,turrEntity.shotRadius,turrEntity.shotSpeed);
               weaponController = pumpkinModel;
               break;
            case "shaft":
               if(shaftModel == null)
               {
                  shaftModel = new ShaftModel();
               }
               shaftModel.initObject(WeaponsManager.getObjectFor(obj.id),turrEntity.max_energy,turrEntity.charge_rate,turrEntity.discharge_rate,turrEntity.elevation_angle_up,turrEntity.elevation_angle_down,turrEntity.vertical_targeting_speed,turrEntity.horizontal_targeting_speed,turrEntity.inital_fov,turrEntity.minimum_fov,turrEntity.shrubs_hiding_radius_min,turrEntity.shrubs_hiding_radius_max,2);
               weaponController = shaftModel;
               break;
            case "snowman":
               if(snowmanModel == null)
               {
                  snowmanModel = new SnowmanModel();
               }
               snowmanModel.initObject(WeaponsManager.getObjectFor(obj.id),turrEntity.shot_radius,turrEntity.shot_range,turrEntity.shot_speed);
               weaponController = snowmanModel;
         }
         return weaponController;
      }
      
      public function onData(data:Command) : void
      {
         var jsParser:Object = null;
         var items:Array = null;
         var item:Object = null;
         var _item:ServerInventoryData = null;
         var alert:AlertBugWindow = null;
         var graffParser:Object = null;
         var graffItems:Array = null;
         var item_:Object = null;
         var parser:Object = null;
         var battle:BattleStatInfo = null;
         var users:Array = null;
         var i:int = 0;
         var obj:Object = null;
         var tempArr:Array = null;
         var pos:Vector3d = null;
         var alertWindow:Alert = null;
         var achievementModel:AchievementModel = null;
         var json:Object = null;
         var ctfModel:CTFModel = null;
         var flagsState:FlagsState = null;
         var blueFlag:ClientFlag = null;
         var redFlag:ClientFlag = null;
         var model:DOMModel = null;
         var points:Vector.<DOMPointData> = null;
         var point:DOMPointData = null;
         var userId:Object = null;
         var table:ServerMessage = null;
         jsParser = null;
         items = null;
         item = null;
         _item = null;
         var jsArray:Object = null;
         var effects:Array = null;
         var effect:BattleEffect = null;
         var time:int = 0;
         var ping:int = 0;
         var tankData:TankData = null;
         var soundResource:SoundResource = null;
         var waypoints:Array = null;
         var group:Object = null;
         var gr:Array = null;
         var waypoint:Object = null;
         alert = null;
         try
         {
            switch(data.type)
            {
               case Type.BATTLE:
                  if(data.args[0] == "init_battle_model")
                  {
                     this.initBattle(data.args[1]);
                     break;
                  }
                  if(data.args[0] == "init_gui_model")
                  {
                     parser = JSON.parse(data.args[1]);
                     battle = new BattleStatInfo();
                     battle.blueScore = parser.score_blue;
                     battle.fund = parser.fund;
                     battle.redScore = parser.score_red;
                     battle.scoreLimit = parser.scoreLimit;
                     battle.teamPlay = parser.team;
                     battle.timeLeft = parser.currTime;
                     battle.timeLimit = parser.timeLimit;
                     PanelModel(Main.osgi.getService(IPanel)).isInBattle = true;
                     users = new Array();
                     StatisticsModel(Main.osgi.getService(IBattlefieldGUI)).initObject(null,parser.name);
                     i = 0;
                     for each(obj in parser.users)
                     {
                        users[i] = new UserStat(0,0,obj.nickname,obj.rank,0,0,BattleTeamType.getType(obj.teamType),obj.nickname);
                        trace((users[i] as UserStat).name + ": rank " + (users[i] as UserStat).rank);
                        i++;
                     }
                     StatisticsModel(Main.osgi.getService(IBattlefieldGUI)).init(new ClientObject("bfObject",null,"bfObject",null),battle,users);
                     ChatModel(Main.osgi.getService(IChatBattle)).objectLoaded(null);
                     this.serverMinesModel.init();
                     CheatManager.getInstance().addEventListener(CheatManagerEvent.CHEAT_DETECTION,Game.onUserEntered);
                     this.serverInventoryModel.init();
                     break;
                  }
                  if(data.args[0] == "init_tank")
                  {
                     this.initTank(data.args[1]);
                     break;
                  }
                  if(data.args[0] == "activate_tank")
                  {
                     if(activeTanks[data.args[1]] != null)
                     {
                        TankModel(Main.osgi.getService(ITank)).activateTank(activeTanks[data.args[1]]);
                        break;
                     }
                     break;
                  }
                  if(data.args[0] == "kill_tank")
                  {
                     if(activeTanks[data.args[1]] != null)
                     {
                        TankModel(Main.osgi.getService(ITank)).kill(activeTanks[data.args[1]],DeathReason.getReason(data.args[2]),data.args[3]);
                        break;
                     }
                     break;
                  }
                  if(data.args[0] == "prepare_to_spawn")
                  {
                     if(activeTanks[data.args[1]] != null)
                     {
                        tempArr = String(data.args[2]).split("@");
                        pos = new Vector3d(tempArr[0],tempArr[1],tempArr[2]);
                        TankModel(Main.osgi.getService(ITank)).prepareToSpawn(activeTanks[data.args[1]],pos,new Vector3d(0,0,tempArr[3]));
                        trace("prepare_to_spawn" + "\t" + pos);
                        break;
                     }
                     break;
                  }
                  if(data.args[0] == "spawn")
                  {
                     this.parseSpawnCommand(data.args[1]);
                     break;
                  }
                  if(data.args[0] == "move")
                  {
                     this.moveTank(data.args[1]);
                     break;
                  }
                  if(data.args[0] == "chat")
                  {
                     this.onChatMessage(data.args[1]);
                     break;
                  }
                  if(data.args[0] == "spectator_message")
                  {
                     ChatModel(Main.osgi.getService(IChatBattle)).addSpectatorMessage(data.args[1]);
                     break;
                  }
                  if(data.args[0] == "remove_user")
                  {
                     trace("remove user " + data.args[1]);
                     this.removeUser(data.args[1]);
                     break;
                  }
                  if(data.args[0] == "ping")
                  {
                     Network(Main.osgi.getService(INetworker)).send("battle;ping");
                     break;
                  }
                  if(data.args[0] != "tracePing")
                  {
                     if(data.args[0] == "tank_smooth")
                     {
                        this.tankSmooth(data.args[1]);
                        break;
                     }
                     if(data.args[0] == "spawn_bonus")
                     {
                        this.parseSpawnBonus(data.args[1]);
                        break;
                     }
                     if(data.args[0] == "take_bonus_by")
                     {
                        BattlefieldModel(Main.osgi.getService(IBattleField)).bonusTaken(null,data.args[1]);
                        break;
                     }
                     if(data.args[0] == "user_log")
                     {
                        StatisticsModel(Main.osgi.getService(IBattlefieldGUI)).logUserAction(data.args[1],data.args[2]);
                        break;
                     }
                     if(data.args[0] == "set_cry")
                     {
                        PanelModel(Main.osgi.getService(IPanel)).updateCrystal(null,int(data.args[1]));
                        break;
                     }
                     if(data.args[0] == "remove_bonus")
                     {
                        BattlefieldModel(Main.osgi.getService(IBattleField)).removeBonus(null,data.args[1]);
                        break;
                     }
                     if(data.args[0] == "start_fire")
                     {
                        this.parseStartFire(activeTanks[data.args[1]],data.args[1],data.args.length > 2 ? data.args[2] : "");
                        break;
                     }
                     if(data.args[0] == "fire")
                     {
                        this.parseFire(activeTanks[data.args[1]],data.args[2]);
                        break;
                     }
                     if(data.args[0] == "change_health")
                     {
                        TankModel(Main.osgi.getService(ITank)).changeHealth(activeTanks[data.args[1]],data.args[2]);
                        break;
                     }
                     if(data.args[0] == "damage_tank")
                     {
                        this.createDamageEffect(activeTanks[data.args[1]],data.args[2]);
                        break;
                     }
                     if(data.args[0] == "create_levelup_effect")
                     {
                        TankModel(Main.osgi.getService(ITank)).createLevelUpEffect(data.args[1],data.args[2]);
                        break;
                     }
                     if(data.args[0] == "create_critical_hit_effect")
                     {
                        TankModel(Main.osgi.getService(ITank)).createCriticalHitEffect(data.args[1]);
                        break;
                     }
                     if(data.args[0] == "init_shots_data")
                     {
                        this.parseShotsData(data.args[1]);
                        break;
                     }
                     if(data.args[0] == "stop_fire")
                     {
                        this.parseStopFire(activeTanks[data.args[1]],data.args[1]);
                        break;
                     }
                     if(data.args[0] == "kick_for_cheats")
                     {
                        Network(Main.osgi.getService(INetworker)).destroy();
                        BattlefieldModel(Main.osgi.getService(IBattleField)).getConfig().map.destroy();
                        BattlefieldModel(Main.osgi.getService(IBattleField)).getConfig().map = null;
                        BattlefieldModel(Main.osgi.getService(IBattleField)).objectUnloaded(null);
                        BattleController(Main.osgi.getService(IBattleController)).destroy();
                        StatisticsModel(Main.osgi.getService(IBattlefieldGUI)).objectUnloaded(null);
                        ChatModel(Main.osgi.getService(IChatBattle)).objectUnloaded(null);
                        for(i = 0; i < Main.mainContainer.numChildren; i++)
                        {
                           Main.mainContainer.removeChildAt(1);
                        }
                        IBackgroundService(Main.osgi.getService(IBackgroundService)).drawBg();
                        IBackgroundService(Main.osgi.getService(IBackgroundService)).showBg();
                        alertWindow = new Alert(-1,true);
                        alertWindow._msg = "Вы были кикнуты за читы. Пидор. Фу.";
                        Main.systemUILayer.addChild(alertWindow);
                        break;
                     }
                     if(data.args[0] == "update_player_statistic")
                     {
                        this.parseUpdatePlayerStatistic(data.args[1]);
                        break;
                     }
                     if(data.args[0] == "change_fund")
                     {
                        StatisticsModel(Main.osgi.getService(IBattlefieldGUI)).fundChange(null,data.args[1]);
                        break;
                     }
                     if(data.args[0] == "battle_finish")
                     {
                        this.parseFinishBattle(data.args[1]);
                        break;
                     }
                     if(data.args[0] == "battle_restart")
                     {
                        StatisticsModel(Main.osgi.getService(IBattlefieldGUI)).restart(null,data.args[1]);
                        BattlefieldModel(Main.osgi.getService(IBattleField)).battleRestart(null);
                        break;
                     }
                     if(data.args[0] == "start_fire_twins")
                     {
                        this.parseStartFireTwins(activeTanks[data.args[1]],data.args[2]);
                        break;
                     }
                     if(data.args[0] == "start_fire_terminator")
                     {
                        this.parseStartFireTerminator(activeTanks[data.args[1]],data.args[2]);
                        break;
                     }
                     if(data.args[0] == "start_fire_snowman")
                     {
                        this.parseStartFireSnowman(activeTanks[data.args[1]],data.args[2]);
                        break;
                     }
                     if(data.args[0] == "show_nube_up_score")
                     {
                        this.bonusModel.showNewbiesUpScore();
                        break;
                     }
                     if(data.args[0] == "show_nube_new_rank")
                     {
                        achievementModel = Main.osgi.getService(IAchievementModel) as AchievementModel;
                        achievementModel.showNewRankCongratulationsWindow();
                        break;
                     }
                     if(data.args[0] == "change_spec_tank")
                     {
                        this.parseChangeSpecTank(activeTanks[data.args[1]],data.args[2]);
                        break;
                     }
                     if(data.args[0] == "change_temperature_tank")
                     {
                        TankModel(Main.osgi.getService(ITank)).setTemperature(activeTanks[data.args[1]],data.args[2]);
                        break;
                     }
                     if(data.args[0] == "fire_ricochet")
                     {
                        this.parseRicochetFire(data.args[1],data.args[2]);
                        break;
                     }
                     if(data.args[0] == "change_team_scores")
                     {
                        StatisticsModel(Main.osgi.getService(IBattlefieldGUI)).changeTeamScore(null,BattleTeamType.getType(data.args[1]),data.args[2]);
                        break;
                     }
                     if(data.args[0] == "init_ctf_model")
                     {
                        json = JSON.parse(data.args[1]);
                        ctfModel = new CTFModel();
                        ctfModel.initObject(this.ctfObj,"flagBlueModel_pedestal","flagBlueModel_img","flagBlue","flagRedModel_pedestal","flagRedModel_img","flagRed",null,new Vector3(json.posBlueFlag.x,json.posBlueFlag.y,json.posBlueFlag.z),new Vector3(json.posRedFlag.x,json.posRedFlag.y,json.posRedFlag.z));
                        flagsState = new FlagsState();
                        blueFlag = new ClientFlag();
                        blueFlag.flagBasePosition = new Vector3(json.basePosBlueFlag.x,json.basePosBlueFlag.y,json.basePosBlueFlag.z);
                        blueFlag.flagPosition = new Vector3(json.posBlueFlag.x,json.posBlueFlag.y,json.posBlueFlag.z);
                        blueFlag.flagCarrierId = json.blueFlagCarrierId;
                        redFlag = new ClientFlag();
                        redFlag.flagBasePosition = new Vector3(json.basePosRedFlag.x,json.basePosRedFlag.y,json.basePosRedFlag.z);
                        redFlag.flagPosition = new Vector3(json.posRedFlag.x,json.posRedFlag.y,json.posRedFlag.z);
                        redFlag.flagCarrierId = json.redFlagCarrierId;
                        flagsState.blueFlag = blueFlag;
                        flagsState.redFlag = redFlag;
                        ctfModel.initFlagsState(this.ctfObj,flagsState);
                        Main.osgi.registerService(ICaptureTheFlagModelBase,ctfModel);
                        break;
                     }
                     if(data.args[0] == "init_dom_model")
                     {
                        model = new DOMModel();
                        points = new Vector.<DOMPointData>();
                        for each(obj in JSON.parse(data.args[1]).points)
                        {
                           point = new DOMPointData();
                           point.radius = obj.radius;
                           point.id = obj.id;
                           point.pos = new Vector3(obj.x,obj.y,obj.z);
                           point.score = obj.score;
                           point.occupatedUsers = new Vector.<String>();
                           for each(userId in obj.occupated_users)
                           {
                              point.occupatedUsers.push(userId);
                           }
                           points.push(point);
                        }
                        model.initObject(points);
                        model.objectLoaded(null);
                        Main.osgi.registerService(IDOMModel,model);
                        break;
                     }
                     if(data.args[0] == "flagTaken")
                     {
                        CTFModel(Main.osgi.getService(ICaptureTheFlagModelBase)).flagTaken(null,data.args[1],BattleTeamType.getType(data.args[2]));
                        break;
                     }
                     if(data.args[0] == "deliver_flag")
                     {
                        CTFModel(Main.osgi.getService(ICaptureTheFlagModelBase)).flagDelivered(null,BattleTeamType.getType(data.args[1]),data.args[2]);
                        break;
                     }
                     if(data.args[0] == "flag_drop")
                     {
                        json = JSON.parse(data.args[1]);
                        CTFModel(Main.osgi.getService(ICaptureTheFlagModelBase)).dropFlag(null,new Vector3d(json.x,json.y,json.z),BattleTeamType.getType(json.flagTeam));
                        break;
                     }
                     if(data.args[0] == "return_flag")
                     {
                        CTFModel(Main.osgi.getService(ICaptureTheFlagModelBase)).returnFlagToBase(null,BattleTeamType.getType(data.args[1]),data.args[2]);
                        break;
                     }
                     if(data.args[0] == "show_warning_table")
                     {
                        table = new ServerMessage(data.args[1]);
                        Main.stage.addChild(table);
                        break;
                     }
                     if(data.args[0] == "change_user_team")
                     {
                        StatisticsModel(Main.osgi.getService(IBattlefieldGUI)).changeUserTeam(null,data.args[1],BattleTeamType.getType(data.args[2]));
                        break;
                     }
                     if(data.args[0] == "init_graffitis")
                     {
                        this.graffitiModel = new GraffitiModel();
                        this.graffitiModel.objectLoaded(null);
                        graffParser = JSON.parse(data.args[1]);
                        graffItems = new Array();
                        for each(item in graffParser.graffitis)
                        {
                           item_ = new Object();
                           item_.count = item.count;
                           item_.id = item.id;
                           item_.name = item.name;
                           graffItems.push(item_);
                        }
                        this.graffitiModel.initGraffitis(graffItems);
                        break;
                     }
                     if(data.args[0] == "create_graffiti")
                     {
                        this.createGraffiti(data.args[1],data.args[2]);
                        break;
                     }
                     if(data.args[0] == "init_inventory")
                     {
                        jsParser = JSON.parse(data.args[1]);
                        items = new Array();
                        for each(item in jsParser.items)
                        {
                           _item = new ServerInventoryData();
                           _item.count = item.count;
                           _item.id = item.id;
                           _item.itemEffectTime = item.itemEffectTime;
                           _item.itemRestSec = item.itemRestSec;
                           _item.slotId = item.slotId;
                           items.push(_item);
                        }
                        this.serverInventoryModel.initInventory(items);
                        break;
                     }
                     if(data.args[0] == "update_inventory")
                     {
                        jsParser = JSON.parse(data.args[1]);
                        items = new Array();
                        for each(item in jsParser.items)
                        {
                           _item = new ServerInventoryData();
                           _item.count = item.count;
                           _item.id = item.id;
                           _item.itemEffectTime = item.itemEffectTime;
                           _item.itemRestSec = item.itemRestSec;
                           _item.slotId = item.slotId;
                           items.push(_item);
                        }
                        this.serverInventoryModel.updateInventory(items);
                        break;
                     }
                     if(data.args[0] == "activate_item")
                     {
                        this.serverInventoryModel.activateItem(data.args[1]);
                        break;
                     }
                     if(data.args[0] == "enable_effect")
                     {
                        this.serverInventoryModel.enableEffect(activeTanks[data.args[1]],data.args[2],data.args[3]);
                        break;
                     }
                     if(data.args[0] == "disnable_effect")
                     {
                        this.serverInventoryModel.disnableEffect(activeTanks[data.args[1]],data.args[2]);
                        break;
                     }
                     if(data.args[0] == "init_effects")
                     {
                        jsArray = JSON.parse(data.args[1]);
                        effects = new Array();
                        for each(obj in jsArray.effects)
                        {
                           effect = new BattleEffect();
                           effect.durationTime = obj.durationTime;
                           effect.itemIndex = obj.itemIndex;
                           effect.userID = obj.userID;
                           effects.push(effect);
                        }
                        this.serverInventoryModel.enableEffects(null,effects);
                        break;
                     }
                     if(data.args[0] == "local_user_killed")
                     {
                        this.serverInventoryModel.localTankKilled();
                        break;
                     }
                     if(data.args[0] == "init_mine_model")
                     {
                        this.serverMinesModel.initModel(data.args[1]);
                        break;
                     }
                     if(data.args[0] == "remove_mines")
                     {
                        this.serverMinesModel.removeMines(data.args[1]);
                        break;
                     }
                     if(data.args[0] == "put_mine")
                     {
                        json = JSON.parse(data.args[1]);
                        this.serverMinesModel.putMine(activeTanks[json.userId],json);
                        break;
                     }
                     if(data.args[0] == "activate_mine")
                     {
                        this.serverMinesModel.activateMine(data.args[1]);
                        break;
                     }
                     if(data.args[0] == "hit_mine")
                     {
                        this.serverMinesModel.hitMine(activeTanks[data.args[2]],data.args[1]);
                        break;
                     }
                     if(data.args[0] == "init_mines")
                     {
                        this.serverMinesModel.initMines(data.args[1]);
                        break;
                     }
                     if(data.args[0] == "tank_capturing_point")
                     {
                        DOMModel(Main.osgi.getService(IDOMModel)).serverTankCapturingPoint(data.args[1],activeTanks[data.args[2]]);
                        break;
                     }
                     if(data.args[0] == "tank_leave_capturing_point")
                     {
                        DOMModel(Main.osgi.getService(IDOMModel)).serverTankLeaveCapturingPoint(activeTanks[data.args[1]],data.args[2]);
                        break;
                     }
                     if(data.args[0] == "set_point_score")
                     {
                        DOMModel(Main.osgi.getService(IDOMModel)).serverSetPointScore(data.args[1],data.args[2]);
                        break;
                     }
                     if(data.args[0] == "point_captured_by")
                     {
                        DOMModel(Main.osgi.getService(IDOMModel)).serverPointCapturedBy(data.args[1],data.args[2]);
                        break;
                     }
                     if(data.args[0] == "point_lost_by")
                     {
                        DOMModel(Main.osgi.getService(IDOMModel)).serverPointLostBy(data.args[1],data.args[2]);
                        break;
                     }
                     if(data.args[0] == "shaft_quick_shot")
                     {
                        this.parseShaftQuickFire(data.args[1],data.args[2]);
                        break;
                     }
                     if(data.args[0] == "pong")
                     {
                        PingService.setPing();
                        break;
                     }
                     if(data.args[0] == "create_critical_hit_effect")
                     {
                        break;
                     }
                     if(data.args[0] == "gold_spawn")
                     {
                        BattlefieldModel(Main.osgi.getService(IBattleField)).messages.addMessage(16753920,ILocaleService(Main.osgi.getService(ILocaleService)).getText(TextConst.BATTLE_GOLD));
                        BattlefieldModel(Main.osgi.getService(IBattleField)).soundManager.playSound(ResourceUtil.getResource(ResourceType.SOUND,"gold").sound,0,1);
                        break;
                     }
                     if(data.args[0] == "spin_spawn")
                     {
                        BattlefieldModel(Main.osgi.getService(IBattleField)).messages.addMessage(16753920,ILocaleService(Main.osgi.getService(ILocaleService)).getText(TextConst.BATTLE_SPIN));
                        BattlefieldModel(Main.osgi.getService(IBattleField)).soundManager.playSound(ResourceUtil.getResource(ResourceType.SOUND,"gold").sound,0,1);
                        break;
                     }
                     if(data.args[0] == "ruby_spawn")
                     {
                        BattlefieldModel(Main.osgi.getService(IBattleField)).messages.addMessage(16753920,ILocaleService(Main.osgi.getService(ILocaleService)).getText(TextConst.BATTLE_RUBY));
                        BattlefieldModel(Main.osgi.getService(IBattleField)).soundManager.playSound(ResourceUtil.getResource(ResourceType.SOUND,"gold").sound,0,1);
                        break;
                     }
                     if(data.args[0] == "prize_spawn")
                     {
                        BattlefieldModel(Main.osgi.getService(IBattleField)).messages.addMessage(16753920,ILocaleService(Main.osgi.getService(ILocaleService)).getText(TextConst.BATTLE_PRIZE));
                        BattlefieldModel(Main.osgi.getService(IBattleField)).soundManager.playSound(ResourceUtil.getResource(ResourceType.SOUND,"prize").sound,0,1);
                        break;
                     }
                     if(data.args[0] == "update_spectator_list")
                     {
                        SpectatorList.spectators = data.args[1];
                        break;
                     }
                     if(data.args[0] == "init_sfx_data")
                     {
                        LightDataManager.init(data.args[1]);
                        break;
                     }
                     break;
                  }
                  break;
            }
         }
         catch(e:Error)
         {
            trace(e.getStackTrace());
            alert = new AlertBugWindow();
            alert.text = "Произошла ошибка: " + e.getStackTrace();
            Main.systemUILayer.addChild(alert);
            throw e;
         }
      }
      
      private function createDamageEffect(user:ClientObject, damage:int) : void
      {
         var isEnable:Boolean = BattlefieldModel(Main.osgi.getService(IBattleField)).isEnableDamageUpEffect();
         if(isEnable)
         {
            new DamageEffect().createEffect(TankModel(Main.osgi.getService(ITank)).getTankData(activeTanks[user.id] as ClientObject).tank,Math.floor(damage));
         }
      }
      
      private function createGraffiti(name:String, json:String) : void
      {
         var parser:Object = JSON.parse(json);
         var rayPos:Vector3 = new Vector3(parser.rayPos.x,parser.rayPos.y,parser.rayPos.z);
         var origin:Vector3 = new Vector3(parser.origin.x,parser.origin.y,parser.origin.z);
         GraffitiManager.createGraffiti(rayPos,origin,name);
      }
      
      private function parseRicochetFire(tankId:String, json:String) : void
      {
         var parser:Object = JSON.parse(json);
         var user:ClientObject = activeTanks[tankId];
         if(user == null || ricochetModel == null || parser == null)
         {
            return;
         }
         ricochetModel.hit(user,parser.victimId,new Vector3d(parser.hitPos3d.x,parser.hitPos3d.y,parser.hitPos3d.z),parser.x,parser.y,parser.z,1);
      }
      
      private function parsePumpkingunFire(tankId:String, json:String) : void
      {
         var parser:Object = JSON.parse(json);
         var user:ClientObject = activeTanks[tankId];
         if(user == null || pumpkinModel == null || parser == null)
         {
            return;
         }
         pumpkinModel.hit(user,parser.victimId,new Vector3d(parser.hitPos3d.x,parser.hitPos3d.y,parser.hitPos3d.z),parser.x,parser.y,parser.z,1);
      }
      
      private function parseShaftQuickFire(userName:String, json:String) : void
      {
         var user:ClientObject = activeTanks[userName];
         if(user == null)
         {
            return;
         }
         var parser:Object = JSON.parse(json);
         shaftModel.quickFire(user,parser.targets,parser.hitPoints,new Vector3(parser.dir.x,parser.dir.y,parser.dir.z));
      }
      
      private function parseChangeSpecTank(client:ClientObject, json:String) : void
      {
         var parser:Object = JSON.parse(json);
         var tankSpec:TankSpecification = new TankSpecification();
         tankSpec.speed = parser.speed;
         tankSpec.turnSpeed = parser.turnSpeed;
         tankSpec.turretRotationSpeed = parser.turretRotationSpeed;
         TankModel(Main.osgi.getService(ITank)).changeSpecification(client,tankSpec,parser.immediate);
      }
      
      private function parseStartFireSnowman(user:ClientObject, json:String) : void
      {
         var parser:Object = JSON.parse(json);
         if(user == null || snowmanModel == null || parser == null)
         {
            return;
         }
         snowmanModel.fire(user,user.id,parser.realShotId,new Vector3d(parser.dirToTarget.x,parser.dirToTarget.y,parser.dirToTarget.z));
      }
      
      private function parseStartFireTwins(user:ClientObject, json:String) : void
      {
         var parser:Object = JSON.parse(json);
         if(user == null || twinsModel == null || parser == null)
         {
            return;
         }
         twinsModel.fire(user,user.id,parser.currBarrel,parser.realShotId,new Vector3d(parser.dirToTarget.x,parser.dirToTarget.y,parser.dirToTarget.z));
      }
      
      private function parseStartFireTerminator(user:ClientObject, json:String) : void
      {
         var parser:Object = JSON.parse(json);
         if(user == null || terminatorModel == null || parser == null)
         {
            return;
         }
         terminatorModel.startFire(user,user.id,parser.currBarrel);
      }
      
      private function parseFinishBattle(json:String) : void
      {
         var obj:Object = null;
         var stat:UserStat = null;
         var parser:Object = JSON.parse(json);
         var users:Array = new Array();
         for each(obj in parser.users)
         {
            stat = new UserStat(obj.kills,obj.deaths,obj.id,obj.rank,obj.score,obj.prize,BattleTeamType.getType(obj.team_type),obj.id);
            users.push(stat);
         }
         StatisticsModel(Main.osgi.getService(IBattlefieldGUI)).finish(null,users,parser.time_to_restart / 1000);
         BattlefieldModel(Main.osgi.getService(IBattleField)).battleFinish(null);
      }
      
      private function parseUpdatePlayerStatistic(json:String) : void
      {
         var parser:Object = JSON.parse(json);
         var stat:UserStat = new UserStat(parser.kills,parser.deaths,parser.id,parser.rank,parser.score,0,BattleTeamType.getType(parser.team_type),parser.id);
         StatisticsModel(Main.osgi.getService(IBattlefieldGUI)).changeUsersStat(null,new Array(stat));
      }
      
      private function parseSpawnCommand(js:String) : void
      {
         var parser:Object = JSON.parse(js);
         var pos:Vector3d = new Vector3d(parser.x,parser.y,parser.z);
         var rot:Vector3d = new Vector3d(0,0,parser.rot);
         var tankSpec:TankSpecification = new TankSpecification();
         tankSpec.speed = parser.speed;
         tankSpec.turnSpeed = parser.turn_speed;
         tankSpec.turretRotationSpeed = parser.turret_rotation_speed;
         TankModel(Main.osgi.getService(ITank)).spawn(activeTanks[parser.tank_id],tankSpec,BattleTeamType.getType(parser.team_type),pos,rot,parser.health,parser.incration_id);
      }
      
      private function parseShotsData(js:String) : void
      {
         var obj:Object = null;
         var shotData:ShotData = null;
         var specialEntity:* = undefined;
         var parser:Object = JSON.parse(js);
         var models:IModelService = Main.osgi.getService(IModelService) as IModelService;
         var wwm:WeaponWeakeningModel = WeaponWeakeningModel(models.getModelsByInterface(IWeaponWeakeningModel)[0]);
         for each(obj in parser.weapons)
         {
            shotData = new ShotData(obj.reload);
            shotData.autoAimingAngleDown.value = obj.auto_aiming_down;
            shotData.autoAimingAngleUp.value = obj.auto_aiming_up;
            shotData.numRaysDown.value = obj.num_rays_down;
            shotData.numRaysUp.value = obj.num_rays_up;
            if(obj.has_wwd)
            {
               wwm.initObject(WeaponsManager.getObjectFor(obj.id),obj.max_damage_radius,obj.minimumDamagePercent,obj.minimumDamageRadius);
            }
            specialEntity = obj.special_entity;
            WeaponsManager.shotDatas[obj.id] = shotData;
            WeaponsManager.specialEntity[obj.id] = specialEntity;
         }
      }
      
      private function parseStopFire(user:ClientObject, firing:String) : void
      {
         var flamethrower:FlamethrowerModel = null;
         if(TankModel(Main.osgi.getService(ITank)) == null)
         {
            return;
         }
         var models:IModelService = Main.osgi.getService(IModelService) as IModelService;
         if(TankModel(Main.osgi.getService(ITank)) == null || activeTanks[user.id] as ClientObject == null)
         {
            return;
         }
         var td:TankData = TankModel(Main.osgi.getService(ITank)).getTankData(activeTanks[user.id] as ClientObject);
         if(td == null || td.turret == null || td.turret.id == null)
         {
            return;
         }
         var id:String = td.turret.id.split("_")[0];
         switch(id)
         {
            case "flamethrower":
               flamethrower = Main.osgi.getService(IFlamethrower) as FlamethrowerModel;
               flamethrower.stopFire(user,firing);
               break;
            case "isida":
               isidaModel.stopWeapon(user,firing);
               break;
            case "frezee":
               frezeeModel.stopFire(user,firing);
               break;
            case "frezeeny":
               frezeeNYModel.stopFire(user,firing);
         }
      }
      
      private function parseStartFire(user:ClientObject, firing:String, argsJSON:String) : void
      {
         var id:String = null;
         var models:IModelService = null;
         id = null;
         var railgun:RailgunModel = null;
         var flamethrower:FlamethrowerModel = null;
         var action:IsisAction = null;
         var parser:Object = null;
         models = Main.osgi.getService(IModelService) as IModelService;
         if(TankModel(Main.osgi.getService(ITank)) == null || activeTanks[user.id] as ClientObject == null)
         {
            return;
         }
         var td:TankData = TankModel(Main.osgi.getService(ITank)).getTankData(activeTanks[user.id] as ClientObject);
         if(td == null || td.turret == null || td.turret.id == null)
         {
            return;
         }
         id = td.turret.id.split("_")[0];
         try
         {
            switch(id)
            {
               case "railgun":
                  railgun = models.getModelsByInterface(IRailgunModelBase)[0] as RailgunModel;
                  railgun.startFire(user,firing);
                  break;
               case "railgunxt":
                  railgun = models.getModelsByInterface(IRailgunModelBase)[0] as RailgunModel;
                  railgun.startFire(user,firing);
                  break;
               case "flamethrower":
                  flamethrower = Main.osgi.getService(IFlamethrower) as FlamethrowerModel;
                  flamethrower.startFire(user,firing);
                  break;
               case "isida":
                  action = new IsisAction();
                  parser = JSON.parse(argsJSON);
                  action.shooterId = parser.shooterId;
                  action.targetId = parser.targetId;
                  action.type = IsisActionType.getType(parser.type);
                  isidaModel.startWeapon(user,action);
                  break;
               case "frezee":
                  frezeeModel.startFire(user,firing);
                  break;
               case "frezeeny":
                  frezeeNYModel.startFire(user,firing);
                  break;
               case "ricochet":
                  parser = JSON.parse(argsJSON);
                  ricochetModel.fire(user,firing,parser.x,parser.y,parser.z);
                  break;
               case "pumpkingun":
                  parser = JSON.parse(argsJSON);
                  pumpkinModel.fire(user,firing,parser.x,parser.y,parser.z);
            }
         }
         catch(e:Error)
         {
            trace("Error parsing fire! Known specs:");
            trace("ID: " + id);
            trace("Firing: " + firing);
            trace("Args: " + argsJSON);
            trace(e.getStackTrace().replace("Error",""));
         }
      }
      
      private function parseFire(user:ClientObject, js:String) : void
      {
         var parser:Object = null;
         var td:TankData = null;
         var targetInc:Array = null;
         var hitPoints:Array = null;
         var targets:Array = null;
         var targetPostitions:Array = null;
         var i:int = 0;
         var railgun_xt:RailgunModel = null;
         var railgun_cs:RailgunModel = null;
         var doubleShot:Boolean = false;
         var terminator:TerminatorModel = null;
         parser = null;
         td = null;
         targetInc = null;
         hitPoints = null;
         targets = null;
         targetPostitions = null;
         var railgun:RailgunModel = null;
         var hitPoint:Vector3d = null;
         var smoky:SmokyModel = null;
         var hitPos:Vector3d = null;
         var shaftModel:ShaftModel = null;
         var ids:Array = null;
         var static_point:Vector3 = null;
         i = 0;
         var obj:Object = null;
         var objj:Object = null;
         parser = null;
         try
         {
            parser = JSON.parse(js);
         }
         catch(e:Error)
         {
            return;
         }
         td = TankModel(Main.osgi.getService(ITank)).getTankData(activeTanks[user.id] as ClientObject);
         if(td == null || td.turret == null || td.turret.id == null)
         {
            return;
         }
         var id:String = td.turret.id.split("_")[0];
         switch(id)
         {
            case "railgun":
               targetInc = parser.targetInc as Array;
               hitPoints = parser.hitPoints as Array;
               targets = parser.targets as Array;
               targetPostitions = parser.targetPostitions as Array;
               for(i = 0; i < hitPoints.length; i++)
               {
                  hitPoints[i] = this.objToVec3d(hitPoints[i]);
               }
               railgun = getWeaponController(td.turret) as RailgunModel;
               if(!railgun)
               {
                  return;
               }
               railgun.fire(user,user.id,hitPoints,targets);
               break;
            case "railgunxt":
               targetInc = parser.targetInc as Array;
               hitPoints = parser.hitPoints as Array;
               targets = parser.targets as Array;
               targetPostitions = parser.targetPostitions as Array;
               for(i = 0; i < hitPoints.length; i++)
               {
                  hitPoints[i] = this.objToVec3d(hitPoints[i]);
               }
               railgun = getWeaponController(td.turret) as RailgunModel;
               if(!railgun)
               {
                  return;
               }
               railgun.fire(user,user.id,hitPoints,targets);
               break;
            case "railgun_xt":
               targetInc = parser.targetInc as Array;
               hitPoints = parser.hitPoints as Array;
               targets = parser.targets as Array;
               targetPostitions = parser.targetPostitions as Array;
               for(i = 0; i < hitPoints.length; i++)
               {
                  hitPoints[i] = this.objToVec3d(hitPoints[i]);
               }
               railgun_xt = getWeaponController(td.turret) as RailgunModel;
               if(!railgun_xt)
               {
                  return;
               }
               railgun_xt.fire(user,user.id,hitPoints,targets);
               break;
            case "railgun_cs":
               targetInc = parser.targetInc as Array;
               hitPoints = parser.hitPoints as Array;
               targets = parser.targets as Array;
               targetPostitions = parser.targetPostitions as Array;
               for(i = 0; i < hitPoints.length; i++)
               {
                  hitPoints[i] = this.objToVec3d(hitPoints[i]);
               }
               railgun_cs = getWeaponController(td.turret) as RailgunModel;
               if(!railgun_cs)
               {
                  return;
               }
               railgun_cs.fire(user,user.id,hitPoints,targets);
               break;
            case "terminator":
               targetInc = parser.targetInc as Array;
               hitPoints = parser.hitPoints as Array;
               targets = parser.targets as Array;
               targetPostitions = parser.targetPostitions as Array;
               doubleShot = parser.double;
               for(i = 0; i < hitPoints.length; i++)
               {
                  hitPoints[i] = this.objToVec3d(hitPoints[i]);
               }
               terminator = getWeaponController(td.turret) as TerminatorModel;
               if(!terminator)
               {
                  return;
               }
               terminator.fire(user,user.id,hitPoints,targets,doubleShot);
               break;
            case "smoky":
               if(parser.hitPos != null)
               {
                  hitPoint = new Vector3d(parser.hitPos.x,parser.hitPos.y,parser.hitPos.z);
               }
               smoky = getWeaponController(td.turret) as SmokyModel;
               if(!smoky)
               {
                  return;
               }
               trace("do smoky.fire()");
               smoky.fire(user,user.id,hitPoint,parser.victimId,1);
               break;
            case "smokyxt":
               if(parser.hitPos != null)
               {
                  hitPoint = new Vector3d(parser.hitPos.x,parser.hitPos.y,parser.hitPos.z);
               }
               smoky = getWeaponController(td.turret) as SmokyModel;
               if(!smoky)
               {
                  return;
               }
               smoky.fire(user,user.id,hitPoint,parser.victimId,1);
               break;
            case "twins":
               twinsModel.hit(user,user.id,parser.shotId,new Vector3d(parser.hitPos.x,parser.hitPos.y,parser.hitPos.z),parser.victimId,0.3);
               break;
            case "twins_xt":
               twinsXTModel.hit(user,user.id,parser.shotId,new Vector3d(parser.hitPos.x,parser.hitPos.y,parser.hitPos.z),parser.victimId,0.3);
               break;
            case "twinsxt":
               twinsModel.hit(user,user.id,parser.shotId,new Vector3d(parser.hitPos.x,parser.hitPos.y,parser.hitPos.z),parser.victimId,0.3);
               break;
            case "thunder":
               if(parser.hitPos != null)
               {
                  hitPos = new Vector3d(parser.hitPos.x,parser.hitPos.y,parser.hitPos.z);
               }
               thunderModel.fire(user,user.id,hitPos,parser.mainTargetId,1,parser.splashTargetIds,null);
               break;
            case "thunder_xt":
               if(parser.hitPos != null)
               {
                  hitPos = new Vector3d(parser.hitPos.x,parser.hitPos.y,parser.hitPos.z);
               }
               thunderXTModel.fire(user,user.id,hitPos,parser.mainTargetId,1,parser.splashTargetIds,null);
               break;
            case "hwthunder":
               if(parser.hitPos != null)
               {
                  hitPos = new Vector3d(parser.hitPos.x,parser.hitPos.y,parser.hitPos.z);
               }
               hwthunderModel.fire(user,user.id,hitPos,parser.mainTargetId,1,parser.splashTargetIds,null);
               break;
            case "shaft":
               shaftModel = getWeaponController(td.turret) as ShaftModel;
               if(!shaftModel)
               {
                  return;
               }
               ids = new Array();
               if(parser.static_shot != null)
               {
                  static_point = new Vector3(parser.static_shot.x,parser.static_shot.y,parser.static_shot.z);
               }
               for each(obj in parser.targets)
               {
                  objj = obj.target;
                  ids.push(new ServerShaftTargetData(new Vector3(objj.pos.x,objj.pos.y,objj.pos.z),new Vector3(objj.point_pos.x,objj.point_pos.y,objj.point_pos.z),objj.id));
               }
               shaftModel.fire(user,static_point,ids);
               break;
            case "snowman":
               snowmanModel.hit(user,user.id,parser.shotId,new Vector3d(parser.hitPos.x,parser.hitPos.y,parser.hitPos.z),parser.victimId,0.3);
         }
      }
      
      private function objToVec3d(obj:Object) : Vector3d
      {
         return new Vector3d(obj.x,obj.y,obj.z);
      }
      
      private function parseSpawnBonus(js:String) : void
      {
         var parser:Object = JSON.parse(js);
         var objId:String = parser.id.split("_")[0];
         var bonus_obj:ClientObject = this.clientObjectBonuses[objId];
         if(bonus_obj == null)
         {
            bonus_obj = new ClientObject(objId,null,objId,null);
            this.clientObjectBonuses[objId] = bonus_obj;
         }
         BattlefieldModel(Main.osgi.getService(IBattleField)).addBonus(bonus_obj,parser.id,parser.id,new Vector3d(parser.x,parser.y,parser.z),parser.disappearing_time);
      }
      
      private function controlSmooth(js:String) : void
      {
         var parser:Object = JSON.parse(js);
         var turrDir:Number = parser.turretDir;
         var ctrlBits:int = parser.ctrlBits;
         if(activeTanks[parser.tank_id] != null)
         {
            TankModel(Main.osgi.getService(ITank)).setControlState(TankModel(Main.osgi.getService(ITank)).getTankData(activeTanks[parser.tank_id]),ctrlBits);
         }
      }
      
      private function tankSmooth(js:String) : void
      {
         var parser:Object = JSON.parse(js);
         var pos:Vector3d = new Vector3d(0,0,0);
         var orient:Vector3d = new Vector3d(0,0,0);
         var line:Vector3d = new Vector3d(0,0,0);
         var ange:Vector3d = new Vector3d(0,0,0);
         pos.x = parser.position.x;
         pos.y = parser.position.y;
         pos.z = parser.position.z;
         orient.x = parser.orient.x;
         orient.y = parser.orient.y;
         orient.z = parser.orient.z;
         line.x = parser.line.x;
         line.y = parser.line.y;
         line.z = parser.line.z;
         ange.x = parser.angle.x;
         ange.y = parser.angle.y;
         ange.z = parser.angle.z;
         var turrDir:Number = parser.turretDir;
         var ctrlBits:int = parser.ctrlBits;
         if(activeTanks[parser.tank_id] != null)
         {
            TankModel(Main.osgi.getService(ITank)).move(activeTanks[parser.tank_id] as ClientObject,pos,orient,line,ange,turrDir,ctrlBits,false);
         }
      }
      
      private function tracePing(ping:Number) : void
      {
         if(this.testLabelPing == null)
         {
            this.testLabelPing = new Label();
            this.testLabelPing.filters = [new GlowFilter()];
            Main.systemUILayer.addChild(this.testLabelPing);
         }
         this.testLabelPing.text = "ping: " + ping;
         this.testLabelPing.x = 15;
         this.testLabelPing.y = 100;
      }
      
      private function removeUser(s:String) : void
      {
         TankModel(Main.osgi.getService(ITank)).objectUnloaded(activeTanks[s]);
         activeTanks[s] = null;
      }
      
      private function onChatMessage(json:String) : void
      {
         var parser:Object = JSON.parse(json);
         if(!parser.system)
         {
            ChatModel(Main.osgi.getService(IChatBattle)).addMessage(null,null,parser.message,BattleTeamType.getType(parser.team_type),parser.team,parser.nickname,parser.rank,parser.chat_level);
         }
         else
         {
            ChatModel(Main.osgi.getService(IChatBattle)).addSystemMessage(null,parser.message);
         }
      }
      
      private function moveTank(js:String) : void
      {
         var parser:Object = JSON.parse(js);
         var pos:Vector3d = new Vector3d(0,0,0);
         var orient:Vector3d = new Vector3d(0,0,0);
         var line:Vector3d = new Vector3d(0,0,0);
         var ange:Vector3d = new Vector3d(0,0,0);
         pos.x = parser.position.x;
         pos.y = parser.position.y;
         pos.z = parser.position.z;
         orient.x = parser.orient.x;
         orient.y = parser.orient.y;
         orient.z = parser.orient.z;
         line.x = parser.line.x;
         line.y = parser.line.y;
         line.z = parser.line.z;
         ange.x = parser.angle.x;
         ange.y = parser.angle.y;
         ange.z = parser.angle.z;
         var turrDir:Number = parser.turretDir;
         var ctrlBits:int = parser.ctrlBits;
         if(activeTanks[parser.tank_id] != null)
         {
            TankModel(Main.osgi.getService(ITank)).move(activeTanks[parser.tank_id] as ClientObject,pos,orient,line,ange,turrDir,ctrlBits,true);
         }
      }
      
      private function initTank(js:String) : void
      {
         var state:TankState = null;
         var json:Object = JSON.parse(js);
         var tankParts:TankParts = new TankParts();
         tankParts.coloringObjectId = json.colormap_id;
         tankParts.hullObjectId = json.hull_id;
         tankParts.turretObjectId = json.turret_id;
         var spec:TankSpecification = new TankSpecification();
         spec.speed = json.speed;
         spec.turnSpeed = json.turn_speed;
         spec.turretRotationSpeed = json.turret_turn_speed;
         var position:Vector3d = new Vector3d(0,0,0);
         var temp:Array = String(json.position).split("@");
         position.x = int(temp[0]);
         position.y = int(temp[1]);
         position.z = int(temp[2]);
         if(!json.state_null)
         {
            state = new TankState();
            state.health = json.health;
            state.orientation = new Vector3d(0,0,temp[3]);
            state.position = position;
            state.turretAngle = 0;
         }
         var clientTank:ClientTank = new ClientTank();
         clientTank.health = json.health;
         clientTank.incarnationId = json.icration;
         clientTank.self = json.tank_id == client.id;
         var stateSpawn:String = json.state;
         clientTank.spawnState = stateSpawn == "newcome" ? TankSpawnState.NEWCOME : (stateSpawn == "active" ? TankSpawnState.ACTIVE : (stateSpawn == "suicide" ? TankSpawnState.SUICIDE : TankSpawnState.ACTIVE));
         clientTank.tankSpecification = spec;
         clientTank.tankState = state;
         clientTank.teamType = BattleTeamType.getType(json.team_type);
         this.myTank = clientTank;
         var tankModelService:TankModel = Main.osgi.getService(ITank) as TankModel;
         if(clientTank.self)
         {
            localTankInited = true;
         }
         activeTanks[json.tank_id] = this.initClientObject(json.tank_id,json.tank_id);
         tankModelService.initObject(activeTanks[json.tank_id],json.battleId,json.mass,json.power,null,tankParts,null,json.impact_force,json.kickback,json.turret_rotation_accel,json.turret_turn_speed,json.nickname,json.rank,tankParts.turretObjectId);
         tankModelService.initTank(activeTanks[json.tank_id],clientTank,tankParts,localTankInited);
      }
      
      private function initBattle(js:String) : void
      {
         var s:String = null;
         this.initLocalClientObject(PanelModel(Main.osgi.getService(IPanel)).userName,PanelModel(Main.osgi.getService(IPanel)).userName);
         var json:Object = JSON.parse(js);
         var soundsParams:BattlefieldSoundScheme = new BattlefieldSoundScheme();
         soundsParams.ambientSound = json.sound_id;
         var gameMode:IGameMode = GameModes.getGameMode(json.game_mode);
         var skyboxId:* = json.skybox_id;
         var nightMode:Boolean = IStorageService(Main.osgi.getService(IStorageService)).getStorage().data["night_mode"];
         if(nightMode != null)
         {
            if(nightMode && json.game_mode == "day")
            {
               gameMode = GameModes.getGameMode("ny");
               skyboxId = "skybox40";
            }
         }
         var resources:Vector.<String> = new Vector.<String>();
         for each(s in json.resources)
         {
            resources.push(s);
         }
         if(json.spectator)
         {
            TankData.localTankData = new TankData();
         }
         this.battle.bm.initObject(client,null,soundsParams,json.kick_period_ms,json.map_id,json.invisible_time,skyboxId,json.spectator,gameMode,resources);
      }
      
      public function initClientObject(id:String, name:String) : ClientObject
      {
         var clientClass:ClientClass = new ClientClass(id,null,name);
         return new ClientObject(id,clientClass,name,null);
      }
      
      private function initLocalClientObject(id:String, name:String) : void
      {
         var clientClass:ClientClass = new ClientClass(id,null,name);
         var clientObject:ClientObject = new ClientObject(id,clientClass,name,null);
         client = clientObject;
      }
      
      public function destroy() : void
      {
         var t:* = undefined;
         BattlefieldModel(Main.osgi.getService(IBattleField)).spectatorMode = false;
         localTankInited = false;
         this.clientObjectBonuses = new Array();
         BonusCache.destroy();
         for each(t in activeTanks)
         {
            TankModel(Main.osgi.getService(ITank)).objectUnloadedFully(t as ClientObject,true);
         }
         if(this.graffitiModel != null)
         {
            this.graffitiModel.objectUnloaded(null);
            this.graffitiModel = null;
         }
      }
   }
}
