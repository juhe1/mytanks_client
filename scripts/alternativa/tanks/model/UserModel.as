package alternativa.tanks.model
{
   import alternativa.init.Main;
   import alternativa.model.IModel;
   import alternativa.model.IObjectLoadListener;
   import alternativa.object.ClientObject;
   import alternativa.osgi.service.loaderParams.ILoaderParamsService;
   import alternativa.osgi.service.locale.ILocaleService;
   import alternativa.osgi.service.storage.IStorageService;
   import alternativa.service.IAddressService;
   import alternativa.tanks.gui.ChangeEmailAndPasswordWindow;
   import alternativa.tanks.gui.ChangePasswordAndEmailEvent;
   import alternativa.tanks.gui.InviteWindow;
   import alternativa.tanks.loader.ILoaderWindowService;
   import alternativa.tanks.locale.constants.TextConst;
   import com.alternativaplatform.client.models.core.users.model.entrance.ConfirmEmailStatus;
   import com.alternativaplatform.client.models.core.users.model.entrance.EntranceModelBase;
   import com.alternativaplatform.client.models.core.users.model.entrance.IEntranceModelBase;
   import com.alternativaplatform.client.models.core.users.model.entrance.RegisterStatusEnum;
   import com.alternativaplatform.client.models.core.users.model.entrance.RestorePasswordStatusEnum;
   import flash.display.DisplayObjectContainer;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.events.TimerEvent;
   import flash.net.SharedObject;
   import flash.net.URLRequest;
   import flash.net.navigateToURL;
   import flash.utils.Dictionary;
   import flash.utils.Timer;
   import forms.Alert;
   import forms.AlertAnswer;
   import forms.LoginForm;
   import forms.RegisterForm;
   import forms.ViewText;
   import forms.events.AlertEvent;
   import forms.events.LoginFormEvent;
   import scpacker.gui.ConfirmEmailCode;
   import scpacker.gui.GTanksLoaderWindow;
   import scpacker.gui.IGTanksLoader;
   import scpacker.networking.INetworkListener;
   import scpacker.networking.INetworker;
   import scpacker.networking.Network;
   import scpacker.networking.commands.Command;
   import scpacker.networking.commands.Type;
   
   public class UserModel extends EntranceModelBase implements IEntranceModelBase, IObjectLoadListener, INetworkListener
   {
       
      
      private var addressService:IAddressService;
      
      private var loaderParamsService:ILoaderParamsService;
      
      private var clientObject:ClientObject;
      
      private var layer:DisplayObjectContainer;
      
      private var loginForm:LoginForm;
      
      private var errorWindow:Alert;
      
      private var confirmAlert:Alert;
      
      private var changeEmailAndPasswordWindow:ChangeEmailAndPasswordWindow;
      
      private var inputShortInt:int = -1;
      
      private var inputLongInt:int = -1;
      
      private const inputShortDelay:int = 250;
      
      private const inputLongDelay:int = 3000;
      
      private const STATE_LOGIN:int = 1;
      
      private const STATE_REGISTER:int = 2;
      
      private const STATE_RESTORE_PASSWORD:int = 3;
      
      private var state:int = 0;
      
      private var not1stSimbols:String = "-_.";
      
      private var hash:String;
      
      private var login:String;
      
      private var up:String;
      
      private var emailConfirmHash:String;
      
      private var email:String;
      
      private var emailChangeHash:String;
      
      private var inviteWindow:InviteWindow;
      
      private var inviteEnabled:Boolean;
      
      private var antiAddictionEnabled:Boolean;
      
      private var params:Dictionary;
      
      private var checkCallsignTimer:Timer;
      
      private const checkCallsignDelay:int = 500;
      
      private var localeService:ILocaleService;
      
      private var network:Network;
      
      private var isUnique:Boolean;
      
      public function UserModel()
      {
         super();
         _interfaces.push(IModel);
         _interfaces.push(IEntranceModelBase);
         _interfaces.push(IObjectLoadListener);
         this.localeService = ILocaleService(Main.osgi.getService(ILocaleService));
         this.layer = Main.contentUILayer;
         this.inviteWindow = new InviteWindow();
         this.addressService = Main.osgi.getService(IAddressService) as IAddressService;
         this.loaderParamsService = Main.osgi.getService(ILoaderParamsService) as ILoaderParamsService;
      }
      
      public function initObject(clientObject:ClientObject, antiAddictionEnabled:Boolean, inviteEnabled:Boolean) : void
      {
         this.inviteEnabled = inviteEnabled;
         this.antiAddictionEnabled = antiAddictionEnabled;
         this.loginForm = new LoginForm(antiAddictionEnabled);
      }
      
      public function objectLoaded(object:ClientObject) : void
      {
         var s:String = null;
         var v:Array = null;
         var i:int = 0;
         var p:Array = null;
         var loaderService:ILoaderWindowService = null;
         var loaderServiceE:ILoaderWindowService = null;
         Main.writeVarsToConsoleChannel("USER MODEL","objectLoaded");
         this.clientObject = object;
         var storage:SharedObject = IStorageService(Main.osgi.getService(IStorageService)).getStorage();
         this.network = Main.osgi.getService(INetworker) as Network;
         this.network.addListener(this);
         this.network.send("system;init_location;" + Game.currLocale);
         if(this.addressService != null)
         {
            s = this.addressService.getValue();
            v = s.split("&");
            this.params = new Dictionary();
            for(i = 0; i < v.length; i++)
            {
               p = (v[i] as String).split("=");
               this.params[p[0]] = p[1];
            }
            this.hash = this.params["hash"];
            this.emailConfirmHash = this.params["emailConfirmHash"];
            this.email = this.params["userEmail"];
            this.emailChangeHash = this.params["emailChangeHash"];
         }
         Main.writeVarsToConsoleChannel("USER MODEL","hassssssh: %1",this.hash);
         if(this.hash != null && this.hash != "")
         {
            storage.data.userHash = this.hash;
         }
         else
         {
            this.hash = storage.data.userHash;
         }
         if(this.email != null && this.email != "")
         {
            storage.data.userEmail = this.email;
         }
         else
         {
            this.email = storage.data.userEmail;
         }
         this.login = storage.data.userName;
         this.up = storage.data.up;
         Main.writeVarsToConsole("USER MODEL","   hash: %1",this.hash);
         Main.writeVarsToConsole("USER MODEL","   email: %1",this.email);
         Main.writeVarsToConsole("USER MODEL","   emailConfirmHash: %1",this.emailConfirmHash);
         if(this.emailConfirmHash != null)
         {
            loaderService = Main.osgi.getService(ILoaderWindowService) as ILoaderWindowService;
            loaderService.hideLoaderWindow();
            loaderService.lockLoaderWindow();
            this.confirmAlert = new Alert(Alert.ALERT_CONFIRM_EMAIL);
            this.layer.addChild(this.confirmAlert);
            this.confirmAlert.addEventListener(AlertEvent.ALERT_BUTTON_PRESSED,this.onAlertButtonPressed);
         }
         else if(this.emailChangeHash != null)
         {
            loaderServiceE = Main.osgi.getService(ILoaderWindowService) as ILoaderWindowService;
            loaderServiceE.hideLoaderWindow();
            loaderServiceE.lockLoaderWindow();
         }
         else
         {
            this.enter();
         }
      }
      
      public function onData(data:Command) : void
      {
         var alert:Alert = null;
         if(data.type == Type.REGISTRATON)
         {
            switch(data.args[0])
            {
               case "check_name_result":
                  this.nameUnique(null,data.args[1] == "not_exist" ? Boolean(Boolean(true)) : Boolean(Boolean(false)));
                  break;
               case "info_done":
                  IStorageService(Main.osgi.getService(IStorageService)).getStorage().data.alreadyPlayedTanks = true;
                  this.objectUnloaded(this.clientObject);
                  GTanksLoaderWindow(Main.osgi.getService(IGTanksLoader)).unlockLoaderWindow();
                  GTanksLoaderWindow(Main.osgi.getService(IGTanksLoader)).addProgress(230);
                  (Main.osgi.getService(ILobby) as Lobby).beforeAuth();
            }
         }
         else if(data.type == Type.AUTH)
         {
            switch(data.args[0])
            {
               case "accept":
                  this.objectUnloaded(this.clientObject);
                  GTanksLoaderWindow(Main.osgi.getService(IGTanksLoader)).unlockLoaderWindow();
                  GTanksLoaderWindow(Main.osgi.getService(IGTanksLoader)).addProgress(230);
                  (Main.osgi.getService(ILobby) as Lobby).beforeAuth();
                  break;
               case "denied":
                  this.passwdLoginFailed(null);
                  break;
               case "not_exist":
                  this.passwdLoginFailed(null);
                  break;
               case "ban":
                  this.showBanWindow(data.args[1]);
                  break;
               case "recovery_account_done":
                  this.layer.addChild(new ConfirmEmailCode(this.localeService.getText(TextConst.ACCOUNT_RECOVERY_FORM_ENTER_CODE),this.onEnterConfirmCode));
                  break;
               case "recovery_account_result":
                  if(data.args[1] == "false")
                  {
                     this.setPasswordChangeResult(null,false,this.localeService.getText(TextConst.ACCOUNT_RECOVERY_FORM_ERROR));
                  }
                  break;
               case "wrong_captcha":
                  this.wrongCaptcha(null);
                  break;
               case "recovery_account_code":
                  if(data.args[1] == "true")
                  {
                     this.restorePasswordStatus(null,RestorePasswordStatusEnum.OK);
                     this.changeEmailHashIsOk(null,data.args[2]);
                  }
                  else
                  {
                     alert = new Alert();
                     alert.showAlert(this.localeService.getText(TextConst.ACCOUNT_RECOVERY_FORM_WRONG_CODE),[AlertAnswer.OK]);
                     this.layer.addChild(alert);
                  }
                  break;
               case "enable_captcha":
                  this.loginForm.setCaptchaEnable(data.args[1],data.args[2]);
                  break;
               case "update_captcha":
                  this.loginForm.updateCaptcha(data.args[1],data.args[2]);
                  break;
               case "recovery_account":
                  if(data.args[1] == "false")
                  {
                     this.setPasswordChangeResult(null,false,this.localeService.getText(TextConst.ACCOUNT_RECOVERY_FORM_ERROR));
                  }
                  else
                  {
                     this.setPasswordChangeResult(null,true,this.localeService.getText(TextConst.ACCOUNT_RECOVERY_FORM_PASSWORD_CHANGED));
                  }
                  break;
               case "invite_not_correct":
                  this.inviteNotFound(null);
                  break;
               case "invite_correct":
                  if(data.args[1] == "free")
                  {
                     this.inviteFree(null);
                  }
                  else
                  {
                     this.inviteAlreadyActivated(null,data.args[2]);
                  }
            }
         }
      }
      
      private function onEnterConfirmCode(code:String) : void
      {
         Network(Main.osgi.getService(INetworker)).send("auth;confirm_email_code;" + code);
      }
      
      public function changeEmailHashIsOk(clientObject:ClientObject, oldEmail:String) : void
      {
         this.changeEmailAndPasswordWindow = new ChangeEmailAndPasswordWindow();
         this.changeEmailAndPasswordWindow.email = oldEmail;
         this.changeEmailAndPasswordWindow.addEventListener(ChangePasswordAndEmailEvent.CHANGE_PRESSED,this.onChangePassAndEmailPressed);
         this.changeEmailAndPasswordWindow.addEventListener(ChangePasswordAndEmailEvent.CANCEL_PRESSED,this.onCancelPassAndEmailPressed);
         this.layer.addChild(this.changeEmailAndPasswordWindow);
         this.allignChangeEmailAndPasswordWindow(null);
         Main.stage.addEventListener(Event.RESIZE,this.allignChangeEmailAndPasswordWindow);
      }
      
      public function changeEmailHashIsWrong(clientObject:ClientObject) : void
      {
         var alert:Alert = new Alert();
         alert.showAlert(this.localeService.getText(TextConst.SETTINGS_CHANGE_PASSWORD_WRONG_LINK_TEXT),[AlertAnswer.OK]);
         this.layer.addChild(alert);
         alert.addEventListener(AlertEvent.ALERT_BUTTON_PRESSED,this.onWrongChangePasswordAlertButtonPressed);
      }
      
      private function onWrongChangePasswordAlertButtonPressed(event:AlertEvent) : void
      {
         this.enter();
      }
      
      private function enter() : void
      {
         var userInfo:String = null;
         if(this.hash != null)
         {
            Main.writeVarsToConsoleChannel("USER MODEL","loginByHash: " + this.hash);
         }
         else if(this.login != null && this.login != "" && this.up != null && this.up != "" && !this.inviteEnabled)
         {
            userInfo = this.login + ";" + this.up;
            this.network.send("auth;" + userInfo);
         }
         else if(this.inviteEnabled)
         {
            this.showInviteWindow();
         }
         else
         {
            this.afterInviteEnter();
         }
      }
      
      private function afterInviteEnter() : void
      {
         var userName:String = null;
         var password:String = null;
         var s:String = null;
         this.checkCallsignTimer = new Timer(this.checkCallsignDelay,1);
         this.checkCallsignTimer.addEventListener(TimerEvent.TIMER_COMPLETE,this.onCallsignCheckTimerComplete);
         this.showWindow();
         var storage:SharedObject = IStorageService(Main.osgi.getService(IStorageService)).getStorage();
         var VasyaWasHere:Boolean = storage.data.alreadyPlayedTanks;
         Main.writeVarsToConsoleChannel("USER MODEL","VasyaWasHere: %1",VasyaWasHere);
         if(VasyaWasHere)
         {
            this.state = this.STATE_LOGIN;
            this.loginForm.loginState = true;
            userName = storage.data.userName;
            password = storage.data.up;
            Main.writeVarsToConsoleChannel("USER MODEL","userName: %1",userName);
            Main.writeVarsToConsoleChannel("USER MODEL","rememberUserFlag: %1",storage.data.rememberUserFlag);
            if(userName != null)
            {
               this.loginForm.callSign = userName;
            }
            if(storage.data.rememberUserFlag)
            {
               this.loginForm.remember = storage.data.rememberUserFlag;
            }
            s = this.loaderParamsService.params["user"];
            if(s != null)
            {
               this.loginForm.callSign = s;
            }
            s = this.loaderParamsService.params["password"];
            if(s != null)
            {
               this.loginForm.checkPassword.password.value = s;
            }
         }
         else
         {
            this.state = this.STATE_REGISTER;
            this.loginForm.loginState = false;
            this.network.send("registration;state");
            if(this.addressService != null)
            {
               if(this.loaderParamsService.params["partner"] != null)
               {
                  this.addressService.setValue("registration/partner=" + this.loaderParamsService.params["partner"]);
               }
               else
               {
                  this.addressService.setValue("registration");
               }
            }
         }
      }
      
      private function onAlertButtonPressed(e:AlertEvent) : void
      {
      }
      
      public function confirmEmailStatus(clientObject:ClientObject, status:ConfirmEmailStatus) : void
      {
         switch(status)
         {
            case ConfirmEmailStatus.ERROR:
               this.enter();
               break;
            case ConfirmEmailStatus.OK:
               this.enter();
               break;
            case ConfirmEmailStatus.OK_EXISTS:
               this.goToPortal();
         }
      }
      
      private function goToPortal(e:AlertEvent = null) : void
      {
         navigateToURL(new URLRequest("http://alternativaplatform.com/ru/"),"_self");
      }
      
      public function objectUnloaded(object:ClientObject) : void
      {
         var loaderService:ILoaderWindowService = Main.osgi.getService(ILoaderWindowService) as ILoaderWindowService;
         loaderService.unlockLoaderWindow();
         var storage:SharedObject = IStorageService(Main.osgi.getService(IStorageService)).getStorage();
         storage.data.alreadyPlayedTanks = true;
         if(this.loginForm.callSign != null && this.loginForm.callSign != "" && this.loginForm.remember)
         {
            storage.data.userName = this.loginForm.callSign;
            storage.data.up = this.loginForm.mainPassword;
            storage.data.rememberUserFlag = this.loginForm.remember;
            if(this.addressService != null)
            {
               if(this.state == this.STATE_REGISTER)
               {
                  if(this.loaderParamsService.params["partner"] != null)
                  {
                     this.addressService.setValue("registered/" + this.loginForm.callSign + "/partner=" + this.loaderParamsService.params["partner"]);
                  }
                  else
                  {
                     this.addressService.setValue("registered/" + this.loginForm.callSign);
                  }
               }
            }
         }
         if(this.checkCallsignTimer != null)
         {
            this.checkCallsignTimer.removeEventListener(TimerEvent.TIMER_COMPLETE,this.onCallsignCheckTimerComplete);
            this.checkCallsignTimer = null;
         }
         if(this.state != 0)
         {
            this.loginForm.hide();
            this.hideWindow();
         }
         this.network.removeListener(this);
         this.loginForm = null;
         this.clientObject = null;
      }
      
      public function hashLoginFailed(clientObject:ClientObject) : void
      {
         Main.writeVarsToConsoleChannel("USER MODEL","hashLoginFailed!");
         var loaderService:ILoaderWindowService = Main.osgi.getService(ILoaderWindowService) as ILoaderWindowService;
         loaderService.hideLoaderWindow();
         loaderService.lockLoaderWindow();
         if(this.inviteEnabled)
         {
            this.showInviteWindow();
         }
         else
         {
            this.afterInviteEnter();
         }
      }
      
      public function wrongCaptcha(clientObject:ClientObject) : void
      {
         this.showErrorWindow(Alert.WRONG_CAPTCHA);
         this.loginForm.registerForm.playButton.enable = true;
         this.loginForm.checkPassword.playButton.enable = true;
      }
      
      public function passwdLoginFailed(clientObject:ClientObject) : void
      {
         Main.writeVarsToConsoleChannel("USER MODEL","passwdLoginFailed!");
         this.showWindow();
         this.state = this.STATE_LOGIN;
         var storage:SharedObject = IStorageService(Main.osgi.getService(IStorageService)).getStorage();
         var userName:String = storage.data.userName;
         this.loginForm.loginState = true;
         if(userName != null)
         {
            this.loginForm.callSign = userName;
         }
         if(storage.data.rememberUserFlag)
         {
            this.loginForm.remember = storage.data.rememberUserFlag;
         }
         this.showErrorWindow(Alert.ERROR_PASSWORD_INCORRECT);
         this.loginForm.clearPassword();
         this.loginForm.registerForm.playButton.enable = true;
         this.loginForm.checkPassword.playButton.enable = true;
      }
      
      public function registerStatus(clientObject:ClientObject, status:RegisterStatusEnum) : void
      {
         Main.writeVarsToConsoleChannel("USER MODEL","registerStatus: " + status);
         switch(status)
         {
            case RegisterStatusEnum.EMAIL_LDAP_UNIQUE:
               this.showErrorWindow(Alert.ERROR_EMAIL_UNIQUE);
               break;
            case RegisterStatusEnum.EMAIL_NOT_VALID:
               this.showErrorWindow(Alert.ERROR_EMAIL_INVALID);
               break;
            case RegisterStatusEnum.UID_LDAP_UNIQUE:
               this.showErrorWindow(Alert.ERROR_CALLSIGN_UNIQUE);
         }
         this.loginForm.registerForm.playButton.enable = true;
         this.loginForm.checkPassword.playButton.enable = true;
      }
      
      public function setHash(clientObject:ClientObject, hash:String) : void
      {
         Main.writeVarsToConsoleChannel("USER MODEL","setHash: " + hash);
         var storage:SharedObject = IStorageService(Main.osgi.getService(IStorageService)).getStorage();
         storage.data.userHash = hash;
         storage.data.alreadyPlayedTanks = true;
         var result:String = storage.flush();
         Main.writeVarsToConsoleChannel("USER MODEL","setHash result: " + result);
      }
      
      public function restorePasswordStatus(clientObject:ClientObject, status:RestorePasswordStatusEnum) : void
      {
         switch(status)
         {
            case RestorePasswordStatusEnum.OK:
               Main.writeVarsToConsoleChannel("USER MODEL","restorePasswordStatus: OK");
               this.loginForm.hideRestoreForm();
               this.state = this.STATE_LOGIN;
               break;
            case RestorePasswordStatusEnum.MAIL_NOT_FOUND:
               Main.writeVarsToConsoleChannel("USER MODEL","restorePasswordStatus: MAIL_NOT_FOUND");
               this.loginForm.invalidRestoreForm();
               this.showErrorWindow(Alert.ERROR_EMAIL_NOTFOUND);
               break;
            case RestorePasswordStatusEnum.MAIL_NOT_SEND:
               Main.writeVarsToConsoleChannel("USER MODEL","restorePasswordStatus: MAIL_NOT_SEND");
               this.loginForm.hideRestoreForm();
               this.showErrorWindow(Alert.ERROR_EMAIL_NOTSENDED);
         }
      }
      
      public function setLicenseText(clientObject:ClientObject, string:String) : void
      {
         Main.writeVarsToConsoleChannel("USER MODEL","setLicenseText: " + string);
         var tv:ViewText = new ViewText();
         this.layer.addChild(tv);
         tv.text = string;
      }
      
      public function setRulesText(clientObject:ClientObject, rules:String) : void
      {
         var tv:ViewText = new ViewText();
         this.layer.addChild(tv);
         tv.text = rules;
      }
      
      public function inviteFree(clientObject:ClientObject) : void
      {
         this.hideInviteWindow();
         this.afterInviteEnter();
      }
      
      public function inviteAlreadyActivated(clientObject:ClientObject, user:String) : void
      {
         this.hideInviteWindow();
         var storage:SharedObject = IStorageService(Main.osgi.getService(IStorageService)).getStorage();
         this.showWindow();
         this.state = this.STATE_LOGIN;
         this.loginForm.loginState = true;
         this.loginForm.callSign = user;
         this.loginForm.checkPassword.registerButton.enable = false;
         if(storage.data.rememberUserFlag)
         {
            this.loginForm.remember = storage.data.rememberUserFlag;
         }
      }
      
      public function inviteNotFound(clientObject:ClientObject) : void
      {
         this.inviteWindow.showInviteError();
      }
      
      public function nameUnique(clientObject:ClientObject, result:Boolean) : void
      {
         Main.writeVarsToConsoleChannel("USER MODEL","nameUnique result: %1",result);
         this.loginForm.registerForm.callSignState = !!result ? int(int(RegisterForm.CALLSIGN_STATE_VALID)) : int(int(RegisterForm.CALLSIGN_STATE_INVALID));
         this.isUnique = result;
      }
      
      private function showWindow() : void
      {
         Main.writeVarsToConsoleChannel("USER MODEL","showWindow");
         if(!this.layer.contains(this.loginForm))
         {
            this.layer.addChild(this.loginForm);
         }
         this.loginForm.addEventListener(LoginFormEvent.SHOW_TERMS,this.onShowTermsPressed);
         this.loginForm.addEventListener(LoginFormEvent.SHOW_RULES,this.onShowRulesPressed);
         this.loginForm.addEventListener(LoginFormEvent.CHANGE_STATE,this.onStateChanged);
         this.loginForm.addEventListener(LoginFormEvent.RESTORE_PRESSED,this.onLoginRestore);
         this.loginForm.checkPassword.restoreLink.addEventListener(MouseEvent.CLICK,this.onRestoreClick);
         this.loginForm.addEventListener(LoginFormEvent.PLAY_PRESSED,this.onPlayPressed);
         Main.writeVarsToConsoleChannel("USER MODEL","   callSign.addEventListener(LoginFormEvent.TEXT_CHANGED)");
         this.loginForm.registerForm.callSign.addEventListener(LoginFormEvent.TEXT_CHANGED,this.onCallsignChanged);
      }
      
      private function hideWindow() : void
      {
         Main.writeVarsToConsoleChannel("USER MODEL","hideWindow");
         if(this.layer.contains(this.loginForm))
         {
            this.layer.removeChild(this.loginForm);
         }
         this.loginForm.removeEventListener(LoginFormEvent.SHOW_TERMS,this.onShowTermsPressed);
         this.loginForm.removeEventListener(LoginFormEvent.SHOW_RULES,this.onShowRulesPressed);
         this.loginForm.removeEventListener(LoginFormEvent.CHANGE_STATE,this.onStateChanged);
         this.loginForm.removeEventListener(LoginFormEvent.RESTORE_PRESSED,this.onLoginRestore);
         this.loginForm.checkPassword.restoreLink.removeEventListener(MouseEvent.CLICK,this.onRestoreClick);
         this.loginForm.removeEventListener(LoginFormEvent.PLAY_PRESSED,this.onPlayPressed);
         Main.writeVarsToConsoleChannel("USER MODEL","   callSign.removeEventListener(LoginFormEvent.TEXT_CHANGED)");
         this.loginForm.registerForm.callSign.removeEventListener(LoginFormEvent.TEXT_CHANGED,this.onCallsignChanged);
      }
      
      private function onCallsignChanged(e:LoginFormEvent) : void
      {
         Main.writeVarsToConsoleChannel("USER MODEL","onCallsignChanged");
         if(this.checkCallsignTimer == null)
         {
            this.checkCallsignTimer = new Timer(this.checkCallsignDelay,1);
            this.checkCallsignTimer.addEventListener(TimerEvent.TIMER_COMPLETE,this.onCallsignCheckTimerComplete);
         }
         this.checkCallsignTimer.reset();
         this.checkCallsignTimer.start();
      }
      
      private function onCallsignCheckTimerComplete(e:TimerEvent) : void
      {
         Main.writeVarsToConsoleChannel("USER MODEL","onCallsignCheckTimerComplete");
         var pattern:RegExp = /^[a-z0-9](([\.\-\w](?!(-|_|\.){2,}))*[a-z0-9])?$/i;
         var result:Array = this.loginForm.registerForm.callSign.value.match(pattern);
         if(result != null)
         {
            this.loginForm.registerForm.callSignState = RegisterForm.CALLSIGN_STATE_PROGRESS;
            this.network.send("registration;check_name;" + this.loginForm.registerForm.callSign.value);
         }
         else
         {
            this.loginForm.registerForm.callSignState = RegisterForm.CALLSIGN_STATE_INVALID;
         }
      }
      
      private function showErrorWindow(alertType:int) : void
      {
         this.errorWindow = new Alert(alertType);
         if(!this.layer.contains(this.errorWindow))
         {
            this.layer.addChild(this.errorWindow);
            Main.stage.focus = this.errorWindow.closeButton;
         }
      }
      
      private function showBanWindow(reason:String) : void
      {
         this.errorWindow = new Alert(Alert.ERROR_BAN);
         this.errorWindow._msg = reason;
         if(!this.layer.contains(this.errorWindow))
         {
            this.clearDataAndExit();
            this.layer.addChild(this.errorWindow);
            Main.stage.focus = this.errorWindow.closeButton;
         }
      }
      
      private function clearDataAndExit() : void
      {
         var storage:SharedObject = IStorageService(Main.osgi.getService(IStorageService)).getStorage();
         storage.data.userHash = null;
         storage.data.up = null;
         storage.flush();
         if(this.inviteEnabled)
         {
            this.showInviteWindow();
         }
         else
         {
            this.afterInviteEnter();
         }
      }
      
      private function showInviteWindow() : void
      {
         if(!this.layer.contains(this.inviteWindow))
         {
            this.layer.addChild(this.inviteWindow);
            this.alignInviteWindow();
            Main.stage.addEventListener(Event.RESIZE,this.alignInviteWindow);
            this.inviteWindow.addEventListener(Event.COMPLETE,this.onInviteWindowComplete);
         }
      }
      
      private function hideInviteWindow() : void
      {
         if(this.layer.contains(this.inviteWindow))
         {
            this.layer.removeChild(this.inviteWindow);
            Main.stage.removeEventListener(Event.RESIZE,this.alignInviteWindow);
            this.inviteWindow.removeEventListener(Event.COMPLETE,this.onInviteWindowComplete);
         }
      }
      
      private function alignInviteWindow(e:Event = null) : void
      {
         this.inviteWindow.x = Math.round((Main.stage.stageWidth - this.inviteWindow.width) * 0.5);
         this.inviteWindow.y = Math.round((Main.stage.stageHeight - this.inviteWindow.height) * 0.5);
      }
      
      private function onInviteWindowComplete(e:Event) : void
      {
         this.network.send("auth;invite;" + this.inviteWindow.code);
      }
      
      private function onPlayPressed(e:LoginFormEvent) : void
      {
         var domen:String = null;
         var referalHash:String = null;
         switch(this.state)
         {
            case this.STATE_LOGIN:
               Main.writeVarsToConsoleChannel("USER MODEL","onPlayPressed STATE_LOGIN");
               Main.writeVarsToConsoleChannel("USER MODEL","   callSign: " + this.loginForm.callSign);
               Main.writeVarsToConsoleChannel("USER MODEL","   mainPassword: " + this.loginForm.mainPassword);
               this.loginByName(this.loginForm.callSign,this.loginForm.mainPassword,this.loginForm.remember,this.loginForm.checkPassword.captchaView == null ? "" : this.loginForm.checkPassword.captchaView.input.value);
               break;
            case this.STATE_REGISTER:
               Main.writeVarsToConsoleChannel("USER MODEL","onPlayPressed STATE_REGISTER");
               if(this.loginForm.callSign.length >= 2)
               {
                  if(this.not1stSimbols.indexOf(this.loginForm.callSign.charAt(0)) != -1)
                  {
                     this.showErrorWindow(Alert.ERROR_CALLSIGN_FIRST_SYMBOL);
                  }
                  else if(this.loginForm.callSign.indexOf("__") != -1 || this.loginForm.callSign.indexOf("--") != -1 || this.loginForm.callSign.indexOf("..") != -1)
                  {
                     this.showErrorWindow(Alert.ERROR_CALLSIGN_DEVIDE);
                  }
                  else if(this.not1stSimbols.indexOf(this.loginForm.callSign.charAt(this.loginForm.callSign.length - 1)) != -1)
                  {
                     this.showErrorWindow(Alert.ERROR_CALLSIGN_LAST_SYMBOL);
                  }
                  else if(this.loginForm.pass1.length < 2)
                  {
                     this.showErrorWindow(Alert.ERROR_PASSWORD_LENGTH);
                  }
                  else if(this.isUnique)
                  {
                     domen = this.addressService != null ? this.addressService.getBaseURL() : "";
                     referalHash = this.params != null ? this.params["friend"] : "";
                     this.registerUser(this.loginForm.callSign,this.loginForm.pass1,this.loginForm.email,this.loginForm.remember,true,this.loginForm.registerForm.captchaView == null ? "" : this.loginForm.registerForm.captchaView.input.value);
                  }
                  else
                  {
                     this.showErrorWindow(Alert.ERROR_CALLSIGN_UNIQUE);
                  }
               }
               else
               {
                  this.showErrorWindow(Alert.ERROR_CALLSIGN_LENGTH);
               }
         }
      }
      
      private function loginByName(login:String, password:String, remember:Boolean, captcha:String) : void
      {
         var userInfo:String = login + ";" + password + ";";
         if(captcha != null && captcha != "")
         {
            userInfo += captcha;
         }
         this.network.send("auth;" + userInfo);
      }
      
      private function registerUser(name:String, password:String, email:String, remember:Boolean, sentNews:Boolean, captcha:String) : void
      {
         var userInfo:String = name + ";" + password + ";";
         var storage:SharedObject = Main.osgi.getService(IStorageService).getStorage() as SharedObject;
         if(storage.data.emailUser == null)
         {
            storage.setProperty("emailUser",email);
         }
         if(captcha != null && captcha != "")
         {
            userInfo += captcha;
         }
         this.network.send("registration;" + userInfo);
      }
      
      private function onStateChanged(e:LoginFormEvent) : void
      {
         if(this.loginForm.loginState)
         {
            this.state = this.STATE_LOGIN;
            if(this.addressService != null)
            {
            }
            this.network.send("auth;state");
         }
         else
         {
            this.state = this.STATE_REGISTER;
            if(this.addressService != null)
            {
               if(this.loaderParamsService.params["partner"] != null)
               {
                  this.addressService.setValue("registration/partner=" + this.loaderParamsService.params["partner"]);
               }
               else
               {
                  this.addressService.setValue("registration");
               }
            }
            this.network.send("registration;state");
         }
         Main.writeVarsToConsoleChannel("USER MODEL","onStateChanged: " + this.state);
      }
      
      private function onShowTermsPressed(e:LoginFormEvent) : void
      {
      }
      
      private function onShowRulesPressed(e:LoginFormEvent) : void
      {
      }
      
      private function onRestoreClick(e:MouseEvent) : void
      {
         Main.writeVarsToConsoleChannel("USER MODEL","onRestoreClick");
         this.state = this.STATE_RESTORE_PASSWORD;
         this.loginForm.showRestoreForm();
         this.network.send("auth;restore_state");
      }
      
      private function onLoginRestore(e:LoginFormEvent) : void
      {
         Main.writeVarsToConsoleChannel("USER MODEL","onLoginRestore");
         Main.writeVarsToConsoleChannel("USER MODEL","restoreEmail: " + this.loginForm.restoreEmail);
         this.restorePassword(this.loginForm.restoreEmail);
      }
      
      private function restorePassword(email:String) : void
      {
         if(email == null || email == "")
         {
            return;
         }
         Network(Main.osgi.getService(INetworker)).send("auth;recovery_account;" + email + ";" + this.loginForm._restoreEmailForm.captchaView.input.value);
      }
      
      private function onCancelPassAndEmailPressed(event:ChangePasswordAndEmailEvent) : void
      {
         this.changeEmailAndPasswordWindow.removeEventListener(ChangePasswordAndEmailEvent.CANCEL_PRESSED,this.onCancelPassAndEmailPressed);
         this.changeEmailAndPasswordWindow.removeEventListener(ChangePasswordAndEmailEvent.CHANGE_PRESSED,this.onChangePassAndEmailPressed);
         this.layer.removeChild(this.changeEmailAndPasswordWindow);
         this.enter();
      }
      
      private function onChangePassAndEmailPressed(event:ChangePasswordAndEmailEvent) : void
      {
         this.changePasswordAndEmail(this.changeEmailAndPasswordWindow.passwordRepeate,this.changeEmailAndPasswordWindow.email);
      }
      
      private function changePasswordAndEmail(pass:String, email:String) : void
      {
         Network(Main.osgi.getService(INetworker)).send("auth;change_pass_email;" + pass + ";" + email);
      }
      
      private function allignChangeEmailAndPasswordWindow(event:Event) : void
      {
         this.changeEmailAndPasswordWindow.x = Math.round((Main.stage.stageWidth - this.changeEmailAndPasswordWindow.width) * 0.5);
         this.changeEmailAndPasswordWindow.y = Math.round((Main.stage.stageHeight - this.changeEmailAndPasswordWindow.height) * 0.5) - 10;
      }
      
      public function setPasswordChangeResult(clientObject:ClientObject, result:Boolean, text:String) : void
      {
         var passChangeAlert:Alert = null;
         var passChangeFailureAlert:Alert = null;
         if(result == true)
         {
            if(this.layer.contains(this.changeEmailAndPasswordWindow))
            {
               this.changeEmailAndPasswordWindow.removeEventListener(ChangePasswordAndEmailEvent.CANCEL_PRESSED,this.onCancelPassAndEmailPressed);
               this.changeEmailAndPasswordWindow.removeEventListener(ChangePasswordAndEmailEvent.CHANGE_PRESSED,this.onChangePassAndEmailPressed);
               this.layer.removeChild(this.changeEmailAndPasswordWindow);
               passChangeAlert = new Alert();
               passChangeAlert.showAlert(text,[AlertAnswer.OK]);
               this.layer.addChild(passChangeAlert);
               passChangeAlert.addEventListener(AlertEvent.ALERT_BUTTON_PRESSED,this.onChangePasswordAndEmailAlertPressed);
            }
         }
         else
         {
            passChangeFailureAlert = new Alert();
            passChangeFailureAlert.showAlert(text,[AlertAnswer.OK]);
            this.layer.addChild(passChangeFailureAlert);
         }
      }
      
      private function onChangePasswordAndEmailAlertPressed(e:Event) : void
      {
         this.enter();
      }
      
      public function serverIsRestarting(clientObject:ClientObject) : void
      {
         this.errorWindow = new Alert();
         this.errorWindow.showAlert(this.localeService.getText(TextConst.SERVER_IS_RESTARTING_LOGIN_TEXT),[AlertAnswer.OK]);
         if(!Main.noticesLayer.contains(this.errorWindow))
         {
            Main.noticesLayer.addChild(this.errorWindow);
            Main.stage.focus = this.errorWindow.closeButton;
         }
      }
      
      public function youWereKicked(clientObject:ClientObject) : void
      {
         this.errorWindow = new Alert();
         this.errorWindow.showAlert("кик нахуй",[AlertAnswer.OK]);
         if(!Main.noticesLayer.contains(this.errorWindow))
         {
            Main.noticesLayer.addChild(this.errorWindow);
            Main.stage.focus = this.errorWindow.closeButton;
         }
      }
   }
}
