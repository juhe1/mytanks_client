package alternativa.tanks.model.shop
{
   import alternativa.init.Main;
   import alternativa.osgi.service.locale.ILocaleService;
   import alternativa.osgi.service.mainContainer.IMainContainerService;
   import alternativa.tanks.model.panel.IPanel;
   import alternativa.tanks.model.panel.PanelModel;
   import alternativa.tanks.model.shop.event.ShopItemChosen;
   import flash.display.DisplayObjectContainer;
   import flash.events.Event;
   import scpacker.networking.INetworker;
   import scpacker.networking.Network;
   
   public class ShopModel
   {
       
      
      private var localeService:ILocaleService;
      
      private var dialogsService:DisplayObjectContainer;
      
      private var window:ShopWindow;
      
      public function ShopModel()
      {
         super();
      }
      
      public function init(json:Object) : void
      {
         var category:Object = null;
         var items:Array = null;
         var item:Object = null;
         this.localeService = Main.osgi.getService(ILocaleService) as ILocaleService;
         this.dialogsService = (Main.osgi.getService(IMainContainerService) as IMainContainerService).dialogsLayer as DisplayObjectContainer;
         ShopWindow.haveDoubleCrystalls = json.have_double_crystals;
         this.window = new ShopWindow();
         var data:Object = json.data;
         var lang:String = (Main.osgi.getService(ILocaleService) as ILocaleService).language;
         if(lang == null)
         {
            lang = "EN";
         }
         else
         {
            lang = lang.toUpperCase();
         }
         var categories:Array = data.categories;
         for each(category in categories)
         {
            this.window.addCategory(category.header_text[lang],category.description[lang],category.category_id);
         }
         items = data.items;
         for each(item in items)
         {
            this.window.addItem(item.category_id,item.item_id,item.additional_data);
         }
         this.window.addEventListener(ShopItemChosen.EVENT_TYPE,this.onSelectItem);
      }
      
      private function onClose(e:Event) : void
      {
         this.dialogsService.removeChild(this.window);
         this.window.removeEventListener(Event.CLOSE,this.onClose);
         Main.stage.removeEventListener(Event.RESIZE,this.onResize);
         PanelModel(Main.osgi.getService(IPanel)).closeShopWindow();
         this.window = null;
      }
      
      private function onResize(e:Event = null) : void
      {
         this.window.x = Math.round((Main.stage.stageWidth - this.window.width) * 0.5);
         this.window.y = Math.round((Main.stage.stageHeight - this.window.height) * 0.5);
      }
      
      public function onEventWindow() : void
      {
         this.window.addEventListener(Event.CLOSE,this.onClose);
         Main.stage.addEventListener(Event.RESIZE,this.onResize);
         this.dialogsService.addChild(this.window);
         this.onResize();
      }
      
      private function onSelectItem(e:ShopItemChosen) : void
      {
         Network(Main.osgi.getService(INetworker)).send("lobby;shop_buy_item;" + e.itemId);
      }
   }
}
