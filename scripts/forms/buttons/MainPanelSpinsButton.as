package forms.buttons
{
   import flash.display.Bitmap;
   
   public class MainPanelSpinsButton extends MainPanelWideButton
   {
      
      private static const iconN:Class = MainPanelSpinsButton_iconN;
      
[Embed(source="1018.png")]
      private static const overBtn:Class;
      
[Embed(source="1202.png")]
      private static const normalBtn:Class;
       
      
      public function MainPanelSpinsButton()
      {
         super(new Bitmap(new iconN().bitmapData),3,3,new Bitmap(new overBtn().bitmapData),new Bitmap(new normalBtn().bitmapData));
      }
   }
}
