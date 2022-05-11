package alternativa.debug
{
   import alternativa.init.*;
   import alternativa.osgi.service.locale.*;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.filters.BitmapFilterQuality;
   import flash.filters.DropShadowFilter;
   import flash.geom.Point;
   import flash.text.*;
   
   public class ServerMessageWindow extends Sprite
   {
       
      
      private var message:TextField;
      
      private var buttonOk:Sprite;
      
      private var buttonText:TextField;
      
      private var _currentSize:Point;
      
      public function ServerMessageWindow()
      {
         var lang1:* = undefined;
         super();
         mouseEnabled = false;
         tabEnabled = false;
         this.message = new TextField();
         this.message.thickness = 50;
         this.message.sharpness = -50;
         with(this.message)
         {
            width = 250;
            y = 25;
            defaultTextFormat = new TextFormat("Tahoma",11,0);
            type = TextFieldType.DYNAMIC;
            autoSize = TextFieldAutoSize.CENTER;
            antiAliasType = AntiAliasType.ADVANCED;
            embedFonts = false;
            selectable = true;
            multiline = true;
            wordWrap = true;
         }
         addChild(this.message);
         this.buttonOk = new Sprite();
         this.buttonOk.graphics.beginFill(16777215,1);
         this.buttonOk.graphics.lineStyle(1,6710886);
         this.buttonOk.graphics.drawRoundRect(0,0,60,30,5,5);
         addChild(this.buttonOk);
         this.buttonOk.addEventListener(MouseEvent.CLICK,this.onOkButtonClick);
         this.buttonText = new TextField();
         this.buttonText.thickness = 50;
         this.buttonText.sharpness = -50;
         with(this.buttonText)
         {
            defaultTextFormat = new TextFormat("Tahoma",12,0,true);
            type = TextFieldType.DYNAMIC;
            autoSize = TextFieldAutoSize.NONE;
            antiAliasType = AntiAliasType.ADVANCED;
            embedFonts = false;
            selectable = true;
            multiline = false;
            mouseEnabled = false;
            tabEnabled = false;
            lang1 = ILocaleService(Main.osgi.getService(ILocaleService)).language;
            if(lang1 != null && lang1.toLocaleLowerCase() == "cn")
            {
               text = "чбошод";
            }
            else
            {
               text = "OK";
            }
         }
         addChild(this.buttonText);
         this._currentSize = new Point(300,200);
         this.filters = [new DropShadowFilter(3,70,0,0.5,2,2,1,BitmapFilterQuality.MEDIUM,false,false,false)];
         this.repaint();
      }
      
      public function set text(value:String) : void
      {
         this.message.text = value;
         this._currentSize.x = Math.max(Math.round(this.message.length * 0.5),300);
         this.message.width = this._currentSize.x - 50;
         this.message.x = Math.round((this._currentSize.x - this.message.textWidth) * 0.5);
         this.repaint();
      }
      
      public function get currentSize() : Point
      {
         return this._currentSize;
      }
      
      private function repaint() : void
      {
         this._currentSize.y = 25 + this.message.textHeight + 30 + this.buttonOk.height;
         this.graphics.clear();
         this.graphics.beginFill(13421772,1);
         this.graphics.drawRoundRect(0,0,this._currentSize.x,this._currentSize.y,5,5);
         this.buttonOk.x = Math.round((this._currentSize.x - this.buttonOk.width) * 0.5);
         this.buttonOk.y = Math.round(this._currentSize.y - 15 - this.buttonOk.height);
         this.buttonText.x = Math.round(this.buttonOk.x + (this.buttonOk.width - this.buttonText.textWidth) * 0.5 - 2);
         this.buttonText.y = Math.round(this.buttonOk.y + (this.buttonOk.height - (this.buttonText.textHeight - 3)) * 0.5 - 3);
      }
      
      private function onOkButtonClick(e:MouseEvent) : void
      {
         Main.debug.hideServerMessageWindow();
      }
   }
}
