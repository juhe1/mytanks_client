package alternativa.tanks.gui
{
   import alternativa.init.Main;
   import alternativa.osgi.service.locale.ILocaleService;
   import alternativa.service.IModelService;
   import alternativa.service.IResourceService;
   import alternativa.tanks.locale.constants.TextConst;
   import alternativa.tanks.model.ItemParams;
   import alternativa.tanks.model.panel.IPanel;
   import alternativa.types.Long;
   import com.alternativaplatform.projects.tanks.client.commons.models.itemtype.ItemTypeEnum;
   import com.alternativaplatform.projects.tanks.client.garage.garage.ItemInfo;
   import controls.TankWindow;
   import controls.TankWindowHeader;
   import controls.TankWindowInner;
   import flash.display.BitmapData;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import forms.events.PartsListEvent;
   import forms.garage.PartsList;
   import scpacker.resource.ResourceType;
   import scpacker.resource.ResourceUtil;
   import scpacker.resource.images.ImageResource;
   
   public class GarageWindow extends Sprite
   {
       
      
      private var resourceRegister:IResourceService;
      
      private var modelRegister:IModelService;
      
      private var localeService:ILocaleService;
      
      private var windowSize:Point;
      
      private const windowMargin:int = 11;
      
      private const buttonSize:Point = new Point(104,33);
      
      private var myItemsWindow:TankWindow;
      
      private var myItemsInner:TankWindowInner;
      
      private var warehouseList:PartsList;
      
      private var shopItemsWindow:TankWindow;
      
      private var shopItemsInner:TankWindowInner;
      
      private var storeList:PartsList;
      
      public var itemInfoPanel:ItemInfoPanel;
      
      public var inventorySelected:Boolean;
      
      public var storeItemSelected:Boolean;
      
      public var selectedItemId:String;
      
      private var itemsInWarehouse:Array;
      
      private var itemsInStore:Array;
      
      public var tankPreview:TankPreview;
      
      public const itemInfoPanelWidth:int = 412;
      
      private var i:int = 0;
      
      private var j:int = 0;
      
      public function GarageWindow(garageBoxId:Long)
      {
         super();
         this.resourceRegister = Main.osgi.getService(IResourceService) as IResourceService;
         this.modelRegister = Main.osgi.getService(IModelService) as IModelService;
         this.localeService = Main.osgi.getService(ILocaleService) as ILocaleService;
         this.itemsInWarehouse = new Array();
         this.itemsInStore = new Array();
         this.windowSize = new Point(880,737);
         this.tankPreview = new TankPreview(garageBoxId);
         addChild(this.tankPreview);
         this.itemInfoPanel = new ItemInfoPanel();
         addChild(this.itemInfoPanel);
         if(TankWindow(Main.osgi.getService(TankWindow)) != null)
         {
            this.myItemsWindow = TankWindow(Main.osgi.getService(TankWindow));
         }
         else
         {
            this.myItemsWindow = new TankWindow();
            Main.osgi.registerService(TankWindow,this.myItemsWindow);
         }
         addChild(this.myItemsWindow);
         this.myItemsWindow.headerLang = this.localeService.getText(TextConst.GUI_LANG);
         this.myItemsWindow.header = TankWindowHeader.YOUR_ITEMS;
         this.myItemsInner = new TankWindowInner(0,0,TankWindowInner.GREEN);
         this.myItemsInner.showBlink = true;
         addChild(this.myItemsInner);
         this.warehouseList = new PartsList("warehouse");
         addChild(this.warehouseList);
         this.shopItemsWindow = new TankWindow();
         addChild(this.shopItemsWindow);
         this.shopItemsWindow.headerLang = this.localeService.getText(TextConst.GUI_LANG);
         this.shopItemsWindow.header = TankWindowHeader.SHOP;
         this.shopItemsInner = new TankWindowInner(0,0,TankWindowInner.GREEN);
         this.shopItemsInner.showBlink = true;
         addChild(this.shopItemsInner);
         this.storeList = new PartsList("market");
         addChild(this.storeList);
         this.warehouseList.addEventListener(PartsListEvent.SELECT_PARTS_LIST_ITEM,this.onWarehouseItemSelect);
         this.storeList.addEventListener(PartsListEvent.SELECT_PARTS_LIST_ITEM,this.onStoreItemSelect);
         this.itemInfoPanel.buttonBuy.addEventListener(MouseEvent.CLICK,this.onButtonBuyClick);
         this.itemInfoPanel.buttonEquip.addEventListener(MouseEvent.CLICK,this.onButtonEquipClick);
         this.itemInfoPanel.buttonSkin.addEventListener(MouseEvent.CLICK,this.onSkinButtonClick);
         this.itemInfoPanel.buttonUpgrade.addEventListener(MouseEvent.CLICK,this.onModButtonClick);
         this.itemInfoPanel.buttonBuyCrystals.addEventListener(MouseEvent.CLICK,this.onButtonBuyCrystalsClick);
      }
      
      public function hide() : void
      {
         this.tankPreview.hide();
         this.itemInfoPanel.hide();
         this.tankPreview = null;
         this.itemInfoPanel = null;
         this.resourceRegister = null;
         this.modelRegister = null;
         this.myItemsWindow = null;
         this.myItemsInner = null;
         this.warehouseList = null;
         this.shopItemsWindow = null;
         this.shopItemsInner = null;
         this.storeList = null;
         this.selectedItemId = null;
         this.itemsInWarehouse = null;
         this.itemsInStore = null;
      }
      
      public function resize(width:int, height:int) : void
      {
         Main.writeVarsToConsoleChannel("GARAGE WINDOW","resize width: %1, height: %2",width,height);
         this.windowSize = new Point(width,height);
         this.myItemsWindow.width = width - 27;
         this.myItemsWindow.height = 169;
         this.myItemsWindow.x = 27;
         this.myItemsInner.width = width - this.windowMargin * 2 - 27;
         this.myItemsInner.height = this.myItemsWindow.height - this.windowMargin * 2;
         this.myItemsInner.x = this.windowMargin + 27;
         this.shopItemsWindow.width = width - 27;
         this.shopItemsWindow.height = 169;
         this.shopItemsWindow.x = 27;
         this.shopItemsInner.width = width - this.windowMargin * 2 - 27;
         this.shopItemsInner.height = this.shopItemsWindow.height - this.windowMargin * 2;
         this.shopItemsInner.x = this.windowMargin + 27;
         this.warehouseList.width = this.myItemsWindow.width - this.windowMargin * 2 - 8;
         this.warehouseList.height = this.myItemsWindow.height - this.windowMargin * 2 + 1;
         this.warehouseList.x = this.windowMargin + 4 + 27;
         this.storeList.width = this.shopItemsWindow.width - this.windowMargin * 2 - 8;
         this.storeList.height = this.shopItemsWindow.height - this.windowMargin * 2 + 1;
         this.storeList.x = this.windowMargin + 4 + 27;
         this.tankPreview.resize(width - this.itemInfoPanelWidth,height - this.myItemsWindow.height - this.shopItemsWindow.height,this.x,this.y);
         this.itemInfoPanel.resize(this.itemInfoPanelWidth,height - this.myItemsWindow.height - this.shopItemsWindow.height);
         this.itemInfoPanel.x = width - this.itemInfoPanelWidth;
         this.myItemsWindow.y = height - this.myItemsWindow.height - this.shopItemsWindow.height;
         this.shopItemsWindow.y = this.myItemsWindow.y + this.myItemsWindow.height;
         this.myItemsInner.y = this.myItemsWindow.y + this.windowMargin;
         this.shopItemsInner.y = this.shopItemsWindow.y + this.windowMargin;
         this.warehouseList.y = this.myItemsWindow.y + this.windowMargin + 4;
         this.storeList.y = this.shopItemsWindow.y + this.windowMargin + 4;
      }
      
      public function selectFirstItemInWarehouse() : void
      {
         this.warehouseList.selectByIndex(0);
      }
      
      public function selectItemInWarehouse(itemId:String) : void
      {
         if(itemId.indexOf("HD_") != -1)
         {
            itemId = itemId.replace("HD_","");
         }
         this.warehouseList.select(itemId);
      }
      
      public function unselectInWarehouse() : void
      {
         this.warehouseList.unselect();
      }
      
      public function selectItemInStore(itemId:String) : void
      {
         this.storeList.select(itemId);
      }
      
      public function unselectInStore() : void
      {
         this.storeList.unselect();
      }
      
      public function addItemToWarehouse(itemId:String, itemParams:ItemParams, itemInfo:ItemInfo) : void
      {
         this.itemsInWarehouse.push(itemId);
         var resource:ImageResource = ResourceUtil.getResource(ResourceType.IMAGE,itemId + "_preview") as ImageResource;
         this.warehouseList.addItem(itemId,itemParams.name,itemParams.itemType.value,itemParams.itemIndex,itemParams.price,itemInfo.discount,itemParams.rankId,false,true,itemInfo.count,resource,itemParams.modificationIndex);
      }
      
      public function addItemToStore(itemId:String, itemParams:ItemParams, itemInfo:ItemInfo) : void
      {
         this.itemsInStore.push(itemId);
         var panelModel:IPanel = Main.osgi.getService(IPanel) as IPanel;
         var userRank:int = panelModel.rank;
         var resource:ImageResource = ResourceUtil.getResource(ResourceType.IMAGE,itemId + "_preview") as ImageResource;
         this.storeList.addItem(itemId,itemParams.name,itemParams.itemType.value,itemParams.itemIndex,itemParams.price,itemInfo.discount,userRank >= itemParams.rankId ? int(0) : int(itemParams.rankId),false,false,0,resource,0);
      }
      
      public function removeItemFromWarehouse(itemId:String) : void
      {
         this.warehouseList.deleteItem(itemId);
         var index:int = this.itemsInWarehouse.indexOf(itemId);
         this.itemsInWarehouse.splice(index,1);
      }
      
      public function removeItemFromStore(itemId:String) : void
      {
         this.storeList.deleteItem(itemId);
         var index:int = this.itemsInStore.indexOf(itemId);
         this.itemsInStore.splice(index,1);
      }
      
      public function lockItemInWarehouse(itemId:String) : void
      {
         this.warehouseList.lock(itemId);
      }
      
      public function unlockItemInWarehouse(itemId:String) : void
      {
         this.warehouseList.unlock(itemId);
      }
      
      public function lockItemInStore(itemId:String) : void
      {
         this.storeList.lock(itemId);
      }
      
      public function unlockItemInStore(itemId:String) : void
      {
         this.storeList.unlock(itemId);
      }
      
      public function unmountItem(itemId:String) : void
      {
         this.warehouseList.unmount(itemId);
      }
      
      public function mountItem(itemId:String) : void
      {
         this.warehouseList.mount(itemId);
      }
      
      public function addSkin(itemId:String, itemParams:ItemParams, isBought:Boolean = true) : void
      {
         if(isBought)
         {
            this.itemInfoPanel.availableSkins.push(itemId);
         }
         this.itemInfoPanel.skinsParams[itemId] = itemParams;
      }
      
      public function showItemInfo(itemId:String, itemParams:ItemParams, storeItem:Boolean, itemInfo:ItemInfo = null, mountedItems:Array = null) : void
      {
         this.storeItemSelected = storeItem;
         this.inventorySelected = itemParams.itemType == ItemTypeEnum.INVENTORY;
         if(itemParams.inventoryItem && !storeItem)
         {
            this.warehouseList.updateCount(itemInfo.itemId,itemInfo.count);
         }
         this.itemInfoPanel.showItemInfo(itemId,itemParams,storeItem,itemInfo,mountedItems);
         this.itemInfoPanel.resize(this.itemInfoPanelWidth,this.windowSize.y - this.myItemsWindow.height - this.shopItemsWindow.height);
      }
      
      public function showOtherItemInfo(lastSelectedItemId:Long) : void
      {
         var index:int = this.itemsInWarehouse.indexOf(lastSelectedItemId);
         if(this.itemsInWarehouse[int(index + 1)] != null)
         {
            this.selectedItemId = this.itemsInWarehouse[int(index + 1)];
            this.warehouseList.select(this.selectedItemId);
         }
         else if(this.itemsInWarehouse[int(index - 1)] != null)
         {
            this.selectedItemId = this.itemsInWarehouse[int(index - 1)];
            this.warehouseList.select(this.selectedItemId);
         }
         dispatchEvent(new GarageWindowEvent(GarageWindowEvent.WAREHOUSE_ITEM_SELECTED,this.selectedItemId));
      }
      
      public function updateItemInfo(itemId:Long, itemInfo:ItemInfo, itemParams:ItemParams) : void
      {
         if(itemParams.inventoryItem)
         {
            this.warehouseList.updateCount(itemId,itemInfo.count);
         }
      }
      
      public function scrollToItemInWarehouse(itemId:String) : void
      {
         this.warehouseList.scrollTo(itemId);
      }
      
      public function scrollToItemInStore(itemId:String) : void
      {
         this.storeList.scrollTo(itemId);
      }
      
      public function lockBuyButton() : void
      {
         this.itemInfoPanel.buttonBuy.enable = false;
      }
      
      public function lockUpgradeButton() : void
      {
         this.itemInfoPanel.buttonUpgrade.enable = false;
      }
      
      public function lockMountButton() : void
      {
         Main.writeVarsToConsoleChannel("GARAGE WINDOW","lockMountButton storeItemSelected: " + this.storeItemSelected);
         Main.writeVarsToConsoleChannel("GARAGE WINDOW","lockMountButton inventorySelected: " + this.inventorySelected);
         if(!this.storeItemSelected && !this.inventorySelected)
         {
            this.itemInfoPanel.buttonEquip.enable = false;
         }
      }
      
      public function unlockBuyButton() : void
      {
         this.itemInfoPanel.buttonBuy.enable = true;
      }
      
      public function unlockUpgradeButton() : void
      {
         this.itemInfoPanel.buttonUpgrade.enable = true;
      }
      
      public function unlockMountButton() : void
      {
         Main.writeVarsToConsoleChannel("GARAGE WINDOW","unlockMountButton storeItemSelected: " + this.storeItemSelected);
         Main.writeVarsToConsoleChannel("GARAGE WINDOW","unlockMountButton inventorySelected: " + this.inventorySelected);
         if(!this.storeItemSelected && !this.inventorySelected)
         {
            this.itemInfoPanel.buttonEquip.enable = true;
         }
      }
      
      public function setMountButtonInfo(icon:BitmapData) : void
      {
         this.itemInfoPanel.buttonEquip.icon = icon;
      }
      
      public function setBuyButtonInfo(reset:Boolean, crystal:int = 0, rank:int = 0) : void
      {
         Main.writeVarsToConsoleChannel("GARAGE WINDOW","setBuyButtonInfo reset: %1, crystal: %2, rank: %3",reset,crystal,rank);
         if(reset)
         {
            this.itemInfoPanel.buttonBuy.icon = null;
         }
         else
         {
            this.itemInfoPanel.buttonBuy.setInfo(crystal,rank);
         }
      }
      
      private function onWarehouseItemSelect(e:Event) : void
      {
         this.selectedItemId = this.warehouseList.selectedItemID as String;
         this.storeList.unselect();
         dispatchEvent(new GarageWindowEvent(GarageWindowEvent.WAREHOUSE_ITEM_SELECTED,this.selectedItemId));
      }
      
      private function onStoreItemSelect(e:Event) : void
      {
         this.selectedItemId = this.storeList.selectedItemID as String;
         this.warehouseList.unselect();
         dispatchEvent(new GarageWindowEvent(GarageWindowEvent.STORE_ITEM_SELECTED,this.selectedItemId));
      }
      
      private function onButtonBuyClick(e:MouseEvent) : void
      {
         dispatchEvent(new GarageWindowEvent(GarageWindowEvent.BUY_ITEM,this.selectedItemId));
      }
      
      private function onButtonBuyCrystalsClick(e:MouseEvent) : void
      {
         dispatchEvent(new GarageWindowEvent(GarageWindowEvent.ADD_CRYSTALS,this.selectedItemId));
      }
      
      private function onButtonEquipClick(e:MouseEvent) : void
      {
         dispatchEvent(new GarageWindowEvent(GarageWindowEvent.SETUP_ITEM,this.selectedItemId));
      }
      
      private function onModButtonClick(e:MouseEvent) : void
      {
         dispatchEvent(new GarageWindowEvent(GarageWindowEvent.UPGRADE_ITEM,this.selectedItemId));
      }
      
      private function onSkinButtonClick(e:MouseEvent) : void
      {
         dispatchEvent(new GarageWindowEvent(GarageWindowEvent.PROCESS_SKIN,this.selectedItemId));
      }
   }
}
