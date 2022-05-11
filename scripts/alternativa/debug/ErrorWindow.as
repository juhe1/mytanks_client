package alternativa.debug
{
   import alternativa.init.Main;
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import flash.text.*;
   
   public class ErrorWindow extends Sprite
   {
      
[Embed(source="781.png")]
      private static const backBitmap:Class;
      
      private static const backBd:BitmapData = new backBitmap().bitmapData;
      
[Embed(source="1029.png")]
      private static const okButtonBitmap:Class;
      
      private static const okButtonBd:BitmapData = new okButtonBitmap().bitmapData;
       
      
      private var back:Bitmap;
      
      private var message:TextField;
      
      private var buttonOkBitmap:Bitmap;
      
      private var buttonOk:Sprite;
      
      private var _currentSize:Point;
      
      public function ErrorWindow()
      {
         super();
         mouseEnabled = false;
         tabEnabled = false;
         this.back = new Bitmap(backBd);
         addChild(this.back);
         this.back.x = -7;
         this.back.y = -7;
         this.message = new TextField();
         this.message.thickness = 50;
         this.message.sharpness = -50;
         with(this.message)
         {
            defaultTextFormat = new TextFormat("Sign",12,0);
            defaultTextFormat.leading = 30;
            type = TextFieldType.DYNAMIC;
            autoSize = TextFieldAutoSize.NONE;
            antiAliasType = AntiAliasType.ADVANCED;
            embedFonts = true;
            selectable = true;
            multiline = false;
            mouseEnabled = false;
            tabEnabled = false;
         }
         addChild(this.message);
         this.buttonOk = new Sprite();
         addChild(this.buttonOk);
         this.buttonOkBitmap = new Bitmap(okButtonBd);
         this.buttonOk.addChild(this.buttonOkBitmap);
         this.buttonOk.addEventListener(MouseEvent.CLICK,this.onOkButtonClick);
         this._currentSize = new Point(367,248);
         this.repaint();
      }
      
      public function set text(value:String) : void
      {
         this.message.width = 300;
         this.message.text = value;
         this.message.x = (this._currentSize.x - this.message.textWidth) * 0.5;
         this.message.y = 38;
      }
      
      public function get currentSize() : Point
      {
         return this._currentSize;
      }
      
      private function repaint() : void
      {
         this.message.autoSize = TextFieldAutoSize.CENTER;
         this.message.width = 200;
         this.message.autoSize = TextFieldAutoSize.NONE;
         this.message.x = (this._currentSize.x - this.message.textWidth) * 0.5;
         this.message.y = 38;
         this.buttonOk.x = (this._currentSize.x - this.buttonOk.width) * 0.5;
         this.buttonOk.y = this._currentSize.y - 30 - this.buttonOk.height;
      }
      
      private function onOkButtonClick(e:MouseEvent) : void
      {
         Main.debug.hideErrorWindow();
      }
   }
}
