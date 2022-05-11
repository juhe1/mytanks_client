package alternativa.tanks.models.battlefield.gamemode
{
   public class GameModes
   {
      
      public static const DEFAULT:IGameMode = new DefaultGameModel();
      
      public static const NIGHT:IGameMode = new NightGameMode();
      
      public static const SPACE:IGameMode = new SpaceGameMode();
      
      public static const NEWYEAR:IGameMode = new NewYearGameMode();
      
      public static const HALLOWEEN:IGameMode = new HalloweenGameMode();
      
      public static const DAY:IGameMode = new DayGameMode();
      
      public static const FOG:IGameMode = new FogGameMode();
       
      
      public function GameModes()
      {
         super();
      }
      
      public static function getGameMode(id:String) : IGameMode
      {
         if(id == "night")
         {
            return NIGHT;
         }
         if(id == "space")
         {
            return SPACE;
         }
         if(id == "ny")
         {
            return NEWYEAR;
         }
         if(id == "halloween")
         {
            return HALLOWEEN;
         }
         if(id == "day")
         {
            return DAY;
         }
         if(id == "fog")
         {
            return FOG;
         }
         return DEFAULT;
      }
   }
}
