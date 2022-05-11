package forms.friends.list
{
   import alternativa.tanks.model.Friend;
   import forms.friends.IFriendsListState;
   import forms.friends.list.dataprovider.FriendsDataProvider;
   import forms.friends.list.renderer.FriendsAcceptedListRenderer;
   import forms.friends.list.renderer.HeaderAcceptedList;
   
   public class AcceptedList extends FriendsList implements IFriendsListState
   {
      
      public static var SCROLL_ON:Boolean;
       
      
      private var _header:HeaderAcceptedList;
      
      public function AcceptedList()
      {
         this._header = new HeaderAcceptedList();
         super();
         init(FriendsAcceptedListRenderer);
         _dataProvider.getItemAtHandler = this.markAsViewed;
         addChild(this._header);
      }
      
      private function markAsViewed(param1:Object) : void
      {
         if(!isViewed(param1) && param1.isNew)
         {
            setAsViewed(param1);
         }
      }
      
      public function initList() : void
      {
         _dataProvider.sortOn([FriendsDataProvider.IS_NEW,FriendsDataProvider.ONLINE,FriendsDataProvider.IS_BATTLE,FriendsDataProvider.UID],[Array.NUMERIC | Array.DESCENDING,Array.NUMERIC | Array.DESCENDING,Array.NUMERIC | Array.DESCENDING,Array.CASEINSENSITIVE]);
         fillFriendsList(Friend.friends);
         _list.scrollToIndex(2);
         this.resize(_width,_height);
      }
      
      public function addFriends(uid:String, id:int, rank:int, isOnline:Boolean) : void
      {
         addFriend(uid,id,rank,isOnline);
      }
      
      override public function resize(param1:Number, param2:Number) : void
      {
         _width = param1;
         _height = param2;
         AcceptedList.SCROLL_ON = _list.verticalScrollBar.visible;
         this._header.width = _width;
         _list.y = 20;
         _list.width = !!AcceptedList.SCROLL_ON ? Number(Number(Number(_width + 6))) : Number(Number(Number(_width)));
         _list.height = _height - 20;
      }
      
      public function onRemoveFromFriends() : void
      {
         _dataProvider.removeAll();
         _dataProvider.refresh();
         this.resize(_width,_height);
      }
      
      public function hide() : void
      {
         if(parent.contains(this))
         {
            parent.removeChild(this);
            _dataProvider.removeAll();
         }
      }
      
      public function filter(param1:String, param2:String) : void
      {
         filterByProperty(param1,param2);
         this.resize(_width,_height);
      }
      
      public function resetFilter() : void
      {
         _dataProvider.resetFilter();
         this.resize(_width,_height);
      }
   }
}
