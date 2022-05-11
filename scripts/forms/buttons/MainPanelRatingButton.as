package forms.buttons
{
   import flash.display.Bitmap;
   
   public class MainPanelRatingButton extends MainPanelWideButton
   {
      
[Embed(source="1162.png")]
      private static const iconN:Class;
      
[Embed(source="820.png")]
      private static const overBtn:Class;
      
      private static const normalBtn:Class = MainPanelRatingButton_normalBtn;
       
      
      public function MainPanelRatingButton()
      {
         super(new Bitmap(new iconN().bitmapData),3,3,new Bitmap(new overBtn().bitmapData),new Bitmap(new normalBtn().bitmapData));
      }
   }
}
