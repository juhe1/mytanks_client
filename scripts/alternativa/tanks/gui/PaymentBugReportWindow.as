package alternativa.tanks.gui
{
   import alternativa.init.Main;
   import alternativa.model.IModel;
   import alternativa.osgi.service.locale.ILocaleService;
   import alternativa.service.IModelService;
   import alternativa.tanks.locale.constants.TextConst;
   import alternativa.tanks.model.panel.IPanel;
   import controls.DefaultButton;
   import controls.Label;
   import controls.TankCheckBox;
   import controls.TankCombo;
   import controls.TankInput;
   import controls.TankWindow;
   import controls.TankWindowHeader;
   import controls.TankWindowInner;
   import controls.TextArea;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import flash.text.TextFieldType;
   import flashx.textLayout.formats.TextAlign;
   
   public class PaymentBugReportWindow extends Sprite
   {
       
      
      private const INDEX_SMS:int = 0;
      
      private const INDEX_VISA:int = 1;
      
      private const INDEX_YANDEX:int = 2;
      
      private const INDEX_WEBMONEY:int = 3;
      
      private const INDEX_OTHER:int = 4;
      
      private var localeService:ILocaleService;
      
      private var window:TankWindow;
      
      private var windowWidth:int = 400;
      
      private var windowHeight:int;
      
      private const windowMargin:int = 11;
      
      private const spaceModule:int = 7;
      
      private const buttonSize:Point = new Point(104,33);
      
      private const descriptionInputHeight:int = 75;
      
      private const colomn2x:int = 100;
      
      public var nameInput:TankInput;
      
      private var nameLabel:Label;
      
      public var dateInput:TankInput;
      
      private var dateLabel:Label;
      
      public var paymentInput:TankInput;
      
      private var paymentLabel:Label;
      
      public var emailInput:TankInput;
      
      private var emailLabel:Label;
      
      public var descriptionInput:TextArea;
      
      private var descriptionLabel:Label;
      
      private var systemLabel:Label;
      
      public var systemCombo:TankCombo;
      
      private var sendButton:DefaultButton;
      
      private var cancelButton:DefaultButton;
      
      private var tabContainers:Array;
      
      private var tabInner:TankWindowInner;
      
      private var innerHeight:int;
      
      private var tabsContainer:Sprite;
      
      public var smsTextInput:TankInput;
      
      private var cardTypeLabel:Label;
      
      public var visaCheckBox:TankCheckBox;
      
      public var mastercardCheckBox:TankCheckBox;
      
      private var realNameLabel:Label;
      
      public var realNameInput:TankInput;
      
      private var lastDigitsLabel:Label;
      
      public var lastDigitsInput:TankInput;
      
      private var phoneNumberLabel:Label;
      
      public var phoneNumberInput:TankInput;
      
      private var walletNumberLabel:Label;
      
      public var walletNumberInput:TankInput;
      
      public var reportString:String;
      
      public function PaymentBugReportWindow()
      {
         var dataString:String = null;
         super();
         var modelRegister:IModelService = Main.osgi.getService(IModelService) as IModelService;
         var panelModel:IPanel = (modelRegister.getModelsByInterface(IPanel) as Vector.<IModel>)[0] as IPanel;
         this.localeService = ILocaleService(Main.osgi.getService(ILocaleService));
         this.window = new TankWindow(this.windowWidth,0);
         addChild(this.window);
         this.window.headerLang = this.localeService.getText(TextConst.GUI_LANG);
         this.window.header = TankWindowHeader.BUG_REPORT;
         this.nameLabel = new Label();
         addChild(this.nameLabel);
         this.nameLabel.text = this.localeService.getText(TextConst.PAYMENT_BUG_REPORT_CALLSIGN_INPUT_LABEL_TEXT);
         this.nameLabel.x = this.windowMargin;
         this.nameInput = new TankInput();
         addChild(this.nameInput);
         this.nameInput.textField.type = TextFieldType.DYNAMIC;
         this.nameInput.width = 140;
         this.nameInput.value = panelModel.userName;
         this.nameInput.x = this.nameLabel.x + this.nameLabel.width + this.spaceModule;
         this.nameInput.y = this.windowMargin;
         this.nameLabel.y = this.nameInput.y + Math.round((this.nameInput.height - this.nameLabel.textHeight) * 0.5) - 2;
         this.windowHeight = this.spaceModule * 4 + this.windowMargin * 3 + this.buttonSize.y + this.nameInput.height * 3 + this.descriptionInputHeight;
         this.dateLabel = new Label();
         addChild(this.dateLabel);
         this.dateLabel.multiline = true;
         this.dateLabel.text = this.localeService.getText(TextConst.PAYMENT_BUG_REPORT_DATE_INPUT_LABEL_TEXT);
         this.dateLabel.x = this.nameInput.x + this.nameInput.width + this.windowMargin;
         this.dateLabel.y = this.nameLabel.y;
         this.dateInput = new TankInput();
         addChild(this.dateInput);
         var time:Date = new Date();
         var monthString:String = time.month + 1 < 10 ? "0" + String(time.month + 1) : String(time.month + 1);
         var dayString:String = time.date < 10 ? "0" + String(time.date) : String(time.date);
         var yearString:String = String(time.fullYear);
         if(this.localeService.getText(TextConst.GUI_LANG) == "ru")
         {
            dataString = dayString + "." + monthString + "." + String(time.fullYear);
         }
         else
         {
            dataString = monthString + "." + dayString + "." + String(time.fullYear);
         }
         this.dateInput.value = dataString;
         this.dateInput.x = this.dateLabel.x + this.dateLabel.width + this.spaceModule;
         this.dateInput.y = this.windowMargin;
         this.dateInput.width = this.windowWidth - this.windowMargin - this.dateInput.x;
         this.dateInput.textField.addEventListener(Event.CHANGE,this.onInputDataChange);
         this.paymentInput = new TankInput();
         addChild(this.paymentInput);
         this.paymentInput.width = this.windowWidth - this.windowMargin - this.dateInput.x;
         this.paymentInput.x = this.dateInput.x;
         this.paymentInput.y = this.nameInput.y + this.nameInput.height + this.spaceModule;
         this.paymentInput.addEventListener(Event.CHANGE,this.onInputDataChange);
         this.paymentLabel = new Label();
         addChild(this.paymentLabel);
         this.paymentLabel.multiline = true;
         this.paymentLabel.align = TextAlign.RIGHT;
         this.paymentLabel.text = this.localeService.getText(TextConst.PAYMENT_BUG_REPORT_PAYMENT_INPUT_LABEL_TEXT);
         this.paymentLabel.x = this.paymentInput.x - this.spaceModule - this.paymentLabel.width;
         this.paymentLabel.y = this.paymentInput.y + Math.round((this.paymentInput.height - this.paymentLabel.textHeight) * 0.5) - 2;
         this.systemLabel = new Label();
         addChild(this.systemLabel);
         this.systemLabel.multiline = true;
         this.systemLabel.align = TextAlign.RIGHT;
         this.systemLabel.text = this.localeService.getText(TextConst.PAYMENT_BUG_REPORT_PAYMENT_SYSTEM_COMBO_LABEL_TEXT);
         this.systemLabel.x = this.windowMargin;
         this.systemCombo = new TankCombo();
         this.systemCombo.x = this.systemLabel.x + this.systemLabel.width + this.spaceModule;
         this.systemCombo.width = this.paymentLabel.x - this.systemCombo.x - this.windowMargin;
         this.systemCombo.y = this.paymentInput.y;
         this.systemLabel.y = this.systemCombo.y + Math.round((this.paymentInput.height - this.systemLabel.textHeight) * 0.5) - 2;
         this.systemCombo.addEventListener(Event.CHANGE,this.onSystemSelect);
         this.systemCombo.addItem({
            "gameName":this.localeService.getText(TextConst.PAYMENT_SMS_NAME_TEXT),
            "rang":0
         });
         this.systemCombo.addItem({
            "gameName":this.localeService.getText(TextConst.PAYMENT_VISA_NAME_TEXT),
            "rang":0
         });
         if(this.localeService.getText(TextConst.GUI_LANG) == "ru")
         {
            this.systemCombo.addItem({
               "gameName":this.localeService.getText(TextConst.PAYMENT_YANDEX_MONEY_NAME_TEXT),
               "rang":0
            });
         }
         this.systemCombo.addItem({
            "gameName":this.localeService.getText(TextConst.PAYMENT_WEBMONEY_NAME_TEXT),
            "rang":0
         });
         this.systemCombo.addItem({
            "gameName":this.localeService.getText(TextConst.PAYMENT_BUG_REPORT_OTHER_PAYMENT_SYSTEM_NAME_TEXT),
            "rang":0
         });
         this.systemCombo.selectedItem = null;
         this.tabsContainer = new Sprite();
         addChild(this.tabsContainer);
         this.tabsContainer.visible = false;
         this.tabsContainer.x = this.windowMargin;
         this.tabsContainer.y = this.paymentInput.y + this.paymentInput.height + this.spaceModule;
         this.tabInner = new TankWindowInner(0,0,TankWindowInner.TRANSPARENT);
         this.tabsContainer.addChild(this.tabInner);
         this.tabInner.width = this.windowWidth - this.windowMargin * 2;
         this.tabContainers = new Array();
         var tab:Sprite = this.addTab(this.INDEX_SMS);
         this.smsTextInput = new TankInput();
         tab.addChild(this.smsTextInput);
         this.smsTextInput.label = this.localeService.getText(TextConst.PAYMENT_BUG_REPORT_SMS_TEXT_INPUT_LABEL_TEXT);
         this.smsTextInput.width = this.windowWidth - this.colomn2x - this.windowMargin - this.spaceModule;
         this.smsTextInput.x = this.colomn2x - this.windowMargin - this.spaceModule;
         tab = this.addTab(this.INDEX_VISA);
         this.cardTypeLabel = new Label();
         tab.addChild(this.cardTypeLabel);
         this.cardTypeLabel.text = this.localeService.getText(TextConst.PAYMENT_BUG_REPORT_CARD_TYPE_LABEL_TEXT);
         this.visaCheckBox = new TankCheckBox();
         this.visaCheckBox.type = TankCheckBox.CHECK_SIGN;
         this.visaCheckBox.checked = true;
         this.visaCheckBox.label = this.localeService.getText(TextConst.PAYMENT_VISA_NAME_TEXT);
         tab.addChild(this.visaCheckBox);
         this.visaCheckBox.addEventListener(MouseEvent.CLICK,this.visaSelected);
         this.visaCheckBox.x = this.colomn2x - this.windowMargin - this.spaceModule;
         this.cardTypeLabel.y = this.visaCheckBox.y + Math.round((this.visaCheckBox.height - this.cardTypeLabel.textHeight) * 0.5) - 2;
         this.cardTypeLabel.x = this.visaCheckBox.x - this.spaceModule - this.cardTypeLabel.width;
         this.mastercardCheckBox = new TankCheckBox();
         this.mastercardCheckBox.type = TankCheckBox.CHECK_SIGN;
         this.mastercardCheckBox.label = this.localeService.getText(TextConst.PAYMENT_BUG_REPORT_MASTERCARD_NAME_TEXT);
         tab.addChild(this.mastercardCheckBox);
         this.mastercardCheckBox.addEventListener(MouseEvent.CLICK,this.mastercardSelected);
         this.mastercardCheckBox.x = this.spaceModule + 150;
         this.realNameInput = new TankInput();
         tab.addChild(this.realNameInput);
         this.realNameInput.width = this.windowWidth - this.colomn2x - this.windowMargin - this.spaceModule;
         this.realNameInput.x = this.colomn2x - this.windowMargin - this.spaceModule;
         this.realNameInput.y = this.visaCheckBox.height + this.spaceModule;
         this.realNameInput.addEventListener(Event.CHANGE,this.onInputDataChange);
         this.realNameLabel = new Label();
         tab.addChild(this.realNameLabel);
         this.realNameLabel.multiline = true;
         this.realNameLabel.align = TextAlign.RIGHT;
         this.realNameLabel.text = this.localeService.getText(TextConst.PAYMENT_BUG_REPORT_NAME_AND_LASTNAME_INPUT_LABEL_TEXT);
         this.realNameLabel.x = this.realNameInput.x - this.spaceModule - this.realNameLabel.width;
         this.realNameLabel.y = this.realNameInput.y + Math.round((this.realNameInput.height - this.realNameLabel.textHeight) * 0.5) - 2;
         this.lastDigitsInput = new TankInput();
         tab.addChild(this.lastDigitsInput);
         this.lastDigitsInput.width = this.windowWidth - this.colomn2x - this.windowMargin - this.spaceModule;
         this.lastDigitsInput.x = this.colomn2x - this.windowMargin - this.spaceModule;
         this.lastDigitsInput.y = this.realNameInput.y + this.realNameInput.height + this.spaceModule;
         this.lastDigitsInput.addEventListener(Event.CHANGE,this.onInputDataChange);
         this.lastDigitsLabel = new Label();
         tab.addChild(this.lastDigitsLabel);
         this.lastDigitsLabel.multiline = true;
         this.lastDigitsLabel.align = TextAlign.RIGHT;
         this.lastDigitsLabel.text = this.localeService.getText(TextConst.PAYMENT_BUG_REPORT_CARD_LAST_FIGURES_INPUT_LABEL_TEXT);
         this.lastDigitsLabel.x = this.lastDigitsInput.x - this.spaceModule - this.lastDigitsLabel.width;
         this.lastDigitsLabel.y = this.lastDigitsInput.y + Math.round((this.lastDigitsInput.height - this.lastDigitsLabel.textHeight) * 0.5) - 2;
         this.phoneNumberInput = new TankInput();
         tab.addChild(this.phoneNumberInput);
         this.phoneNumberInput.width = this.windowWidth - this.colomn2x - this.windowMargin - this.spaceModule;
         this.phoneNumberInput.x = this.colomn2x - this.windowMargin - this.spaceModule;
         this.phoneNumberInput.y = this.lastDigitsInput.y + this.lastDigitsInput.height + this.spaceModule;
         this.phoneNumberInput.addEventListener(Event.CHANGE,this.onInputDataChange);
         this.phoneNumberLabel = new Label();
         tab.addChild(this.phoneNumberLabel);
         this.phoneNumberLabel.multiline = true;
         this.phoneNumberLabel.align = TextAlign.RIGHT;
         this.phoneNumberLabel.text = this.localeService.getText(TextConst.PAYMENT_BUG_REPORT_PHONE_NUMBER_INPUT_LABEL_TEXT);
         this.phoneNumberLabel.x = this.phoneNumberInput.x - this.spaceModule - this.phoneNumberLabel.width;
         this.phoneNumberLabel.y = this.phoneNumberInput.y + Math.round((this.phoneNumberInput.height - this.phoneNumberLabel.textHeight) * 0.5) - 2;
         tab = this.addTab(this.INDEX_YANDEX);
         this.tabContainers[this.INDEX_WEBMONEY] = tab;
         this.walletNumberInput = new TankInput();
         tab.addChild(this.walletNumberInput);
         this.walletNumberInput.width = this.windowWidth - this.colomn2x - this.windowMargin - this.spaceModule;
         this.walletNumberInput.x = this.colomn2x - this.windowMargin - this.spaceModule;
         this.walletNumberLabel = new Label();
         tab.addChild(this.walletNumberLabel);
         this.walletNumberLabel.multiline = true;
         this.walletNumberLabel.align = TextAlign.RIGHT;
         this.walletNumberLabel.text = this.localeService.getText(TextConst.PAYMENT_BUG_REPORT_PURSE_NUMBER_INPUT_LABEL_TEXT);
         this.walletNumberLabel.x = this.walletNumberInput.x - this.spaceModule - this.walletNumberLabel.width;
         this.walletNumberLabel.y = this.walletNumberInput.y + Math.round((this.walletNumberInput.height - this.phoneNumberLabel.textHeight) * 0.5) - 2;
         this.cancelButton = new DefaultButton();
         addChild(this.cancelButton);
         this.cancelButton.label = this.localeService.getText(TextConst.BUG_REPORT_BUTTON_CANCEL_TEXT);
         this.cancelButton.x = this.windowWidth - this.buttonSize.x - this.windowMargin + 5;
         this.sendButton = new DefaultButton();
         addChild(this.sendButton);
         this.sendButton.label = this.localeService.getText(TextConst.BUG_REPORT_BUTTON_SEND_TEXT);
         this.sendButton.x = this.windowWidth - this.buttonSize.x * 2 - 1 - this.windowMargin;
         this.descriptionInput = new TextArea();
         addChild(this.descriptionInput);
         this.descriptionInput.x = this.colomn2x;
         this.descriptionInput.width = this.windowWidth - this.colomn2x - this.windowMargin;
         this.descriptionInput.height = this.descriptionInputHeight;
         this.emailInput = new TankInput();
         addChild(this.emailInput);
         this.emailInput.label = this.localeService.getText(TextConst.PAYMENT_BUG_REPORT_EMAIL_INPUT_LABEL_TEXT);
         this.emailInput.value = panelModel.userEmail;
         this.emailInput.x = this.colomn2x;
         this.emailInput.width = this.windowWidth - this.colomn2x - this.windowMargin;
         this.emailInput.addEventListener(Event.CHANGE,this.onInputDataChange);
         this.descriptionLabel = new Label();
         addChild(this.descriptionLabel);
         this.descriptionLabel.text = this.localeService.getText(TextConst.PAYMENT_BUG_REPORT_COMMENT_INPUT_LABEL_TEXT);
         this.descriptionLabel.x = this.descriptionInput.x - this.spaceModule - this.descriptionLabel.width;
         this.sendButton.enable = false;
         this.cancelButton.addEventListener(MouseEvent.CLICK,this.onCancelClick);
         this.sendButton.addEventListener(MouseEvent.CLICK,this.onSendClick);
         addChild(this.systemCombo);
         this.hideAll();
         this.resize();
      }
      
      private function addTab(index:int) : Sprite
      {
         var tab:Sprite = new Sprite();
         this.tabsContainer.addChild(tab);
         tab.x = this.spaceModule;
         tab.y = this.spaceModule;
         this.tabContainers[index] = tab;
         return tab;
      }
      
      private function onCancelClick(e:MouseEvent) : void
      {
         dispatchEvent(new Event(Event.CANCEL,true,false));
      }
      
      private function onSendClick(e:MouseEvent) : void
      {
         this.reportString = this.localeService.getText(TextConst.PAYMENT_COMMON_NAME) + this.nameInput.value + "\n";
         this.reportString += this.localeService.getText(TextConst.PAYMENT_COMMON_LANGUAGE) + this.localeService.language + "\n";
         this.reportString += this.localeService.getText(TextConst.PAYMENT_COMMON_DATE) + this.dateInput.value + "\n";
         this.reportString += this.localeService.getText(TextConst.PAYMENT_COMMON_SYSTEM) + this.systemCombo.selectedItem["gameName"] + "\n";
         this.reportString += this.localeService.getText(TextConst.PAYMENT_COMMON_TRANSACTION) + this.paymentInput.value + "\n";
         switch(this.systemCombo.selectedItem["gameName"])
         {
            case this.localeService.getText(TextConst.PAYMENT_SMS_NAME_TEXT):
               if(this.smsTextInput.value != "")
               {
                  this.reportString += this.localeService.getText(TextConst.PAYMENT_SMS_REQUEST_TEXT) + this.smsTextInput.value + "\n";
               }
               break;
            case this.localeService.getText(TextConst.PAYMENT_VISA_NAME_TEXT):
               this.reportString += this.localeService.getText(TextConst.PAYMENT_CARD_TYPE) + (!!this.visaCheckBox.checked ? "VISA" : "MaterCard") + "\n";
               this.reportString += this.localeService.getText(TextConst.PAYMENT_CARD_CODE) + this.lastDigitsInput.value + "\n";
               this.reportString += this.localeService.getText(TextConst.PAYMENT_CARD_NAME) + this.realNameInput.value + "\n";
               this.reportString += this.localeService.getText(TextConst.PAYMENT_CARD_PHONE_NUMBER) + this.phoneNumberInput.value + "\n";
               break;
            case this.localeService.getText(TextConst.PAYMENT_YANDEX_MONEY_NAME_TEXT):
               if(this.walletNumberInput.value != "")
               {
                  this.reportString += this.localeService.getText(TextConst.PAYMENT_YANDEX_MONEY_NUMBER) + this.walletNumberInput.value + "\n";
               }
               break;
            case this.localeService.getText(TextConst.PAYMENT_WEBMONEY_NAME_TEXT):
               if(this.walletNumberInput.value != "")
               {
                  this.reportString += this.localeService.getText(TextConst.PAYMENT_YANDEX_MONEY_NUMBER) + this.walletNumberInput.value + "\n";
               }
         }
         this.reportString += "E-mail: " + this.emailInput.value + "\n";
         if(this.descriptionInput.text != "")
         {
            this.reportString += this.localeService.getText(TextConst.PAYMENT_COMMON_COMMENT) + this.descriptionInput.text + "\n";
         }
         dispatchEvent(new Event(Event.COMPLETE,true,false));
      }
      
      private function hideAll() : void
      {
         for(var i:int = 0; i < this.tabContainers.length; i++)
         {
            (this.tabContainers[i] as Sprite).visible = false;
         }
      }
      
      private function onSystemSelect(e:Event) : void
      {
         var systemName:String = null;
         if(this.systemCombo.selectedItem != null)
         {
            systemName = this.systemCombo.selectedItem["gameName"];
            if(systemName == this.localeService.getText(TextConst.PAYMENT_BUG_REPORT_OTHER_PAYMENT_SYSTEM_NAME_TEXT))
            {
               this.tabsContainer.visible = false;
               this.innerHeight = 0;
            }
            else
            {
               this.tabsContainer.visible = true;
               this.hideAll();
               if(systemName == this.localeService.getText(TextConst.PAYMENT_VISA_NAME_TEXT))
               {
                  (this.tabContainers[this.INDEX_VISA] as Sprite).visible = true;
                  this.innerHeight = this.visaCheckBox.height + this.nameInput.height * 3 + this.spaceModule * 5;
                  this.tabInner.height = this.innerHeight;
               }
               else
               {
                  this.innerHeight = this.nameInput.height + this.spaceModule * 2;
                  this.tabInner.height = this.innerHeight;
                  if(systemName == this.localeService.getText(TextConst.PAYMENT_SMS_NAME_TEXT))
                  {
                     (this.tabContainers[this.INDEX_SMS] as Sprite).visible = true;
                  }
                  else if(systemName == this.localeService.getText(TextConst.PAYMENT_YANDEX_MONEY_NAME_TEXT))
                  {
                     (this.tabContainers[this.INDEX_YANDEX] as Sprite).visible = true;
                  }
                  else
                  {
                     (this.tabContainers[this.INDEX_WEBMONEY] as Sprite).visible = true;
                  }
               }
            }
            this.resize();
            this.checkMainFields();
         }
      }
      
      private function resize() : void
      {
         this.windowHeight = (!!this.tabsContainer.visible ? this.innerHeight + this.spaceModule : 0) + this.spaceModule * 3 + this.windowMargin * 3 + this.buttonSize.y + this.nameInput.height * 3 + this.descriptionInputHeight;
         this.window.height = this.windowHeight;
         this.cancelButton.y = this.windowHeight - this.buttonSize.y - this.windowMargin;
         this.sendButton.y = this.windowHeight - this.buttonSize.y - this.windowMargin;
         this.descriptionInput.y = this.windowHeight - this.windowMargin * 2 - this.descriptionInputHeight - this.buttonSize.y;
         this.descriptionLabel.y = this.descriptionInput.y;
         this.emailInput.y = this.descriptionInput.y - this.spaceModule - this.emailInput.height;
         this.align();
      }
      
      private function align() : void
      {
         this.x = Math.round((Main.stage.stageWidth - this.width) * 0.5);
         this.y = Math.round((Main.stage.stageHeight - this.height) * 0.5);
      }
      
      private function onInputDataChange(e:Event) : void
      {
         this.checkMainFields();
         Main.writeToConsole("InputChange");
      }
      
      private function visaSelected(e:MouseEvent) : void
      {
         this.mastercardCheckBox.checked = false;
      }
      
      private function mastercardSelected(e:MouseEvent) : void
      {
         this.visaCheckBox.checked = false;
      }
      
      private function checkMainFields() : void
      {
         var mailPattern:RegExp = null;
         var datePattern:RegExp = null;
         var dataValid:Boolean = false;
         if(this.systemCombo.selectedItem != null)
         {
            mailPattern = /(\w|[_.\-])+@((\w|-)+\.)+\w{2,4}+/;
            datePattern = /[0-9]{1,2}\.[0-9]{1,2}\.[0-9]{4}/;
            dataValid = this.paymentInput.value.length > 0 && mailPattern.exec(this.emailInput.value) != null && datePattern.exec(this.dateInput.value) != null;
            if(this.systemCombo.selectedItem["gameName"] == this.localeService.getText(TextConst.PAYMENT_VISA_NAME_TEXT))
            {
               dataValid = dataValid && (this.realNameInput.value.length > 0 && this.realNameInput.value.indexOf(" ") != -1 && this.lastDigitsInput.value.length > 0 && this.phoneNumberInput.value.length > 0);
            }
         }
         this.sendButton.enable = dataValid;
      }
   }
}
