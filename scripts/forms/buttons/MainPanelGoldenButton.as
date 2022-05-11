package forms.buttons
{
   import flash.display.Bitmap;
   
   public class MainPanelGoldenButton extends MainPanelQuadButton
   {
      
[Embed(source="1041.png")]
      private static const overBtn:Class;
      
[Embed(source="933.png")]
      private static const normalBtn:Class;
       
      
      public function MainPanelGoldenButton()
      {
         super(new Bitmap(new overBtn().bitmapData),new Bitmap(new normalBtn().bitmapData));
      }
   }
}
