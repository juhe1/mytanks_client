package forms
{
   import alternativa.init.Main;
   import alternativa.osgi.service.locale.ILocaleService;
   import alternativa.tanks.locale.constants.TextConst;
   import alternativa.tanks.model.captcha.CaptchaForm;
   import controls.DefaultButton;
   import controls.Label;
   import controls.TankCheckBox;
   import controls.TankInput;
   import controls.TankWindow;
   import controls.TankWindowHeader;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.filters.GlowFilter;
   
   public class CheckPassword extends Sprite
   {
       
      
      public var callSign:TankInput;
      
      public var restoreLink:Label;
      
      public var password:TankInput;
      
      public var checkRemember:TankCheckBox;
      
      public var playButton:DefaultButton;
      
      public var registerButton:DefaultButton;
      
      public var captchaView:CaptchaForm;
      
      private var bg:TankWindow;
      
      private var label:Label;
      
      private var p:Number = 0.5;
      
      public function CheckPassword()
      {
         this.bg = new TankWindow(400,187);
         super();
         var localeService:ILocaleService = Main.osgi.getService(ILocaleService) as ILocaleService;
         addChild(this.bg);
         this.bg.headerLang = localeService.getText(TextConst.GUI_LANG);
         this.bg.header = TankWindowHeader.LOGIN;
         this.restoreLink = new Label();
         this.restoreLink.x = 25;
         this.restoreLink.y = 25;
         this.restoreLink.htmlText = localeService.getText(TextConst.CHECK_PASSWORD_FORM_RESTORE_LINK_TEXT);
         addChild(this.restoreLink);
         this.registerButton = new DefaultButton();
         this.registerButton.label = localeService.getText(TextConst.CHECK_PASSWORD_FORM_BUTTON_REGISTRATION_TEXT);
         this.registerButton.x = 280;
         this.registerButton.y = 20;
         addChild(this.registerButton);
         this.callSign = new TankInput();
         this.callSign.width = 295;
         this.callSign.x = 85;
         this.callSign.y = 65;
         this.callSign.label = localeService.getText(TextConst.CHECK_PASSWORD_FORM_CALLSIGN);
         this.callSign.tabIndex = 0;
         this.callSign.restrict = ".0-9a-zA-z_\\-";
         this.callSign.maxChars = 20;
         addChild(this.callSign);
         this.password = new TankInput();
         this.password.width = 295;
         this.password.x = 85;
         this.password.y = 97;
         this.password.label = localeService.getText(TextConst.CHECK_PASSWORD_FORM_PASSWORD);
         this.password.hidden = true;
         this.password.tabIndex = 1;
         addChild(this.password);
         this.checkRemember = new TankCheckBox();
         this.checkRemember.x = 147;
         this.checkRemember.y = 140;
         addChild(this.checkRemember);
         this.label = new Label();
         this.label.x = 175;
         this.label.y = 145;
         this.label.text = localeService.getText(TextConst.CHECK_PASSWORD_FORM_REMEMBER);
         addChild(this.label);
         var test:GlowFilter = new GlowFilter();
         this.playButton = new DefaultButton();
         this.playButton.label = localeService.getText(TextConst.CHECK_PASSWORD_FORM_PLAY_BUTTON);
         this.playButton.x = 280;
         this.playButton.y = 140;
         addChild(this.playButton);
      }
      
      private function onResize(e:Event) : void
      {
         stage.removeEventListener(Event.RESIZE,this.onResize);
      }
      
      public function captcha(value:Boolean) : void
      {
         if(value && this.captchaView == null)
         {
            this.captchaView = new CaptchaForm();
            addChild(this.captchaView);
            this.bg.height += this.captchaView.height + 10;
            this.captchaView.x = this.password.x;
            this.captchaView.y = this.password.y + this.password.height + 15;
            this.checkRemember.y = this.captchaView.y + this.captchaView.height + 15;
            this.checkRemember.x -= 20;
            this.playButton.y = this.checkRemember.y;
            this.playButton.x = 260;
            this.label.y = this.checkRemember.y + 4;
            this.label.x -= 20;
            this.callSign.width = 270;
            this.password.width = 270;
            this.bg.height += 7;
            this.bg.width -= 10;
            this.y -= this.captchaView.height / 2;
            this.p = this.y / stage.height;
            this.onResize(null);
            stage.addEventListener(Event.RESIZE,this.onResize);
         }
      }
   }
}
