package alternativa.tanks.model.news
{
   import alternativa.init.Main;
   import alternativa.osgi.service.locale.ILocaleService;
   import alternativa.tanks.locale.constants.TextConst;
   import controls.DefaultButton;
   import controls.TankWindow;
   import controls.TankWindowHeader;
   import controls.TankWindowInner;
   import flash.display.Sprite;
   
   public class NewsWindow extends Sprite
   {
      
      public static const MAX_HEIGHT:int = 400;
       
      
      private var window:TankWindow;
      
      private var inner:TankWindowInner;
      
      private var items:NewsOutput;
      
      public var closeBtn:DefaultButton;
      
      private var itemsSpriteHeight:int;
      
      public function NewsWindow()
      {
         this.window = new TankWindow();
         this.inner = new TankWindowInner(0,0,TankWindowInner.GREEN);
         this.items = new NewsOutput();
         this.closeBtn = new DefaultButton();
         super();
         this.x = 100;
         this.y = 100;
         this.window.width = 500;
         this.window.height = 250;
         this.window.headerLang = ILocaleService(Main.osgi.getService(ILocaleService)).language;
         this.window.header = TankWindowHeader.ATTANTION;
         addChild(this.window);
         this.inner.x = 10;
         this.inner.y = 10;
         this.inner.width = this.window.width - 20;
         this.inner.height = this.window.height - 60;
         this.window.addChild(this.inner);
         addChild(this.items);
         this.items.move(15,30);
         addChild(this.closeBtn);
         this.closeBtn.label = ILocaleService(Main.osgi.getService(ILocaleService)).getText(TextConst.FREE_BONUSES_WINDOW_BUTTON_CLOSE_TEXT);
         this.closeBtn.y = this.window.height + 106;
         this.closeBtn.x = this.window.width - this.closeBtn.width >> 1;
      }
      
      public function setItems(array:Array) : void
      {
         var item:NewsItem = null;
         var prevItem:NewsItem = null;
         item = null;
         for each(item in array)
         {
            if(prevItem == null)
            {
               this.items.addItem(item);
               prevItem = item;
            }
            else
            {
               item.y = prevItem.y + prevItem.height + 10;
               this.items.addItem(item);
               prevItem = item;
            }
            this.itemsSpriteHeight += item.heigth;
         }
         this.redraw();
      }
      
      public function getHeigth() : Number
      {
         return this.window.height;
      }
      
      private function redraw() : void
      {
         this.window.height = Math.min(this.itemsSpriteHeight + 130,MAX_HEIGHT);
         this.inner.height = Math.min(this.window.height - 60,MAX_HEIGHT);
         this.items.height = Math.min(this.window.height - 100,MAX_HEIGHT);
         this.closeBtn.y = this.window.height - 44;
      }
   }
}
