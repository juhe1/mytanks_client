package alternativa.tanks.models.sfx
{
   import alternativa.engine3d.alternativa3d;
   import alternativa.engine3d.core.Object3D;
   import alternativa.engine3d.materials.Material;
   import alternativa.engine3d.objects.Sprite3D;
   import alternativa.math.Matrix4;
   import alternativa.math.Vector3;
   import alternativa.object.ClientObject;
   import alternativa.tanks.camera.GameCamera;
   import alternativa.tanks.models.battlefield.scene3dcontainer.Scene3DContainer;
   import alternativa.tanks.sfx.IGraphicEffect;
   import alternativa.tanks.utils.objectpool.ObjectPool;
   import alternativa.tanks.utils.objectpool.PooledObject;
   import flash.geom.ColorTransform;
   
   public class SpriteShotEffect extends PooledObject implements IGraphicEffect
   {
      
      private static const STATE_BRIGHT:int = 1;
      
      private static const STATE_FADE:int = 2;
      
      private static var turretMatrix:Matrix4 = new Matrix4();
      
      private static var globalPosition:Vector3 = new Vector3();
       
      
      private var sprite:Sprite3D;
      
      private var brightTime:int;
      
      private var fadeTime:int;
      
      private var turret:Object3D;
      
      private var localPosition:Vector3;
      
      private var time:int;
      
      private var state:int;
      
      public function SpriteShotEffect(objectPool:ObjectPool)
      {
         this.localPosition = new Vector3();
         super(objectPool);
         this.sprite = new Sprite3D(100,100);
      }
      
      public function init(material:Material, localMuzzlePosition:Vector3, turret:Object3D, localOffset:Number, size:Number, brightTime:int, fadeTime:int, colorTransform:ColorTransform) : void
      {
         this.localPosition.vCopy(localMuzzlePosition);
         this.localPosition.y += localOffset;
         this.turret = turret;
         this.brightTime = brightTime;
         this.fadeTime = fadeTime;
         this.sprite.material = material;
         this.sprite.width = size;
         this.sprite.height = size;
         this.sprite.rotation = Math.random() * Math.PI * 2;
         this.sprite.colorTransform = colorTransform;
         this.sprite.alpha = 1;
         this.state = STATE_BRIGHT;
         this.time = brightTime;
      }
      
      public function get owner() : ClientObject
      {
         return null;
      }
      
      public function play(millis:int, camera:GameCamera) : Boolean
      {
         switch(this.state)
         {
            case STATE_BRIGHT:
               if(this.time < 0)
               {
                  this.state = STATE_FADE;
                  this.time = this.fadeTime;
               }
               else
               {
                  this.time -= millis;
               }
               break;
            case STATE_FADE:
               if(this.time < 0)
               {
                  return false;
               }
               this.time -= millis;
               this.sprite.alpha = this.time / this.fadeTime;
               break;
         }
         turretMatrix.setMatrix(this.turret.x,this.turret.y,this.turret.z,this.turret.rotationX,this.turret.rotationY,this.turret.rotationZ);
         turretMatrix.transformVector(this.localPosition,globalPosition);
         this.sprite.x = globalPosition.x;
         this.sprite.y = globalPosition.y;
         this.sprite.z = globalPosition.z;
         return true;
      }
      
      public function destroy() : void
      {
         this.sprite.alternativa3d::removeFromParent();
         this.sprite.material = null;
         this.sprite.colorTransform = null;
         this.turret = null;
         storeInPool();
      }
      
      public function addToContainer(container:Scene3DContainer) : void
      {
         container.addChild(this.sprite);
      }
      
      public function kill() : void
      {
      }
      
      override protected function getClass() : Class
      {
         return SpriteShotEffect;
      }
   }
}
