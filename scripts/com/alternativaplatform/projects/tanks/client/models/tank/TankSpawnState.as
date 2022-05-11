package com.alternativaplatform.projects.tanks.client.models.tank
{
   public class TankSpawnState
   {
      
      public static var NEWCOME:TankSpawnState = new TankSpawnState("NEWCOME");
      
      public static var ACTIVE:TankSpawnState = new TankSpawnState("ACTIVE");
      
      public static var SUICIDE:TankSpawnState = new TankSpawnState("SUICIDE");
       
      
      private var name:String;
      
      public function TankSpawnState(name:String)
      {
         super();
         this.name = name;
      }
      
      public function toString() : String
      {
         return this.name;
      }
   }
}
