package alternativa.tanks.models.weapon.terminator
{
   import alternativa.engine3d.materials.TextureMaterial;
   import alternativa.init.Main;
   import alternativa.math.Vector3;
   import alternativa.model.IModel;
   import alternativa.model.IObjectLoadListener;
   import alternativa.object.ClientObject;
   import alternativa.service.IModelService;
   import alternativa.tanks.models.battlefield.BattlefieldData;
   import alternativa.tanks.models.battlefield.BattlefieldModel;
   import alternativa.tanks.models.battlefield.IBattleField;
   import alternativa.tanks.models.ctf.ICTFModel;
   import alternativa.tanks.models.sfx.shoot.railgun.IRailgunSFXModel;
   import alternativa.tanks.models.tank.ITank;
   import alternativa.tanks.models.tank.TankData;
   import alternativa.tanks.models.weapon.IWeaponController;
   import alternativa.tanks.models.weapon.WeaponConst;
   import alternativa.tanks.models.weapon.WeaponUtils;
   import alternativa.tanks.models.weapon.common.IWeaponCommonModel;
   import alternativa.tanks.models.weapon.common.WeaponCommonData;
   import alternativa.tanks.models.weapon.shared.shot.ShotData;
   import alternativa.tanks.sfx.IGraphicEffect;
   import alternativa.tanks.sfx.ISound3DEffect;
   import com.alternativaplatform.projects.tanks.client.commons.types.Vector3d;
   import com.alternativaplatform.projects.tanks.client.models.tank.TankSpawnState;
   import com.alternativaplatform.projects.tanks.client.warfare.models.tankparts.weapon.terminator.ITerminatorModelBase;
   import com.alternativaplatform.projects.tanks.client.warfare.models.tankparts.weapon.terminator.TerminatorModelBase;
   import com.reygazu.anticheat.variables.SecureInt;
   import scpacker.networking.INetworker;
   import scpacker.networking.Network;
   import scpacker.tanks.WeaponsManager;
   
   public class TerminatorModel extends TerminatorModelBase implements IModel, ITerminatorModelBase, IWeaponController, IObjectLoadListener
   {
      
      private static const DECAL_RADIUS:Number = 50;
      
      private static const DECAL:Class = TerminatorModel_DECAL;
      
      private static var decalMaterial:TextureMaterial;
       
      
      private const INFINITY:Number = 20000;
      
      private var modelService:IModelService;
      
      private var battlefieldModel:BattlefieldModel;
      
      private var tankModel:ITank;
      
      private var commonModel:IWeaponCommonModel;
      
      private var localTankData:TankData;
      
      private var localShotData:ShotData;
      
      private var localTerminatorData:TerminatorData;
      
      private var localWeaponCommonData:WeaponCommonData;
      
      private var weaponUtils:WeaponUtils;
      
      private var _triggerPressed:Boolean;
      
      private var chargeTimeLeft:SecureInt;
      
      private var nextReadyTime:SecureInt;
      
      private var targetSystem:TerminatorTargetSystem;
      
      private var shotResult:TerminatorShotResult;
      
      private var _globalHitPosition:Vector3;
      
      private var _xAxis:Vector3;
      
      private var _globalMuzzlePosition:Vector3;
      
      private var _globalGunDirection:Vector3;
      
      private var _barrelOrigin:Vector3;
      
      private var _hitPos3d:Vector3d;
      
      private var targetPositions:Array;
      
      private var targetIncarnations:Array;
      
      private var firstshot = true;
      
      private var shotBarrel:int = 0;
      
      private var activatedTime:Number = 0;
      
      private var quickShot:Boolean;
      
      private var lock:Boolean = false;
      
      private var double:Boolean = false;
      
      private var defaultReloadMsec:int = 1;
      
      public function TerminatorModel()
      {
         this.weaponUtils = WeaponUtils.getInstance();
         this.chargeTimeLeft = new SecureInt("chargeTimeLeft.value terminator");
         this.nextReadyTime = new SecureInt("chargeTimeLeft.value terminator");
         this.targetSystem = new TerminatorTargetSystem();
         this.shotResult = new TerminatorShotResult();
         this._globalHitPosition = new Vector3();
         this._xAxis = new Vector3();
         this._globalMuzzlePosition = new Vector3();
         this._globalGunDirection = new Vector3();
         this._barrelOrigin = new Vector3();
         this._hitPos3d = new Vector3d(0,0,0);
         this.targetPositions = [];
         this.targetIncarnations = [];
         super();
         _interfaces.push(IModel,ITerminatorModelBase,IWeaponController,IObjectLoadListener);
         this.objectLoaded(null);
         if(decalMaterial == null)
         {
            decalMaterial = new TextureMaterial(new DECAL().bitmapData);
         }
      }
      
      public function objectLoaded(clientObject:ClientObject) : void
      {
         if(this.commonModel == null)
         {
            this.modelService = Main.osgi.getService(IModelService) as IModelService;
            this.battlefieldModel = Main.osgi.getService(IBattleField) as BattlefieldModel;
            this.tankModel = Main.osgi.getService(ITank) as ITank;
            this.commonModel = Main.osgi.getService(IWeaponCommonModel) as IWeaponCommonModel;
         }
      }
      
      public function objectUnloaded(clientObject:ClientObject) : void
      {
      }
      
      public function initObject(clientObject:ClientObject, chargingTimeMsec:int, weakeningCoeff:Number) : void
      {
         var terminatorData:TerminatorData = new TerminatorData();
         terminatorData.chargingTime = chargingTimeMsec;
         terminatorData.weakeningCoeff = weakeningCoeff;
         clientObject.putParams(TerminatorModel,terminatorData);
         this.battlefieldModel.blacklist.push(decalMaterial.getTextureResource());
         this.objectLoaded(clientObject);
      }
      
      public function startFire(clientObject:ClientObject, firingTankId:String, barrel:int) : void
      {
         var firingTank:ClientObject = clientObject;
         if(firingTank == null)
         {
            return;
         }
         if(this.tankModel == null)
         {
            this.tankModel = Main.osgi.getService(ITank) as ITank;
         }
         var firingTankData:TankData = this.tankModel.getTankData(firingTank);
         if(firingTankData.tank == null || !firingTankData.enabled || firingTankData.local)
         {
            return;
         }
         if(this.commonModel == null)
         {
            this.commonModel = Main.osgi.getService(IWeaponCommonModel) as IWeaponCommonModel;
         }
         var commonData:WeaponCommonData = this.commonModel.getCommonData(firingTankData.turret);
         this.shotBarrel = barrel;
         this.weaponUtils.calculateGunParamsAux(firingTankData.tank.skin.turretMesh,commonData.muzzles[barrel],this._globalMuzzlePosition,this._globalGunDirection);
         var terminatorSfxModel:IRailgunSFXModel = WeaponsManager.getTerminatorSFX(firingTankData.turret);
         var terminatorData:TerminatorData = this.getTerminatorData(firingTankData.turret);
         var graphicEffect:IGraphicEffect = terminatorSfxModel.createChargeEffect(firingTankData.turret,firingTankData.user,commonData.muzzles[barrel],firingTankData.tank.skin.turretMesh,terminatorData.chargingTime);
         if(this.battlefieldModel == null)
         {
            this.battlefieldModel = Main.osgi.getService(IBattleField) as BattlefieldModel;
         }
         if(this.firstshot)
         {
            this.firstshot = false;
            this.battlefieldModel.addGraphicEffect(graphicEffect);
            graphicEffect = terminatorSfxModel.createChargeEffect(firingTankData.turret,firingTankData.user,commonData.muzzles[barrel],firingTankData.tank.skin.turretMesh,terminatorData.chargingTime);
         }
         this.battlefieldModel.addGraphicEffect(graphicEffect);
         var soundEffect:ISound3DEffect = terminatorSfxModel.createSoundShotEffect(firingTankData.turret,firingTankData.user,this._globalMuzzlePosition);
         if(soundEffect != null)
         {
            this.battlefieldModel.addSound3DEffect(soundEffect);
         }
      }
      
      public function fire(clientObject:ClientObject, firingTankId:String, affectedPoints:Array, affectedTankIds:Array, doubleShot:Boolean) : void
      {
         var firingTankData:TankData = null;
         var v:Vector3d = null;
         var graphicEffect:IGraphicEffect = null;
         var i:int = 0;
         var affectedTankObject:ClientObject = null;
         var affectedTankData:TankData = null;
         var firingTank:ClientObject = clientObject;
         if(firingTank == null)
         {
            return;
         }
         firingTankData = this.tankModel.getTankData(firingTank);
         if(firingTankData == null || firingTankData.tank == null || !firingTankData.enabled || firingTankData.local)
         {
            return;
         }
         if(this.commonModel == null)
         {
            this.commonModel = Main.osgi.getService(IWeaponCommonModel) as IWeaponCommonModel;
         }
         if(this.battlefieldModel == null)
         {
            this.battlefieldModel = Main.osgi.getService(IBattleField) as BattlefieldModel;
         }
         var commonData:WeaponCommonData = this.commonModel.getCommonData(firingTankData.turret);
         var terminatorData:TerminatorData = this.getTerminatorData(firingTankData.turret);
         this.weaponUtils.calculateGunParamsAux(firingTankData.tank.skin.turretMesh,commonData.muzzles[this.shotBarrel],this._globalMuzzlePosition,this._globalGunDirection);
         var numPoints:int = affectedPoints.length;
         var impactForce:Number = commonData.impactForce;
         if(affectedTankIds != null)
         {
            for(i = 0; i < numPoints - 1; i++)
            {
               affectedTankObject = BattleController.activeTanks[affectedTankIds[i]];
               if(affectedTankObject != null)
               {
                  affectedTankData = this.tankModel.getTankData(affectedTankObject);
                  if(!(affectedTankData == null || affectedTankData.tank == null))
                  {
                     v = affectedPoints[i];
                     this._globalHitPosition.x = v.x;
                     this._globalHitPosition.y = v.y;
                     this._globalHitPosition.z = v.z;
                     this._globalHitPosition.vTransformBy3(affectedTankData.tank.baseMatrix);
                     this._globalHitPosition.vAdd(affectedTankData.tank.state.pos);
                     affectedTankData.tank.addWorldForceScaled(this._globalHitPosition,this._globalGunDirection,!!doubleShot ? Number(impactForce / 1.5) : Number(impactForce));
                     this.battlefieldModel.tankHit(affectedTankData,this._globalGunDirection,impactForce / WeaponConst.BASE_IMPACT_FORCE);
                     impactForce *= terminatorData.weakeningCoeff;
                  }
               }
            }
         }
         v = affectedPoints[numPoints - 1];
         this._globalHitPosition.x = v.x;
         this._globalHitPosition.y = v.y;
         this._globalHitPosition.z = v.z;
         this.battlefieldModel.addDecal(this._globalHitPosition,this._globalMuzzlePosition,DECAL_RADIUS,decalMaterial);
         firingTankData.tank.addWorldForceScaled(this._globalMuzzlePosition,this._globalGunDirection,!!doubleShot ? Number(-commonData.kickback / 1.5) : Number(-commonData.kickback));
         var terminatorSfxModel:IRailgunSFXModel = WeaponsManager.getTerminatorSFX(firingTankData.turret);
         var angle:Number = this._globalHitPosition.vClone().vRemove(this._globalMuzzlePosition).vNormalize().vCosAngle(this._globalGunDirection);
         if(angle < 0)
         {
            trace("Adding inversed ray");
            graphicEffect = terminatorSfxModel.createGraphicShotEffect(firingTankData.turret,this._globalMuzzlePosition,this._globalMuzzlePosition.vClone().vScale(2).vRemove(this._globalHitPosition));
         }
         else
         {
            graphicEffect = terminatorSfxModel.createGraphicShotEffect(firingTankData.turret,this._globalMuzzlePosition,this._globalHitPosition);
         }
         if(graphicEffect != null)
         {
            this.battlefieldModel.addGraphicEffect(graphicEffect);
         }
      }
      
      public function activateWeapon(time:int) : void
      {
         this._triggerPressed = true;
      }
      
      public function deactivateWeapon(time:int, sendServerCommand:Boolean) : void
      {
         this._triggerPressed = false;
      }
      
      public function setLocalUser(localUserData:TankData) : void
      {
         this.localTankData = localUserData;
         this.localShotData = WeaponsManager.shotDatas[localUserData.turret.id];
         this.defaultReloadMsec = this.localShotData.reloadMsec.value;
         this.localTerminatorData = this.getTerminatorData(localUserData.turret);
         this.localWeaponCommonData = this.commonModel.getCommonData(localUserData.turret);
         this.battlefieldModel = Main.osgi.getService(IBattleField) as BattlefieldModel;
         this.targetSystem.setParams(this.battlefieldModel.getBattlefieldData().physicsScene.collisionDetector,this.localShotData.autoAimingAngleUp.value,this.localShotData.numRaysUp.value,this.localShotData.autoAimingAngleDown.value,this.localShotData.numRaysDown.value,this.localTerminatorData.weakeningCoeff,null);
         this.reset();
         var muzzleLocalPos:Vector3 = this.localWeaponCommonData.muzzles[this.localWeaponCommonData.currBarrel];
         var terminatorSfxModel:IRailgunSFXModel = WeaponsManager.getTerminatorSFX(this.localTankData.turret);
         var graphicEffect:IGraphicEffect = terminatorSfxModel.createChargeEffect(this.localTankData.turret,this.localTankData.user,muzzleLocalPos,this.localTankData.tank.skin.turretMesh,this.localTerminatorData.chargingTime);
         if(graphicEffect != null)
         {
            this.battlefieldModel.addGraphicEffect(graphicEffect);
         }
      }
      
      public function clearLocalUser() : void
      {
         this.localTankData = null;
         this.localShotData = null;
         this.localTerminatorData = null;
         this.localWeaponCommonData = null;
      }
      
      public function update(param1:int, param2:int) : Number
      {
         var _loc3_:Vector3 = null;
         var _loc4_:IRailgunSFXModel = null;
         var _loc5_:IGraphicEffect = null;
         var _loc6_:ISound3DEffect = null;
         var _loc7_:Vector3 = null;
         var _loc8_:IGraphicEffect = null;
         if(this.chargeTimeLeft.value > 0)
         {
            this.chargeTimeLeft.value -= param2;
            if(this.chargeTimeLeft.value <= 0)
            {
               this.chargeTimeLeft.value = 0;
               if(this.double)
               {
                  this.doFire(this.localWeaponCommonData,this.localTankData,param1,true);
                  this.doFire(this.localWeaponCommonData,this.localTankData,param1,true);
                  this.double = false;
               }
               else
               {
                  this.doFire(this.localWeaponCommonData,this.localTankData,param1,false);
               }
            }
            return this.chargeTimeLeft.value / this.localTerminatorData.chargingTime;
         }
         if(param1 < this.nextReadyTime.value)
         {
            return 1 - (this.nextReadyTime.value - param1) / this.localShotData.reloadMsec.value;
         }
         if(this._triggerPressed && TankData.localTankData.spawnState == TankSpawnState.ACTIVE && param1 > this.nextReadyTime.value)
         {
            this.activatedTime += param2;
         }
         else
         {
            if(TankData.localTankData.spawnState == TankSpawnState.ACTIVE && this.activatedTime > 0 && this.activatedTime < 1000)
            {
               this.quickShot = true;
            }
            this.activatedTime = 0;
         }
         if(this.activatedTime >= 1000)
         {
            if(!this.lock)
            {
               this.double = true;
               this.chargeTimeLeft.value = this.localTerminatorData.chargingTime;
               _loc3_ = this.localWeaponCommonData.muzzles[this.localWeaponCommonData.currBarrel];
               this.weaponUtils.calculateGunParams(this.localTankData.tank.skin.turretMesh,_loc3_,this._globalMuzzlePosition,this._barrelOrigin,this._xAxis,this._globalGunDirection);
               _loc4_ = WeaponsManager.getTerminatorSFX(this.localTankData.turret);
               _loc5_ = _loc4_.createChargeEffect(this.localTankData.turret,this.localTankData.user,_loc3_,this.localTankData.tank.skin.turretMesh,this.localTerminatorData.chargingTime);
               if(_loc5_ != null)
               {
                  this.battlefieldModel.addGraphicEffect(_loc5_);
               }
               _loc6_ = _loc4_.createSoundShotEffect(this.localTankData.turret,this.localTankData.user,this._globalMuzzlePosition);
               if(_loc6_ != null)
               {
                  this.battlefieldModel.addSound3DEffect(_loc6_);
               }
               this.startFireCommand(this.localTankData.turret,this.localWeaponCommonData.currBarrel);
               this.localWeaponCommonData.currBarrel = (this.localWeaponCommonData.currBarrel + 1) % this.localWeaponCommonData.muzzles.length;
               _loc7_ = this.localWeaponCommonData.muzzles[this.localWeaponCommonData.currBarrel];
               this.weaponUtils.calculateGunParams(this.localTankData.tank.skin.turretMesh,_loc7_,this._globalMuzzlePosition,this._barrelOrigin,this._xAxis,this._globalGunDirection);
               _loc8_ = _loc4_.createChargeEffect(this.localTankData.turret,this.localTankData.user,_loc7_,this.localTankData.tank.skin.turretMesh,this.localTerminatorData.chargingTime);
               if(_loc8_ != null)
               {
                  this.battlefieldModel.addGraphicEffect(_loc8_);
               }
               this.startFireCommand(this.localTankData.turret,this.localWeaponCommonData.currBarrel);
               this.localShotData.reloadMsec.value = this.defaultReloadMsec * 1.75;
               this.activatedTime = 0;
            }
         }
         else if(this.quickShot)
         {
            this.chargeTimeLeft.value = this.localTerminatorData.chargingTime;
            _loc3_ = this.localWeaponCommonData.muzzles[this.localWeaponCommonData.currBarrel];
            this.weaponUtils.calculateGunParams(this.localTankData.tank.skin.turretMesh,_loc3_,this._globalMuzzlePosition,this._barrelOrigin,this._xAxis,this._globalGunDirection);
            _loc4_ = WeaponsManager.getTerminatorSFX(this.localTankData.turret);
            _loc5_ = _loc4_.createChargeEffect(this.localTankData.turret,this.localTankData.user,_loc3_,this.localTankData.tank.skin.turretMesh,this.localTerminatorData.chargingTime);
            if(_loc5_ != null)
            {
               this.battlefieldModel.addGraphicEffect(_loc5_);
            }
            _loc6_ = _loc4_.createSoundShotEffect(this.localTankData.turret,this.localTankData.user,this._globalMuzzlePosition);
            if(_loc6_ != null)
            {
               this.battlefieldModel.addSound3DEffect(_loc6_);
            }
            this.startFireCommand(this.localTankData.turret,this.localWeaponCommonData.currBarrel);
            if(this.localShotData.reloadMsec.value > this.defaultReloadMsec)
            {
               this.localShotData.reloadMsec.value /= 1.75;
            }
            this.quickShot = false;
            this.activatedTime = 0;
         }
         return 1;
      }
      
      private function startFireCommand(turr:ClientObject, currBarrel:int) : void
      {
         var jsobject:Object = new Object();
         jsobject.currBarrel = currBarrel;
         Network(Main.osgi.getService(INetworker)).send("battle;start_fire;" + JSON.stringify(jsobject));
      }
      
      public function reset() : void
      {
         this.activatedTime = 0;
         this.chargeTimeLeft.value = 0;
         this.nextReadyTime.value = 0;
         this._triggerPressed = false;
      }
      
      public function stopEffects(ownerTankData:TankData) : void
      {
      }
      
      private function getTerminatorData(clientObject:ClientObject) : TerminatorData
      {
         return clientObject.getParams(TerminatorModel) as TerminatorData;
      }
      
      private function doFire(commonData:WeaponCommonData, tankData:TankData, time:int, double:Boolean) : void
      {
         var graphicEffect:IGraphicEffect = null;
         var len:int = 0;
         var i:int = 0;
         var currHitPoint:Vector3 = null;
         var currTankData:TankData = null;
         var v:Vector3 = null;
         this.nextReadyTime.value = time + this.localShotData.reloadMsec.value;
         this.weaponUtils.calculateGunParams(tankData.tank.skin.turretMesh,commonData.muzzles[commonData.currBarrel],this._globalMuzzlePosition,this._barrelOrigin,this._xAxis,this._globalGunDirection);
         var bfData:BattlefieldData = this.battlefieldModel.getBattlefieldData();
         this.targetSystem.getTargets(tankData,this._barrelOrigin,this._globalGunDirection,this._xAxis,bfData.tanks,this.shotResult);
         if(this.shotResult.hitPoints.length == 0)
         {
            this._globalHitPosition.x = this._hitPos3d.x = this._globalMuzzlePosition.x + this.INFINITY * this._globalGunDirection.x;
            this._globalHitPosition.y = this._hitPos3d.y = this._globalMuzzlePosition.y + this.INFINITY * this._globalGunDirection.y;
            this._globalHitPosition.z = this._hitPos3d.z = this._globalMuzzlePosition.z + this.INFINITY * this._globalGunDirection.z;
            this.fireCommand(tankData.turret,null,[this._hitPos3d],null,null,this.localWeaponCommonData.currBarrel,double);
            this.localWeaponCommonData.currBarrel = (this.localWeaponCommonData.currBarrel + 1) % this.localWeaponCommonData.muzzles.length;
         }
         else
         {
            this._globalHitPosition.vCopy(this.shotResult.hitPoints[this.shotResult.hitPoints.length - 1]);
            if(this.shotResult.hitPoints.length == this.shotResult.targets.length)
            {
               this._globalHitPosition.vSubtract(this._globalMuzzlePosition).vNormalize().vScale(this.INFINITY).vAdd(this._globalMuzzlePosition);
               this.shotResult.hitPoints.push(this._globalHitPosition);
            }
            this.shotResult.hitPoints[this.shotResult.hitPoints.length - 1] = new Vector3d(this._globalHitPosition.x,this._globalHitPosition.y,this._globalHitPosition.z);
            this.targetPositions.length = 0;
            this.targetIncarnations.length = 0;
            len = this.shotResult.targets.length;
            for(i = 0; i < len; i++)
            {
               currHitPoint = this.shotResult.hitPoints[i];
               currTankData = this.shotResult.targets[i];
               currTankData.tank.addWorldForceScaled(currHitPoint,this.shotResult.dir,!!double ? Number(commonData.impactForce / 1.5) : Number(commonData.impactForce));
               this.shotResult.targets[i] = currTankData.user.id;
               currHitPoint.vSubtract(currTankData.tank.state.pos).vTransformBy3Tr(currTankData.tank.baseMatrix);
               this.shotResult.hitPoints[i] = new Vector3d(currHitPoint.x,currHitPoint.y,currHitPoint.z);
               v = currTankData.tank.state.pos;
               this.targetPositions[i] = new Vector3d(v.x,v.y,v.z);
               this.targetIncarnations[i] = currTankData.incarnation;
            }
            if(len == 0)
            {
               this.battlefieldModel.addDecal(Vector3d(this.shotResult.hitPoints[0]).toVector3(),this._barrelOrigin,DECAL_RADIUS,decalMaterial);
            }
            else
            {
               this.battlefieldModel.addDecal(this._globalHitPosition,this._barrelOrigin,DECAL_RADIUS,decalMaterial);
            }
            this.fireCommand(tankData.turret,this.targetIncarnations,this.shotResult.hitPoints,this.shotResult.targets,this.targetPositions,this.localWeaponCommonData.currBarrel,double);
            this.localWeaponCommonData.currBarrel = (this.localWeaponCommonData.currBarrel + 1) % this.localWeaponCommonData.muzzles.length;
         }
         tankData.tank.addWorldForceScaled(this._globalMuzzlePosition,this._globalGunDirection,!!double ? Number(-commonData.kickback / 1.5) : Number(-commonData.kickback));
         var terminatorSfxModel:IRailgunSFXModel = WeaponsManager.getTerminatorSFX(tankData.turret);
         var angle:Number = this._globalHitPosition.vClone().vRemove(this._globalMuzzlePosition).vNormalize().vCosAngle(this._globalGunDirection);
         if(angle < 0)
         {
            graphicEffect = terminatorSfxModel.createGraphicShotEffect(tankData.turret,this._globalMuzzlePosition,this._globalMuzzlePosition.vClone().vScale(2).vRemove(this._globalHitPosition));
         }
         else
         {
            graphicEffect = terminatorSfxModel.createGraphicShotEffect(tankData.turret,this._globalMuzzlePosition,this._globalHitPosition);
         }
         if(graphicEffect != null)
         {
            this.battlefieldModel.addGraphicEffect(graphicEffect);
         }
      }
      
      public function fireCommand(turret:ClientObject, targetInc:Array, hitPoints:Array, targets:Array, targetPostitions:Array, currBarrel:int, double:Boolean) : void
      {
         var firstHitPoints:Vector3d = hitPoints[0] as Vector3d;
         var jsobject:Object = new Object();
         jsobject.hitPoints = hitPoints;
         jsobject.targetInc = targetInc;
         jsobject.targets = targets;
         jsobject.currBarrel = currBarrel;
         jsobject.double = double;
         jsobject.targetPostitions = targetPostitions;
         jsobject.reloadTime = this.localShotData.reloadMsec.value;
         Network(Main.osgi.getService(INetworker)).send("battle;fire;" + JSON.stringify(jsobject));
      }
   }
}
