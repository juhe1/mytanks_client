package alternativa.tanks.models.sfx.healing
{
   import alternativa.console.ConsoleVarFloat;
   import alternativa.math.Vector3;
   import alternativa.tanks.camera.ICameraStateModifier;
   import alternativa.tanks.camera.IFollowCameraController;
   import flash.utils.getTimer;
   
   public class HealingGunCameraEffect implements ICameraStateModifier
   {
      
      private static var amplitude:ConsoleVarFloat;
      
      private static var frequency:ConsoleVarFloat;
       
      
      public var refCounter:int;
      
      private var startTime:int;
      
      public function HealingGunCameraEffect()
      {
         super();
      }
      
      public static function initVars() : void
      {
         amplitude = new ConsoleVarFloat("healcam_ampl",2,0,1000);
         frequency = new ConsoleVarFloat("healcam_freq",25,0,1000);
      }
      
      public function update(time:int, delta:int, position:Vector3, rotation:Vector3) : Boolean
      {
         if(this.refCounter <= 0)
         {
            return false;
         }
         var dt:Number = 0.001 * (time - this.startTime);
         position.z += amplitude.value * Math.sin(frequency.value * dt);
         return true;
      }
      
      public function onAddedToController(controller:IFollowCameraController) : void
      {
         this.startTime = getTimer();
      }
      
      public function destroy() : void
      {
      }
   }
}
