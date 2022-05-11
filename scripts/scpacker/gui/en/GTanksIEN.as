package scpacker.gui.en
{
   import flash.display.Bitmap;
   import scpacker.gui.GTanksLoaderImages;
   
   public class GTanksIEN implements GTanksLoaderImages
   {
      
[Embed(source="1166.png")]
      private static const coldload1:Class;
      
[Embed(source="1165.png")]
      private static const coldload2:Class;
      
[Embed(source="1142.png")]
      private static const coldload3:Class;
      
[Embed(source="1143.png")]
      private static const coldload4:Class;
      
[Embed(source="1139.png")]
      private static const coldload5:Class;
      
[Embed(source="1141.png")]
      private static const coldload6:Class;
      
[Embed(source="1147.png")]
      private static const coldload7:Class;
      
[Embed(source="1148.png")]
      private static const coldload8:Class;
      
[Embed(source="1145.png")]
      private static const coldload9:Class;
      
[Embed(source="991.png")]
      private static const coldload10:Class;
      
[Embed(source="992.png")]
      private static const coldload11:Class;
      
[Embed(source="987.png")]
      private static const coldload12:Class;
      
[Embed(source="988.png")]
      private static const coldload13:Class;
      
[Embed(source="989.png")]
      private static const coldload14:Class;
      
[Embed(source="990.png")]
      private static const coldload15:Class;
      
      private static var items:Array = new Array(coldload1,coldload2,coldload3,coldload4,coldload5,coldload6,coldload7,coldload8,coldload9,coldload10,coldload11,coldload12,coldload13,coldload14,coldload15);
       
      
      private var prev:int;
      
      public function GTanksIEN()
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
