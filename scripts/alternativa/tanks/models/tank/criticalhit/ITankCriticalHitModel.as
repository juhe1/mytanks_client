package alternativa.tanks.models.tank.criticalhit
{
   import alternativa.object.ClientObject;
   import alternativa.tanks.models.tank.TankData;
   
   public interface ITankCriticalHitModel
   {
       
      
      function createExplosionEffects(param1:ClientObject, param2:TankData) : void;
   }
}
