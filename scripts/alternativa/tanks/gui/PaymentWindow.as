package alternativa.tanks.gui
{
   import alternativa.init.Main;
   import alternativa.osgi.service.locale.ILocaleService;
   import alternativa.tanks.model.panel.IPanel;
   import assets.scroller.color.ScrollThumbSkinGreen;
   import assets.scroller.color.ScrollTrackGreen;
   import controls.DefaultButton;
   import controls.Label;
   import controls.PaymentButton;
   import controls.TankCombo;
   import controls.TankWindow;
   import controls.TankWindowInner;
   import fl.containers.ScrollPane;
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.DisplayObjectContainer;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import flash.net.SharedObject;
   import projects.tanks.client.panel.model.payment.SMSNumber;
   
   public class PaymentWindow extends Sprite
   {
      
[Embed(source="1031.png")]
      private static const bitmapCrystalsPic:Class;
      
      private static const crystalsBd:BitmapData = new bitmapCrystalsPic().bitmapData;
      
[Embed(source="831.png")]
      private static const bitmapError:Class;
      
      private static const errorBd:BitmapData = new bitmapError().bitmapData;
      
      public static const SYSTEM_TYPE_SMS:String = "sms";
      
      public static const SYSTEM_TYPE_QIWI:String = "mk";
      
      public static const SYSTEM_TYPE_YANDEX:String = "yandex";
      
      public static const SYSTEM_TYPE_VISA:String = "bank_card";
      
      public static const SYSTEM_TYPE_WEBMONEY:String = "wm";
      
      public static const SYSTEM_TYPE_EASYPAY:String = "easypay";
      
      public static const SYSTEM_TYPE_PAYPAL:String = "paypal";
      
      public static const SYSTEM_TYPE_TERMINAL:String = "terminal";
      
      public static var SYSTEM_TYPE_PREPAID:String = "prepaid";
      
      public static const SYSTEM_TYPE_WALLIE:String = "wallie";
      
      public static const SYSTEM_TYPE_PAYSAFE:String = "paysafecard";
      
      public static const SYSTEM_TYPE_RIXTY:String = "rixty";
      
      public static const SYSTEM_TYPE_CASHU:String = "cashu";
      
      public static const SYSTEM_TYPE_CHRONOPAY:String = "chronopay";
      
      public static const SYSTEM_TYPE_LIQPAY:String = "liqpay";
      
      public static const SYSTEM_TYPE_ALIPAY:String = "alipay";
       
      
      private var localeService:ILocaleService;
      
      private var storage:SharedObject;
      
      private var panelModel:IPanel;
      
      private var dialogsLayer:DisplayObjectContainer;
      
      private var window:TankWindow;
      
      private var windowSize:Point;
      
      private const windowMargin:int = 11;
      
      private const spaceModule:int = 7;
      
      private const buttonSize:Point = new Point(155,50);
      
      private var numbers:Array;
      
      private var systemTypesNum:int;
      
      private var systemTypeButtonsSmall:Array;
      
      private var systemTypeButtons:Array;
      
      private var systemTypeButtonNames:Array;
      
      private var systemTypeButtonsInner:TankWindowInner;
      
      private var systemTypeButtonsSpace:int = 2;
      
      private var bigButtonsContainer:Sprite;
      
      private var smallButtonsContainer:Sprite;
      
      private var systemTypeTitle:Label;
      
      private var systemTypeDescriptions:Array;
      
      private var systemTypeDescription:Label;
      
      private var systemTypeDescriptionInner:TankWindowInner;
      
      private var systemTypeDescriptionInnerWidth:int = 200;
      
      private var errorInner:TankWindowInner;
      
      private var errorButton:DefaultButton;
      
      private var errorIcon:Bitmap;
      
      private var errorLabel:Label;
      
      private var colomn2x:int;
      
      private var colomn3x:int;
      
      private var tabContainers:Array;
      
      private var currentTabIndex:int = 0;
      
      private var exchangeGroup:ExchangeGroup;
      
      private var rates:Array;
      
      private var crystals:int;
      
      private var WMCombo:TankCombo;
      
      private var proceedButton:DefaultButton;
      
      private var crystalsPic:Bitmap;
      
      private var header:Label;
      
      private var headerInner:TankWindowInner;
      
      private var scrollPane:ScrollPane;
      
      private var scrollContainer:Sprite;
      
      private var smsBlock:SMSblock;
      
      public var terminalCountriesCombo:TankCombo;
      
      private var wallieButton:PaymentButton;
      
      private var paysafeButton:PaymentButton;
      
      private var rixtyButton:PaymentButton;
      
      private var cashuButton:PaymentButton;
      
      private var chronopayButton:PaymentButton;
      
      private var liqpayButton:PaymentButton;
      
      private var chronopaySelected:Boolean;
      
      private var prepayCardSelectedIndex:int;
      
      private var INDEX_SMS:int;
      
      private var INDEX_QIWI:int;
      
      private var INDEX_YANDEX:int;
      
      private var INDEX_VISA:int;
      
      private var INDEX_WEBMONEY:int;
      
      private var INDEX_EASYPAY:int;
      
      private var INDEX_WEBCREDS:int;
      
      private var INDEX_PAYPAL:int;
      
      private var INDEX_TERMINAL:int;
      
      private var INDEX_PREPAID:int;
      
      private var INDEX_WALLIE:int;
      
      private var INDEX_PAYSAFE:int;
      
      private var INDEX_RIXTY:int;
      
      private var INDEX_CASHU:int;
      
      private var INDEX_ALIPAY:int;
      
      private var buttonTypes:Array;
      
      private var bugReportWindow:PaymentBugReportWindow;
      
      private var visaRateValue:Number;
      
      private var visaCurrency:String;
      
      private var prepaidRate:Number = 0;
      
      public function PaymentWindow()
      {
         super();
         throw new Error("");
      }
      
      private function confScroll() : void
      {
         this.scrollPane.setStyle("downArrowUpSkin",ScrollArrowDownGreen);
         this.scrollPane.setStyle("downArrowDownSkin",ScrollArrowDownGreen);
         this.scrollPane.setStyle("downArrowOverSkin",ScrollArrowDownGreen);
         this.scrollPane.setStyle("downArrowDisabledSkin",ScrollArrowDownGreen);
         this.scrollPane.setStyle("upArrowUpSkin",ScrollArrowUpGreen);
         this.scrollPane.setStyle("upArrowDownSkin",ScrollArrowUpGreen);
         this.scrollPane.setStyle("upArrowOverSkin",ScrollArrowUpGreen);
         this.scrollPane.setStyle("upArrowDisabledSkin",ScrollArrowUpGreen);
         this.scrollPane.setStyle("trackUpSkin",ScrollTrackGreen);
         this.scrollPane.setStyle("trackDownSkin",ScrollTrackGreen);
         this.scrollPane.setStyle("trackOverSkin",ScrollTrackGreen);
         this.scrollPane.setStyle("trackDisabledSkin",ScrollTrackGreen);
         this.scrollPane.setStyle("thumbUpSkin",ScrollThumbSkinGreen);
         this.scrollPane.setStyle("thumbDownSkin",ScrollThumbSkinGreen);
         this.scrollPane.setStyle("thumbOverSkin",ScrollThumbSkinGreen);
         this.scrollPane.setStyle("thumbDisabledSkin",ScrollThumbSkinGreen);
      }
      
      public function resize(width:int, height:int) : void
      {
         var b:PaymentButton = null;
         var smallButton:DefaultButton = null;
         Main.writeVarsToConsoleChannel("PAYMENT WINDOW","resize");
         this.scrollPane.update();
         this.windowSize.x = width;
         this.windowSize.y = height;
         this.window.width = width;
         this.window.height = height;
         if(this.localeService.language != "cn")
         {
            this.errorInner.y = height - this.windowMargin - this.errorInner.height;
            this.errorInner.width = width - this.windowMargin * 2 - this.errorInner.x;
            this.errorIcon.y = this.errorInner.y + int((this.errorInner.height - this.errorIcon.height) * 0.5);
            this.errorLabel.y = this.errorInner.y + int((this.errorInner.height - this.errorLabel.height) * 0.5);
            this.errorButton.y = this.errorInner.y + this.spaceModule;
            this.errorButton.x = width - 125;
            this.errorLabel.width = this.errorButton.x - this.errorLabel.x - this.windowMargin;
         }
         this.headerInner.width = width - this.windowMargin * 2;
         this.headerInner.height = this.crystalsPic.height;
         this.header.width = width - this.header.x - this.windowMargin * 2;
         this.crystalsPic.y = this.headerInner.y;
         this.header.y = this.crystalsPic.y + Math.round((this.crystalsPic.height - this.header.textHeight) * 0.5);
         var row2y:int = this.headerInner.y + this.headerInner.height + this.spaceModule - 2;
         this.systemTypeButtonsInner.y = row2y;
         this.systemTypeButtonsInner.height = height - row2y - this.windowMargin;
         this.bigButtonsContainer.y = row2y + this.spaceModule + 1;
         this.smallButtonsContainer.y = this.bigButtonsContainer.y;
         for(var i:int = 0; i < this.systemTypesNum; i++)
         {
            b = this.systemTypeButtons[i];
            b.y = i * (b.height + this.systemTypeButtonsSpace);
            smallButton = this.systemTypeButtonsSmall[i];
            smallButton.y = i * (smallButton.height + this.systemTypeButtonsSpace);
         }
         if(height - (this.bigButtonsContainer.y + this.systemTypesNum * (this.systemTypeButtons[0] as PaymentButton).height + (this.systemTypesNum - 1) * this.systemTypeButtonsSpace + this.spaceModule + 1 + this.windowMargin) >= 0)
         {
            this.bigButtonsContainer.visible = true;
            this.smallButtonsContainer.visible = false;
         }
         else
         {
            this.bigButtonsContainer.visible = false;
            this.smallButtonsContainer.visible = true;
         }
         this.systemTypeTitle.y = this.systemTypeButtonsInner.y - 5;
         this.systemTypeDescriptionInner.y = row2y + this.spaceModule * 3;
         this.systemTypeDescriptionInner.width = width - this.windowMargin * 2 - this.systemTypeDescriptionInner.x;
         var descriptionHeight:int = int((height - this.systemTypeDescriptionInner.y - this.windowMargin * 2) * 0.4) - (this.localeService.language != "cn" ? this.errorInner.height : 0) - this.windowMargin;
         this.systemTypeDescriptionInner.height = descriptionHeight;
         this.systemTypeDescription.width = this.systemTypeDescriptionInner.width - this.spaceModule * 3;
         this.colomn3x = int(this.systemTypeDescriptionInner.width * 0.25);
         var colomn3width:int = int(this.systemTypeDescriptionInner.width * 0.5);
         this.scrollPane.x = this.systemTypeDescriptionInner.x;
         this.scrollPane.y = this.systemTypeDescriptionInner.y + this.spaceModule;
         this.scrollPane.setSize(this.systemTypeDescriptionInner.width,descriptionHeight - this.spaceModule * 2);
         this.scrollPane.update();
         this.tabContainers[this.currentTabIndex].x = this.colomn2x + this.windowMargin;
         this.tabContainers[this.currentTabIndex].y = this.systemTypeDescriptionInner.y + descriptionHeight + this.spaceModule;
         if(this.currentTabIndex == this.INDEX_SMS && this.localeService.language != "cn")
         {
            this.smsBlock.resize(this.systemTypeDescriptionInner.width,height - this.tabContainers[this.currentTabIndex].y - this.windowMargin * 2 - this.errorInner.height);
         }
         else
         {
            if(this.currentTabIndex == this.INDEX_WEBMONEY && this.localeService.language != "cn")
            {
               this.WMCombo.x = this.colomn3x;
               this.WMCombo.width = colomn3width;
               this.exchangeGroup.y = this.spaceModule * 5;
            }
            else if(this.currentTabIndex == this.INDEX_TERMINAL && this.localeService.language != "cn")
            {
               this.terminalCountriesCombo.x = this.colomn3x + 4;
               this.terminalCountriesCombo.width = colomn3width - 8;
               this.exchangeGroup.y = this.spaceModule * 5;
            }
            else
            {
               this.exchangeGroup.y = 0;
            }
            this.exchangeGroup.x = this.currentTabIndex == this.INDEX_VISA || this.currentTabIndex == this.INDEX_PREPAID ? Number(Number(this.chronopayButton.width + this.spaceModule)) : Number(Number(this.colomn3x));
            this.exchangeGroup.resize(colomn3width);
            this.proceedButton.x = this.currentTabIndex == this.INDEX_VISA || this.currentTabIndex == this.INDEX_PREPAID ? Number(Number(this.chronopayButton.width + this.spaceModule + 4)) : Number(Number(this.colomn3x + 4));
            this.proceedButton.y = !this.exchangeGroup.visible ? Number(Number(this.spaceModule * 5 + 3)) : Number(Number(this.exchangeGroup.y + this.exchangeGroup.height + this.spaceModule));
            this.proceedButton.width = colomn3width - 8;
         }
      }
      
      public function setInitData(countries:Array, rates:Array, accountId:String, projectId:int, formId:String) : void
      {
      }
      
      public function setOperators(operators:Array) : void
      {
      }
      
      public function setNumbers(numbers:Array) : void
      {
      }
      
      private function sortNumbersByCost(n1:SMSNumber, n2:SMSNumber) : int
      {
         return 0;
      }
      
      public function get selectedCountry() : String
      {
         return this.smsBlock.countriesCombo.selectedItem["id"] as String;
      }
      
      public function get selectedOperator() : int
      {
         return int(this.smsBlock.operatorsCombo.selectedItem["id"] as int);
      }
      
      private function lockProceedButtons() : void
      {
         this.proceedButton.enable = false;
      }
      
      private function unlockProceedButtons() : void
      {
         this.proceedButton.enable = true;
      }
      
      private function onSystemSelect(e:MouseEvent) : void
      {
         var index:int = 0;
         Main.writeVarsToConsoleChannel("PAYMENT","onSystemSelect");
         if(this.bigButtonsContainer.visible)
         {
            Main.writeVarsToConsoleChannel("PAYMENT","   type: %1",(e.currentTarget as PaymentButton).type);
            index = this.systemTypeButtons.indexOf(e.currentTarget);
         }
         else
         {
            index = this.systemTypeButtonsSmall.indexOf(e.currentTarget);
         }
         this.setSystemIndex(index);
      }
      
      private function setSystemIndex(index:int) : void
      {
         Main.writeVarsToConsoleChannel("PAYMENT","setSystemIndex: %1",index);
         (this.tabContainers[this.currentTabIndex] as Sprite).visible = false;
         var button:PaymentButton = this.systemTypeButtons[this.currentTabIndex];
         button.enable = true;
         var smallButton:DefaultButton = this.systemTypeButtonsSmall[this.currentTabIndex];
         smallButton.enable = true;
         button = this.systemTypeButtons[index];
         button.enable = false;
         smallButton = this.systemTypeButtonsSmall[index];
         smallButton.enable = false;
         this.currentTabIndex = index;
         (this.tabContainers[this.currentTabIndex] as Sprite).visible = true;
         this.systemTypeTitle.text = this.systemTypeButtonNames[index] as String;
         var helpURL:String = this.localeService.language == "ru" ? "<font color=\'#00ff0b\'><u><a href=\'http://forum.tankionline.com/posts/list/12852.page\' target=\'_blank\'>Инструкция по покупке кристаллов</a></u></font>" : (this.localeService.language == "en" ? "<font color=\'#00ff0b\'><u><a href=\'http://forum.tankionline.com/posts/list/1171.page#101800\' target=\'_blank\'>Crystal purchase instruction</a></u></font>" : "<font color=\'#00ff0b\'><u><a href=\'http://forum.3dtank.com/posts/list/7.page\' target=\'_blank\'>水晶购买指南</a></u></font>");
         this.systemTypeDescription.htmlText = (this.systemTypeDescriptions[index] as String) + "\n\n" + helpURL;
         this.scrollPane.update();
         if(this.currentTabIndex != this.INDEX_SMS)
         {
            if(this.exchangeGroup.inputValue != 0)
            {
               this.onExchangeChange();
            }
            this.WMCombo.visible = this.currentTabIndex == this.INDEX_WEBMONEY;
            this.terminalCountriesCombo.visible = this.currentTabIndex == this.INDEX_TERMINAL;
            this.exchangeGroup.visible = !(this.currentTabIndex == this.INDEX_YANDEX || this.currentTabIndex == this.INDEX_WEBMONEY || this.currentTabIndex == this.INDEX_TERMINAL);
            if(this.currentTabIndex == this.INDEX_YANDEX || this.currentTabIndex == this.INDEX_WEBMONEY)
            {
               this.proceedButton.enable = true;
            }
            else
            {
               this.proceedButton.enable = this.currentTabIndex == this.INDEX_TERMINAL && this.terminalCountriesCombo.selectedItem != null || this.currentTabIndex != this.INDEX_TERMINAL && this.exchangeGroup.inputValue != 0;
            }
         }
         this.chronopayButton.visible = this.liqpayButton.visible = this.currentTabIndex == this.INDEX_VISA;
         this.wallieButton.visible = this.paysafeButton.visible = this.rixtyButton.visible = this.currentTabIndex == this.INDEX_PREPAID;
         this.cashuButton.visible = this.currentTabIndex == this.INDEX_PREPAID && SYSTEM_TYPE_PREPAID == "prepaiden";
         this.resize(this.windowSize.x,this.windowSize.y);
         this.storage.data.paymentSystemType = this.buttonTypes[this.currentTabIndex];
      }
      
      private function onCountrySelect(e:Event) : void
      {
         if(this.smsBlock.countriesCombo.selectedItem != null && this.smsBlock.countriesCombo.selectedItem != "")
         {
            this.storage.data.userCountryName = this.smsBlock.countriesCombo.selectedItem["gameName"];
            dispatchEvent(new PaymentWindowEvent(PaymentWindowEvent.SELECT_COUNTRY));
         }
      }
      
      private function onOperatorSelect(e:Event) : void
      {
         if(this.smsBlock.operatorsCombo.selectedItem != null && this.smsBlock.operatorsCombo.selectedItem != "")
         {
            this.storage.data.userOperatorName = this.smsBlock.operatorsCombo.selectedItem["gameName"];
            dispatchEvent(new PaymentWindowEvent(PaymentWindowEvent.SELECT_OPERATOR));
         }
      }
      
      private function onProceedButtonClick(e:MouseEvent) : void
      {
      }
      
      private function onWMComboSelect(e:Event) : void
      {
         this.storage.data.paymentWMType = this.WMCombo.selectedItem["gameName"];
         this.onExchangeChange();
      }
      
      private function onChronopaySelected(e:MouseEvent) : void
      {
      }
      
      private function onLiqpaySelected(e:MouseEvent) : void
      {
      }
      
      private function onPrepaidButtonSelected(e:MouseEvent = null) : void
      {
      }
      
      private function onExchangeChange(e:Event = null) : void
      {
      }
      
      private function onErrorButtonClick(e:MouseEvent) : void
      {
      }
      
      private function alignReportWindow(e:Event = null) : void
      {
         this.bugReportWindow.x = Math.round((Main.stage.stageWidth - this.bugReportWindow.width) * 0.5);
         this.bugReportWindow.y = Math.round((Main.stage.stageHeight - this.bugReportWindow.height) * 0.5);
      }
   }
}
