package forms.friends.list.renderer
{
   import alternativa.init.Main;
   import fl.controls.listClasses.CellRenderer;
   import fl.controls.listClasses.ListData;
   import flash.display.DisplayObject;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import forms.ColorConstants;
   import forms.friends.FriendActionIndicator;
   import forms.friends.list.renderer.background.RendererBackGroundOutgoingList;
   import forms.userlabel.UserLabel;
   import scpacker.networking.INetworker;
   import scpacker.networking.Network;
   
   public class FriendsOutgoingListRenderer extends CellRenderer
   {
       
      
      private var _labelsContainer:DisplayObject;
      
      private var _userLabel:UserLabel;
      
      private var _cancelRequestIndicator:FriendActionIndicator;
      
      public function FriendsOutgoingListRenderer()
      {
         super();
      }
      
      override public function set data(value:Object) : void
      {
         _data = value;
         mouseEnabled = false;
         mouseChildren = true;
         useHandCursor = false;
         buttonMode = false;
         var _loc2_:RendererBackGroundOutgoingList = new RendererBackGroundOutgoingList(false);
         var _loc3_:RendererBackGroundOutgoingList = new RendererBackGroundOutgoingList(true);
         setStyle("upSkin",_loc2_);
         setStyle("downSkin",_loc2_);
         setStyle("overSkin",_loc2_);
         setStyle("selectedUpSkin",_loc3_);
         setStyle("selectedOverSkin",_loc3_);
         setStyle("selectedDownSkin",_loc3_);
         this._labelsContainer = this.createLabels(_data);
         if(this._cancelRequestIndicator == null)
         {
            this._cancelRequestIndicator = new FriendActionIndicator(FriendActionIndicator.NO);
            addChild(this._cancelRequestIndicator);
         }
         this._cancelRequestIndicator.visible = false;
         this.addEventListener(Event.RESIZE,this.onResize,false,0,true);
         this.addEventListener(MouseEvent.ROLL_OVER,this.onRollOver,false,0,true);
         this.addEventListener(MouseEvent.ROLL_OUT,this.onRollOut,false,0,true);
         this.resize();
         this._cancelRequestIndicator.addEventListener(MouseEvent.CLICK,this.onClickCancelRequest,false,0,true);
      }
      
      private function onResize(event:Event) : void
      {
         this.resize();
      }
      
      private function resize() : void
      {
         this._cancelRequestIndicator.x = _width - this._cancelRequestIndicator.width - 6;
      }
      
      private function createLabels(data:Object) : Sprite
      {
         var _loc2_:Sprite = new Sprite();
         if(data.id != null)
         {
            this._userLabel = new UserLabel(data.id);
            this._userLabel.setUidColor(ColorConstants.GREEN_LABEL);
            this._userLabel.x = -3;
            this._userLabel.y = -1;
            this._userLabel.setRank(data.rank);
            this._userLabel.setUid(data.uid,data.uid);
            _loc2_.addChild(this._userLabel);
         }
         return _loc2_;
      }
      
      private function onRollOver(event:MouseEvent) : void
      {
         this._cancelRequestIndicator.visible = true;
         super.selected = true;
      }
      
      private function onRollOut(event:MouseEvent) : void
      {
         this._cancelRequestIndicator.visible = false;
         super.selected = false;
      }
      
      private function onClickCancelRequest(event:MouseEvent) : void
      {
         Network(Main.osgi.getService(INetworker)).send("lobby;cancel_request;" + this._userLabel.uid);
      }
      
      override public function set selected(a:Boolean) : void
      {
      }
      
      override public function set listData(value:ListData) : void
      {
         _listData = value;
         label = _listData.label;
         if(this._labelsContainer != null)
         {
            setStyle("icon",this._labelsContainer);
         }
      }
      
      override protected function drawBackground() : void
      {
         var _loc1_:String = !!enabled ? mouseState : "disabled";
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
   }
}
