package forms.buttons
{
   import flash.display.Bitmap;
   
   public class MainPanelChallengeButton extends MainPanelWideButton
   {
      
[Embed(source="818.png")]
      private static const iconN:Class;
      
[Embed(source="982.png")]
      private static const overBtn:Class;
      
[Embed(source="958.png")]
      private static const normalBtn:Class;
       
      
      public function MainPanelChallengeButton()
      {
         super(new Bitmap(new iconN().bitmapData),3,3,new Bitmap(new overBtn().bitmapData),new Bitmap(new normalBtn().bitmapData));
      }
   }
}
