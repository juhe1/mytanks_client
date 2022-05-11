package alternativa.tanks.model.profile
{
   import alternativa.init.Main;
   import alternativa.osgi.service.locale.ILocaleService;
   import alternativa.tanks.locale.constants.TextConst;
   import alternativa.tanks.model.challenge.greenpanel.GreenPanel;
   import controls.DefaultButton;
   import controls.Label;
   import controls.TankWindow;
   import controls.TankWindowInner;
   import fl.events.ListEvent;
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.Sprite;
   
   public class UserGiftsView extends Sprite
   {
      
      public static const WINNER_ITEM_ID:int = 9;
      
      private static const ANIMATE_DURATION:int = 9700;
      
[Embed(source="926.png")]
      private static const emptyBitmap:Class;
       
      
      private var empty:Bitmap;
      
      private var localeService:ILocaleService;
      
      private var window:TankWindow;
      
      public var closeButton:DefaultButton;
      
      private var giftInfoList:UserGiftsInfoList;
      
      private var userInfo:GiftUserInfo;
      
      private var panel:GreenPanel;
      
      private var preview:Bitmap;
      
      private var sender:Label;
      
      private var senderText:Label;
      
      private var nameG:Label;
      
      private var nameText:Label;
      
      private var date:Label;
      
      private var dateText:Label;
      
      private var message:Label;
      
      private var messageText:Label;
      
      private var status:Label;
      
      private var statusText:Label;
      
      private var emptyText:Label;
      
      private var items:Array;
      
      private var selectObj:Object;
      
      private var bitmapData:Object;
      
      public function UserGiftsView(data:Array, parserInfo:Object)
      {
         this.empty = new Bitmap(new emptyBitmap().bitmapData);
         this.panel = new GreenPanel(450,210);
         this.window = new TankWindow();
         this.closeButton = new DefaultButton();
         super();
         this.items = data;
         this.localeService = ILocaleService(Main.osgi.getService(ILocaleService));
         this.window.width = 595 + 108;
         this.window.height = this.items.length > 0 ? Number(450) : Number(325);
         var inner:TankWindowInner = new TankWindowInner(0,0,TankWindowInner.GREEN);
         inner.width = this.window.width - 20;
         inner.height = this.window.height - 55;
         inner.showBlink = true;
         inner.x = 10;
         inner.y = 10;
         addChild(this.window);
         addChild(inner);
         this.panel.x = 30;
         this.panel.y = 30;
         inner.addChild(this.panel);
         this.userInfo = new GiftUserInfo(parserInfo.userId,parserInfo.rank,parserInfo.spins,parserInfo.emeralds,parserInfo.incomingGifts,parserInfo.outcomingGifts);
         this.userInfo.x = this.panel.x + this.panel.width + 10;
         this.userInfo.y = this.panel.y;
         inner.addChild(this.userInfo);
         if(this.items.length <= 0)
         {
            this.emptyText = new Label();
            this.emptyText.color = 5898034;
            this.emptyText.size = 24;
            this.emptyText.text = this.localeService.getText(TextConst.PROFILE_WINDOW_EMPTY_TEXT);
            this.emptyText.x = this.panel.width / 2 - this.emptyText.width / 2;
            this.emptyText.y = 15;
            this.panel.addChild(this.emptyText);
            this.empty.x = this.panel.width / 2 - this.empty.width / 2;
            this.empty.y = this.emptyText.y + 40;
            this.panel.addChild(this.empty);
         }
         this.giftInfoList = new UserGiftsInfoList();
         this.giftInfoList.width = this.window.width - 60;
         this.giftInfoList.height = 135;
         this.giftInfoList.x = 30;
         this.giftInfoList.y = inner.height - this.giftInfoList.height + 5;
         this.giftInfoList.initData(data,this.successLoaded);
         this.giftInfoList.addClickListener(this.selectItem);
         addChild(this.giftInfoList);
         this.closeButton.label = this.localeService.getText(TextConst.GIFT_WINDOW_CLOSE);
         this.closeButton.x = this.window.width - this.closeButton.width - 10;
         this.closeButton.y = this.window.height - this.closeButton.height - 11;
         addChild(this.closeButton);
      }
      
      private function successLoaded(obj:Object) : void
      {
         this.selectObj = obj.item;
         this.bitmapData = obj.preview.bitmapData;
         this.loadPanel();
      }
      
      private function selectItem(e:ListEvent) : void
      {
         this.selectObj = e.item.dat.item;
         this.bitmapData = e.item.dat.preview.bitmapData;
         this.loadPanel();
      }
      
      private function loadPanel() : void
      {
         if(this.selectObj == null || this.bitmapData == null)
         {
            return;
         }
         this.showInfo(this.bitmapData);
      }
      
      private function showInfo(resource:Object) : void
      {
         this.removeOld();
         this.preview = new Bitmap(this.bitmapData as BitmapData);
         this.preview.x = 10;
         this.preview.y = 10;
         this.panel.addChild(this.preview);
         this.sender = new Label();
         this.sender.color = 5898034;
         this.sender.text = this.localeService.getText(TextConst.PROFILE_WINDOW_SENDER_TEXT);
         this.sender.x = this.preview.x + this.preview.width + 10;
         this.sender.y = 20;
         this.panel.addChild(this.sender);
         this.senderText = new Label();
         this.senderText.color = 16777215;
         this.senderText.text = this.selectObj.userid;
         this.senderText.x = this.sender.x + this.sender.width + 5;
         this.senderText.y = this.sender.y;
         this.panel.addChild(this.senderText);
         this.nameG = new Label();
         this.nameG.color = 5898034;
         this.nameG.text = this.localeService.getText(TextConst.PROFILE_WINDOW_NAME_TEXT);
         this.nameG.x = this.preview.x + this.preview.width + 10;
         this.nameG.y = this.senderText.y + this.senderText.height + 5;
         this.panel.addChild(this.nameG);
         this.nameText = new Label();
         this.nameText.color = 16777215;
         this.nameText.text = this.selectObj.name;
         this.nameText.x = this.nameG.x + this.nameG.width + 5;
         this.nameText.y = this.nameG.y;
         this.panel.addChild(this.nameText);
         this.date = new Label();
         this.date.color = 5898034;
         this.date.text = this.localeService.getText(TextConst.PROFILE_WINDOW_DATE_TEXT);
         this.date.x = this.preview.x + this.preview.width + 10;
         this.date.y = this.nameText.y + this.nameText.height + 5;
         this.panel.addChild(this.date);
         this.dateText = new Label();
         this.dateText.color = 16777215;
         this.dateText.text = this.selectObj.date;
         this.dateText.x = this.date.x + this.date.width + 5;
         this.dateText.y = this.date.y;
         this.panel.addChild(this.dateText);
         this.status = new Label();
         this.status.color = 5898034;
         this.status.text = this.localeService.getText(TextConst.PROFILE_WINDOW_STATUS_TEXT);
         this.status.x = this.preview.x + this.preview.width + 10;
         this.status.y = this.dateText.y + this.dateText.height + 5;
         this.panel.addChild(this.status);
         this.statusText = new Label();
         this.statusText.color = 16777215;
         this.statusText.text = this.selectObj.status.indexOf("Уникаль") > -1 ? "Уникальный" : this.selectObj.status;
         this.statusText.x = this.status.x + this.status.width + 5;
         this.statusText.y = this.status.y;
         this.panel.addChild(this.statusText);
         this.message = new Label();
         this.message.color = 5898034;
         this.message.text = this.localeService.getText(TextConst.PROFILE_WINDOW_MESSAGE_TEXT);
         this.message.x = this.preview.x;
         this.message.y = this.preview.y + this.preview.height + 5;
         this.panel.addChild(this.message);
         this.messageText = new Label();
         this.messageText.color = 16777215;
         this.messageText.htmlText = this.selectObj.message;
         this.messageText.x = this.message.x + this.message.width + 5;
         this.messageText.y = this.message.y;
         this.messageText.width = 350;
         this.messageText.multiline = true;
         this.messageText.wordWrap = true;
         this.panel.addChild(this.messageText);
      }
      
      private function removeOld() : void
      {
         if(this.preview != null)
         {
            this.panel.removeChild(this.preview);
            this.preview = null;
         }
         if(this.sender != null)
         {
            this.panel.removeChild(this.sender);
            this.sender = null;
         }
         if(this.senderText != null)
         {
            this.panel.removeChild(this.senderText);
            this.senderText = null;
         }
         if(this.nameG != null)
         {
            this.panel.removeChild(this.nameG);
            this.nameG = null;
         }
         if(this.nameText != null)
         {
            this.panel.removeChild(this.nameText);
            this.nameText = null;
         }
         if(this.date != null)
         {
            this.panel.removeChild(this.date);
            this.date = null;
         }
         if(this.dateText != null)
         {
            this.panel.removeChild(this.dateText);
            this.dateText = null;
         }
         if(this.status != null)
         {
            this.panel.removeChild(this.status);
            this.status = null;
         }
         if(this.statusText != null)
         {
            this.panel.removeChild(this.statusText);
            this.statusText = null;
         }
         if(this.message != null)
         {
            this.panel.removeChild(this.message);
            this.message = null;
         }
         if(this.messageText != null)
         {
            this.panel.removeChild(this.messageText);
            this.messageText = null;
         }
      }
   }
}
