package scpacker.test.usertitles
{
   import alternativa.math.Vector3;
   import alternativa.tanks.models.battlefield.IBattleField;
   import alternativa.tanks.models.tank.TankData;
   
   public interface UserTitlesRender
   {
       
      
      function render() : void;
      
      function setBattlefield(param1:IBattleField) : void;
      
      function setLocalData(param1:TankData) : void;
      
      function updateTitle(param1:TankData, param2:Vector3) : void;
      
      function configurateTitle(param1:TankData) : void;
   }
}
