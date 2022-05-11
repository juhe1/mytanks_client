package alternativa.tanks.model.shop
{
   import alternativa.init.Main;
   import alternativa.osgi.service.locale.ILocaleService;
   import alternativa.tanks.model.shop.bugreport.PaymentBugReportBlock;
   import alternativa.tanks.model.shop.items.crystallitem.CrystalPackageItem;
   import controls.TankWindow;
   import controls.base.DefaultButtonBase;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   
   public class ShopWindow extends Sprite
   {
      
      public static var localeService:ILocaleService = Main.osgi.getService(ILocaleService) as ILocaleService;
      
      public static const WINDOW_PADDING:int = 11;
      
      public static const SPACE_MODULE:int = 7;
      
      public static var haveDoubleCrystalls:Boolean = false;
       
      
      private var tankWindow:TankWindow;
      
      private var categories:ShopCategorysView;
      
      private var bugReportBlock:PaymentBugReportBlock;
      
      public var header:ShowWindowHeader;
      
      private var closeButton:DefaultButtonBase;
      
      public function ShopWindow()
      {
         this.tankWindow = new TankWindow();
         this.categories = new ShopCategorysView();
         this.header = new ShowWindowHeader();
         super();
         addChild(this.tankWindow);
         this.tankWindow.width = 915;
         this.tankWindow.height = 691;
         this.header.x = WINDOW_PADDING;
         this.header.y = WINDOW_PADDING;
         this.header.resize(915 - WINDOW_PADDING * 2);
         this.closeButton = new DefaultButtonBase();
         this.closeButton.tabEnabled = false;
         this.closeButton.label = "Закрыть";
         this.closeButton.x = this.tankWindow.width - this.closeButton.width - 2 * WINDOW_PADDING;
         this.closeButton.y = this.tankWindow.height - this.closeButton.height - WINDOW_PADDING;
         this.closeButton.addEventListener(MouseEvent.CLICK,this.onClickClose);
         addChild(this.closeButton);
         this.bugReportBlock = new PaymentBugReportBlock();
         this.bugReportBlock.x = WINDOW_PADDING;
         this.bugReportBlock.y = this.closeButton.y - WINDOW_PADDING - this.bugReportBlock.height;
         this.bugReportBlock.width = this.tankWindow.width - WINDOW_PADDING - this.bugReportBlock.x;
         addChild(this.bugReportBlock);
         this.tankWindow.addChild(this.categories);
         this.tankWindow.addChild(this.header);
         this.categories.x = WINDOW_PADDING;
         this.categories.y = this.header.y + this.header.height + SPACE_MODULE - 2;
      }
      
      private function onClickClose(e:MouseEvent) : void
      {
         dispatchEvent(new Event(Event.CLOSE));
      }
      
      public function addCategory(header:String, description:String, categoryId:String) : void
      {
         this.categories.addCategory(new ShopCategoryView(header,description,categoryId));
         this.categories.render(this.tankWindow.width - WINDOW_PADDING * 2,this.bugReportBlock.y - this.categories.y - WINDOW_PADDING);
      }
      
      public function addItem(categoryId:String, itemId:String, additionalData:Object) : void
      {
         if(itemId.indexOf("crystal") >= 0)
         {
            this.categories.addItem(categoryId,new CrystalPackageItem(itemId,additionalData));
         }
         this.categories.render(this.tankWindow.width - WINDOW_PADDING * 2,this.bugReportBlock.y - this.categories.y - WINDOW_PADDING);
      }
   }
}
