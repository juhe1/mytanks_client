package alternativa.tanks.models.battlefield.effects
{
   import alternativa.engine3d.core.Object3D;
   import alternativa.engine3d.materials.TextureMaterial;
   import alternativa.engine3d.objects.Sprite3D;
   import alternativa.object.ClientObject;
   import alternativa.tanks.camera.GameCamera;
   import alternativa.tanks.models.battlefield.scene3dcontainer.Scene3DContainer;
   import alternativa.tanks.sfx.IGraphicEffect;
   import alternativa.tanks.utils.objectpool.ObjectPool;
   import alternativa.tanks.utils.objectpool.PooledObject;
   
   public class DamageUpEffect extends PooledObject implements IGraphicEffect
   {
      
      private static const POP_HEIGHT:Number = 100;
      
      private static const REST_HEIGHT:Number = 250;
      
      private static const MAX_HEIGHT:Number = 300;
      
      private static const POP_SPEED:Number = 1000;
      
      private static const REST_SPEED:Number = 100;
       
      
      private var damage:Sprite3D;
      
      private var delay:int;
      
      private var time:int;
      
      private var maxHeight:Number;
      
      private var visibleHeight:Number;
      
      private var heightSpeed:Number;
      
      private var x:Number;
      
      private var y:Number;
      
      private var z:Number;
      
      private var object:Object3D;
      
      private var container:Scene3DContainer;
      
      private var variationX:Number;
      
      private var variationY:Number;
      
      public function DamageUpEffect(param1:ObjectPool)
      {
         super(param1);
         this.damage = new Sprite3D(50,30);
      }
      
      public function init(param1:int, param2:Number, param3:Number, param4:Number, param5:Number, param6:Number, param7:Number, param8:Number, param9:Number, param10:Number, param11:Object3D, param12:TextureMaterial, param13:String) : void
      {
         this.delay = param1;
         this.damage.width = param2;
         this.damage.height = param3;
         this.damage.calculateBounds();
         this.damage.rotation = param4;
         this.maxHeight = param5;
         this.visibleHeight = param6;
         this.heightSpeed = param7;
         this.x = param8;
         this.y = param9;
         this.z = param10;
         this.object = param11;
         this.damage.material = param12;
         this.damage.softAttenuation = 150;
         this.damage.depthMapAlphaThreshold = 2;
         this.damage.shadowMapAlphaThreshold = 2;
         this.damage.useShadowMap = false;
         this.damage.useLight = false;
         this.damage.depthTest = false;
         this.damage.sorting = 1;
         this.damage.perspectiveScale = false;
         this.damage.blendMode = param13;
         this.damage.alpha = 1;
         this.time = 0;
      }
      
      public function addToContainer(param1:Scene3DContainer) : void
      {
         this.container = param1;
         param1.addChild(this.damage);
      }
      
      public function play(param1:int, param2:GameCamera) : Boolean
      {
         var _loc3_:Number = NaN;
         if(this.z >= this.maxHeight)
         {
            return false;
         }
         this.damage.x = this.object.x + this.x;
         this.damage.y = this.object.y + this.y;
         this.damage.z = this.object.z + this.z;
         this.time += param1;
         this.z += this.maxHeight * this.heightSpeed * param1 * 0.001;
         if(this.z < this.visibleHeight)
         {
            this.damage.alpha = this.z / this.visibleHeight;
         }
         else
         {
            _loc3_ = (this.z - this.visibleHeight) / (this.maxHeight - this.visibleHeight);
            this.damage.alpha = 1 - _loc3_ * _loc3_ * _loc3_ * _loc3_ * _loc3_ * _loc3_ * _loc3_ * _loc3_;
         }
         if(this.damage.alpha < 0)
         {
            this.damage.alpha = 0;
         }
         if(this.damage.alpha > 1)
         {
            this.damage.alpha = 1;
         }
         return true;
      }
      
      public function get owner() : ClientObject
      {
         return null;
      }
      
      public function destroy() : void
      {
         this.container.removeChild(this.damage);
         this.container = null;
         this.damage.material = null;
      }
      
      public function kill() : void
      {
         this.z = this.maxHeight;
         this.damage.alpha = 0;
      }
   }
}
