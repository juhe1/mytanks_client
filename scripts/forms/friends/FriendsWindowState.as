package forms.friends
{
   public class FriendsWindowState
   {
      
      public static var ACCEPTED:FriendsWindowState = new FriendsWindowState(0);
      
      public static var INCOMING:FriendsWindowState = new FriendsWindowState(1);
      
      public static var OUTCOMING:FriendsWindowState = new FriendsWindowState(2);
       
      
      private var _value:int;
      
      public function FriendsWindowState(param1:int)
      {
         super();
         this._value = param1;
      }
      
      public function get value() : int
      {
         return this._value;
      }
   }
}
