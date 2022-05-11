package alternativa.tanks.models.weapon.shaft
{
   import alternativa.math.Vector3;
   import alternativa.tanks.vehicles.tanks.Tank;
   
   public class Aim
   {
       
      
      public var target:Tank;
      
      public var targetHitPoint:Vector3;
      
      public function Aim(b:Tank, v:Vector3)
      {
         super();
         this.target = b;
         this.targetHitPoint = v;
      }
   }
}
