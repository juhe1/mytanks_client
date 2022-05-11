package com.alternativaplatform.projects.tanks.client.models.tank
{
   import com.alternativaplatform.projects.tanks.client.commons.types.TankSpecification;
   import com.alternativaplatform.projects.tanks.client.commons.types.TankState;
   import projects.tanks.client.battleservice.model.team.BattleTeamType;
   
   public class ClientTank
   {
       
      
      public var self:Boolean;
      
      public var teamType:BattleTeamType;
      
      public var incarnationId:int;
      
      public var tankSpecification:TankSpecification;
      
      public var tankState:TankState;
      
      public var spawnState:TankSpawnState;
      
      public var health:int;
      
      public function ClientTank()
      {
         super();
      }
   }
}
