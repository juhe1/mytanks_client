package forms.events
{
   import flash.events.Event;
   
   public class MainButtonBarEvents extends Event
   {
      
      public static const ADDMONEY:String = "AddMoney";
      
      public static const PROFILE:String = "Profile";
      
      public static const CHALLENGE:String = "Challenge";
      
      public static const BATTLE:String = "Batle";
      
      public static const GARAGE:String = "Garage";
      
      public static const STAT:String = "Stat";
      
      public static const CLANS:String = "Clans";
      
      public static const SOUND:String = "Sound";
      
      public static const SETTINGS:String = "Settings";
      
      public static const HELP:String = "Help";
      
      public static const CLOSE:String = "Close";
      
      public static const BUGS:String = "Bugs";
      
      public static const EXCHANGE:String = "ChangeMoney";
      
      public static const SOCIALNETS:String = "Referal";
      
      public static const SPINS:String = "Spins";
      
      public static const FRIENDS:String = "Friends";
      
      public static const PANEL_BUTTON_PRESSED:String = "Close";
       
      
      private var types:Array;
      
      private var _typeButton:String;
      
      public function MainButtonBarEvents(typeButton:int)
      {
         this.types = new Array(ADDMONEY,PROFILE,CHALLENGE,BATTLE,GARAGE,STAT,SETTINGS,SOUND,HELP,CLOSE,BUGS,EXCHANGE,SPINS,SOCIALNETS,FRIENDS,CLANS);
         super(MainButtonBarEvents.PANEL_BUTTON_PRESSED,true,false);
         this._typeButton = this.types[typeButton - 1];
      }
      
      public function get typeButton() : String
      {
         return this._typeButton;
      }
   }
}
