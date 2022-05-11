package alternativa.tanks.model
{
   import alternativa.init.Main;
   import alternativa.model.IModel;
   import alternativa.model.IObjectLoadListener;
   import alternativa.object.ClientObject;
   import alternativa.osgi.service.locale.ILocaleService;
   import alternativa.osgi.service.mainContainer.IMainContainerService;
   import alternativa.service.IModelService;
   import alternativa.tanks.gui.ExternalLinkAlert;
   import alternativa.tanks.locale.constants.TextConst;
   import alternativa.tanks.model.user.IUserData;
   import alternativa.types.Long;
   import com.alternativaplatform.client.models.core.community.chat.ChatModelBase;
   import com.alternativaplatform.client.models.core.community.chat.IChatModelBase;
   import com.alternativaplatform.client.models.core.community.chat.types.ChatMessage;
   import flash.display.DisplayObjectContainer;
   import flash.events.TextEvent;
   import flash.net.URLRequest;
   import flash.net.navigateToURL;
   import forms.AlertAnswer;
   import forms.LobbyChat;
   import forms.events.AlertEvent;
   import forms.events.ChatFormEvent;
   import scpacker.networking.INetworker;
   import scpacker.networking.Network;
   import specter.utils.KeyboardBinder;
   
   public class ChatModel extends ChatModelBase implements IChatModelBase, IObjectLoadListener
   {
       
      
      private var clientObject:ClientObject;
      
      private var layer:DisplayObjectContainer;
      
      public var chatPanel:LobbyChat;
      
      private var myName:String;
      
      private var linksWhiteList:Array;
      
      private var userDataModel:IUserData;
      
      private var messageBuffer:Vector.<ChatMessage>;
      
      private var expectedData:Vector.<Long>;
      
      private var messagesBuf:Vector.<String>;
      
      private var keyBinder:KeyboardBinder;
      
      private var currentBufMsg:int = -1;
      
      private var link:String;
      
      private var alert:ExternalLinkAlert;
      
      public function ChatModel()
      {
         this.messagesBuf = new Vector.<String>();
         super();
         _interfaces.push(IModel);
         _interfaces.push(IChatModelBase);
         _interfaces.push(IObjectLoadListener);
         this.layer = Main.contentUILayer;
         var modelRegister:IModelService = Main.osgi.getService(IModelService) as IModelService;
      }
      
      public function objectLoaded(object:ClientObject) : void
      {
         this.clientObject = object;
         this.messageBuffer = new Vector.<ChatMessage>();
         this.expectedData = new Vector.<Long>();
         if(LobbyChat(Main.osgi.getService(LobbyChat)) != null)
         {
            this.cleanUsersMessages(null,"");
            this.chatPanel = LobbyChat(Main.osgi.getService(LobbyChat));
         }
         else
         {
            this.chatPanel = new LobbyChat();
            Main.osgi.registerService(LobbyChat,this.chatPanel);
         }
         this.keyBinder = new KeyboardBinder(this.chatPanel);
         this.chatPanel.selfName = this.myName;
         this.showPanel();
      }
      
      public function objectUnloaded(object:ClientObject) : void
      {
         this.chatPanel.hide();
         this.hidePanel();
         this.clientObject = null;
      }
      
      public function userDataChanged(userId:Long) : void
      {
         var index:int = this.expectedData.indexOf(userId);
         if(index != -1)
         {
            this.expectedData.splice(index,1);
            this.checkBuffer();
         }
      }
      
      public function initObject(clientObject:ClientObject, linksWhiteList:Array, selfName:String) : void
      {
         this.myName = selfName;
         this.linksWhiteList = linksWhiteList;
      }
      
      public function showMessages(clientObject:ClientObject, messages:Array) : void
      {
         var message:ChatMessage = null;
         Main.writeVarsToConsoleChannel("CHAT","showMessages");
         for(var i:int = 0; i < messages.length; i++)
         {
            message = messages[i];
            this.chatPanel.addMessage(message.sourceUser.uid,message.sourceUser.rankIndex,message.sourceUser.chatPermissions,this.replaceBattleLink(message.text),message.targetUser != null ? int(message.targetUser.rankIndex) : int(0),message.targetUser != null ? int(message.targetUser.chatPermissions) : int(0),message.targetUser != null ? message.targetUser.uid : "",message.system,message.sysCollor);
         }
         if(i > 25)
         {
            this.chatPanel.output.scrollDown();
         }
      }
      
      private function replaceBattleLink(text:String) : String
      {
         return text;
      }
      
      private function checkBuffer() : void
      {
         var message:ChatMessage = null;
         Main.writeVarsToConsoleChannel("CHAT","checkBuffer");
         while(this.messageBuffer.length > 0)
         {
            message = this.messageBuffer[0];
            Main.writeVarsToConsoleChannel("CHAT","addMessage targetUserName: %1",message.targetUser != null ? message.targetUser.uid : "");
            this.chatPanel.addMessage(message.sourceUser.uid,message.sourceUser.rankIndex,message.sourceUser.chatPermissions,message.text,message.targetUser != null ? int(message.targetUser.rankIndex) : int(0),message.targetUser != null ? int(message.targetUser.chatPermissions) : int(0),message.targetUser != null ? message.targetUser.uid : "");
            this.messageBuffer.splice(0,1);
         }
      }
      
      private function onSendChatMessage(e:ChatFormEvent) : void
      {
         var message:String = this.chatPanel.inputText;
         if(this.messagesBuf.length == 0 || this.messagesBuf[this.messagesBuf.length - 1] != message)
         {
            this.messagesBuf.push(message);
         }
         this.currentBufMsg = -1;
         var reg:RegExp = /;/g;
         var reg2:RegExp = /~/g;
         if(message.search(reg) != -1)
         {
            message = message.replace(reg," ");
         }
         if(message.search(reg2) != -1)
         {
            message = message.replace(reg2," ");
         }
         this.sendMessage(this.clientObject,e.nameTo,message);
      }
      
      public function sendMessage(client:ClientObject, nameTo:String, message:String) : void
      {
         Network(Main.osgi.getService(INetworker)).send("lobby_chat;" + message + ";" + (nameTo != null ? "true" : "false") + ";" + (nameTo != "" ? nameTo : "NULL") + "");
      }
      
      private function processBufUp(isKeyDown:Boolean) : void
      {
         if(!isKeyDown || this.messagesBuf.length == 0)
         {
            return;
         }
         this.currentBufMsg = Math.min(this.currentBufMsg + 1,this.messagesBuf.length - 1);
         this.chatPanel.inputText = this.messagesBuf[this.messagesBuf.length - 1 - this.currentBufMsg];
      }
      
      private function processBufDown(isKeyDown:Boolean) : void
      {
         if(!isKeyDown || this.messagesBuf.length == 0)
         {
            return;
         }
         this.currentBufMsg = Math.max(this.currentBufMsg - 1,0);
         this.chatPanel.inputText = this.messagesBuf[this.messagesBuf.length - 1 - this.currentBufMsg];
      }
      
      private function showPanel() : void
      {
         if(!this.layer.contains(this.chatPanel))
         {
            this.layer.addChild(this.chatPanel);
            this.chatPanel.addEventListener(ChatFormEvent.SEND_MESSAGE,this.onSendChatMessage);
            this.chatPanel.addEventListener(TextEvent.LINK,this.onTextLink);
            this.keyBinder.bind("UP",this.processBufUp);
            this.keyBinder.bind("DOWN",this.processBufDown);
            this.keyBinder.enable();
         }
      }
      
      private function hidePanel() : void
      {
         if(this.layer.contains(this.chatPanel))
         {
            this.layer.removeChild(this.chatPanel);
            this.chatPanel.removeEventListener(ChatFormEvent.SEND_MESSAGE,this.onSendChatMessage);
            this.keyBinder.unbindAll();
            this.keyBinder.disable();
         }
      }
      
      public function showBattle(obj:ClientObject, id:String) : void
      {
         Network(Main.osgi.getService(INetworker)).send("lobby;get_show_battle_info;" + id);
      }
      
      private function onTextLink(e:TextEvent) : void
      {
         var id:String = null;
         var dialogsLayer:DisplayObjectContainer = (Main.osgi.getService(IMainContainerService) as IMainContainerService).dialogsLayer as DisplayObjectContainer;
         var localeService:ILocaleService = Main.osgi.getService(ILocaleService) as ILocaleService;
         var battleIdRegExp:RegExp = /#battle\d+@[\w\W]+@#\d+/gi;
         this.link = e.text;
         Main.writeVarsToConsoleChannel("CHAT","Click link: %1",this.link);
         if(this.link.search(battleIdRegExp) > -1)
         {
            id = this.link.split("battle")[1];
            this.showBattle(this.clientObject,id);
         }
         else if(this.linksWhiteList.indexOf(this.link) == -1)
         {
            this.alert = new ExternalLinkAlert();
            this.alert.showAlert(localeService.getText(TextConst.ALERT_CHAT_PROCEED_EXTERNAL_LINK) + "\n\n<font color =\'#f0f0ff\'><u><a href=\'" + this.link + "\' target=\'_blank\'>" + this.link + "</a></u></font>",[AlertAnswer.PROCEED,AlertAnswer.CANCEL]);
            dialogsLayer.addChild(this.alert);
            this.alert.addEventListener(AlertEvent.ALERT_BUTTON_PRESSED,this.onAlertButtonPressed);
         }
      }
      
      private function onAlertButtonPressed(e:AlertEvent) : void
      {
         if(e.typeButton == AlertAnswer.PROCEED)
         {
            this.alert.removeEventListener(AlertEvent.ALERT_BUTTON_PRESSED,this.onAlertButtonPressed);
            navigateToURL(new URLRequest(this.link),"_blank");
         }
      }
      
      public function cleanUsersMessages(clientObject:ClientObject, uid:String) : void
      {
         if(this.chatPanel == null)
         {
            return;
         }
         this.chatPanel.cleanOutUsersMessages(uid);
      }
      
      public function cleanMessages(msg:String) : void
      {
         if(this.chatPanel == null)
         {
            return;
         }
         this.chatPanel.cleanOutMessages(msg);
      }
   }
}
