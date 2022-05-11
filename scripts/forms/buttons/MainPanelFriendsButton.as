package forms.buttons
{
   import flash.display.Bitmap;
   
   public class MainPanelFriendsButton extends MainPanelWideButton
   {
      
[Embed(source="1052.png")]
      private static const iconN:Class;
      
[Embed(source="875.png")]
      private static const overBtn:Class;
      
[Embed(source="939.png")]
      private static const normalBtn:Class;
       
      
      public function MainPanelFriendsButton()
      {
         super(new Bitmap(new iconN().bitmapData),3,3,new Bitmap(new overBtn().bitmapData),new Bitmap(new normalBtn().bitmapData));
      }
   }
}
