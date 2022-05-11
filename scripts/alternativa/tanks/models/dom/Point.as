package alternativa.tanks.models.dom
{
   import alternativa.console.ConsoleVarFloat;
   import alternativa.engine3d.core.Object3D;
   import alternativa.math.Vector3;
   import alternativa.tanks.models.battlefield.scene3dcontainer.Scene3DContainer;
   import com.alternativaplatform.projects.tanks.client.models.tank.TankSpawnState;
   import com.reygazu.anticheat.variables.SecureBoolean;
   
   public class Point
   {
      
      private static const CON_SMOOTHING_FACTOR:ConsoleVarFloat = new ConsoleVarFloat("dom_smoothing_factor",0.95,0,1);
      
      private static const MAX_PROGRESS:Number = 100;
       
      
      public var pos:Vector3;
      
      private var radius:Number;
      
      private var model:DOMModel;
      
      private var capture:SecureBoolean;
      
      public var id:int;
      
      public var pedestal:Object3D;
      
      private var serverProgress:Number = 0;
      
      public var clientProgress:Number = 0;
      
      private var progressSpeed:Number = 0;
      
      private var updateForced:Boolean;
      
      public function Point(id:int, pos:Vector3, radius:Number, model:DOMModel)
      {
         this.capture = new SecureBoolean("capture");
         super();
         this.pos = pos;
         this.radius = radius;
         this.model = model;
         this.id = id;
      }
      
      public function drawDebug(scene:Scene3DContainer) : void
      {
      }
      
      public function tick(time:int, deltaMsec:int, deltaSec:Number, interpolationCoeff:Number) : void
      {
         var tankPos:Vector3 = null;
         var dot:Number = NaN;
         if(DOMModel.userTankData == null)
         {
            return;
         }
         if(DOMModel.userTankData.spawnState == TankSpawnState.ACTIVE)
         {
            tankPos = DOMModel.userTankData.tank.state.pos;
            dot = this.pos.distanceTo(tankPos);
            if(!this.capture.value)
            {
               if(dot <= this.radius)
               {
                  this.capture.value = true;
                  this.model.tankCapturingPoint(this,DOMModel.userTankData);
               }
            }
            else if(dot > this.radius)
            {
               this.capture.value = false;
               this.model.tankLeaveCapturingPoint(this,DOMModel.userTankData);
            }
         }
         else if(this.capture.value)
         {
            this.capture.value = false;
            this.model.tankLeaveCapturingPoint(this,DOMModel.userTankData);
         }
      }
      
      public function readPos(v:Vector3) : void
      {
         v.x = this.pos.x;
         v.y = this.pos.y;
         v.z = this.pos.z;
      }
   }
}
