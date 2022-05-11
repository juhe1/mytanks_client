package alternativa.tanks.models.battlefield.gui.statistics.field
{
   import flash.display.Bitmap;
   
   public class DOMScoreIndicator extends TeamScoreFieldBase
   {
      
      private static const ICON_WIDTH:int = 21;
      
      private static const ICON_Y:int = 9;
      
[Embed(source="1071.png")]
      private static const icon_:Class;
       
      
      private var icon:Bitmap;
      
      public function DOMScoreIndicator()
      {
         this.icon = new Bitmap(new icon_().bitmapData);
         super();
         addChild(this.icon);
         this.icon.y = ICON_Y;
      }
      
      override protected function calculateWidth() : int
      {
         var maxWidth:int = labelRed.width > labelBlue.width ? int(int(labelRed.width)) : int(int(labelBlue.width));
         labelRed.x = 5 + 5 + (maxWidth - labelRed.width >> 1);
         this.icon.x = labelRed.x + maxWidth + 5;
         labelBlue.x = this.icon.x + ICON_WIDTH + 5 + (maxWidth - labelBlue.width >> 1);
         return labelBlue.x + maxWidth + 5 + 5;
      }
   }
}
