package alternativa.tanks.models.battlefield.gui.chat
{
   import alternativa.init.Main;
   import alternativa.model.IModel;
   import alternativa.model.IObjectLoadListener;
   import alternativa.object.ClientObject;
   import alternativa.service.IModelService;
   import alternativa.tanks.model.panel.IBattleSettings;
   import alternativa.tanks.model.panel.IPanelListener;
   import alternativa.tanks.model.user.IUserDataListener;
   import alternativa.tanks.models.battlefield.IUserStat;
   import alternativa.types.Long;
   import flash.display.DisplayObjectContainer;
   import flash.events.KeyboardEvent;
   import flash.ui.Keyboard;
   import projects.tanks.client.battlefield.gui.models.chat.ChatModelBase;
   import projects.tanks.client.battlefield.gui.models.chat.IChatModelBase;
   import projects.tanks.client.battleservice.model.team.BattleTeamType;
   import scpacker.networking.INetworker;
   import scpacker.networking.Network;
   import specter.utils.KeyboardBinder;
   
   public class ChatModel extends ChatModelBase implements IChatModelBase, IObjectLoadListener, IPanelListener, IChatBattle
   {
       
      
      private var userStat:IUserStat;
      
      private var bfClientObject:ClientObject;
      
      private var contentLayer:DisplayObjectContainer;
      
      private var teamOnly:Boolean;
      
      private var battleChat:BattleChat;
      
      private var uiLockCount:int;
      
      private var messagesBuf:Vector.<String>;
      
      private var keyBinder:KeyboardBinder;
      
      private var currentBufMsg:int = -1;
      
      public function ChatModel()
      {
         this.messagesBuf = new Vector.<String>();
         super();
         _interfaces.push(IModel,IChatModelBase,IObjectLoadListener,IUserDataListener,IPanelListener);
         this.contentLayer = Main.contentUILayer;
         this.battleChat = new BattleChat();
         Main.osgi.registerService(IChatBattle,this);
      }
      
      public function objectLoaded(object:ClientObject) : void
      {
         this.bfClientObject = object;
         this.battleChat.clear();
         this.contentLayer.addChild(this.battleChat);
         this.battleChat.addEventListener(BattleChatEvent.SEND_MESSAGE,this.onSendMessage);
         this.battleChat.addEventListener(BattleChatEvent.CHAT_EXIT,this.onChatClosed);
         Main.stage.addEventListener(KeyboardEvent.KEY_UP,this.onKeyUp);
         var modelService:IModelService = Main.osgi.getService(IModelService) as IModelService;
         this.battleChat.alwaysShow = this.getSettings().showBattleChat;
         this.keyBinder = new KeyboardBinder(this.battleChat.input);
         this.keyBinder.bind("UP",this.processBufUp);
         this.keyBinder.bind("DOWN",this.processBufDown);
         this.keyBinder.enable();
      }
      
      public function objectUnloaded(object:ClientObject) : void
      {
         this.battleChat.removeEventListener(BattleChatEvent.SEND_MESSAGE,this.onSendMessage);
         this.battleChat.removeEventListener(BattleChatEvent.CHAT_EXIT,this.onChatClosed);
         this.battleChat.clear();
         this.contentLayer.removeChild(this.battleChat);
         Main.stage.removeEventListener(KeyboardEvent.KEY_UP,this.onKeyUp);
         this.bfClientObject = null;
         this.keyBinder.unbindAll();
         this.keyBinder.disable();
      }
      
      public function bugReportOpened() : void
      {
         this.updateUILock(1);
      }
      
      public function bugReportClosed() : void
      {
         this.updateUILock(-1);
      }
      
      public function friendsOpened() : void
      {
         this.updateUILock(1);
      }
      
      public function friendsClosed() : void
      {
         this.updateUILock(-1);
      }
      
      public function exchangeOpened() : void
      {
         this.updateUILock(1);
      }
      
      public function exchangeClosed() : void
      {
         this.updateUILock(-1);
      }
      
      public function onCloseGame() : void
      {
         this.updateUILock(1);
      }
      
      public function onCloseGameExit() : void
      {
         this.updateUILock(-1);
      }
      
      public function settingsAccepted() : void
      {
         this.updateUILock(-1);
         this.battleChat.alwaysShow = this.getSettings().showBattleChat;
      }
      
      public function settingsOpened() : void
      {
         this.updateUILock(1);
      }
      
      public function settingsCanceled() : void
      {
         this.updateUILock(-1);
      }
      
      public function setMuteSound(mute:Boolean) : void
      {
      }
      
      private function onKeyUp(e:KeyboardEvent) : void
      {
         switch(e.keyCode)
         {
            case Keyboard.ENTER:
               this.teamOnly = e.ctrlKey;
               this.battleChat.openChat();
               break;
            case 84:
               if(!this.battleChat.chatOpened)
               {
                  this.teamOnly = true;
                  this.battleChat.openChat();
               }
         }
      }
      
      private function onChatClosed(e:BattleChatEvent) : void
      {
         this.currentBufMsg = -1;
      }
      
      private function onSendMessage(e:BattleChatEvent) : void
      {
         this.sendMessage(this.bfClientObject,e.message,this.teamOnly);
      }
      
      private function sendMessage(cl:ClientObject, msg:String, team:Boolean) : void
      {
         if(this.messagesBuf.length == 0 || this.messagesBuf[this.messagesBuf.length - 1] != msg)
         {
            this.messagesBuf.push(msg);
         }
         this.currentBufMsg = -1;
         var reg:RegExp = /;/g;
         var reg2:RegExp = /~/g;
         msg = msg.replace(reg," ").replace(reg2," ");
         Network(Main.osgi.getService(INetworker)).send("battle;chat;" + msg + ";" + team);
      }
      
      private function processBufUp(isKeyDown:Boolean) : void
      {
         if(!isKeyDown || this.messagesBuf.length == 0 || !this.battleChat.chatOpened)
         {
            return;
         }
         this.currentBufMsg = Math.min(this.currentBufMsg + 1,this.messagesBuf.length - 1);
         this.battleChat.input.text = this.messagesBuf[this.messagesBuf.length - 1 - this.currentBufMsg];
      }
      
      private function processBufDown(isKeyDown:Boolean) : void
      {
         if(!isKeyDown || this.messagesBuf.length == 0 || !this.battleChat.chatOpened)
         {
            return;
         }
         this.currentBufMsg = Math.max(this.currentBufMsg - 1,0);
         this.battleChat.input.text = this.messagesBuf[this.messagesBuf.length - 1 - this.currentBufMsg];
      }
      
      public function addMessage(clientObject:ClientObject, userId:Long, message:String, type:BattleTeamType, teamOnly:Boolean, nick:String = null, rank:int = 0, chat_level:int = 0) : void
      {
         var messageLabel:String = type != BattleTeamType.NONE && teamOnly ? "[TEAM]" : null;
         var userName:String = nick;
         var userRank:int = rank;
         this.battleChat.addUserMessage(messageLabel,userName,userRank,chat_level,type,message + "\n");
      }
      
      public function addSpectatorMessage(message:String) : void
      {
         this.battleChat.addSpectatorMessage(message + "\n");
      }
      
      public function addSystemMessage(clientObject:ClientObject, message:String) : void
      {
         this.battleChat.addSystemMessage(message);
      }
      
      private function updateUILock(delta:int) : void
      {
         this.uiLockCount += delta;
         if(this.bfClientObject != null)
         {
            if(this.uiLockCount > 0)
            {
               this.battleChat.closeChat();
               this.battleChat.locked = true;
            }
            else
            {
               this.battleChat.locked = false;
            }
         }
      }
      
      private function getSettings() : IBattleSettings
      {
         return IBattleSettings(Main.osgi.getService(IBattleSettings));
      }
   }
}

import alternativa.types.Long;
import projects.tanks.client.battleservice.model.team.BattleTeamType;

class ExpectingMessage
{
    
   
   public var messageLabel:String;
   
   public var userID:Long;
   
   public var message:String;
   
   public var type:BattleTeamType;
   
   function ExpectingMessage(messageLabel:String, userID:Long, type:BattleTeamType, message:String)
   {
      super();
      this.messageLabel = messageLabel;
      this.userID = userID;
      this.message = message;
      this.type = type;
   }
}
