package forms
{
   import alternativa.init.Main;
   import alternativa.osgi.service.locale.ILocaleService;
   import alternativa.osgi.service.storage.IStorageService;
   import alternativa.tanks.locale.constants.TextConst;
   import alternativa.tanks.model.news.NewsItem;
   import alternativa.tanks.model.news.NewsOutput;
   import assets.scroller.color.ScrollThumbSkinGreen;
   import assets.scroller.color.ScrollTrackGreen;
   import controls.DefaultButton;
   import controls.Label;
   import controls.TankInput;
   import controls.TankWindow;
   import controls.TankWindowHeader;
   import controls.TankWindowInner;
   import controls.chat.ChatOutput;
   import controls.chat.ChatOutputLine;
   import fl.events.ScrollEvent;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.KeyboardEvent;
   import flash.events.MouseEvent;
   import flash.events.TimerEvent;
   import flash.net.SharedObject;
   import flash.text.TextField;
   import flash.text.TextFormat;
   import flash.ui.Keyboard;
   import flash.utils.Timer;
   import forms.buttons.NewsButton;
   import forms.events.ChatFormEvent;
   import forms.events.LoginFormEvent;
   
   public class LobbyChat extends Sprite
   {
      
      public static var so:SharedObject;
       
      
      private var bg:Sprite;
      
      private var mainBackground:TankWindow;
      
      private var inner:TankWindowInner;
      
      private var inputControl:TankInput;
      
      private var input:TextField;
      
      private var format:TextFormat;
      
      private var chatSource:Sprite;
      
      private var addressed:Boolean;
      
      private var oldTarget:ChatOutputLine;
      
      private var _rangTo:int;
      
      private var _nameTo:String;
      
      private var _oldNameTo:String;
      
      private var oldSelect:Boolean = true;
      
      private var delayTimer:Timer;
      
      private var lang:String;
      
      private var localeService:ILocaleService;
      
      private var CtrlPressed:Boolean = false;
      
      private var htmlFlag:Boolean = false;
      
      public var output:ChatOutput;
      
      public var sendButton:DefaultButton;
      
      private var newsButton:NewsButton;
      
      private var chatButton:DefaultButton;
      
      private var newsOutput:NewsOutput;
      
      private var _selfName:String;
      
      private var sharpLinks:Array;
      
      public function LobbyChat()
      {
         this.bg = new Sprite();
         this.mainBackground = new TankWindow();
         this.inner = new TankWindowInner(100,100,TankWindowInner.GREEN);
         this.inputControl = new TankInput();
         this.chatSource = new Sprite();
         this.output = new ChatOutput();
         this.sendButton = new DefaultButton();
         super();
         addEventListener(Event.ADDED_TO_STAGE,this.ConfigUI);
         addEventListener(Event.ADDED_TO_STAGE,this.addResizeListener);
         addEventListener(Event.REMOVED_FROM_STAGE,this.removeResizeListener);
      }
      
      public static function get blockList() : Array
      {
         var list:Array = null;
         if(so == null)
         {
            so = IStorageService(Main.osgi.getService(IStorageService)).getStorage();
         }
         list = so.data.blocklist;
         if(list == null)
         {
            list = new Array();
         }
         return list;
      }
      
      public static function blockUser(name:String) : Boolean
      {
         var list:Array = null;
         var index:int = -1;
         so = IStorageService(Main.osgi.getService(IStorageService)).getStorage();
         list = so.data.blocklist;
         if(list == null)
         {
            list = new Array();
         }
         index = list.indexOf(name);
         if(index > -1)
         {
            list.splice(index,1);
         }
         list.push(name);
         so.data.blocklist = list;
         so.flush();
         return true;
      }
      
      public static function unblockUser(name:String) : Boolean
      {
         var list:Array = null;
         var index:int = -1;
         so = IStorageService(Main.osgi.getService(IStorageService)).getStorage();
         list = so.data.blocklist;
         if(list == null)
         {
            list = new Array();
         }
         index = list.indexOf(name);
         if(index > -1)
         {
            list.splice(index,1);
         }
         so.data.blocklist = list;
         so.flush();
         return true;
      }
      
      public static function unblockall() : Boolean
      {
         so = IStorageService(Main.osgi.getService(IStorageService)).getStorage();
         so.data.blocklist = new Array();
         so.flush();
         return true;
      }
      
      public static function blocked(name:String) : Boolean
      {
         var list:Array = null;
         var index:int = 0;
         so = IStorageService(Main.osgi.getService(IStorageService)).getStorage();
         list = so.data.blocklist;
         if(list == null)
         {
            list = new Array();
            so.data.blocklist = list;
            so.flush();
         }
         index = list.indexOf(name);
         return index > -1;
      }
      
      public function set selfName(name:String) : void
      {
         this._selfName = name;
         this.output.selfName = this._selfName;
      }
      
      public function get inputText() : String
      {
         return this.input.text;
      }
      
      public function set inputText(text:String) : void
      {
         this.input.text = text;
      }
      
      private function addResizeListener(e:Event) : void
      {
         stage.addEventListener(Event.RESIZE,this.onResize);
         this.onResize(null);
      }
      
      private function removeResizeListener(e:Event) : void
      {
         stage.removeEventListener(Event.RESIZE,this.onResize);
      }
      
      public function ConfigUI(e:Event) : void
      {
         this.localeService = Main.osgi.getService(ILocaleService) as ILocaleService;
         this.input = this.inputControl.textField;
         this.input.maxChars = 299;
         removeEventListener(Event.ADDED_TO_STAGE,this.ConfigUI);
         addChild(this.mainBackground);
         addChild(this.inner);
         this.inner.x = 11;
         this.inner.y = 45;
         this.inner.showBlink = true;
         this.lang = this.localeService.getText(TextConst.GUI_LANG);
         this.mainBackground.headerLang = this.lang;
         this.mainBackground.header = TankWindowHeader.CHAT;
         this.input.addEventListener(KeyboardEvent.KEY_DOWN,this.sendMessageKey);
         this.input.addEventListener(KeyboardEvent.KEY_UP,this.clearCtrlPressed);
         this.sendButton.addEventListener(MouseEvent.CLICK,this.sendMessage);
         addChild(this.inputControl);
         addChild(this.output);
         this.output.move(15,this.inner.y + 4);
         this.confScroll();
         this.output.addEventListener(MouseEvent.CLICK,this.addUserName);
         this.output.addEventListener(ScrollEvent.SCROLL,this.onScroll);
         this.inputControl.addEventListener(LoginFormEvent.TEXT_CHANGED,this.checkName);
         this.sendButton.x = 272;
         this.sendButton.width = 80;
         this.sendButton.label = this.localeService.getText(TextConst.CHAT_PANEL_BUTTON_SEND);
         addChild(this.sendButton);
         this.prepareSharpLink();
         this.newsButton = new NewsButton(this.localeService.getText(TextConst.LOBBY_NEWS_BUTTON));
         addChild(this.newsButton);
         this.newsButton.y = 11;
         this.newsButton.x = 11;
         this.chatButton = new DefaultButton();
         this.chatButton.label = this.localeService.getText(TextConst.LOBBY_CHAT_BUTTON);
         addChild(this.chatButton);
         this.chatButton.x = this.newsButton.width + this.newsButton.x + 5;
         this.chatButton.y = 11;
         this.newsButton.addEventListener(MouseEvent.CLICK,this.onNewsButtonClick);
         this.chatButton.addEventListener(MouseEvent.CLICK,this.onChatButtonClick);
         this.newsOutput = new NewsOutput();
         this.newsOutput.x = 15;
         this.newsOutput.y = this.inner.y + 4;
         this.newsOutput.visible = false;
         addChild(this.newsOutput);
         this.onChatButtonClick(null);
      }
      
      public function initNews(news:Array) : void
      {
         var prevItem:NewsItem = null;
         var item:NewsItem = null;
         for each(item in news)
         {
            if(prevItem == null)
            {
               this.newsOutput.addItem(item);
               prevItem = item;
            }
            else
            {
               item.y = prevItem.y + prevItem.height + 10;
               this.newsOutput.addItem(item);
               prevItem = item;
            }
         }
      }
      
      private function onNewsButtonClick(e:MouseEvent) : void
      {
         this.newsButton.enable = false;
         this.chatButton.enable = true;
         this.output.visible = false;
         this.sendButton.visible = false;
         this.inputControl.visible = false;
         this.newsOutput.visible = true;
         this.onResize(null);
      }
      
      private function onChatButtonClick(e:MouseEvent) : void
      {
         this.sendButton.visible = true;
         this.onResize(null);
         this.newsButton.enable = true;
         this.chatButton.enable = false;
         this.output.visible = true;
         this.newsOutput.visible = false;
         this.inputControl.visible = true;
      }
      
      private function clearCtrlPressed(event:KeyboardEvent) : void
      {
         this.CtrlPressed = false;
      }
      
      private function onScroll(e:ScrollEvent) : void
      {
         this.output.deltaWidth = 18;
         this.output.setSize(this.inner.width + 1,this.inner.height - 8);
         this.output.removeEventListener(ScrollEvent.SCROLL,this.onScroll);
         this.output.firstFill = false;
      }
      
      private function checkName(e:Event) : void
      {
         var pattern:RegExp = /^[a-z0-9](([\.\-\w](?!(-|_|\.){2,}))*[a-z0-9])\: /i;
         var result:int = this.input.text.search(pattern);
         var str:String = this.input.text.slice(0,this.input.text.indexOf(": "));
         if(result == 0)
         {
            if(!this.addressed || str != this._oldNameTo)
            {
               this._oldNameTo = this._nameTo = str;
               this.addressed = true;
               this.output.selectUser(this._nameTo);
            }
         }
         else if(this.addressed)
         {
            this.addressed = false;
            this.output.selectUser("");
         }
      }
      
      private function confScroll() : void
      {
         this.output.setStyle("downArrowUpSkin",ScrollArrowDownGreen);
         this.output.setStyle("downArrowDownSkin",ScrollArrowDownGreen);
         this.output.setStyle("downArrowOverSkin",ScrollArrowDownGreen);
         this.output.setStyle("downArrowDisabledSkin",ScrollArrowDownGreen);
         this.output.setStyle("upArrowUpSkin",ScrollArrowUpGreen);
         this.output.setStyle("upArrowDownSkin",ScrollArrowUpGreen);
         this.output.setStyle("upArrowOverSkin",ScrollArrowUpGreen);
         this.output.setStyle("upArrowDisabledSkin",ScrollArrowUpGreen);
         this.output.setStyle("trackUpSkin",ScrollTrackGreen);
         this.output.setStyle("trackDownSkin",ScrollTrackGreen);
         this.output.setStyle("trackOverSkin",ScrollTrackGreen);
         this.output.setStyle("trackDisabledSkin",ScrollTrackGreen);
         this.output.setStyle("thumbUpSkin",ScrollThumbSkinGreen);
         this.output.setStyle("thumbDownSkin",ScrollThumbSkinGreen);
         this.output.setStyle("thumbOverSkin",ScrollThumbSkinGreen);
         this.output.setStyle("thumbDisabledSkin",ScrollThumbSkinGreen);
      }
      
      private function addUserName(e:MouseEvent) : void
      {
         var str:String = null;
         var strName:String = null;
         var target:Label = null;
         var Line:ChatOutputLine = null;
         if(e.target is Label)
         {
            target = e.target as Label;
            Line = target.parent as ChatOutputLine;
            if(target == Line._nameFrom || target == Line._nameTo)
            {
               strName = target == Line._nameFrom ? Line._userName : Line._userNameTo;
               this.output.selectUser(strName);
               str = this.input.text;
               if(str.indexOf(": ") > 0)
               {
                  str = strName + ": " + str.slice(str.indexOf(": ") + 2,str.length);
               }
               else
               {
                  str = strName + ": " + str.slice(str.indexOf(": ") + 1,str.length);
               }
               this.input.text = str;
               this.input.setSelection(this.input.length,this.input.length);
               this.addressed = true;
               this._nameTo = strName;
            }
            if(this.CtrlPressed)
            {
               str = "/ban " + strName + " ";
               this.input.text = str;
               this.input.setSelection(this.input.length,this.input.length);
               this.addressed = true;
               this._nameTo = strName;
            }
         }
      }
      
      private function sendMessageKey(e:KeyboardEvent) : void
      {
         if(e.keyCode == Keyboard.ENTER)
         {
            this.send();
         }
         this.CtrlPressed = e.ctrlKey && e.shiftKey;
      }
      
      private function sendMessage(e:MouseEvent) : void
      {
         this.send();
      }
      
      private function systemMessage(str:String) : Boolean
      {
         var pattern:RegExp = /(can write to chat again|was banned for a)/;
         return str.search(pattern) > -1;
      }
      
      private function send() : void
      {
         var command:String = null;
         var commandName:String = null;
         var msg:String = null;
         var htmlFlag:Boolean = false;
         var list:Array = null;
         var i:int = 0;
         var str:String = this.input.text;
         var str1:String = str;
         var pattern1:RegExp = /(^(\/block|\/unblock) ([a-z0-9](([\.\-\w](?!(-|_|\.){2,}))*[a-z0-9])))$/i;
         var pattern2:RegExp = /^(\/unblockall|\/blocklist)$/;
         var result1:int = str1.search(pattern1);
         var result2:int = str1.search(pattern2);
         if(result1 > -1)
         {
            command = str1.replace(pattern1,"$2");
            commandName = str1.replace(pattern1,"$3");
            if(command == "/block")
            {
               LobbyChat.blockUser(commandName);
               msg = TextConst.setVarsInString(this.localeService.getText(TextConst.CHAT_PANEL_COMMAND_BLOCK,commandName));
               this.addMessage("System",0,0,msg,0,0,"",true);
            }
            else
            {
               LobbyChat.unblockUser(commandName);
               msg = TextConst.setVarsInString(this.localeService.getText(TextConst.CHAT_PANEL_COMMAND_UNBLOCK,commandName));
               this.addMessage("System",0,0,msg,0,0,"",true);
            }
            this.input.text = command + " ";
            return;
         }
         if(result2 > -1)
         {
            command = str1.replace(pattern1,"$1");
            if(command == "/unblockall")
            {
               LobbyChat.unblockall();
               msg = this.localeService.getText(TextConst.CHAT_PANEL_COMMAND_UNBLOCK_ALL);
               this.addMessage("System",0,0,msg,0,0,"",true);
            }
            else
            {
               list = LobbyChat.blockList;
               if(list.length > 0)
               {
                  msg = this.localeService.getText(TextConst.CHAT_PANEL_COMMAND_BLOCK_LIST);
                  for(str = "\n" + msg + "\n—————————————\n"; i < list.length; )
                  {
                     str += String(i + 1) + ": " + list[i] + "\n";
                     i++;
                  }
               }
               else
               {
                  str = "...";
               }
               this.addMessage("System",0,0,str,0,0,"",true);
            }
            htmlFlag = false;
            this.input.text = "";
            return;
         }
         if(str != "")
         {
            if(this.addressed)
            {
               str = str.slice(str.indexOf(": ") + 2,str.length);
               this.input.text = str;
               dispatchEvent(new ChatFormEvent(this._rangTo,this._nameTo));
               this.input.text = this._nameTo + ": ";
            }
            else
            {
               dispatchEvent(new ChatFormEvent());
               this.input.text = "";
            }
            this.input.setSelection(0,0);
            this.input.setSelection(this.input.length,this.input.length);
            this.output.scrollDown();
         }
      }
      
      private function onResize(e:Event) : void
      {
         var minWidth:int = int(Math.max(1000,stage.stageWidth));
         this.mainBackground.width = minWidth / 3;
         this.mainBackground.height = Math.max(stage.stageHeight - 60,530);
         x = 0;
         y = 60;
         this.inner.width = this.mainBackground.width - 22;
         this.inner.height = !!this.sendButton.visible ? Number(this.mainBackground.height - 90) : Number(this.mainBackground.height - 57);
         this.sendButton.y = this.mainBackground.height - 42;
         this.sendButton.x = this.mainBackground.width - this.sendButton.width - 11;
         this.inputControl.x = 11;
         this.inputControl.y = this.mainBackground.height - 42;
         this.inputControl.width = this.sendButton.x - 16;
         this.output.setSize(this.inner.width + 1,this.inner.height - 8);
         this.newsOutput.width = this.inner.width + 1;
         this.newsOutput.height = this.inner.height - 8;
         if(this.delayTimer == null)
         {
            this.delayTimer = new Timer(200,1);
            this.delayTimer.addEventListener(TimerEvent.TIMER,this.correctResize);
         }
         this.delayTimer.reset();
         this.delayTimer.start();
      }
      
      private function correctResize(e:TimerEvent = null) : void
      {
         this.output.setSize(this.inner.width + 1,this.inner.height - 8);
         this.delayTimer.removeEventListener(TimerEvent.TIMER,this.correctResize);
         this.delayTimer = null;
      }
      
      private function prepareSharpLink() : void
      {
         this.sharpLinks = [this.localeService.getText(TextConst.CHAT_SHARP_FAQ).split("|"),this.localeService.getText(TextConst.CHAT_SHARP_RULES).split("|"),this.localeService.getText(TextConst.CHAT_SHARP_PLANS).split("|"),this.localeService.getText(TextConst.CHAT_SHARP_RANKS).split("|"),this.localeService.getText(TextConst.CHAT_SHARP_CLANS).split("|"),this.localeService.getText(TextConst.CHAT_SHARP_FORUM).split("|"),this.localeService.getText(TextConst.CHAT_SHARP_UPDATES).split("|"),this.localeService.getText(TextConst.CHAT_SHARP_FEEDBACK).split("|"),this.localeService.getText(TextConst.CHAT_SHARP_THEFT).split("|")];
         for(var i:int = 0; i < this.sharpLinks.length; i++)
         {
            this.sharpLinks[i][0] = new RegExp("#" + this.sharpLinks[i][0],"gi");
         }
      }
      
      private function replaceSharpLinks(message:String) : String
      {
         var currentPattern:RegExp = null;
         var result:int = 0;
         var text:String = message;
         for(var i:int = 0; i < this.sharpLinks.length; i++)
         {
            currentPattern = this.sharpLinks[i][0];
            result = text.search(currentPattern);
            if(result > -1)
            {
               text = text.replace(currentPattern,"<u><a href=\'" + this.sharpLinks[i][2] + "\' target=\'_blank\'>" + this.sharpLinks[i][1] + "</a></u>");
               this.htmlFlag = true;
            }
         }
         return text;
      }
      
      private function maskMyLinks(text:String) : String
      {
         var result:int = 0;
         var forumLinkPattern:RegExp = /((http:\/\/)?(forum.tankionline.com)([-a-zA-Z0-9@:%_\+.~#?&\/]+)?(;jsessionid=([A-F0-9]+))?)/g;
         var blogLinkPattern:RegExp = /((http:\/\/)?(blog.tankionline.com)((\/[-a-zA-Z0-9@:%_\+.~#?&]+){1,3}([-a-zA-Z0-9@:%_\+.~#?&\/]+)))/g;
         result = text.search(forumLinkPattern);
         if(result > -1)
         {
            text = text.replace(forumLinkPattern,"$2forumlink$4");
            this.htmlFlag = true;
         }
         result = text.search(blogLinkPattern);
         if(result > -1)
         {
            text = text.replace(blogLinkPattern,"$2bloglink$4");
            this.htmlFlag = true;
         }
         return text;
      }
      
      public function addMessage(username:String, rang:int, chatPermissions:int, text:String, rangTo:int = 0, chatPermissionsTo:int = 0, nameTo:String = "", system:Boolean = false, _systemColor:uint = 8454016) : void
      {
         var htmlPattern:RegExp = /(<)(.*?)(>)/gi;
         var externalLink2:RegExp = /((^|\s)(http(s)?:\/\/)?(www\.)?((([a-z0-9]+)\.){1,4})([a-z]{2,10})(\/[a-z0-9\.\%\-\/\?=\:&]*)?(#([a-z0-9\.\%\-\/\?=\:&]*))?($|\s))/gi;
         var mailLink:RegExp = /((mailto: ?)?(([\w\-\.]+)@((?:[\w]+\.)+)([a-zA-Z]{2,4})))/gi;
         var forumLinkPattern:RegExp = /((http:\/\/)?(forumlink)([-a-zA-Z0-9@:%_\+.~#?&\/]+)?(;jsessionid=([A-F0-9]+))?)/g;
         var blogLinkPattern:RegExp = /((http:\/\/)?(bloglink)((\/[-a-zA-Z0-9@:%_\+.~#?&]+){1,3}([-a-zA-Z0-9@:%_\+.~#?&\/]+)))/g;
         var battlePattern:RegExp = /#battle\d+@[\w\W]+@#\d+/gi;
         var result:int = 0;
         this.htmlFlag = false;
         result = text.search(htmlPattern);
         if(result > -1)
         {
            text = text.replace(htmlPattern,"&lt;$2&gt;");
            this.htmlFlag = true;
         }
         text = this.maskMyLinks(text);
         result = text.search(externalLink2);
         if(result > -1)
         {
            text = text.replace(externalLink2," <u><a href=\'event:http$4://$6$9$10$11\'>$&</a></u> ");
            this.htmlFlag = true;
         }
         result = text.search(mailLink);
         if(result > -1)
         {
            text = text.replace(mailLink," <u><a href=\'mailto:$3\'>$3</a></u> ");
            this.htmlFlag = true;
         }
         result = text.search(battlePattern);
         if(result > -1)
         {
            text = text.replace(battlePattern,"<u><a href=\'event:" + text + "\'>" + text.split("@")[1] + "</a></u>");
            this.htmlFlag = true;
         }
         result = text.search(forumLinkPattern);
         if(result > -1)
         {
            text = text.replace(forumLinkPattern,"<u><a href=\'http://forum.tankionline.com$4\' target=\'_blank\'>http://forum...$4</a></u>");
            this.htmlFlag = true;
         }
         result = text.search(blogLinkPattern);
         if(result > -1)
         {
            text = text.replace(blogLinkPattern,"<u><a href=\'http://blog.tankionline.com$4\' target=\'_blank\'>http://blog/...$6</a></u>");
            this.htmlFlag = true;
         }
         text = this.replaceSharpLinks(text);
         if(!blocked(username))
         {
            this.output.addLine(rang,chatPermissions,username,text,rangTo,chatPermissionsTo,nameTo,system,this.htmlFlag,_systemColor);
            if(this.addressed)
            {
               this.output.selectUser(this._nameTo);
            }
         }
      }
      
      public function hide() : void
      {
      }
      
      public function cleanOutUsersMessages(uid:String) : void
      {
         this.output.cleanOutUsersMessages(uid);
      }
      
      public function cleanOutMessages(msg:String) : void
      {
         this.output.cleanOutMessages(msg);
      }
   }
}
