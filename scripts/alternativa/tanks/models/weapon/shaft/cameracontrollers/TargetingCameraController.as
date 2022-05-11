package alternativa.tanks.models.weapon.shaft.cameracontrollers
{
   import alternativa.engine3d.core.Object3D;
   import alternativa.init.Main;
   import alternativa.math.Matrix3;
   import alternativa.math.Vector3;
   import alternativa.tanks.camera.GameCamera;
   import alternativa.tanks.camera.ICameraController;
   import alternativa.tanks.models.battlefield.BattlefieldModel;
   import alternativa.tanks.models.battlefield.IBattleField;
   
   public class TargetingCameraController implements ICameraController
   {
      
      private static const objectMatrix:Matrix3 = new Matrix3();
      
      private static const cameraMatrix:Matrix3 = new Matrix3();
      
      private static const vector:Vector3 = new Vector3();
       
      
      private var cameraPosition:Vector3;
      
      private var anchorObject:Object3D;
      
      private var _elevation:Number = 0;
      
      private var localPosition:Vector3;
      
      private var maxElevation:Number;
      
      private var minElevation:Number;
      
      private var _elevationDirection:int;
      
      private var maxElevationSpeed:Number = 1;
      
      private var maxElevationSpeedFactor:Number = 1;
      
      private var elevationSpeed:Number = 0;
      
      private var elevationAcceleration:Number = 5;
      
      private var battlefieldModel:BattlefieldModel;
      
      public var maxTime:Number = 400000;
      
      public var maxRadius:Number = 5;
      
      public var maxAngle:Number = 3.141592653589793;
      
      public var radius:Number = 0;
      
      public var direction:Vector3;
      
      private var e1:Vector3;
      
      private var e2:Vector3;
      
      private var sign:int = 1;
      
      private var modX:Number = 0;
      
      private var modZ:Number = 0;
      
      private var ind:Boolean = true;
      
      private var ang:Number;
      
      public function TargetingCameraController(param1:Number, param2:Number, param3:Number, param4:Number)
      {
         this.direction = new Vector3();
         this.e1 = new Vector3();
         this.e2 = new Vector3();
         this.localPosition = new Vector3();
         super();
         this.maxElevation = param1;
         this.minElevation = param2;
         this.maxElevationSpeed = param3;
         this.elevationAcceleration = param4;
         this.reload();
         this.battlefieldModel = Main.osgi.getService(IBattleField) as BattlefieldModel;
         this.direction.vReset(1 - 2 * Math.random(),1 - 2 * Math.random(),1 - 2 * Math.random()).vNormalize();
         this.cameraPosition = new Vector3();
         this.ang = Math.random() * 2 * Math.PI;
      }
      
      public function reload() : void
      {
         this.modX = 0;
         this.modZ = 0;
         this.sign = 1;
      }
      
      public function set elevationDirection(param1:int) : void
      {
         if(this._elevationDirection != param1)
         {
            this._elevationDirection = param1;
            this.elevationSpeed = 0;
         }
      }
      
      public function isMaxElevation() : Boolean
      {
         return this._elevation == this.maxElevation || this._elevation == this.minElevation;
      }
      
      public function readCameraPosition(param1:Vector3) : void
      {
         var _loc2_:GameCamera = null;
         _loc2_ = null;
         _loc2_ = this.battlefieldModel.bfData.viewport.camera;
         param1.x = _loc2_.x;
         param1.y = _loc2_.y;
         param1.z = _loc2_.z;
      }
      
      public function readCameraDirection(param1:Vector3) : void
      {
         var _loc2_:GameCamera = this.battlefieldModel.bfData.viewport.camera;
         var _loc3_:Vector3 = _loc2_.zAxis;
         param1.vCopy(_loc3_);
      }
      
      public function get elevation() : Number
      {
         return this._elevation;
      }
      
      public function set elevation(param1:Number) : void
      {
         if(param1 > this.maxElevation)
         {
            this._elevation = this.maxElevation;
         }
         else if(param1 < this.minElevation)
         {
            this._elevation = this.minElevation;
         }
         else
         {
            this._elevation = param1;
         }
      }
      
      public function setAnchorObject(param1:Object3D) : void
      {
         this.anchorObject = param1;
      }
      
      public function setLocalPosition(param1:Vector3) : void
      {
         this.localPosition.vCopy(param1);
      }
      
      public function setMaxElevationSpeedFactor(param1:Number) : void
      {
         this.maxElevationSpeedFactor = param1;
      }
      
      public function update(param1:int, param2:int) : void
      {
         var _loc5_:Number = NaN;
         var _loc3_:Number = param2 / 1000;
         if(this._elevationDirection != 0)
         {
            this.elevationSpeed += this.elevationAcceleration * _loc3_;
            _loc5_ = this.maxElevationSpeed * this.maxElevationSpeedFactor;
            if(this.elevationSpeed > _loc5_)
            {
               this.elevationSpeed = _loc5_;
            }
            this._elevation += this._elevationDirection * this.elevationSpeed * _loc3_;
            if(this._elevation > this.maxElevation)
            {
               this._elevation = this.maxElevation;
            }
            else if(this._elevation < this.minElevation)
            {
               this._elevation = this.minElevation;
            }
         }
         var freequency:Number = this.battlefieldModel.shaft_freq.value;
         var vel:Number = this.battlefieldModel.shaft_vel.value;
         var avel:Number = this.battlefieldModel.shaft_avel.value;
         objectMatrix.setRotationMatrix(this.anchorObject.rotationX,this.anchorObject.rotationY,this.anchorObject.rotationZ);
         cameraMatrix.fromAxisAngle(Vector3.X_AXIS,this._elevation - Math.PI / 2);
         cameraMatrix.append(objectMatrix);
         cameraMatrix.getEulerAngles(vector);
         var cam:GameCamera = this.battlefieldModel.bfData.viewport.camera;
         var delta:Vector3 = this.getDeltas(vel,avel,freequency,100);
         var isMaxElevation:Boolean = this._elevation == this.maxElevation;
         var isMinElevation:Boolean = this._elevation == this.minElevation;
         this.modX += !!isMaxElevation ? 0 : delta.x;
         this.modZ += delta.z;
         cam.rotationX = vector.x + this.modX;
         cam.rotationY = vector.y;
         cam.rotationZ = vector.z + this.modZ;
         objectMatrix.transformVector(this.localPosition,vector);
         cam.x = vector.x + this.anchorObject.x;
         cam.y = vector.y + this.anchorObject.y;
         cam.z = vector.z + this.anchorObject.z;
      }
      
      public function setCameraFov(param1:Number) : void
      {
         this.battlefieldModel.bfData.viewport.camera.fov = param1;
      }
      
      private function getRandom() : Number
      {
         var rd1:Number = Math.random();
         var rd2:Number = Math.random();
         return rd1 > 0.5 ? Number(Number(-rd2)) : Number(Number(rd2));
      }
      
      private function stableRandom(k:Number) : Number
      {
         var rd1:Number = Math.random();
         var rd2:Number = Math.random();
         this.sign = rd2 > Math.pow(0.5,k) ? int(int(-this.sign)) : int(int(this.sign));
         return this.sign * rd1;
      }
      
      private function stableRandomSign(k:Number) : Number
      {
         this.sign = Math.random() > Math.pow(0.5,k) ? int(int(-this.sign)) : int(int(this.sign));
         return this.sign;
      }
      
      private function getDeltas(vel:Number, avel:Number, freeq:Number, dist:Number) : Vector3
      {
         var res:Vector3 = new Vector3(Math.atan2(vel * Math.cos(this.ang) * Math.random(),dist),0,Math.atan2(vel * Math.sin(this.ang) * Math.random(),dist));
         this.ang += this.stableRandom(freeq) * avel;
         return res;
      }
   }
}
