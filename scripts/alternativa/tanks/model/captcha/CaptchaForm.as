package alternativa.tanks.model.captcha
{
   import alternativa.init.Main;
   import alternativa.osgi.service.locale.ILocaleService;
   import alternativa.tanks.locale.constants.TextConst;
   import controls.Label;
   import controls.TankInput;
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.Sprite;
   import flash.filters.BlurFilter;
   import flash.filters.DropShadowFilter;
   
   public class CaptchaForm extends Sprite
   {
       
      
      private var captchaImage:Bitmap;
      
      private var captchaContainer:Bitmap;
      
      public var refreshBtn:CaptchaRefreshButton;
      
      private var label:Label;
      
      public var input:TankInput;
      
      private var _space:int = 10;
      
      private var localeService:ILocaleService;
      
      public function CaptchaForm()
      {
         super();
         this.localeService = ILocaleService(Main.osgi.getService(ILocaleService));
         this.input = new TankInput();
         this.input.tabIndex = 5;
         this.input.restrict = ".0-9a-zA-z_\\-";
         addChild(this.input);
         this.label = new Label();
         this.label.multiline = true;
         this.label.wordWrap = true;
         this.label.text = this.localeService.getText(TextConst.CHECK_PASSWORD_FORM_CAPTCHA);
         this.label.y = -8;
         addChild(this.label);
         this.captchaContainer = new Bitmap(new BitmapData(285,50,true,0));
         this.captchaContainer.filters = [new BlurFilter(2,2),new DropShadowFilter(0,45,0,1,4,4,2)];
         addChild(this.captchaContainer);
         this.refreshBtn = new CaptchaRefreshButton();
         this.refreshBtn.useHandCursor = true;
         this.refreshBtn.buttonMode = true;
         addChild(this.refreshBtn);
         if(stage != null)
         {
            stage.focus = this.input.textField;
         }
         this.width = 275;
      }
      
      override public function get height() : Number
      {
         return this.input.y + this.input.height;
      }
      
      override public function set width(value:Number) : void
      {
         this.label.width = value - this.label.x;
         this.captchaContainer.width = value;
         this.input.width = value - 4;
         this.refreshBtn.x = this.captchaContainer.x + this.captchaContainer.width - this.refreshBtn.width - 11;
         this.captchaContainer.y = this.label.y + this.label.height + this._space;
         this.input.y = this.captchaContainer.y + this.captchaContainer.height + this._space;
         this.refreshBtn.y = this.captchaContainer.y + this._space + 5;
      }
      
      public function moveY(value:Number) : void
      {
         this.label.y += value;
         this.input.y += value;
         this.refreshBtn.y += value;
         this.captchaContainer.y += value;
      }
      
      public function captcha(param1:Bitmap) : void
      {
         this.captchaImage = param1;
         this.captchaContainer.bitmapData = this.captchaImage.bitmapData;
         this.input.value = "";
      }
      
      public function setEnabled(param1:Boolean) : void
      {
         this.input.visible = param1;
         this.refreshBtn.doubleClickEnabled = param1;
         this.refreshBtn.mouseEnabled = param1;
      }
   }
}
