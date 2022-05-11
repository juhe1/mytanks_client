package forms
{
   import alternativa.init.Main;
   import alternativa.osgi.service.locale.ILocaleService;
   import alternativa.tanks.locale.constants.TextConst;
   import alternativa.tanks.model.captcha.CaptchaForm;
   import controls.DefaultButton;
   import controls.Label;
   import controls.TankInput;
   import controls.TankWindow;
   import controls.TankWindowHeader;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.FocusEvent;
   import flash.text.TextFormatAlign;
   
   public class RestoreEmail extends Sprite
   {
       
      
      public var cancelButton:DefaultButton;
      
      public var recoverButton:DefaultButton;
      
      public var email:TankInput;
      
      public var captchaView:CaptchaForm;
      
      private var label:Label;
      
      private var bg:TankWindow;
      
      public function RestoreEmail()
      {
         super();
         var localeService:ILocaleService = Main.osgi.getService(ILocaleService) as ILocaleService;
         this.bg = new TankWindow(280,185);
         this.bg.headerLang = localeService.getText(TextConst.GUI_LANG);
         this.bg.header = TankWindowHeader.RECOVER;
         this.label = new Label();
         addChild(this.bg);
         addChild(this.label);
         this.label.multiline = true;
         this.label.size = 11;
         this.label.align = TextFormatAlign.CENTER;
         this.label.text = localeService.getText(TextConst.ACCOUNT_RECOVERY_FORM_HELP_LABEL_TEXT);
         this.label.x = int(140 - this.label.width / 2);
         this.label.y = 25;
         this.cancelButton = new DefaultButton();
         this.recoverButton = new DefaultButton();
         this.email = new TankInput();
         addChild(this.cancelButton);
         addChild(this.recoverButton);
         addChild(this.email);
         this.cancelButton.x = 153;
         this.cancelButton.y = 115;
         this.recoverButton.x = 30;
         this.recoverButton.y = 115;
         this.email.width = 220;
         this.email.x = 30;
         this.email.y = 70;
         this.cancelButton.label = localeService.getText(TextConst.ACCOUNT_RECOVERY_FORM_BUTTON_CANCEL_TEXT);
         this.recoverButton.label = localeService.getText(TextConst.ACCOUNT_RECOVERY_FORM_BUTTON_RECOVER_TEXT);
         this.x = 61;
         this.email.addEventListener(FocusEvent.FOCUS_IN,this.restoreInput);
      }
      
      private function restoreInput(e:Event) : void
      {
         this.email.validValue = true;
      }
      
      public function captcha(value:Boolean) : void
      {
         if(value && this.captchaView == null)
         {
            this.label.size = 12;
            this.captchaView = new CaptchaForm();
            addChild(this.captchaView);
            this.captchaView.width -= 40;
            this.bg.height += this.captchaView.height + 40;
            this.bg.width += 18;
            this.email.width = this.captchaView.width - 15;
            this.captchaView.x = this.email.x;
            this.captchaView.y = this.email.y + this.email.height + 20;
            this.cancelButton.x = 175;
            this.cancelButton.y = 295;
            this.recoverButton.x = 30;
            this.recoverButton.y = 295;
         }
      }
   }
}
