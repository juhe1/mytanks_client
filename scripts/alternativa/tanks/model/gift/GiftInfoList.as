package alternativa.tanks.model.gift
{
   import alternativa.model.IResourceLoadListener;
   import alternativa.tanks.model.gift.icons.ItemGiftBackgrounds;
   import alternativa.tanks.model.gift.server.GiftServerItem;
   import alternativa.types.Long;
   import assets.icons.InputCheckIcon;
   import assets.scroller.color.ScrollThumbSkinGreen;
   import assets.scroller.color.ScrollTrackGreen;
   import controls.Label;
   import fl.controls.ScrollBarDirection;
   import fl.controls.TileList;
   import fl.data.DataProvider;
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.DisplayObject;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.filters.GlowFilter;
   import flash.geom.Rectangle;
   import flash.system.Capabilities;
   import flash.utils.getTimer;
   import forms.RegisterForm;
   import scpacker.resource.ResourceType;
   import scpacker.resource.ResourceUtil;
   import scpacker.resource.images.ImageResource;
   
   public class GiftInfoList extends Sprite implements IResourceLoadListener
   {
      
      private static const MIN_POSSIBLE_SPEED:Number = 70;
      
      private static const MAX_DELTA_FOR_SELECT:Number = 7;
      
      private static const ADDITIONAL_SCROLL_AREA_HEIGHT:Number = 3;
       
      
      private var list:TileList;
      
      private var dataProvider:DataProvider;
      
      private var previousPositionX:Number;
      
      private var currentPositionX:Number;
      
      private var sumDragWay:Number;
      
      private var lastItemIndex:int;
      
      private var previousTime:int;
      
      private var currentTime:int;
      
      private var scrollSpeed:Number = 0;
      
      private var _width:int;
      
      private var _height:int;
      
      public function GiftInfoList()
      {
         super();
         this.dataProvider = new DataProvider();
         this.list = new TileList();
         this.list.dataProvider = this.dataProvider;
         this.list.rowCount = 2;
         this.list.rowHeight = 117;
         this.list.columnWidth = 160;
         this.list.setStyle("cellRenderer",GiftRollerRenderer);
         this.list.direction = ScrollBarDirection.HORIZONTAL;
         this.list.focusEnabled = false;
         this.list.horizontalScrollBar.focusEnabled = false;
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
      
      public function initData(items:Array) : void
      {
         var item:GiftServerItem = null;
         var data:Object = null;
         var icon:DisplayObject = null;
         items.sortOn("rare",Array.NUMERIC);
         var i:int = 0;
         for each(item in items)
         {
            data = {};
            data.id = item.id;
            data.index = i;
            data.count = item.count;
            data.rare = item.rare;
            data.preview = ResourceUtil.getResource(ResourceType.IMAGE,item.id + "_m0_preview");
            icon = this.myIcon(data,false);
            this.dataProvider.addItem({
               "iconNormal":icon,
               "iconSelected":icon,
               "dat":data,
               "accessable":false,
               "rang":0,
               "type":1,
               "typesort":0,
               "sort":1
            });
            i++;
         }
         addChild(this.list);
         addEventListener(Event.ADDED_TO_STAGE,this.addListeners);
         addEventListener(Event.REMOVED_FROM_STAGE,this.removeListeners);
      }
      
      private function addListeners(e:Event) : void
      {
         addEventListener(MouseEvent.MOUSE_WHEEL,this.scrollList);
         addEventListener(MouseEvent.MOUSE_DOWN,this.onMouseDown);
      }
      
      private function removeListeners(e:Event) : void
      {
         removeEventListener(MouseEvent.MOUSE_WHEEL,this.scrollList);
         removeEventListener(MouseEvent.MOUSE_DOWN,this.onMouseDown);
         removeEventListener(Event.ENTER_FRAME,this.onEnterFrame);
         stage.removeEventListener(MouseEvent.MOUSE_UP,this.onMouseUp);
         stage.removeEventListener(MouseEvent.MOUSE_MOVE,this.onMouseMove);
      }
      
      private function scrollList(e:MouseEvent) : void
      {
         this.list.horizontalScrollPosition -= e.delta * (!!Boolean(Capabilities.os.search("Linux") != -1) ? 50 : 10);
      }
      
      private function onMouseDown(e:MouseEvent) : void
      {
         this.scrollSpeed = 0;
         var rect:Rectangle = this.list.horizontalScrollBar.getBounds(stage);
         rect.top -= ADDITIONAL_SCROLL_AREA_HEIGHT;
         if(!rect.contains(e.stageX,e.stageY))
         {
            this.sumDragWay = 0;
            this.previousPositionX = this.currentPositionX = e.stageX;
            this.currentTime = this.previousTime = getTimer();
            this.lastItemIndex = this.list.selectedIndex;
            stage.addEventListener(MouseEvent.MOUSE_UP,this.onMouseUp);
            stage.addEventListener(MouseEvent.MOUSE_MOVE,this.onMouseMove);
         }
      }
      
      private function onMouseUp(e:MouseEvent) : void
      {
         stage.removeEventListener(MouseEvent.MOUSE_MOVE,this.onMouseMove);
         stage.removeEventListener(MouseEvent.MOUSE_UP,this.onMouseUp);
         var delta:Number = (getTimer() - this.previousTime) / 1000;
         if(delta == 0)
         {
            delta = 0.1;
         }
         var deltaX:Number = e.stageX - this.previousPositionX;
         this.scrollSpeed = deltaX / delta;
         this.previousTime = this.currentTime;
         this.currentTime = getTimer();
         addEventListener(Event.ENTER_FRAME,this.onEnterFrame);
      }
      
      private function onEnterFrame(param1:Event) : void
      {
         this.previousTime = this.currentTime;
         this.currentTime = getTimer();
         var dt:Number = (this.currentTime - this.previousTime) / 1000;
         this.list.horizontalScrollPosition -= this.scrollSpeed * dt;
         var horizontalPos:Number = this.list.horizontalScrollPosition;
         var maxHorizontalPos:Number = this.list.maxHorizontalScrollPosition;
         if(Math.abs(this.scrollSpeed) > MIN_POSSIBLE_SPEED && 0 < horizontalPos && horizontalPos < maxHorizontalPos)
         {
            this.scrollSpeed *= Math.exp(-1.5 * dt);
         }
         else
         {
            this.scrollSpeed = 0;
            removeEventListener(Event.ENTER_FRAME,this.onEnterFrame);
         }
      }
      
      private function onMouseMove(e:MouseEvent) : void
      {
         this.previousPositionX = this.currentPositionX;
         this.currentPositionX = e.stageX;
         this.previousTime = this.currentTime;
         this.currentTime = getTimer();
         var deltaX:Number = this.currentPositionX - this.previousPositionX;
         this.sumDragWay += Math.abs(deltaX);
         if(this.sumDragWay > MAX_DELTA_FOR_SELECT)
         {
            this.list.horizontalScrollPosition -= deltaX;
         }
         e.updateAfterEvent();
      }
      
      public function resourceLoaded(resource:Object) : void
      {
         var item:Object = null;
         for(var i:int = 0; i < this.dataProvider.length; i++)
         {
            item = this.dataProvider.getItemAt(i);
            if(resource.id.split("_m0_preview")[0] == item.dat.id)
            {
               this.update(item.dat.index,"preview",resource as ImageResource);
            }
         }
      }
      
      private function itemByIndex(id:Object, searchInSilent:Boolean = false) : int
      {
         var obj:Object = null;
         for(var i:int = 0; i < this.dataProvider.length; i++)
         {
            obj = this.dataProvider.getItemAt(i);
            if(obj.dat.index == i)
            {
               return i;
            }
         }
         return -1;
      }
      
      public function update(index:int, param:String, value:* = null) : void
      {
         var iNormal:DisplayObject = null;
         var iSelected:DisplayObject = null;
         var obj:Object = this.dataProvider.getItemAt(index);
         var data:Object = obj.dat;
         data[param] = value;
         iNormal = this.myIcon(data,false);
         iSelected = this.myIcon(data,true);
         obj.dat = data;
         obj.iconNormal = iNormal;
         obj.iconSelected = iSelected;
         this.dataProvider.replaceItemAt(obj,index);
         this.dataProvider.invalidateItemAt(index);
      }
      
      public function resourceUnloaded(resourceId:Long) : void
      {
      }
      
      private function myIcon(param1:Object, param2:Boolean) : DisplayObject
      {
         var _loc5_:BitmapData = null;
         var _loc6_:ImageResource = null;
         var _loc8_:uint = 0;
         var _loc10_:Bitmap = null;
         var _loc11_:Label = null;
         var _loc12_:GlowFilter = null;
         var _loc3_:Sprite = new Sprite();
         var _loc4_:Sprite = new Sprite();
         _loc6_ = param1.preview;
         var _loc7_:Bitmap = new Bitmap(ItemGiftBackgrounds.getBG(param1.rare));
         _loc7_.x = 2;
         _loc7_.y = 4;
         _loc8_ = ItemGiftBackgrounds.getColor(param1.rare);
         _loc4_.addChildAt(_loc7_,0);
         var _loc9_:InputCheckIcon = new InputCheckIcon();
         _loc6_ = param1.preview;
         if(_loc6_ == null)
         {
            _loc4_.addChild(_loc9_);
            _loc9_.x = 130 - _loc9_.width >> 1;
            _loc9_.y = 93 - _loc9_.height >> 1;
            _loc9_.gotoAndStop(RegisterForm.CALLSIGN_STATE_INVALID);
         }
         else if(_loc6_.loaded())
         {
            _loc10_ = new Bitmap(_loc6_.bitmapData as BitmapData);
            _loc10_.width *= 0.85;
            _loc10_.height *= 0.85;
            _loc10_.x = 13;
            _loc10_.y = 18;
            _loc4_.addChild(_loc10_);
         }
         else if(_loc6_ != null && !_loc6_.loaded())
         {
            _loc4_.addChild(_loc9_);
            _loc9_.x = 134 - _loc9_.width >> 1;
            _loc9_.y = 97 - _loc9_.height >> 1;
            _loc9_.gotoAndStop(RegisterForm.CALLSIGN_STATE_PROGRESS);
            _loc6_.completeLoadListener = this;
            _loc6_.load();
         }
         if(param1.count > 1)
         {
            _loc11_ = new Label();
            _loc11_.text = "x" + param1.count;
            _loc8_ = ItemGiftBackgrounds.getColor(param1.rare);
            _loc12_ = new GlowFilter(_loc8_);
            _loc12_.strength = 1.4;
            _loc11_.filters = [_loc12_];
            _loc11_.x = 13;
            _loc11_.y = 12;
            _loc4_.addChild(_loc11_);
         }
         _loc5_ = new BitmapData(_loc4_.width + 5,_loc4_.height + 5,true,0);
         _loc5_.draw(_loc4_);
         _loc3_.addChildAt(new Bitmap(_loc5_),0);
         return _loc3_;
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
   }
}
