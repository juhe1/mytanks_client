package alternativa.tanks.model.gift
{
   import alternativa.init.Main;
   import alternativa.osgi.service.locale.ILocaleService;
   import alternativa.resource.StubBitmapData;
   import alternativa.tanks.locale.constants.TextConst;
   import alternativa.tanks.model.GarageModel;
   import alternativa.tanks.model.IGarage;
   import alternativa.tanks.model.gift.opened.GiftOpenedView;
   import alternativa.tanks.model.gift.opened.GivenItem;
   import alternativa.tanks.model.panel.IPanel;
   import alternativa.tanks.model.panel.PanelModel;
   import com.alternativaplatform.projects.tanks.client.garage.garage.ItemInfo;
   import controls.DefaultButton;
   import controls.Label;
   import controls.TankWindow;
   import controls.TankWindowInner;
   import flash.display.BitmapData;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.utils.getTimer;
   import scpacker.networking.INetworker;
   import scpacker.networking.Network;
   import scpacker.resource.ResourceType;
   import scpacker.resource.ResourceUtil;
   
   public class GiftView extends Sprite
   {
      
      public static const WINNER_ITEM_ID:int = 9;
      
      private static const ANIMATE_DURATION:int = 9700;
       
      
      private var localeService:ILocaleService;
      
      private var window:TankWindow;
      
      private var roller:GilfRoller;
      
      private var playButton:DefaultButton;
      
      private var playButton5:DefaultButton;
      
      private var playButton10:DefaultButton;
      
      public var closeButton:DefaultButton;
      
      private var giftInfoList:GiftInfoList;
      
      private var startTime:Number;
      
      private var finalPosition:Number;
      
      private var items:Array;
      
      private var firstRoll = true;
      
      private var openedCountLabel:Label;
      
      private var leftCountLabel:Label;
      
      private var opened:int = 0;
      
      private var lefted:int = 0;
      
      private var offsetCrystalls:int = -1;
      
      private var winnerItemId:String;
      
      private var winnerCountItems:Array;
      
      private var itemName:String;
      
      private var rarityItem:int;
      
      private var openMultiply:int;
      
      public function GiftView(data:Array, count:int)
      {
         this.window = new TankWindow();
         this.playButton = new DefaultButton();
         this.playButton5 = new DefaultButton();
         this.playButton10 = new DefaultButton();
         this.closeButton = new DefaultButton();
         super();
         this.items = data;
         this.lefted = count;
         this.localeService = ILocaleService(Main.osgi.getService(ILocaleService));
         this.window.width = 595 + 108;
         this.window.height = 610;
         var inner:TankWindowInner = new TankWindowInner(0,0,TankWindowInner.GREEN);
         inner.width = this.window.width - 20;
         inner.height = this.window.height - 55;
         inner.showBlink = true;
         inner.x = 10;
         inner.y = 10;
         addChild(this.window);
         addChild(inner);
         this.roller = new GilfRoller(data,this.window.width - 60,128);
         this.roller.x = 30;
         this.roller.y = 30;
         addChild(this.roller);
         this.playButton.label = this.localeService.getText(TextConst.GIFT_WINDOW_OPEN);
         this.playButton.width = 151;
         this.playButton.x = this.window.width / 2 - this.playButton.width / 2;
         this.playButton.y = 191;
         this.playButton.height = 30;
         addChild(this.playButton);
         this.playButton.addEventListener(MouseEvent.CLICK,this.openGift);
         this.playButton5.label = this.localeService.getText(TextConst.GIFT_WINDOW_OPEN) + " x5";
         this.playButton5.width = 151;
         this.playButton5.x = this.window.width / 2 - this.playButton.width / 2;
         this.playButton5.y = 230;
         this.playButton5.height = 30;
         addChild(this.playButton5);
         this.playButton5.addEventListener(MouseEvent.CLICK,this.openGift);
         this.playButton5.enable = this.lefted >= 5;
         this.playButton10.label = this.localeService.getText(TextConst.GIFT_WINDOW_OPEN) + " x10";
         this.playButton10.width = 151;
         this.playButton10.x = this.window.width / 2 - this.playButton.width / 2;
         this.playButton10.y = 269;
         this.playButton10.height = 30;
         addChild(this.playButton10);
         this.playButton10.addEventListener(MouseEvent.CLICK,this.openGift);
         this.playButton10.enable = this.lefted >= 10;
         this.giftInfoList = new GiftInfoList();
         this.giftInfoList.width = this.window.width - 60;
         this.giftInfoList.height = 250;
         this.giftInfoList.x = 30;
         this.giftInfoList.y = inner.height - this.giftInfoList.height + 5;
         this.giftInfoList.initData(data);
         addChild(this.giftInfoList);
         this.closeButton.label = this.localeService.getText(TextConst.GIFT_WINDOW_CLOSE);
         this.closeButton.x = this.window.width - this.closeButton.width - 10;
         this.closeButton.y = this.window.height - this.closeButton.height - 11;
         addChild(this.closeButton);
         this.openedCountLabel = new Label();
         this.openedCountLabel.x = this.playButton.x - 80;
         this.openedCountLabel.y = this.playButton.y + 8;
         this.openedCountLabel.text = this.localeService.getText(TextConst.GIFT_WINDOW_OPENED) + this.opened;
         this.openedCountLabel.size = 12;
         this.openedCountLabel.textColor = 7726175;
         addChild(this.openedCountLabel);
         this.leftCountLabel = new Label();
         this.leftCountLabel.x = this.playButton.x + this.playButton.width + 20;
         this.leftCountLabel.y = this.playButton.y + 8;
         this.leftCountLabel.text = this.localeService.getText(TextConst.GIFT_WINDOW_LEFTED) + this.lefted;
         this.leftCountLabel.size = 12;
         this.leftCountLabel.textColor = 7726175;
         addChild(this.leftCountLabel);
         var infoText:Label = new Label();
         infoText.text = this.localeService.getText(TextConst.GIFT_WINDOW_INFO);
         infoText.x = 13;
         infoText.y = this.window.height - infoText.height - 18;
         addChild(infoText);
      }
      
      private function openGift(event:MouseEvent) : void
      {
         this.playButton.enable = false;
         this.playButton5.enable = false;
         this.playButton10.enable = false;
         this.closeButton.enable = false;
         if(event.currentTarget == this.playButton)
         {
            this.openMultiply = 1;
            Network(Main.osgi.getService(INetworker)).send("lobby;try_roll_item");
         }
         if(event.currentTarget == this.playButton5)
         {
            this.openMultiply = 5;
            Network(Main.osgi.getService(INetworker)).send("lobby;try_roll_items;5");
         }
         if(event.currentTarget == this.playButton10)
         {
            this.openMultiply = 10;
            Network(Main.osgi.getService(INetworker)).send("lobby;try_roll_items;10");
         }
      }
      
      public function rolls(param1:Array) : void
      {
         var _loc3_:Object = null;
         var _loc4_:int = 0;
         var _loc5_:Object = null;
         var _loc6_:BitmapData = null;
         var _loc7_:GivenItem = null;
         var _loc8_:* = undefined;
         var _loc9_:Array = null;
         var _loc10_:int = 0;
         var _loc11_:ItemInfo = null;
         this.opened += this.openMultiply;
         this.lefted -= this.openMultiply;
         this.openedCountLabel.text = this.localeService.getText(TextConst.GIFT_WINDOW_OPENED) + this.opened;
         this.leftCountLabel.text = this.localeService.getText(TextConst.GIFT_WINDOW_LEFTED) + this.lefted;
         if(this.lefted < 1)
         {
            GarageModel(Main.osgi.getService(IGarage)).removeItemFromWarehouse("gift_m0");
         }
         else
         {
            for(_loc4_ = 0; _loc4_ < this.openMultiply; _loc4_++)
            {
               GarageModel(Main.osgi.getService(IGarage)).decreaseCountItems("gift_m0");
            }
         }
         var _loc2_:Array = new Array();
         for each(_loc3_ in param1)
         {
            _loc5_ = ResourceUtil.getResource(ResourceType.IMAGE,_loc3_.itemId + "_m0_preview");
            _loc6_ = _loc5_ == null ? new StubBitmapData(1) : _loc5_.bitmapData;
            _loc7_ = new GivenItem(_loc6_,_loc3_.visualItemName,_loc3_.rarity);
            _loc2_.push(_loc7_);
            _loc8_ = parseInt(_loc3_.offsetCrystalls);
            if(_loc8_ > 0)
            {
               if(this.offsetCrystalls == -1)
               {
                  this.offsetCrystalls = 0;
               }
               this.offsetCrystalls += _loc8_;
            }
            this.winnerCountItems = _loc3_.numInventoryCounts as Array;
            this.winnerItemId = _loc3_.itemId;
            if(this.winnerItemId != "crystalls")
            {
               if(this.winnerItemId.indexOf("set_") != -1)
               {
                  _loc9_ = new Array("health_m0","armor_m0","double_damage_m0","n2o_m0","mine_m0");
                  for(_loc10_ = 0; _loc10_ < _loc9_.length; _loc10_++)
                  {
                     _loc11_ = new ItemInfo();
                     _loc11_.count = this.winnerCountItems[_loc10_];
                     _loc11_.itemId = _loc9_[_loc10_];
                     _loc11_.addable = true;
                     GarageModel(Main.osgi.getService(IGarage)).buyItem(null,_loc11_);
                  }
               }
               else if(this.offsetCrystalls < 1)
               {
                  _loc11_ = new ItemInfo();
                  _loc11_.count = this.winnerCountItems[0];
                  _loc11_.itemId = this.winnerItemId + "_m0";
                  _loc11_.addable = true;
                  GarageModel(Main.osgi.getService(IGarage)).buyItem(null,_loc11_);
               }
            }
         }
         Main.stage.addChild(new GiftOpenedView(_loc2_));
         if(this.lefted < 1)
         {
            this.closeButton.dispatchEvent(new MouseEvent(MouseEvent.CLICK,true,false));
         }
         if(this.offsetCrystalls != -1)
         {
            trace("OFFSET CRYSTALLS: " + this.offsetCrystalls);
            PanelModel(Main.osgi.getService(IPanel)).updateCrystal(null,PanelModel(Main.osgi.getService(IPanel)).crystal + this.offsetCrystalls);
         }
         this.playButton.enable = this.lefted > 0;
         this.playButton5.enable = this.lefted >= 5;
         this.playButton10.enable = this.lefted >= 10;
         this.closeButton.enable = true;
         this.offsetCrystalls = 0;
      }
      
      public function roll(winnerId:String, countItem:Array, offsetCrystalls:int, itemName:String, rarity:int) : void
      {
         if(!this.firstRoll)
         {
            this.roller.init(this.items);
         }
         this.offsetCrystalls = offsetCrystalls;
         this.winnerItemId = winnerId;
         this.winnerCountItems = countItem;
         this.itemName = itemName;
         this.rarityItem = rarity;
         this.firstRoll = false;
         ++this.opened;
         --this.lefted;
         this.openedCountLabel.text = this.localeService.getText(TextConst.GIFT_WINDOW_OPENED) + this.opened;
         this.leftCountLabel.text = this.localeService.getText(TextConst.GIFT_WINDOW_LEFTED) + this.lefted;
         if(this.lefted < 1)
         {
            GarageModel(Main.osgi.getService(IGarage)).removeItemFromWarehouse("gift_m0");
         }
         else
         {
            GarageModel(Main.osgi.getService(IGarage)).decreaseCountItems("gift_m0");
         }
         this.roller.list.update(WINNER_ITEM_ID + 4,"preview",ResourceUtil.getResource(ResourceType.IMAGE,winnerId + "_m0_preview"));
         var offset:Number = Math.random();
         var marketOffser:Number = this.giftInfoList.width / 2;
         this.finalPosition = 204 * WINNER_ITEM_ID + marketOffser + offset * 180;
         this.startTime = getTimer();
         Main.stage.addEventListener(Event.ENTER_FRAME,this.update);
      }
      
      private function update(param1:Event) : void
      {
         var _loc5_:BitmapData = null;
         var _loc6_:GivenItem = null;
         var _loc7_:Array = null;
         var _loc8_:int = 0;
         var _loc9_:ItemInfo = null;
         var _loc2_:Number = (getTimer() - this.startTime) / ANIMATE_DURATION;
         if(_loc2_ > 1)
         {
            _loc2_ = 1;
            Main.stage.removeEventListener(Event.ENTER_FRAME,this.update);
            this.playButton.enable = true;
            this.playButton5.enable = this.lefted >= 5;
            this.playButton10.enable = this.lefted >= 10;
            this.closeButton.enable = true;
            if(this.lefted < 1)
            {
               this.closeButton.dispatchEvent(new MouseEvent(MouseEvent.CLICK,true,false));
            }
            if(this.offsetCrystalls != -1)
            {
               PanelModel(Main.osgi.getService(IPanel)).updateCrystal(null,PanelModel(Main.osgi.getService(IPanel)).crystal + this.offsetCrystalls);
            }
            _loc5_ = ResourceUtil.getResource(ResourceType.IMAGE,this.winnerItemId + "_m0_preview").bitmapData;
            _loc6_ = new GivenItem(_loc5_,this.itemName,this.rarityItem);
            Main.stage.addChild(new GiftOpenedView(new Array(_loc6_)));
            if(this.winnerItemId == "crystalls")
            {
               return;
            }
            if(this.winnerItemId.indexOf("set_") != -1)
            {
               _loc7_ = new Array("health_m0","armor_m0","double_damage_m0","n2o_m0","mine_m0");
               for(_loc8_ = 0; _loc8_ < _loc7_.length; _loc8_++)
               {
                  _loc9_ = new ItemInfo();
                  _loc9_.count = this.winnerCountItems[_loc8_];
                  _loc9_.itemId = _loc7_[_loc8_];
                  _loc9_.addable = true;
                  GarageModel(Main.osgi.getService(IGarage)).buyItem(null,_loc9_);
               }
            }
            else if(this.offsetCrystalls < 1)
            {
               _loc9_ = new ItemInfo();
               _loc9_.count = this.winnerCountItems[0];
               _loc9_.itemId = this.winnerItemId + "_m0";
               _loc9_.addable = true;
               GarageModel(Main.osgi.getService(IGarage)).buyItem(null,_loc9_);
            }
         }
         var _loc3_:* = _loc2_ * (2 - _loc2_);
         var _loc4_:* = _loc3_ * this.finalPosition;
         this.roller.list.list.horizontalScrollPosition = _loc4_;
      }
   }
}
