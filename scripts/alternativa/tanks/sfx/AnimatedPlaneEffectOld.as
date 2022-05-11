package alternativa.tanks.sfx
{
   import alternativa.engine3d.alternativa3d;
   import alternativa.engine3d.core.Clipping;
   import alternativa.engine3d.core.Sorting;
   import alternativa.engine3d.materials.Material;
   import alternativa.engine3d.primitives.Plane;
   import alternativa.math.Vector3;
   import alternativa.object.ClientObject;
   import alternativa.tanks.camera.GameCamera;
   import alternativa.tanks.models.battlefield.scene3dcontainer.Scene3DContainer;
   import alternativa.tanks.utils.objectpool.ObjectPool;
   import alternativa.tanks.utils.objectpool.PooledObject;
   
   public class AnimatedPlaneEffectOld extends PooledObject implements IGraphicEffect
   {
      
      private static const BASE_SIZE:Number = 100;
       
      
      private var framesPerMillisecond:Number;
      
      private var frames:Vector.<Material>;
      
      private var numFrames:int;
      
      private var scaleSpeed:Number;
      
      private var currentFrame:Number;
      
      private var scale:Number;
      
      private var baseScale:Number;
      
      private var plane:Plane;
      
      public function AnimatedPlaneEffectOld(objectPool:ObjectPool)
      {
         super(objectPool);
      }
      
      public function init(size:Number, position:Vector3, rotation:Vector3, fps:Number, frames:Vector.<Material>, scaleSpeed:Number) : void
      {
         this.framesPerMillisecond = 0.001 * fps;
         this.frames = frames;
         this.scaleSpeed = 0.001 * scaleSpeed;
         this.numFrames = frames.length;
         if(this.plane == null)
         {
            this.plane = new Plane(BASE_SIZE,BASE_SIZE);
            this.plane.clipping = Clipping.FACE_CLIPPING;
            this.plane.sorting = Sorting.DYNAMIC_BSP;
         }
         this.baseScale = size / BASE_SIZE;
         this.scale = this.baseScale;
         this.plane.x = position.x;
         this.plane.y = position.y;
         this.plane.z = position.z;
         this.plane.rotationX = rotation.x;
         this.plane.rotationY = rotation.y;
         this.plane.rotationZ = rotation.z;
         this.plane.useShadowMap = false;
         this.plane.useLight = false;
         this.plane.shadowMapAlphaThreshold = 2;
         this.plane.depthMapAlphaThreshold = 2;
         this.plane.softAttenuation = 0;
         this.currentFrame = 0;
      }
      
      public function addToContainer(container:Scene3DContainer) : void
      {
         container.addChild(this.plane);
      }
      
      public function play(millis:int, camera:GameCamera) : Boolean
      {
         if(this.currentFrame >= this.numFrames)
         {
            return false;
         }
         this.plane.setMaterialToAllFaces(this.frames[int(this.currentFrame)]);
         this.currentFrame += this.framesPerMillisecond * millis;
         this.plane.scaleX = this.scale;
         this.plane.scaleY = this.scale;
         this.scale += this.baseScale * this.scaleSpeed * millis;
         return true;
      }
      
      public function destroy() : void
      {
         this.plane.alternativa3d::removeFromParent();
         this.plane.destroy();
         storeInPool();
      }
      
      public function kill() : void
      {
         this.currentFrame = this.frames.length;
      }
      
      public function get owner() : ClientObject
      {
         return null;
      }
      
      override protected function getClass() : Class
      {
         return AnimatedPlaneEffect;
      }
   }
}
