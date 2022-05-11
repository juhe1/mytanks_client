package forms.userlabel
{
   import alternativa.types.Long;
   import controls.base.LabelBase;
   import controls.rangicons.RangIconSmall;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.system.System;
   import forms.ColorConstants;
   
   public class UserLabel extends Sprite
   {
      
      protected static const RANK_ICON_CONT_WIDTH:int = 20;
      
      private static const RANK_ICON_CONT_HEIGHT:int = 18;
      
      public static var ds:Sprite = new Sprite();
       
      
      protected var shadowContainer:Sprite;
      
      protected var _userId:Long;
      
      protected var _uid:String;
      
      protected var _rank:int;
      
      protected var _uidLabel:LabelBase;
      
      protected var _writeInPublicChat:Boolean;
      
      protected var _writePrivateInChat:Boolean;
      
      protected var _blockUserEnable:Boolean;
      
      protected var _forciblySubscribeFriend:Boolean;
      
      protected var _isInitRank:Boolean;
      
      protected var _isInitUid:Boolean;
      
      protected var _focusOnUserEnabled:Boolean;
      
      protected var _hasPremium:Boolean;
      
      private var _inviteBattleEnable:Boolean;
      
      private var _rankIcon:RangIconSmall;
      
      private var _online:Boolean = false;
      
      private var _friend:Boolean = false;
      
      protected var _self:Boolean;
      
      private var _lastUidColor:uint;
      
      private var _ignoreFriendsColor:Boolean;
      
      private var _additionalText:String = "";
      
      protected var _showClanTag:Boolean = true;
      
      private var _showClanProfile:Boolean = true;
      
      private var _showInviteToClan:Boolean = true;
      
      private var nic:String = "";
      
      public function UserLabel(param1:Long, param2:Boolean = true)
      {
         this.shadowContainer = new Sprite();
         super();
         if(param1 == null)
         {
            throw Error("UserLabel userId is NULL");
         }
         this._userId = param1;
         this.init();
         ds.addEventListener("dsf",this.getlab);
      }
      
      protected function getShadowFilters() : Array
      {
         return null;
      }
      
      private function init() : void
      {
         mouseChildren = false;
         mouseEnabled = true;
         tabEnabled = false;
         tabChildren = false;
         addChild(this.shadowContainer);
         this.shadowContainer.filters = this.getShadowFilters();
         this._lastUidColor = ColorConstants.GREEN_LABEL;
         this.initSelf();
         if(!this._self)
         {
            useHandCursor = true;
            buttonMode = true;
         }
         this.createRankIcon();
         this.createAdditionalIcons();
         this.createUidLabel();
         this.updateProperties();
         this.friend(false);
         addEventListener(Event.ADDED_TO_STAGE,this.onAddedToStage);
      }
      
      protected function initSelf() : void
      {
      }
      
      protected function createAdditionalIcons() : void
      {
      }
      
      protected function updateProperties() : void
      {
      }
      
      protected function createUidLabel() : void
      {
         this._uidLabel = new LabelBase();
         this._uidLabel.x = RANK_ICON_CONT_WIDTH - 2 + this.getAdditionalIconsWidth();
         this.shadowContainer.addChild(this._uidLabel);
         this._uidLabel.visible = false;
      }
      
      protected function getAdditionalIconsWidth() : Number
      {
         return 0;
      }
      
      private function createRankIcon() : void
      {
         var _loc1_:Sprite = new Sprite();
         _loc1_.graphics.clear();
         _loc1_.graphics.beginFill(65535,0);
         _loc1_.graphics.drawRect(0,0,RANK_ICON_CONT_WIDTH,RANK_ICON_CONT_HEIGHT);
         _loc1_.graphics.endFill();
         this._rankIcon = new RangIconSmall(0);
         _loc1_.addChild(this._rankIcon);
         this.shadowContainer.addChild(_loc1_);
         this._rankIcon.visible = false;
      }
      
      private function onAddedToStage(param1:Event) : void
      {
         removeEventListener(Event.ADDED_TO_STAGE,this.onAddedToStage);
         addEventListener(Event.REMOVED_FROM_STAGE,this.onRemoveFromStage);
         this.setEvent();
      }
      
      private function onRemoveFromStage(param1:Event) : void
      {
         removeEventListener(Event.REMOVED_FROM_STAGE,this.onRemoveFromStage);
         addEventListener(Event.ADDED_TO_STAGE,this.onAddedToStage);
         this.removeEvent();
      }
      
      private function setEvent() : void
      {
         if(!this.hasEventListener(MouseEvent.CLICK))
         {
            this.addEventListener(MouseEvent.CLICK,this.onMouseClick);
         }
      }
      
      private function removeEvent() : void
      {
         if(this.hasEventListener(MouseEvent.CLICK))
         {
            this.removeEventListener(MouseEvent.CLICK,this.onMouseClick);
         }
      }
      
      protected function onMouseClick(param1:MouseEvent) : void
      {
         if(!this._isInitRank || !this._isInitUid)
         {
            return;
         }
         if(param1.ctrlKey)
         {
            System.setClipboard(this._uid);
         }
      }
      
      public function setUid(param1:String, param2:String = "") : void
      {
         if(!this._isInitUid)
         {
            this._isInitUid = true;
            this._uidLabel.visible = true;
         }
         this._uid = param1;
         this._uidLabel.text = param1;
         if(param2 != null && param2 != "")
         {
            this.nic = param2;
            this.getlab();
         }
      }
      
      public function getlab(param1:Event = null) : void
      {
         if(this.nic != null && this.nic != "")
         {
         }
      }
      
      public function setRank(param1:int) : void
      {
         this._rank = param1;
         this._isInitRank = true;
         this._rankIcon = new RangIconSmall(this._rank);
         this._rankIcon.visible = true;
         this.addChild(this._rankIcon);
         this.alignRankIcon();
      }
      
      private function alignRankIcon() : void
      {
         this._rankIcon.x = RANK_ICON_CONT_WIDTH - this._rankIcon.width >> 1;
         this._rankIcon.y = RANK_ICON_CONT_HEIGHT - this._rankIcon.height >> 1;
      }
      
      public function setUidColor(param1:uint, param2:Boolean = false) : void
      {
         this._lastUidColor = param1;
         this._ignoreFriendsColor = param2;
         this._uidLabel.color = param1;
      }
      
      public function online1(param1:Boolean) : void
      {
         this._online = param1;
         this.setUidColor(!!param1 ? (!!this._friend ? uint(uint(uint(ColorConstants.FRIEND_COLOR))) : uint(uint(uint(ColorConstants.GREEN_LABEL)))) : uint(uint(uint(ColorConstants.ACCESS_LABEL))),true);
      }
      
      public function get online() : Boolean
      {
         return this._online;
      }
      
      public function get tw() : int
      {
         return this._uidLabel.textWidth;
      }
      
      public function friend(param1:Boolean) : void
      {
         this._friend = param1;
         if(this._friend)
         {
            this._uidLabel.color = ColorConstants.FRIEND_COLOR;
            return;
         }
      }
      
      public function get userRank() : int
      {
         return this._rank;
      }
      
      public function get self() : Boolean
      {
         return this._self;
      }
      
      public function get uid() : String
      {
         return this._uid;
      }
      
      public function get userId() : Long
      {
         return this._userId;
      }
      
      public function get inviteBattleEnable() : Boolean
      {
         return this._inviteBattleEnable;
      }
      
      public function set inviteBattleEnable(param1:Boolean) : void
      {
         this._inviteBattleEnable = param1;
      }
      
      public function get premium() : Boolean
      {
         return this._hasPremium;
      }
      
      public function get showClanProfile() : Boolean
      {
         return this._showClanProfile;
      }
      
      public function set showClanProfile(param1:Boolean) : void
      {
         this._showClanProfile = param1;
      }
      
      public function get showInviteToClan() : Boolean
      {
         return this._showInviteToClan;
      }
      
      public function set showInviteToClan(param1:Boolean) : void
      {
         this._showInviteToClan = param1;
      }
   }
}
