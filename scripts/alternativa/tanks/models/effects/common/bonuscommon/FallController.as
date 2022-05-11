package alternativa.tanks.models.effects.common.bonuscommon
{
   import alternativa.engine3d.core.Object3D;
   import alternativa.math.Matrix3;
   import alternativa.math.Vector3;
   
   public class FallController
   {
      
      private static const MAX_ANGLE_X:Number = 0.3;
      
      private static const ANGLE_X_FREQ:Number = 3.4;
      
      private static const MAX_ANGLE_X_PARACHUTE:Number = 0.15;
      
      private static const ANGLE_X_FREQ_PARACHUTE:Number = 1.3;
      
      private static const m:Matrix3 = new Matrix3();
      
      private static const v:Vector3 = new Vector3();
       
      
      private const interpolatedMatrix:Matrix3 = new Matrix3();
      
      private const interpolatedParachuteMatrix:Matrix3 = new Matrix3();
      
      private const interpolatedVector:Vector3 = new Vector3();
      
      private const interpolatedParachuteVector:Vector3 = new Vector3();
      
      private const oldState:BattleBonusState = new BattleBonusState();
      
      private const oldStateParachute:BattleBonusState = new BattleBonusState();
      
      private const newState:BattleBonusState = new BattleBonusState();
      
      private const newStateParachute:BattleBonusState = new BattleBonusState();
      
      private const interpolatedState:BattleBonusState = new BattleBonusState();
      
      private const interpolatedParachuteState:BattleBonusState = new BattleBonusState();
      
      private var battleBonus:ParaBonus;
      
      private var minPivotZ:Number;
      
      private var time:Number;
      
      private var fallSpeed:Number;
      
      private var t0:Number;
      
      private var x:Number = 0;
      
      private var y:Number = 0;
      
      public function FallController(battleBonus:ParaBonus)
      {
         super();
         this.battleBonus = battleBonus;
      }
      
      public function init(spawnPosition:Vector3, fallSpeed:Number, minPivotZ:Number, t0:Number, startTime:Number, startingAngleZ:Number) : void
      {
         this.x = spawnPosition.x;
         this.y = spawnPosition.y;
         this.newState.pivotZ = spawnPosition.z + BonusConst.BONUS_OFFSET_Z - fallSpeed * startTime;
         this.newState.angleZ = startingAngleZ + BonusConst.ANGULAR_SPEED_Z * startTime;
         this.newStateParachute.pivotZ = spawnPosition.z + BonusConst.BONUS_OFFSET_Z - fallSpeed * startTime;
         this.newStateParachute.angleZ = startingAngleZ + BonusConst.ANGULAR_SPEED_Z * startTime;
         this.fallSpeed = fallSpeed;
         this.minPivotZ = minPivotZ;
         this.t0 = t0;
         this.time = startTime;
      }
      
      public function start() : void
      {
      }
      
      public function runBeforePhysicsUpdate(dt:Number) : void
      {
         dt *= 0.001;
         this.oldState.copy(this.newState);
         this.oldStateParachute.copy(this.newStateParachute);
         this.time += dt;
         this.newState.pivotZ -= this.fallSpeed * dt;
         this.newState.angleX = MAX_ANGLE_X * Math.sin(ANGLE_X_FREQ * (this.t0 + this.time));
         this.newState.angleZ += (BonusConst.ANGULAR_SPEED_Z + 0.2) * dt;
         this.newStateParachute.pivotZ -= this.fallSpeed * dt;
         this.newStateParachute.angleX = MAX_ANGLE_X_PARACHUTE * Math.sin(ANGLE_X_FREQ_PARACHUTE * (this.t0 + this.time));
         this.newStateParachute.angleZ += BonusConst.ANGULAR_SPEED_Z * dt;
         if(this.newState.pivotZ <= this.minPivotZ)
         {
            this.newState.pivotZ = this.minPivotZ;
            this.newState.angleX = 0;
            this.newStateParachute.pivotZ = this.minPivotZ;
            this.newStateParachute.angleX = 0;
            this.interpolatePhysicsState(1);
            this.render();
            this.battleBonus.onStaticCollision();
         }
         this.updateTrigger();
      }
      
      private function updateTrigger() : void
      {
         m.setRotationMatrix(this.newState.angleX,0,this.newState.angleZ);
         m.transformVector(Vector3.DOWN,v);
         v.scale(BonusConst.BONUS_OFFSET_Z);
         this.battleBonus.trigger.update(this.x + v.x,this.y + v.y,this.newState.pivotZ + v.z,this.newState.angleX,0,this.newState.angleZ);
      }
      
      public function interpolatePhysicsState(interpolationCoeff:Number) : void
      {
         this.interpolatedParachuteState.interpolate(this.oldStateParachute,this.newStateParachute,interpolationCoeff);
         this.interpolatedParachuteMatrix.setRotationMatrix(this.interpolatedParachuteState.angleX,0,this.interpolatedParachuteState.angleZ);
         this.interpolatedParachuteMatrix.transformVector(Vector3.DOWN,this.interpolatedParachuteVector);
         this.interpolatedState.interpolate(this.oldState,this.newState,interpolationCoeff);
         this.interpolatedMatrix.setRotationMatrix(this.interpolatedState.angleX,0,this.interpolatedState.angleZ);
         this.interpolatedMatrix.transformVector(Vector3.DOWN,this.interpolatedVector);
      }
      
      public function render() : void
      {
         this.setObjectTransform(this.battleBonus.parachute,BonusConst.PARACHUTE_OFFSET_Z,this.interpolatedParachuteVector);
         this.setObjectTransform(this.battleBonus.skin,BonusConst.BONUS_OFFSET_Z,this.interpolatedVector);
         this.battleBonus.cordsMesh.updateVertices();
      }
      
      private function setObjectTransform(object:Object3D, objectOffset:Number, offsetVector:Vector3) : void
      {
         if(object != this.battleBonus.parachute)
         {
            object.rotationX = this.interpolatedState.angleX;
            object.rotationZ = this.interpolatedState.angleZ;
            object.x = this.x + 50 * offsetVector.x;
            object.y = this.y + 50 * offsetVector.y;
            object.z = this.interpolatedState.pivotZ + objectOffset * offsetVector.z;
         }
         else
         {
            object.rotationX = this.interpolatedParachuteState.angleX;
            object.rotationZ = this.interpolatedParachuteState.angleZ;
            object.x = this.x + objectOffset * offsetVector.x;
            object.y = this.y + objectOffset * offsetVector.y;
            object.z = this.interpolatedParachuteState.pivotZ + objectOffset * offsetVector.z;
         }
      }
   }
}
