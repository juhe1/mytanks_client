package alternativa.tanks.model.captcha
{
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   
   public class CaptchaRefreshButton extends Sprite
   {
      
[Embed(source="1024.png")]
      private static const _bitmapData:Class;
      
      private static const bitmapData:BitmapData = new _bitmapData().bitmapData;
       
      
      private var bitmap:Bitmap;
      
      public function CaptchaRefreshButton()
      {
         super();
         this.bitmap = new Bitmap(bitmapData);
         addChild(this.bitmap);
         addEventListener(MouseEvent.MOUSE_DOWN,this.mouseHandler);
         addEventListener(MouseEvent.MOUSE_UP,this.mouseHandler);
      }
      
      private function mouseHandler(event:MouseEvent) : void
      {
         this.bitmap.y = event.type == MouseEvent.MOUSE_DOWN ? Number(Number(1)) : Number(Number(0));
      }
   }
}
