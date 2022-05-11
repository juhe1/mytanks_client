package alternativa.tanks.model.panel
{
   import alternativa.init.Main;
   import alternativa.model.IModel;
   import alternativa.model.IObjectLoadListener;
   import alternativa.object.ClientObject;
   import alternativa.osgi.service.alert.IAlertService;
   import alternativa.osgi.service.locale.ILocaleService;
   import alternativa.osgi.service.mainContainer.IMainContainerService;
   import alternativa.osgi.service.storage.IStorageService;
   import alternativa.service.IModelService;
   import alternativa.tanks.JPGencoder.JPGEncoder;
   import alternativa.tanks.config.TanksMap;
   import alternativa.tanks.gui.BugReportWindow;
   import alternativa.tanks.gui.NewReferalWindow;
   import alternativa.tanks.gui.PaymentWindow;
   import alternativa.tanks.gui.PaymentWindowEvent;
   import alternativa.tanks.gui.ReferalWindowEvent;
   import alternativa.tanks.gui.SettingsWindow;
   import alternativa.tanks.gui.SettingsWindowEvent;
   import alternativa.tanks.gui.SocialNetworksWindow;
   import alternativa.tanks.gui.ThanksForPurchaseWindow;
   import alternativa.tanks.help.ButtonBarHelper;
   import alternativa.tanks.help.IHelpService;
   import alternativa.tanks.help.MainMenuHelper;
   import alternativa.tanks.help.MoneyHelper;
   import alternativa.tanks.help.RankBarHelper;
   import alternativa.tanks.help.RankHelper;
   import alternativa.tanks.help.RatingIndicatorHelper;
   import alternativa.tanks.help.ScoreHelper;
   import alternativa.tanks.loader.ILoaderWindowService;
   import alternativa.tanks.locale.constants.TextConst;
   import alternativa.tanks.model.BattleSelectModel;
   import alternativa.tanks.model.GarageModel;
   import alternativa.tanks.model.IGarage;
   import alternativa.tanks.model.achievement.AchievementModel;
   import alternativa.tanks.model.achievement.IAchievementModel;
   import alternativa.tanks.model.antiaddiction.IAntiAddictionAlert;
   import alternativa.tanks.model.challenge.ChallengeCongratulationWindow;
   import alternativa.tanks.model.payment.IPayment;
   import alternativa.tanks.model.payment.IPaymentListener;
   import alternativa.tanks.model.profile.UserGiftsView;
   import alternativa.tanks.model.referals.IReferals;
   import alternativa.tanks.model.referals.IReferalsListener;
   import alternativa.tanks.model.shop.ShopModel;
   import alternativa.tanks.model.tempdiscount.TempDiscountWindow;
   import alternativa.tanks.models.battlefield.BattlefieldModel;
   import alternativa.tanks.models.battlefield.IBattleField;
   import alternativa.tanks.models.battlefield.StatisticsModel;
   import alternativa.tanks.models.battlefield.gui.IBattlefieldGUI;
   import alternativa.tanks.models.battlefield.gui.chat.ChatModel;
   import alternativa.tanks.models.battlefield.inventory.InventoryModel;
   import alternativa.tanks.models.ctf.CTFModel;
   import alternativa.tanks.models.dom.DOMModel;
   import alternativa.tanks.models.dom.IDOMModel;
   import alternativa.tanks.models.inventory.IInventory;
   import alternativa.tanks.service.money.IMoneyListener;
   import alternativa.tanks.service.money.IMoneyService;
   import com.alternativaplatform.projects.tanks.client.models.ctf.ICaptureTheFlagModelBase;
   import controls.PlayerInfo;
   import controls.Rank;
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.DisplayObject;
   import flash.display.DisplayObjectContainer;
   import flash.display.Shape;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.events.TimerEvent;
   import flash.filters.BitmapFilterQuality;
   import flash.filters.BlurFilter;
   import flash.geom.Point;
   import flash.media.SoundMixer;
   import flash.media.SoundTransform;
   import flash.net.SharedObject;
   import flash.net.URLRequest;
   import flash.net.navigateToURL;
   import flash.utils.Timer;
   import forms.Alert;
   import forms.AlertAnswer;
   import forms.MainPanel;
   import forms.ServerRedirectAlert;
   import forms.ServerStopAlert;
   import forms.events.AlertEvent;
   import forms.events.MainButtonBarEvents;
   import forms.friends.FriendsWindow;
   import projects.tanks.client.battleselect.IBattleSelectModelBase;
   import projects.tanks.client.panel.model.IPanelModelBase;
   import projects.tanks.client.panel.model.PanelModelBase;
   import projects.tanks.client.panel.model.referals.IReferalsModelBase;
   import projects.tanks.client.panel.model.referals.ReferalsModelBase;
   import scpacker.gui.ConfirmEmailCode;
   import scpacker.gui.GTanksLoaderWindow;
   import scpacker.gui.IGTanksLoader;
   import scpacker.gui.RecoveryWindow;
   import scpacker.networking.INetworker;
   import scpacker.networking.Network;
   import scpacker.tanks.WeaponsManager;
   import scpacker.test.UpdateRankLabel;
   
   public class PanelModel extends PanelModelBase implements IPanelModelBase, IObjectLoadListener, IPanel, IPaymentListener, IMoneyService, IBattleSettings, IReferalsListener
   {
      
      private static const PARAM_SHOW_SKY_BOX:String = "showSkyBox";
      
      private static const PARAM_SHOW_FPS:String = "showFPS";
      
      private static const PARAM_SHOW_BATTLE_CHAT:String = "showBattleChat";
      
      private static const PARAM_ADAPTIVE_FPS:String = "adaptiveFPS";
      
      private static const PARAM_INVERSE_BACK_DRIVING:String = "inverseBackDriving";
      
      private static const PARAM_BGSOUND:String = "bgSound";
      
      private static const PARAM_MUTE_SOUND:String = "muteSound";
      
      private static const PARAM_SOUND_VOLUME:String = "volume";
      
      private static const PARAM_MIPMAPPING:String = "mipMapping";
      
      private static const PARAM_FOG:String = "fog";
      
      private static const PARAM_DUST:String = "dust";
      
      private static const SHADOWS:String = "shadows";
      
      private static const DEFFERED_LIGHTING:String = "defferedLighting";
      
      private static const ANIMATED_TRACKS:String = "animatedTracks";
      
      private static const ANIMATED_DAMAGE:String = "animatedDamage";
      
      private static const SHADOW_UNDER_TANKS:String = "shadowUnderTanks";
      
      private static const COLORED_FPS:String = "COLORED_FPS";
      
      private static const PARAM_SSAO:String = "SSAO";
      
      private static const HELPER_GROUP_KEY:String = "PanelModel";
      
      private static const DEFAULT_VOLUME:Number = 0.7;
       
      
      private var modelRegister:IModelService;
      
      private var storage:SharedObject;
      
      private var clientObject:ClientObject;
      
      private var layer:DisplayObjectContainer;
      
      private var dialogsLayer:DisplayObjectContainer;
      
      private var loaderWindow:ILoaderWindowService;
      
      public var mainPanel:MainPanel;
      
      private var kills:int;
      
      private var deaths:int;
      
      private var screenShot:BitmapData;
      
      private var cropedScreenshot:BitmapData;
      
      private var screenPixelCurrentNum:int;
      
      private var reportWindow:BugReportWindow;
      
      private var settingsWindow:SettingsWindow;
      
      private var paymentWindow:PaymentWindow;
      
      private var referalWindow:NewReferalWindow;
      
      private var socialNetsWindow:SocialNetworksWindow;
      
      private var discountWindow:TempDiscountWindow;
      
      private var shopModel:ShopModel;
      
      private var giftsWindow:UserGiftsView;
      
      private var friendsWindow:FriendsWindow;
      
      private var challegneCongratsWindow:ChallengeCongratulationWindow;
      
      private var purchaseWindow:ThanksForPurchaseWindow;
      
      private var encoder:JPGEncoder;
      
      private var encodeInt:uint;
      
      private var encodeDelay:int = 5;
      
      private var _userName:String;
      
      private var userRank:int;
      
      private var startRating:Number;
      
      private var _crystal:int;
      
      private var emailConfirmed:Boolean;
      
      private var bg:Shape;
      
      private const HELPER_RANK:int = 1;
      
      private const HELPER_RANK_BAR:int = 2;
      
      private const HELPER_RATING_INDICATOR:int = 3;
      
      private const HELPER_MAIN_MENU:int = 5;
      
      private const HELPER_BUTTON_BAR:int = 6;
      
      private const HELPER_MONEY:int = 7;
      
      private const HELPER_SCORE:int = 10;
      
      private var moneyListeners:Array;
      
      private var rankHelper:RankHelper;
      
      private var rankBarHelper:RankBarHelper;
      
      private var ratingHelper:RatingIndicatorHelper;
      
      private var mainMenuHelper:MainMenuHelper;
      
      private var buttonBarHelper:ButtonBarHelper;
      
      private var moneyHelper:MoneyHelper;
      
      private var scoreHelper:ScoreHelper;
      
      private var blurBmp:Bitmap;
      
      private var blurBmpContainer:Sprite;
      
      private var blured:Boolean;
      
      private var stopAlert:ServerStopAlert;
      
      private var score:int;
      
      private var nextScore:int;
      
      private var isTester:Boolean;
      
      private var email:String;
      
      private var showRedirectAlertTimer:Timer;
      
      private var redirectAlert:ServerRedirectAlert;
      
      private var serverToRedirectTo:String;
      
      public var isBattleSelect:Boolean = true;
      
      public var isGarageSelect:Boolean = false;
      
      public var isInBattle:Boolean = false;
      
      public var panelListeners:Vector.<IModel>;
      
      private var localeService:ILocaleService;
      
      private var networker:Network;
      
      private var overlay:Sprite;
      
      public function PanelModel()
      {
         this.panelListeners = new Vector.<IModel>();
         this.overlay = new Sprite();
         super();
         _interfaces.push(IModel,IPanel,IPanelModelBase,IObjectLoadListener,IPaymentListener,IReferalsListener);
         this.modelRegister = Main.osgi.getService(IModelService) as IModelService;
         this.dialogsLayer = (Main.osgi.getService(IMainContainerService) as IMainContainerService).dialogsLayer as DisplayObjectContainer;
         this.localeService = Main.osgi.getService(ILocaleService) as ILocaleService;
         this.layer = Main.contentUILayer;
         this.mainPanel = new MainPanel();
         this.shopModel = new ShopModel();
         this.loaderWindow = Main.osgi.getService(ILoaderWindowService) as ILoaderWindowService;
         this.bg = new Shape();
         this.blurBmpContainer = new Sprite();
         this.blurBmp = new Bitmap();
         this.blurBmpContainer.addChild(this.blurBmp);
         this.blurBmpContainer.mouseEnabled = true;
         this.blurBmpContainer.filters = new Array(new BlurFilter(5,5,BitmapFilterQuality.LOW));
         this.blured = false;
      }
      
      public function initObject(clientObject:ClientObject, crystal:int, email:String, isTester:Boolean, name:String, nextScore:int, place:int, rang:int, rating:Number, score:int, haveDoubleCrystalls:*) : void
      {
         this.isTester = isTester;
         this.email = email;
         this.showPanel();
         this.storage = IStorageService(Main.osgi.getService(IStorageService)).getStorage();
         if(this.storage == null)
         {
            throw new Error("storage is null");
         }
         this.storage.data.userRank = rang;
         this.storage.flush();
         this.nextScore = nextScore;
         this.userRank = rang;
         this.mainPanel.rang = rang;
         this.mainPanel.isTester = isTester;
         this._userName = name;
         var info:PlayerInfo = this.mainPanel.playerInfo;
         info.playerName = name;
         this._crystal = crystal;
         info.crystals = crystal;
         info.position = place + 1;
         info.rating = rating;
         info.updateScore(score,nextScore);
         this.startRating = rating;
         this.lock();
         Main.writeVarsToConsoleChannel("PANEL MODEL","долбаная панель загрузилась!.. я тестер? - %1",isTester);
         this.objectLoaded(clientObject);
      }
      
      public function objectLoaded(object:ClientObject) : void
      {
         this.networker = Network(Main.osgi.getService(INetworker));
         this.clientObject = object;
         this.moneyListeners = new Array();
         Main.osgi.registerService(IMoneyService,this);
         this.setSoundSettings();
         this.mainPanel.buttonBar.soundOn = !this.getSoundMute();
         var helpService:IHelpService = Main.osgi.getService(IHelpService) as IHelpService;
         this.rankHelper = new RankHelper();
         this.rankBarHelper = new RankBarHelper();
         this.ratingHelper = new RatingIndicatorHelper();
         this.mainMenuHelper = new MainMenuHelper();
         this.buttonBarHelper = new ButtonBarHelper();
         this.moneyHelper = new MoneyHelper();
         this.scoreHelper = new ScoreHelper();
         this.unlock();
         helpService.registerHelper(HELPER_GROUP_KEY,this.HELPER_RANK,this.rankHelper,true);
         helpService.registerHelper(HELPER_GROUP_KEY,this.HELPER_RANK_BAR,this.rankBarHelper,true);
         helpService.registerHelper(HELPER_GROUP_KEY,this.HELPER_RATING_INDICATOR,this.ratingHelper,true);
         helpService.registerHelper(HELPER_GROUP_KEY,this.HELPER_MAIN_MENU,this.mainMenuHelper,true);
         helpService.registerHelper(HELPER_GROUP_KEY,this.HELPER_BUTTON_BAR,this.buttonBarHelper,true);
         helpService.registerHelper(HELPER_GROUP_KEY,this.HELPER_SCORE,this.scoreHelper,true);
      }
      
      private function setSoundSettings() : void
      {
         SoundMixer.soundTransform = new SoundTransform(!!this.getSoundMute() ? Number(Number(0)) : Number(Number(this.getSoundVolume())));
      }
      
      private function getSoundMute() : Boolean
      {
         return this.getBoolean(PARAM_MUTE_SOUND,false);
      }
      
      private function getSoundVolume() : Number
      {
         return this.getNumber(PARAM_SOUND_VOLUME,DEFAULT_VOLUME);
      }
      
      private function removeDisplayObject(displayObect:DisplayObject) : void
      {
         if(displayObect != null && displayObect.parent != null)
         {
            displayObect.parent.removeChild(displayObect);
         }
      }
      
      public function objectUnloaded(object:ClientObject) : void
      {
         Main.writeToConsole("PanelModel objectUnloaded");
         this.unblur();
         this.mainPanel.hide();
         this.hidePanel();
         this.removeDisplayObject(this.settingsWindow);
         this.removeDisplayObject(this.reportWindow);
         this.removeDisplayObject(this.referalWindow);
         this.removeDisplayObject(this.paymentWindow);
         var helpService:IHelpService = Main.osgi.getService(IHelpService) as IHelpService;
         helpService.hideHelp();
         helpService.unregisterHelper(HELPER_GROUP_KEY,this.HELPER_RANK);
         helpService.unregisterHelper(HELPER_GROUP_KEY,this.HELPER_RANK_BAR);
         helpService.unregisterHelper(HELPER_GROUP_KEY,this.HELPER_RATING_INDICATOR);
         helpService.unregisterHelper(HELPER_GROUP_KEY,this.HELPER_MAIN_MENU);
         helpService.unregisterHelper(HELPER_GROUP_KEY,this.HELPER_BUTTON_BAR);
         helpService.unregisterHelper(HELPER_GROUP_KEY,this.HELPER_SCORE);
         this.rankHelper = null;
         this.rankBarHelper = null;
         this.ratingHelper = null;
         this.mainMenuHelper = null;
         this.buttonBarHelper = null;
         this.moneyHelper = null;
         this.scoreHelper = null;
         this.moneyListeners = null;
         Main.osgi.unregisterService(IMoneyService);
         this.clientObject = null;
      }
      
      public function goToGarage() : void
      {
      }
      
      public function showGarage(obj:Object) : void
      {
         var battle:BattleSelectModel = null;
         var alert:Alert = null;
         if(!this.isInBattle)
         {
            Network(Main.osgi.getService(INetworker)).send("lobby;get_garage_data");
         }
         if(this.isBattleSelect)
         {
            battle = BattleSelectModel(Main.osgi.getService(IBattleSelectModelBase));
            battle.objectUnloaded(null);
            this.isBattleSelect = false;
            Main.osgi.unregisterService(IBattleSelectModelBase);
         }
         else if(this.isInBattle)
         {
            this.blur();
            alert = new Alert();
            alert.showAlert("Покинуть битву? Очки и кристальный фонд будет потеряны.",[AlertAnswer.YES,AlertAnswer.NO]);
            this.dialogsLayer.addChild(alert);
            alert.addEventListener(AlertEvent.ALERT_BUTTON_PRESSED,function(ae:AlertEvent):void
            {
               if(ae.typeButton == localeService.getText(TextConst.ALERT_ANSWER_YES))
               {
                  onExitFromBattle();
                  Network(Main.osgi.getService(INetworker)).send("lobby;get_garage_data");
                  isInBattle = false;
                  isGarageSelect = true;
                  (Main.osgi.getService(IGTanksLoader) as GTanksLoaderWindow).unlockLoaderWindow();
                  (Main.osgi.getService(IGTanksLoader) as GTanksLoaderWindow).addProgress(99);
               }
               else
               {
                  mainPanel.buttonBar.garageButton.enable = true;
                  unlock();
               }
               unblur();
            });
            return;
         }
         (Main.osgi.getService(IGTanksLoader) as GTanksLoaderWindow).unlockLoaderWindow();
         (Main.osgi.getService(IGTanksLoader) as GTanksLoaderWindow).addProgress(99);
      }
      
      public function onExitFromBattle(sendToServer:Boolean = true) : void
      {
         var o:* = undefined;
         var bfModel:BattlefieldModel = BattlefieldModel(Main.osgi.getService(IBattleField));
         var map:TanksMap = bfModel.getConfig().map;
         map.mapContainer.destroyTree();
         map.mapContainer.destroy();
         map.destroy();
         map = null;
         bfModel.objectUnloaded(null);
         if(bfModel.toDestroy.length > 1)
         {
            for each(o in bfModel.toDestroy)
            {
               if(o != null)
               {
                  if(bfModel.blacklist.indexOf(o) == -1)
                  {
                     o.destroy(true);
                     o = null;
                  }
               }
            }
            bfModel.toDestroy = new Vector.<Object>();
         }
         BattleController(Main.osgi.getService(IBattleController)).destroy();
         StatisticsModel(Main.osgi.getService(IBattlefieldGUI)).objectUnloaded(null);
         Network(Main.osgi.getService(INetworker)).removeListener(Main.osgi.getService(IBattleController) as BattleController);
         ChatModel(Main.osgi.getService(IChatBattle)).objectUnloaded(null);
         WeaponsManager.destroy();
         var ctfModel:CTFModel = Main.osgi.getService(ICaptureTheFlagModelBase) as CTFModel;
         if(ctfModel != null)
         {
            ctfModel.objectUnloaded(null);
            Main.osgi.unregisterService(ICaptureTheFlagModelBase);
         }
         var domModel:DOMModel = Main.osgi.getService(IDOMModel) as DOMModel;
         if(domModel != null)
         {
            domModel.objectUnloaded(null);
            Main.osgi.unregisterService(IDOMModel);
         }
         var modelsService:IModelService = IModelService(Main.osgi.getService(IModelService));
         var inventoryModel:InventoryModel = InventoryModel(modelsService.getModelsByInterface(IInventory)[0]);
         if(inventoryModel != null)
         {
            inventoryModel.objectUnloaded(null);
         }
         this.isInBattle = false;
         this.networker.send("battle;i_exit_from_battle");
      }
      
      public function goToPayment() : void
      {
      }
      
      public function serverHalt(clientObject:ClientObject, timeBeforeRestart:int, delayBeforShowRedirectMessage:int, redirectMessageIdle:int, serverToRedirectTo:String) : void
      {
         if(serverToRedirectTo != null && serverToRedirectTo != "null")
         {
            this.serverToRedirectTo = serverToRedirectTo;
            this.redirectAlert = new ServerRedirectAlert(redirectMessageIdle);
            this.dialogsLayer.addChild(this.redirectAlert);
            this.showRedirectAlertTimer = new Timer(redirectMessageIdle * 1000,1);
            this.showRedirectAlertTimer.addEventListener(TimerEvent.TIMER_COMPLETE,this.hideRedirectAlert);
            this.showRedirectAlertTimer.start();
            this.alignRedirectAlert();
            Main.stage.addEventListener(Event.RESIZE,this.alignRedirectAlert);
         }
         else
         {
            this.stopAlert = new ServerStopAlert(timeBeforeRestart);
            this.dialogsLayer.addChild(this.stopAlert);
            this.alignStopAlert();
            Main.stage.addEventListener(Event.RESIZE,this.alignStopAlert);
         }
      }
      
      private function hideRedirectAlert(e:TimerEvent) : void
      {
         Main.stage.removeEventListener(Event.RESIZE,this.alignRedirectAlert);
         this.dialogsLayer.removeChild(this.redirectAlert);
         var lang:String = (Main.osgi.getService(ILocaleService) as ILocaleService).language;
         if(lang == null)
         {
            lang = "en";
         }
         navigateToURL(new URLRequest("http://tankionline.com/battle-" + lang + this.serverToRedirectTo.toString() + ".html"),"_self");
      }
      
      private function alignRedirectAlert(e:Event = null) : void
      {
         this.redirectAlert.x = Math.round((Main.stage.stageWidth - this.redirectAlert.width) * 0.5);
         this.redirectAlert.y = Math.round((Main.stage.stageHeight - this.redirectAlert.height) * 0.5);
      }
      
      private function alignStopAlert(e:Event = null) : void
      {
         this.stopAlert.x = Math.round((Main.stage.stageWidth - this.stopAlert.width) * 0.5);
         this.stopAlert.y = Math.round((Main.stage.stageHeight - this.stopAlert.height) * 0.5);
      }
      
      public function showMessage(clientObject:ClientObject, text:String) : void
      {
         this._showMessage(text);
      }
      
      public function _showMessage(text:String) : void
      {
         var alert:Alert = new Alert();
         alert.showAlert(text,[AlertAnswer.OK]);
         this.dialogsLayer.addChild(alert);
      }
      
      public function updateRating(clientObject:ClientObject, rating:Number) : void
      {
         var info:PlayerInfo = this.mainPanel.playerInfo;
         if(this.startRating < rating)
         {
            info.ratingChange = 1;
         }
         else if(this.startRating > rating)
         {
            info.ratingChange = -1;
         }
         else
         {
            info.ratingChange = 0;
         }
         info.rating = rating;
         this.mainPanel.onResize(null);
      }
      
      public function updatePlace(clientObject:ClientObject, place:int) : void
      {
         var info:PlayerInfo = this.mainPanel.playerInfo;
         info.position = place + 1;
         this.mainPanel.onResize(null);
      }
      
      public function updateRang(clientObject:ClientObject, rang:int, nextScore:int) : void
      {
         var prevRang:* = this.mainPanel.rang;
         this.mainPanel.rang = rang;
         this.userRank = rang;
         this.nextScore = nextScore;
         this.mainPanel.playerInfo.updateScore(this.score,nextScore);
         if(prevRang != rang)
         {
            Main.contentUILayer.addChild(new UpdateRankLabel(Rank.name(rang),rang));
         }
         this.mainPanel.onResize(null);
      }
      
      public function updateScore(clientObject:ClientObject, score:int) : void
      {
         this.score = score;
         this.mainPanel.playerInfo.updateScore(score,this.nextScore);
         this.mainPanel.onResize(null);
      }
      
      public function updateKills(clientObject:ClientObject, kills:int) : void
      {
         this.kills = kills;
      }
      
      public function updateDeaths(clientObject:ClientObject, deaths:int) : void
      {
         this.deaths = deaths;
      }
      
      public function updateCrystal(clientObject:ClientObject, crystal:int) : void
      {
         var listener:IMoneyListener = null;
         var info:PlayerInfo = this.mainPanel.playerInfo;
         this.mainPanel.onResize(null);
         info.crystals = crystal;
         this._crystal = crystal;
         for(var i:int = 0; i < this.moneyListeners.length; i++)
         {
            listener = this.moneyListeners[i] as IMoneyListener;
            listener.crystalsChanged(crystal);
         }
         this.mainPanel.onResize(null);
      }
      
      public function updateRankProgress(clientObject:ClientObject, position:int) : void
      {
         Main.writeVarsToConsoleChannel("PANEL MODEL","updateRankProgress: %1",position);
         var info:PlayerInfo = this.mainPanel.playerInfo;
         info.progress = position;
         this.mainPanel.onResize(null);
      }
      
      public function openProfile(clientObject:ClientObject, emailNotice:Boolean, isConfirmEmail:Boolean, antiAddictionEnabled:Boolean, realName:String, idNumber:String) : void
      {
         var listener:IPanelListener = null;
         this.emailConfirmed = isConfirmEmail;
         this.blur();
         this.settingsWindow = new SettingsWindow(this.userEmail,this.emailConfirmed,antiAddictionEnabled,realName,idNumber);
         this.dialogsLayer.addChild(this.settingsWindow);
         this.settingsWindow.showSkyBox = this.showSkyBox;
         this.settingsWindow.showFPS = this.showFPS;
         this.settingsWindow.showBattleChat = this.showBattleChat;
         this.settingsWindow.adaptiveFPS = this.adaptiveFPS;
         this.settingsWindow.enableMipMapping = this.enableMipMapping;
         this.settingsWindow.volume = this.getSoundVolume();
         this.settingsWindow.inverseBackDriving = this.inverseBackDriving;
         this.settingsWindow.bgSound = this.bgSound;
         this.settingsWindow.useDust = this.useDust;
         this.settingsWindow.useShadows = this.shadows;
         this.settingsWindow.useDefferedLighting = this.defferedLighting;
         this.settingsWindow.useAnimatedTracks = this.animationTracks;
         this.settingsWindow.useAnimatedDamage = this.animationDamage;
         this.settingsWindow.showShadowsTank = this.shadowUnderTanks;
         this.settingsWindow.coloredFPS = this.coloredFPS;
         if(this.settingsWindow.isPasswordChangeDisabled)
         {
            this.settingsWindow.addEventListener(SettingsWindowEvent.CHANGE_PASSWORD,this.onChangePassword);
         }
         this.settingsWindow.addEventListener(SettingsWindowEvent.CANCEL_SETTINGS,this.onSettingsCancel);
         this.settingsWindow.addEventListener(SettingsWindowEvent.ACCEPT_SETTINGS,this.onSettingsComplete);
         this.settingsWindow.addEventListener(SettingsWindowEvent.RESEND_CONFIRMATION,this.onConfirmEmail);
         this.settingsWindow.addEventListener(SettingsWindowEvent.CHANGE_VOLUME,this.onChangeVolume);
         Main.stage.addEventListener(Event.RESIZE,this.alignSettingsWindow);
         this.alignSettingsWindow();
         this.unlock();
         var listeners:Vector.<IModel> = this.modelRegister.getModelsByInterface(IPanelListener);
         if(listeners != null)
         {
            for each(listener in listeners)
            {
               listener.settingsOpened();
            }
         }
         (Main.osgi.getService(IAchievementModel) as AchievementModel).changeSwitchPanelStateEnd(MainButtonBarEvents.SETTINGS);
      }
      
      private function onChangePassword(event:SettingsWindowEvent) : void
      {
         if(this.settingsWindow.isPasswordChangeDisabled)
         {
            Network(Main.osgi.getService(INetworker)).send("lobby;generate_key_email");
            this.dialogsLayer.addChild(new ConfirmEmailCode(this.localeService.getText(TextConst.ACCOUNT_RECOVERY_FORM_ENTER_CODE),this.onEnterRecoveryCode));
         }
      }
      
      private function onEnterRecoveryCode(code:String) : void
      {
         Network(Main.osgi.getService(INetworker)).send("lobby;confirm_email_code_recovery;" + code);
      }
      
      public function updatePasswordError(clientObject:ClientObject) : void
      {
         this.dialogsLayer.addChild(new Alert(Alert.ERROR_PASSWORD_CHANGE));
      }
      
      public function changeEmailError(clientObject:ClientObject) : void
      {
      }
      
      public function openPayment(clientObject:ClientObject) : void
      {
         this.openPaymentWindow();
         (Main.osgi.getService(ILoaderWindowService) as ILoaderWindowService).hideLoaderWindow();
         this.partSelected(3);
      }
      
      public function closePayment(clientObject:ClientObject) : void
      {
         this.closePaymentWindow();
      }
      
      public function openRefererPanel(clientObject:ClientObject, referalsCount:int, hashUser:String, banner:String, inviteMessageTemplate:String) : void
      {
         Main.writeVarsToConsoleChannel("PANEL MODEL","S -> C openRefererPanel");
         this.blur();
         var url:String = "http://" + this.localeService.getText(TextConst.GAME_BASE_URL) + "#friend=" + hashUser;
         var referalModel:IReferals = (this.modelRegister.getModelsByInterface(IReferals) as Vector.<IModel>)[0] as IReferals;
         this.referalWindow = new NewReferalWindow(hashUser,banner,url,inviteMessageTemplate);
         this.dialogsLayer.addChild(this.referalWindow);
         referalModel.getReferalsData();
         this.referalWindow.addEventListener(ReferalWindowEvent.SEND_MAIL,this.sendInvitation);
         this.referalWindow.closeButton.addEventListener(MouseEvent.CLICK,this.closeRefererPanel);
         Main.stage.addEventListener(Event.RESIZE,this.alignReferalWindow);
         this.alignReferalWindow();
         this.unlock();
      }
      
      public function startBattle(clientObject:ClientObject) : void
      {
         this.isBattleSelect = false;
         Main.writeVarsToConsoleChannel("PANEL MODEL","startBattle");
         this.mainPanel.buttonBar.battlesButton.enable = true;
         this.lock();
         (Main.osgi.getService(IGTanksLoader) as GTanksLoaderWindow).setProgress(0);
         (Main.osgi.getService(IGTanksLoader) as GTanksLoaderWindow).setProgress(300);
         (Main.osgi.getService(IAchievementModel) as AchievementModel).onEnterInBattle();
      }
      
      public function setInviteSendResult(sentSuccessfuly:Boolean, errorMessage:String) : void
      {
         if(sentSuccessfuly)
         {
            this._showMessage(this.localeService.getText(TextConst.INVITATION_HAS_BEEN_SENT_ALERT_TEXT));
            this.referalWindow.clearRecipientInputField();
         }
         else
         {
            this._showMessage(errorMessage);
         }
      }
      
      public function partSelected(partIndex:int) : void
      {
         Main.writeVarsToConsoleChannel("PANEL MODEL","partSelected: " + partIndex);
         if(this.mainPanel != null)
         {
            switch(partIndex)
            {
               case 0:
                  this.mainPanel.buttonBar.battlesButton.enable = false;
                  this.mainPanel.buttonBar.garageButton.enable = true;
                  this.mainPanel.buttonBar.statButton.enable = true;
                  this.mainPanel.buttonBar.addButton.enable = true;
                  (Main.osgi.getService(IAchievementModel) as AchievementModel).changeSwitchPanelStateEnd(MainButtonBarEvents.BATTLE);
                  break;
               case 1:
                  this.mainPanel.buttonBar.battlesButton.enable = true;
                  this.mainPanel.buttonBar.garageButton.enable = false;
                  this.mainPanel.buttonBar.statButton.enable = true;
                  (Main.osgi.getService(IAchievementModel) as AchievementModel).changeSwitchPanelStateEnd(MainButtonBarEvents.GARAGE);
                  break;
               case 2:
                  this.mainPanel.buttonBar.battlesButton.enable = true;
                  this.mainPanel.buttonBar.garageButton.enable = true;
                  this.mainPanel.buttonBar.statButton.enable = false;
                  break;
               case 3:
                  this.mainPanel.buttonBar.battlesButton.enable = true;
                  this.mainPanel.buttonBar.garageButton.enable = true;
                  this.mainPanel.buttonBar.statButton.enable = true;
                  break;
               case 4:
                  this.mainPanel.buttonBar.battlesButton.enable = true;
                  this.mainPanel.buttonBar.garageButton.enable = true;
                  this.mainPanel.buttonBar.statButton.enable = true;
                  if(this.loaderWindow != null)
                  {
                     this.loaderWindow.unlockLoaderWindow();
                     this.loaderWindow.hideLoaderWindow();
                     this.loaderWindow.lockLoaderWindow();
                  }
                  (Main.osgi.getService(IAchievementModel) as AchievementModel).onLoadedInBattle();
            }
         }
         this.unlock();
      }
      
      public function setInitData(countries:Array, rates:Array, accountId:String, projectId:int, formId:String) : void
      {
         var alertService:IAlertService = null;
         this.unlock();
         if(!(accountId != null && accountId != "" && accountId != "null"))
         {
            alertService = Main.osgi.getService(IAlertService) as IAlertService;
            alertService.showAlert(ILocaleService(Main.osgi.getService(ILocaleService)).getText(TextConst.PAYMENT_NOT_AVAILABLE_ALERT_TEXT));
         }
      }
      
      public function setOperators(countryId:String, operators:Array) : void
      {
      }
      
      public function setNumbers(operatorId:int, smsNumbers:Array) : void
      {
         this.paymentWindow.setNumbers(smsNumbers);
      }
      
      public function updateReferalsData(data:Array) : void
      {
         if(this.referalWindow != null)
         {
            this.referalWindow.addReferals(data);
         }
      }
      
      public function lock() : void
      {
         Main.writeVarsToConsoleChannel("PANEL MODEL","lock");
         this.mainPanel.mouseEnabled = false;
         this.mainPanel.mouseChildren = false;
      }
      
      public function unlock() : void
      {
         Main.writeVarsToConsoleChannel("PANEL MODEL","unlock");
         this.mainPanel.mouseEnabled = true;
         this.mainPanel.mouseChildren = true;
      }
      
      public function addListener(listener:IMoneyListener) : void
      {
         this.moneyListeners.push(listener);
      }
      
      public function removeListener(listener:IMoneyListener) : void
      {
         var index:int = this.moneyListeners.indexOf(listener);
         if(index != -1)
         {
            this.moneyListeners.splice(index,1);
         }
      }
      
      public function get userName() : String
      {
         return this._userName;
      }
      
      public function get userEmail() : String
      {
         return this.email == "" || this.email == null || this.email == "null" ? "" : this.email;
      }
      
      public function get rank() : int
      {
         return this.userRank;
      }
      
      public function get crystal() : int
      {
         return this._crystal;
      }
      
      public function get showSkyBox() : Boolean
      {
         return this.getBoolean(PARAM_SHOW_SKY_BOX,true);
      }
      
      public function get showFPS() : Boolean
      {
         return this.getBoolean(PARAM_SHOW_FPS,true);
      }
      
      public function get showBattleChat() : Boolean
      {
         return this.getBoolean(PARAM_SHOW_BATTLE_CHAT,true);
      }
      
      public function get adaptiveFPS() : Boolean
      {
         return this.getBoolean(PARAM_ADAPTIVE_FPS,false);
      }
      
      public function get useDust() : Boolean
      {
         return this.getBoolean(PARAM_DUST,false);
      }
      
      public function get enableMipMapping() : Boolean
      {
         return this.getBoolean(PARAM_MIPMAPPING,true);
      }
      
      public function get inverseBackDriving() : Boolean
      {
         return this.getBoolean(PARAM_INVERSE_BACK_DRIVING,false);
      }
      
      public function get bgSound() : Boolean
      {
         return this.getBoolean(PARAM_BGSOUND,true);
      }
      
      public function get muteSound() : Boolean
      {
         return this.getBoolean(PARAM_MUTE_SOUND,false);
      }
      
      public function get fog() : Boolean
      {
         return this.getBoolean(PARAM_FOG,false);
      }
      
      public function get dust() : Boolean
      {
         return this.getBoolean(PARAM_DUST,false);
      }
      
      public function get shadows() : Boolean
      {
         return this.getBoolean(SHADOWS,false);
      }
      
      public function get defferedLighting() : Boolean
      {
         return this.getBoolean(DEFFERED_LIGHTING,false);
      }
      
      public function get animationTracks() : Boolean
      {
         return this.getBoolean(ANIMATED_TRACKS,false);
      }
      
      public function get animationDamage() : Boolean
      {
         return this.getBoolean(ANIMATED_DAMAGE,true);
      }
      
      public function get shadowUnderTanks() : Boolean
      {
         return this.getBoolean(SHADOW_UNDER_TANKS,false);
      }
      
      public function get coloredFPS() : Boolean
      {
         return this.getBoolean(COLORED_FPS,false);
      }
      
      public function get useSSAO() : Boolean
      {
         return this.getBoolean(PARAM_SSAO,false);
      }
      
      private function showPanel() : void
      {
         if(!this.layer.contains(this.mainPanel))
         {
            this.layer.addChild(this.mainPanel);
         }
         this.mainPanel.buttonBar.addEventListener(MainButtonBarEvents.PANEL_BUTTON_PRESSED,this.onButtonBarButtonClick);
      }
      
      private function hidePanel() : void
      {
         if(this.layer.contains(this.mainPanel))
         {
            this.layer.removeChild(this.mainPanel);
         }
         this.mainPanel.buttonBar.removeEventListener(MainButtonBarEvents.PANEL_BUTTON_PRESSED,this.onButtonBarButtonClick);
      }
      
      private function onButtonBarButtonClick(e:MainButtonBarEvents) : void
      {
         this.lock();
         (Main.osgi.getService(IAchievementModel) as AchievementModel).changeSwitchPanelStateStart(e.typeButton);
         switch(e.typeButton)
         {
            case MainButtonBarEvents.BATTLE:
               this.showBattleSelect(this.clientObject);
               this.isBattleSelect = true;
               this.lock();
               break;
            case MainButtonBarEvents.BUGS:
               this.unlock();
               break;
            case MainButtonBarEvents.CLOSE:
               this.showQuitDialog();
               this.unlock();
               break;
            case MainButtonBarEvents.GARAGE:
               this.showGarage(this.clientObject);
               this.isGarageSelect = true;
               this.lock();
               break;
            case MainButtonBarEvents.HELP:
               this.showHelpers();
               this.unlock();
               break;
            case MainButtonBarEvents.SETTINGS:
               if(this.settingsWindow == null)
               {
                  this.showProfile(this.clientObject);
               }
               else
               {
                  this.unlock();
               }
               this.unlock();
               break;
            case MainButtonBarEvents.SOUND:
               this.togleSoundMute();
               this.unlock();
               break;
            case MainButtonBarEvents.STAT:
               this.unlock();
               break;
            case MainButtonBarEvents.ADDMONEY:
               this.networker.send("lobby;get_shop");
               break;
            case MainButtonBarEvents.PROFILE:
               this.networker.send("lobby;get_profile");
               this.unlock();
               break;
            case MainButtonBarEvents.CHALLENGE:
               this.networker.send("lobby;show_quests");
               break;
            case MainButtonBarEvents.FRIENDS:
               this.networker.send("lobby;get_friends");
               break;
            case MainButtonBarEvents.SOCIALNETS:
               if(this.socialNetsWindow == null)
               {
                  this.openSocialNetworks();
                  this.unlock();
               }
               else
               {
                  this.unlock();
               }
               break;
            case MainButtonBarEvents.SPINS:
               this.networker.send("lobby;get_spins_url");
               break;
            case MainButtonBarEvents.CLANS:
               this.unlock();
         }
      }
      
      public function onShopWindow(json:Object) : void
      {
         var listener:IPanelListener = null;
         this.blur();
         this.shopModel.init(json);
         this.shopModel.onEventWindow();
         this.unlock();
         var listeners:Vector.<IModel> = this.modelRegister.getModelsByInterface(IPanelListener);
         if(listeners != null)
         {
            for each(listener in listeners)
            {
               listener.friendsOpened();
            }
         }
      }
      
      public function closeShopWindow(e:MouseEvent = null) : void
      {
         var listener:IPanelListener = null;
         this.unblur();
         var listeners:Vector.<IModel> = this.modelRegister.getModelsByInterface(IPanelListener);
         if(listeners != null)
         {
            for each(listener in listeners)
            {
               listener.friendsClosed();
            }
         }
      }
      
      public function showPurchaseWindow(donate:int, bonus:int, doubleCrys:int) : void
      {
         var listeners:Vector.<IModel> = null;
         var listener:IPanelListener = null;
         if(this.purchaseWindow == null)
         {
            this.blur();
            this.purchaseWindow = new ThanksForPurchaseWindow(donate,bonus,doubleCrys);
            this.dialogsLayer.addChild(this.purchaseWindow);
            this.purchaseWindow.closeButton.addEventListener(MouseEvent.CLICK,this.closePurchaseWindow);
            Main.stage.addEventListener(Event.RESIZE,this.alignPurchaseWindow);
            this.alignPurchaseWindow();
            this.unlock();
            listeners = this.modelRegister.getModelsByInterface(IPanelListener);
            if(listeners != null)
            {
               for each(listener in listeners)
               {
                  listener.friendsOpened();
               }
            }
         }
      }
      
      private function closePurchaseWindow(e:MouseEvent) : void
      {
         var listener:IPanelListener = null;
         this.unblur();
         this.dialogsLayer.removeChild(this.purchaseWindow);
         Main.stage.removeEventListener(Event.RESIZE,this.alignPurchaseWindow);
         this.purchaseWindow = null;
         var listeners:Vector.<IModel> = this.modelRegister.getModelsByInterface(IPanelListener);
         if(listeners != null)
         {
            for each(listener in listeners)
            {
               listener.friendsClosed();
            }
         }
      }
      
      private function alignPurchaseWindow(e:Event = null) : void
      {
         this.purchaseWindow.x = Math.round((Main.stage.stageWidth - this.purchaseWindow.width) * 0.5);
         this.purchaseWindow.y = Math.round((Main.stage.stageHeight - this.purchaseWindow.height) * 0.5);
      }
      
      private function showProfile(c:ClientObject) : void
      {
         this.networker.send("lobby;show_profile");
      }
      
      public function showQuitBattleDialog() : void
      {
         var alert:Alert = new Alert(Alert.ALERT_CONFIRM_BATTLE_EXIT);
         this.dialogsLayer.addChild(alert);
         alert.addEventListener(AlertEvent.ALERT_BUTTON_PRESSED,function(e:AlertEvent):void
         {
            if(e.typeButton == AlertAnswer.YES)
            {
               closeFriendsWindow();
               showBattleSelect(null);
            }
         });
      }
      
      public function showRemoveFriendDialog(nickname:String) : void
      {
         var alert:Alert = new Alert(Alert.ALERT_CONFIRM_REMOVE_FRIEND);
         this.dialogsLayer.addChild(alert);
         alert.addEventListener(AlertEvent.ALERT_BUTTON_PRESSED,function(e:AlertEvent):void
         {
            if(e.typeButton == AlertAnswer.YES)
            {
               networker.send("lobby;del_friend;" + nickname + ";");
            }
         });
      }
      
      public function showGiftWindow(items:Array, parserInfo:Object) : void
      {
         var listeners:Vector.<IModel> = null;
         var listener:IPanelListener = null;
         if(this.giftsWindow == null)
         {
            this.blur();
            this.giftsWindow = new UserGiftsView(items,parserInfo);
            this.dialogsLayer.addChild(this.giftsWindow);
            this.giftsWindow.closeButton.addEventListener(MouseEvent.CLICK,this.closeUserGiftsWindow);
            Main.stage.addEventListener(Event.RESIZE,this.alignUserGiftsWindow);
            this.alignUserGiftsWindow();
            this.unlock();
            listeners = this.modelRegister.getModelsByInterface(IPanelListener);
            if(listeners != null)
            {
               for each(listener in listeners)
               {
                  listener.friendsOpened();
               }
            }
         }
      }
      
      private function closeUserGiftsWindow(e:MouseEvent) : void
      {
         var listener:IPanelListener = null;
         this.unblur();
         this.dialogsLayer.removeChild(this.giftsWindow);
         Main.stage.removeEventListener(Event.RESIZE,this.alignUserGiftsWindow);
         this.giftsWindow = null;
         var listeners:Vector.<IModel> = this.modelRegister.getModelsByInterface(IPanelListener);
         if(listeners != null)
         {
            for each(listener in listeners)
            {
               listener.friendsClosed();
            }
         }
      }
      
      private function alignUserGiftsWindow(e:Event = null) : void
      {
         this.giftsWindow.x = Math.round((Main.stage.stageWidth - this.giftsWindow.width) * 0.5);
         this.giftsWindow.y = Math.round((Main.stage.stageHeight - this.giftsWindow.height) * 0.5);
      }
      
      public function openFriends() : void
      {
         var listeners:Vector.<IModel> = null;
         var listener:IPanelListener = null;
         if(this.friendsWindow == null)
         {
            this.blur();
            this.friendsWindow = new FriendsWindow(this.networker);
            this.dialogsLayer.addChild(this.friendsWindow);
            this.friendsWindow._closeButton.addEventListener(MouseEvent.CLICK,this.closeFriendsWindow);
            Main.stage.addEventListener(Event.RESIZE,this.alignFriendsWindow);
            this.alignFriendsWindow();
            this.unlock();
            listeners = this.modelRegister.getModelsByInterface(IPanelListener);
            if(listeners != null)
            {
               for each(listener in listeners)
               {
                  listener.friendsOpened();
               }
            }
         }
      }
      
      private function alignFriendsWindow(e:Event = null) : void
      {
         if(this.friendsWindow == null)
         {
            return;
         }
         this.friendsWindow.x = Math.round((Main.stage.stageWidth - this.friendsWindow._windowSize.x) * 0.5);
         this.friendsWindow.y = Math.round((Main.stage.stageHeight - this.friendsWindow._windowSize.y) * 0.5);
      }
      
      private function closeFriendsWindow(e:MouseEvent = null) : void
      {
         var listener:IPanelListener = null;
         this.friendsWindow._closeButton.removeEventListener(MouseEvent.CLICK,this.closeFriendsWindow);
         Main.stage.removeEventListener(Event.RESIZE,this.alignFriendsWindow);
         this.dialogsLayer.removeChild(this.friendsWindow);
         this.friendsWindow = null;
         this.unblur();
         var listeners:Vector.<IModel> = this.modelRegister.getModelsByInterface(IPanelListener);
         if(listeners != null)
         {
            for each(listener in listeners)
            {
               listener.friendsClosed();
            }
         }
      }
      
      public function updateFriendsList() : void
      {
         if(this.friendsWindow == null)
         {
            return;
         }
         this.friendsWindow.updateList();
      }
      
      public function openSocialNetworks() : void
      {
         var listeners:Vector.<IModel> = null;
         var listener:IPanelListener = null;
         if(this.socialNetsWindow == null)
         {
            this.blur();
            this.socialNetsWindow = new SocialNetworksWindow();
            this.dialogsLayer.addChild(this.socialNetsWindow);
            this.socialNetsWindow.closeBtn.addEventListener(MouseEvent.CLICK,this.closeSocialNetworks);
            Main.stage.addEventListener(Event.RESIZE,this.alignSocialNetworks);
            this.alignSocialNetworks();
            this.unlock();
            listeners = this.modelRegister.getModelsByInterface(IPanelListener);
            if(listeners != null)
            {
               for each(listener in listeners)
               {
                  listener.friendsOpened();
               }
            }
         }
      }
      
      private function alignSocialNetworks(e:Event = null) : void
      {
         if(this.socialNetsWindow == null)
         {
            return;
         }
         this.socialNetsWindow.x = Math.round((Main.stage.stageWidth - this.socialNetsWindow.windowWidth) * 0.5);
         this.socialNetsWindow.y = Math.round((Main.stage.stageHeight - this.socialNetsWindow.windowHeight) * 0.5);
      }
      
      private function closeSocialNetworks(e:MouseEvent = null) : void
      {
         var listener:IPanelListener = null;
         this.socialNetsWindow.closeBtn.removeEventListener(MouseEvent.CLICK,this.closeSocialNetworks);
         Main.stage.removeEventListener(Event.RESIZE,this.alignSocialNetworks);
         this.dialogsLayer.removeChild(this.socialNetsWindow);
         this.socialNetsWindow = null;
         this.unblur();
         var listeners:Vector.<IModel> = this.modelRegister.getModelsByInterface(IPanelListener);
         if(listeners != null)
         {
            for each(listener in listeners)
            {
               listener.friendsClosed();
            }
         }
      }
      
      public function openDiscountWindow(text:String, itemId:String, discount:String) : void
      {
         if(this.discountWindow == null)
         {
            this.blur();
            this.discountWindow = new TempDiscountWindow(text,itemId,discount);
            this.dialogsLayer.addChild(this.discountWindow);
            this.discountWindow.closeBtn.addEventListener(MouseEvent.CLICK,this.closeDiscountWindow);
            Main.stage.addEventListener(Event.RESIZE,this.alignDiscountWindow);
            this.alignDiscountWindow();
            this.unlock();
         }
      }
      
      private function alignDiscountWindow(e:Event = null) : void
      {
         if(this.discountWindow == null)
         {
            return;
         }
         this.discountWindow.x = Math.round((Main.stage.stageWidth - this.discountWindow.windowWidth) * 0.5);
         this.discountWindow.y = Math.round((Main.stage.stageHeight - this.discountWindow.windowHeight) * 0.5);
      }
      
      private function closeDiscountWindow(e:MouseEvent = null) : void
      {
         this.discountWindow.closeBtn.removeEventListener(MouseEvent.CLICK,this.closeDiscountWindow);
         Main.stage.removeEventListener(Event.RESIZE,this.alignDiscountWindow);
         this.dialogsLayer.removeChild(this.discountWindow);
         this.discountWindow = null;
         this.unblur();
      }
      
      public function openChallegneCongratsWindow(prizes:Array) : void
      {
         if(this.challegneCongratsWindow == null)
         {
            this.blur();
            this.challegneCongratsWindow = new ChallengeCongratulationWindow(prizes);
            this.dialogsLayer.addChild(this.challegneCongratsWindow);
            this.challegneCongratsWindow.closeBtn.addEventListener(MouseEvent.CLICK,this.closeChallegneCongratsWindow);
            Main.stage.addEventListener(Event.RESIZE,this.alignChallegneCongratsWindow);
            this.alignChallegneCongratsWindow();
            this.unlock();
         }
      }
      
      private function alignChallegneCongratsWindow(e:Event = null) : void
      {
         if(this.challegneCongratsWindow == null)
         {
            return;
         }
         this.challegneCongratsWindow.x = Math.round((Main.stage.stageWidth - this.challegneCongratsWindow.windowWidth) * 0.5);
         this.challegneCongratsWindow.y = Math.round((Main.stage.stageHeight - this.challegneCongratsWindow.windowHeight) * 0.5);
      }
      
      private function closeChallegneCongratsWindow(e:MouseEvent = null) : void
      {
         this.challegneCongratsWindow.closeBtn.removeEventListener(MouseEvent.CLICK,this.closeChallegneCongratsWindow);
         Main.stage.removeEventListener(Event.RESIZE,this.alignChallegneCongratsWindow);
         this.dialogsLayer.removeChild(this.challegneCongratsWindow);
         this.challegneCongratsWindow = null;
         this.unblur();
      }
      
      public function showBattleSelect(c:ClientObject, sendToServer:Boolean = true) : void
      {
         var alert:Alert = null;
         if(this.isGarageSelect)
         {
            GarageModel(Main.osgi.getService(IGarage)).objectUnloaded(null);
            GarageModel(Main.osgi.getService(IGarage)).kostil = false;
            Main.osgi.unregisterService(IGarage);
            this.isGarageSelect = false;
         }
         else if(this.isInBattle)
         {
            this.blur();
            alert = new Alert();
            alert.showAlert("Покинуть битву? Очки и кристальный фонд будет потеряны.",[AlertAnswer.YES,AlertAnswer.NO]);
            this.dialogsLayer.addChild(alert);
            alert.addEventListener(AlertEvent.ALERT_BUTTON_PRESSED,function(ae:AlertEvent):void
            {
               if(ae.typeButton == localeService.getText(TextConst.ALERT_ANSWER_YES))
               {
                  onExitFromBattle(sendToServer);
                  networker.send("lobby;get_data_init_battle_select");
                  isInBattle = false;
                  isBattleSelect = true;
                  (Main.osgi.getService(IGTanksLoader) as GTanksLoaderWindow).addProgress(99);
               }
               else
               {
                  mainPanel.buttonBar.battlesButton.enable = true;
                  unlock();
               }
               unblur();
            });
            return;
         }
         (Main.osgi.getService(IGTanksLoader) as GTanksLoaderWindow).addProgress(99);
         this.isBattleSelect = true;
         this.networker.send("lobby;get_data_init_battle_select");
      }
      
      private function togleSoundMute() : void
      {
         var listener:IPanelListener = null;
         this.storeBoolean(PARAM_MUTE_SOUND,!this.getSoundMute());
         this.flushStorage();
         this.setSoundSettings();
         this.unlock();
         for each(listener in this.panelListeners)
         {
            listener.setMuteSound(this.getSoundMute());
         }
      }
      
      private function showHelpers() : void
      {
         this.alignHelpers();
         Main.stage.addEventListener(Event.RESIZE,this.alignHelpers);
         var helpService:IHelpService = Main.osgi.getService(IHelpService) as IHelpService;
         helpService.showHelp();
         this.unlock();
         Main.stage.addEventListener(MouseEvent.MOUSE_DOWN,this.hideHelp);
      }
      
      private function showQuitDialog() : void
      {
         var listener:IPanelListener = null;
         var alert:Alert = new Alert(Alert.ALERT_QUIT);
         this.dialogsLayer.addChild(alert);
         this.blur();
         alert.addEventListener(AlertEvent.ALERT_BUTTON_PRESSED,this.onAlertButtonPressed);
         var listeners:Vector.<IModel> = this.modelRegister.getModelsByInterface(IPanelListener);
         if(listeners != null)
         {
            for each(listener in listeners)
            {
               listener.onCloseGame();
            }
         }
      }
      
      private function hideHelp(e:MouseEvent) : void
      {
         Main.stage.removeEventListener(Event.RESIZE,this.alignHelpers);
         Main.stage.removeEventListener(MouseEvent.MOUSE_DOWN,this.hideHelp);
         (Main.osgi.getService(IAchievementModel) as AchievementModel).changeSwitchPanelStateEnd(MainButtonBarEvents.HELP);
      }
      
      private function alignReferalWindow(e:Event = null) : void
      {
         this.referalWindow.x = Math.round((Main.stage.stageWidth - this.referalWindow.windowSize.x) * 0.5);
         this.referalWindow.y = Math.round((Main.stage.stageHeight - this.referalWindow.windowSize.y) * 0.5);
      }
      
      private function closeRefererPanel(e:MouseEvent = null) : void
      {
         this.referalWindow.removeEventListener(ReferalWindowEvent.SEND_MAIL,this.sendInvitation);
         this.referalWindow.closeButton.removeEventListener(MouseEvent.CLICK,this.closeRefererPanel);
         Main.stage.removeEventListener(Event.RESIZE,this.alignReferalWindow);
         this.dialogsLayer.removeChild(this.referalWindow);
         this.referalWindow = null;
         this.unblur();
      }
      
      private function openPaymentWindow() : void
      {
      }
      
      private function alignPaymentWindow(e:Event = null) : void
      {
         Main.writeVarsToConsoleChannel("PAYMENT","PanelModel alignPaymentWindow");
         var minWidth:int = int(Math.max(1000,Main.stage.stageWidth));
      }
      
      private function onPaymentSelectCountry(e:PaymentWindowEvent) : void
      {
         Main.writeVarsToConsoleChannel("PAYMENT","PanelModel onPaymentSelectCountry (%1)",this.paymentWindow.selectedCountry);
         var paymentModel:IPayment = (Main.osgi.getService(IModelService) as IModelService).getModelsByInterface(IPayment)[0] as IPayment;
         paymentModel.getOperatorsList(this.paymentWindow.selectedCountry);
      }
      
      private function onPaymentSelectOperator(e:PaymentWindowEvent) : void
      {
         Main.writeVarsToConsoleChannel("PAYMENT","PanelModel onPaymentSelectOperator");
         var paymentModel:IPayment = (Main.osgi.getService(IModelService) as IModelService).getModelsByInterface(IPayment)[0] as IPayment;
         paymentModel.getNumbersList(this.paymentWindow.selectedOperator);
      }
      
      private function closePaymentWindow() : void
      {
         if(this.paymentWindow != null && this.layer.contains(this.paymentWindow))
         {
            this.layer.removeChild(this.paymentWindow);
            Main.stage.removeEventListener(Event.RESIZE,this.alignPaymentWindow);
            this.paymentWindow.removeEventListener(PaymentWindowEvent.SELECT_COUNTRY,this.onPaymentSelectCountry);
            this.paymentWindow.removeEventListener(PaymentWindowEvent.SELECT_OPERATOR,this.onPaymentSelectOperator);
            this.paymentWindow = null;
         }
      }
      
      private function onConfirmEmail(e:Event = null) : void
      {
         this.settingsWindow.removeEventListener(Event.ACTIVATE,this.onConfirmEmail);
      }
      
      private function onChangeVolume(e:Event = null) : void
      {
         if(!this.getSoundMute())
         {
            SoundMixer.soundTransform = new SoundTransform(this.settingsWindow.volume);
         }
      }
      
      private function hideSettingsDialog() : void
      {
         this.settingsWindow.removeEventListener(SettingsWindowEvent.CANCEL_SETTINGS,this.onSettingsCancel);
         this.settingsWindow.removeEventListener(SettingsWindowEvent.ACCEPT_SETTINGS,this.onSettingsComplete);
         this.settingsWindow.removeEventListener(SettingsWindowEvent.RESEND_CONFIRMATION,this.onConfirmEmail);
         this.settingsWindow.removeEventListener(SettingsWindowEvent.CHANGE_VOLUME,this.onChangeVolume);
         Main.stage.removeEventListener(Event.RESIZE,this.alignSettingsWindow);
         this.dialogsLayer.removeChild(this.settingsWindow);
         this.unblur();
         this.settingsWindow = null;
         this.mainPanel.buttonBar.settingsButton.enable = true;
      }
      
      private function onSettingsCancel(e:Event = null) : void
      {
         var listener:IPanelListener = null;
         this.setSoundSettings();
         this.hideSettingsDialog();
         var listeners:Vector.<IModel> = this.modelRegister.getModelsByInterface(IPanelListener);
         if(listeners != null)
         {
            for each(listener in listeners)
            {
               listener.settingsCanceled();
            }
         }
      }
      
      private function onSettingsComplete(e:Event = null) : void
      {
         var modelRegister:IModelService = null;
         var aaModel:IAntiAddictionAlert = null;
         var listener:IPanelListener = null;
         if(!this.settingsWindow.isPasswordChangeDisabled)
         {
            this.updateProfile(this.clientObject,this.settingsWindow.email,this.settingsWindow.emailNoticeValue);
            if(this.settingsWindow.password != "")
            {
               Main.writeVarsToConsoleChannel("PANEL MODEL","onSettingsComplete password: %1",this.settingsWindow.password);
               this.updatePassword(this.clientObject,this.settingsWindow.password);
            }
         }
         if(this.settingsWindow.realName != "" && this.settingsWindow.idNumber != "")
         {
            modelRegister = Main.osgi.getService(IModelService) as IModelService;
            aaModel = modelRegister.getModelsByInterface(IAntiAddictionAlert)[0] as IAntiAddictionAlert;
            Main.writeVarsToConsoleChannel("PANEL MODEL","onSettingsComplete AA: %1 %2",this.settingsWindow.realName,this.settingsWindow.idNumber);
            Main.writeVarsToConsoleChannel("PANEL MODEL","onSettingsComplete AAModel: %1",aaModel);
            aaModel.setIdNumberAndRealName(this.settingsWindow.realName,this.settingsWindow.idNumber);
         }
         if(this.settingsWindow.useDust && !this.settingsWindow.useSoftParticle)
         {
            this.settingsWindow.visibleDustButton = false;
         }
         else
         {
            this.settingsWindow.visibleDustButton = true;
         }
         this.storeBoolean(PARAM_SHOW_SKY_BOX,this.settingsWindow.showSkyBox);
         this.storeBoolean(PARAM_SHOW_FPS,this.settingsWindow.showFPS);
         this.storeBoolean(PARAM_SHOW_BATTLE_CHAT,this.settingsWindow.showBattleChat);
         this.storeBoolean(PARAM_ADAPTIVE_FPS,this.settingsWindow.adaptiveFPS);
         this.storeBoolean(PARAM_MIPMAPPING,this.settingsWindow.enableMipMapping);
         this.storeBoolean(PARAM_INVERSE_BACK_DRIVING,this.settingsWindow.inverseBackDriving);
         this.storeBoolean(PARAM_BGSOUND,this.settingsWindow.bgSound);
         this.storeNumber(PARAM_SOUND_VOLUME,this.settingsWindow.volume);
         this.storeBoolean(PARAM_FOG,this.settingsWindow.useFog);
         this.storeBoolean(PARAM_DUST,this.settingsWindow.useDust);
         this.storeBoolean(SHADOWS,this.settingsWindow.useShadows);
         this.storeBoolean(DEFFERED_LIGHTING,this.settingsWindow.useDefferedLighting);
         this.storeBoolean(ANIMATED_TRACKS,this.settingsWindow.useAnimatedTracks);
         this.storeBoolean(ANIMATED_DAMAGE,this.settingsWindow.useAnimatedDamage);
         this.storeBoolean(SHADOW_UNDER_TANKS,this.settingsWindow.showShadowsTank);
         this.storeBoolean(COLORED_FPS,this.settingsWindow.coloredFPS);
         this.flushStorage();
         this.setSoundSettings();
         this.hideSettingsDialog();
         var listeners:Vector.<IModel> = this.modelRegister.getModelsByInterface(IPanelListener);
         if(listeners != null)
         {
            for each(listener in listeners)
            {
               listener.settingsAccepted();
            }
         }
      }
      
      private function updatePassword(cl:ClientObject, newPass:String) : void
      {
         Network(Main.osgi.getService(INetworker)).send("lobby;change_password;" + newPass);
      }
      
      private function updateProfile(cl:ClientObject, email:String, emailNotification:Boolean) : void
      {
         var pattern:RegExp = null;
         var result:Object = null;
         if(email != null && email != "")
         {
            pattern = /(\w|[_.\-])+@((\w|-)+\.)+\w{2,4}+/;
            result = pattern.exec(email);
            if(email.length > 0 && result != null)
            {
               Network(Main.osgi.getService(INetworker)).send("lobby;update_profile;" + email);
               this.postUpdateProfile();
            }
         }
      }
      
      private function postUpdateProfile() : void
      {
         this.dialogsLayer.addChild(new ConfirmEmailCode(this.localeService.getText(TextConst.ACCOUNT_RECOVERY_FORM_ENTER_CODE),this.onEnterConfirmCode));
      }
      
      private function onEnterConfirmCode(code:String) : void
      {
         Network(Main.osgi.getService(INetworker)).send("lobby;confirm_email_code;" + code);
      }
      
      public function openRecoveryWindow(email:String) : void
      {
         this.dialogsLayer.addChild(new RecoveryWindow(this.onSavedRecovery,email));
      }
      
      private function onSavedRecovery(pass:String, email:String) : void
      {
         if(pass == null || pass == "")
         {
            pass = " ";
         }
         if(email == null || email == "")
         {
            email = " ";
         }
         Network(Main.osgi.getService(INetworker)).send("lobby;change_pass_email;" + pass + ";" + email);
      }
      
      private function alignSettingsWindow(e:Event = null) : void
      {
         this.settingsWindow.x = Math.round((Main.stage.stageWidth - this.settingsWindow.width) * 0.5);
         this.settingsWindow.y = Math.round((Main.stage.stageHeight - this.settingsWindow.height) * 0.5);
      }
      
      private function alignReportWindow(e:Event = null) : void
      {
         this.reportWindow.x = Math.round((Main.stage.stageWidth - this.reportWindow.width) * 0.5);
         this.reportWindow.y = Math.round((Main.stage.stageHeight - this.reportWindow.height) * 0.5);
      }
      
      private function sendInvitation(e:ReferalWindowEvent) : void
      {
         var result:Object = null;
         var referalsModel:ReferalsModelBase = null;
         var a:Array = e.adresses.split(",");
         var pattern:RegExp = /(\w|[_.\-])+@((\w|-)+\.)+\w{2,4}+/;
         var notValid:Array = new Array();
         for(var i:int = 0; i < a.length; i++)
         {
            result = pattern.exec(a[i]);
            if(result == null)
            {
               notValid.push(a[i]);
            }
         }
         if(notValid.length > 0)
         {
            if(notValid.length == 1)
            {
               this._showMessage(this.localeService.getText(TextConst.REFERAL_WINDOW_ADDRESS_NOT_VALID_ALERT_TEXT,notValid[0]));
            }
            else
            {
               this._showMessage(this.localeService.getText(TextConst.REFERAL_WINDOW_ADDRESSES_NOT_VALID_ALERT_TEXT,notValid.join(", ")));
            }
         }
         else
         {
            this.modelRegister = Main.osgi.getService(IModelService) as IModelService;
            referalsModel = (this.modelRegister.getModelsByInterface(IReferalsModelBase) as Vector.<IModel>)[0] as ReferalsModelBase;
         }
      }
      
      private function onAlertButtonPressed(e:AlertEvent) : void
      {
         var listener:IPanelListener = null;
         this.unlock();
         this.unblur();
         if(e.typeButton == AlertAnswer.YES)
         {
            this.storage.data.userHash = null;
            this.storage.data.up = null;
            this.storage.flush();
         }
         var listeners:Vector.<IModel> = this.modelRegister.getModelsByInterface(IPanelListener);
         if(listeners != null)
         {
            for each(listener in listeners)
            {
               listener.onCloseGameExit();
            }
         }
      }
      
      private function alignHelpers(e:Event = null) : void
      {
         var stageWidth:int = Main.stage.stageWidth;
         if(stageWidth < 1000)
         {
            stageWidth = 1000;
         }
         var rankBarWidth:int = stageWidth - 465 - 13 * 2 - 110 - 60;
         this.rankBarHelper.targetPoint = new Point(60 + Math.round(rankBarWidth * 0.5),this.rankBarHelper.targetPoint.y);
         this.ratingHelper.targetPoint = new Point(rankBarWidth + 60,this.ratingHelper.targetPoint.y);
         this.mainMenuHelper.targetPoint = new Point(60 + rankBarWidth + 170,this.mainMenuHelper.targetPoint.y);
         this.buttonBarHelper.targetPoint = new Point(stageWidth - 140,this.buttonBarHelper.targetPoint.y);
         this.moneyHelper.targetPoint = new Point(185 + rankBarWidth + 5,this.moneyHelper.targetPoint.y);
      }
      
      public function blur() : void
      {
         if(!this.blured)
         {
            Main.stage.addEventListener(Event.RESIZE,this.resizeBlur);
            this.redrawBlur();
            this.dialogsLayer.addChildAt(this.overlay,0);
            this.resizeBlur(null);
            this.blured = true;
         }
      }
      
      private function redrawBlur() : void
      {
         var width:int = Main.stage.stageWidth;
         var heigth:int = Main.stage.stageHeight;
         this.overlay.graphics.clear();
         this.overlay.graphics.beginFill(0,0.5);
         this.overlay.graphics.drawRect(0,0,width,heigth);
      }
      
      private function resizeBlur(e:Event = null) : void
      {
         var width:int = Main.stage.stageWidth;
         var heigth:int = Main.stage.stageHeight;
         this.overlay.width = width;
         this.overlay.height = heigth;
      }
      
      public function unblur() : void
      {
         if(this.blured)
         {
            this.dialogsLayer.removeChild(this.overlay);
            Main.stage.removeEventListener(Event.RESIZE,this.resizeBlur);
            this.blured = false;
         }
      }
      
      public function showCloselessMessage(clientObject:ClientObject, message:String) : void
      {
         var alert:Alert = new Alert();
         alert.showAlert(message,[]);
         this.dialogsLayer.addChild(alert);
      }
      
      public function setIdNumberCheckResult(result:Boolean) : void
      {
         if(!result)
         {
            this._showMessage("该身份证错误,请重新输入");
         }
         else
         {
            this._showMessage("您的身份证信息已通过验证");
         }
      }
      
      private function getBoolean(name:String, defaultValue:Boolean) : Boolean
      {
         if(this.storage == null)
         {
            this.storage = IStorageService(Main.osgi.getService(IStorageService)).getStorage();
         }
         var value:* = this.storage.data[name];
         return value == null ? Boolean(Boolean(defaultValue)) : Boolean(Boolean(value));
      }
      
      private function storeBoolean(name:String, value:Boolean) : void
      {
         this.storage.data[name] = value;
      }
      
      private function getNumber(name:String, defauleValue:Number = 0) : Number
      {
         var value:Number = Number(this.storage.data[name]);
         return !!isNaN(value) ? Number(Number(defauleValue)) : Number(Number(value));
      }
      
      private function storeNumber(name:String, value:Number) : void
      {
         this.storage.data[name] = value;
      }
      
      private function flushStorage() : void
      {
         this.storage.flush();
      }
      
      public function get showShadowsTank() : Boolean
      {
         return IStorageService(Main.osgi.getService(IStorageService)).getStorage().data["show_shadows_tank"];
      }
      
      public function get useSoftParticle() : Boolean
      {
         return IStorageService(Main.osgi.getService(IStorageService)).getStorage().data["soft_particle"];
      }
   }
}
