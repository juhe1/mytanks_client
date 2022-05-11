package forms.friends.list
{
   import alternativa.tanks.model.Friend;
   import forms.friends.IFriendsListState;
   import forms.friends.IRejectAllIncomingButtonEnabled;
   import forms.friends.list.renderer.FriendsIncomingListRenderer;
   
   public class IncomingList extends FriendsList implements IFriendsListState
   {
       
      
      private var _rejectAllIncomingButton:IRejectAllIncomingButtonEnabled;
      
      public function IncomingList(param1:IRejectAllIncomingButtonEnabled)
      {
         super();
         this._rejectAllIncomingButton = param1;
         init(FriendsIncomingListRenderer);
         _dataProvider.getItemAtHandler = this.markAsViewed;
      }
      
      public function initList() : void
      {
         _dataProvider.sortOn(["isNew","uid"],[Array.NUMERIC | Array.DESCENDING,Array.CASEINSENSITIVE]);
         fillIncomingList(Friend.friends);
         this.updateEnableRejectButton();
         _list.scrollToIndex(2);
         resize(_width,_height);
      }
      
      public function onRemoveFromFriends() : void
      {
         _dataProvider.removeAll();
         _dataProvider.refresh();
         this.resize(_width,_height);
      }
      
      private function updateEnableRejectButton() : void
      {
         this._rejectAllIncomingButton.setEnable(_dataProvider.length != 0);
      }
      
      private function markAsViewed(param1:Object) : void
      {
         if(!isViewed(param1) && param1.isNew)
         {
            setAsViewed(param1);
         }
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
         resize(_width,_height);
      }
      
      public function resetFilter() : void
      {
         _dataProvider.resetFilter();
         resize(_width,_height);
      }
   }
}
