package alternativa.tanks.model
{
   import flash.utils.getTimer;
   
   public class PingService
   {
      
      private static var ping:int;
      
      private static var reqTime:int;
      
      private static var resTime:int;
       
      
      public function PingService()
      {
         super();
      }
      
      public static function setReqTime() : void
      {
         reqTime = getTimer();
      }
      
      public static function getResTime() : int
      {
         return resTime;
      }
      
      public static function setPing() : void
      {
         ping = getTimer() - reqTime;
         resTime = getTimer();
      }
      
      public static function getPing() : int
      {
         return ping;
      }
   }
}
