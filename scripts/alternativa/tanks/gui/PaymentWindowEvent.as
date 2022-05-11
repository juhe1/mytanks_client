package alternativa.tanks.gui
{
   import flash.events.Event;
   
   public class PaymentWindowEvent extends Event
   {
      
      public static const SELECT_COUNTRY:String = "PaymentWindowEventSelectCountry";
      
      public static const SELECT_OPERATOR:String = "PaymentWindowEventSelectOperator";
      
      public static const CLOSE:String = "PaymentWindowEventClose";
       
      
      public function PaymentWindowEvent(type:String)
      {
         super(type,true,false);
      }
   }
}
