package forms.battlelist
{
   import alternativa.init.Main;
   import alternativa.osgi.service.locale.ILocaleService;
   import alternativa.tanks.locale.constants.TextConst;
   import assets.cellrenderer.battlelist.Abris;
   import assets.cellrenderer.battlelist.PaydIcon;
   import assets.scroller.color.ScrollThumbSkinGreen;
   import assets.scroller.color.ScrollTrackGreen;
   import controls.DefaultButton;
   import controls.Label;
   import controls.TankWindow;
   import controls.TankWindowHeader;
   import controls.TankWindowInner;
   import fl.controls.List;
   import fl.controls.ScrollBar;
   import fl.data.DataProvider;
   import fl.events.ListEvent;
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.Shape;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.KeyboardEvent;
   import flash.events.MouseEvent;
   import flash.events.TimerEvent;
   import flash.text.TextFieldAutoSize;
   import flash.text.TextFormat;
   import flash.text.TextFormatAlign;
   import flash.ui.Keyboard;
   import flash.utils.Timer;
   import forms.events.BattleListEvent;
   
   public class ViewBattleList extends Sprite
   {
      
[Embed(source="888.png")]
      private static const dm:Class;
      
[Embed(source="1020.png")]
      private static const tdm:Class;
      
[Embed(source="1022.png")]
      private static const ctf:Class;
      
[Embed(source="895.png")]
      private static const cp:Class;
       
      
      private var mainBackground:TankWindow;
      
      private var inner:TankWindowInner;
      
      private var format:TextFormat;
      
      private var battleList:List;
      
      private var dp:DataProvider;
      
      private var filterDP:DataProvider;
      
      private var _selectedBattleID:Object;
      
      private var delayTimer:Timer;
      
      private var iconWidth:int = 100;
      
      private var onStage:Boolean = false;
      
      private var dmButton:DefaultButton;
      
      private var tdmButton:DefaultButton;
      
      private var ctfButton:DefaultButton;
      
      private var domButton:DefaultButton;
      
      private var dmBitmap:Sprite;
      
      private var tdmBitmap:Sprite;
      
      private var ctfBitmap:Sprite;
      
      private var domBitmap:Sprite;
      
      public var createButton:DefaultButton;
      
      private var oldIconWidth:int = 0;
      
      public function ViewBattleList()
      {
         this.mainBackground = new TankWindow();
         this.inner = new TankWindowInner(100,100,TankWindowInner.GREEN);
         this.format = new TextFormat("MyriadPro",13);
         this.battleList = new List();
         this.dp = new DataProvider();
         this.filterDP = new DataProvider();
         this.dmButton = new DefaultButton();
         this.tdmButton = new DefaultButton();
         this.ctfButton = new DefaultButton();
         this.domButton = new DefaultButton();
         this.dmBitmap = new Sprite();
         this.tdmBitmap = new Sprite();
         this.ctfBitmap = new Sprite();
         this.domBitmap = new Sprite();
         this.createButton = new DefaultButton();
         super();
         addEventListener(Event.ADDED_TO_STAGE,this.ConfigUI);
         addEventListener(Event.ADDED_TO_STAGE,this.addResizeListener);
         addEventListener(Event.REMOVED_FROM_STAGE,this.removeResizeListener);
      }
      
      public function get selectedBattleID() : Object
      {
         return this._selectedBattleID;
      }
      
      private function addResizeListener(e:Event) : void
      {
         stage.addEventListener(Event.RESIZE,this.onResize);
         this.onStage = true;
         this.onResize(null);
      }
      
      private function removeResizeListener(e:Event) : void
      {
         stage.removeEventListener(Event.RESIZE,this.onResize);
         this.onStage = false;
      }
      
      private function ConfigUI(e:Event) : void
      {
         var localeService:ILocaleService = Main.osgi.getService(ILocaleService) as ILocaleService;
         removeEventListener(Event.ADDED_TO_STAGE,this.ConfigUI);
         addChild(this.mainBackground);
         addChild(this.inner);
         this.inner.showBlink = true;
         this.mainBackground.headerLang = localeService.getText(TextConst.GUI_LANG);
         this.mainBackground.header = TankWindowHeader.CURRENT_BATTLES;
         this.battleList.rowHeight = 20;
         this.battleList.setStyle("cellRenderer",BattleListRenderer);
         this.battleList.dataProvider = this.dp;
         this.battleList.addEventListener(ListEvent.ITEM_CLICK,this.selectItem);
         this.battleList.addEventListener(KeyboardEvent.KEY_UP,this.selectCurrentItem);
         this.battleList.focusEnabled = true;
         this.confScroll();
         addChild(this.battleList);
         this.battleList.move(15,15);
         addChild(this.createButton);
         this.createButton.addEventListener(MouseEvent.CLICK,this.createGame);
         this.createButton.label = localeService.getText(TextConst.BATTLELIST_PANEL_BUTTON_CREATE);
         this.dmBitmap.addChild(new dm());
         this.tdmBitmap.addChild(new tdm());
         this.ctfBitmap.addChild(new ctf());
         this.domBitmap.addChild(new cp());
         addChild(this.dmButton);
         this.dmButton.width = this.dmButton.height;
         addChild(this.dmBitmap);
         this.dmBitmap.addEventListener(MouseEvent.CLICK,this.filterBattle);
         addChild(this.tdmButton);
         this.tdmButton.width = this.tdmButton.height;
         addChild(this.tdmBitmap);
         this.tdmBitmap.addEventListener(MouseEvent.CLICK,this.filterBattle);
         addChild(this.ctfButton);
         this.ctfButton.width = this.ctfButton.height;
         addChild(this.ctfBitmap);
         this.ctfBitmap.addEventListener(MouseEvent.CLICK,this.filterBattle);
         addChild(this.domButton);
         this.domButton.width = this.domButton.height;
         addChild(this.domBitmap);
         this.domBitmap.addEventListener(MouseEvent.CLICK,this.filterBattle);
         this.inner.y = 11;
         this.inner.x = 11;
      }
      
      private function filterBattle(e:MouseEvent = null) : void
      {
         var target:Sprite = null;
         var i:int = 0;
         if(e.currentTarget as Sprite != null)
         {
            this.battleList.selectedItem = null;
            target = e.currentTarget as Sprite;
            if(target == this.dmBitmap)
            {
               this.dmButton.enable = !this.dmButton.enable;
            }
            else if(target == this.tdmBitmap)
            {
               this.tdmButton.enable = !this.tdmButton.enable;
            }
            else if(target == this.ctfBitmap)
            {
               this.ctfButton.enable = !this.ctfButton.enable;
            }
            else if(target == this.domBitmap)
            {
               this.domButton.enable = !this.domButton.enable;
            }
            this.filterDP.removeAll();
            for(i = 0; i < this.dp.length; i++)
            {
               if(!this.dmButton.enable && this.dp.getItemAt(i).dat.type == "DM")
               {
                  this.filterDP.addItem(this.dp.getItemAt(i));
               }
               if(!this.tdmButton.enable && this.dp.getItemAt(i).dat.type == "TDM")
               {
                  this.filterDP.addItem(this.dp.getItemAt(i));
               }
               if(!this.ctfButton.enable && this.dp.getItemAt(i).dat.type == "CTF")
               {
                  this.filterDP.addItem(this.dp.getItemAt(i));
               }
               if(!this.domButton.enable && this.dp.getItemAt(i).dat.type == "DOM")
               {
                  this.filterDP.addItem(this.dp.getItemAt(i));
               }
            }
            this.filterDP.sortOn(["accessible","id"],[Array.DESCENDING,Array.DESCENDING]);
            if(this.filterDP.length > 0 && (this.dmButton.enable || this.tdmButton.enable || this.ctfButton.enable || this.domButton.enable))
            {
               this.battleList.dataProvider = this.filterDP;
            }
            else
            {
               this.battleList.dataProvider = this.dp;
            }
         }
      }
      
      private function confScroll() : void
      {
         var bar:ScrollBar = this.battleList.verticalScrollBar;
         this.battleList.setStyle("downArrowUpSkin",ScrollArrowDownGreen);
         this.battleList.setStyle("downArrowDownSkin",ScrollArrowDownGreen);
         this.battleList.setStyle("downArrowOverSkin",ScrollArrowDownGreen);
         this.battleList.setStyle("downArrowDisabledSkin",ScrollArrowDownGreen);
         this.battleList.setStyle("upArrowUpSkin",ScrollArrowUpGreen);
         this.battleList.setStyle("upArrowDownSkin",ScrollArrowUpGreen);
         this.battleList.setStyle("upArrowOverSkin",ScrollArrowUpGreen);
         this.battleList.setStyle("upArrowDisabledSkin",ScrollArrowUpGreen);
         this.battleList.setStyle("trackUpSkin",ScrollTrackGreen);
         this.battleList.setStyle("trackDownSkin",ScrollTrackGreen);
         this.battleList.setStyle("trackOverSkin",ScrollTrackGreen);
         this.battleList.setStyle("trackDisabledSkin",ScrollTrackGreen);
         this.battleList.setStyle("thumbUpSkin",ScrollThumbSkinGreen);
         this.battleList.setStyle("thumbDownSkin",ScrollThumbSkinGreen);
         this.battleList.setStyle("thumbOverSkin",ScrollThumbSkinGreen);
         this.battleList.setStyle("thumbDisabledSkin",ScrollThumbSkinGreen);
      }
      
      private function createGame(e:MouseEvent) : void
      {
         this.battleList.selectedItem = null;
         dispatchEvent(new BattleListEvent(BattleListEvent.CREATE_GAME));
      }
      
      private function selectItem(e:ListEvent) : void
      {
         this._selectedBattleID = e.item.id;
         dispatchEvent(new BattleListEvent(BattleListEvent.SELECT_BATTLE));
      }
      
      private function selectCurrentItem(e:KeyboardEvent) : void
      {
         if(!this.battleList.selectedItem || e.keyCode != Keyboard.UP && e.keyCode != Keyboard.DOWN)
         {
            return;
         }
         this._selectedBattleID = this.battleList.selectedItem.id;
         dispatchEvent(new BattleListEvent(BattleListEvent.SELECT_BATTLE));
      }
      
      private function getItem(id:Object, name:String, deathMatch:Boolean = true, reds:int = 0, blues:int = 0, all:int = 0, map:String = "", totalfull:Boolean = false, redful:Boolean = false, bluefull:Boolean = false, accessible:Boolean = true, closed:Boolean = false) : Object
      {
         var data:Object = new Object();
         var item:Object = new Object();
         data.gamename = name;
         data.id = id;
         data.dmatch = deathMatch;
         data.reds = reds;
         data.blues = blues;
         data.all = all;
         data.nmap = map;
         data.allfull = totalfull;
         data.redfull = redful;
         data.bluefull = bluefull;
         data.accessible = accessible;
         data.closed = closed;
         item.id = id;
         item.accessible = accessible;
         item.iconNormal = this.myIcon(false,data);
         item.iconSelected = this.myIcon(true,data);
         item.dat = data;
         return item;
      }
      
      public function addItem(id:Object, name:String, deathMatch:Boolean = true, reds:int = 0, blues:int = 0, all:int = 0, map:String = "", totalfull:Boolean = false, redful:Boolean = false, bluefull:Boolean = false, accessible:Boolean = true, closed:Boolean = false, type:String = "") : void
      {
         var data:Object = new Object();
         var item:Object = new Object();
         var index:int = this.indexById(id);
         data.gamename = name;
         data.id = id;
         data.type = type;
         data.dmatch = deathMatch;
         data.reds = reds;
         data.blues = blues;
         data.all = all;
         data.nmap = map;
         data.allfull = totalfull;
         data.redfull = redful;
         data.bluefull = bluefull;
         data.accessible = accessible;
         data.closed = closed;
         item.id = id;
         item.accessible = accessible;
         item.iconNormal = this.myIcon(false,data);
         item.iconSelected = this.myIcon(true,data);
         item.dat = data;
         if(index < 0)
         {
            this.dp.addItem(item);
            this.dp.sortOn(["accessible","id"],[Array.DESCENDING,Array.DESCENDING]);
         }
         if(this.onStage)
         {
            this.onResize();
         }
      }
      
      public function setBattleAccessibility(id:Object, accessible:Boolean) : void
      {
         var d:Object = null;
         var newItem:Object = null;
         var i:Object = new Object();
         var index:int = this.indexById(id);
         if(index >= 0)
         {
            i = this.dp.getItemAt(index);
            d = i.dat;
            newItem = this.getItem(i.id,d.gamename,d.dmatch,d.reds,d.blues,d.all,d.nmap,d.allfull,d.redfull,d.bluefull,accessible,d.closed);
            this.dp.replaceItemAt(newItem,index);
            this.dp.invalidateItemAt(index);
         }
      }
      
      public function updatePlayersTotal(id:Object, num:int, full:Boolean) : void
      {
         var d:Object = null;
         var newItem:Object = null;
         var i:Object = new Object();
         var index:int = this.indexById(id);
         if(index >= 0)
         {
            i = this.dp.getItemAt(index);
            d = i.dat;
            newItem = this.getItem(i.id,d.gamename,d.dmatch,d.reds,d.blues,num,d.nmap,full,d.redfull,d.bluefull,d.accessible,d.closed);
            this.dp.replaceItemAt(newItem,index);
            this.dp.invalidateItemAt(index);
         }
      }
      
      public function updatePlayersRed(id:Object, num:int, full:Boolean) : void
      {
         var d:Object = null;
         var newItem:Object = null;
         var i:Object = new Object();
         var index:int = this.indexById(id);
         if(index >= 0)
         {
            i = this.dp.getItemAt(index);
            d = i.dat;
            newItem = this.getItem(i.id,d.gamename,d.dmatch,num,d.blues,d.all,d.nmap,d.allfull,full,d.bluefull,d.accessible,d.closed);
            this.dp.replaceItemAt(newItem,index);
            this.dp.invalidateItemAt(index);
         }
      }
      
      public function updatePlayersBlue(id:Object, num:int, full:Boolean) : void
      {
         var d:Object = null;
         var newItem:Object = null;
         var i:Object = new Object();
         var index:int = this.indexById(id);
         if(index >= 0)
         {
            i = this.dp.getItemAt(index);
            d = i.dat;
            newItem = this.getItem(i.id,d.gamename,d.dmatch,d.reds,num,d.all,d.nmap,d.allfull,d.redfull,full,d.accessible,d.closed);
            this.dp.replaceItemAt(newItem,index);
            this.dp.invalidateItemAt(index);
         }
      }
      
      public function select(id:Object) : void
      {
         var index:int = this.indexById(id);
         if(index > -1)
         {
            this.battleList.selectedIndex = index;
            this.battleList.scrollToSelected();
            this._selectedBattleID = id;
         }
      }
      
      public function removeItem(id:Object) : void
      {
         var index:int = this.indexById(id);
         if(index >= 0)
         {
            this.dp.removeItemAt(index);
         }
      }
      
      private function indexById(id:Object) : int
      {
         var obj:Object = null;
         for(var i:int = 0; i < this.dp.length; i++)
         {
            obj = this.dp.getItemAt(i);
            if(obj.id == id)
            {
               return i;
            }
         }
         return -1;
      }
      
      private function myIcon(select:Boolean, data:Object) : Sprite
      {
         var icon:Bitmap = null;
         var tf:Label = null;
         var abris:Abris = null;
         var cont:Sprite = new Sprite();
         var shape:Shape = new Shape();
         var access:Boolean = data.accessible;
         var closed_icon:PaydIcon = new PaydIcon();
         var _width:int = this.iconWidth;
         var bmp:BitmapData = new BitmapData(_width,20,true,0);
         var abrisX:int = int(_width * 0.55);
         if(data.closed)
         {
            closed_icon.y = 3;
            closed_icon.x = -2;
            cont.addChild(closed_icon);
            closed_icon.gotoAndStop(!!select ? (!!access ? 2 : 4) : (!!access ? 1 : 3));
         }
         tf = new Label();
         tf.size = 12;
         tf.color = !!select ? (!!access ? uint(TankWindowInner.GREEN) : uint(5789784)) : (!!access ? uint(5898034) : uint(11645361));
         tf.text = data.gamename;
         tf.autoSize = TextFieldAutoSize.NONE;
         tf.width = abrisX - 6;
         tf.height = 18;
         tf.x = 8;
         tf.y = -1;
         cont.addChild(tf);
         tf = new Label();
         tf.size = 12;
         tf.color = !!select ? (!!access ? uint(TankWindowInner.GREEN) : uint(5789784)) : (!!access ? uint(5898034) : uint(11645361));
         tf.autoSize = TextFieldAutoSize.RIGHT;
         tf.align = TextFormatAlign.RIGHT;
         tf.text = String(data.nmap);
         tf.x = _width - tf.textWidth + 2;
         tf.y = -1;
         cont.addChild(tf);
         if(data.dmatch)
         {
            abris = new Abris();
            abris.gotoAndStop(!data.allfull ? 2 : 1);
            abris.x = abrisX;
            abris.y = 1;
            cont.addChild(abris);
            tf = new Label();
            tf.autoSize = TextFieldAutoSize.NONE;
            tf.size = 12;
            tf.color = !data.allfull ? uint(16777215) : uint(8816262);
            tf.align = TextFormatAlign.CENTER;
            tf.text = String(data.all);
            tf.x = abrisX - 0.5;
            tf.y = -1;
            tf.width = 52;
            cont.addChild(tf);
         }
         else
         {
            abris = new Abris();
            abris.gotoAndStop(!data.redfull ? 5 : 3);
            abris.x = abrisX;
            abris.y = 1;
            cont.addChild(abris);
            abris = new Abris();
            abris.gotoAndStop(!data.bluefull ? 6 : 4);
            abris.x = abrisX + 27;
            abris.y = 1;
            cont.addChild(abris);
            tf = new Label();
            tf.autoSize = TextFieldAutoSize.NONE;
            tf.size = 12;
            tf.align = TextFormatAlign.CENTER;
            tf.color = !data.redfull ? uint(16777215) : uint(8816262);
            tf.text = String(data.reds);
            tf.x = abrisX - 0.5;
            tf.y = -1;
            tf.width = 27;
            cont.addChild(tf);
            tf = new Label();
            tf.autoSize = TextFieldAutoSize.NONE;
            tf.align = TextFormatAlign.CENTER;
            tf.color = !data.bluefull ? uint(16777215) : uint(8816262);
            tf.text = String(data.blues);
            tf.x = abrisX + 26.5;
            tf.y = -1;
            tf.width = 25;
            cont.addChild(tf);
         }
         bmp.draw(cont,null,null,null,null,true);
         icon = new Bitmap(bmp);
         return cont;
      }
      
      private function resizeAll(___width:int) : void
      {
         var i:Object = null;
         var d:Object = null;
         this.iconWidth = ___width - (this.battleList.maxVerticalScrollPosition > 0 ? 32 : 20);
         if(this.iconWidth == this.oldIconWidth)
         {
            return;
         }
         this.oldIconWidth = this.iconWidth;
         for(var j:int = 0; j < this.dp.length; j++)
         {
            i = this.dp.getItemAt(j);
            d = i.dat;
            i.iconNormal = this.myIcon(false,d);
            i.iconSelected = this.myIcon(true,d);
            this.dp.replaceItemAt(i,j);
            this.dp.invalidateItemAt(j);
         }
      }
      
      private function onResize(e:Event = null) : void
      {
         var listWidth:int = 0;
         var minWidth:int = int(Math.max(1000,stage.stageWidth));
         var index:int = this.battleList.selectedIndex;
         if(this.delayTimer == null)
         {
            this.delayTimer = new Timer(400,1);
            this.delayTimer.addEventListener(TimerEvent.TIMER,this.resizeList);
         }
         this.mainBackground.width = minWidth / 3;
         this.mainBackground.height = Math.max(stage.stageHeight - 60,530);
         this.x = this.mainBackground.width;
         this.y = 60;
         this.inner.width = this.mainBackground.width - 22;
         this.inner.height = this.mainBackground.height - 58;
         this.createButton.x = this.mainBackground.width - this.createButton.width - 11;
         this.createButton.y = this.mainBackground.height - 42;
         this.dmButton.x = this.inner.x;
         this.dmButton.y = this.mainBackground.height - 42;
         this.tdmButton.x = this.dmButton.x + 11 / 2 + this.dmButton.width;
         this.tdmButton.y = this.mainBackground.height - 42;
         this.ctfButton.x = this.tdmButton.x + 11 / 2 + this.tdmButton.width;
         this.ctfButton.y = this.mainBackground.height - 42;
         this.domButton.x = this.ctfButton.x + 11 / 2 + this.ctfButton.width;
         this.domButton.y = this.mainBackground.height - 42;
         this.dmBitmap.x = this.dmButton.x + (this.dmButton.width - this.dmBitmap.width) / 2;
         this.dmBitmap.y = this.dmButton.y + (this.dmButton.height - this.dmBitmap.height) / 2;
         this.tdmBitmap.x = this.tdmButton.x + (this.tdmButton.width - this.tdmBitmap.width) / 2;
         this.tdmBitmap.y = this.tdmButton.y + (this.tdmButton.height - this.tdmBitmap.height) / 2;
         this.ctfBitmap.x = this.ctfButton.x + (this.ctfButton.width - this.ctfBitmap.width) / 2;
         this.ctfBitmap.y = this.ctfButton.y + (this.ctfButton.height - this.ctfBitmap.height) / 2;
         this.domBitmap.x = this.domButton.x + (this.domButton.width - this.domBitmap.width) / 2;
         this.domBitmap.y = this.domButton.y + (this.domButton.height - this.domBitmap.height) / 2;
         this.createButton.x = this.mainBackground.width - this.createButton.width - 11;
         this.createButton.y = this.mainBackground.height - 42;
         listWidth = this.inner.width - (this.battleList.maxVerticalScrollPosition > 0 ? 0 : 4);
         this.battleList.setSize(listWidth,this.inner.height - 8);
         this.resizeAll(listWidth);
         this.delayTimer.stop();
         this.delayTimer.start();
      }
      
      private function resizeList(e:TimerEvent) : void
      {
         var index:int = this.battleList.selectedIndex;
         var listWidth:int = this.inner.width - (this.battleList.maxVerticalScrollPosition > 0 ? 0 : 4);
         this.battleList.setSize(listWidth,this.inner.height - 8);
         this.resizeAll(listWidth);
         this.battleList.selectedIndex = index;
         this.battleList.scrollToSelected();
         this.delayTimer.removeEventListener(TimerEvent.TIMER,this.resizeList);
         this.delayTimer = null;
      }
      
      public function destroy() : *
      {
         this.mainBackground = null;
      }
   }
}
