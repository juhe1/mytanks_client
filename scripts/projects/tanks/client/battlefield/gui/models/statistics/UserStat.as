package projects.tanks.client.battlefield.gui.models.statistics
{
   import projects.tanks.client.battleservice.model.team.BattleTeamType;
   
   public class UserStat
   {
       
      
      public var name:String;
      
      public var rank:int;
      
      public var teamType:BattleTeamType;
      
      public var userId:String;
      
      public var kills:int;
      
      public var deaths:int;
      
      public var score:int;
      
      public var reward:int;
      
      public function UserStat(kills:int, deaths:int, name:String, rank:int, score:int, reward:int, teamType:BattleTeamType, userId:String)
      {
         super();
         this.name = name;
         this.rank = rank;
         this.teamType = teamType;
         this.userId = userId;
         this.kills = kills;
         this.deaths = deaths;
         this.score = score;
         this.reward = reward;
      }
   }
}
