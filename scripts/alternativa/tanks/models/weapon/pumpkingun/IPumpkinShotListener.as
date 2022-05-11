package alternativa.tanks.models.weapon.pumpkingun
{
   import alternativa.math.Vector3;
   import alternativa.physics.Body;
   
   public interface IPumpkinShotListener
   {
       
      
      function shotHit(param1:PumpkinShot, param2:Vector3, param3:Vector3, param4:Body) : void;
   }
}
