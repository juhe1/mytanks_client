package
{
   import alternativa.init.BattleSelectModelActivator;
   import alternativa.init.ChatModelActivator;
   import alternativa.init.GarageModelActivator;
   import alternativa.init.Main;
   import alternativa.model.IModel;
   import alternativa.osgi.service.locale.ILocaleService;
   import alternativa.osgi.service.storage.IStorageService;
   import alternativa.service.IModelService;
   import alternativa.tanks.gui.shopitems.item.kits.description.KitsInfoData;
   import alternativa.tanks.model.Friend;
   import alternativa.tanks.model.GarageModel;
   import alternativa.tanks.model.IGarage;
   import alternativa.tanks.model.IItemEffect;
   import alternativa.tanks.model.ItemEffectModel;
   import alternativa.tanks.model.ItemParams;
   import alternativa.tanks.model.achievement.Achievement;
   import alternativa.tanks.model.achievement.AchievementModel;
   import alternativa.tanks.model.achievement.IAchievementModel;
   import alternativa.tanks.model.challenge.ChallengeModel;
   import alternativa.tanks.model.challenge.ChallengePrizeInfo;
   import alternativa.tanks.model.challenge.IChallenge;
   import alternativa.tanks.model.challenge.server.ChallengeServerData;
   import alternativa.tanks.model.challenge.server.UserProgressServerData;
   import alternativa.tanks.model.gift.server.GiftServerItem;
   import alternativa.tanks.model.gift.server.GiftServerModel;
   import alternativa.tanks.model.gift.server.IGiftServerModel;
   import alternativa.tanks.model.news.INewsModel;
   import alternativa.tanks.model.news.NewsItemServer;
   import alternativa.tanks.model.news.NewsModel;
   import alternativa.tanks.model.panel.IPanel;
   import alternativa.tanks.model.panel.PanelModel;
   import alternativa.tanks.model.profile.server.UserGiftServerItem;
   import alternativa.tanks.model.user.IUserData;
   import alternativa.tanks.model.user.UserData;
   import alternativa.types.Long;
   import com.alternativaplatform.client.models.core.community.chat.types.ChatMessage;
   import com.alternativaplatform.client.models.core.community.chat.types.UserChat;
   import com.alternativaplatform.projects.tanks.client.commons.models.itemtype.ItemTypeEnum;
   import com.alternativaplatform.projects.tanks.client.commons.types.ItemProperty;
   import com.alternativaplatform.projects.tanks.client.garage.garage.ItemInfo;
   import com.alternativaplatform.projects.tanks.client.garage.item.ItemPropertyValue;
   import com.alternativaplatform.projects.tanks.client.garage.item.ModificationInfo;
   import flash.net.SharedObject;
   import flash.net.URLRequest;
   import flash.net.navigateToURL;
   import forms.Alert;
   import forms.AlertAnswer;
   import projects.tanks.client.battlefield.gui.models.chat.IChatModelBase;
   import projects.tanks.client.battleselect.IBattleSelectModelBase;
   import projects.tanks.client.battleselect.types.BattleClient;
   import projects.tanks.client.battleselect.types.MapClient;
   import projects.tanks.client.battleselect.types.UserInfoClient;
   import projects.tanks.client.battleservice.model.BattleType;
   import projects.tanks.client.battleservice.model.team.BattleTeamType;
   import projects.tanks.client.panel.model.shop.kitpackage.KitPackageItemInfo;
   import scpacker.networking.INetworkListener;
   import scpacker.networking.INetworker;
   import scpacker.networking.Network;
   import scpacker.networking.commands.Command;
   import scpacker.networking.commands.Type;
   import scpacker.resource.ResourceType;
   import scpacker.resource.ResourceUtil;
   import scpacker.server.models.bonus.ServerBonusModel;
   
   public class Lobby implements INetworkListener
   {
      
      public static var firstInit:Boolean = true;
       
      
      public var chat:ChatModelActivator;
      
      public var battleSelect:BattleSelectModelActivator;
      
      public var garage:GarageModelActivator;
      
      private var networker:Network;
      
      private var nullCommand:String;
      
      private var chatInited:Boolean = false;
      
      private const greenColor:uint = 8454016;
      
      private const yellowColor:uint = 15335168;
      
      private var bonusModel:ServerBonusModel;
      
      private var modelRegister:IModelService;
      
      private var itemEffectModel:ItemEffectModel;
      
      private var waitForLoad = false;
      
      private var listInited:Boolean = false;
      
      public function Lobby()
      {
         this.bonusModel = new ServerBonusModel();
         super();
         this.chat = new ChatModelActivator();
         this.battleSelect = new BattleSelectModelActivator();
         this.garage = new GarageModelActivator();
         this.garage.start(Main.osgi);
         this.modelRegister = Main.osgi.getService(IModelService) as IModelService;
         this.itemEffectModel = (this.modelRegister.getModelsByInterface(IItemEffect) as Vector.<IModel>)[0] as IItemEffect as ItemEffectModel;
      }
      
      public function onData(data:Command) : void
      {
         var parser:Object = null;
         var questsModel:ChallengeModel = null;
         var quest:ChallengeServerData = null;
         var prizes:Array = null;
         var p:String = null;
         var idOldItem:String = null;
         var special:Object = null;
         var specQuest:ChallengeServerData = null;
         var specialPrizes:Array = null;
         var _prize:Object = null;
         var prize:ChallengePrizeInfo = null;
         var alert:Alert = null;
         var parserGifts:Object = null;
         var itemsGift:Array = null;
         var parserInfo:Object = null;
         var storage:SharedObject = null;
         parser = null;
         var info:UserInfoClient = null;
         var achievementModel:AchievementModel = null;
         var temp:BattleController = null;
         var effect:* = undefined;
         var id:String = null;
         var time:Number = NaN;
         var newsModel:NewsModel = null;
         var news:Vector.<NewsItemServer> = null;
         var news_item:* = undefined;
         questsModel = null;
         var progress:UserProgressServerData = null;
         var quests:Array = null;
         var q:Object = null;
         quest = null;
         prizes = null;
         p = null;
         var achievements:Vector.<Achievement> = null;
         var achievementId:Object = null;
         var achievement:Achievement = null;
         var giftsModel:GiftServerModel = null;
         var items:Array = null;
         var _item:* = undefined;
         var j:Array = null;
         var oldItem:ItemParams = null;
         idOldItem = null;
         var item:ItemParams = null;
         var item_info:ItemInfo = null;
         var parser1:Object = null;
         switch(data.type)
         {
            case Type.LOBBY_CHAT:
               if(data.args[0] == "system")
               {
                  if(!this.chatInited)
                  {
                     this.chatInited = true;
                  }
                  this.chat.chatModel.chatPanel.addMessage("",0,0,data.args[1],0,0,"",true,data.args[2] == "yellow" ? uint(this.yellowColor) : uint(this.greenColor));
               }
               else if(data.args[0] == "init_chat")
               {
                  storage = IStorageService(Main.osgi.getService(IStorageService)).getStorage();
                  if(storage.data.showNewRules)
                  {
                     return;
                  }
                  this.bonusModel.showRulesUpdate();
                  storage.data.showNewRules = true;
               }
               else if(data.args[0] == "clear_all")
               {
                  if(!this.chatInited)
                  {
                     this.chatInited = true;
                  }
                  this.chat.chatModel.cleanUsersMessages(null,"");
               }
               else if(data.args[0] == "init_messages")
               {
                  Main.osgi.registerService(IChatModelBase,this.chat.chatModel);
                  this.chat.chatModel.initObject(Game.getInstance.classObject,["vk.com/scpacker"],(Main.osgi.getService(IUserData) as UserData).name);
                  this.chat.chatModel.objectLoaded(Game.getInstance.classObject);
                  this.parseChatMessages(data.args[1]);
               }
               else if(data.args[0] == "clean_by")
               {
                  this.chat.chatModel.cleanUsersMessages(null,data.args[1]);
               }
               else if(data.args[0] == "clean_by_text")
               {
                  this.chat.chatModel.cleanMessages(data.args[1]);
               }
               else
               {
                  if(!this.chatInited)
                  {
                     this.chatInited = true;
                  }
                  this.parseAndAddMessageToChat(data.args[0]);
               }
               break;
            case Type.LOBBY:
               if(data.args[0] == "init_panel")
               {
                  this.parseAndInitPanelInfo(data.args[1]);
               }
               else if(data.args[0] == "add_crystall")
               {
                  PanelModel(Main.osgi.getService(IPanel)).updateCrystal(null,int(data.args[1]));
               }
               else if(data.args[0] == "add_score")
               {
                  PanelModel(Main.osgi.getService(IPanel)).updateScore(null,int(data.args[1]));
               }
               else if(data.args[0] == "update_rang_progress")
               {
                  PanelModel(Main.osgi.getService(IPanel)).updateRankProgress(null,int(data.args[1]));
               }
               else if(data.args[0] == "update_rang")
               {
                  PanelModel(Main.osgi.getService(IPanel)).updateRang(null,int(data.args[1]),int(data.args[2]));
               }
               else if(data.args[0] == "init_battle_select")
               {
                  this.parseAndInitBattlesList(data.args[1]);
               }
               else if(data.args[0] == "create_battle")
               {
                  this.parseBattle(data.args[1]);
               }
               else if(data.args[0] == "start_battle")
               {
                  this.battleSelect.battleSelectModel.startLoadBattle();
               }
               else if(data.args[0] == "check_battle_name")
               {
                  this.battleSelect.battleSelectModel.setFilteredBattleName(null,data.args[1]);
               }
               else if(data.args[0] == "show_battle_info")
               {
                  this.parseBattleInfo(data.args[1]);
               }
               else if(data.args[0] == "navigate_url")
               {
                  navigateToURL(new URLRequest(data.args[1]),"_self");
                  PanelModel(Main.osgi.getService(IPanel)).unlock();
               }
               else if(data.args[0] == "show_discount_window")
               {
                  PanelModel(Main.osgi.getService(IPanel)).openDiscountWindow(data.args[1],data.args[2],data.args[3]);
               }
               else if(data.args[0] == "show_quests")
               {
                  trace(data.args[1]);
                  parser = JSON.parse(data.args[1]);
                  questsModel = Main.osgi.getService(IChallenge) as ChallengeModel;
                  quest = new ChallengeServerData();
                  quest.description = parser.description;
                  quest.id = parser.id;
                  quest.target_progress = parser.target_progress;
                  quest.progress = parser.progress;
                  prizes = new Array();
                  for each(p in parser.prizes)
                  {
                     prizes.push(p);
                  }
                  quest.prizes = prizes;
                  quest.completed = parser.completed;
                  quest.changeCost = parser.changeCost;
                  if(parser.special != null)
                  {
                     special = parser.special;
                     specQuest = new ChallengeServerData();
                     specQuest.description = special.description;
                     specQuest.id = special.id;
                     specQuest.target_progress = special.target_progress;
                     specQuest.progress = special.progress;
                     specialPrizes = new Array();
                     for each(p in special.prizes)
                     {
                        specialPrizes.push(p);
                     }
                     specQuest.prizes = specialPrizes;
                     quest.specialChallenge = specQuest;
                  }
                  questsModel.show(quest);
                  PanelModel(Main.osgi.getService(IPanel)).unlock();
               }
               else if(data.args[0] == "show_new_quests")
               {
                  trace(data.args[1]);
                  parser = JSON.parse(data.args[1]);
                  questsModel = Main.osgi.getService(IChallenge) as ChallengeModel;
                  quest = new ChallengeServerData();
                  quest.description = parser.description;
                  quest.id = parser.id;
                  quest.target_progress = parser.target_progress;
                  quest.progress = parser.progress;
                  prizes = new Array();
                  for each(p in parser.prizes)
                  {
                     prizes.push(p);
                  }
                  quest.prizes = prizes;
                  quest.completed = parser.completed;
                  quest.changeCost = parser.changeCost;
                  if(parser.special != null)
                  {
                     special = parser.special;
                     specQuest = new ChallengeServerData();
                     specQuest.description = special.description;
                     specQuest.id = special.id;
                     specQuest.target_progress = special.target_progress;
                     specQuest.progress = special.progress;
                     specialPrizes = new Array();
                     for each(p in special.prizes)
                     {
                        specialPrizes.push(p);
                     }
                     specQuest.prizes = specialPrizes;
                     quest.specialChallenge = specQuest;
                  }
                  questsModel.updateQuest(quest);
               }
               else if(data.args[0] == "show_quests_bonus")
               {
                  trace(data.args[1]);
                  parser = JSON.parse(data.args[1]);
                  prizes = new Array();
                  for each(_prize in parser.prizes)
                  {
                     prize = new ChallengePrizeInfo();
                     prize.count = _prize.count;
                     prize.nameId = _prize.nameId;
                     prizes.push(prize);
                  }
                  PanelModel(Main.osgi.getService(IPanel)).openChallegneCongratsWindow(prizes);
               }
               else if(data.args[0] == "show_alert_info")
               {
                  alert = new Alert();
                  alert.showAlert(data.args[1],[AlertAnswer.OK]);
                  Main.contentUILayer.addChild(alert);
                  PanelModel(Main.osgi.getService(IPanel)).unlock();
               }
               else if(data.args[0] == "init_friends_list")
               {
                  Friend.friends = data.args[1];
                  PanelModel(Main.osgi.getService(IPanel)).openFriends();
               }
               else if(data.args[0] == "update_friends_list")
               {
                  Friend.friends = data.args[1];
                  PanelModel(Main.osgi.getService(IPanel)).updateFriendsList();
               }
               else if(data.args[0] == "update_count_users_in_dm_battle")
               {
                  this.battleSelect.battleSelectModel.updateUsersCountForDM(null,data.args[1],data.args[2]);
               }
               else if(data.args[0] == "update_count_users_in_team_battle")
               {
                  parser = JSON.parse(data.args[1]);
                  this.battleSelect.battleSelectModel.updateUsersCountForTeam(null,parser.battleId,parser.redPeople,parser.bluePeople);
               }
               else if(data.args[0] == "remove_battle")
               {
                  this.battleSelect.battleSelectModel.removeBattle(null,data.args[1]);
               }
               else if(data.args[0] == "add_player_to_battle")
               {
                  parser = JSON.parse(data.args[1]);
                  if(parser.battleId != this.battleSelect.battleSelectModel.selectedBattleId)
                  {
                     return;
                  }
                  info = new UserInfoClient();
                  info.id = parser.id;
                  info.kills = parser.kills;
                  info.name = parser.name;
                  info.rank = parser.rank;
                  info.type = BattleTeamType.getType(parser.type);
                  info.isBot = parser.isBot;
                  this.battleSelect.battleSelectModel.currentBattleAddUser(null,info);
               }
               else if(data.args[0] == "remove_player_from_battle")
               {
                  parser = JSON.parse(data.args[1]);
                  if(parser.battleId != this.battleSelect.battleSelectModel.selectedBattleId)
                  {
                     return;
                  }
                  this.battleSelect.battleSelectModel.currentBattleRemoveUser(null,parser.id);
               }
               else if(data.args[0] == "server_message")
               {
                  Main.debug.showServerMessageWindow(data.args[1]);
               }
               else if(data.args[0] == "show_bonuses")
               {
                  this.bonusModel.showBonuses(data.args[1]);
               }
               else if(data.args[0] == "show_no_supplies")
               {
                  this.bonusModel.showNoSupplies();
               }
               else if(data.args[0] == "show_double_crystalls")
               {
                  this.bonusModel.showDoubleCrystalls();
               }
               else if(data.args[0] == "show_crystalls")
               {
                  this.bonusModel.showCrystalls(int(data.args[1]));
               }
               else if(data.args[0] == "show_nube_up_score")
               {
                  this.bonusModel.showNewbiesUpScore();
               }
               else if(data.args[0] == "show_nube_new_rank")
               {
                  achievementModel = Main.osgi.getService(IAchievementModel) as AchievementModel;
                  achievementModel.showNewRankCongratulationsWindow();
               }
               else if(data.args[0] == "init_battlecontroller")
               {
                  PanelModel(Main.osgi.getService(IPanel)).startBattle(null);
                  if(BattleController(Main.osgi.getService(IBattleController)) == null)
                  {
                     temp = new BattleController();
                     Main.osgi.registerService(IBattleController,temp);
                  }
                  Network(Main.osgi.getService(INetworker)).addEventListener(Main.osgi.getService(IBattleController) as BattleController);
               }
               else if(data.args[0] == "server_halt")
               {
                  PanelModel(Main.osgi.getService(IPanel)).serverHalt(null,50,0,0,null);
               }
               else if(data.args[0] == "show_profile")
               {
                  parser = JSON.parse(data.args[1]);
                  PanelModel(Main.osgi.getService(IPanel)).openProfile(null,parser.emailNotice,parser.isComfirmEmail,false,"","");
               }
               else if(data.args[0] == "open_profile")
               {
                  trace(data.args[1]);
                  trace(data.args[2]);
                  parserGifts = JSON.parse(data.args[1]).incoming;
                  itemsGift = new Array();
                  for each(_item in parserGifts)
                  {
                     itemsGift.push(new UserGiftServerItem(_item.userid,_item.giftid,_item.image,_item.name,_item.status,_item.message,_item.date));
                  }
                  parserInfo = JSON.parse(data.args[2]);
                  PanelModel(Main.osgi.getService(IPanel)).showGiftWindow(itemsGift,parserInfo);
               }
               else if(data.args[0] == "open_shop")
               {
                  PanelModel(Main.osgi.getService(IPanel)).onShopWindow(JSON.parse(data.args[1]));
               }
               else if(data.args[0] == "open_url")
               {
                  navigateToURL(new URLRequest(data.args[1]),"_self");
               }
               else if(data.args[0] == "donate_successfully")
               {
                  PanelModel(Main.osgi.getService(IPanel)).showPurchaseWindow(data.args[1],data.args[2],data.args[3]);
               }
               else if(data.args[0] == "open_recovery_window")
               {
                  PanelModel(Main.osgi.getService(IPanel)).openRecoveryWindow(data.args[1]);
               }
               else if(data.args[0] == "effect_stopped")
               {
                  this.itemEffectModel.effectStopped(data.args[1]);
               }
               else if(data.args[0] == "init_effect_model")
               {
                  parser = JSON.parse(data.args[1]);
                  for each(effect in parser.effects)
                  {
                     id = effect.id;
                     time = effect.time;
                     this.itemEffectModel.setRemaining(id,time);
                  }
               }
               else if(data.args[0] == "set_reamining_time")
               {
                  this.itemEffectModel.setRemaining(data.args[1],data.args[2]);
               }
               else if(data.args[0] == "show_news")
               {
                  parser = JSON.parse(data.args[1]);
                  newsModel = Main.osgi.getService(INewsModel) as NewsModel;
                  news = new Vector.<NewsItemServer>();
                  for each(news_item in parser)
                  {
                     news.push(new NewsItemServer(news_item.date,news_item.text,news_item.icon_id));
                  }
                  newsModel.showNews(news);
               }
               else if(data.args[0] == "show_achievements")
               {
                  achievementModel = Main.osgi.getService(IAchievementModel) as AchievementModel;
                  parser = JSON.parse(data.args[1]);
                  achievements = new Vector.<Achievement>();
                  for each(achievementId in parser.ids)
                  {
                     achievements.push(Achievement.getById(achievementId as int));
                  }
                  achievementModel.objectLoaded(achievements);
               }
               else if(data.args[0] == "complete_achievement")
               {
                  achievementModel = Main.osgi.getService(IAchievementModel) as AchievementModel;
                  achievement = Achievement.getById(parseInt(data.args[1]));
                  achievementModel.completeAchievement(achievement);
               }
               else if(data.args[0] == "update_rating_data")
               {
                  PanelModel(Main.osgi.getService(IPanel)).updateRating(null,parseInt(data.args[1]));
                  PanelModel(Main.osgi.getService(IPanel)).updatePlace(null,parseInt(data.args[2]));
               }
               else if(data.args[0] == "show_gifts_window")
               {
                  parser = JSON.parse(data.args[1]);
                  giftsModel = Main.osgi.getService(IGiftServerModel) as GiftServerModel;
                  items = new Array();
                  for each(_item in parser)
                  {
                     items.push(new GiftServerItem(_item.item_id,_item.rarity,_item.count));
                  }
                  giftsModel.openGiftWindow(items,parseInt(data.args[2]));
               }
               else if(data.args[0] == "item_rolled")
               {
                  giftsModel = Main.osgi.getService(IGiftServerModel) as GiftServerModel;
                  giftsModel.doRoll(data.args[1],JSON.parse(data.args[2]) as Array,data.args[3],data.args[4],parseInt(data.args[5]));
               }
               else if(data.args[0] == "items_rolled")
               {
                  giftsModel = Main.osgi.getService(IGiftServerModel) as GiftServerModel;
                  j = JSON.parse(data.args[1]) as Array;
                  giftsModel.doRolls(j);
               }
               break;
            case Type.GARAGE:
               if(data.args[0] == "init_garage_items")
               {
                  this.parseGarageItems(data.args[1],data.src);
               }
               else if(data.args[0] == "init_market")
               {
                  this.parseMarket(data.args[1]);
               }
               else if(data.args[0] == "mount_item")
               {
                  oldItem = GarageModel.getItemParams(data.args[1]);
                  if(oldItem.itemType == ItemTypeEnum.ARMOR)
                  {
                     idOldItem = this.garage.garageModel.mountedArmorId;
                  }
                  else if(oldItem.itemType == ItemTypeEnum.WEAPON)
                  {
                     idOldItem = this.garage.garageModel.mountedWeaponId;
                  }
                  else if(oldItem.itemType == ItemTypeEnum.COLOR)
                  {
                     idOldItem = this.garage.garageModel.mountedEngineId;
                  }
                  if(ResourceUtil.getResource(ResourceType.IMAGE,"garage_box_img") == null)
                  {
                     ResourceUtil.addEventListener(function():void
                     {
                        garage.garageModel.mountItem(null,idOldItem,data.args[1]);
                     });
                  }
                  else
                  {
                     this.garage.garageModel.mountItem(null,idOldItem,data.args[1]);
                  }
               }
               else if(data.args[0] == "update_item")
               {
                  GarageModel.replaceItemInfo(data.args[1],this.getNextId(data.args[1]));
                  GarageModel.replaceItemParams(data.args[1],this.getNextId(data.args[1]));
                  this.garage.garageModel.upgradeItem(null,data.args[2] == "" ? this.garage.garageModel.currentItemForUpdate : data.args[2],GarageModel.getItemInfo(this.getNextId(data.args[1])));
               }
               else if(data.args[0] == "init_mounted_item")
               {
                  item = GarageModel.getItemParams(data.args[1]);
                  this.garage.garageModel.mountItem(null,null,data.args[1]);
               }
               else if(data.args[0] == "buy_item")
               {
                  item_info = new ItemInfo();
                  parser1 = JSON.parse(data.args[2]);
                  item_info.count = parser1.count;
                  item_info.itemId = data.args[1];
                  item_info.addable = parser1.addable;
                  item_info.multicounted = parser1.multicounted;
                  this.garage.garageModel.buyItem(null,item_info);
               }
               else if(data.args[0] == "remove_item_from_market")
               {
                  this.garage.garageModel.removeItemFromStore(data.args[1]);
               }
         }
      }
      
      private function parseChatMessages(json:String) : void
      {
         var obj:Object = null;
         var user:UserChat = null;
         var msg:ChatMessage = null;
         var parser:Object = JSON.parse(json);
         var msgs:Array = new Array();
         var userTo:UserChat = null;
         for each(obj in parser.messages)
         {
            user = new UserChat();
            user.rankIndex = obj.rang;
            user.chatPermissions = obj.chatPermissions;
            user.uid = obj.name;
            if(obj.addressed)
            {
               userTo = new UserChat();
               userTo.uid = obj.nameTo;
               userTo.chatPermissions = obj.chatPermissionsTo;
               userTo.rankIndex = obj.rangTo;
            }
            msg = new ChatMessage();
            msg.sourceUser = user;
            msg.system = obj.system;
            msg.targetUser = userTo;
            msg.text = obj.message;
            msg.sysCollor = !!Boolean(obj.yellow) ? uint(uint(this.yellowColor)) : uint(uint(this.greenColor));
            msgs.push(msg);
            userTo = null;
         }
         this.chat.chatModel.showMessages(null,msgs);
      }
      
      private function parseBattleInfo(json:String) : void
      {
         var user_obj:Object = null;
         var usr:UserInfoClient = null;
         var obj:Object = JSON.parse(json);
         if(obj.null_battle)
         {
            return;
         }
         var users:Array = new Array();
         for each(user_obj in obj.users_in_battle)
         {
            usr = new UserInfoClient();
            usr.id = String(user_obj.nickname);
            usr.kills = int(user_obj.kills);
            usr.name = String(user_obj.nickname);
            usr.rank = int(user_obj.rank);
            usr.type = BattleTeamType.getType(user_obj.team_type);
            usr.isBot = user_obj.isBot;
            users.push(usr);
         }
         this.battleSelect.battleSelectModel.showBattleInfo(null,obj.name,obj.maxPeople,BattleType.getType(obj.type),obj.battleId,obj.previewId,obj.minRank,obj.maxRank,obj.timeLimit,obj.timeCurrent,obj.killsLimit,obj.scoreRed,obj.scoreBlue,obj.autobalance,obj.frielndyFie,users,obj.paidBattle,obj.withoutBonuses,obj.userAlreadyPaid,obj.fullCash,obj.clanName != null ? obj.clanName : "",obj.spectator);
         this.battleSelect.battleSelectModel.selectedBattleId = obj.battleId;
      }
      
      private function parseBattle(json:String) : void
      {
         var parser:Object = JSON.parse(json);
         var battle:BattleClient = new BattleClient();
         battle.battleId = parser.battleId;
         battle.mapId = parser.mapId;
         battle.name = parser.name;
         battle.team = parser.team;
         battle.countRedPeople = parser.redPeople;
         battle.countBluePeople = parser.bluePeople;
         battle.countPeople = parser.countPeople;
         battle.maxPeople = parser.maxPeople;
         battle.minRank = parser.minRank;
         battle.maxRank = parser.maxRank;
         battle.paid = parser.isPaid;
         this.battleSelect.battleSelectModel.addBattle(null,battle);
      }
      
      private function initMarket(json:String) : void
      {
         var obj:Object = null;
         var modifications:Array = null;
         var obj2:Object = null;
         var id:int = 0;
         var item:ItemParams = null;
         var infoItem:ItemInfo = null;
         var props:Array = null;
         var prop:Object = null;
         var info:ModificationInfo = null;
         var pid:String = null;
         var p:ItemPropertyValue = null;
         var parser:Object = JSON.parse(json);
         var items:Array = new Array();
         for each(obj in parser.items)
         {
            modifications = new Array();
            for each(obj2 in obj.modification)
            {
               props = new Array();
               for each(prop in obj2.properts)
               {
                  p = new ItemPropertyValue();
                  p.property = this.getItemProperty(prop.property);
                  p.value = prop.value;
                  props.push(p);
               }
               info = new ModificationInfo();
               info.crystalPrice = obj2.price;
               info.rankId = obj2.rank;
               info.previewId = obj2.previewId;
               pid = obj2.previewId;
               info.itemProperties = props;
               modifications.push(info);
            }
            if(obj.json_kit_info != null)
            {
               this.parseKitInfo(obj.id + "_m" + obj.modificationID,JSON.parse(obj.json_kit_info),obj.discount);
            }
            id = obj.modificationID;
            item = new ItemParams(obj.id + "_m" + id,obj.description,obj.isInventory,obj.index,props,this.getTypeItem(obj.type),obj.modificationID,obj.name,obj.next_price,null,obj.next_rank,modifications[id].previewId,obj.price,obj.rank,modifications);
            infoItem = new ItemInfo();
            infoItem.count = item.price;
            infoItem.itemId = item.baseItemId;
            infoItem.discount = obj.discount;
            infoItem.multicounted = obj.multicounted;
            this.garage.garageModel.initItem(item.baseItemId,item);
            this.garage.garageModel.initMarket(null,[infoItem]);
         }
         this.garage.garageModel.objectLoaded(Game.getInstance.classObject);
      }
      
      private function parseKitInfo(key:String, kitInfos:Object, discount:int) : void
      {
         var infoObj:Object = null;
         var lang:String = (Main.osgi.getService(ILocaleService) as ILocaleService).language;
         if(lang == null)
         {
            lang = "EN";
         }
         else
         {
            lang = lang.toUpperCase();
         }
         var kitPackage:Vector.<KitPackageItemInfo> = new Vector.<KitPackageItemInfo>();
         for each(infoObj in kitInfos)
         {
            kitPackage.push(new KitPackageItemInfo(1,infoObj.price,lang == "RU" ? infoObj.name_ru : infoObj.name_en));
         }
         KitsInfoData.setData(key,kitPackage,discount);
      }
      
      private function parseMarket(json:String) : void
      {
         if(!ResourceUtil.resourceLoaded || ResourceUtil.getResource(ResourceType.IMAGE,"garage_box_img") == null || ResourceUtil.getResource(ResourceType.IMAGE,"zeus_m0_preview") == null)
         {
            ResourceUtil.addEventListener(function():void
            {
               parseMarket(json);
            });
         }
         else
         {
            this.initMarket(json);
         }
      }
      
      private function getNextId(oldId:String) : String
      {
         var temp:String = oldId.substring(0,oldId.length - 1);
         var mod:int = int(oldId.substring(oldId.length - 1,oldId.length));
         return temp + (mod + 1);
      }
      
      public function parseGarageItems(json:String, src:String = null) : void
      {
         if(!ResourceUtil.resourceLoaded || ResourceUtil.getResource(ResourceType.IMAGE,"garage_box_img") == null || ResourceUtil.getResource(ResourceType.IMAGE,"zeus_m0_preview") == null)
         {
            ResourceUtil.addEventListener(function():void
            {
               parseGarageItems(json,src);
            });
         }
         else
         {
            this.initGarageItems(json,src);
         }
      }
      
      private function initGarageItems(json:String, src:String = null) : void
      {
         var parser:Object = null;
         var items:Array = null;
         var obj:Object = null;
         var modifications:Array = null;
         var obj2:Object = null;
         var id:int = 0;
         var item:ItemParams = null;
         var infoItem:ItemInfo = null;
         var props:Array = null;
         var prop:Object = null;
         var info:ModificationInfo = null;
         var pid:String = null;
         var p:ItemPropertyValue = null;
         this.garage.garageModel.initObject(Game.getInstance.classObject,"russia",1000000,new Long(100,100),this.networker);
         try
         {
            parser = JSON.parse(json);
            items = new Array();
            for each(obj in parser.items)
            {
               modifications = new Array();
               for each(obj2 in obj.modification)
               {
                  props = new Array();
                  for each(prop in obj2.properts)
                  {
                     p = new ItemPropertyValue();
                     p.property = this.getItemProperty(prop.property);
                     p.value = prop.value;
                     props.push(p);
                  }
                  info = new ModificationInfo();
                  info.crystalPrice = obj2.price;
                  info.rankId = obj2.rank;
                  info.previewId = obj2.previewId;
                  pid = obj2.previewId;
                  info.itemProperties = props;
                  modifications.push(info);
               }
               id = obj.modificationID;
               item = new ItemParams(obj.id + "_m" + id,obj.description,obj.isInventory,obj.index,props,this.getTypeItem(obj.type),obj.modificationID,obj.name,obj.next_price,null,obj.next_rank,modifications[id].previewId,obj.price,obj.rank,modifications);
               if(item.baseItemId == "smoky_xt_m0")
               {
                  trace(item.baseItemId);
               }
               infoItem = new ItemInfo();
               if(this.getTypeItem(obj.type) != ItemTypeEnum.ARMOR)
               {
                  if(this.getTypeItem(obj.type) != ItemTypeEnum.WEAPON)
                  {
                     if(this.getTypeItem(obj.type) == ItemTypeEnum.COLOR)
                     {
                     }
                  }
               }
               infoItem.count = obj.count;
               infoItem.itemId = item.baseItemId;
               infoItem.discount = obj.discount;
               infoItem.multicounted = obj.multicounted;
               this.garage.garageModel.initItem(item.baseItemId,item);
               this.garage.garageModel.initDepot(null,[infoItem]);
            }
            Network(Main.osgi.getService(INetworker)).send("garage;get_garage_data");
            PanelModel(Main.osgi.getService(IPanel)).addListener(this.garage.garageModel);
            Main.osgi.registerService(IGarage,this.garage.garageModel);
            PanelModel(Main.osgi.getService(IPanel)).isGarageSelect = true;
         }
         catch(e:Error)
         {
            throw new Error("РћС€РёР±РєР° " + e.getStackTrace());
         }
      }
      
      public function parseAndInitBattlesList(json:String) : void
      {
         var obj1:Object = null;
         var btl:Object = null;
         var map:MapClient = null;
         var battle:BattleClient = null;
         Main.osgi.registerService(IBattleSelectModelBase,this.battleSelect.battleSelectModel);
         var maps:Array = new Array();
         var battles:Array = new Array();
         var js:Object = JSON.parse(json);
         for each(obj1 in js.items)
         {
            map = new MapClient();
            map.ctf = obj1.ctf;
            map.gameName = obj1.gameName;
            map.id = obj1.id;
            map.maxPeople = obj1.maxPeople;
            map.maxRank = obj1.maxRank;
            map.minRank = obj1.minRank;
            map.name = obj1.name;
            map.previewId = obj1.id + "_preview";
            map.tdm = obj1.tdm;
            map.dom = obj1.dom;
            map.hr = obj1.hr;
            map.themeName = obj1.themeName;
            maps.push(map);
         }
         for each(btl in js.battles)
         {
            battle = new BattleClient();
            battle.battleId = btl.battleId;
            battle.mapId = btl.mapId;
            battle.name = btl.name;
            battle.type = btl.type;
            battle.team = btl.team;
            battle.countRedPeople = btl.redPeople;
            battle.countBluePeople = btl.bluePeople;
            battle.countPeople = btl.countPeople;
            battle.maxPeople = btl.maxPeople;
            battle.minRank = btl.minRank;
            battle.maxRank = btl.maxRank;
            battle.paid = btl.isPaid;
            battles.push(battle);
         }
         this.battleSelect.battleSelectModel.initObject(null,10,js.haveSubscribe,maps);
         this.battleSelect.battleSelectModel.initBattleList(null,battles,js.recommendedBattle,false);
         if(!this.listInited)
         {
            this.listInited = true;
         }
      }
      
      public function parseAndAddMessageToChat(json:String) : void
      {
         var parser:Object = JSON.parse(json);
         this.chat.chatModel.chatPanel.addMessage(parser.name,parser.rang,parser.chatPermissions,parser.message,parser.rangTo,parser.chatPermissionsTo,parser.nameTo == "NULL" ? "" : parser.nameTo,parser.system);
      }
      
      public function parseAndInitPanelInfo(json:String) : void
      {
         var obj:Object = JSON.parse(json);
         this.initPanel(obj.crystall,obj.email,obj.tester,obj.name,obj.next_score,obj.place,obj.rang,obj.rating,obj.score,obj.have_double_crystalls);
      }
      
      public function initPanel(crystall:int, email:String, tester:Boolean, name:String, nextScore:int, place:int, rang:int, rating:int, score:int, haveDoubleCrystalls:Boolean) : void
      {
         var modelPanel:PanelModel = PanelModel(Main.osgi.getService(IPanel));
         modelPanel.initObject(Game.getInstance.classObject,crystall,email,tester,name,nextScore,place,rang,rating,score,haveDoubleCrystalls);
         modelPanel.lock();
         var user1:UserData = new UserData(name,name,rang);
         Main.osgi.registerService(IUserData,user1);
         this.init();
      }
      
      public function beforeAuth() : void
      {
         this.networker = Main.osgi.getService(INetworker) as Network;
         this.networker.addEventListener(this);
      }
      
      private function init() : void
      {
         this.chat.start(Game.getInstance.osgi);
         this.battleSelect.start(Game.getInstance.osgi);
      }
      
      public function getItemProperty(src:String) : ItemProperty
      {
         switch(src)
         {
            case "damage":
               return ItemProperty.DAMAGE;
            case "damage_per_second":
               return ItemProperty.DAMAGE_PER_SECOND;
            case "critical_chance":
               return ItemProperty.CRITICAL_CHANCE;
            case "heating_time":
               return ItemProperty.HEATING_TIME;
            case "aiming_error":
               return ItemProperty.AIMING_ERROR;
            case "cone_angle":
               return ItemProperty.CONE_ANGLE;
            case "shot_area":
               return ItemProperty.SHOT_AREA;
            case "shot_frequency":
               return ItemProperty.SHOT_FREQUENCY;
            case "shot_range":
               return ItemProperty.SHOT_RANGE;
            case "turn_speed":
               return ItemProperty.TURN_SPEED;
            case "mech_resistance":
               return ItemProperty.MECH_RESISTANCE;
            case "plasma_resistance":
               return ItemProperty.PLASMA_RESISTANCE;
            case "rail_resistance":
               return ItemProperty.RAIL_RESISTANCE;
            case "terminator_resistance":
               return ItemProperty.TERMINATOR_RESISTANCE;
            case "mine_resistance":
               return ItemProperty.MINE_RESISTANCE;
            case "vampire_resistance":
               return ItemProperty.VAMPIRE_RESISTANCE;
            case "armor":
               return ItemProperty.ARMOR;
            case "turret_turn_speed":
               return ItemProperty.TURRET_TURN_SPEED;
            case "fire_resistance":
               return ItemProperty.FIRE_RESISTANCE;
            case "thunder_resistance":
               return ItemProperty.THUNDER_RESISTANCE;
            case "freeze_resistance":
               return ItemProperty.FREEZE_RESISTANCE;
            case "ricochet_resistance":
               return ItemProperty.RICOCHET_RESISTANCE;
            case "healing_radius":
               return ItemProperty.HEALING_RADUIS;
            case "heal_rate":
               return ItemProperty.HEAL_RATE;
            case "vampire_rate":
               return ItemProperty.VAMPIRE_RATE;
            case "speed":
               return ItemProperty.SPEED;
            case "shaft_damage":
               return ItemProperty.SHAFT_DAMAGE;
            case "shaft_shot_frequency":
               return ItemProperty.SHAFT_FIRE_RATE;
            case "shaft_resistance":
               return ItemProperty.SHAFT_RESISTANCE;
            default:
               return null;
         }
      }
      
      public function getTypeItem(sct:int) : ItemTypeEnum
      {
         switch(sct)
         {
            case 2:
               return ItemTypeEnum.ARMOR;
            case 1:
               return ItemTypeEnum.WEAPON;
            case 3:
               return ItemTypeEnum.COLOR;
            case 4:
               return ItemTypeEnum.INVENTORY;
            case 5:
               return ItemTypeEnum.PLUGIN;
            case 6:
               return ItemTypeEnum.KIT;
            default:
               return null;
         }
      }
   }
}
