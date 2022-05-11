package alternativa.tanks.models.sfx.shoot.shaft
{
   import alternativa.engine3d.materials.Material;
   import alternativa.math.Vector3;
   import alternativa.object.ClientObject;
   import alternativa.tanks.camera.GameCamera;
   import alternativa.tanks.models.battlefield.scene3dcontainer.Scene3DContainer;
   import alternativa.tanks.sfx.SFXUtils;
   import alternativa.tanks.utils.objectpool.ObjectPool;
   import alternativa.tanks.utils.objectpool.PooledObject;
   
   public class TrailEffect2 extends PooledObject implements ShaftTrailEffect
   {
      
      private static const BASE_WIDTH:Number = 48;
       
      
      private var position:Vector3;
      
      private var direction:Vector3;
      
      private var alphaSpeed:Number;
      
      private var timeToLive:int;
      
      private var beam:Trail2;
      
      private var container:Scene3DContainer;
      
      public function TrailEffect2(param1:ObjectPool)
      {
         this.position = new Vector3();
         this.direction = new Vector3();
         super(param1);
         this.beam = new Trail2();
      }
      
      public function init(param1:Vector3, param2:Vector3, param3:Number, param4:Number, param5:Material, param6:int) : void
      {
         this.position.vCopy(param1);
         this.direction.vCopy(param2);
         this.timeToLive = param6;
         this.alphaSpeed = 1 / param6;
         this.beam.init(BASE_WIDTH,param3,param4,param5);
      }
      
      public function play(param1:int, param2:GameCamera) : Boolean
      {
         if(this.timeToLive < 0)
         {
            return false;
         }
         this.timeToLive -= param1;
         this.beam.alpha -= this.alphaSpeed * param1;
         SFXUtils.alignObjectPlaneToView(this.beam,this.position,this.direction,param2.pos);
         return true;
      }
      
      public function addToContainer(param1:Scene3DContainer) : void
      {
         this.container = param1;
         param1.addChild(this.beam);
      }
      
      public function destroy() : void
      {
         this.container.removeChild(this.beam);
         this.container = null;
      }
      
      public function kill() : void
      {
         this.timeToLive = -1;
      }
      
      public function get owner() : ClientObject
      {
         return null;
      }
   }
}
