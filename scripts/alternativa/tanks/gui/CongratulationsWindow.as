package alternativa.tanks.gui
{
   import alternativa.init.Main;
   import alternativa.osgi.service.locale.ILocaleService;
   import alternativa.service.IResourceService;
   import alternativa.tanks.locale.constants.TextConst;
   import assets.icons.GarageItemBackground;
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
   
   public class CongratulationsWindow extends Sprite
   {
       
      
      private var window:TankWindow;
      
      private var inner:TankWindowInner;
      
      public var closeButton:DefaultButton;
      
      private var messageLabel:Label;
      
      private var windowSize:Point;
      
      private var windowWidth:int = 450;
      
      private const windowMargin:int = 12;
      
      private const margin:int = 9;
      
      private const buttonSize:Point = new Point(104,33);
      
      private const space:int = 8;
      
      public function CongratulationsWindow(message:String, items:Array, center:Boolean = false)
      {
         var preview:Bitmap = null;
         preview = null;
         var numLabel:Label = null;
         super();
         var bg:GarageItemBackground = new GarageItemBackground(GarageItemBackground.ENGINE_NORMAL);
         this.windowWidth = bg.width + this.windowMargin * 2 + this.margin * 2 + (items.length > 1 ? bg.width + this.space : 0);
         var resourceService:IResourceService = IResourceService(Main.osgi.getService(IResourceService));
         this.messageLabel = new Label();
         this.messageLabel.wordWrap = true;
         this.messageLabel.multiline = true;
         this.messageLabel.htmlText = message;
         if(center)
         {
            this.messageLabel.align = TextFormatAlign.CENTER;
         }
         this.messageLabel.size = 12;
         this.messageLabel.color = 5898034;
         this.messageLabel.x = this.windowMargin * 2;
         this.messageLabel.y = this.windowMargin * 2;
         this.messageLabel.width = this.windowWidth - this.windowMargin * 4;
         var previewBd:BitmapData = new BitmapData(100,100);
         this.windowSize = new Point(this.windowWidth,this.messageLabel.height + bg.height * Math.round(items.length / 2) + this.buttonSize.y + this.windowMargin * 3 + this.margin * 3 + (items.length > 2 ? this.space : 0));
         this.window = new TankWindow(this.windowSize.x,this.windowSize.y);
         addChild(this.window);
         this.window.headerLang = ILocaleService(Main.osgi.getService(ILocaleService)).getText(TextConst.GUI_LANG);
         if(center)
         {
            this.window.header = TankWindowHeader.INFORMATION;
         }
         else
         {
            this.window.header = TankWindowHeader.CONGRATULATIONS;
         }
         this.inner = new TankWindowInner(0,0,TankWindowInner.GREEN);
         addChild(this.inner);
         this.inner.x = this.windowMargin;
         this.inner.y = this.windowMargin;
         this.inner.width = this.windowSize.x - this.windowMargin * 2;
         this.inner.height = this.windowSize.y - this.windowMargin - this.margin * 2 - this.buttonSize.y + 2;
         addChild(this.messageLabel);
         for(var i:int = 0; i < items.length; preview.x = bg.x + (bg.width - preview.width >> 1),preview.y = bg.y + (bg.height - preview.height >> 1),numLabel = new Label(),numLabel.size = 16,numLabel.color = 5898034,numLabel.text = "×" + "400",addChild(numLabel),numLabel.x = bg.x + bg.width - numLabel.width - 15,numLabel.y = bg.y + bg.height - numLabel.height - 10,i++)
         {
            bg = new GarageItemBackground(GarageItemBackground.ENGINE_NORMAL);
            addChild(bg);
            previewBd = new BitmapData(100,100);
            preview = new Bitmap(previewBd);
            addChild(preview);
            switch(items.length)
            {
               case 1:
                  bg.x = this.windowSize.x - bg.width >> 1;
                  bg.y = this.messageLabel.y + this.messageLabel.height + this.windowMargin;
                  continue;
               case 2:
                  bg.x = i == 0 ? Number(Number(this.inner.x + this.margin)) : Number(Number(this.inner.x + this.margin + bg.width + this.space));
                  bg.y = this.messageLabel.y + this.messageLabel.height + this.windowMargin;
                  continue;
               case 3:
                  if(i == 2)
                  {
                     bg.x = this.windowSize.x - bg.width >> 1;
                     bg.y = this.messageLabel.y + this.messageLabel.height + this.windowMargin + bg.height + this.space;
                  }
                  else
                  {
                     bg.x = i == 0 ? Number(Number(this.inner.x + this.margin)) : Number(Number(this.inner.x + this.margin + bg.width + this.space));
                     bg.y = this.messageLabel.y + this.messageLabel.height + this.windowMargin;
                  }
                  continue;
               case 4:
                  bg.x = i == 0 || i == 2 ? Number(Number(this.inner.x + this.margin)) : Number(Number(this.inner.x + this.margin + bg.width + this.space));
                  if(i > 1)
                  {
                     bg.y = this.messageLabel.y + this.messageLabel.height + this.windowMargin + bg.height + this.space;
                     break;
                  }
                  bg.y = this.messageLabel.y + this.messageLabel.height + this.windowMargin;
                  break;
            }
         }
         this.closeButton = new DefaultButton();
         addChild(this.closeButton);
         this.closeButton.label = ILocaleService(Main.osgi.getService(ILocaleService)).getText(TextConst.FREE_BONUSES_WINDOW_BUTTON_CLOSE_TEXT);
         this.closeButton.x = this.windowSize.x - this.buttonSize.x >> 1;
         this.closeButton.y = this.windowSize.y - this.margin - this.buttonSize.y - 2;
      }
   }
}
