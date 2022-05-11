package alternativa.tanks.model.shop.event
{
   import flash.events.Event;
   
   public class ShopItemChosen extends Event
   {
      
      public static const EVENT_TYPE:String = "ShopItemChosenEVENT";
       
      
      public var itemId:String;
      
      public var gridPosition:int;
      
      public function ShopItemChosen(param1:String, param2:int)
      {
         super(EVENT_TYPE,true);
         this.itemId = param1;
         this.gridPosition = param2;
      }
   }
}
