package forms.friends.list
{
   import alternativa.types.Long;
   import fl.controls.List;
   import flash.display.Sprite;
   import flash.utils.Dictionary;
   import forms.friends.list.dataprovider.FriendsDataProvider;
   import utils.ScrollStyleUtils;
   
   public class FriendsList extends Sprite
   {
       
      
      protected var _dataProvider:FriendsDataProvider;
      
      protected var _list:List;
      
      protected var _width:Number;
      
      protected var _height:Number;
      
      protected var _viewed:Dictionary;
      
      private var de:Long;
      
      public function FriendsList()
      {
         this._dataProvider = new FriendsDataProvider();
         this._list = new List();
         this._viewed = new Dictionary();
         this.de = new Long(0,10000);
         super();
      }
      
      protected function init(param1:Object) : void
      {
         this._list.rowHeight = 20;
         this._list.setStyle("cellRenderer",param1);
         this._list.focusEnabled = true;
         this._list.selectable = false;
         ScrollStyleUtils.setGreenStyle(this._list);
         this._list.dataProvider = this._dataProvider;
         addChild(this._list);
         ScrollStyleUtils.setGreenStyle(this._list);
      }
      
      protected function isViewed(param1:Object) : Boolean
      {
         return param1 in this._viewed;
      }
      
      protected function setAsViewed(param1:Object) : void
      {
         this._viewed[param1] = true;
      }
      
      protected function fillFriendsList(friends_json:String) : void
      {
         var obj:Object = null;
         var i:int = 0;
         for each(obj in JSON.parse(friends_json).friends)
         {
            if(obj == null)
            {
               return;
            }
            this._dataProvider.addUser(obj.id,obj.battleId,i,obj.rank,obj.online);
            i++;
         }
         if(obj == null)
         {
            return;
         }
         this._dataProvider.setOnlineUser(new Long(0,obj.id),obj.online);
         this._dataProvider.refresh();
      }
      
      protected function fillIncomingList(friends_json:String) : void
      {
         var obj:Object = null;
         var i:int = 0;
         for each(obj in JSON.parse(friends_json).incoming)
         {
            if(obj == null)
            {
               return;
            }
            this._dataProvider.addUser(obj.id,"",i,obj.rank,true);
            i++;
         }
         if(obj == null)
         {
            return;
         }
         this._dataProvider.setOnlineUser(new Long(0,obj.id),true);
         this._dataProvider.refresh();
      }
      
      protected function fillOutcomingList(friends_json:String) : void
      {
         var obj:Object = null;
         var i:int = 0;
         for each(obj in JSON.parse(friends_json).outcoming)
         {
            if(obj == null)
            {
               return;
            }
            this._dataProvider.addUser(obj.id,"",i,obj.rank,true);
            i++;
         }
         if(obj == null)
         {
            return;
         }
         this._dataProvider.setOnlineUser(new Long(0,obj.id),true);
         this._dataProvider.refresh();
      }
      
      public function addFriend(uid:String, id:int, rank:int, isOnline:Boolean) : void
      {
         this._dataProvider.addUser(uid,"",id,rank,isOnline);
         this._dataProvider.setOnlineUser(new Long(0,id),isOnline);
         this._dataProvider.refresh();
      }
      
      protected function filterByProperty(param1:String, param2:String) : void
      {
         this._dataProvider.setFilter(param1,param2);
         this.resize(this._width,this._height);
      }
      
      public function resize(param1:Number, param2:Number) : void
      {
         this._width = param1;
         this._height = param2;
         var _loc3_:Boolean = this._list.verticalScrollBar.visible;
         this._list.width = !!_loc3_ ? Number(Number(Number(this._width + 6))) : Number(Number(Number(this._width)));
         this._list.height = this._height;
      }
   }
}
