package forms.garage
{
   import alternativa.console.IConsole;
   import alternativa.init.Main;
   import alternativa.model.IResourceLoadListener;
   import alternativa.tanks.model.GarageModel;
   import alternativa.tanks.model.IGarage;
   import alternativa.types.Long;
   import assets.Diamond;
   import assets.icons.GarageItemBackground;
   import assets.icons.IconGarageMod;
   import assets.icons.InputCheckIcon;
   import assets.scroller.color.ScrollThumbSkinGreen;
   import assets.scroller.color.ScrollTrackGreen;
   import controls.InventoryIcon;
   import controls.Label;
   import controls.rangicons.RangIconNormal;
   import fl.controls.LabelButton;
   import fl.controls.ScrollBar;
   import fl.controls.ScrollBarDirection;
   import fl.controls.TileList;
   import fl.data.DataProvider;
   import fl.events.ListEvent;
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.DisplayObject;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.geom.Rectangle;
   import flash.system.Capabilities;
   import flash.text.TextFieldAutoSize;
   import flash.text.TextFormatAlign;
   import flash.utils.getTimer;
   import forms.RegisterForm;
   import forms.events.PartsListEvent;
   import scpacker.resource.images.ImageResource;
   
   public class PartsList extends Sprite implements IResourceLoadListener
   {
      
      private static const MIN_POSIBLE_SPEED:Number = 70;
      
      private static const MAX_DELTA_FOR_SELECT:Number = 7;
      
      private static const ADDITIONAL_SCROLL_AREA_HEIGHT:Number = 3;
      
      private static var _discountImage:Class = PartsList__discountImage;
      
      private static var discountBitmap:BitmapData = new _discountImage().bitmapData;
      
      public static const NOT_TANK_PART:int = 4;
      
      public static const WEAPON:int = 1;
      
      public static const ARMOR:int = 2;
      
      public static const COLOR:int = 3;
      
      public static const PLUGIN:int = 5;
      
      public static const KIT:int = 6;
       
      
      private var list:TileList;
      
      private var silentList:TileList;
      
      private var dp:DataProvider;
      
      private var silentdp:DataProvider;
      
      private var typeSort:Array;
      
      private var sumDragWay:Number;
      
      private var previousTime:int;
      
      private var currentTime:int;
      
      private var scrollSpeed:Number = 0;
      
      private var lastItemIndex:int;
      
      private var previousPositionX:Number;
      
      private var currrentPositionX:Number;
      
      private var _selectedItemID:Object = null;
      
      private var ID:String;
      
      private var model:GarageModel;
      
      private var _width:int;
      
      private var _height:int;
      
      public function PartsList(id:String = null)
      {
         this.typeSort = [0,2,3,4,1,0,1];
         super();
         this.ID = id;
         this.dp = new DataProvider();
         this.silentdp = new DataProvider();
         this.silentList = new TileList();
         this.silentList.dataProvider = this.silentdp;
         this.list = new TileList();
         this.list.dataProvider = this.dp;
         this.list.addEventListener(ListEvent.ITEM_CLICK,this.selectItem);
         this.list.addEventListener(ListEvent.ITEM_DOUBLE_CLICK,this.selectItem);
         this.list.rowCount = 1;
         this.list.rowHeight = 130;
         this.list.columnWidth = 203;
         this.list.setStyle("cellRenderer",PartsListRenderer);
         this.list.direction = ScrollBarDirection.HORIZONTAL;
         this.list.focusEnabled = false;
         this.list.horizontalScrollBar.focusEnabled = false;
         addChild(this.list);
         addEventListener(MouseEvent.MOUSE_WHEEL,this.scrollList);
         this.list.horizontalScrollBar.addEventListener(Event.ENTER_FRAME,this.updateScrollOnEnterFrame);
         addEventListener(MouseEvent.MOUSE_DOWN,this.onMouseDown);
         this.confScroll();
         addEventListener(Event.REMOVED_FROM_STAGE,this.killLists);
      }
      
      public function get selectedItemID() : Object
      {
         return this._selectedItemID;
      }
      
      override public function set width(value:Number) : void
      {
         this._width = int(value);
         this.list.width = this._width;
      }
      
      override public function get width() : Number
      {
         return this._width;
      }
      
      override public function set height(value:Number) : void
      {
         this._height = int(value);
         this.list.height = this._height;
      }
      
      override public function get height() : Number
      {
         return this._height;
      }
      
      public function resourceLoaded(resource:Object) : void
      {
         var i:int = 0;
         var item:Object = null;
         try
         {
            for(i = 0; i < this.dp.length; i++)
            {
               item = this.dp.getItemAt(i);
               if(resource.id.split("_preview")[0] == item.dat.id)
               {
                  this.update(item.dat.id,"preview",resource as ImageResource);
                  break;
               }
            }
            this.model = GarageModel(Main.osgi.getService(IGarage));
         }
         catch(e:Error)
         {
            (Main.osgi.getService(IConsole) as IConsole).addLine(e.getStackTrace());
         }
      }
      
      public function resourceUnloaded(resourceId:Long) : void
      {
      }
      
      private function updateScrollOnEnterFrame(param1:Event) : void
      {
         var _loc4_:Sprite = null;
         var _loc5_:Sprite = null;
         var _loc2_:ScrollBar = this.list.horizontalScrollBar;
         var _loc3_:int = 0;
         while(_loc3_ < _loc2_.numChildren)
         {
            _loc4_ = Sprite(_loc2_.getChildAt(_loc3_));
            if(_loc4_.hitArea != null)
            {
               _loc5_ = _loc4_.hitArea;
               _loc5_.graphics.clear();
            }
            else
            {
               _loc5_ = new Sprite();
               _loc5_.mouseEnabled = false;
               _loc4_.hitArea = _loc5_;
               this.list.addChild(_loc5_);
            }
            _loc5_.graphics.beginFill(0,0);
            if(_loc4_ is LabelButton)
            {
               _loc5_.graphics.drawRect(_loc4_.y - 14,_loc2_.y - ADDITIONAL_SCROLL_AREA_HEIGHT,_loc4_.height + 28,_loc4_.width + ADDITIONAL_SCROLL_AREA_HEIGHT);
            }
            else
            {
               _loc5_.graphics.drawRect(_loc4_.y,_loc2_.y - ADDITIONAL_SCROLL_AREA_HEIGHT,_loc4_.height,_loc4_.width + ADDITIONAL_SCROLL_AREA_HEIGHT);
            }
            _loc5_.graphics.endFill();
            _loc3_++;
         }
      }
      
      private function killLists(e:Event) : void
      {
         this.list.removeEventListener(ListEvent.ITEM_CLICK,this.selectItem);
         removeEventListener(MouseEvent.MOUSE_WHEEL,this.scrollList);
         this.list.horizontalScrollBar.removeEventListener(Event.ENTER_FRAME,this.updateScrollOnEnterFrame);
         removeEventListener(MouseEvent.MOUSE_WHEEL,this.scrollList);
         removeEventListener(MouseEvent.MOUSE_DOWN,this.onMouseDown);
         stage.removeEventListener(MouseEvent.MOUSE_UP,this.onMouseUp);
         stage.removeEventListener(MouseEvent.MOUSE_MOVE,this.onMouseMove);
         this.list.removeAll();
         this.dp.removeAll();
         this.silentList.removeAll();
         this.silentdp.removeAll();
         this.list = null;
         this.dp = null;
         this.silentList = null;
         this.silentdp = null;
      }
      
      public function addItem(id:Object, name:String, type:int, sort:int, crystalPrice:int, discount:int, rang:int, installed:Boolean, garageElement:Boolean, count:int, preview:ImageResource, modification:int = 0) : void
      {
         var iNormal:DisplayObject = null;
         var iSelected:DisplayObject = null;
         var data:Object = {};
         var access:Boolean = rang < 1 && !garageElement;
         data.id = id;
         data.name = name;
         data.type = type;
         data.typeSort = this.typeSort[type];
         data.mod = modification;
         data.crystalPrice = crystalPrice;
         data.discount = discount;
         data.rang = !!garageElement ? -1 : rang;
         data.installed = installed;
         data.garageElement = garageElement;
         data.count = count;
         data.preview = preview;
         data.sort = sort;
         iNormal = this.myIcon(data,false);
         iSelected = this.myIcon(data,true);
         if(String(id).indexOf("HD_") != -1)
         {
            this.silentdp.addItem({
               "iconNormal":iNormal,
               "iconSelected":iSelected,
               "dat":data,
               "accessable":access,
               "rang":data.rang,
               "type":type,
               "typesort":data.typeSort,
               "sort":sort
            });
         }
         else
         {
            this.dp.addItem({
               "iconNormal":iNormal,
               "iconSelected":iSelected,
               "dat":data,
               "accessable":access,
               "rang":data.rang,
               "type":type,
               "typesort":data.typeSort,
               "sort":sort
            });
            this.dp.sortOn(["accessable","rang","typesort","sort"],[Array.DESCENDING,Array.NUMERIC,Array.NUMERIC,Array.NUMERIC]);
         }
      }
      
      private function update(id:Object, param:String, value:* = null) : void
      {
         var obj:Object = null;
         var iNormal:DisplayObject = null;
         var iSelected:DisplayObject = null;
         var HD:Boolean = String(id).indexOf("HD_") != -1;
         var M3:Boolean = id.indexOf("_m3") != -1 && (id.indexOf("dictator") != -1 || id.indexOf("railgun") != -1);
         if(HD)
         {
            id = id.replace("HD_","");
         }
         var index:int = this.indexById(id);
         if(M3 && HD)
         {
            if(index != -1)
            {
               obj = this.silentdp.getItemAt(this.indexById("HD_" + id,true));
               this.silentdp.addItem(this.dp.getItemAt(index));
            }
            else
            {
               obj = this.silentdp.getItemAt(this.indexById(id,true));
               index = this.indexById("HD_" + id);
            }
         }
         else if(index != -1)
         {
            obj = this.dp.getItemAt(index);
         }
         else
         {
            index = this.indexById("HD_" + id);
            obj = this.dp.getItemAt(index);
         }
         var data:Object = obj.dat;
         data[param] = value;
         iNormal = this.myIcon(data,false);
         iSelected = this.myIcon(data,true);
         obj.dat = data;
         obj.iconNormal = iNormal;
         obj.iconSelected = iSelected;
         this.dp.replaceItemAt(obj,index);
         this.dp.sortOn(["accessable","rang","typesort","sort"],[Array.DESCENDING,Array.NUMERIC,Array.NUMERIC,Array.NUMERIC]);
         this.dp.invalidateItemAt(index);
      }
      
      public function lock(id:Object) : void
      {
         this.update(id,"accessable",true);
      }
      
      public function unlock(id:Object) : void
      {
         this.update(id,"accessable",false);
      }
      
      public function mount(id:Object) : void
      {
         this.update(id,"installed",true);
      }
      
      public function unmount(id:Object) : void
      {
         this.update(id,"installed",false);
      }
      
      public function updateCondition(id:Object, value:int) : void
      {
         this.update(id,"condition",value);
      }
      
      public function updateCount(id:Object, value:int) : void
      {
         this.update(id,"count",value);
      }
      
      public function updateModification(id:Object, value:int) : void
      {
         this.update(id,"mod",value);
      }
      
      public function deleteItem(id:Object) : void
      {
         var index:int = this.indexById(id);
         if(index == -1)
         {
            return;
         }
         var obj:Object = this.dp.getItemAt(index);
         if(this.list.selectedIndex == index)
         {
            this._selectedItemID = null;
            this.list.selectedItem = null;
         }
         this.dp.removeItem(obj);
      }
      
      public function select(id:Object) : void
      {
         var index:int = this.indexById(id);
         this.list.selectedIndex = index;
         this._selectedItemID = id;
         dispatchEvent(new PartsListEvent(PartsListEvent.SELECT_PARTS_LIST_ITEM));
      }
      
      public function selectByIndex(index:uint) : void
      {
         var obj:Object = (this.dp.getItemAt(index) as Object).dat;
         this.list.selectedIndex = index;
         this._selectedItemID = obj.id;
         dispatchEvent(new PartsListEvent(PartsListEvent.SELECT_PARTS_LIST_ITEM));
      }
      
      public function scrollTo(id:Object) : void
      {
         var index:int = this.indexById(id);
         this.list.scrollToIndex(index);
      }
      
      public function unselect() : void
      {
         this._selectedItemID = null;
         this.list.selectedItem = null;
      }
      
      private function myIcon(data:Object, select:Boolean) : DisplayObject
      {
         var bmp:BitmapData = null;
         var bg:GarageItemBackground = null;
         var itemName:String = null;
         var prv:Bitmap = null;
         var rangIcon:RangIconNormal = null;
         var icon:Sprite = new Sprite();
         var cont:Sprite = new Sprite();
         var discountLabel:Bitmap = null;
         var label:Label = null;
         var name:Label = new Label();
         var c_price:Label = new Label();
         var count:Label = new Label();
         var diamond:Diamond = new Diamond();
         var iconMod:IconGarageMod = new IconGarageMod(data.mod);
         var iconInventory:InventoryIcon = new InventoryIcon(data.sort,true);
         var iconCheck:InputCheckIcon = new InputCheckIcon();
         var imageResource:ImageResource = data.preview;
         if(imageResource == null)
         {
            cont.addChild(iconCheck);
            iconCheck.x = 200 - iconCheck.width >> 1;
            iconCheck.y = 130 - iconCheck.height >> 1;
            iconCheck.gotoAndStop(RegisterForm.CALLSIGN_STATE_INVALID);
         }
         else if(imageResource.loaded())
         {
            prv = new Bitmap(imageResource.bitmapData as BitmapData);
            prv.x = 19;
            prv.y = 18;
            cont.addChild(prv);
         }
         else if(imageResource != null && !imageResource.loaded())
         {
            cont.addChild(iconCheck);
            iconCheck.x = 200 - iconCheck.width >> 1;
            iconCheck.y = 130 - iconCheck.height >> 1;
            iconCheck.gotoAndStop(RegisterForm.CALLSIGN_STATE_PROGRESS);
            imageResource.completeLoadListener = this;
            imageResource.load();
         }
         if(data.rang > 0 && !data.garageElement || data.accessable)
         {
            rangIcon = new RangIconNormal(data.rang);
            itemName = "OFF";
            data.installed = false;
            rangIcon.x = 135;
            rangIcon.y = 60;
            if(data.type != PLUGIN)
            {
               cont.addChild(rangIcon);
            }
            count.color = c_price.color = name.color = 12632256;
         }
         else
         {
            count.color = c_price.color = name.color = 5898034;
            switch(data.type)
            {
               case WEAPON:
                  if(data.garageElement)
                  {
                     cont.addChild(iconMod);
                     iconMod.x = 159;
                     iconMod.y = 7;
                     if(data.installed)
                     {
                        name.color = 8693863;
                     }
                  }
                  itemName = "GUN";
                  break;
               case ARMOR:
                  if(data.garageElement)
                  {
                     cont.addChild(iconMod);
                     iconMod.x = 159;
                     iconMod.y = 7;
                     if(data.installed)
                     {
                        name.color = 9411748;
                     }
                  }
                  itemName = "SHIELD";
                  break;
               case COLOR:
                  itemName = "COLOR";
                  if(data.installed)
                  {
                     name.color = 11049390;
                  }
                  break;
               case NOT_TANK_PART:
                  itemName = "ENGINE";
                  data.installed = false;
                  cont.addChild(count);
                  count.x = 90;
                  count.y = 100;
                  if(data.id != "1000_scores_m0")
                  {
                     cont.addChild(iconInventory);
                     iconInventory.x = 6;
                     iconInventory.y = 84;
                  }
                  count.autoSize = TextFieldAutoSize.NONE;
                  count.size = 16;
                  count.align = TextFormatAlign.RIGHT;
                  count.width = 100;
                  count.height = 25;
                  count.text = data.count == 0 ? " " : "×" + String(data.count);
                  break;
               case PLUGIN:
                  itemName = "PLUGIN";
               case KIT:
                  itemName = "PLUGIN";
            }
         }
         itemName += (Boolean(data.installed) ? "_INSTALLED" : "_NORMAL") + (!!select ? "_SELECTED" : "");
         bg = new GarageItemBackground(GarageItemBackground.idByName(itemName));
         name.text = data.name;
         if(!data.garageElement || data.type == NOT_TANK_PART)
         {
            if(data.crystalPrice > 0)
            {
               c_price.text = String(data.crystalPrice);
               c_price.x = 181 - c_price.textWidth;
               c_price.y = 2;
               cont.addChild(diamond);
               cont.addChild(c_price);
               diamond.x = 186;
               diamond.y = 6;
            }
         }
         name.y = 2;
         name.x = 3;
         cont.addChildAt(bg,0);
         cont.addChild(name);
         var needShowSales:Boolean = false;
         if(data.garageElement)
         {
            if((data.type == WEAPON || data.type == ARMOR) && data.maxModification > 1 && data.mod != 3)
            {
               needShowSales = true;
            }
            if(data.type == NOT_TANK_PART)
            {
               needShowSales = true;
            }
         }
         else
         {
            needShowSales = true;
         }
         if(data.discount > 0 && needShowSales)
         {
            discountLabel = new Bitmap(discountBitmap);
            discountLabel.x = 0;
            discountLabel.y = bg.height - discountLabel.height;
            cont.addChild(discountLabel);
            label = new Label();
            label.color = 16777215;
            label.align = TextFormatAlign.LEFT;
            label.text = "-" + data.discount + "%";
            label.height = 35;
            label.width = 100;
            label.thickness = 0;
            label.autoSize = TextFieldAutoSize.NONE;
            label.size = 16;
            label.x = 10;
            label.y = 90;
            label.rotation = 45;
            cont.addChild(label);
         }
         bmp = new BitmapData(cont.width,cont.height,true,0);
         bmp.draw(cont);
         icon.addChildAt(new Bitmap(bmp),0);
         return icon;
      }
      
      private function confScroll() : void
      {
         this.list.setStyle("downArrowUpSkin",ScrollArrowDownGreen);
         this.list.setStyle("downArrowDownSkin",ScrollArrowDownGreen);
         this.list.setStyle("downArrowOverSkin",ScrollArrowDownGreen);
         this.list.setStyle("downArrowDisabledSkin",ScrollArrowDownGreen);
         this.list.setStyle("upArrowUpSkin",ScrollArrowUpGreen);
         this.list.setStyle("upArrowDownSkin",ScrollArrowUpGreen);
         this.list.setStyle("upArrowOverSkin",ScrollArrowUpGreen);
         this.list.setStyle("upArrowDisabledSkin",ScrollArrowUpGreen);
         this.list.setStyle("trackUpSkin",ScrollTrackGreen);
         this.list.setStyle("trackDownSkin",ScrollTrackGreen);
         this.list.setStyle("trackOverSkin",ScrollTrackGreen);
         this.list.setStyle("trackDisabledSkin",ScrollTrackGreen);
         this.list.setStyle("thumbUpSkin",ScrollThumbSkinGreen);
         this.list.setStyle("thumbDownSkin",ScrollThumbSkinGreen);
         this.list.setStyle("thumbOverSkin",ScrollThumbSkinGreen);
         this.list.setStyle("thumbDisabledSkin",ScrollThumbSkinGreen);
      }
      
      private function indexById(param1:Object, param2:Boolean = false) : int
      {
         var _loc3_:Object = null;
         var _loc4_:int = 0;
         if(!param2)
         {
            for(_loc4_ = 0; _loc4_ < this.dp.length; _loc4_++)
            {
               _loc3_ = this.dp.getItemAt(_loc4_);
               if(_loc3_.dat.id == param1)
               {
                  return _loc4_;
               }
            }
         }
         else
         {
            for(_loc4_ = 0; _loc4_ < this.silentdp.length; _loc4_++)
            {
               _loc3_ = this.silentdp.getItemAt(_loc4_);
               if(_loc3_.dat.id == param1)
               {
                  return _loc4_;
               }
            }
         }
         return -1;
      }
      
      private function selectItem(e:ListEvent) : void
      {
         var obj:Object = null;
         obj = e.item;
         this._selectedItemID = obj.dat.id;
         this.list.selectedItem = obj;
         this.list.scrollToSelected();
         dispatchEvent(new PartsListEvent(PartsListEvent.SELECT_PARTS_LIST_ITEM));
         if(e.type == ListEvent.ITEM_DOUBLE_CLICK && this.model)
         {
            if(this.ID == "warehouse")
            {
               this.model.tryMountItem(null,String(this._selectedItemID));
            }
            else if(this.model.garageWindow.itemInfoPanel.buttonBuy.enable)
            {
               this.model.buyRequest(String(this._selectedItemID));
            }
         }
      }
      
      private function scrollList(e:MouseEvent) : void
      {
         this.list.horizontalScrollPosition -= e.delta * (!!Boolean(Capabilities.os.search("Linux") != -1) ? 50 : 10);
      }
      
      private function onMouseDown(param1:MouseEvent) : void
      {
         this.scrollSpeed = 0;
         var _loc2_:Rectangle = this.list.horizontalScrollBar.getBounds(stage);
         _loc2_.top -= ADDITIONAL_SCROLL_AREA_HEIGHT;
         if(!_loc2_.contains(param1.stageX,param1.stageY))
         {
            this.sumDragWay = 0;
            this.previousPositionX = this.currrentPositionX = param1.stageX;
            this.currentTime = this.previousTime = getTimer();
            this.lastItemIndex = this.list.selectedIndex;
            stage.addEventListener(MouseEvent.MOUSE_UP,this.onMouseUp);
            stage.addEventListener(MouseEvent.MOUSE_MOVE,this.onMouseMove);
         }
      }
      
      private function onMouseMove(param1:MouseEvent) : void
      {
         this.previousPositionX = this.currrentPositionX;
         this.currrentPositionX = param1.stageX;
         this.previousTime = this.currentTime;
         this.currentTime = getTimer();
         var _loc2_:Number = this.currrentPositionX - this.previousPositionX;
         this.sumDragWay += Math.abs(_loc2_);
         if(this.sumDragWay > MAX_DELTA_FOR_SELECT)
         {
            this.list.horizontalScrollPosition -= _loc2_;
         }
         param1.updateAfterEvent();
      }
      
      private function onMouseUp(param1:MouseEvent) : void
      {
         stage.removeEventListener(MouseEvent.MOUSE_MOVE,this.onMouseMove);
         stage.removeEventListener(MouseEvent.MOUSE_UP,this.onMouseUp);
         var _loc2_:Number = (getTimer() - this.previousTime) / 1000;
         if(_loc2_ == 0)
         {
            _loc2_ = 0.1;
         }
         var _loc3_:Number = param1.stageX - this.previousPositionX;
         this.scrollSpeed = _loc3_ / _loc2_;
         this.previousTime = this.currentTime;
         this.currentTime = getTimer();
         addEventListener(Event.ENTER_FRAME,this.onEnterFrame);
      }
      
      private function onEnterFrame(param1:Event) : void
      {
         this.previousTime = this.currentTime;
         this.currentTime = getTimer();
         var _loc2_:Number = (this.currentTime - this.previousTime) / 1000;
         this.list.horizontalScrollPosition -= this.scrollSpeed * _loc2_;
         var _loc3_:Number = this.list.horizontalScrollPosition;
         var _loc4_:Number = this.list.maxHorizontalScrollPosition;
         if(Math.abs(this.scrollSpeed) > MIN_POSIBLE_SPEED && 0 < _loc3_ && _loc3_ < _loc4_)
         {
            this.scrollSpeed *= Math.exp(-1.5 * _loc2_);
         }
         else
         {
            this.scrollSpeed = 0;
            removeEventListener(Event.ENTER_FRAME,this.onEnterFrame);
         }
      }
   }
}
