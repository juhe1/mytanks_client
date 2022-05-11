package projects.tanks.client.battleselect.types
{
   import projects.tanks.client.battleservice.model.team.BattleTeamType;
   
   public class UserInfoClient
   {
       
      
      public var id:String;
      
      public var type:BattleTeamType;
      
      public var name:String;
      
      public var rank:int;
      
      public var kills:int;
      
      public var isBot:Boolean;
      
      public function UserInfoClient()
      {
         super();
      }
   }
}
