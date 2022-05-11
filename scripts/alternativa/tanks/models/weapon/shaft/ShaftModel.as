package alternativa.tanks.models.weapon.shaft
{
   import alternativa.engine3d.core.Object3D;
   import alternativa.engine3d.core.RayIntersectionData;
   import alternativa.engine3d.materials.TextureMaterial;
   import alternativa.init.Main;
   import alternativa.math.Matrix4;
   import alternativa.math.Vector3;
   import alternativa.model.IObjectLoadListener;
   import alternativa.object.ClientObject;
   import alternativa.physics.Body;
   import alternativa.physics.collision.types.RayIntersection;
   import alternativa.service.IModelService;
   import alternativa.tanks.camera.GameCamera;
   import alternativa.tanks.models.battlefield.BattlefieldModel;
   import alternativa.tanks.models.battlefield.IBattleField;
   import alternativa.tanks.models.battlefield.Object3DNames;
   import alternativa.tanks.models.tank.ITank;
   import alternativa.tanks.models.tank.TankData;
   import alternativa.tanks.models.tank.TankModel;
   import alternativa.tanks.models.weapon.AllGlobalGunParams;
   import alternativa.tanks.models.weapon.IWeaponController;
   import alternativa.tanks.models.weapon.WeaponConst;
   import alternativa.tanks.models.weapon.WeaponUtils;
   import alternativa.tanks.models.weapon.common.IWeaponCommonModel;
   import alternativa.tanks.models.weapon.common.WeaponCommonData;
   import alternativa.tanks.models.weapon.shaft.modes.TargetingController;
   import alternativa.tanks.models.weapon.shaft.quickshot.ShaftShotResult;
   import alternativa.tanks.models.weapon.shaft.quickshot.ShaftTargetSystem;
   import alternativa.tanks.models.weapon.shaft.sfx.ShaftSFXModel;
   import alternativa.tanks.models.weapon.shaft.states.ShaftModes;
   import alternativa.tanks.models.weapon.shared.shot.ShotData;
   import alternativa.tanks.models.weapon.weakening.IWeaponWeakeningModel;
   import alternativa.tanks.physics.CollisionGroup;
   import alternativa.tanks.physics.TanksCollisionDetector;
   import alternativa.tanks.utils.MathUtils;
   import alternativa.tanks.vehicles.tanks.Tank;
   import alternativa.tanks.vehicles.tanks.TankSkin;
   import com.alternativaplatform.projects.tanks.client.commons.types.Vector3d;
   import com.alternativaplatform.projects.tanks.client.models.tank.TankSpawnState;
   import com.alternativaplatform.projects.tanks.client.warfare.models.tankparts.weapon.gun.IGunModelBase;
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.utils.Dictionary;
   import flash.utils.getTimer;
   import scpacker.networking.INetworker;
   import scpacker.networking.Network;
   import scpacker.server.models.shaft.ServerShaftTargetData;
   import scpacker.tanks.WeaponsManager;
   
   public class ShaftModel implements IGunModelBase, IObjectLoadListener, IWeaponController
   {
      
      private static var _barrelOrigin:Vector3 = new Vector3();
      
      private static const _origin:Vector3 = new Vector3();
      
      private static const _direction:Vector3 = new Vector3();
      
      private static const _m:Matrix4 = new Matrix4();
      
      private static const _p:Vector3 = new Vector3();
      
      private static const _closestBarrelOrigin:Vector3 = new Vector3();
      
      private static const thousand:int = 1000;
      
      private static const allGunParams:AllGlobalGunParams = new AllGlobalGunParams();
      
[Embed(source="1097.png")]
      private static const decal:Class;
      
      private static var decalMaterial:TextureMaterial = new TextureMaterial(new decal().bitmapData);
       
      
      private var _hitPos:Vector3;
      
      private var _hitPosLocal:Vector3;
      
      private var _hitPosGlobal:Vector3;
      
      private var _gunDirGlobal:Vector3;
      
      private var _muzzlePosGlobal:Vector3;
      
      private var _xAxis:Vector3;
      
      private var _hitPos3d:Vector3d;
      
      private var _tankPos3d:Vector3d;
      
      private var weaponUtils:WeaponUtils;
      
      private var tank:Tank;
      
      private var localTankData:TankData;
      
      private var localShotData:ShotData;
      
      private var localWeaponCommonData:WeaponCommonData;
      
      private var modelService:IModelService;
      
      private var battlefieldModel:BattlefieldModel;
      
      private var tankModel:TankModel;
      
      private var weaponWeakeningModel:IWeaponWeakeningModel;
      
      private var collisionDetector:TanksCollisionDetector;
      
      private var weaponCommonModel:IWeaponCommonModel;
      
      private var maxTargetingDistance:Number = 100000;
      
      private var pressed:Boolean = false;
      
      private var image:Bitmap;
      
      private var activate:Boolean = false;
      
      private var activatedTime:Number = 0;
      
      private var indicator:Indicator;
      
      private var targetController:TargetingController;
      
      private var updateController:Boolean = false;
      
      private var lock:Boolean = false;
      
      private var indicatorBitmap:Bitmap;
      
      private var lockCheckIntersection:Boolean;
      
      private var energyAdditive:Number = 1000;
      
      private var energySpeed:Number = -250;
      
      private var energyBaseTime:int;
      
      private var exitTime:int;
      
      private var fired:Boolean;
      
      private var energyMode:ShaftEnergyMode;
      
      public var shaftData:ShaftData;
      
      private var exclusionSet:Dictionary;
      
      private var exclusionSetController:SetControllerForTemporaryItems;
      
      private var multybodyPredicate:MultybodyCollisionPredicate;
      
      private var intersection:RayIntersection;
      
      private var quickShotTargetSystem:ShaftTargetSystem;
      
      private var shotResult:ShaftShotResult;
      
      private var commonModel:IWeaponCommonModel;
      
      private var quickShot:Boolean;
      
      private var tempRayResult:RayIntersection;
      
      public function ShaftModel()
      {
         this._hitPos = new Vector3();
         this._hitPosLocal = new Vector3();
         this._hitPosGlobal = new Vector3();
         this._gunDirGlobal = new Vector3();
         this._muzzlePosGlobal = new Vector3();
         this._xAxis = new Vector3();
         this._hitPos3d = new Vector3d(0,0,0);
         this._tankPos3d = new Vector3d(0,0,0);
         this.weaponUtils = WeaponUtils.getInstance();
         this.energyMode = ShaftEnergyMode.RECHARGE;
         this.shaftData = new ShaftData();
         this.multybodyPredicate = new MultybodyCollisionPredicate();
         this.intersection = new RayIntersection();
         this.quickShotTargetSystem = new ShaftTargetSystem();
         this.shotResult = new ShaftShotResult();
         this.tempRayResult = new RayIntersection();
         super();
      }
      
      public static function globalToLocal(param1:Body, param2:Vector3) : void
      {
         param2.vSubtract(param1.state.pos);
         param2.vTransformBy3Tr(param1.baseMatrix);
      }
      
      public static function localToGlobal(param1:Body, param2:Vector3) : void
      {
         param2.vTransformBy3(param1.baseMatrix);
         param2.vAdd(param1.state.pos);
      }
      
      private static function getShotDirection(param1:Vector3, param2:Vector3, param3:Vector3) : Vector3
      {
         if(param2 != null)
         {
            return new Vector3().vDiff(param2,param1).vNormalize();
         }
         if(param3 == null)
         {
            param3 = allGunParams.direction;
         }
         return new Vector3().vDiff(param3,param1).vNormalize();
      }
      
      private static function getClosestBarrelOrigin(param1:Vector3, param2:Vector.<Vector3>, param3:Vector3) : void
      {
         var _loc6_:Number = NaN;
         _barrelOrigin.vCopy(param2[0]);
         _barrelOrigin.y = 0;
         param3.vCopy(_barrelOrigin);
         var _loc4_:Number = param1.distanceToSquared(_barrelOrigin);
         var _loc5_:int = 1;
         while(_loc5_ < param2.length)
         {
            _barrelOrigin.vCopy(param2[_loc5_]);
            _barrelOrigin.y = 0;
            _loc6_ = param1.distanceToSquared(_barrelOrigin);
            if(_loc6_ < _loc4_)
            {
               _loc4_ = _loc6_;
               param3.vCopy(_barrelOrigin);
            }
            _loc5_++;
         }
      }
      
      public function initObject(clientObject:ClientObject, maxEnegry:Number, chargeRate:Number, dischargeRate:Number, elevationAngleUp:Number, elevationAngleDown:Number, verticalTargetingSpeed:Number, horizontalTargetingSpeed:Number, initialFOV:Number, minimumFOV:Number, shrubsHidingRadiusMin:Number, shrubsHidingRadiusMax:Number, impactQuickShot:Number) : void
      {
         var shaftData:ShaftData = new ShaftData();
         shaftData.maxEnergy = maxEnegry;
         shaftData.chargeRate = chargeRate;
         shaftData.dischargeRate = dischargeRate;
         shaftData.elevationAngleUp = elevationAngleUp;
         shaftData.elevationAngleDown = elevationAngleDown;
         shaftData.verticalTargetingSpeed = verticalTargetingSpeed;
         shaftData.horizontalTargetingSpeed = horizontalTargetingSpeed;
         shaftData.initialFOV = initialFOV;
         shaftData.minimumFOV = minimumFOV;
         shaftData.shrubsHidingRadiusMin = shrubsHidingRadiusMin;
         shaftData.shrubsHidingRadiusMax = shrubsHidingRadiusMax;
         shaftData.impactQuickShot = impactQuickShot * WeaponConst.BASE_IMPACT_FORCE;
         clientObject.putParams(ShaftData,shaftData);
         this.objectLoaded(null);
      }
      
      public function objectLoaded(object:ClientObject) : void
      {
         if(this.modelService == null)
         {
            this.modelService = IModelService(Main.osgi.getService(IModelService));
            this.battlefieldModel = Main.osgi.getService(IBattleField) as BattlefieldModel;
            this.tankModel = Main.osgi.getService(ITank) as TankModel;
            this.weaponCommonModel = Main.osgi.getService(IWeaponCommonModel) as IWeaponCommonModel;
            this.weaponWeakeningModel = IWeaponWeakeningModel(this.modelService.getModelsByInterface(IWeaponWeakeningModel)[0]);
            this.commonModel = Main.osgi.getService(IWeaponCommonModel) as IWeaponCommonModel;
            (this.battlefieldModel as BattlefieldModel).blacklist.push(decalMaterial.getTextureResource());
            this.exclusionSet = this.battlefieldModel.bfData.viewport.shaftRaycastExcludedObjects;
            this.exclusionSetController = new SetControllerForTemporaryItems(this.exclusionSet);
            this.collisionDetector = TanksCollisionDetector(this.battlefieldModel.bfData.physicsScene.collisionDetector);
         }
      }
      
      public function setEnergyMode(mode:ShaftEnergyMode) : void
      {
         var physTime:int = 0;
         var energy:Number = NaN;
         if(this.battlefieldModel == null || this.battlefieldModel.bfData == null)
         {
            return;
         }
         if(mode != this.energyMode)
         {
            physTime = this.battlefieldModel.bfData.physTime;
            energy = this.getEnergy(physTime);
            this.doSetEnergyMode(mode,energy,physTime);
         }
      }
      
      public function objectUnloaded(object:ClientObject) : void
      {
      }
      
      private function startTargetMode() : void
      {
      }
      
      private function stopTargetMode() : void
      {
      }
      
      public function update(param1:int, param2:int) : Number
      {
         var _loc3_:int = 0;
         var _loc4_:Vector3 = null;
         var _loc5_:WeaponCommonData = null;
         var _loc6_:Tank = null;
         var _loc7_:BitmapData = null;
         var _loc8_:GameCamera = null;
         if(this.tank == null)
         {
            this.tank = TankData.localTankData.tank;
         }
         if(this.activate && TankData.localTankData.spawnState == TankSpawnState.ACTIVE)
         {
            this.activatedTime += param2;
         }
         else
         {
            if(TankData.localTankData.spawnState == TankSpawnState.ACTIVE && this.activatedTime > 0 && this.activatedTime < 300)
            {
               this.quickShot = true;
            }
            this.activatedTime = 0;
         }
         if(this.activatedTime >= 300)
         {
            _loc3_ = this.getEnergy(param1);
            if(!this.lock && _loc3_ == 1000 && param1 >= this.exitTime && (!(this.tank.leftTrack.lastContactsNum == 0 && this.tank.rightTrack.lastContactsNum == 0) || !this.hasIntersection()))
            {
               this.updateController = true;
               this.updateCrossPosition();
               Main.stage.addChild(this.image);
               this.targetController.camera = this.battlefieldModel.bfData.viewport.camera;
               this.targetController.skin = TankData.localTankData.tank.skin;
               this.targetController.cameraController.setAnchorObject(TankData.localTankData.tank.skin.turretMesh);
               _loc4_ = new Vector3();
               _loc5_ = this.commonModel.getCommonData(TankData.localTankData.turret);
               TankData.localTankData.tank.getBarrelOrigin(_loc4_,_loc5_.muzzles);
               this.targetController.cameraController.setLocalPosition(_loc4_);
               this.targetController.cameraController.elevation = 0;
               this.targetController.cameraController.elevationDirection = 0;
               this.targetController.enter(param1);
               _loc6_ = TankData.localTankData.tank;
               _loc6_.title.hide();
               _loc7_ = _loc6_.title.getTexture();
               this.indicatorBitmap = new Bitmap(_loc7_);
               _loc8_ = this.battlefieldModel.bfData.viewport.camera;
               this.indicatorBitmap.x = Main.stage.stageWidth - this.indicatorBitmap.width >> 1;
               this.indicatorBitmap.y = Main.stage.stageHeight / 2 + this.indicatorBitmap.height * 2;
               Main.stage.addChild(this.indicatorBitmap);
               this.lock = true;
               this.fired = false;
               this.lockCheckIntersection = true;
               this.exitTime = -1;
               this.sendStartAimCommand();
            }
         }
         else if(this.quickShot)
         {
            _loc3_ = this.getEnergy(param1);
            if(_loc3_ == 1000)
            {
               this.onQuickShot();
            }
            this.quickShot = false;
         }
         else if(this.fired)
         {
            this.activatedTime = 0;
            if(this.exitTime > 0)
            {
               if(param1 >= this.exitTime)
               {
                  if(Main.stage.contains(this.image))
                  {
                     Main.stage.removeChild(this.image);
                     Main.stage.removeChild(this.indicatorBitmap);
                     _loc6_ = TankData.localTankData.tank;
                     _loc6_.title.show();
                     this.battlefieldModel.activateFollowCamera();
                     this.battlefieldModel.resetFollowCamera();
                     this.targetController.exit();
                     this.updateController = false;
                     this.lock = false;
                     this.lockCheckIntersection = false;
                     this.fired = false;
                  }
               }
            }
         }
         else if(Main.stage.contains(this.image))
         {
            this.setEnergyMode(ShaftEnergyMode.RECHARGE);
            this.performAimedShot(1000);
            this.exitTime = getTimer() + 500;
            this.fired = true;
         }
         if(this.updateController)
         {
            this.updateCrossPosition();
            this.indicatorBitmap.x = Main.stage.stageWidth - this.indicatorBitmap.width >> 1;
            this.indicatorBitmap.y = Main.stage.stageHeight / 2 + this.indicatorBitmap.height * 2;
            this.targetController.update(param1,param2);
            if(!(!(this.tank.leftTrack.lastContactsNum == 0 && this.tank.rightTrack.lastContactsNum == 0) || !this.hasIntersection()))
            {
               this.forceExit(param1);
            }
         }
         return this.getStatus();
      }
      
      private function forceExit(time:int) : void
      {
         if(Main.stage.contains(this.image))
         {
            this.activatedTime = 0;
            Main.stage.removeChild(this.image);
            Main.stage.removeChild(this.indicatorBitmap);
            this.tank.title.show();
            this.battlefieldModel.activateFollowCamera();
            this.battlefieldModel.resetFollowCamera();
            this.targetController.exit();
            this.updateController = false;
            this.lock = false;
            this.lockCheckIntersection = false;
            this.fired = false;
            this.doSetEnergyMode(ShaftEnergyMode.RECHARGE,Math.min(this.getEnergy(time),0),time);
            this.targetController.shaftMode = ShaftModes.TARGET_DEACTIVATION;
         }
      }
      
      private function sendQuickShotCommand(result:ShaftShotResult) : void
      {
         Network(Main.osgi.getService(INetworker)).send("battle;quick_shot_shaft;" + result.toJSON());
         trace("battle;quick_shot_shaft;" + result.toJSON());
      }
      
      private function sendStartAimCommand() : void
      {
         Network(Main.osgi.getService(INetworker)).send("battle;start_fire");
      }
      
      private function sendStopAimCommand(physTime:int, staticShot:Vector3, aims:Array) : void
      {
         var json:Object = new Object();
         json.phys_time = physTime;
         json.static_shot = staticShot;
         json.targets = aims;
         json.energy = this.getEnergy(this.battlefieldModel.bfData.physTime);
         Network(Main.osgi.getService(INetworker)).send("battle;fire;" + JSON.stringify(json,function(k:*, v:*):*
         {
            var aim:* = undefined;
            var pointPos:* = undefined;
            if(v is Aim)
            {
               aim = v as Aim;
               pointPos = aim.targetHitPoint.vClone();
               globalToLocal(aim.target,pointPos);
               return {"target":{
                  "id":aim.target.tankData.userName,
                  "pos":aim.targetHitPoint,
                  "point_pos":pointPos
               }};
            }
            return v;
         }));
         trace("battle;fire;" + JSON.stringify(json,function(k:*, v:*):*
         {
            var aim:* = undefined;
            var pointPos:* = undefined;
            if(v is Aim)
            {
               aim = v as Aim;
               pointPos = aim.targetHitPoint.vClone();
               globalToLocal(aim.target,pointPos);
               return {"target":{
                  "id":aim.target.tankData.userName,
                  "pos":aim.targetHitPoint,
                  "point_pos":pointPos
               }};
            }
            return v;
         }));
      }
      
      private function onQuickShot() : void
      {
         var i:int = 0;
         var target:TankData = null;
         var currTank:Tank = null;
         var tankData:TankData = TankData.localTankData;
         var commonData:WeaponCommonData = this.commonModel.getCommonData(tankData.turret);
         var shaftSFX:ShaftSFXModel = WeaponsManager.getShaftSFX(WeaponsManager.getObjectFor(TankData.localTankData.turret.id));
         this.weaponUtils.calculateGunParams(tankData.tank.skin.turretMesh,commonData.muzzles[0],allGunParams.muzzlePosition,_barrelOrigin,this._xAxis,allGunParams.direction);
         this.quickShotTargetSystem.getTargets(tankData,_barrelOrigin,allGunParams.direction,this._xAxis,this.battlefieldModel.getBattlefieldData().tanks,this.shotResult);
         if(this.shotResult.hitPoints.length == 0)
         {
            trace("shot v nikuda");
         }
         else if(this.shotResult.targets.length == 0)
         {
            trace("shot on static");
            this.createStaticShotEffect(tankData.user,this.shotResult.hitPoints[0] as Vector3,allGunParams.direction);
            this.battlefieldModel.addDecal(this.shotResult.hitPoints[0] as Vector3,allGunParams.muzzlePosition,50,decalMaterial);
         }
         else
         {
            for(i = 0; i < this.shotResult.targets.length; i++)
            {
               target = this.shotResult.targets[i];
               trace("quick shot: " + target.userName);
               currTank = target.tank;
               this.createTankShotEffect(tankData.user,this.shotResult.hitPoints[i],allGunParams.direction);
               currTank.addWorldForceScaled(this.shotResult.hitPoints[i],allGunParams.direction,this.shaftData.impactQuickShot);
            }
            if(this.shotResult.hitPoints.length > this.shotResult.targets.length)
            {
               trace("shot on static");
               this.createStaticShotEffect(tankData.user,this.shotResult.hitPoints[this.shotResult.targets.length] as Vector3,allGunParams.direction);
               this.battlefieldModel.addDecal(this.shotResult.hitPoints[this.shotResult.targets.length] as Vector3,allGunParams.muzzlePosition,50,decalMaterial);
            }
         }
         trace(this.shotResult.toJSON());
         shaftSFX.createMuzzleFlashEffect(tankData.turret,tankData.tank.skin.turretDescriptor.shaftMuzzle,tankData.tank.skin.turretMesh);
         shaftSFX.createShotSoundEffect(tankData.turret,tankData.user,allGunParams.muzzlePosition);
         TankData.localTankData.tank.addWorldForceScaled(allGunParams.muzzlePosition,allGunParams.direction,-commonData.kickback);
         this.doSetEnergyMode(ShaftEnergyMode.RECHARGE,0,this.battlefieldModel.bfData.physTime);
         this.sendQuickShotCommand(this.shotResult);
      }
      
      [ServerData]
      public function quickFire(param1:ClientObject, param2:Array, param3:Array, param4:Vector3) : void
      {
         var _loc9_:Vector3 = null;
         var _loc10_:int = 0;
         var _loc11_:Vector3 = null;
         var _loc12_:TankData = null;
         var _loc13_:Tank = null;
         var _loc5_:TankData = this.tankModel.getTankData(param1);
         if(_loc5_ == TankData.localTankData)
         {
            return;
         }
         if(param2 == null || param3 == null)
         {
            return;
         }
         if(this.commonModel == null)
         {
            this.commonModel = Main.osgi.getService(IWeaponCommonModel) as IWeaponCommonModel;
         }
         var _loc6_:WeaponCommonData = this.commonModel.getCommonData(_loc5_.turret);
         var _loc7_:ShaftData = _loc5_.turret.getParams(ShaftData) as ShaftData;
         this.weaponUtils.calculateGunParamsAux(_loc5_.tank.skin.turretMesh,_loc6_.muzzles[0],allGunParams.muzzlePosition,allGunParams.direction);
         var _loc8_:ShaftSFXModel = WeaponsManager.getShaftSFX(WeaponsManager.getObjectFor(_loc5_.turret.id));
         _loc8_.createMuzzleFlashEffect(_loc5_.turret,_loc5_.tank.skin.turretDescriptor.shaftMuzzle,_loc5_.tank.skin.turretMesh);
         _loc5_.tank.addWorldForceScaled(allGunParams.muzzlePosition,allGunParams.direction,-_loc6_.kickback);
         if(param3.length == 0)
         {
            return;
         }
         if(param2.length == 0)
         {
            _loc9_ = new Vector3(param3[0].x,param3[0].y,param3[0].z);
            this.createStaticShotEffect(_loc5_.user,_loc9_,allGunParams.direction);
            this.battlefieldModel.addDecal(_loc9_,allGunParams.muzzlePosition,50,decalMaterial);
         }
         else
         {
            for(_loc10_ = 0; _loc10_ < param2.length; _loc10_++)
            {
               _loc11_ = new Vector3(param3[_loc10_].x,param3[_loc10_].y,param3[_loc10_].z);
               _loc12_ = this.tankModel.getTankData(BattleController.activeTanks[param2[_loc10_].target_id]);
               _loc13_ = _loc12_.tank;
               this.createTankShotEffect(_loc5_.user,_loc11_,allGunParams.direction);
               _loc13_.addWorldForceScaled(_loc11_,allGunParams.direction,_loc7_.impactQuickShot);
            }
            if(param3.length > param2.length)
            {
               _loc9_ = new Vector3(param3[param2.length].x,param3[param2.length].y,param3[param2.length].z);
               this.createStaticShotEffect(_loc5_.user,_loc9_,allGunParams.direction);
               this.battlefieldModel.addDecal(_loc9_,allGunParams.muzzlePosition,50,decalMaterial);
            }
         }
      }
      
      [ServerData]
      public function fire(user:ClientObject, staticHit:Vector3, targets:Array) : void
      {
         var target:ServerShaftTargetData = null;
         var targetTankPos:Vector3 = null;
         var targetTank:TankData = null;
         var firringTank:TankData = this.tankModel.getTankData(user);
         if(firringTank == TankData.localTankData)
         {
            return;
         }
         if(this.commonModel == null)
         {
            this.commonModel = Main.osgi.getService(IWeaponCommonModel) as IWeaponCommonModel;
         }
         var commonData:WeaponCommonData = this.commonModel.getCommonData(firringTank.turret);
         this.weaponUtils.calculateGunParamsAux(firringTank.tank.skin.turretMesh,commonData.muzzles[0],allGunParams.muzzlePosition,allGunParams.direction);
         var effects:ShaftSFXModel = WeaponsManager.getShaftSFX(WeaponsManager.getObjectFor(firringTank.turret.id));
         effects.createMuzzleFlashEffect(firringTank.turret,firringTank.tank.skin.turretDescriptor.shaftMuzzle,firringTank.tank.skin.turretMesh);
         for(var i:int = 0; i < targets.length; i++)
         {
            target = targets[i];
            targetTank = this.tankModel.getTankData(BattleController.activeTanks[target.targetId]);
            if(targetTank != null)
            {
               targetTankPos = targetTank.tank.state.pos;
            }
            localToGlobal(targetTank.tank,target.globalHitPoint);
            this.createTankShotEffect(firringTank.user,target.globalHitPoint,allGunParams.direction);
            targetTank.tank.addWorldForceScaled(target.globalHitPoint,allGunParams.direction,commonData.impactForce);
         }
         if(staticHit != null)
         {
            this.createStaticShotEffect(firringTank.user,staticHit,allGunParams.direction);
            this.battlefieldModel.addDecal(staticHit,allGunParams.muzzlePosition,50,decalMaterial);
         }
         effects.createShotSoundEffect(firringTank.turret,firringTank.user,allGunParams.muzzlePosition);
      }
      
      public function performAimedShot(param1:Number) : void
      {
         var a:Object = null;
         var currTank:Tank = null;
         var commonData:WeaponCommonData = this.weaponCommonModel.getCommonData(TankData.localTankData.turret);
         var shaftSFX:ShaftSFXModel = WeaponsManager.getShaftSFX(WeaponsManager.getObjectFor(TankData.localTankData.turret.id));
         var _loc2_:int = this.battlefieldModel.bfData.physTime;
         shaftSFX.stopManualSound(TankData.localTankData.user);
         this.localTankData.tank.getAllGunParams(allGunParams,commonData.muzzles);
         var result:AimedShotResult = this.getAimedShotTargets();
         this.targetController.cameraController.readCameraDirection(_direction);
         var _loc4_:Number = param1 - this.getEnergy(_loc2_);
         for(var i:int = 0; i < result.aims.length; i++)
         {
            a = result.aims[i];
            this.createTankShotEffect(TankData.localTankData.user,a.targetHitPoint,_direction);
            currTank = a.target;
            currTank.addWorldForceScaled(a.targetHitPoint,_direction,commonData.impactForce);
         }
         if(result.staticHitPoint != null)
         {
            this.createStaticShotEffect(TankData.localTankData.user,result.staticHitPoint,_direction);
            this.battlefieldModel.addDecal(result.staticHitPoint,allGunParams.muzzlePosition,50,decalMaterial);
         }
         shaftSFX.createShotSoundEffect(TankData.localTankData.turret,TankData.localTankData.user,allGunParams.muzzlePosition);
         TankData.localTankData.tank.addWorldForceScaled(allGunParams.muzzlePosition,allGunParams.direction,-commonData.kickback);
         this.sendStopAimCommand(_loc2_,result.staticHitPoint,result.aims);
         this.doSetEnergyMode(ShaftEnergyMode.RECHARGE,Math.min(this.getEnergy(_loc2_),0),_loc2_);
         this.targetController.shaftMode = ShaftModes.TARGET_DEACTIVATION;
      }
      
      private function createTankShotEffect(user:ClientObject, point:Vector3, dir:Vector3) : void
      {
         var tankData:TankData = this.tankModel.getTankData(user);
         if(this.commonModel == null)
         {
            this.commonModel = Main.osgi.getService(IWeaponCommonModel) as IWeaponCommonModel;
         }
         var commonData:WeaponCommonData = this.commonModel.getCommonData(tankData.turret);
         this.weaponUtils.calculateGunParamsAux(tankData.tank.skin.turretMesh,commonData.muzzles[0],allGunParams.muzzlePosition,allGunParams.direction);
         var effects:ShaftSFXModel = WeaponsManager.getShaftSFX(WeaponsManager.getObjectFor(tankData.turret.id));
         effects.createHitPointsGraphicEffects(tankData.turret,tankData.user,null,point,allGunParams.muzzlePosition,allGunParams.direction,dir);
      }
      
      private function createStaticShotEffect(user:ClientObject, point:Vector3, dir:Vector3) : void
      {
         var tankData:TankData = this.tankModel.getTankData(user);
         if(this.commonModel == null)
         {
            this.commonModel = Main.osgi.getService(IWeaponCommonModel) as IWeaponCommonModel;
         }
         var commonData:WeaponCommonData = this.commonModel.getCommonData(tankData.turret);
         this.weaponUtils.calculateGunParamsAux(tankData.tank.skin.turretMesh,commonData.muzzles[0],allGunParams.muzzlePosition,allGunParams.direction);
         var effects:ShaftSFXModel = WeaponsManager.getShaftSFX(WeaponsManager.getObjectFor(tankData.turret.id));
         effects.createHitPointsGraphicEffects(tankData.turret,tankData.user,point,null,allGunParams.muzzlePosition,allGunParams.direction,dir);
      }
      
      public function hasIntersection() : Boolean
      {
         var object:Object3D = null;
         var commonData:WeaponCommonData = this.weaponCommonModel.getCommonData(TankData.localTankData.turret);
         this.localTankData.tank.getAllGunParams(allGunParams,commonData.muzzles);
         var tankPos:Vector3 = TankData.localTankData.tank.state.pos;
         _direction.vDiff(allGunParams.barrelOrigin,tankPos);
         this.exclusionSetController.addTemporaryItem(this.localTankData.tank.skin.turretMesh);
         this.exclusionSetController.addTemporaryItem(this.localTankData.tank.skin.hullMesh);
         var rayData:RayIntersectionData = this.battlefieldModel.raycast(tankPos,_direction,this.exclusionSet);
         trace(_direction);
         trace(allGunParams.barrelOrigin);
         trace(commonData.muzzles);
         if(rayData != null && rayData.time <= 1)
         {
            object = rayData.object;
            trace("hasIntersection " + object.name);
            this.exclusionSetController.deleteAllTemporaryItems();
            return object.name == Object3DNames.STATIC;
         }
         this.exclusionSetController.deleteAllTemporaryItems();
         trace("hasIntersection " + false);
         return false;
      }
      
      private function getAimedShotTargets() : AimedShotResult
      {
         var data:RayIntersectionData = null;
         var aim:Object3D = null;
         var hitPoint:Vector3 = null;
         var target:Tank = null;
         var result:AimedShotResult = new AimedShotResult();
         this.targetController.cameraController.readCameraPosition(_origin);
         this.targetController.cameraController.readCameraDirection(_direction);
         this.addTankSkinToExclusionSet(this.localTankData.tank.skin);
         while(true)
         {
            data = this.battlefieldModel.raycast(_origin,_direction,this.exclusionSet);
            if(data == null)
            {
               break;
            }
            aim = data.object;
            hitPoint = _origin.vClone().vAddScaled(data.time + 0.1,_direction);
            if(aim.name == Object3DNames.STATIC)
            {
               result.setStaticHitPoint(hitPoint);
               break;
            }
            if(aim.name == Object3DNames.TANK_PART)
            {
               target = this.battlefieldModel.objects2tank[aim];
               if(this.isValidHit(target,aim,hitPoint))
               {
                  result.setTarget(target,hitPoint);
               }
               this.addTankSkinToExclusionSet(target.skin);
            }
            else
            {
               this.exclusionSetController.addTemporaryItem(aim);
            }
            _origin.vCopy(hitPoint);
         }
         this.exclusionSetController.deleteAllTemporaryItems();
         return result;
      }
      
      private function isValidHit(param1:Tank, param2:Object3D, param3:Vector3) : Boolean
      {
         var commonData:WeaponCommonData = null;
         var _loc4_:TankSkin = param1.skin;
         if(_loc4_.turretMesh == param2)
         {
            _m.setMatrix(param2.x,param2.y,param2.z,param2.rotationX,param2.rotationY,param2.rotationZ);
            _m.transformVectorInverse(param3,_p);
            commonData = this.weaponCommonModel.getCommonData(param1.tankData.turret);
            getClosestBarrelOrigin(_p,commonData.muzzles,_closestBarrelOrigin);
            _m.transformVector(_closestBarrelOrigin,_p);
            _p.vSubtract(param3);
            if(this.battlefieldModel.bfData.collisionDetector.hasStaticHit(param3,_p,CollisionGroup.STATIC,1))
            {
               return false;
            }
         }
         return _loc4_.hullMesh.alpha == 1;
      }
      
      private function addTankSkinToExclusionSet(param1:TankSkin) : void
      {
         this.exclusionSetController.addTemporaryItem(param1.hullMesh);
         this.exclusionSetController.addTemporaryItem(param1.turretMesh);
      }
      
      public function targetModeOn() : void
      {
         this.tankModel.lockControls(true);
         this.tankModel.applyControlState(TankData.localTankData,0,true);
         this.tankModel.setControlState(TankData.localTankData,0,true);
         var shaftSFX:ShaftSFXModel = WeaponsManager.getShaftSFX(WeaponsManager.getObjectFor(TankData.localTankData.turret.id));
         shaftSFX.createManualModeEffects(TankData.localTankData.turret,TankData.localTankData.user,TankData.localTankData.tank.skin.turretMesh);
      }
      
      public function getStatus() : Number
      {
         return this.getEnergy(getTimer()) / this.shaftData.maxEnergy;
      }
      
      public function doSetEnergyMode(mode:ShaftEnergyMode, energy:Number, physTime:int) : void
      {
         this.energyMode = mode;
         switch(mode)
         {
            case ShaftEnergyMode.RECHARGE:
               this.energyAdditive = 0;
               this.energySpeed = this.shaftData.chargeRate;
               this.energyBaseTime = physTime - energy / this.energySpeed * thousand;
               break;
            case ShaftEnergyMode.DRAIN:
               this.energyAdditive = this.shaftData.maxEnergy;
               this.energySpeed = -this.shaftData.dischargeRate;
               this.energyBaseTime = physTime + (this.shaftData.maxEnergy - energy) / this.energySpeed * thousand;
               this.sendBeginEnergyDrain(physTime);
         }
      }
      
      private function sendBeginEnergyDrain(time:int) : void
      {
         Network(Main.osgi.getService(INetworker)).send("battle;begin_enegry_drain;" + time);
      }
      
      public function getEnergy(energyTime:Number) : Number
      {
         var enegry:Number = this.energyAdditive + (energyTime - this.energyBaseTime) * this.energySpeed / thousand;
         return MathUtils.clamp(enegry,0,this.shaftData.maxEnergy);
      }
      
      private function updateCrossPosition() : void
      {
         this.image.x = Main.stage.stageWidth - this.image.width >> 1;
         this.image.y = Main.stage.stageHeight - this.image.height >> 1;
      }
      
      public function stopEffects(ownerTankData:TankData) : void
      {
         var tank:Tank = null;
         if(TankData.localTankData == ownerTankData)
         {
            if(Main.stage.contains(this.image))
            {
               Main.stage.removeChild(this.image);
               Main.stage.removeChild(this.indicatorBitmap);
               tank = TankData.localTankData.tank;
               tank.title.show();
               this.battlefieldModel.activateFollowCamera();
               this.battlefieldModel.resetFollowCamera();
               this.targetController.exit();
               this.setEnergyMode(ShaftEnergyMode.RECHARGE);
               this.targetController.deactivationTask.stop();
            }
            this.updateController = false;
            this.lock = false;
            this.lockCheckIntersection = false;
            this.fired = false;
            this.battlefieldModel.onResize(null);
         }
      }
      
      public function reset() : void
      {
         this.doSetEnergyMode(ShaftEnergyMode.RECHARGE,this.shaftData.maxEnergy,this.battlefieldModel.bfData.physTime);
         if(TankData.localTankData == null)
         {
            return;
         }
         var shaftSFX:ShaftSFXModel = WeaponsManager.getShaftSFX(WeaponsManager.getObjectFor(TankData.localTankData.turret.id));
         shaftSFX.stopManualSound(TankData.localTankData.user);
         this.lockCheckIntersection = false;
      }
      
      public function setLocalUser(localUserData:TankData) : void
      {
         this.objectLoaded(null);
         this.localTankData = localUserData;
         this.localShotData = WeaponsManager.shotDatas[localUserData.turret.id];
         this.localWeaponCommonData = this.weaponCommonModel.getCommonData(localUserData.turret);
         trace(this.localShotData.autoAimingAngleUp.value,this.localShotData.numRaysUp.value,this.localShotData.autoAimingAngleDown.value,this.localShotData.numRaysDown.value);
         this.quickShotTargetSystem.setParams(this.battlefieldModel.getBattlefieldData().physicsScene.collisionDetector,this.localShotData.autoAimingAngleUp.value,this.localShotData.numRaysUp.value,this.localShotData.autoAimingAngleDown.value,this.localShotData.numRaysDown.value,1,null);
         this.shaftData = localUserData.turret.getParams(ShaftData) as ShaftData;
         this.image = new Bitmap(Indicator.getIndicator(localUserData.turret));
         this.targetController = new TargetingController(this);
         this.reset();
      }
      
      public function clearLocalUser() : void
      {
      }
      
      public function activateWeapon(time:int) : void
      {
         this.activate = true;
      }
      
      public function deactivateWeapon(time:int, sendServerCommand:Boolean) : void
      {
         this.activate = false;
      }
      
      public function get targetingController() : TargetingController
      {
         return this.targetController;
      }
   }
}

import alternativa.physics.Body;
import alternativa.physics.collision.IRayCollisionPredicate;
import flash.utils.Dictionary;

class MultybodyCollisionPredicate implements IRayCollisionPredicate
{
    
   
   public var bodies:Dictionary;
   
   function MultybodyCollisionPredicate()
   {
      this.bodies = new Dictionary();
      super();
   }
   
   public function considerBody(body:Body) : Boolean
   {
      return this.bodies[body] == null;
   }
}
