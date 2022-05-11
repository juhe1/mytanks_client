package alternativa.tanks.model.challenge.greenpanel.green
{
   import flash.display.BitmapData;
   import utils.FlipBitmapDataUtils;
   
   public class GreenPack
   {
      
      private static const bg:Class = GreenPack_bg;
      
      private static const left_botom_corner:Class = GreenPack_left_botom_corner;
      
      private static const left_line:Class = GreenPack_left_line;
      
      private static const left_top:Class = GreenPack_left_top;
      
      private static const top_line:Class = GreenPack_top_line;
      
      public static const _dailyQuestPanelBackground:BitmapData = new bg().bitmapData;
      
      public static const _bottomLeftCorner:BitmapData = new left_botom_corner().bitmapData;
      
      public static const _leftLine:BitmapData = new left_line().bitmapData;
      
      public static const _topLeftCorner:BitmapData = new left_top().bitmapData;
      
      public static const _topCenterLine:BitmapData = new top_line().bitmapData;
      
      public static const _topRightCorner:BitmapData = FlipBitmapDataUtils.flipH(_topLeftCorner);
      
      public static const _bottomCenterLine:BitmapData = FlipBitmapDataUtils.flipW(_topCenterLine);
      
      public static const _dailyQuestPanelRightLine:BitmapData = FlipBitmapDataUtils.flipH(_leftLine);
      
      public static const _bottomRightCorner:BitmapData = FlipBitmapDataUtils.flipH(_bottomLeftCorner);
       
      
      public function GreenPack()
      {
         super();
      }
   }
}
