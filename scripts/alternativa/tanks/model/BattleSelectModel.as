package alternativa.tanks.model
{
   import alternativa.console.IConsole;
   import alternativa.init.BattleSelectModelActivator;
   import alternativa.init.Main;
   import alternativa.model.IModel;
   import alternativa.model.IObjectLoadListener;
   import alternativa.model.IResourceLoadListener;
   import alternativa.object.ClientObject;
   import alternativa.osgi.service.alert.IAlertService;
   import alternativa.osgi.service.dump.IDumpService;
   import alternativa.osgi.service.dump.dumper.IDumper;
   import alternativa.osgi.service.loaderParams.ILoaderParamsService;
   import alternativa.osgi.service.locale.ILocaleService;
   import alternativa.osgi.service.log.ILogService;
   import alternativa.osgi.service.log.LogLevel;
   import alternativa.osgi.service.mainContainer.IMainContainerService;
   import alternativa.osgi.service.storage.IStorageService;
   import alternativa.service.IAddressService;
   import alternativa.service.IModelService;
   import alternativa.tanks.help.CreateMapHelper;
   import alternativa.tanks.help.IHelpService;
   import alternativa.tanks.help.LockedMapsHelper;
   import alternativa.tanks.locale.constants.TextConst;
   import alternativa.tanks.model.panel.IPanel;
   import alternativa.tanks.model.panel.PanelModel;
   import alternativa.types.Long;
   import flash.display.BitmapData;
   import flash.display.DisplayObjectContainer;
   import flash.events.Event;
   import flash.events.TimerEvent;
   import flash.geom.Point;
   import flash.net.SharedObject;
   import flash.utils.Dictionary;
   import flash.utils.Timer;
   import forms.Alert;
   import forms.AlertAnswer;
   import forms.battlelist.BattleMap;
   import forms.battlelist.CreateBattleForm;
   import forms.battlelist.ViewBattleList;
   import forms.battlelist.ViewDM;
   import forms.battlelist.ViewTDM;
   import forms.events.AlertEvent;
   import forms.events.BattleListEvent;
   import projects.tanks.client.battlefield.gui.models.chat.IChatModelBase;
   import projects.tanks.client.battleselect.BattleSelectModelBase;
   import projects.tanks.client.battleselect.IBattleSelectModelBase;
   import projects.tanks.client.battleselect.types.BattleClient;
   import projects.tanks.client.battleselect.types.MapClient;
   import projects.tanks.client.battleselect.types.UserInfoClient;
   import projects.tanks.client.battleservice.model.BattleType;
   import projects.tanks.client.battleservice.model.team.BattleTeamType;
   import scpacker.gui.GTanksLoaderWindow;
   import scpacker.gui.IGTanksLoader;
   import scpacker.networking.INetworker;
   import scpacker.networking.Network;
   import scpacker.resource.ResourceType;
   import scpacker.resource.ResourceUtil;
   import scpacker.resource.images.ImageResource;
   import swfaddress.SWFAddressEvent;
   
   public class BattleSelectModel extends BattleSelectModelBase implements IBattleSelectModelBase, IObjectLoadListener, IResourceLoadListener, IDumper
   {
       
      
      private var modelRegister:IModelService;
      
      private var panelModel:IPanel;
      
      private var helpService:IHelpService;
      
      private var addressService:IAddressService;
      
      private var loaderParamsService:ILoaderParamsService;
      
      private var localeService:ILocaleService;
      
      private var clientObject:ClientObject;
      
      private var layer:DisplayObjectContainer;
      
      private var dialogsLayer:DisplayObjectContainer;
      
      private var battleList:ViewBattleList;
      
      private var createBattleForm:CreateBattleForm;
      
      private var viewDM:ViewDM;
      
      private var viewTDM:ViewTDM;
      
      private var battlesArray:Array;
      
      private var mapsArray:Array;
      
      private var battles:Dictionary;
      
      private var maps:Dictionary;
      
      private var usersInfo:Dictionary;
      
      private const maxBattlesNum:int = 2147483647;
      
      private const HELPER_NOT_AVAILABLE:int = 1;
      
      private const HELPER_CREATE_MAP:int = 5;
      
      private var lockedMapsHelper:LockedMapsHelper;
      
      private var createHelper:CreateMapHelper;
      
      private const HELPER_GROUP_KEY:String = "BattleSelectModel";
      
      private var hideHelperInt:uint;
      
      private var hideHelperDelay:int = 5000;
      
      private var clearURL:Boolean;
      
      private var recommendedBattle:String;
      
      private var paidBattleAlert:Alert;
      
      private var createBattleExpectedResourceId:String;
      
      private var viewBattleExpectedResourceId:String;
      
      public var selectedBattleId:String;
      
      private var battleToSelect:String;
      
      private var translate:Dictionary;
      
      private var locale:String;
      
      private var gameNameBeforeCheck:String;
      
      public function BattleSelectModel()
      {
         this.translate = new Dictionary();
         super();
         _interfaces.push(IModel);
         _interfaces.push(IBattleSelectModelBase);
         _interfaces.push(IObjectLoadListener);
         _interfaces.push(IResourceLoadListener);
         this.modelRegister = Main.osgi.getService(IModelService) as IModelService;
         this.panelModel = Main.osgi.getService(IPanel) as IPanel;
         this.helpService = Main.osgi.getService(IHelpService) as IHelpService;
         this.addressService = Main.osgi.getService(IAddressService) as IAddressService;
         this.loaderParamsService = Main.osgi.getService(ILoaderParamsService) as ILoaderParamsService;
         this.localeService = ILocaleService(Main.osgi.getService(ILocaleService));
         this.layer = Main.contentUILayer;
         this.dialogsLayer = (Main.osgi.getService(IMainContainerService) as IMainContainerService).dialogsLayer as DisplayObjectContainer;
      }
      
      public function initObject(clientObject:ClientObject, cost:int, haveSubscribe:Boolean, maps:Array) : void
      {
         var mapId:String = null;
         var m:MapClient = null;
         var previewBitmap:BitmapData = null;
         var mapParams:BattleMap = null;
         Main.writeVarsToConsoleChannel("BATTLE SELECT","initObject");
         Main.writeVarsToConsoleChannel("BATTLE SELECT","   maps: %1",maps);
         Main.writeVarsToConsoleChannel("BATTLE SELECT","   haveSubscribe: %1",haveSubscribe);
         this.translate["Лето"] = "Summer";
         this.translate["Зима"] = "Winter";
         this.translate["Летний вечер"] = "Summer evening";
         this.translate["Зимний вечер"] = "Winter evening";
         this.locale = Game.currLocale;
         this.clientObject = clientObject;
         this.battles = new Dictionary();
         this.battlesArray = new Array();
         this.maps = new Dictionary();
         if(ViewBattleList(Main.osgi.getService(ViewBattleList)) != null)
         {
            ViewBattleList(Main.osgi.getService(ViewBattleList)).destroy();
         }
         this.battleList = new ViewBattleList();
         Main.osgi.registerService(ViewBattleList,this.battleList);
         var haveSubscribe:Boolean = true;
         this.createBattleForm = new CreateBattleForm(haveSubscribe);
         this.createBattleForm.mapsCombo.addEventListener(Event.CHANGE,this.onMapSelect);
         this.createBattleForm.themeCombo.addEventListener(Event.CHANGE,this.onMapSelect);
         this.createBattleForm.addEventListener(BattleListEvent.NEW_BATTLE_NAME_ADDED,this.checkBattleName);
         if(ViewDM(Main.osgi.getService(ViewDM)) != null)
         {
            this.viewDM = ViewDM(Main.osgi.getService(ViewDM));
            this.viewDM.haveSubscribe = haveSubscribe;
         }
         else
         {
            this.viewDM = new ViewDM(haveSubscribe);
            Main.osgi.registerService(ViewDM,this.viewDM);
         }
         if(ViewTDM(Main.osgi.getService(ViewTDM)) != null)
         {
            this.viewTDM = ViewTDM(Main.osgi.getService(ViewTDM));
            this.viewTDM.haveSubscribe = haveSubscribe;
         }
         else
         {
            this.viewTDM = new ViewTDM(haveSubscribe);
            Main.osgi.registerService(ViewTDM,this.viewTDM);
         }
         this.mapsArray = maps;
         for(var i:int = 0; i < maps.length; i++)
         {
            mapId = MapClient(maps[i]).id;
            this.maps[mapId] = maps[i];
         }
         var mapsParams:Array = new Array();
         for(i = 0; i < this.mapsArray.length; i++)
         {
            m = MapClient(this.mapsArray[i]);
            try
            {
               previewBitmap = ResourceUtil.getResource(ResourceType.IMAGE,m.previewId).bitmapData as BitmapData;
            }
            catch(e:Error)
            {
               previewBitmap = new BitmapData(500,500);
            }
            mapParams = new BattleMap();
            mapParams.id = m.id;
            mapParams.gameName = m.name;
            mapParams.maxPeople = m.maxPeople;
            mapParams.maxRank = m.maxRank;
            mapParams.minRank = m.minRank;
            mapParams.themeName = this.locale == "RU" ? m.themeName : this.translate[m.themeName];
            mapParams.preview = previewBitmap;
            mapParams.ctf = m.ctf;
            mapParams.tdm = m.tdm;
            mapParams.tdm = m.tdm;
            mapParams.dom = m.dom;
            mapParams.hr = m.hr;
            mapsParams.push(mapParams);
         }
         this.createBattleForm.maps = mapsParams;
         if(this.addressService != null)
         {
            this.addressService.addEventListener(SWFAddressEvent.CHANGE,this.onAddressChange);
         }
         this.clearURL = true;
         this.createHelper = new CreateMapHelper();
         this.lockedMapsHelper = new LockedMapsHelper();
         this.helpService.registerHelper(this.HELPER_GROUP_KEY,this.HELPER_CREATE_MAP,this.createHelper,true);
         this.helpService.registerHelper(this.HELPER_GROUP_KEY,this.HELPER_NOT_AVAILABLE,this.lockedMapsHelper,false);
         var minWidth:int = int(Math.max(1000,Main.stage.stageWidth));
         var minHeight:int = int(Math.max(600,Main.stage.stageHeight));
         this.createHelper.targetPoint = new Point(Math.round(minWidth * (2 / 3)) - 47,minHeight - 34);
         Main.stage.addEventListener(Event.RESIZE,this.alignHelpers);
         this.alignHelpers();
         (BattleSelectModelActivator.osgi.getService(IDumpService) as IDumpService).registerDumper(this);
         (Main.osgi.getService(IConsole) as IConsole).addLine("server initObject() end");
      }
      
      public function objectLoaded(object:ClientObject) : void
      {
      }
      
      public function objectUnloaded(object:ClientObject) : void
      {
         (BattleSelectModelActivator.osgi.getService(IDumpService) as IDumpService).unregisterDumper(this.dumperName);
         if(this.addressService != null)
         {
            this.addressService.removeEventListener(SWFAddressEvent.CHANGE,this.onAddressChange);
            if(this.clearURL)
            {
               this.addressService.setValue("");
            }
         }
         this.hideList();
         this.hideInfo();
         this.hideCreateForm();
         Main.stage.removeEventListener(Event.RESIZE,this.alignHelpers);
         this.helpService.hideHelper(this.HELPER_GROUP_KEY,this.HELPER_NOT_AVAILABLE);
         this.helpService.unregisterHelper(this.HELPER_GROUP_KEY,this.HELPER_NOT_AVAILABLE);
         this.helpService.unregisterHelper(this.HELPER_GROUP_KEY,this.HELPER_CREATE_MAP);
         this.lockedMapsHelper = null;
         this.createHelper = null;
         this.battleList = null;
         this.createBattleForm = null;
         this.viewDM = null;
         this.viewTDM = null;
         this.battlesArray = null;
         this.mapsArray = null;
         this.battles = null;
         this.maps = null;
         this.usersInfo = null;
         this.paidBattleAlert = null;
         this.clientObject = null;
      }
      
      public function resourceLoaded(resource:Object) : void
      {
         Main.writeVarsToConsoleChannel("BATTLE SELECT","resourceLoaded");
         Main.writeVarsToConsoleChannel("BATTLE SELECT","   resourceId: " + resource.id);
         Main.writeVarsToConsoleChannel("BATTLE SELECT","   viewExpectedResourceId: " + this.viewBattleExpectedResourceId);
         Main.writeVarsToConsoleChannel("BATTLE SELECT","   createExpectedResourceId: " + this.createBattleExpectedResourceId);
         var bitmapData:BitmapData = resource.bitmapData as BitmapData;
         if(resource.id == this.viewBattleExpectedResourceId)
         {
            if(this.viewDM != null && this.layer.contains(this.viewDM))
            {
               this.viewDM.info.setPreview(bitmapData);
            }
            else if(this.viewTDM != null && this.layer.contains(this.viewTDM))
            {
               this.viewTDM.info.setPreview(bitmapData);
            }
            this.viewBattleExpectedResourceId = null;
         }
         else if(resource.id == this.createBattleExpectedResourceId)
         {
            if(this.createBattleForm != null && this.layer.contains(this.createBattleForm))
            {
               this.createBattleForm.info.setPreview(bitmapData);
            }
            this.createBattleExpectedResourceId = null;
         }
      }
      
      public function resourceUnloaded(resourceId:Long) : void
      {
      }
      
      public function initBattleList(clientObject:ClientObject, battles:Array, recommendedBattle:String, onLink:Boolean) : void
      {
         var garageAvailableAlert:Alert = null;
         var dialogsLayer:DisplayObjectContainer = null;
         var timer:Timer = new Timer(2500,1);
         timer.addEventListener(TimerEvent.TIMER_COMPLETE,function(e:TimerEvent):void
         {
            var i:int = 0;
            var selectedBattleId:String = null;
            (Main.osgi.getService(IGTanksLoader) as GTanksLoaderWindow).setFullAndClose(null);
            panelModel.partSelected(0);
            showList();
            if(battles != null)
            {
               for(i = 0; i < battles.length; i++)
               {
                  addBattle(clientObject,BattleClient(battles[i]));
               }
               selectedBattleId = checkSelectedBattle();
               if(selectedBattleId == null || onLink)
               {
                  selectBattle(clientObject,recommendedBattle);
               }
               else
               {
                  selectBattle(clientObject,selectedBattleId);
               }
            }
            if(Lobby.firstInit)
            {
               Network(Main.osgi.getService(INetworker)).send("lobby;user_inited");
               Lobby.firstInit = false;
            }
            (Main.osgi.getService(IConsole) as IConsole).addLine("server initBattleList() Timer end");
         });
         timer.start();
         var storage:SharedObject = IStorageService(Main.osgi.getService(IStorageService)).getStorage();
         if(storage.data.garageAvailableAlertShown == null && (this.panelModel.rank == 2 || this.panelModel.rank == 3))
         {
            garageAvailableAlert = new Alert(Alert.GARAGE_AVAILABLE);
            garageAvailableAlert.addEventListener(AlertEvent.ALERT_BUTTON_PRESSED,this.onGarageAvailableAlertPressed);
            dialogsLayer = (Main.osgi.getService(IMainContainerService) as IMainContainerService).dialogsLayer as DisplayObjectContainer;
            dialogsLayer.addChild(garageAvailableAlert);
            storage.data.garageAvailableAlertShown = true;
            storage.flush();
         }
         (Main.osgi.getService(IConsole) as IConsole).addLine("server initBattleList() end");
      }
      
      private function onGarageAvailableAlertPressed(e:AlertEvent) : void
      {
         if(e.typeButton == AlertAnswer.GARAGE)
         {
            this.panelModel.goToGarage();
         }
      }
      
      public function addBattle(clientObject:ClientObject, battle:BattleClient) : void
      {
         this.battles[battle.battleId] = battle;
         this.battlesArray.push(battle);
         this.battleList.addItem(battle.battleId,battle.name,!battle.team,battle.countRedPeople,battle.countBluePeople,battle.countPeople,(this.maps[battle.mapId] as MapClient).name,battle.countPeople >= battle.maxPeople,battle.countRedPeople >= battle.maxPeople,battle.countBluePeople >= battle.maxPeople,battle.minRank <= this.panelModel.rank && battle.maxRank >= this.panelModel.rank,battle.paid,battle.type);
         if(this.battlesArray.length > this.maxBattlesNum)
         {
            this.battleList.createButton.enable = false;
         }
         if(this.battleToSelect != null && this.battleToSelect == battle.name)
         {
            this.selectBattle(clientObject,battle.battleId);
            this.battleToSelect = null;
         }
      }
      
      public function getBattleName(id:String) : String
      {
         return (this.battles[id] as BattleClient).name;
      }
      
      public function selectBattleFromChat(id:Long) : void
      {
      }
      
      public function removeBattle(clientObject:ClientObject, battleId:String) : void
      {
         if(this.battles == null)
         {
            return;
         }
         var battle:BattleClient = this.battles[battleId];
         this.battlesArray.splice(this.battlesArray.indexOf(battle),1);
         this.battles[battleId] = null;
         if(this.battleList.selectedBattleID == battleId)
         {
            this.hideInfo();
         }
         this.battleList.removeItem(battleId);
         if(this.battlesArray.length <= this.maxBattlesNum)
         {
            this.battleList.createButton.enable = true;
         }
      }
      
      public function setHaveSubscribe(clientObject:ClientObject, haveSubscribe:Boolean) : void
      {
         this.viewDM.haveSubscribe = haveSubscribe;
         this.viewTDM.haveSubscribe = haveSubscribe;
         this.createBattleForm.haveSubscribe = haveSubscribe;
      }
      
      public function showBattleInfo(clientObject:ClientObject, name:String, maxPeople:int, battleType:BattleType, battleId:String, previewId:String, minRank:int, maxRank:int, timeLimit:int, timeCurrent:int, killsLimit:int, scoreRed:int, scoreBlue:int, autobalance:Boolean, friendlyFire:Boolean, users:Array, paidBattle:Boolean, withoutBonuses:Boolean, userAlreadyPaid:Boolean, fullCash:Boolean, clanName:String, spectator:Boolean = false) : void
      {
         var previewBitmap:BitmapData = null;
         var url:String = null;
         var team:Boolean = false;
         var i:int = 0;
         var userInfo:UserInfoClient = null;
         Main.writeVarsToConsoleChannel("BATTLE SELECT","showBattleInfo");
         Main.writeVarsToConsoleChannel("BATTLE SELECT","   battleId: %1",battleId);
         Main.writeVarsToConsoleChannel("BATTLE SELECT","this.clientObject = %1",this.clientObject == clientObject);
         this.usersInfo = new Dictionary(false);
         var preivewResource:ImageResource = ResourceUtil.getResource(ResourceType.IMAGE,previewId) as ImageResource;
         if(preivewResource == null)
         {
            preivewResource = new ImageResource("",previewId,false,null,"");
         }
         if(!preivewResource.loaded())
         {
            preivewResource.completeLoadListener = this;
            preivewResource.load();
            this.viewBattleExpectedResourceId = preivewResource.id;
         }
         else
         {
            previewBitmap = preivewResource.bitmapData as BitmapData;
         }
         if(this.battleList != null)
         {
            this.battleList.select(battleId);
            url = "";
            if(this.addressService != null)
            {
               if(this.loaderParamsService.params["partner"] != null && this.addressService.getValue().indexOf("registered") != -1)
               {
                  this.addressService.setValue("battle/" + battleId.toString() + "/partner=" + this.loaderParamsService.params["partner"]);
               }
               else
               {
                  this.addressService.setValue("battle/" + battleId.toString());
               }
            }
            url = "#battle" + battleId;
            team = battleType == BattleType.CTF || battleType == BattleType.TDM || battleType == BattleType.DOM;
            this.showInfo(team);
            if(team)
            {
               this.viewTDM.Init(name,clanName,maxPeople,minRank,maxRank,scoreRed,scoreBlue,previewBitmap,timeLimit,timeCurrent,killsLimit,false,autobalance,friendlyFire,url,minRank <= this.panelModel.rank && maxRank >= this.panelModel.rank,battleType == BattleType.CTF,battleType == BattleType.DOM,paidBattle,!withoutBonuses,userAlreadyPaid,fullCash);
               for(i = 0; i < users.length; i++)
               {
                  userInfo = users[i] as UserInfoClient;
                  this.usersInfo[userInfo.id] = userInfo;
                  this.viewTDM.updatePlayer(userInfo.type == BattleTeamType.RED ? Boolean(ViewTDM.RED_TEAM) : Boolean(ViewTDM.BLUE_TEAM),userInfo.id,userInfo.name,userInfo.rank,userInfo.kills);
               }
               if(paidBattle && !userAlreadyPaid)
               {
                  this.viewTDM.addEventListener(BattleListEvent.START_TDM_BLUE,this.onStartPaidBlueTeamBattle);
                  this.viewTDM.addEventListener(BattleListEvent.START_TDM_RED,this.onStartPaidRedTeamBattle);
                  this.viewTDM.removeEventListener(BattleListEvent.START_TDM_BLUE,this.onStartTeamBattleForBlue);
                  this.viewTDM.removeEventListener(BattleListEvent.START_TDM_RED,this.onStartTeamBattleForRed);
               }
               else
               {
                  this.viewTDM.addEventListener(BattleListEvent.START_TDM_BLUE,this.onStartTeamBattleForBlue);
                  this.viewTDM.addEventListener(BattleListEvent.START_TDM_RED,this.onStartTeamBattleForRed);
                  this.viewTDM.removeEventListener(BattleListEvent.START_TDM_BLUE,this.onStartPaidBlueTeamBattle);
                  this.viewTDM.removeEventListener(BattleListEvent.START_TDM_RED,this.onStartPaidRedTeamBattle);
               }
               if(spectator)
               {
                  this.viewTDM.info.showSpectatorButton();
               }
            }
            else
            {
               this.viewDM.Init(name,clanName,maxPeople,minRank,maxRank,previewBitmap,timeLimit,timeCurrent,killsLimit,false,url,minRank <= this.panelModel.rank && maxRank >= this.panelModel.rank,paidBattle,!withoutBonuses,userAlreadyPaid,fullCash);
               for(i = 0; i < users.length; i++)
               {
                  userInfo = users[i] as UserInfoClient;
                  this.usersInfo[userInfo.id] = userInfo;
                  this.viewDM.updatePlayer(userInfo.id,userInfo.name,userInfo.rank,userInfo.kills);
               }
               if(paidBattle && !userAlreadyPaid)
               {
                  this.viewDM.addEventListener(BattleListEvent.START_DM_GAME,this.onStartPaidDMBattle);
                  this.viewDM.removeEventListener(BattleListEvent.START_DM_GAME,this.onStartDMBattle);
               }
               else
               {
                  this.viewDM.removeEventListener(BattleListEvent.START_DM_GAME,this.onStartPaidDMBattle);
                  this.viewDM.addEventListener(BattleListEvent.START_DM_GAME,this.onStartDMBattle);
               }
               if(spectator)
               {
                  this.viewDM.info.showSpectatorButton();
               }
            }
         }
      }
      
      public function currentBattleAddUser(clientObject:ClientObject, userInfo:UserInfoClient) : void
      {
         if(this.usersInfo == null)
         {
            this.usersInfo = new Dictionary();
         }
         this.usersInfo[userInfo.id] = userInfo;
         if(this.viewDM != null && this.layer.contains(this.viewDM))
         {
            this.viewDM.updatePlayer(userInfo.id,userInfo.name,userInfo.rank,userInfo.kills);
         }
         else if(this.viewTDM != null && this.layer.contains(this.viewTDM))
         {
            this.viewTDM.updatePlayer(userInfo.type == BattleTeamType.RED,userInfo.id,userInfo.name,userInfo.rank,userInfo.kills);
         }
      }
      
      public function currentBattleRemoveUser(clientObject:ClientObject, userId:String) : void
      {
         if(this.viewDM != null && this.layer.contains(this.viewDM))
         {
            this.viewDM.removePlayer(userId);
         }
         else if(this.viewTDM != null && this.layer.contains(this.viewTDM))
         {
            this.viewTDM.removePlayer(userId);
         }
      }
      
      public function teamScoreUpdate(clientObject:ClientObject, redTeamScore:int, blueTeamScore:int) : void
      {
         if(this.clientObject != null && this.clientObject == clientObject)
         {
            if(this.viewTDM != null)
            {
               this.viewTDM.updateScore(ViewTDM.RED_TEAM,redTeamScore);
               this.viewTDM.updateScore(ViewTDM.BLUE_TEAM,blueTeamScore);
            }
         }
      }
      
      public function updateUsersCountForTeam(clientObject:ClientObject, battleId:String, redPeople:int, bluePeople:int) : void
      {
         var b:BattleClient = null;
         if(this.battles != null)
         {
            b = this.battles[battleId] as BattleClient;
            if(b != null)
            {
               b.countRedPeople = redPeople;
               b.countBluePeople = bluePeople;
               if(this.battleList != null)
               {
                  this.battleList.updatePlayersBlue(battleId,bluePeople,bluePeople >= b.maxPeople);
                  this.battleList.updatePlayersRed(battleId,redPeople,redPeople >= b.maxPeople);
               }
            }
         }
      }
      
      public function updateUsersCountForDM(clientObject:ClientObject, battleId:String, peoples:int) : void
      {
         var b:BattleClient = null;
         if(this.battles != null)
         {
            b = this.battles[battleId] as BattleClient;
            if(b != null)
            {
               b.countPeople = peoples;
               if(this.battleList != null)
               {
                  this.battleList.updatePlayersTotal(battleId,peoples,peoples >= b.maxPeople);
               }
            }
         }
      }
      
      public function currentBattleRestart(clientObject:ClientObject) : void
      {
         if(this.clientObject != null && this.clientObject == clientObject)
         {
            if(this.viewDM != null && this.layer.contains(this.viewDM))
            {
               this.viewDM.info.restartCountDown();
               this.viewDM.dropKills();
            }
            else if(this.viewTDM != null && this.layer.contains(this.viewTDM))
            {
               this.viewTDM.info.restartCountDown();
               this.viewTDM.dropKills();
            }
         }
      }
      
      public function currentBattleUserScoreUpdate(clientObject:ClientObject, user:Long, kills:int) : void
      {
         var userInfo:UserInfoClient = null;
         var logger:ILogService = null;
         if(this.clientObject != null && this.clientObject == clientObject)
         {
            userInfo = this.usersInfo[user] as UserInfoClient;
            if(userInfo != null)
            {
               userInfo.kills = kills;
               if(this.viewDM != null && this.layer.contains(this.viewDM))
               {
                  this.viewDM.updatePlayer(user,userInfo.name,userInfo.rank,kills);
               }
               else if(this.viewTDM != null && this.layer.contains(this.viewTDM))
               {
                  this.viewTDM.updatePlayer(userInfo.type == BattleTeamType.RED,user,userInfo.name,userInfo.rank,kills);
               }
            }
            else
            {
               logger = Main.osgi.getService(ILogService) as ILogService;
               logger.log(LogLevel.LOG_ERROR,"[BattleSelectModel]:currentBattleUserKillsUpdate  ERROR: userInfo = null! (userId: " + user + ")");
            }
         }
      }
      
      public function currentBattleFinish(clientObject:ClientObject) : void
      {
         if(this.clientObject != null && this.clientObject == clientObject)
         {
            if(this.layer.contains(this.viewDM))
            {
               this.viewDM.info.stopCountDown();
            }
            else if(this.layer.contains(this.viewTDM))
            {
               this.viewTDM.info.stopCountDown();
            }
         }
      }
      
      public function battleCreated(clientObject:ClientObject, battleId:Long) : void
      {
         if(this.clientObject != null && this.clientObject == clientObject)
         {
            this.battleList.select(battleId);
         }
      }
      
      public function createBattleFlood(clientObject:ClientObject) : void
      {
         var alertService:IAlertService = Main.osgi.getService(IAlertService) as IAlertService;
         alertService.showAlert(ILocaleService(Main.osgi.getService(ILocaleService)).getText(TextConst.BATTLE_CREATE_PANEL_FLOOD_ALERT_TEXT));
      }
      
      private function checkSelectedBattle() : String
      {
         var selectedBattleId:String = null;
         var s:String = null;
         var v:Array = null;
         if(this.addressService != null)
         {
            s = this.addressService.getValue();
            if(s.indexOf("battle/") != -1)
            {
               v = s.split("/");
               if(v[2] != null)
               {
                  selectedBattleId = v[2] as String;
               }
            }
         }
         return selectedBattleId;
      }
      
      private function onAddressChange(e:SWFAddressEvent) : void
      {
         var i:int = 0;
         var selectedBattleId:String = this.checkSelectedBattle();
         if(selectedBattleId != null)
         {
            for(i = 0; i < this.battlesArray.length; i++)
            {
               if((this.battlesArray[i] as BattleClient).battleId == selectedBattleId && selectedBattleId != this.battleList.selectedBattleID)
               {
                  Main.writeVarsToConsoleChannel("BATTLE SELECT","   select: %1",selectedBattleId);
                  this.battleList.select(selectedBattleId);
               }
            }
         }
      }
      
      public function showList() : void
      {
         if(!this.layer.contains(this.battleList))
         {
            this.layer.addChild(this.battleList);
            this.battleList.addEventListener(BattleListEvent.CREATE_GAME,this.onCreateGameClick);
            this.battleList.addEventListener(BattleListEvent.SELECT_BATTLE,this.onBattleSelect);
         }
      }
      
      public function hideList() : void
      {
         if(this.battleList != null)
         {
            if(this.layer.contains(this.battleList))
            {
               this.layer.removeChild(this.battleList);
               this.battleList.removeEventListener(BattleListEvent.CREATE_GAME,this.onCreateGameClick);
               this.battleList.removeEventListener(BattleListEvent.SELECT_BATTLE,this.onBattleSelect);
            }
         }
      }
      
      private function showCreateForm() : void
      {
         var panelModel:IPanel = null;
         if(!this.layer.contains(this.createBattleForm))
         {
            if(this.createBattleForm != null)
            {
               this.layer.addChild(this.createBattleForm);
            }
            panelModel = IPanel(Main.osgi.getService(IPanel));
            this.createBattleForm.currentRang = panelModel.rank;
            this.createBattleForm.addEventListener(BattleListEvent.START_CREATED_GAME,this.onStartCreatedGame);
         }
      }
      
      private function hideCreateForm() : void
      {
         if(this.createBattleForm != null)
         {
            if(this.layer.contains(this.createBattleForm))
            {
               this.layer.removeChild(this.createBattleForm);
               this.createBattleForm.removeEventListener(BattleListEvent.START_CREATED_GAME,this.onStartCreatedGame);
            }
         }
      }
      
      private function showInfo(team:Boolean) : void
      {
         if(team)
         {
            if(this.layer.contains(this.viewDM))
            {
               this.layer.removeChild(this.viewDM);
            }
            if(!this.layer.contains(this.viewTDM))
            {
               this.layer.addChild(this.viewTDM);
            }
         }
         else
         {
            if(this.layer.contains(this.viewTDM))
            {
               this.layer.removeChild(this.viewTDM);
            }
            if(!this.layer.contains(this.viewDM))
            {
               this.layer.addChild(this.viewDM);
            }
         }
      }
      
      private function hideInfo() : void
      {
         if(this.viewDM != null)
         {
            if(this.layer.contains(this.viewDM))
            {
               this.layer.removeChild(this.viewDM);
            }
         }
         if(this.viewTDM != null)
         {
            if(this.layer.contains(this.viewTDM))
            {
               this.layer.removeChild(this.viewTDM);
            }
         }
      }
      
      private function onMapSelect(e:Event) : void
      {
         var previewBitmap:BitmapData = null;
         var previewId:String = (this.maps[this.createBattleForm.mapID] as MapClient).previewId;
         Main.writeVarsToConsoleChannel("BATTLE SELECT","1   previewId: " + previewId);
         (Main.osgi.getService(IConsole) as IConsole).addLine("onMapSelect(): try get resources: " + previewId);
         var imageResource:ImageResource = ResourceUtil.getResource(ResourceType.IMAGE,previewId) as ImageResource;
         if(imageResource == null)
         {
            imageResource = new ImageResource("",previewId,false,null,"");
            (Main.osgi.getService(IConsole) as IConsole).addLine("onMapSelect(): try get failed. resources is null: " + previewId);
         }
         if(!imageResource.loaded())
         {
            imageResource.completeLoadListener = this;
            imageResource.load();
            this.createBattleExpectedResourceId = imageResource.id;
         }
         else
         {
            previewBitmap = imageResource.bitmapData as BitmapData;
            this.createBattleExpectedResourceId = null;
            this.createBattleForm.info.setPreview(previewBitmap);
         }
         Main.writeVarsToConsoleChannel("BATTLE SELECT","1   previewBitmap: " + previewBitmap);
      }
      
      private function onCreateGameClick(e:BattleListEvent) : void
      {
         this.hideInfo();
         this.showCreateForm();
         if(this.battlesArray.length > this.maxBattlesNum)
         {
            this.battleList.createButton.enable = false;
         }
      }
      
      private function onStartCreatedGame(e:BattleListEvent) : void
      {
         this.battleToSelect = !!this.createBattleForm.HrMode ? "(HR Mode) " + this.createBattleForm.gameName : this.createBattleForm.gameName;
         if(this.createBattleForm.deathMatch)
         {
            this.createBattle(this.clientObject,this.createBattleForm.gameName,this.createBattleForm.mapID as String,this.createBattleForm.time,this.createBattleForm.numKills,this.createBattleForm.numPlayers,this.createBattleForm.minRang,this.createBattleForm.maxRang,this.createBattleForm.PrivateBattle,this.createBattleForm.PayBattle,!!this.createBattleForm.PayBattle ? Boolean(!this.createBattleForm.inventoryBattle) : Boolean(false),this.createBattleForm.HrMode);
         }
         else if(this.createBattleForm.CaptureTheFlag)
         {
            this.createBattleCaptureFlag(this.clientObject,this.createBattleForm.gameName,this.createBattleForm.mapID as String,this.createBattleForm.time,this.createBattleForm.numFlags,this.createBattleForm.numPlayers,this.createBattleForm.minRang,this.createBattleForm.maxRang,this.createBattleForm.autoBalance,this.createBattleForm.friendlyFire,this.createBattleForm.PrivateBattle,this.createBattleForm.PayBattle,!!this.createBattleForm.PayBattle ? Boolean(!this.createBattleForm.inventoryBattle) : Boolean(false),this.createBattleForm.HrMode);
         }
         else if(this.createBattleForm.Team)
         {
            this.createBattleTeam(this.clientObject,this.createBattleForm.gameName,this.createBattleForm.mapID as String,this.createBattleForm.time,this.createBattleForm.numKills,this.createBattleForm.numPlayers,this.createBattleForm.minRang,this.createBattleForm.maxRang,this.createBattleForm.autoBalance,this.createBattleForm.friendlyFire,this.createBattleForm.PrivateBattle,this.createBattleForm.PayBattle,!!this.createBattleForm.PayBattle ? Boolean(!this.createBattleForm.inventoryBattle) : Boolean(false),this.createBattleForm.HrMode);
         }
         else if(this.createBattleForm.DOM)
         {
            this.createBattleDominationOfMap(this.clientObject,this.createBattleForm.gameName,this.createBattleForm.mapID as String,this.createBattleForm.time,this.createBattleForm.numPoints,this.createBattleForm.numPlayers,this.createBattleForm.minRang,this.createBattleForm.maxRang,this.createBattleForm.autoBalance,this.createBattleForm.friendlyFire,this.createBattleForm.PrivateBattle,this.createBattleForm.PayBattle,!!this.createBattleForm.PayBattle ? Boolean(!this.createBattleForm.inventoryBattle) : Boolean(false),this.createBattleForm.HrMode);
         }
         this.hideCreateForm();
      }
      
      private function createBattleDominationOfMap(clientObject:ClientObject, gameName:String, mapId:String, time:int, numPointsScore:int, numPlayers:int, minRang:int, maxRang:int, autoBalance:Boolean, friendlyFire:Boolean, privateBattle:Boolean, payBattle:Boolean, inventory:Boolean, hrMode:Boolean) : void
      {
         var json:Object = new Object();
         json.gameName = gameName;
         json.mapId = mapId;
         json.time = time;
         json.numPointsScore = numPointsScore;
         json.numPlayers = numPlayers;
         json.minRang = minRang;
         json.maxRang = maxRang;
         json.autoBalance = autoBalance;
         json.frielndyFire = friendlyFire;
         json.privateBattle = privateBattle;
         json.pay = payBattle;
         json.inventory = inventory;
         json.hrMode = hrMode;
         Network(Main.osgi.getService(INetworker)).send("lobby;try_create_battle_dom;" + JSON.stringify(json));
      }
      
      private function createBattleCaptureFlag(clientObject:ClientObject, gameName:String, mapId:String, time:int, numFlags:int, numPlayers:int, minRang:int, maxRang:int, autoBalance:Boolean, friendlyFire:Boolean, privateBattle:Boolean, payBattle:Boolean, inventory:Boolean, hrMode:Boolean) : void
      {
         var json:Object = new Object();
         json.gameName = gameName;
         json.mapId = mapId;
         json.time = time;
         json.numFlags = numFlags;
         json.numPlayers = numPlayers;
         json.minRang = minRang;
         json.maxRang = maxRang;
         json.autoBalance = autoBalance;
         json.frielndyFire = friendlyFire;
         json.privateBattle = privateBattle;
         json.pay = payBattle;
         json.inventory = inventory;
         json.hrMode = hrMode;
         Network(Main.osgi.getService(INetworker)).send("lobby;try_create_battle_ctf;" + JSON.stringify(json));
      }
      
      private function createBattleTeam(cl:ClientObject, gameName:String, mapId:String, time:int, numKills:int, numPlayers:int, minRang:int, maxRang:int, autoBalance:Boolean, frielndyFire:Boolean, privateBattle:Boolean, pay:Boolean, inventory:Boolean, hrMode:Boolean) : void
      {
         var json:Object = new Object();
         json.gameName = gameName;
         json.mapId = mapId;
         json.time = time;
         json.numKills = numKills;
         json.numPlayers = numPlayers;
         json.minRang = minRang;
         json.maxRang = maxRang;
         json.autoBalance = autoBalance;
         json.frielndyFire = frielndyFire;
         json.privateBattle = privateBattle;
         json.pay = pay;
         json.inventory = inventory;
         json.hrMode = hrMode;
         Network(Main.osgi.getService(INetworker)).send("lobby;try_create_battle_tdm;" + JSON.stringify(json));
      }
      
      private function createBattle(cl:ClientObject, gameName:String, id:String, time:Number, numKills:Number, numPlayers:Number, minRang:int, maxRang:int, isPrivate:Boolean, isPay:Boolean, isX3:Boolean, hrMode:Boolean) : void
      {
         Network(Main.osgi.getService(INetworker)).send("lobby;try_create_battle_dm;" + gameName + ";" + id + ";" + time + ";" + numKills + ";" + numPlayers + ";" + minRang + ";" + maxRang + ";" + isPrivate + ";" + isPay + ";" + isX3 + ";" + hrMode);
      }
      
      private function onBattleSelect(e:BattleListEvent) : void
      {
         this.selectBattle(this.clientObject,this.battleList.selectedBattleID as String);
         var b:BattleClient = this.battles[this.battleList.selectedBattleID as String] as BattleClient;
         if(b.minRank > this.panelModel.rank || b.maxRank < this.panelModel.rank)
         {
            this.lockedMapsHelper.targetPoint = new Point(Main.stage.mouseX,Main.stage.mouseY);
         }
      }
      
      private function selectBattle(cl:ClientObject, id:String) : void
      {
         Network(Main.osgi.getService(INetworker)).send("lobby;get_show_battle_info;" + id);
      }
      
      private function onStartPaidDMBattle(e:BattleListEvent) : void
      {
         this.panelModel.blur();
         if(this.panelModel.crystal < 5)
         {
            this.paidBattleAlert = new Alert(-1);
            this.paidBattleAlert.showAlert(this.localeService.getText(TextConst.GARAGE_CONFIRM_ALERT_NOT_ENOUGH_CRYSTALS),["OK"]);
            this.dialogsLayer.addChild(this.paidBattleAlert);
            this.paidBattleAlert.addEventListener(AlertEvent.ALERT_BUTTON_PRESSED,function(e:Event):void
            {
               panelModel.unblur();
            });
            return;
         }
         this.paidBattleAlert = new Alert();
         this.paidBattleAlert.showAlert(this.localeService.getText(TextConst.BATTLEINFO_PANEL_PAID_BATTLES_ALERT_TEXT),[this.localeService.getText(TextConst.BATTLEINFO_PANEL_PAID_BATTLES_ALERT_ANSWER_ENTER),this.localeService.getText(TextConst.BATTLEINFO_PANEL_PAID_BATTLES_ALERT_ANSWER_DONT_ENTER)]);
         this.dialogsLayer.addChild(this.paidBattleAlert);
         this.paidBattleAlert.addEventListener(AlertEvent.ALERT_BUTTON_PRESSED,this.onAcceptPaidDMBattle);
      }
      
      private function onStartPaidRedTeamBattle(e:BattleListEvent) : void
      {
         this.panelModel.blur();
         if(this.panelModel.crystal < 5)
         {
            this.paidBattleAlert = new Alert(-1);
            this.paidBattleAlert.showAlert(this.localeService.getText(TextConst.GARAGE_CONFIRM_ALERT_NOT_ENOUGH_CRYSTALS),["OK"]);
            this.dialogsLayer.addChild(this.paidBattleAlert);
            this.paidBattleAlert.addEventListener(AlertEvent.ALERT_BUTTON_PRESSED,function(e:Event):void
            {
               panelModel.unblur();
            });
            return;
         }
         this.paidBattleAlert = new Alert();
         this.paidBattleAlert.showAlert(this.localeService.getText(TextConst.BATTLEINFO_PANEL_PAID_BATTLES_ALERT_TEXT),[this.localeService.getText(TextConst.BATTLEINFO_PANEL_PAID_BATTLES_ALERT_ANSWER_ENTER),this.localeService.getText(TextConst.BATTLEINFO_PANEL_PAID_BATTLES_ALERT_ANSWER_DONT_ENTER)]);
         this.dialogsLayer.addChild(this.paidBattleAlert);
         this.paidBattleAlert.addEventListener(AlertEvent.ALERT_BUTTON_PRESSED,this.onAcceptPaidRedTeamBattle);
      }
      
      private function onStartPaidBlueTeamBattle(e:BattleListEvent) : void
      {
         this.panelModel.blur();
         if(this.panelModel.crystal < 5)
         {
            this.paidBattleAlert = new Alert(-1);
            this.paidBattleAlert.showAlert(this.localeService.getText(TextConst.GARAGE_CONFIRM_ALERT_NOT_ENOUGH_CRYSTALS),["OK"]);
            this.dialogsLayer.addChild(this.paidBattleAlert);
            this.paidBattleAlert.addEventListener(AlertEvent.ALERT_BUTTON_PRESSED,function(e:Event):void
            {
               panelModel.unblur();
            });
            return;
         }
         this.paidBattleAlert = new Alert();
         this.paidBattleAlert.showAlert(this.localeService.getText(TextConst.BATTLEINFO_PANEL_PAID_BATTLES_ALERT_TEXT),[this.localeService.getText(TextConst.BATTLEINFO_PANEL_PAID_BATTLES_ALERT_ANSWER_ENTER),this.localeService.getText(TextConst.BATTLEINFO_PANEL_PAID_BATTLES_ALERT_ANSWER_DONT_ENTER)]);
         this.dialogsLayer.addChild(this.paidBattleAlert);
         this.paidBattleAlert.addEventListener(AlertEvent.ALERT_BUTTON_PRESSED,this.onAcceptPaidBlueTeamBattle);
      }
      
      private function onAcceptPaidDMBattle(e:AlertEvent) : void
      {
         this.panelModel.unblur();
         if(e.typeButton == this.localeService.getText(TextConst.BATTLEINFO_PANEL_PAID_BATTLES_ALERT_ANSWER_ENTER))
         {
            this.clearURL = false;
            this.viewDM.removeEventListener(BattleListEvent.START_DM_GAME,this.onStartPaidDMBattle);
            this.fightBattle(this.clientObject,false,false);
         }
      }
      
      private function onAcceptPaidRedTeamBattle(e:AlertEvent) : void
      {
         this.panelModel.unblur();
         if(e.typeButton == this.localeService.getText(TextConst.BATTLEINFO_PANEL_PAID_BATTLES_ALERT_ANSWER_ENTER))
         {
            this.clearURL = false;
            this.viewTDM.removeEventListener(BattleListEvent.START_TDM_BLUE,this.onStartPaidBlueTeamBattle);
            this.viewTDM.removeEventListener(BattleListEvent.START_TDM_RED,this.onStartPaidRedTeamBattle);
            this.fightBattle(this.clientObject,true,true);
         }
      }
      
      private function onAcceptPaidBlueTeamBattle(e:AlertEvent) : void
      {
         this.panelModel.unblur();
         if(e.typeButton == this.localeService.getText(TextConst.BATTLEINFO_PANEL_PAID_BATTLES_ALERT_ANSWER_ENTER))
         {
            this.clearURL = false;
            this.viewTDM.removeEventListener(BattleListEvent.START_TDM_BLUE,this.onStartPaidBlueTeamBattle);
            this.viewTDM.removeEventListener(BattleListEvent.START_TDM_RED,this.onStartPaidRedTeamBattle);
            this.fightBattle(this.clientObject,true,false);
         }
      }
      
      private function onStartDMBattle(e:BattleListEvent) : void
      {
         this.clearURL = false;
         this.viewDM.removeEventListener(BattleListEvent.START_DM_GAME,this.onStartDMBattle);
         this.fightBattle(this.clientObject,false,false);
      }
      
      private function fightBattle(cl:ClientObject, team:Boolean, red:Boolean) : void
      {
         Network(Main.osgi.getService(INetworker)).send("lobby;" + (!team ? "enter_battle;" : "enter_battle_team;") + this.selectedBattleId + ";" + red);
      }
      
      public function startLoadBattle() : void
      {
         var temp:BattleController = null;
         this.objectUnloaded(null);
         PanelModel(Main.osgi.getService(IPanel)).startBattle(null);
         ChatModel(Main.osgi.getService(IChatModelBase)).objectUnloaded(null);
         if(BattleController(Main.osgi.getService(IBattleController)) == null)
         {
            temp = new BattleController();
            Main.osgi.registerService(IBattleController,temp);
         }
         Network(Main.osgi.getService(INetworker)).addEventListener(Main.osgi.getService(IBattleController) as BattleController);
      }
      
      private function onStartTeamBattleForRed(e:BattleListEvent) : void
      {
         this.clearURL = false;
         this.viewDM.removeEventListener(BattleListEvent.START_TDM_RED,this.onStartTeamBattleForRed);
         this.viewDM.removeEventListener(BattleListEvent.START_TDM_BLUE,this.onStartTeamBattleForBlue);
         this.fightBattle(this.clientObject,true,true);
      }
      
      private function onStartTeamBattleForBlue(e:BattleListEvent) : void
      {
         this.clearURL = false;
         this.viewDM.removeEventListener(BattleListEvent.START_TDM_RED,this.onStartTeamBattleForRed);
         this.viewDM.removeEventListener(BattleListEvent.START_TDM_BLUE,this.onStartTeamBattleForBlue);
         this.fightBattle(this.clientObject,true,false);
      }
      
      public function dump(params:Vector.<String>) : String
      {
         var battle:BattleClient = null;
         var result:String = "\n";
         for(var i:int = 0; i < this.battlesArray.length; i++)
         {
            battle = this.battlesArray[i] as BattleClient;
            result += "   battle id: " + battle.battleId + "   battle name: " + battle.name + "   map id: " + battle.mapId + "\n";
         }
         return result + "\n";
      }
      
      public function get dumperName() : String
      {
         return "battle";
      }
      
      private function alignHelpers(e:Event = null) : void
      {
         var minWidth:int = int(Math.max(1000,Main.stage.stageWidth));
         var minHeight:int = int(Math.max(600,Main.stage.stageHeight));
         this.createHelper.targetPoint = new Point(Math.round(minWidth * (2 / 3)) - 47,minHeight - 34);
      }
      
      private function checkBattleName(event:BattleListEvent) : void
      {
         this.gameNameBeforeCheck = this.createBattleForm.gameName;
         this.checkBattleNameForForbiddenWords(this.clientObject,this.createBattleForm.gameName);
      }
      
      private function checkBattleNameForForbiddenWords(cl:ClientObject, forCheck:String) : void
      {
         Network(Main.osgi.getService(INetworker)).send("lobby;check_battleName_for_forbidden_words;" + forCheck);
      }
      
      public function setFilteredBattleName(clientObject:ClientObject, name:String) : void
      {
         if(this.createBattleForm.gameName == this.gameNameBeforeCheck && this.gameNameBeforeCheck != name)
         {
            this.createBattleForm.gameName = name;
         }
         else
         {
            this.createBattleForm.gameName = this.createBattleForm.gameName;
         }
      }
      
      public function serverIsRestarting(clientObject:ClientObject) : void
      {
         var serverIsRestartingAlert:Alert = new Alert();
         serverIsRestartingAlert.showAlert(this.localeService.getText(TextConst.SERVER_IS_RESTARTING_CREATE_BATTLE_TEXT),[AlertAnswer.OK]);
         this.dialogsLayer.addChild(serverIsRestartingAlert);
      }
      
      public function enterInBattleSpectator() : void
      {
         var temp:BattleController = null;
         this.objectUnloaded(null);
         PanelModel(Main.osgi.getService(IPanel)).startBattle(null);
         ChatModel(Main.osgi.getService(IChatModelBase)).objectUnloaded(null);
         if(BattleController(Main.osgi.getService(IBattleController)) == null)
         {
            temp = new BattleController();
            Main.osgi.registerService(IBattleController,temp);
         }
         Network(Main.osgi.getService(INetworker)).send("lobby;enter_battle_spectator;" + this.selectedBattleId);
         Network(Main.osgi.getService(INetworker)).addEventListener(Main.osgi.getService(IBattleController) as BattleController);
      }
   }
}
