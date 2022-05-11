package forms
{
   import alternativa.init.Main;
   import alternativa.osgi.service.locale.ILocaleService;
   import alternativa.tanks.locale.constants.TextConst;
   import alternativa.tanks.model.captcha.CaptchaForm;
   import assets.icons.InputCheckIcon;
   import controls.DefaultButton;
   import controls.Label;
   import controls.TankCheckBox;
   import controls.TankInput;
   import controls.TankWindow;
   import controls.TankWindowHeader;
   import controls.TankWindowInner;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.FocusEvent;
   import flash.events.MouseEvent;
   
   public class RegisterForm extends Sprite
   {
      
      public static const CALLSIGN_STATE_OFF:int = 0;
      
      public static const CALLSIGN_STATE_PROGRESS:int = 1;
      
      public static const CALLSIGN_STATE_VALID:int = 2;
      
      public static const CALLSIGN_STATE_INVALID:int = 3;
       
      
      public var callSign:TankInput;
      
      public var callSignCheckIcon:InputCheckIcon;
      
      public var pass1:TankInput;
      
      public var pass2:TankInput;
      
      public var email:TankInput;
      
      public var chekArgree:TankCheckBox;
      
      public var chekNews:TankCheckBox;
      
      public var chekRemember:TankCheckBox;
      
      public var playButton:DefaultButton;
      
      public var rulesButton:Label;
      
      public var loginButton:DefaultButton;
      
      public var realName:TankInput;
      
      public var idNumber:TankInput;
      
      public var confirm:Label;
      
      public var captchaView:CaptchaForm;
      
      private var bg:TankWindow;
      
      private var label:Label;
      
      private var p:Number = 0.5;
      
      public function RegisterForm(antiAddictionEnabled:Boolean)
      {
         var localeService:ILocaleService = null;
         var inner:TankWindowInner = null;
         var antiAddictionInner:TankWindowInner = null;
         var antiAddictionTitle:Label = null;
         super();
         localeService = Main.osgi.getService(ILocaleService) as ILocaleService;
         var title:Label = new Label();
         this.bg = new TankWindow(400,!!antiAddictionEnabled ? int(585) : int(300));
         inner = new TankWindowInner(350,38);
         this.callSign = new TankInput();
         this.callSignCheckIcon = new InputCheckIcon();
         this.pass1 = new TankInput();
         this.pass2 = new TankInput();
         this.email = new TankInput();
         this.chekArgree = new TankCheckBox();
         this.chekNews = new TankCheckBox();
         this.chekRemember = new TankCheckBox();
         this.playButton = new DefaultButton();
         this.loginButton = new DefaultButton();
         this.confirm = new Label();
         addChild(this.bg);
         this.bg.headerLang = localeService.getText(TextConst.GUI_LANG);
         this.bg.header = TankWindowHeader.REGISTER;
         addChild(inner);
         addChild(title);
         addChild(this.callSign);
         addChild(this.callSignCheckIcon);
         addChild(this.pass1);
         addChild(this.pass2);
         addChild(this.chekArgree);
         addChild(this.chekNews);
         addChild(this.chekRemember);
         addChild(this.playButton);
         addChild(this.loginButton);
         addChild(this.confirm);
         title.x = 20;
         title.y = 20;
         title.text = localeService.getText(TextConst.REGISTER_FORM_HEADER_TEXT);
         this.loginButton.x = 270;
         this.loginButton.y = 20;
         this.loginButton.width = 112;
         this.loginButton.label = localeService.getText(TextConst.REGISTER_FORM_BUTTON_LOGIN_TEXT);
         this.callSign.x = 147;
         this.callSign.y = 65;
         this.callSign.maxChars = 20;
         this.callSign.tabIndex = 0;
         this.callSign.restrict = ".0-9a-zA-z_\\-";
         this.callSign.label = localeService.getText(TextConst.REGISTER_FORM_CALLSIGN_INPUT_LABEL_TEXT);
         this.callSign.validValue = true;
         this.callSignCheckIcon.x = 356 - this.callSignCheckIcon.width;
         this.callSignCheckIcon.y = 70;
         this.callSignState = CALLSIGN_STATE_OFF;
         this.pass1.x = 147;
         this.pass1.y = 97;
         this.pass1.label = localeService.getText(TextConst.REGISTER_FORM_PASSWORD_INPUT_LABEL_TEXT);
         this.pass1.maxChars = 46;
         this.pass1.hidden = true;
         this.pass1.validValue = true;
         this.pass1.tabIndex = 1;
         this.pass2.x = 147;
         this.pass2.y = 129;
         this.pass2.label = localeService.getText(TextConst.REGISTER_FORM_REPEAT_PASSWORD_INPUT_LABEL_TEXT);
         this.pass2.maxChars = 46;
         this.pass2.hidden = true;
         this.pass2.validValue = true;
         this.pass2.tabIndex = 2;
         this.label = new Label();
         this.label.x = 30;
         this.label.y = 164;
         this.label.multiline = true;
         this.label.text = localeService.getText(TextConst.REGISTER_FORM_EMAIL_NOTE_TEXT);
         this.email.x = 147;
         this.email.y = 183;
         this.email.label = localeService.getText(TextConst.REGISTER_FORM_EMAIL_LABEL_TEXT);
         this.email.tabIndex = 3;
         this.confirm.visible = false;
         this.confirm.tabEnabled = false;
         this.confirm.x = 30;
         this.confirm.y = 215 - 60;
         this.confirm.size = 11;
         this.confirm.text = localeService.getText(TextConst.REGISTER_FORM_CONFIRM_TEXT);
         this.chekNews.x = 147;
         this.chekNews.y = 235 - 60;
         this.label = new Label();
         this.label.x = 175;
         this.label.y = 240 - 60;
         this.label.text = localeService.getText(TextConst.REGISTER_FORM_SEND_NEWS_TEXT);
         addChild(this.label);
         inner.x = 25;
         inner.y = !!antiAddictionEnabled ? Number(485) : Number(265 - 60);
         this.chekArgree.x = 107;
         this.chekArgree.y = !!antiAddictionEnabled ? Number(490) : Number(270 - 60);
         this.rulesButton = new Label();
         this.rulesButton.x = 135;
         this.rulesButton.y = !!antiAddictionEnabled ? Number(495) : Number(275 - 60);
         this.rulesButton.htmlText = localeService.getText(TextConst.REGISTER_FORM_AGREEMENT_NOTE_TEXT);
         addChild(this.rulesButton);
         this.label = new Label();
         this.label.x = 175;
         this.label.y = !!antiAddictionEnabled ? Number(540) : Number(320 - 60);
         this.label.text = localeService.getText(TextConst.REGISTER_FORM_REMEMBER_ME_CHECKBOX_LABEL_TEXT);
         addChild(this.label);
         this.chekRemember.x = 147;
         this.chekRemember.y = !!antiAddictionEnabled ? Number(535) : Number(315 - 60);
         this.playButton.x = 280;
         this.playButton.y = !!antiAddictionEnabled ? Number(535) : Number(315 - 60);
         this.playButton.label = "Play";
         this.playButton.label = localeService.getText(TextConst.REGISTER_FORM_BUTTON_PLAY_TEXT);
         this.playButton.enable = false;
         if(antiAddictionEnabled)
         {
            this.realName = new TankInput();
            this.realName.label = "您的真实姓名:";
            this.realName.x = 147;
            this.realName.y = 400;
            this.idNumber = new TankInput();
            this.idNumber.label = "身份证号码:";
            this.idNumber.x = 147;
            this.idNumber.y = 435;
            antiAddictionInner = new TankWindowInner(350,210);
            antiAddictionInner.x = 25;
            antiAddictionInner.y = 265;
            antiAddictionTitle = new Label();
            antiAddictionTitle.text = "按照版署《网络游戏未成年人防沉迷系统》要求 \n" + "\t未满18岁的用户和身份信息不完整的用户将受到防沉迷系统的限制，游戏沉迷时间超过3小时收益减半，超过5小时收益为0 。" + "\n\t已满18岁的用户将等待公安机关的身份验证，验证通过的用户将不受限制，不通过的用户需要重新修改身份信息，否则将纳入防沉迷系统管理。";
            antiAddictionTitle.x = 45;
            antiAddictionTitle.y = 285;
            antiAddictionTitle.wordWrap = true;
            antiAddictionTitle.height = 110;
            antiAddictionTitle.width = 320;
            addChild(antiAddictionInner);
            addChild(antiAddictionTitle);
            addChild(this.realName);
            addChild(this.idNumber);
            this.idNumber.addEventListener(FocusEvent.FOCUS_OUT,this.validateAddictionID);
            this.idNumber.addEventListener(FocusEvent.FOCUS_IN,this.restoreInput);
         }
         this.callSign.addEventListener(FocusEvent.FOCUS_OUT,this.validateCallSign);
         this.callSign.addEventListener(FocusEvent.FOCUS_IN,this.restoreInput);
         this.email.addEventListener(FocusEvent.FOCUS_OUT,this.validateEmail);
         this.email.addEventListener(FocusEvent.FOCUS_IN,this.restoreInput);
         this.pass1.addEventListener(FocusEvent.FOCUS_OUT,this.validatePassword);
         this.pass1.addEventListener(FocusEvent.FOCUS_IN,this.restoreInput);
         this.pass2.addEventListener(FocusEvent.FOCUS_OUT,this.validatePassword);
         this.pass2.addEventListener(FocusEvent.FOCUS_IN,this.restoreInput);
         this.chekArgree.addEventListener(MouseEvent.CLICK,this.switchPlayButton);
      }
      
      public function set callSignState(value:int) : void
      {
         if(value == CALLSIGN_STATE_OFF)
         {
            this.callSignCheckIcon.visible = false;
         }
         else
         {
            this.callSignCheckIcon.visible = true;
            this.callSignCheckIcon.gotoAndStop(value);
         }
      }
      
      private function switchPlayButton(event:Event) : void
      {
         this.playButton.enable = this.chekArgree.checked && this.pass1.validValue && this.pass2.validValue && this.callSign.validValue;
      }
      
      private function validatePassword(event:FocusEvent) : void
      {
         var verySimplePassword:Boolean = this.pass1.value == this.callSign.value || this.pass1.value == "123" || this.pass1.value == "1234" || this.pass1.value == "12345" || this.pass1.value == "qwerty";
         if(this.pass1.value != this.pass2.value || this.pass1.value == "")
         {
            this.pass2.validValue = false;
         }
         else
         {
            this.pass1.validValue = !verySimplePassword;
            this.pass2.validValue = true;
         }
         this.switchPlayButton(event);
      }
      
      private function validateAddictionID(event:FocusEvent) : void
      {
         var l:int = 0;
         if(this.idNumber != null)
         {
            l = this.idNumber.value.length;
            this.idNumber.validValue = l == 18;
         }
      }
      
      private function validateCallSign(event:FocusEvent) : void
      {
         var pattern:RegExp = /^[a-z0-9](([\.\-\w](?!(-|_|\.){2,}))*[a-z0-9])?$/i;
         var result:Array = this.callSign.value.match(pattern);
         this.callSign.validValue = result != null;
         this.switchPlayButton(null);
      }
      
      private function validateEmail(event:FocusEvent) : void
      {
         var pattern:RegExp = /(\w|[_.\-])+@((\w|-)+\.)+\w{2,4}+/;
         var result:Object = pattern.exec(this.email.value);
         if(this.email.value.length > 0)
         {
            this.chekNews.checked = this.email.validValue = this.confirm.visible = result != null;
         }
         else
         {
            this.email.validValue = true;
            this.confirm.visible = false;
         }
      }
      
      public function playButtonActivate() : void
      {
         this.playButton.enable = true;
      }
      
      public function hide() : void
      {
         this.callSign.removeEventListener(FocusEvent.FOCUS_OUT,this.validateCallSign);
         this.callSign.removeEventListener(FocusEvent.FOCUS_IN,this.restoreInput);
         this.email.removeEventListener(FocusEvent.FOCUS_OUT,this.validateEmail);
         this.email.removeEventListener(FocusEvent.FOCUS_IN,this.restoreInput);
         this.pass1.removeEventListener(FocusEvent.FOCUS_OUT,this.validatePassword);
         this.pass1.removeEventListener(FocusEvent.FOCUS_IN,this.restoreInput);
         this.pass2.removeEventListener(FocusEvent.FOCUS_OUT,this.validatePassword);
         this.pass2.removeEventListener(FocusEvent.FOCUS_IN,this.restoreInput);
         stage.removeEventListener(Event.RESIZE,this.onResize);
      }
      
      private function restoreInput(e:Event) : void
      {
         var trgt:TankInput = e.currentTarget as TankInput;
         trgt.validValue = true;
      }
      
      private function onResize(e:Event) : void
      {
         this.y = this.p * stage.height + 0.5 * this.captchaView.height;
      }
      
      public function captcha(value:Boolean) : void
      {
         if(value && this.captchaView == null)
         {
            this.captchaView = new CaptchaForm();
            addChild(this.captchaView);
            this.captchaView.y = this.chekRemember.y;
            this.captchaView.x = 85;
            this.bg.height += this.captchaView.height + 20;
            this.playButton.y += 125;
            this.playButton.x -= 20;
            this.chekRemember.y += 125;
            this.label.y += 125;
            this.callSign.x = this.captchaView.x;
            this.pass1.x = this.captchaView.x;
            this.pass2.x = this.captchaView.x;
            this.callSign.width = this.captchaView.width;
            this.pass1.width = this.captchaView.width;
            this.pass2.width = this.captchaView.width;
            this.callSignCheckIcon.x += 10;
            this.y -= this.captchaView.height;
            this.p = this.y / stage.height;
            stage.addEventListener(Event.RESIZE,this.onResize);
         }
      }
   }
}
