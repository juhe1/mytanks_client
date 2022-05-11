package forms.friends.list
{
   import alternativa.tanks.model.Friend;
   import forms.friends.IFriendsListState;
   import forms.friends.list.renderer.FriendsOutgoingListRenderer;
   
   public class OutcomingList extends FriendsList implements IFriendsListState
   {
       
      
      public function OutcomingList()
      {
         super();
         init(FriendsOutgoingListRenderer);
         _dataProvider.getItemAtHandler = this.markAsViewed;
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
         _dataProvider.sortOn(["uid"],[Array.CASEINSENSITIVE]);
         fillOutcomingList(Friend.friends);
         _list.scrollToIndex(2);
         resize(_width,_height);
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
      
      public function filter(propertyName:String, searchString:String) : void
      {
         filterByProperty(propertyName,searchString);
         resize(_width,_height);
      }
      
      public function resetFilter() : void
      {
         _dataProvider.resetFilter();
         resize(_width,_height);
      }
   }
}
