package forms.friends
{
   import alternativa.init.Main;
   import alternativa.osgi.service.locale.ILocaleService;
   import alternativa.tanks.locale.constants.TextConst;
   import alternativa.tanks.model.Friend;
   import controls.TankWindowInner;
   import controls.base.LabelBase;
   import controls.base.TankInputBase;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.FocusEvent;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import flash.net.URLLoader;
   import flash.utils.clearTimeout;
   import flash.utils.setTimeout;
   import forms.TankWindowWithHeader;
   import forms.events.LoginFormEvent;
   import forms.friends.list.AcceptedList;
   import forms.friends.list.IncomingList;
   import forms.friends.list.OutcomingList;
   import scpacker.networking.INetworker;
   import scpacker.networking.Network;
   
   public class FriendsWindow extends Sprite
   {
      
      [Inject]
      public static var localeService:ILocaleService = Main.osgi.getService(ILocaleService) as ILocaleService;
      
      public static const WINDOW_MARGIN:int = 12;
      
      public static const DEFAULT_BUTTON_WIDTH:int = 100;
      
      private static const WINDOW_WIDTH:int = 468 + WINDOW_MARGIN * 2 + 4;
      
      private static const WINDOW_HEIGHT:int = 485;
      
      private static const SEARCH_TIMEOUT:int = 600;
      
      public static var bu:Network;
      
      public static var bup:Sprite = new Sprite();
       
      
      private var netLoader:URLLoader;
      
      private var _window:TankWindowWithHeader;
      
      private var _windowInner:TankWindowInner;
      
      public var _windowSize:Point;
      
      private var _acceptedButton:FriendsWindowStateBigButton;
      
      private var _outgoingButton:FriendsWindowStateBigButton;
      
      private var _incomingButton:FriendsWindowStateBigButton;
      
      public var _closeButton:FriendWindowButton;
      
      private var _rejectAllIncomingButton:RejectAllIncomingButton;
      
      private var _addFriendButton:RejectAllIncomingButton;
      
      private var _acceptedList:AcceptedList;
      
      private var _outcomingList:OutcomingList;
      
      private var _incomingList:IncomingList;
      
      private var _currentList:IFriendsListState;
      
      private var _searchInListTextInput:TankInputBase;
      
      private var _addFriendtTextInput:TankInputBase;
      
      private var _searchInListLabel:LabelBase;
      
      private var _searchInListTimeOut:uint;
      
      private var _addRequestView:AddRequestView;
      
      private var hh:Boolean = false;
      
      public function FriendsWindow(param1:Network)
      {
         super();
         this.init();
         bu = param1;
      }
      
      private function init() : void
      {
         this._window = TankWindowWithHeader.createWindow(localeService.getText(TextConst.FRIENDS_WINDOW_TEXT).toLocaleUpperCase());
         addChild(this._window);
         this._windowSize = new Point(WINDOW_WIDTH,WINDOW_HEIGHT);
         this._windowInner = new TankWindowInner(0,0,TankWindowInner.GREEN);
         addChild(this._windowInner);
         this._acceptedButton = new FriendsWindowStateBigButton(FriendsWindowState.ACCEPTED);
         addChild(this._acceptedButton);
         this._acceptedButton.label = localeService.getText(TextConst.FRIENDS_WINDOW_TEXT);
         this._acceptedButton.addEventListener(MouseEvent.CLICK,this.onChangeState);
         this._outgoingButton = new FriendsWindowStateBigButton(FriendsWindowState.OUTCOMING);
         addChild(this._outgoingButton);
         this._outgoingButton.label = localeService.getText(TextConst.FRIENDS_WINDOW_OUTCOMING_LIST);
         this._outgoingButton.addEventListener(MouseEvent.CLICK,this.onChangeState);
         this._incomingButton = new FriendsWindowStateBigButton(FriendsWindowState.INCOMING);
         addChild(this._incomingButton);
         this._incomingButton.label = localeService.getText(TextConst.FRIENDS_WINDOW_INCOMING_LIST);
         this._incomingButton.addEventListener(MouseEvent.CLICK,this.onChangeState);
         this._rejectAllIncomingButton = new RejectAllIncomingButton();
         addChild(this._rejectAllIncomingButton);
         this._rejectAllIncomingButton.label = localeService.getText(TextConst.FRIENDS_WINDOW_REJECT_ALL);
         this._rejectAllIncomingButton.addEventListener(MouseEvent.CLICK,this.onClickRejectAllIncoming);
         this._addFriendButton = new RejectAllIncomingButton();
         addChild(this._addFriendButton);
         this._addFriendButton.label = localeService.getText(TextConst.FRIENDS_WINDOW_SEND_INVITE);
         this._addFriendButton.addEventListener(MouseEvent.CLICK,this.onClickAddFriend);
         this._acceptedList = new AcceptedList();
         this._incomingList = new IncomingList(this._rejectAllIncomingButton);
         this._outcomingList = new OutcomingList();
         this._closeButton = new FriendWindowButton();
         addChild(this._closeButton);
         this._closeButton.label = localeService.getText(TextConst.FREE_BONUSES_WINDOW_BUTTON_CLOSE_TEXT);
         this._searchInListTextInput = new TankInputBase();
         this._searchInListTextInput.maxChars = 20;
         this._searchInListTextInput.restrict = "0-9.a-zA-z_\\-*";
         addChild(this._searchInListTextInput);
         this._addFriendtTextInput = new TankInputBase();
         this._addFriendtTextInput.maxChars = 20;
         this._addFriendtTextInput.restrict = "0-9.a-zA-z_\\-*";
         addChild(this._addFriendtTextInput);
         this._searchInListTextInput.addEventListener(FocusEvent.FOCUS_IN,this.onFocusInSearchInList);
         this._searchInListTextInput.addEventListener(FocusEvent.FOCUS_OUT,this.onFocusOutSearchInList);
         this._searchInListTextInput.addEventListener(LoginFormEvent.TEXT_CHANGED,this.onTextChangeSearchInList);
         this._searchInListLabel = new LabelBase();
         addChild(this._searchInListLabel);
         this._searchInListLabel.mouseEnabled = false;
         this._searchInListLabel.color = 10987948;
         this._searchInListLabel.text = localeService.getText(TextConst.FRIENDS_WINDOW_SEARCH_IN_LIST);
         this._addRequestView = new AddRequestView(bu);
         addChild(this._addRequestView);
         this.resize();
         this.show(FriendsWindowState.ACCEPTED);
      }
      
      public function removeFriends() : void
      {
         this._acceptedList.onRemoveFromFriends();
      }
      
      public function updateList() : void
      {
         this._acceptedList.onRemoveFromFriends();
         this._outcomingList.onRemoveFromFriends();
         this._incomingList.onRemoveFromFriends();
         this._currentList.initList();
      }
      
      private function onClickRejectAllIncoming(event:MouseEvent) : void
      {
         var obj:Object = null;
         for each(obj in JSON.parse(Friend.friends).incoming)
         {
            Network(Main.osgi.getService(INetworker)).send("lobby;deny_friend;" + obj.id);
         }
      }
      
      private function onClickAddFriend(event:MouseEvent) : void
      {
         Network(Main.osgi.getService(INetworker)).send("lobby;make_friend;" + this._addFriendtTextInput.value);
      }
      
      private function onConfirmRejectAllIncoming(event:MouseEvent) : void
      {
      }
      
      private function onTextChangeSearchInList(event:LoginFormEvent) : void
      {
         if(this._searchInListTextInput.value.length > 0)
         {
            this._searchInListLabel.visible = false;
         }
         clearTimeout(this._searchInListTimeOut);
         this._searchInListTimeOut = setTimeout(this._currentList.filter,SEARCH_TIMEOUT,"uid",this._searchInListTextInput.value);
         this.updateVisibleSearchInListLabel();
      }
      
      private function onFocusInSearchInList(event:FocusEvent) : void
      {
         this._searchInListLabel.visible = false;
      }
      
      private function onFocusOutSearchInList(event:FocusEvent) : void
      {
         this.updateVisibleSearchInListLabel();
      }
      
      private function updateVisibleSearchInListLabel() : void
      {
         if(this._searchInListTextInput.value.length == 0)
         {
            this._searchInListLabel.visible = true;
         }
      }
      
      private function onBattleLinkClick(event:MouseEvent) : void
      {
         this.hide();
      }
      
      private function resize() : void
      {
         this._window.width = this._windowSize.x;
         this._window.height = this._windowSize.y;
         this._acceptedButton.width = DEFAULT_BUTTON_WIDTH;
         this._acceptedButton.x = WINDOW_MARGIN;
         this._acceptedButton.y = WINDOW_MARGIN;
         this._incomingButton.width = DEFAULT_BUTTON_WIDTH + 50;
         this._incomingButton.x = this._windowSize.x - this._incomingButton.width - WINDOW_MARGIN;
         this._incomingButton.y = WINDOW_MARGIN;
         this._outgoingButton.width = DEFAULT_BUTTON_WIDTH + 50;
         this._outgoingButton.x = this._incomingButton.x - this._outgoingButton.width - 6;
         this._outgoingButton.y = WINDOW_MARGIN;
         this._closeButton.width = DEFAULT_BUTTON_WIDTH;
         this._closeButton.x = this._windowSize.x - this._closeButton.width - WINDOW_MARGIN;
         this._closeButton.y = this._windowSize.y - this._closeButton.height - WINDOW_MARGIN;
         this._rejectAllIncomingButton.width = DEFAULT_BUTTON_WIDTH;
         this._rejectAllIncomingButton.x = this._closeButton.x - this._rejectAllIncomingButton.width - 6;
         this._rejectAllIncomingButton.y = this._windowSize.y - this._rejectAllIncomingButton.height - WINDOW_MARGIN;
         this._addFriendButton.width = DEFAULT_BUTTON_WIDTH;
         this._addFriendButton.x = this._closeButton.x - this._addFriendButton.width - 6;
         this._addFriendButton.y = this._windowSize.y - this._addFriendButton.height - WINDOW_MARGIN;
         this._windowInner.x = WINDOW_MARGIN;
         this._windowInner.y = this._acceptedButton.y + this._acceptedButton.height + 1;
         this._windowInner.width = this._windowSize.x - WINDOW_MARGIN * 2;
         this._windowInner.height = this._windowSize.y - this._windowInner.y - this._closeButton.height - 18;
         var _loc2_:int = this._windowInner.x + 4;
         var _loc3_:int = this._windowInner.y + 4;
         var _loc4_:int = this._windowInner.width - 4 * 2 + 2;
         var _loc5_:int = this._windowInner.height - 4 * 2;
         this._acceptedList.resize(_loc4_,_loc5_);
         this._acceptedList.x = _loc2_;
         this._acceptedList.y = _loc3_;
         this._incomingList.resize(_loc4_,_loc5_);
         this._incomingList.x = _loc2_;
         this._incomingList.y = _loc3_;
         this._outcomingList.resize(_loc4_,_loc5_);
         this._outcomingList.x = _loc2_;
         this._outcomingList.y = _loc3_;
         this._searchInListTextInput.width = 235;
         this._searchInListTextInput.x = WINDOW_MARGIN;
         this._searchInListTextInput.y = this._windowSize.y - this._searchInListTextInput.height - WINDOW_MARGIN;
         this._addFriendtTextInput.width = 235;
         this._addFriendtTextInput.x = WINDOW_MARGIN;
         this._addFriendtTextInput.y = this._windowSize.y - this._addFriendtTextInput.height - WINDOW_MARGIN;
         this._searchInListLabel.x = this._searchInListTextInput.x + 3;
         this._searchInListLabel.y = this._searchInListTextInput.y + 7;
         this._addRequestView.y = this._windowSize.y - this._addRequestView.height - WINDOW_MARGIN;
      }
      
      private function onChangeState(event:MouseEvent) : void
      {
         this.hh = !this.hh;
         this.show(FriendsWindowButtonType(event.currentTarget).getType());
      }
      
      public function destroy() : void
      {
         this._acceptedButton.removeEventListener(MouseEvent.CLICK,this.onChangeState);
         this._outgoingButton.removeEventListener(MouseEvent.CLICK,this.onChangeState);
         this._incomingButton.removeEventListener(MouseEvent.CLICK,this.onChangeState);
         this._searchInListTextInput.removeEventListener(FocusEvent.FOCUS_IN,this.onFocusInSearchInList);
         this._searchInListTextInput.removeEventListener(FocusEvent.FOCUS_OUT,this.onFocusOutSearchInList);
         this._rejectAllIncomingButton.removeEventListener(MouseEvent.CLICK,this.onClickRejectAllIncoming);
         this.hide();
      }
      
      private function hide() : void
      {
         if(this._closeButton.hasEventListener(MouseEvent.CLICK))
         {
            this._closeButton.removeEventListener(MouseEvent.CLICK,this.onCloseButtonClick);
         }
         if(this._currentList != null)
         {
            this._currentList.hide();
            this._currentList = null;
         }
         clearTimeout(this._searchInListTimeOut);
         this._addRequestView.hide();
      }
      
      private function job(param1:Event) : void
      {
         this.hide();
         if(this.hh)
         {
            FriendsWindowState.INCOMING = new FriendsWindowState(1);
            this.show(FriendsWindowState.INCOMING);
         }
         else
         {
            FriendsWindowState.ACCEPTED = new FriendsWindowState(0);
            this.show(FriendsWindowState.ACCEPTED);
         }
      }
      
      private function getFriendsListByState(param1:FriendsWindowState) : IFriendsListState
      {
         switch(param1)
         {
            case FriendsWindowState.ACCEPTED:
               return this._acceptedList;
            case FriendsWindowState.INCOMING:
               return this._incomingList;
            case FriendsWindowState.OUTCOMING:
               return this._outcomingList;
            default:
               return this._acceptedList;
         }
      }
      
      public function show(param1:FriendsWindowState = null) : void
      {
         switch(param1)
         {
            case FriendsWindowState.ACCEPTED:
               this.showAccepted();
               break;
            case FriendsWindowState.INCOMING:
               this.showIncoming();
               break;
            case FriendsWindowState.OUTCOMING:
               this.showOutgoing();
         }
         this._searchInListTextInput.value = "";
         this._addFriendtTextInput.value = "";
         this._currentList.resetFilter();
      }
      
      private function showAccepted() : void
      {
         this.updateState(FriendsWindowState.ACCEPTED);
         this._acceptedList.initList();
         addChild(this._acceptedList);
         this._currentList = this._acceptedList;
      }
      
      private function showIncoming() : void
      {
         this.updateState(FriendsWindowState.INCOMING);
         this._incomingList.initList();
         addChild(this._incomingList);
         this._currentList = this._incomingList;
      }
      
      private function showOutgoing() : void
      {
         this.updateState(FriendsWindowState.OUTCOMING);
         this._outcomingList.initList();
         addChild(this._outcomingList);
         this._currentList = this._outcomingList;
      }
      
      private function updateState(state:FriendsWindowState) : void
      {
         this.currentState = state;
         if(this._currentList != null)
         {
            this._currentList.hide();
            this._currentList = null;
         }
         if(!this._closeButton.hasEventListener(MouseEvent.CLICK))
         {
            this._closeButton.addEventListener(MouseEvent.CLICK,this.onCloseButtonClick);
         }
      }
      
      private function onCloseButtonClick(event:MouseEvent = null) : void
      {
         this.closeWindow();
      }
      
      private function closeWindow() : void
      {
         this._searchInListTextInput.value = "";
         this.updateVisibleSearchInListLabel();
         this.hide();
      }
      
      public function set currentState(value:FriendsWindowState) : void
      {
         switch(value)
         {
            case FriendsWindowState.ACCEPTED:
               this._acceptedButton.enable = false;
               this._outgoingButton.enable = true;
               this._incomingButton.enable = true;
               this._rejectAllIncomingButton.visible = false;
               this._searchInListTextInput.visible = true;
               this._addFriendButton.visible = false;
               this._addFriendtTextInput.visible = false;
               this.updateVisibleSearchInListLabel();
               this._addRequestView.hide();
               break;
            case FriendsWindowState.INCOMING:
               this._acceptedButton.enable = true;
               this._outgoingButton.enable = true;
               this._incomingButton.enable = false;
               this._rejectAllIncomingButton.visible = true;
               this._searchInListTextInput.visible = true;
               this._addFriendButton.visible = false;
               this._addFriendtTextInput.visible = false;
               this.updateVisibleSearchInListLabel();
               this._addRequestView.hide();
               break;
            case FriendsWindowState.OUTCOMING:
               this._acceptedButton.enable = true;
               this._outgoingButton.enable = false;
               this._incomingButton.enable = true;
               this._rejectAllIncomingButton.visible = false;
               this._searchInListTextInput.visible = false;
               this._searchInListLabel.visible = false;
               this._addFriendButton.visible = true;
               this._addFriendtTextInput.visible = true;
               this._addRequestView.hide();
         }
      }
   }
}
