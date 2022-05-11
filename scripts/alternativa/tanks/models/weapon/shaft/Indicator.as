package alternativa.tanks.models.weapon.shaft
{
   import alternativa.object.ClientObject;
   import flash.display.BitmapData;
   
   public class Indicator
   {
      
[Embed(source="879.png")]
      private static const aim_m0:Class;
      
[Embed(source="877.png")]
      private static const aim_m1:Class;
      
[Embed(source="878.png")]
      private static const aim_m2:Class;
      
[Embed(source="880.png")]
      private static const aim_m3:Class;
      
      private static var aimM0:BitmapData = new aim_m0().bitmapData;
      
      private static var aimM1:BitmapData = new aim_m1().bitmapData;
      
      private static var aimM2:BitmapData = new aim_m2().bitmapData;
      
      private static var aimM3:BitmapData = new aim_m3().bitmapData;
       
      
      public function Indicator()
      {
         super();
      }
      
      public static function getIndicator(turret:ClientObject) : BitmapData
      {
         switch(turret.id)
         {
            case "shaft_m0":
               return aimM0;
            case "shaft_m1":
               return aimM1;
            case "shaft_m2":
               return aimM2;
            case "shaft_m3":
               return aimM3;
            default:
               return aimM0;
         }
      }
   }
}
