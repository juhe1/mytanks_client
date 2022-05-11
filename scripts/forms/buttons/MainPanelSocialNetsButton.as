package forms.buttons
{
   import flash.display.Bitmap;
   
   public class MainPanelSocialNetsButton extends MainPanelWideButton
   {
      
[Embed(source="1017.png")]
      private static const iconN:Class;
      
[Embed(source="1045.png")]
      private static const overBtn:Class;
      
[Embed(source="778.png")]
      private static const normalBtn:Class;
       
      
      public function MainPanelSocialNetsButton()
      {
         super(new Bitmap(new iconN().bitmapData),3,3,new Bitmap(new overBtn().bitmapData),new Bitmap(new normalBtn().bitmapData));
      }
   }
}
