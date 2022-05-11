package scpacker.server.models.shaft
{
   import alternativa.math.Vector3;
   
   public class ServerShaftTargetData
   {
       
      
      public var hitPoint:Vector3;
      
      public var globalHitPoint:Vector3;
      
      public var targetId:String;
      
      public function ServerShaftTargetData(hitPoint:Vector3, globalHitPoint:Vector3, targetId:String)
      {
         super();
         this.hitPoint = hitPoint;
         this.globalHitPoint = globalHitPoint;
         this.targetId = targetId;
      }
   }
}
