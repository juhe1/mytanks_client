package alternativa.tanks.gui.icons
{
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   
   public class CrystalIcon
   {
      
[Embed(source="868.png")]
      private static const bitmapCrystal:Class;
      
      private static const crystalBd:BitmapData = new bitmapCrystal().bitmapData;
      
[Embed(source="1188.png")]
      private static const smallCrystal:Class;
      
      private static const smallBitmapData:BitmapData = new smallCrystal().bitmapData;
       
      
      public function CrystalIcon()
      {
         super();
      }
      
      public static function createInstance() : Bitmap
      {
         return new Bitmap(crystalBd);
      }
      
      public static function createSmallInstance() : Bitmap
      {
         return new Bitmap(smallBitmapData);
      }
   }
}
