package alternativa.tanks.model.challenge.greenpanel.black
{
   import flash.display.BitmapData;
   import utils.FlipBitmapDataUtils;
   
   public class BlackPack
   {
      
[Embed(source="1112.png")]
      private static const bg:Class;
      
[Embed(source="1033.png")]
      private static const left_botom_corner:Class;
      
[Embed(source="1053.png")]
      private static const left_line:Class;
      
[Embed(source="817.png")]
      private static const left_top:Class;
      
[Embed(source="1070.png")]
      private static const top_line:Class;
      
      public static const _dailyQuestPanelBackground:BitmapData = new bg().bitmapData;
      
      public static const _bottomLeftCorner:BitmapData = new left_botom_corner().bitmapData;
      
      public static const _leftLine:BitmapData = new left_line().bitmapData;
      
      public static const _topLeftCorner:BitmapData = new left_top().bitmapData;
      
      public static const _topCenterLine:BitmapData = new top_line().bitmapData;
      
      public static const _topRightCorner:BitmapData = FlipBitmapDataUtils.flipH(_topLeftCorner);
      
      public static const _bottomCenterLine:BitmapData = FlipBitmapDataUtils.flipW(_topCenterLine);
      
      public static const _dailyQuestPanelRightLine:BitmapData = FlipBitmapDataUtils.flipH(_leftLine);
      
      public static const _bottomRightCorner:BitmapData = FlipBitmapDataUtils.flipH(_bottomLeftCorner);
       
      
      public function BlackPack()
      {
         super();
      }
   }
}
