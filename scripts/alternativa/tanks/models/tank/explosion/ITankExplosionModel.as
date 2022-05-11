package alternativa.tanks.models.tank.explosion
{
   import alternativa.object.ClientObject;
   import alternativa.tanks.models.tank.TankData;
   
   public interface ITankExplosionModel
   {
       
      
      function createExplosionEffects(param1:ClientObject, param2:TankData) : void;
   }
}
