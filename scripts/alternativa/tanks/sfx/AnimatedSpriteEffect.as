package alternativa.tanks.sfx
{
   import alternativa.engine3d.alternativa3d;
   import alternativa.engine3d.materials.Material;
   import alternativa.engine3d.objects.Sprite3D;
   import alternativa.math.Vector3;
   import alternativa.object.ClientObject;
   import alternativa.tanks.camera.GameCamera;
   import alternativa.tanks.models.battlefield.scene3dcontainer.Scene3DContainer;
   import alternativa.tanks.utils.objectpool.ObjectPool;
   import alternativa.tanks.utils.objectpool.PooledObject;
   import flash.geom.ColorTransform;
   
   public class AnimatedSpriteEffect extends PooledObject implements IGraphicEffect
   {
      
      private static var toCamera:Vector3 = new Vector3();
       
      
      private var sprite:Sprite3D;
      
      private var offsetToCamera:Number;
      
      private var framesPerMillisecond:Number;
      
      private var currFrame:Number;
      
      private var materials:Vector.<Material>;
      
      private var numFrames:int;
      
      private var position:Vector3;
      
      private var loop:Boolean;
      
      public function AnimatedSpriteEffect(objectPool:ObjectPool)
      {
         this.position = new Vector3();
         super(objectPool);
      }
      
      public function init(width:Number, height:Number, materials:Vector.<Material>, position:Vector3, rotation:Number, offsetToCamera:Number, fps:Number, loop:Boolean, originX:Number = 0.5, originY:Number = 0.5, colorTransform:ColorTransform = null) : void
      {
         this.initSprite(width,height,rotation,originX,originY,colorTransform);
         this.materials = materials;
         this.offsetToCamera = offsetToCamera;
         this.framesPerMillisecond = 0.001 * fps;
         this.position.vCopy(position);
         this.loop = loop;
         this.numFrames = materials.length;
         this.sprite.softAttenuation = 140;
         this.currFrame = 0;
      }
      
      public function addToContainer(container:Scene3DContainer) : void
      {
         container.addChild(this.sprite);
      }
      
      public function get owner() : ClientObject
      {
         return null;
      }
      
      public function play(timeDelta:int, camera:GameCamera) : Boolean
      {
         if(!this.loop && this.currFrame >= this.numFrames)
         {
            return false;
         }
         toCamera.x = camera.x - this.position.x;
         toCamera.y = camera.y - this.position.y;
         toCamera.z = camera.z - this.position.z;
         toCamera.vNormalize();
         this.sprite.x = this.position.x + this.offsetToCamera * toCamera.x;
         this.sprite.y = this.position.y + this.offsetToCamera * toCamera.y;
         this.sprite.z = this.position.z + this.offsetToCamera * toCamera.z;
         this.sprite.material = this.materials[int(this.currFrame)];
         this.currFrame += this.framesPerMillisecond * timeDelta;
         if(this.loop)
         {
            while(this.currFrame >= this.numFrames)
            {
               this.currFrame -= this.numFrames;
            }
         }
         return true;
      }
      
      public function destroy() : void
      {
         this.sprite.alternativa3d::removeFromParent();
         this.sprite.material = null;
         this.sprite.destroy();
         this.sprite = null;
         this.materials = null;
         storeInPool();
      }
      
      public function kill() : void
      {
         this.loop = false;
         this.currFrame = this.numFrames + 1;
      }
      
      override protected function getClass() : Class
      {
         return AnimatedSpriteEffect;
      }
      
      private function initSprite(width:Number, height:Number, rotation:Number, originX:Number, originY:Number, colorTransform:ColorTransform) : void
      {
         if(this.sprite == null)
         {
            this.sprite = new Sprite3D(width,height);
         }
         else
         {
            this.sprite.width = width;
            this.sprite.height = height;
         }
         this.sprite.rotation = rotation;
         this.sprite.originX = originX;
         this.sprite.originY = originY;
         this.sprite.colorTransform = colorTransform;
         this.sprite.useShadowMap = false;
         this.sprite.useLight = false;
      }
   }
}
