package alternativa.tanks.gui
{
   import alternativa.init.Main;
   import alternativa.object.ClientObject;
   import alternativa.osgi.service.locale.ILocaleService;
   import alternativa.tanks.locale.constants.ImageConst;
   import alternativa.tanks.locale.constants.TextConst;
   import controls.DefaultButton;
   import controls.Label;
   import controls.TankWindow;
   import controls.TankWindowHeader;
   import controls.TankWindowInner;
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.Sprite;
   import flash.geom.Point;
   import flash.text.TextFormatAlign;
   
   public class CongratulationsWindowPresent extends Sprite
   {
      
      private static var abonBd:BitmapData;
      
[Embed(source="1194.png")]
      private static const bitmapCrys:Class;
      
      private static const crysBd:BitmapData = new bitmapCrys().bitmapData;
      
[Embed(source="1116.png")]
      private static const bitmapCryss:Class;
      
      private static const crys:BitmapData = new bitmapCryss().bitmapData;
      
      public static const CRYSTALS:int = 0;
      
      public static const NOSUPPLIES:int = 1;
      
      public static const DOUBLE_CRYSTALLS:int = 2;
       
      
      private var window:TankWindow;
      
      private var inner:TankWindowInner;
      
      private var messageTopLabel:Label;
      
      private var messageBottomLabel:Label;
      
      private var presentBitmap:Bitmap;
      
      public var closeButton:DefaultButton;
      
      private var bannerObject:ClientObject;
      
      private var bannerContainer:Sprite;
      
      private var bannerBmp:Bitmap;
      
      private var bannerURL:String;
      
      private var windowWidth:int = 450;
      
      private const windowMargin:int = 12;
      
      private const margin:int = 9;
      
      private const buttonSize:Point = new Point(104,33);
      
      private const space:int = 8;
      
      public function CongratulationsWindowPresent(type:int, bannerObject:ClientObject, numCrystals:int = 0)
      {
         var messageTop:String = null;
         var messageBottom:String = null;
         super();
         var localeService:ILocaleService = ILocaleService(Main.osgi.getService(ILocaleService));
         this.bannerContainer = new Sprite();
         this.bannerBmp = new Bitmap();
         this.bannerContainer.addChild(this.bannerBmp);
         if(type == CRYSTALS)
         {
            this.presentBitmap = new Bitmap(crysBd);
            messageTop = ILocaleService(Main.osgi.getService(ILocaleService)).getText(TextConst.FREE_BONUSES_WINDOW_MESSAGE_TEXT);
            messageBottom = TextConst.setVarsInString(ILocaleService(Main.osgi.getService(ILocaleService)).getText(TextConst.FREE_BONUSES_WINDOW_MESSAGE_CRYSTALS_TEXT),numCrystals);
         }
         else if(type == NOSUPPLIES)
         {
            this.presentBitmap = new Bitmap(ILocaleService(Main.osgi.getService(ILocaleService)).getImage(ImageConst.CONGRATULATION_WINDOW_TICKET_IMAGE));
            messageTop = ILocaleService(Main.osgi.getService(ILocaleService)).getText(TextConst.FREE_BONUSES_WINDOW_MESSAGE_TEXT);
            messageBottom = ILocaleService(Main.osgi.getService(ILocaleService)).getText(TextConst.FREE_BONUSES_WINDOW_MESSAGE_NOSUPPLIES_TEXT);
         }
         else
         {
            this.presentBitmap = new Bitmap(crys);
            messageTop = "";
            messageBottom = ILocaleService(Main.osgi.getService(ILocaleService)).getText(TextConst.FREE_BONUSES_WINDOW_MESSAGE_DOUBLECRYSTALLS_TEXT);
         }
         if(type == 0 || type == 1)
         {
            this.windowWidth = this.presentBitmap.width + this.windowMargin * 2 + this.margin * 2;
            this.window = new TankWindow(this.windowWidth,this.presentBitmap.height);
            addChild(this.window);
            this.window.headerLang = ILocaleService(Main.osgi.getService(ILocaleService)).getText(TextConst.GUI_LANG);
            this.window.header = TankWindowHeader.CONGRATULATIONS;
            this.inner = new TankWindowInner(0,0,TankWindowInner.GREEN);
            addChild(this.inner);
            this.inner.x = this.windowMargin;
            this.inner.y = this.windowMargin;
            this.messageTopLabel = new Label();
            this.messageTopLabel.align = TextFormatAlign.CENTER;
            this.messageTopLabel.wordWrap = true;
            this.messageTopLabel.multiline = true;
            this.messageTopLabel.size = 12;
            this.messageTopLabel.text = messageTop;
            this.messageTopLabel.color = 5898034;
            this.messageTopLabel.x = this.windowMargin * 2;
            this.messageTopLabel.y = this.windowMargin * 2;
            this.messageTopLabel.width = this.windowWidth - this.windowMargin * 4;
            addChild(this.messageTopLabel);
            this.presentBitmap.x = this.margin + this.windowMargin;
            this.presentBitmap.y = this.messageTopLabel.y + this.messageTopLabel.height - 20;
            addChild(this.presentBitmap);
            this.messageBottomLabel = new Label();
            this.messageBottomLabel.align = TextFormatAlign.CENTER;
            this.messageBottomLabel.wordWrap = true;
            this.messageBottomLabel.multiline = true;
            this.messageBottomLabel.size = 12;
            this.messageBottomLabel.color = 5898034;
            this.messageBottomLabel.htmlText = messageBottom;
            this.messageBottomLabel.x = this.windowMargin * 2;
            this.messageBottomLabel.y = this.presentBitmap.y + this.presentBitmap.height - 20;
            this.messageBottomLabel.width = this.windowWidth - this.windowMargin * 4;
            addChild(this.messageBottomLabel);
            this.closeButton = new DefaultButton();
            addChild(this.closeButton);
            this.closeButton.label = ILocaleService(Main.osgi.getService(ILocaleService)).getText(TextConst.FREE_BONUSES_WINDOW_BUTTON_CLOSE_TEXT);
            this.window.height = this.messageBottomLabel.y + this.messageBottomLabel.height + this.closeButton.height + this.margin * 3;
            this.closeButton.y = this.window.height - this.margin - 35;
            this.closeButton.x = this.window.width - this.closeButton.width >> 1;
            this.inner.width = this.window.width - this.windowMargin * 2;
            this.inner.height = this.window.height - this.windowMargin - this.margin * 2 - this.buttonSize.y + 2;
         }
         else
         {
            this.windowWidth = this.presentBitmap.width * 2 - this.windowMargin * 2 + 5;
            this.window = new TankWindow(this.windowWidth,this.presentBitmap.height);
            addChild(this.window);
            this.window.headerLang = ILocaleService(Main.osgi.getService(ILocaleService)).getText(TextConst.GUI_LANG);
            this.window.header = TankWindowHeader.CONGRATULATIONS;
            this.inner = new TankWindowInner(0,0,TankWindowInner.GREEN);
            addChild(this.inner);
            this.inner.x = this.windowMargin;
            this.inner.y = this.windowMargin;
            this.messageTopLabel = new Label();
            this.messageTopLabel.align = TextFormatAlign.LEFT;
            this.messageTopLabel.wordWrap = true;
            this.messageTopLabel.multiline = true;
            this.messageTopLabel.size = 12;
            this.messageTopLabel.text = messageTop;
            this.messageTopLabel.color = 5898034;
            this.messageTopLabel.x = this.windowMargin * 2;
            this.messageTopLabel.y = this.windowMargin * 2;
            this.messageTopLabel.width = this.windowWidth - this.windowMargin * 4;
            addChild(this.messageTopLabel);
            this.messageBottomLabel = new Label();
            this.messageBottomLabel.align = TextFormatAlign.LEFT;
            this.messageBottomLabel.wordWrap = true;
            this.messageBottomLabel.multiline = true;
            this.messageBottomLabel.size = 12;
            this.messageBottomLabel.color = 5898034;
            this.messageBottomLabel.htmlText = messageBottom;
            this.messageBottomLabel.x = this.windowMargin * 2;
            this.messageBottomLabel.y = this.messageTopLabel.y + this.messageTopLabel.height - 7;
            this.messageBottomLabel.width = this.windowWidth - this.windowMargin * 4;
            addChild(this.messageBottomLabel);
            this.presentBitmap.x = this.presentBitmap.width / 2 + this.inner.width / 2 - 25;
            this.presentBitmap.y = this.messageBottomLabel.y + this.messageBottomLabel.height + 10;
            addChild(this.presentBitmap);
            this.closeButton = new DefaultButton();
            addChild(this.closeButton);
            this.closeButton.label = ILocaleService(Main.osgi.getService(ILocaleService)).getText(TextConst.FREE_BONUSES_WINDOW_BUTTON_CLOSE_TEXT);
            this.window.height = this.presentBitmap.y + this.messageBottomLabel.height + this.closeButton.height + this.margin * 3;
            this.closeButton.y = this.window.height - this.margin - 35;
            this.closeButton.x = this.window.width - this.closeButton.width >> 1;
            this.inner.width = this.window.width - this.windowMargin * 2;
            this.inner.height = this.window.height - this.windowMargin - this.margin * 2 - this.buttonSize.y + 2;
         }
      }
   }
}
