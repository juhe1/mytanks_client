package forms.friends.list.renderer
{
   import alternativa.init.Main;
   import alternativa.osgi.service.locale.ILocaleService;
   import alternativa.tanks.model.panel.IPanel;
   import alternativa.tanks.model.panel.PanelModel;
   import controls.base.LabelBase;
   import fl.controls.listClasses.CellRenderer;
   import fl.controls.listClasses.ListData;
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.DisplayObject;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.system.System;
   import forms.ColorConstants;
   import forms.friends.FriendActionIndicator;
   import forms.friends.battleLink.BattleLink;
   import forms.friends.list.renderer.background.RendererBackGroundAcceptedList;
   import forms.userlabel.UserLabel;
   
   public class FriendsAcceptedListRenderer extends CellRenderer
   {
      
      public static var localeService:ILocaleService;
      
      public static const ROW_HEIGHT:int = 18;
      
      public static const ICON_RIGHT_OFFSET:int = 195;
      
[Embed(source="1002.png")]
      private static var gradientGreenIconClass:Class;
      
      private static var gradientGreenBitmapData:BitmapData = Bitmap(new gradientGreenIconClass()).bitmapData;
      
[Embed(source="1117.png")]
      private static var gradientGreyIconClass:Class;
      
      private static var gradientGreyBitmapData:BitmapData = Bitmap(new gradientGreyIconClass()).bitmapData;
      
[Embed(source="1103.png")]
      private static var socialFriendClass:Class;
      
      private static var socialFriendBitmapData:BitmapData = Bitmap(new socialFriendClass()).bitmapData;
      
[Embed(source="974.png")]
      private static var referralFriendClass:Class;
      
      private static var referralFriendBitmapData:BitmapData = Bitmap(new referralFriendClass()).bitmapData;
       
      
      private var labelsContainer:DisplayObject;
      
      private var userLabel:UserLabel;
      
      private var battleLink:BattleLink;
      
      private var removeFriendsIndicator:FriendActionIndicator;
      
      private var isNewLabel:LabelBase;
      
      private var gradientGreen:Bitmap;
      
      private var gradientGrey:Bitmap;
      
      private var battleInviteIcon:Bitmap;
      
      private var socialFriendIcon:Bitmap;
      
      private var referralFriendIcon:Bitmap;
      
      public function FriendsAcceptedListRenderer()
      {
         super();
      }
      
      override public function set data(param1:Object) : void
      {
         _data = param1;
         mouseEnabled = true;
         mouseChildren = true;
         useHandCursor = false;
         buttonMode = false;
         this.labelsContainer = this.createLabels(_data);
         var _loc2_:DisplayObject = new RendererBackGroundAcceptedList(param1.online);
         var _loc3_:DisplayObject = new RendererBackGroundAcceptedList(param1.online,param1.online);
         setStyle("upSkin",_loc2_);
         setStyle("downSkin",_loc2_);
         setStyle("overSkin",_loc2_);
         setStyle("selectedUpSkin",_loc3_);
         setStyle("selectedOverSkin",_loc3_);
         setStyle("selectedDownSkin",_loc3_);
      }
      
      private function createLabels(param1:Object) : Sprite
      {
         var _loc2_:Sprite = null;
         _loc2_ = new Sprite();
         if(param1.id != null)
         {
            if(this.battleInviteIcon == null)
            {
            }
            this.userLabel = new UserLabel(param1.id);
            this.userLabel.inviteBattleEnable = false;
            this.userLabel.x = 0;
            this.userLabel.y = 0;
            _loc2_.addChild(this.userLabel);
            this.userLabel.setRank(param1.rank);
            this.userLabel.setUid(param1.uid,param1.uid);
            this.userLabel.online1(param1.online);
            if(param1.isNew)
            {
               if(this.userLabel.online)
               {
                  if(this.gradientGreen == null)
                  {
                     this.gradientGreen = new Bitmap(gradientGreenBitmapData);
                  }
                  this.gradientGreen.visible = true;
                  _loc2_.addChild(this.gradientGreen);
               }
               else
               {
                  if(this.gradientGrey == null)
                  {
                     this.gradientGrey = new Bitmap(gradientGreyBitmapData);
                  }
                  this.gradientGrey.visible = true;
                  _loc2_.addChild(this.gradientGrey);
               }
               if(this.isNewLabel == null)
               {
                  this.isNewLabel = new LabelBase();
                  this.isNewLabel.text = "Новый";
                  this.isNewLabel.color = ColorConstants.GREEN_LABEL;
                  this.isNewLabel.mouseEnabled = false;
               }
               this.isNewLabel.visible = true;
               this.isNewLabel.x = 223 - this.isNewLabel.width;
               this.isNewLabel.y = 0;
               _loc2_.addChild(this.isNewLabel);
               if(this.gradientGreen != null)
               {
                  this.gradientGreen.x = this.isNewLabel.x - 7;
               }
               if(this.gradientGrey != null)
               {
                  this.gradientGrey.x = this.isNewLabel.x - 7;
               }
            }
            else
            {
               if(this.isNewLabel != null)
               {
                  this.isNewLabel.visible = false;
               }
               if(this.gradientGreen != null)
               {
                  this.gradientGreen.visible = false;
               }
               if(this.gradientGrey != null)
               {
                  this.gradientGrey.visible = false;
               }
            }
            if(this.removeFriendsIndicator != null)
            {
               this.removeFriendsIndicator.removeEventListener(MouseEvent.CLICK,this.onClickRemoveFriend);
            }
            if(this.removeFriendsIndicator == null)
            {
               this.removeFriendsIndicator = new FriendActionIndicator(FriendActionIndicator.NO);
            }
            this.removeFriendsIndicator.visible = false;
            this.removeFriendsIndicator.x = 223 - this.removeFriendsIndicator.width;
            this.removeFriendsIndicator.y = 0;
            this.removeFriendsIndicator.addEventListener(MouseEvent.CLICK,this.onClickRemoveFriend,false,0,true);
            _loc2_.addChild(this.removeFriendsIndicator);
            if(this.battleLink != null)
            {
               this.battleLink.removeEvents();
            }
            this.battleLink = new BattleLink(param1.idb);
            _loc2_.addChild(this.battleLink);
            this.battleLink.x = 233;
            this.socialFriendIcon = new Bitmap(socialFriendBitmapData);
            this.socialFriendIcon.y = 5;
            this.socialFriendIcon.visible = param1.isSNFriend && !param1.isNew;
            _loc2_.addChild(this.socialFriendIcon);
            this.referralFriendIcon = new Bitmap(referralFriendBitmapData);
            this.referralFriendIcon.y = 5;
            this.referralFriendIcon.visible = param1.isReferral && !param1.isNew;
            _loc2_.addChild(this.referralFriendIcon);
            this.arrangeIcons();
            this.updateStatusOnline();
            this.addEventListener(MouseEvent.ROLL_OVER,this.onRollOver,false,0,true);
            this.addEventListener(MouseEvent.ROLL_OUT,this.onRollOut,false,0,true);
            this.userLabel.addEventListener(MouseEvent.CLICK,this.copyName);
         }
         return _loc2_;
      }
      
      private function copyName(param1:MouseEvent) : void
      {
         System.setClipboard(this.userLabel.uid);
      }
      
      private function arrangeIcons() : void
      {
         if(this.socialFriendIcon.visible)
         {
            this.socialFriendIcon.x = ICON_RIGHT_OFFSET - (this.socialFriendIcon.width >> 1);
            if(this.referralFriendIcon.visible)
            {
               this.referralFriendIcon.x = this.socialFriendIcon.x - 15;
            }
         }
         else
         {
            this.referralFriendIcon.x = ICON_RIGHT_OFFSET - (this.referralFriendIcon.width >> 1);
         }
      }
      
      private function updateStatusOnline() : void
      {
         this.userLabel.setUidColor(!!this.userLabel.online ? uint(uint(uint(ColorConstants.GREEN_LABEL))) : uint(uint(uint(ColorConstants.ACCESS_LABEL))),true);
      }
      
      private function onRollOver(param1:MouseEvent) : void
      {
         this.removeFriendsIndicator.visible = true;
         if(_data.isNew)
         {
            if(this.isNewLabel != null)
            {
               this.isNewLabel.visible = false;
            }
            if(this.userLabel.online)
            {
               if(this.gradientGreen != null)
               {
                  this.gradientGreen.visible = false;
               }
            }
            else if(this.gradientGrey != null)
            {
               this.gradientGrey.visible = false;
            }
         }
         super.selected = true;
      }
      
      private function onRollOut(param1:MouseEvent) : void
      {
         this.removeFriendsIndicator.visible = false;
         if(_data.isNew)
         {
            if(this.isNewLabel != null)
            {
               this.isNewLabel.visible = true;
            }
            if(this.userLabel.online)
            {
               if(this.gradientGreen != null)
               {
                  this.gradientGreen.visible = true;
               }
            }
            else if(this.gradientGrey != null)
            {
               this.gradientGrey.visible = true;
            }
         }
         super.selected = false;
      }
      
      private function onClickRemoveFriend(param1:MouseEvent) : void
      {
         PanelModel(Main.osgi.getService(IPanel)).showRemoveFriendDialog(this.userLabel.uid);
      }
      
      override public function set listData(param1:ListData) : void
      {
         _listData = param1;
         label = _listData.label;
         if(this.labelsContainer != null)
         {
            setStyle("icon",this.labelsContainer);
         }
      }
      
      override protected function drawBackground() : void
      {
         var _loc1_:* = !!enabled ? mouseState : "disabled";
         if(selected)
         {
            _loc1_ = "selected" + _loc1_.substr(0,1).toUpperCase() + _loc1_.substr(1);
         }
         _loc1_ += "Skin";
         var _loc2_:DisplayObject = background;
         background = getDisplayObjectInstance(getStyleValue(_loc1_));
         addChildAt(background,0);
         if(_loc2_ != null && _loc2_ != background)
         {
            removeChild(_loc2_);
         }
      }
      
      override public function set selected(param1:Boolean) : void
      {
      }
   }
}
