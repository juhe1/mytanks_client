package alternativa.tanks.models.weapon.shaft.states
{
   public class ShaftModes
   {
      
      public static var IDLE:ShaftModes = new ShaftModes();
      
      public static var TARGET_ACTIVATION:ShaftModes = new ShaftModes();
      
      public static var TARGETING:ShaftModes = new ShaftModes();
      
      public static var TARGET_DEACTIVATION:ShaftModes = new ShaftModes();
       
      
      public function ShaftModes()
      {
         super();
      }
   }
}
