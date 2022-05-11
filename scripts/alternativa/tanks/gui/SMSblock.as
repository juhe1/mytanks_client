package alternativa.tanks.gui
{
   import alternativa.init.Main;
   import alternativa.osgi.service.locale.ILocaleService;
   import alternativa.tanks.locale.constants.TextConst;
   import controls.Label;
   import controls.TankCombo;
   import controls.TankWindowInner;
   import flash.display.Bitmap;
   import flash.display.Sprite;
   import flash.geom.Point;
   import forms.payment.PaymentList;
   import utils.TextUtils;
   
   public class SMSblock extends Sprite
   {
       
      
      private const windowMargin:int = 11;
      
      private const spaceModule:int = 7;
      
      public var countriesCombo:TankCombo;
      
      public var operatorsCombo:TankCombo;
      
      private var comboWidth:int = 200;
      
      private var comboLabelWidth:int = 50;
      
      public var smsTextLabel:Label;
      
      private var smsText:Label;
      
      private var smsTextBmp:Bitmap;
      
      public var numbersList:PaymentList;
      
      private var numbersListInner:TankWindowInner;
      
      private var smsTextInner:TankWindowInner;
      
      private var oneText:Boolean;
      
      private var size:Point;
      
      public function SMSblock()
      {
         super();
         var localeService:ILocaleService = ILocaleService(Main.osgi.getService(ILocaleService));
         this.size = new Point();
         this.numbersListInner = new TankWindowInner(0,0,TankWindowInner.GREEN);
         this.numbersListInner.showBlink = true;
         addChild(this.numbersListInner);
         this.smsTextInner = new TankWindowInner(0,0,TankWindowInner.GREEN);
         this.smsTextInner.showBlink = true;
         addChild(this.smsTextInner);
         this.numbersList = new PaymentList();
         addChild(this.numbersList);
         this.smsTextLabel = new Label();
         this.smsTextLabel.text = localeService.getText(TextConst.PAYMENT_SMSTEXT_HEADER_LABEL_TEXT);
         addChild(this.smsTextLabel);
         this.smsText = new Label();
         this.smsTextBmp = new Bitmap();
         addChild(this.smsTextBmp);
         this.operatorsCombo = new TankCombo();
         addChild(this.operatorsCombo);
         this.operatorsCombo.label = localeService.getText(TextConst.PAYMENT_OPERATORS_LABEL_TEXT);
         this.countriesCombo = new TankCombo();
         addChild(this.countriesCombo);
         this.countriesCombo.label = localeService.getText(TextConst.PAYMENT_COUNTRIES_LABEL_TEXT);
         this.numbersList.withSMSText = false;
         this.smsTextInner.visible = false;
         this.smsTextLabel.visible = false;
         this.smsTextBmp.visible = false;
      }
      
      public function resize(width:int, height:int) : void
      {
         var newSize:int = 0;
         this.size.x = width;
         this.size.y = height;
         this.countriesCombo.width = int(width * 0.5) - this.comboLabelWidth - this.windowMargin;
         this.operatorsCombo.width = int(width * 0.5) - this.comboLabelWidth - this.windowMargin;
         this.countriesCombo.x = this.comboLabelWidth;
         this.operatorsCombo.x = int(width * 0.5) + this.comboLabelWidth + this.windowMargin;
         this.graphics.drawRect(this.comboLabelWidth,0,int(width * 0.5) - this.comboLabelWidth - this.windowMargin,this.countriesCombo.height);
         this.graphics.drawRect(int(width * 0.5) + this.comboLabelWidth + this.windowMargin,0,int(width * 0.5) - this.comboLabelWidth - this.windowMargin,this.operatorsCombo.height);
         if(this.oneText)
         {
            this.smsTextInner.width = width - this.comboLabelWidth;
            this.smsTextInner.height = 50;
            this.smsTextInner.x = this.comboLabelWidth;
            this.smsTextInner.y = this.spaceModule * 5;
            if(this.smsText.text != null && this.smsText.text != "")
            {
               newSize = Math.min(12 + int((this.size.x - 447) * 0.03) + int((28 - this.smsText.text.length) * 0.3),20);
               this.smsText.size = newSize;
               this.smsTextBmp.bitmapData = TextUtils.getTextInCells(this.smsText,11 * (newSize / 12),16 * (newSize / 12));
               this.smsTextBmp.x = this.smsTextInner.x + this.spaceModule * 2;
               this.smsTextBmp.y = this.smsTextInner.y + (this.smsTextInner.height - this.smsTextBmp.height >> 1);
            }
            this.smsTextLabel.x = this.smsTextInner.x - this.spaceModule - this.smsTextLabel.width;
            this.smsTextLabel.y = this.smsTextInner.y + (this.smsTextInner.height - this.smsTextLabel.height >> 1);
            this.numbersListInner.y = this.smsTextInner.y + this.smsTextInner.height + this.spaceModule;
         }
         else
         {
            this.numbersListInner.y = this.spaceModule * 5;
         }
         this.numbersListInner.width = width;
         this.numbersListInner.height = height - this.numbersListInner.y;
         this.numbersList.x = 5;
         this.numbersList.y = this.numbersListInner.y + 5;
         this.numbersList.width = width - 10;
         this.numbersList.height = height - this.numbersListInner.y - 10;
      }
      
      public function set smsString(value:String) : void
      {
         var newSize:int = 0;
         if(value != null && value != "")
         {
            this.smsTextBmp.visible = true;
            this.smsText.text = value;
            newSize = Math.min(12 + int((this.size.x - 447) * 0.03) + int((28 - this.smsText.text.length) * 0.3),20);
            this.smsText.size = newSize;
            this.smsTextBmp.bitmapData = TextUtils.getTextInCells(this.smsText,11 * (newSize / 12),16 * (newSize / 12));
            this.smsTextBmp.x = this.smsTextInner.x + this.spaceModule * 2;
            this.smsTextBmp.y = this.smsTextInner.y + (this.smsTextInner.height - this.smsTextBmp.height >> 1);
         }
         else
         {
            this.smsTextBmp.visible = false;
         }
      }
      
      public function set oneTextForAllNumbers(value:Boolean) : void
      {
         this.oneText = value;
         this.numbersList.withSMSText = !value;
         this.smsTextInner.visible = value;
         this.smsTextLabel.visible = value;
         this.smsTextBmp.visible = value;
         this.resize(this.size.x,this.size.y);
      }
   }
}
