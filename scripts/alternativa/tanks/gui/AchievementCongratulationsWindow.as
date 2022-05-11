package alternativa.tanks.gui
{
   import alternativa.init.Main;
   import alternativa.osgi.service.locale.ILocaleService;
   import alternativa.tanks.locale.constants.TextConst;
   import controls.DefaultButton;
   import controls.Label;
   import controls.TankWindow;
   import controls.TankWindowHeader;
   import controls.TankWindowInner;
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.Sprite;
   import flash.text.TextFormatAlign;
   
   public class AchievementCongratulationsWindow extends Sprite
   {
      
[Embed(source="777.png")]
      private static const _p:Class;
      
      private static var bitmapData:BitmapData = new _p().bitmapData;
       
      
      private var window:TankWindow;
      
      private var inner:TankWindowInner;
      
      private var message:Label;
      
      private var present:Bitmap;
      
      public var closeBtn:DefaultButton;
      
      public function AchievementCongratulationsWindow()
      {
         super();
      }
      
      public function init(msg:String) : void
      {
         this.present = new Bitmap(bitmapData);
         this.window = new TankWindow(Math.max(this.present.width + 12 * 2 + 9 * 2,300));
         this.window.headerLang = ILocaleService(Main.osgi.getService(ILocaleService)).getText(TextConst.GUI_LANG);
         this.window.header = TankWindowHeader.CONGRATULATIONS;
         addChild(this.window);
         this.inner = new TankWindowInner(0,0,TankWindowInner.GREEN);
         addChild(this.inner);
         this.inner.x = 12;
         this.inner.y = 12;
         this.message = new Label();
         this.message.align = TextFormatAlign.CENTER;
         this.message.wordWrap = true;
         this.message.multiline = true;
         this.message.size = 12;
         this.message.htmlText = msg;
         this.message.color = 5898034;
         this.message.x = 12 * 2;
         this.message.y = 12 * 2;
         this.message.width = this.window.width - 12 * 4;
         addChild(this.message);
         if(this.message.numLines > 2)
         {
            this.message.align = TextFormatAlign.LEFT;
            this.message.htmlText = msg;
            this.message.width = this.window.width - 12 * 4;
         }
         this.present.x = this.window.width - this.present.width >> 1;
         this.present.y = this.message.y + this.message.height + 9;
         addChild(this.present);
         this.closeBtn = new DefaultButton();
         this.closeBtn.label = ILocaleService(Main.osgi.getService(ILocaleService)).getText(TextConst.FREE_BONUSES_WINDOW_BUTTON_CLOSE_TEXT);
         addChild(this.closeBtn);
         var height:int = this.present.height + this.closeBtn.height + 9 * 2 + 12 * 3;
         height += this.message.height + 9;
         this.window.height = height;
         this.closeBtn.y = this.window.height - 9 - 35;
         this.closeBtn.x = this.window.width - this.closeBtn.width >> 1;
         this.inner.width = this.window.width - 12 * 2;
         this.inner.height = this.window.height - 12 - 9 * 2 - 33 + 2;
      }
   }
}
