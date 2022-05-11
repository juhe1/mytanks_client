package alternativa.tanks.models.weapon.shaft.modes
{
   import alternativa.engine3d.core.Object3D;
   import alternativa.init.Main;
   import alternativa.math.Matrix4;
   import alternativa.math.Quaternion;
   import alternativa.math.Vector3;
   import alternativa.tanks.camera.CameraFovCalculator;
   import alternativa.tanks.camera.GameCamera;
   import alternativa.tanks.models.battlefield.BattlefieldModel;
   import alternativa.tanks.models.battlefield.IBattleField;
   import alternativa.tanks.models.tank.ITank;
   import alternativa.tanks.models.tank.TankData;
   import alternativa.tanks.models.tank.TankModel;
   import alternativa.tanks.models.tank.turret.default.DefaultTurretController;
   import alternativa.tanks.models.tank.turret.shaft.ShaftTurretController;
   import alternativa.tanks.models.weapon.shaft.LinearInterpolator;
   import alternativa.tanks.models.weapon.shaft.ShaftData;
   import alternativa.tanks.models.weapon.shaft.ShaftDeactivationTask;
   import alternativa.tanks.models.weapon.shaft.ShaftEnergyMode;
   import alternativa.tanks.models.weapon.shaft.ShaftModel;
   import alternativa.tanks.models.weapon.shaft.cameracontrollers.TargetingCameraController;
   import alternativa.tanks.models.weapon.shaft.sfx.ShaftSFXModel;
   import alternativa.tanks.models.weapon.shaft.states.ShaftModes;
   import alternativa.tanks.utils.MathUtils;
   import alternativa.tanks.vehicles.tanks.TankSkin;
   import scpacker.tanks.WeaponsManager;
   
   public class TargetingController
   {
      
      private static var aimDirection:Vector3 = new Vector3();
      
      private static var cameraPosition:Vector3 = new Vector3();
       
      
      private var up:Boolean;
      
      private var down:Boolean;
      
      public var cameraController:TargetingCameraController;
      
      private var fovInterpolator:LinearInterpolator;
      
      private var rangeInterpolator:LinearInterpolator;
      
      private var exitTime:int;
      
      private var fired:Boolean;
      
      private var chargingEffectActive:Boolean;
      
      public var shaftMode:ShaftModes;
      
      private var timeLeft:int = 0;
      
      private var alphaInterpolator:LinearInterpolator;
      
      private var reticleAlphaInterpolator:LinearInterpolator;
      
      private var stateDuration:int = 500;
      
      public var camera:GameCamera;
      
      public var skin:TankSkin;
      
      private var targetFOV:Number = 0.698132;
      
      private var targetCameraPosition:Vector3;
      
      private var initialCameraOrientation:Quaternion;
      
      private var targetCameraOrientation:Quaternion;
      
      private var cameraOrientation:Quaternion;
      
      private var initialCameraPosition:Vector3;
      
      private var cameraPosition:Vector3;
      
      private var cameraMatrix:Matrix4;
      
      private var turretMatrix:Matrix4;
      
      private var cameraAngles:Vector3;
      
      private var battlefieldModel:BattlefieldModel;
      
      public var deactivationTask:ShaftDeactivationTask;
      
      public var shaftModel:ShaftModel;
      
      private var initalEnegry:Number;
      
      private var lastEnergy:Number;
      
      private var savedTurnAcceleration:Number;
      
      private var savedTurnSpred:Number;
      
      private var tankModel:TankModel;
      
      private var sfxModel:ShaftSFXModel;
      
      public function TargetingController(shaftModel:ShaftModel)
      {
         this.fovInterpolator = new LinearInterpolator();
         this.rangeInterpolator = new LinearInterpolator();
         this.shaftMode = ShaftModes.TARGET_ACTIVATION;
         super();
         var shaftData:ShaftData = shaftModel.shaftData;
         this.targetFOV = shaftData.minimumFOV;
         this.fovInterpolator.setInterval(shaftData.initialFOV,shaftData.minimumFOV);
         this.rangeInterpolator.setInterval(shaftData.shrubsHidingRadiusMin,shaftData.shrubsHidingRadiusMax);
         this.cameraController = new TargetingCameraController(shaftData.elevationAngleUp,shaftData.elevationAngleDown,shaftData.verticalTargetingSpeed,shaftData.horizontalTargetingSpeed);
         this.alphaInterpolator = new LinearInterpolator();
         this.reticleAlphaInterpolator = new LinearInterpolator();
         this.initialCameraOrientation = new Quaternion();
         this.targetCameraOrientation = Quaternion.createFromAxisAngle(Vector3.X_AXIS,-Math.PI / 2);
         this.initialCameraPosition = new Vector3();
         this.cameraPosition = new Vector3();
         this.cameraOrientation = new Quaternion();
         this.cameraMatrix = new Matrix4();
         this.turretMatrix = new Matrix4();
         this.cameraAngles = new Vector3();
         this.reticleAlphaInterpolator.setInterval(0,1);
         this.shaftModel = shaftModel;
         this.targetCameraPosition = new Vector3(0,30,10);
         this.tankModel = Main.osgi.getService(ITank) as TankModel;
      }
      
      public function enter(time:int) : void
      {
         this.savedTurnAcceleration = TankData.localTankData.tank.turretTurnAcceleration;
         this.savedTurnSpred = TankData.localTankData.tank.maxTurretTurnSpeed;
         TankData.localTankData.tank.turretTurnAcceleration = 2;
         this.setTurretSpeedFactor(this.savedTurnSpred);
         this.up = MathUtils.getBitValue(TankData.localTankData.tank.turretDirSign,1) != 0;
         this.down = MathUtils.getBitValue(TankData.localTankData.tank.turretDirSign,2) != 0;
         this.shaftModel.setEnergyMode(ShaftEnergyMode.DRAIN);
         this.timeLeft = this.stateDuration;
         this.alphaInterpolator.setInterval(this.skin.hullMesh.alpha,0);
         this.fovInterpolator.setInterval(this.camera.fov,this.targetFOV);
         this.calculateCameraInitialValues();
         this.exitTime = -1;
         this.fired = false;
         this.chargingEffectActive = true;
         this.battlefieldModel = Main.osgi.getService(IBattleField) as BattlefieldModel;
         this.deactivationTask = new ShaftDeactivationTask(this.battlefieldModel.bfData.viewport.camera);
         this.deactivationTask.setSkin(this.skin);
         this.deactivationTask.stop();
         this.shaftMode = ShaftModes.TARGET_ACTIVATION;
         this.cameraController.reload();
         this.battlefieldModel.initCameraController(this.cameraController);
         this.battlefieldModel.hidableObjects.enable();
         this.battlefieldModel.hidableObjects.setCenterAndRadius(TankData.localTankData.tank.state.pos,0);
         this.initalEnegry = this.shaftModel.getEnergy(time);
         this.shaftModel.targetModeOn();
         this.tankModel.localUserData.tank.setTurretController(new ShaftTurretController(this.tankModel.localUserData));
         this.tankModel.localUserData.tank.getTurretController().enableTurretSound(false);
         this.sfxModel = WeaponsManager.getShaftSFX(WeaponsManager.getObjectFor(TankData.localTankData.turret.id));
      }
      
      public function exit() : void
      {
         this.deactivationTask.setTargetFov(CameraFovCalculator.getCameraFov(Main.stage.stageWidth,Main.stage.stageHeight));
         this.deactivationTask.start();
         TankData.localTankData.tank.turretTurnAcceleration = this.savedTurnAcceleration;
         TankData.localTankData.tank.setMaxTurretTurnSpeed(this.savedTurnSpred,true);
         this.tankModel.localUserData.tank.setTurretController(new DefaultTurretController(this.tankModel.localUserData));
         this.tankModel.localUserData.tank.getTurretController().enableTurretSound(true);
         this.sfxModel.playTargetingSound(this.tankModel.localUserData.turret,this.tankModel.localUserData.user,false);
         this.battlefieldModel.hidableObjects.disnable();
         this.battlefieldModel.hidableObjects.restore();
      }
      
      private function setTurretSpeedFactor(param1:Number) : void
      {
         TankData.localTankData.tank.setMaxTurretTurnSpeed(param1 * 0.5,false);
         this.cameraController.setMaxElevationSpeedFactor(param1);
      }
      
      public function update(param1:int, param2:int) : void
      {
         var _loc3_:Number = NaN;
         var _loc4_:Number = NaN;
         var weaponEnegry:Number = NaN;
         var en:Number = NaN;
         var dir:int = 0;
         switch(this.shaftMode)
         {
            case ShaftModes.TARGET_ACTIVATION:
               _loc3_ = 0;
               _loc4_ = 0;
               if(this.timeLeft <= 0)
               {
                  this.shaftMode = ShaftModes.TARGETING;
                  this.fovInterpolator.setInterval(this.camera.fov,this.targetFOV);
               }
               else
               {
                  this.timeLeft -= param2;
                  _loc3_ = 1 - this.timeLeft / this.stateDuration;
                  if(_loc3_ > 1)
                  {
                     _loc3_ = 1;
                  }
                  _loc4_ = this.alphaInterpolator.interpolate(_loc3_);
                  this.skin.setAlpha(_loc4_);
                  this.updateCamera(_loc3_);
               }
               break;
            case ShaftModes.TARGETING:
               weaponEnegry = this.shaftModel.getEnergy(param1);
               en = (this.initalEnegry - weaponEnegry) / 1000;
               this.lastEnergy = en;
               this.cameraController.setCameraFov(this.fovInterpolator.interpolate(en));
               if(weaponEnegry == 0 && this.chargingEffectActive)
               {
                  this.chargingEffectActive = false;
                  this.sfxModel.fadeChargingEffect(TankData.localTankData.turret,TankData.localTankData.user);
               }
               this.up = TankData.localTankData.ctrlBits & TankModel.FORWARD;
               this.down = TankData.localTankData.ctrlBits & TankModel.BACK;
               dir = int(this.up) - int(this.down);
               this.sfxModel.playTargetingSound(TankData.localTankData.turret,TankData.localTankData.user,dir != 0 && !this.cameraController.isMaxElevation() || this.tankModel.localUserData.tank.turretTurnSpeed != 0);
               this.cameraController.elevationDirection = dir;
               this.battlefieldModel.hidableObjects.setCenterAndRadius(TankData.localTankData.tank.state.pos,this.rangeInterpolator.interpolate(en));
               break;
            case ShaftModes.TARGET_DEACTIVATION:
         }
      }
      
      private function calculateCameraInitialValues() : void
      {
         var _loc1_:Object3D = this.skin.turretMesh;
         this.turretMatrix.setMatrix(_loc1_.x,_loc1_.y,_loc1_.z,_loc1_.rotationX,_loc1_.rotationY,_loc1_.rotationZ);
         this.cameraMatrix.setMatrix(this.camera.x,this.camera.y,this.camera.z,this.camera.rotationX,this.camera.rotationY,this.camera.rotationZ);
         this.turretMatrix.invert();
         this.cameraMatrix.append(this.turretMatrix);
         this.cameraMatrix.getEulerAngles(this.cameraAngles);
         this.initialCameraOrientation.setFromEulerAnglesXYZ(this.cameraAngles.x,this.cameraAngles.y,this.cameraAngles.z);
         this.cameraMatrix.getAxis(3,this.initialCameraPosition);
      }
      
      private function updateCamera(param1:Number) : void
      {
         this.cameraPosition.interpolate(param1,this.initialCameraPosition,this.targetCameraPosition);
         this.cameraOrientation.slerp(this.initialCameraOrientation,this.targetCameraOrientation,param1);
         this.cameraOrientation.toMatrix4(this.cameraMatrix);
         this.cameraMatrix.setPosition(this.cameraPosition);
         var _loc2_:Object3D = this.skin.turretMesh;
         this.turretMatrix.setMatrix(_loc2_.x,_loc2_.y,_loc2_.z,_loc2_.rotationX,_loc2_.rotationY,_loc2_.rotationZ);
         this.cameraMatrix.append(this.turretMatrix);
         this.cameraMatrix.getEulerAngles(this.cameraAngles);
         this.camera.x = this.cameraMatrix.d;
         this.camera.y = this.cameraMatrix.h;
         this.camera.z = this.cameraMatrix.l;
         this.camera.rotationX = this.cameraAngles.x;
         this.camera.rotationY = this.cameraAngles.y;
         this.camera.rotationZ = this.cameraAngles.z;
      }
   }
}
