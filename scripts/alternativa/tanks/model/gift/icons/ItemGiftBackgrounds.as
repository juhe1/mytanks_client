package alternativa.tanks.model.gift.icons
{
   import flash.display.BitmapData;
   
   public class ItemGiftBackgrounds
   {
      
[Embed(source="1040.png")]
      private static const _bg_common:Class;
      
[Embed(source="758.png")]
      private static const _bg_legendary:Class;
      
[Embed(source="1000.png")]
      private static const _bg_rare:Class;
      
[Embed(source="1164.png")]
      private static const _bg_uncommon:Class;
      
[Embed(source="873.png")]
      private static const _bg_unique:Class;
      
      private static const bgCommon:BitmapData = new _bg_common().bitmapData;
      
      private static const bgLegendary:BitmapData = new _bg_legendary().bitmapData;
      
      private static const bgRare:BitmapData = new _bg_rare().bitmapData;
      
      private static const bgUncommon:BitmapData = new _bg_uncommon().bitmapData;
      
      private static const bgUnique:BitmapData = new _bg_unique().bitmapData;
      
      private static const array:Array = new Array(bgCommon,bgUncommon,bgRare,bgUnique,bgLegendary);
       
      
      public function ItemGiftBackgrounds()
      {
         super();
      }
      
      public static function getBG(i:int) : BitmapData
      {
         return array[i];
      }
      
      public static function getColor(i:int) : uint
      {
         if(i == 0)
         {
            return 12632256;
         }
         if(i == 1)
         {
            return 65535;
         }
         if(i == 2)
         {
            return 11163135;
         }
         if(i == 3)
         {
            return 16736256;
         }
         if(i == 4)
         {
            return 16776960;
         }
         return 0;
      }
   }
}
