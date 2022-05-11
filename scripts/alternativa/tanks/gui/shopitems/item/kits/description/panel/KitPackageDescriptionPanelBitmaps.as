package alternativa.tanks.gui.shopitems.item.kits.description.panel
{
   import flash.display.BitmapData;
   import utils.FlipBitmapDataUtils;
   
   public class KitPackageDescriptionPanelBitmaps
   {
      
[Embed(source="891.png")]
      private static const bitmapLeftTopCorner:Class;
      
      public static const leftTopCorner:BitmapData = new bitmapLeftTopCorner().bitmapData;
      
      public static const rightTopCorner:BitmapData = FlipBitmapDataUtils.flipH(leftTopCorner);
      
[Embed(source="977.png")]
      private static const bitmapLeftBottomCorner:Class;
      
      public static const leftBottomCorner:BitmapData = new bitmapLeftBottomCorner().bitmapData;
      
      public static const rightBottomCorner:BitmapData = FlipBitmapDataUtils.flipH(leftBottomCorner);
      
[Embed(source="887.png")]
      private static const bitmapTopLine:Class;
      
      public static const topLine:BitmapData = new bitmapTopLine().bitmapData;
      
      public static const centerLine:BitmapData = FlipBitmapDataUtils.flipW(topLine);
      
      public static const bottomLine:BitmapData = FlipBitmapDataUtils.flipW(topLine);
      
[Embed(source="1062.png")]
      private static const bitmapLeftLine:Class;
      
      public static const leftLine:BitmapData = new bitmapLeftLine().bitmapData;
      
      public static const rightLine:BitmapData = FlipBitmapDataUtils.flipH(leftLine);
      
[Embed(source="807.png")]
      private static const bitmapBackgroundPixel:Class;
      
      public static const backgroundPixel:BitmapData = new bitmapBackgroundPixel().bitmapData;
       
      
      public function KitPackageDescriptionPanelBitmaps()
      {
         super();
      }
   }
}
