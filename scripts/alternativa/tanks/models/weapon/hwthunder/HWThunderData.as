package alternativa.tanks.models.weapon.hwthunder
{
   public class HWThunderData
   {
       
      
      public var maxSplashDamageRadius:Number = 0;
      
      public var minSplashDamageRadius:Number = 0;
      
      public var minSplashDamagePercent:Number = 0;
      
      public var impactForce:Number = 0;
      
      public function HWThunderData(maxSplashDamageRadius:Number, minSplashDamageRadius:Number, minSplashDamagePercent:Number, impactForce:Number)
      {
         super();
         this.maxSplashDamageRadius = maxSplashDamageRadius;
         this.minSplashDamageRadius = minSplashDamageRadius;
         this.minSplashDamagePercent = minSplashDamagePercent;
         this.impactForce = impactForce;
      }
   }
}
