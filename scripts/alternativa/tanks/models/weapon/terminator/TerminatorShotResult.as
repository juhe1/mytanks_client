package alternativa.tanks.models.weapon.terminator
{
   import alternativa.math.Vector3;
   
   public class TerminatorShotResult
   {
       
      
      public var targets:Array;
      
      public var hitPoints:Array;
      
      public var dir:Vector3;
      
      public function TerminatorShotResult()
      {
         this.targets = [];
         this.hitPoints = [];
         this.dir = new Vector3();
         super();
      }
   }
}
