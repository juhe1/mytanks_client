package scpacker.test
{
   public class UpdateRankPrize
   {
      
      private static var crystalls:Array = [0,100,200,300,500,1000,1500,2000,3000,4000,5000,6000,7000,8000,9000,10000,11000,12000,13000,14000,15000,16000,17000,18000,19000,20000,30000,40000,50000,60000];
       
      
      public function UpdateRankPrize()
      {
         super();
      }
      
      public static function getCount(rang:int) : int
      {
         return crystalls[rang - 1];
      }
   }
}
