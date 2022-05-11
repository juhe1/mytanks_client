package alternativa.tanks.models.weapon.shaft
{
   import alternativa.math.Vector3;
   import alternativa.tanks.vehicles.tanks.Tank;
   
   public class AimedShotResult
   {
       
      
      public var aims:Array;
      
      public var staticHitPoint:Vector3;
      
      public var targetHitPoint:Vector3;
      
      public function AimedShotResult()
      {
         this.aims = new Array();
         super();
      }
      
      public function setTarget(param1:Tank, param2:Vector3) : void
      {
         this.targetHitPoint = param2;
         this.aims.push(new Aim(param1,param2));
      }
      
      public function setStaticHitPoint(param1:Vector3) : void
      {
         this.staticHitPoint = param1.vClone();
      }
   }
}
