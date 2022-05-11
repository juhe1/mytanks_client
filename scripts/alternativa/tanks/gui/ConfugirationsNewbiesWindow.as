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
   
   public class ConfugirationsNewbiesWindow extends Sprite
   {
      
[Embed(source="985.png")]
      private static const b:Class;
      
      private static var bitmap:BitmapData = new b().bitmapData;
       
      
      private var window:TankWindow;
      
      private var inner:TankWindowInner;
      
      private var message:Label;
      
      private var presentBitmap:Bitmap;
      
      public var closeButton:DefaultButton;
      
      public function ConfugirationsNewbiesWindow(textId:String)
      {
         var preview:Bitmap = null;
         super();
         this.window = new TankWindow(290,315);
         addChild(this.window);
         this.window.headerLang = ILocaleService(Main.osgi.getService(ILocaleService)).getText(TextConst.GUI_LANG);
         this.window.header = TankWindowHeader.CONGRATULATIONS;
         this.inner = new TankWindowInner(290 - 12 * 2,315 - 12 - 50,TankWindowInner.GREEN);
         addChild(this.inner);
         this.inner.x = 12;
         this.inner.y = 12;
         this.message = new Label();
         this.message.align = TextFormatAlign.LEFT;
         this.message.wordWrap = true;
         this.message.multiline = true;
         this.message.size = 12;
         this.message.text = ILocaleService(Main.osgi.getService(ILocaleService)).getText(textId);
         this.message.color = 5898034;
         this.message.x = 12 * 2;
         this.message.y = 12 * 2;
         this.message.width = 290 - 12 * 4;
         addChild(this.message);
         this.closeButton = new DefaultButton();
         addChild(this.closeButton);
         this.closeButton.label = ILocaleService(Main.osgi.getService(ILocaleService)).getText(TextConst.FREE_BONUSES_WINDOW_BUTTON_CLOSE_TEXT);
         this.closeButton.y = this.window.height - 35 - 8;
         this.closeButton.x = this.window.width - this.closeButton.width >> 1;
         preview = new Bitmap(bitmap);
         preview.x = this.window.width - preview.width >> 1;
         preview.y = this.window.height - 160;
         addChild(preview);
      }
   }
}
