package scpacker.gui
{
   import flash.display.Bitmap;
   
   public class GTanksI implements GTanksLoaderImages
   {
      
[Embed(source="905.png")]
      private static const coldload1:Class;
      
[Embed(source="904.png")]
      private static const coldload2:Class;
      
[Embed(source="903.png")]
      private static const coldload3:Class;
      
[Embed(source="902.png")]
      private static const coldload4:Class;
      
[Embed(source="900.png")]
      private static const coldload5:Class;
      
[Embed(source="899.png")]
      private static const coldload6:Class;
      
[Embed(source="898.png")]
      private static const coldload7:Class;
      
[Embed(source="897.png")]
      private static const coldload8:Class;
      
[Embed(source="896.png")]
      private static const coldload9:Class;
      
[Embed(source="813.png")]
      private static const coldload10:Class;
      
[Embed(source="812.png")]
      private static const coldload11:Class;
      
[Embed(source="815.png")]
      private static const coldload12:Class;
      
[Embed(source="814.png")]
      private static const coldload13:Class;
      
[Embed(source="808.png")]
      private static const coldload14:Class;
      
[Embed(source="809.png")]
      private static const coldload15:Class;
      
[Embed(source="810.png")]
      private static const coldload16:Class;
      
[Embed(source="811.png")]
      private static const coldload17:Class;
      
      private static var items:Array = new Array(coldload1,coldload2,coldload3,coldload4,coldload5,coldload6,coldload7,coldload8,coldload9,coldload10,coldload11,coldload12,coldload13,coldload14,coldload15,coldload16,coldload17);
       
      
      private var prev:int;
      
      public function GTanksI()
      {
         super();
      }
      
      public function getRandomPict() : Bitmap
      {
         var r:int = 0;
         while((r = Math.random() * items.length) == this.prev)
         {
         }
         return new Bitmap(new items[r]().bitmapData);
      }
   }
}
