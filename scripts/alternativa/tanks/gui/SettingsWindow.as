package alternativa.tanks.gui
{
   import alternativa.init.Main;
   import alternativa.osgi.service.locale.ILocaleService;
   import alternativa.osgi.service.storage.IStorageService;
   import alternativa.tanks.locale.constants.TextConst;
   import controls.DefaultButton;
   import controls.Label;
   import controls.Slider;
   import controls.TankCheckBox;
   import controls.TankInput;
   import controls.TankWindow;
   import controls.TankWindowHeader;
   import controls.TankWindowInner;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.FocusEvent;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import flash.text.AntiAliasType;
   import forms.events.SliderEvent;
   import scpacker.gui.GTanksLoaderWindow;
   import scpacker.gui.IGTanksLoader;
   
   public class SettingsWindow extends Sprite
   {
      
      private static const buttonSize:Point = new Point(104,33);
      
      private static const FIRST_COLUMN_X:int = 21;
      
      private static const SECOND_COLUMN_X:int = 109;
      
      private static const windowMargin:int = 12;
      
      private static const margin:int = 8;
       
      
      private var passwordInput:TankInput;
      
      private var passwordConfirmInput:TankInput;
      
      private var emailInput:TankInput;
      
      private var realNameInput:TankInput;
      
      private var idNumberInput:TankInput;
      
      private var volumeLevel:Slider;
      
      private var volumeLabel:Label;
      
      private var passLabel:Label;
      
      private var repPassLabel:Label;
      
      private var emailLabel:Label;
      
      private var performanceLabel:Label;
      
      private var accountLabel:Label;
      
      private var controlLabel:Label;
      
      private var antiAddictionLabel:Label;
      
      private var realNameLabel:Label;
      
      private var idNumberLabel:Label;
      
      private var _bgSound:TankCheckBox;
      
      private var _showFPS:TankCheckBox;
      
      private var _adaptiveFPS:TankCheckBox;
      
      private var _sendNews:TankCheckBox;
      
      private var _showSkyBox:TankCheckBox;
      
      private var _showBattleChat:TankCheckBox;
      
      private var _inverseBackDriving:TankCheckBox;
      
      private var cbMipMapping:TankCheckBox;
      
      private var useNewLoader:TankCheckBox;
      
      private var _showShadowsTank:TankCheckBox;
      
      private var _useFog:TankCheckBox;
      
      private var _softParticle:TankCheckBox;
      
      private var _dust:TankCheckBox;
      
      private var _shadows:TankCheckBox;
      
      private var _defferedLighting:TankCheckBox;
      
      private var _nyLighting:TankCheckBox;
      
      private var _tracksAnimation:TankCheckBox;
      
      private var _damageAnimation:TankCheckBox;
      
      private var _useOldTextures:TankCheckBox;
      
      private var _useSSAO:TankCheckBox;
      
      private var _coloredFPS:TankCheckBox;
      
      private var window:TankWindow;
      
      private var soundInner:TankWindowInner;
      
      private var performanceInner:TankWindowInner;
      
      private var accountInner:TankWindowInner;
      
      private var controlInner:TankWindowInner;
      
      private var antiAddictionInner:TankWindowInner;
      
      private var windowSize:Point;
      
      public var confirmEmailButton:DefaultButton;
      
      private var cancelButton:DefaultButton;
      
      private var switchButton:DefaultButton;
      
      private var okButton:DefaultButton;
      
      private var changePasswordButton:DefaultButton;
      
      public var state:int;
      
      public const STATE_EMAIL_UNDEFINED:int = 0;
      
      public const STATE_EMAIL_UNCONFIRMED:int = 1;
      
      public const STATE_EMAIL_CHANGE:int = 2;
      
      public var isPasswordChangeDisabled:Boolean = false;
      
      public function SettingsWindow(mail:String, emailConfirmed:Boolean, antiAddictionEnabled:Boolean, realName:String, idNumber:String)
      {
         var localeService:ILocaleService = null;
         super();
         localeService = ILocaleService(Main.osgi.getService(ILocaleService));
         if(emailConfirmed)
         {
            this.state = this.STATE_EMAIL_CHANGE;
            this.isPasswordChangeDisabled = true;
         }
         else if(mail != "" && mail != null)
         {
            this.state = this.STATE_EMAIL_UNCONFIRMED;
            this.isPasswordChangeDisabled = true;
         }
         else
         {
            this.state = this.STATE_EMAIL_UNDEFINED;
         }
         this.windowSize = new Point(444,550 + (!!antiAddictionEnabled ? 110 : 50) + (!this.isPasswordChangeDisabled ? 30 : 0));
         var inputWidth:int = 120;
         this.window = new TankWindow(this.windowSize.x,this.windowSize.y);
         this.window.headerLang = localeService.getText(TextConst.GUI_LANG);
         this.window.header = TankWindowHeader.SETTINGS;
         addChild(this.window);
         this.soundInner = new TankWindowInner(0,0,TankWindowInner.TRANSPARENT);
         addChild(this.soundInner);
         this.soundInner.x = windowMargin;
         this.soundInner.y = windowMargin;
         this.soundInner.width = this.windowSize.x - windowMargin * 2;
         this.performanceInner = new TankWindowInner(0,0,TankWindowInner.TRANSPARENT);
         addChild(this.performanceInner);
         this.performanceInner.x = windowMargin;
         this.performanceInner.width = this.windowSize.x - windowMargin * 2;
         this.accountInner = new TankWindowInner(0,0,TankWindowInner.TRANSPARENT);
         addChild(this.accountInner);
         this.accountInner.x = windowMargin;
         this.accountInner.width = this.windowSize.x - windowMargin * 2;
         this.controlInner = new TankWindowInner(0,0,TankWindowInner.TRANSPARENT);
         addChild(this.controlInner);
         this.controlInner.x = windowMargin;
         this.controlInner.width = this.windowSize.x - windowMargin * 2;
         this._bgSound = this.createCheckBox(localeService.getText(TextConst.SETTINGS_BACKGROUND_SOUND_CHECKBOX_LABEL_TEXT));
         addChild(this._bgSound);
         this._bgSound.x = this.windowSize.x - windowMargin - this._bgSound.width - margin;
         this._bgSound.y = this.soundInner.y + margin;
         this.volumeLabel = new Label();
         addChild(this.volumeLabel);
         this.volumeLabel.text = localeService.getText(TextConst.SETTINGS_SOUND_VOLUME_LABEL_TEXT);
         this.volumeLabel.x = SECOND_COLUMN_X - margin - this.volumeLabel.textWidth;
         this.volumeLevel = new Slider();
         addChild(this.volumeLevel);
         this.volumeLevel.maxValue = 100;
         this.volumeLevel.minValue = 0;
         this.volumeLevel.tickInterval = 5;
         this.volumeLevel.x = SECOND_COLUMN_X;
         this.volumeLevel.y = this.soundInner.y + margin;
         this.volumeLevel.width = this.windowSize.x - windowMargin - margin - SECOND_COLUMN_X - this._bgSound.width - margin;
         this.volumeLevel.addEventListener(SliderEvent.CHANGE_VALUE,this.onChangeVolume);
         this.soundInner.height = margin * 2 + this.volumeLevel.height;
         this.volumeLabel.y = this.soundInner.y + Math.round((this.soundInner.height - this.volumeLabel.textHeight) * 0.5) - 2;
         this.performanceLabel = new Label();
         this.performanceLabel.antiAliasType = AntiAliasType.ADVANCED;
         this.performanceLabel.sharpness = -100;
         this.performanceLabel.thickness = 100;
         this.performanceLabel.text = localeService.getText(TextConst.SETTINGS_PERFORMANCE_HEADER_LABEL_TEXT);
         this.performanceLabel.textColor = 0;
         addChild(this.performanceLabel);
         this.performanceLabel.x = windowMargin;
         this.performanceLabel.y = this.soundInner.y + this.soundInner.height + windowMargin;
         this.performanceInner.y = this.performanceLabel.y + this.performanceLabel.textHeight + 5;
         this._showFPS = this.createCheckBox(localeService.getText(TextConst.SETTINGS_SHOW_FPS_CHECKBOX_LABEL_TEXT));
         addChild(this._showFPS);
         this._showFPS.x = FIRST_COLUMN_X;
         this._showFPS.y = this.performanceInner.y + margin + 1;
         this._adaptiveFPS = this.createCheckBox(localeService.getText(TextConst.SETTINGS_ENABLE_ADAPTIVE_FPS_CHECKBOX_LABEL_TEXT));
         addChild(this._adaptiveFPS);
         this._adaptiveFPS.x = this._showFPS.x + 252;
         this._adaptiveFPS.y = this._showFPS.y + this._showFPS.height + margin;
         this._coloredFPS = this.createCheckBox(localeService.getText(TextConst.SETTINGS_COLORED_FPS));
         addChild(this._coloredFPS);
         this._coloredFPS.x = this._showFPS.x;
         this._coloredFPS.y = this._showFPS.y + this._showFPS.height + margin;
         this._showSkyBox = this.createCheckBox(localeService.getText(TextConst.SETTINGS_SHOW_SKYBOX_CHECKBOX_LABEL_TEXT));
         this._showSkyBox.type = TankCheckBox.CHECK_SIGN;
         addChild(this._showSkyBox);
         this._showSkyBox.x = this._adaptiveFPS.x;
         this._showSkyBox.y = this._showFPS.y;
         this.useNewLoader = this.createCheckBox(localeService.getText(TextConst.SETTINGS_USE_NEW_LOADER_CHECKBOX_LABEL_TEXT));
         addChild(this.useNewLoader);
         this.useNewLoader.x = this._showSkyBox.x;
         this.useNewLoader.y = this._adaptiveFPS.y + this._adaptiveFPS.height + margin;
         this.useNewLoader.addEventListener(MouseEvent.CLICK,function(e:MouseEvent):void
         {
            IStorageService(Main.osgi.getService(IStorageService)).getStorage().setProperty("use_new_loader",useNewLoader.checked);
            Main.osgi.registerService(IGTanksLoader,new GTanksLoaderWindow(useNewLoader.checked));
            GTanksLoaderWindow(Main.osgi.getService(IGTanksLoader)).hideLoaderWindow();
         });
         this.useNewLoader.checked = IStorageService(Main.osgi.getService(IStorageService)).getStorage().data["use_new_loader"];
         this._showBattleChat = this.createCheckBox(localeService.getText(TextConst.SETTINGS_SHOW_BATTLE_CHAT_CHECKBOX_LABEL_TEXT));
         addChild(this._showBattleChat);
         this._showBattleChat.x = FIRST_COLUMN_X;
         this._showBattleChat.y = this._adaptiveFPS.y + this._adaptiveFPS.height + margin;
         this._useFog = this.createCheckBox(localeService.getText(TextConst.SETTINGS_FOG_CHECKBOX_LABEL_TEXT));
         this._useFog.x = this._showBattleChat.x;
         this._useFog.y = this._showBattleChat.y + this._useFog.height * 2 + 15;
         this._useFog.checked = IStorageService(Main.osgi.getService(IStorageService)).getStorage().data["fog"];
         addChild(this._useFog);
         this._defferedLighting = this.createCheckBox(localeService.getText(TextConst.SETTINGS_DYNAMIC_LIGHTS_CHECKBOX_LABEL_TEXT));
         this._defferedLighting.x = this.useNewLoader.x;
         this._defferedLighting.y = this._showBattleChat.y + this._useFog.height * 2 + 15;
         addChild(this._defferedLighting);
         this._nyLighting = this.createCheckBox("Night mode");
         this._nyLighting.x = this.useNewLoader.x - 125;
         this._nyLighting.y = this._showBattleChat.y + this._useFog.height * 2 + 15;
         this._nyLighting.addEventListener(MouseEvent.CLICK,function(e:MouseEvent):void
         {
            IStorageService(Main.osgi.getService(IStorageService)).getStorage().setProperty("night_mode",_nyLighting.checked);
         });
         this._nyLighting.checked = IStorageService(Main.osgi.getService(IStorageService)).getStorage().data["night_mode"];
         addChild(this._nyLighting);
         this._shadows = this.createCheckBox(localeService.getText(TextConst.SETTINGS_DYNAMIC_SHADOWS_CHECKBOX_LABEL_TEXT));
         this._shadows.x = this._useFog.x;
         this._shadows.y = this._useFog.y + this._shadows.height + 6;
         this._shadows.enabled = false;
         addChild(this._shadows);
         this._showShadowsTank = this.createCheckBox(localeService.getText(TextConst.SETTINGS_TANK_SHADOWS_CHECKBOX_LABEL_TEXT));
         this._showShadowsTank.x = this.useNewLoader.x;
         this._showShadowsTank.y = this.useNewLoader.y + this.useNewLoader.height - 3;
         addChild(this._showShadowsTank);
         this.cbMipMapping = this.createCheckBox(localeService.getText(TextConst.SETTINGS_MIPMAPPING_LABEL_TEXT));
         this.cbMipMapping.x = FIRST_COLUMN_X;
         this.cbMipMapping.y = this._showBattleChat.y + this._showBattleChat.height + margin;
         addChild(this.cbMipMapping);
         this._softParticle = this.createCheckBox(localeService.getText(TextConst.SETTINGS_SOFT_PARTICLES_CHECKBOX_LABEL_TEXT));
         this._softParticle.x = this.useNewLoader.x;
         this._softParticle.y = this.cbMipMapping.y + this._shadows.height * 2 + 13;
         this._softParticle.addEventListener(MouseEvent.CLICK,function(e:MouseEvent):void
         {
            IStorageService(Main.osgi.getService(IStorageService)).getStorage().setProperty("soft_particle",_softParticle.checked);
            Main.osgi.registerService(IGTanksLoader,new GTanksLoaderWindow(useNewLoader.checked));
            GTanksLoaderWindow(Main.osgi.getService(IGTanksLoader)).hideLoaderWindow();
            _dust.visible = _softParticle.checked;
         });
         this._softParticle.checked = IStorageService(Main.osgi.getService(IStorageService)).getStorage().data["soft_particle"];
         addChild(this._softParticle);
         this._dust = this.createCheckBox(localeService.getText(TextConst.SETTINGS_DUST_CHECKBOX_LABEL_TEXT));
         this._dust.x = this._softParticle.x;
         this._dust.y = this._softParticle.y + this._dust.height + 6;
         this._dust.visible = this._softParticle.checked;
         addChild(this._dust);
         this._tracksAnimation = this.createCheckBox(localeService.getText(TextConst.SETTINGS_TRACKS_CHECKBOX_LABEL_TEXT));
         this._tracksAnimation.x = this._useFog.x;
         this._tracksAnimation.y = this._softParticle.y + this._dust.height + 6;
         addChild(this._tracksAnimation);
         this._damageAnimation = this.createCheckBox(localeService.getText(TextConst.SETTINGS_DAMAGE_CHECKBOX_LABEL_TEXT));
         this._damageAnimation.x = this._useFog.x;
         this._damageAnimation.y = this._dust.y + this._dust.height + 6;
         this._damageAnimation.checked = true;
         addChild(this._damageAnimation);
         this._useOldTextures = this.createCheckBox(localeService.getText(TextConst.SETTINGS_OLD_TEXTURES_LABEL_TEXT));
         this._useOldTextures.x = this._softParticle.x;
         this._useOldTextures.y = this._dust.y + this._dust.height + 6;
         this._useOldTextures.addEventListener(MouseEvent.CLICK,function(e:MouseEvent):void
         {
            IStorageService(Main.osgi.getService(IStorageService)).getStorage().setProperty("use_old_textures",_useOldTextures.checked);
         });
         this._useOldTextures.checked = IStorageService(Main.osgi.getService(IStorageService)).getStorage().data["use_old_textures"];
         addChild(this._useOldTextures);
         this._useSSAO = this.createCheckBox("SSAO");
         this._useSSAO.x = this._softParticle.x - 100;
         this._useSSAO.y = this._dust.y + this._dust.height + 6;
         this._useSSAO.addEventListener(MouseEvent.CLICK,function(e:MouseEvent):void
         {
            IStorageService(Main.osgi.getService(IStorageService)).getStorage().setProperty("use_ssao",_useSSAO.checked);
         });
         this._useSSAO.checked = IStorageService(Main.osgi.getService(IStorageService)).getStorage().data["use_ssao"];
         addChild(this._useSSAO);
         this.performanceInner.height = this._shadows.y + 2 * margin;
         this.accountLabel = new Label();
         this.accountLabel.antiAliasType = AntiAliasType.ADVANCED;
         this.accountLabel.sharpness = -100;
         this.accountLabel.thickness = 100;
         this.accountLabel.text = localeService.getText(TextConst.SETTINGS_ACCOUNT_HEADER_LABEL_TEXT);
         this.accountLabel.textColor = 0;
         addChild(this.accountLabel);
         this.accountLabel.x = windowMargin;
         this.accountLabel.y = this.performanceInner.y + this.performanceInner.height + windowMargin;
         this.accountInner.y = this.accountLabel.y + this.accountLabel.textHeight + 5;
         if(!this.isPasswordChangeDisabled)
         {
            this.passwordInput = new TankInput();
            this.passwordInput.hidden = true;
            addChild(this.passwordInput);
            this.passwordInput.width = inputWidth;
            this.passwordInput.x = SECOND_COLUMN_X;
            this.passwordInput.y = this.accountInner.y + margin;
            this.passwordInput.addEventListener(Event.CHANGE,this.checkPasswordConfirmation);
            this.passwordInput.maxChars = 35;
            this.passLabel = new Label();
            addChild(this.passLabel);
            this.passLabel.text = localeService.getText(TextConst.SETTINGS_NEW_PASSWORD_LABEL_TEXT);
            this.passLabel.x = SECOND_COLUMN_X - margin - this.passLabel.textWidth;
            this.passLabel.y = this.passwordInput.y + Math.round((this.passwordInput.height - this.passLabel.textHeight) * 0.5) - 2;
            this.repPassLabel = new Label();
            addChild(this.repPassLabel);
            this.repPassLabel.text = localeService.getText(TextConst.SETTINGS_REENTER_PASSWORD_LABEL_TEXT);
            this.repPassLabel.x = this.passwordInput.x + this.passwordInput.width + 7;
            this.repPassLabel.y = this.passLabel.y;
            this.passwordConfirmInput = new TankInput();
            addChild(this.passwordConfirmInput);
            this.passwordConfirmInput.hidden = true;
            this.passwordConfirmInput.x = this.repPassLabel.x + this.repPassLabel.textWidth + margin;
            this.passwordConfirmInput.width = this.accountInner.x + this.accountInner.width - this.passwordConfirmInput.x - 10;
            this.passwordConfirmInput.y = this.passwordInput.y;
            this.passwordConfirmInput.addEventListener(Event.CHANGE,this.checkPasswordConfirmation);
            this.passwordConfirmInput.maxChars = 35;
            this.emailLabel = new Label();
            addChild(this.emailLabel);
            this.emailLabel.text = localeService.getText(TextConst.SETTINGS_EMAIL_LABEL_TEXT);
            this.emailLabel.x = this.passLabel.x;
            this.emailLabel.y = this.passwordConfirmInput.y + this.passwordConfirmInput.height + windowMargin + 6;
            this.emailInput = new TankInput();
            addChild(this.emailInput);
            this.emailInput.textField.text = mail;
            this.emailInput.x = this.emailLabel.x + this.emailLabel.textWidth + margin;
            this.emailInput.y = this.passwordConfirmInput.y + this.passwordConfirmInput.height + windowMargin;
            if(this.state == this.STATE_EMAIL_UNCONFIRMED)
            {
               this.confirmEmailButton = new DefaultButton();
               addChild(this.confirmEmailButton);
               this.confirmEmailButton.width = 160;
               this.confirmEmailButton.label = localeService.getText(TextConst.SETTINGS_BUTTON_RESEND_CONFIRMATION_TEXT);
               this.confirmEmailButton.x = this.windowSize.x - windowMargin - margin - this.confirmEmailButton.width;
               this.confirmEmailButton.y = this.passwordConfirmInput.y + this.passwordConfirmInput.height + windowMargin;
               this.confirmEmailButton.addEventListener(MouseEvent.CLICK,this.onComfirmClick);
               this.emailInput.width = this.confirmEmailButton.x - windowMargin - this.emailInput.x;
            }
            else
            {
               this.emailInput.width = this.windowSize.x - windowMargin - margin - this.emailInput.x;
            }
            this.accountInner.height = margin * 2 + this.passwordInput.height + buttonSize.y + windowMargin - 1;
         }
         else
         {
            this.changePasswordButton = new DefaultButton();
            this.changePasswordButton.width = 210;
            this.accountInner.height = buttonSize.y * 2;
            addChild(this.changePasswordButton);
            this.changePasswordButton.label = localeService.getText(TextConst.SETTINGS_BUTTON_CHANGE_PASSWORD_TEXT);
            this.changePasswordButton.x = (this.windowSize.x - this.changePasswordButton.width) / 2;
            this.changePasswordButton.y = this.accountInner.y + (this.accountInner.height - this.changePasswordButton.height) / 2;
            this.changePasswordButton.addEventListener(MouseEvent.CLICK,this.onChangePasswordClick);
         }
         if(antiAddictionEnabled)
         {
            this.antiAddictionInner = new TankWindowInner(0,0,TankWindowInner.TRANSPARENT);
            addChild(this.antiAddictionInner);
            this.antiAddictionInner.x = windowMargin;
            this.antiAddictionInner.width = this.windowSize.x - windowMargin * 2;
            this.antiAddictionLabel = new Label();
            this.antiAddictionLabel.antiAliasType = AntiAliasType.ADVANCED;
            this.antiAddictionLabel.sharpness = -100;
            this.antiAddictionLabel.thickness = 100;
            this.antiAddictionLabel.text = "防沉迷验证登记";
            this.antiAddictionLabel.textColor = 0;
            addChild(this.antiAddictionLabel);
            this.antiAddictionLabel.x = windowMargin;
            this.antiAddictionLabel.y = this.accountInner.y + this.accountInner.height + windowMargin;
            this.antiAddictionInner.y = this.antiAddictionLabel.y + this.antiAddictionLabel.textHeight + 5;
            this.realNameLabel = new Label();
            addChild(this.realNameLabel);
            this.realNameLabel.text = "您的真实姓名:";
            this.realNameLabel.x = SECOND_COLUMN_X - margin - this.realNameLabel.textWidth;
            this.realNameInput = new TankInput();
            addChild(this.realNameInput);
            this.realNameInput.width = this.antiAddictionInner.width - margin * 4 - this.realNameLabel.width;
            this.realNameInput.x = SECOND_COLUMN_X;
            this.realNameInput.y = this.antiAddictionInner.y + margin;
            this.realNameLabel.y = this.realNameInput.y + Math.round((this.realNameInput.height - this.realNameLabel.textHeight) * 0.5) - 2;
            this.idNumberLabel = new Label();
            addChild(this.idNumberLabel);
            this.idNumberLabel.text = "身份证号码:";
            this.idNumberLabel.x = SECOND_COLUMN_X - this.idNumberLabel.width - 5;
            this.idNumberLabel.y = this.realNameInput.y + this.realNameInput.height + windowMargin + 6;
            this.idNumberInput = new TankInput();
            addChild(this.idNumberInput);
            this.idNumberInput.textField.text = mail;
            this.idNumberInput.x = this.realNameInput.x;
            this.idNumberInput.y = this.realNameInput.y + this.realNameInput.height + windowMargin;
            this.idNumberInput.width = this.antiAddictionInner.width - margin * 4 - this.realNameLabel.width;
            this.antiAddictionInner.height = margin * 4 + 2 * this.realNameInput.height;
            this.idNumberInput.textField.text = idNumber != null && idNumber != "null" ? idNumber : "";
            this.realNameInput.textField.text = realName != null && realName != "null" ? realName : "";
            this.idNumberInput.addEventListener(FocusEvent.FOCUS_OUT,this.validateAddictionID);
            this.idNumberInput.addEventListener(FocusEvent.FOCUS_IN,this.restoreInput);
         }
         this.controlLabel = new Label();
         this.controlLabel.antiAliasType = AntiAliasType.ADVANCED;
         this.controlLabel.sharpness = -100;
         this.controlLabel.thickness = 100;
         this.controlLabel.text = localeService.getText(TextConst.SETTINGS_CONTROL_HEADER_LABEL_TEXT);
         this.controlLabel.textColor = 0;
         addChild(this.controlLabel);
         this.controlLabel.x = windowMargin;
         this.controlLabel.y = !!antiAddictionEnabled ? Number(this.antiAddictionInner.y + this.antiAddictionInner.height + windowMargin) : Number(this.accountInner.y + this.accountInner.height + windowMargin);
         this.controlInner.y = this.controlLabel.y + this.controlLabel.textHeight + 5;
         this._inverseBackDriving = this.createCheckBox(localeService.getText(TextConst.SETTINGS_INVERSE_TURN_CONTROL_CHECKBOX_LABEL_TEXT));
         addChild(this._inverseBackDriving);
         this._inverseBackDriving.x = FIRST_COLUMN_X;
         this._inverseBackDriving.y = this.controlInner.y + margin + 1;
         this.controlInner.height = margin * 2 + this._showFPS.height + 1;
         this.okButton = new DefaultButton();
         addChild(this.okButton);
         this.okButton.label = localeService.getText(TextConst.SETTINGS_BUTTON_SAVE_TEXT);
         this.okButton.x = this.windowSize.x - buttonSize.x * 2 - 1 - margin;
         this.okButton.y = this.windowSize.y - buttonSize.y - margin;
         this.okButton.addEventListener(MouseEvent.CLICK,this.onOkClick);
         this.cancelButton = new DefaultButton();
         addChild(this.cancelButton);
         this.cancelButton.label = localeService.getText(TextConst.SETTINGS_BUTTON_CANCEL_TEXT);
         this.cancelButton.x = this.windowSize.x - buttonSize.x - margin + 5;
         this.cancelButton.y = this.windowSize.y - buttonSize.y - margin;
         this.cancelButton.addEventListener(MouseEvent.CLICK,this.onCancelClick);
         this.switchButton = new DefaultButton();
         this.switchButton.label = "Управление";
         this.switchButton.x = this.windowSize.x - buttonSize.x - margin + 5;
         this.switchButton.y = this.soundInner.y + this.soundInner.height;
         this.switchButton.addEventListener(MouseEvent.CLICK,this.onCancelClick);
         this._sendNews = this.createCheckBox(localeService.getText(TextConst.SETTINGS_SEND_NEWS_CHECKBOX_LABEL_TEXT));
         this._sendNews.x = FIRST_COLUMN_X;
         this._sendNews.y = this.cancelButton.y - Math.round((buttonSize.y - this._sendNews.height) * 0.5) + 4;
      }
      
      public function get useShadows() : Boolean
      {
         return this._shadows.checked;
      }
      
      public function set useShadows(v:Boolean) : void
      {
         this._shadows.checked = v;
      }
      
      public function get useDefferedLighting() : Boolean
      {
         return this._defferedLighting.checked;
      }
      
      public function set useDefferedLighting(v:Boolean) : *
      {
         this._defferedLighting.checked = v;
      }
      
      public function get useAnimatedTracks() : Boolean
      {
         return this._tracksAnimation.checked;
      }
      
      public function set useAnimatedTracks(v:Boolean) : *
      {
         this._tracksAnimation.checked = v;
      }
      
      public function get useAnimatedDamage() : Boolean
      {
         return this._damageAnimation.checked;
      }
      
      public function set useAnimatedDamage(v:Boolean) : *
      {
         this._damageAnimation.checked = v;
      }
      
      public function get useOldTextures() : Boolean
      {
         return this._useOldTextures.checked;
      }
      
      public function set useOldTextures(v:Boolean) : *
      {
         this._useOldTextures.checked = v;
      }
      
      public function get useDust() : Boolean
      {
         return this._dust.checked;
      }
      
      public function set useDust(v:Boolean) : void
      {
         this._dust.checked = v;
      }
      
      public function get useSoftParticle() : Boolean
      {
         return this._softParticle.checked;
      }
      
      public function get useFog() : Boolean
      {
         return this._useFog.checked;
      }
      
      public function get bgSound() : Boolean
      {
         return this._bgSound.checked;
      }
      
      public function get showShadowsTank() : Boolean
      {
         return this._showShadowsTank.checked;
      }
      
      public function set showShadowsTank(value:Boolean) : void
      {
         this._showShadowsTank.checked = value;
      }
      
      public function set bgSound(value:Boolean) : void
      {
         this._bgSound.checked = value;
      }
      
      public function get showFPS() : Boolean
      {
         return this._showFPS.checked;
      }
      
      public function set showFPS(value:Boolean) : void
      {
         this._showFPS.checked = value;
      }
      
      public function get adaptiveFPS() : Boolean
      {
         return this._adaptiveFPS.checked;
      }
      
      public function set adaptiveFPS(value:Boolean) : void
      {
         this._adaptiveFPS.checked = value;
      }
      
      public function get coloredFPS() : Boolean
      {
         return this._coloredFPS.checked;
      }
      
      public function set coloredFPS(value:Boolean) : void
      {
         this._coloredFPS.checked = value;
      }
      
      public function get sendNews() : Boolean
      {
         return this._sendNews.checked;
      }
      
      public function set sendNews(value:Boolean) : void
      {
         this._sendNews.checked = value;
      }
      
      public function get showSkyBox() : Boolean
      {
         return this._showSkyBox.checked;
      }
      
      public function set showSkyBox(value:Boolean) : void
      {
         this._showSkyBox.checked = value;
      }
      
      public function get showBattleChat() : Boolean
      {
         return this._showBattleChat.checked;
      }
      
      public function set showBattleChat(value:Boolean) : void
      {
         this._showBattleChat.checked = value;
      }
      
      public function get inverseBackDriving() : Boolean
      {
         return this._inverseBackDriving.checked;
      }
      
      public function set inverseBackDriving(value:Boolean) : void
      {
         this._inverseBackDriving.checked = value;
      }
      
      public function get enableMipMapping() : Boolean
      {
         return this.cbMipMapping.checked;
      }
      
      public function set enableMipMapping(value:Boolean) : void
      {
         this.cbMipMapping.checked = value;
      }
      
      private function restoreInput(event:FocusEvent) : void
      {
         var trgt:TankInput = event.currentTarget as TankInput;
         trgt.validValue = true;
      }
      
      private function validateAddictionID(event:FocusEvent) : void
      {
         var l:int = 0;
         if(this.idNumberInput != null)
         {
            l = this.idNumberInput.value.length;
            this.idNumberInput.validValue = l == 18 || this.trimString(this.idNumberInput.value).length == 0;
         }
      }
      
      private function onChangePasswordClick(event:MouseEvent) : void
      {
         this.changePasswordButton.enable = false;
         dispatchEvent(new SettingsWindowEvent(SettingsWindowEvent.CHANGE_PASSWORD));
      }
      
      private function onChangeVolume(e:SliderEvent) : void
      {
         dispatchEvent(new SettingsWindowEvent(SettingsWindowEvent.CHANGE_VOLUME));
      }
      
      public function set visibleDustButton(v:Boolean) : void
      {
         this._dust.visible = v;
      }
      
      private function onComfirmClick(e:MouseEvent) : void
      {
         this.confirmEmailButton.enable = false;
      }
      
      private function onCancelClick(e:MouseEvent) : void
      {
         dispatchEvent(new SettingsWindowEvent(SettingsWindowEvent.CANCEL_SETTINGS));
      }
      
      private function onOkClick(e:MouseEvent) : void
      {
         dispatchEvent(new SettingsWindowEvent(SettingsWindowEvent.ACCEPT_SETTINGS));
      }
      
      private function checkPasswordConfirmation(e:Event) : void
      {
         if(this.passwordInput.value.length > 0 && this.passwordConfirmInput.value.length > 0 && this.passwordConfirmInput.value != this.passwordInput.value)
         {
            this.okButton.enable = false;
            this.passwordConfirmInput.validValue = false;
         }
         else
         {
            this.okButton.enable = true;
            this.passwordConfirmInput.validValue = true;
         }
      }
      
      public function get password() : String
      {
         if(this.isPasswordChangeDisabled)
         {
            return "";
         }
         var p:String = "";
         if(this.passwordInput.textField.text != "" && this.passwordInput.textField.text != null)
         {
            if(this.passwordInput.textField.text == this.passwordConfirmInput.textField.text)
            {
               p = this.passwordInput.textField.text;
            }
         }
         return p;
      }
      
      public function get email() : String
      {
         if(this.isPasswordChangeDisabled)
         {
            return "";
         }
         return this.emailInput.textField.text;
      }
      
      public function get emailNoticeValue() : Boolean
      {
         return this._sendNews.checked;
      }
      
      public function get volume() : Number
      {
         return this.volumeLevel.value / 100;
      }
      
      public function set volume(value:Number) : void
      {
         this.volumeLevel.value = value * 100;
      }
      
      public function get realName() : String
      {
         if(this.realNameInput != null && this.realNameInput.value != null && this.trimString(this.realNameInput.value).length > 0)
         {
            return this.realNameInput.value;
         }
         return "";
      }
      
      public function get idNumber() : String
      {
         if(this.idNumberInput != null && this.idNumberInput.value != null && this.trimString(this.idNumberInput.value).length > 0)
         {
            return this.idNumberInput.value;
         }
         return "";
      }
      
      private function trimString(str:String) : String
      {
         if(str.charAt(0) == " ")
         {
            str = this.trimString(str.substring(1));
         }
         if(str.charAt(str.length - 1) == " ")
         {
            str = this.trimString(str.substring(0,str.length - 1));
         }
         return str;
      }
      
      private function createCheckBox(labelText:String) : TankCheckBox
      {
         var cb:TankCheckBox = new TankCheckBox();
         cb.type = TankCheckBox.CHECK_SIGN;
         cb.label = labelText;
         return cb;
      }
   }
}
