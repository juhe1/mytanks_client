package alternativa.tanks.model.challenge.server
{
   public class ChallengeServerData
   {
       
      
      public var level:int;
      
      public var target_progress:int;
      
      public var progress:int;
      
      public var id:String;
      
      public var description:String;
      
      public var prizes:Array;
      
      public var completed:String;
      
      public var changeCost:int;
      
      public var specialChallenge:ChallengeServerData = null;
      
      public function ChallengeServerData()
      {
         super();
      }
   }
}
