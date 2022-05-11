package alternativa.physics
{
   import alternativa.math.Quaternion;
   import alternativa.math.Vector3;
   
   public class BodyState
   {
       
      
      public var pos:Vector3;
      
      public var orientation:Quaternion;
      
      public var velocity:Vector3;
      
      public var rotation:Vector3;
      
      public function BodyState(localTank:Boolean = false)
      {
         this.orientation = new Quaternion();
         this.rotation = new Vector3();
         super();
         this.pos = new Vector3();
         this.velocity = new Vector3();
      }
      
      public function copy(state:BodyState) : void
      {
         this.pos.vCopy(state.pos);
         this.orientation.copy(state.orientation);
         this.velocity.vCopy(state.velocity);
         this.rotation.vCopy(state.rotation);
      }
   }
}
