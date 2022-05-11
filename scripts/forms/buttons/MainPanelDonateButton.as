package forms.buttons
{
   import flash.display.Bitmap;
   
   public class MainPanelDonateButton extends MainPanelWideButton
   {
      
[Embed(source="892.png")]
      private static const iconN:Class;
      
      private static const overBtn:Class = MainPanelDonateButton_overBtn;
      
[Embed(source="816.png")]
      private static const normalBtn:Class;
       
      
      public function MainPanelDonateButton()
      {
         super(new Bitmap(new iconN().bitmapData),3,3,new Bitmap(new overBtn().bitmapData),new Bitmap(new normalBtn().bitmapData));
      }
   }
}
