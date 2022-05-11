package forms.buttons
{
   import controls.DefaultButton;
   import controls.Label;
   import flash.display.Bitmap;
   
   public class NewsButton extends DefaultButton
   {
      
[Embed(source="1124.png")]
      private static const image:Class;
       
      
      private var img:Bitmap;
      
      public function NewsButton(name:String)
      {
         var label:Label = null;
         this.img = new Bitmap(new image().bitmapData);
         super();
         this.img.y = 6;
         this.img.x = 6;
         addChild(this.img);
         label = new Label();
         label.mouseEnabled = false;
         label.text = name;
         label.x = this.img.x + this.img.width + 11;
         label.y = this.height / 2 - this.img.height / 2;
         this.addChild(label);
      }
   }
}
