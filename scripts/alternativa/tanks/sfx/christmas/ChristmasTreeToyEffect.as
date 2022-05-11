package alternativa.tanks.sfx.christmas
{
   import alternativa.engine3d.core.MipMapping;
   import alternativa.engine3d.lights.OmniLight;
   import alternativa.engine3d.materials.TextureMaterial;
   import alternativa.engine3d.objects.Sprite3D;
   import alternativa.math.Vector3;
   import alternativa.object.ClientObject;
   import alternativa.tanks.camera.GameCamera;
   import alternativa.tanks.models.battlefield.scene3dcontainer.Scene3DContainer;
   import alternativa.tanks.sfx.IGraphicEffect;
   import alternativa.tanks.sfx.Object3DPositionProvider;
   import alternativa.tanks.utils.objectpool.ObjectPool;
   import alternativa.tanks.utils.objectpool.PooledObject;
   import flash.display.BlendMode;
   
   public class ChristmasTreeToyEffect extends PooledObject implements IGraphicEffect
   {
      
      private static const SIZE:Number = 256;
      
      private static const RESOLUTION:Number = 2;
      
[Embed(source="1069.png")]
      private static const RedTexture:Class;
      
      private static const redMaterial:TextureMaterial = new TextureMaterial(new RedTexture().bitmapData,false,true,MipMapping.PER_PIXEL,RESOLUTION);
      
[Embed(source="835.png")]
      private static const GreenTexture:Class;
      
      private static const greenMaterial:TextureMaterial = new TextureMaterial(new GreenTexture().bitmapData,false,true,MipMapping.PER_PIXEL,RESOLUTION);
      
[Embed(source="1005.png")]
      private static const BlueTexture:Class;
      
      private static const blueMaterial:TextureMaterial = new TextureMaterial(new BlueTexture().bitmapData,false,true,MipMapping.PER_PIXEL,RESOLUTION);
      
[Embed(source="1075.png")]
      private static const OrangeTexture:Class;
      
      private static const orangeMaterial:TextureMaterial = new TextureMaterial(new OrangeTexture().bitmapData,false,true,MipMapping.PER_PIXEL,RESOLUTION);
      
      private static const NEAR_1:Number = 100;
      
      private static const NEAR_2:Number = 300;
      
      private static const FAR_1:Number = 500;
      
      private static const FAR_2:Number = 1000;
      
      private static const MIN_SCALE:Number = 0.3;
      
      private static const MAX_SCALE:Number = 1.3;
      
      private static const ROTATION_SPEED:Number = Math.PI / 2;
      
      private static const INTERVAL:Number = 3;
       
      
      private var sprite:Sprite3D;
      
      private var omni:OmniLight;
      
      private var container:Scene3DContainer;
      
      private var positionProvider:Object3DPositionProvider;
      
      private var alive:Boolean;
      
      private var time:Number;
      
      public function ChristmasTreeToyEffect(param1:ObjectPool)
      {
         this.omni = new OmniLight(0,0,0);
         super(param1);
      }
      
      public function addToContainer(container:Scene3DContainer) : void
      {
         this.container = container;
         container.addChild(this.sprite);
         container.addChild(this.omni);
      }
      
      public function init(param1:Sprite3D, param2:Object3DPositionProvider, param3:Vector3) : void
      {
         this.sprite = param1;
         this.positionProvider = param2;
         param1.width = SIZE;
         param1.height = SIZE;
         param1.originX = 0.5;
         param1.originY = 0.5;
         param1.softAttenuation = 50;
         param1.useLight = false;
         param1.useShadowMap = false;
         param1.shadowMapAlphaThreshold = 2;
         param1.depthMapAlphaThreshold = 2;
         param1.blendMode = BlendMode.ADD;
         if(param1.name.indexOf("1") >= 0)
         {
            param1.material = redMaterial;
            this.omni.color = 16727074;
         }
         else if(param1.name.indexOf("2") >= 0)
         {
            param1.material = greenMaterial;
            this.omni.color = 6356736;
         }
         else if(param1.name.indexOf("3") >= 0)
         {
            param1.material = blueMaterial;
            this.omni.color = 34047;
         }
         else if(param1.name.indexOf("4") >= 0)
         {
            param1.material = orangeMaterial;
            this.omni.color = 16771584;
         }
         this.omni.intensity = 0.7;
         this.omni.attenuationBegin = NEAR_2;
         this.omni.attenuationEnd = FAR_2;
         this.omni.calculateBounds();
         var _loc5_:Number = param1.x - param3.x;
         var _loc6_:Number = param1.y - param3.y;
         var _loc7_:Number = Math.sqrt(_loc5_ * _loc5_ + _loc6_ * _loc6_);
         this.omni.x = param1.x + _loc5_ * 200 / _loc7_;
         this.omni.y = param1.y + _loc6_ * 200 / _loc7_;
         this.omni.z = param1.z + 200 / 2;
         this.time = Math.random() * INTERVAL;
         this.alive = true;
      }
      
      public function play(param1:int, param2:GameCamera) : Boolean
      {
         var _loc3_:Number = NaN;
         if(!this.alive)
         {
            return false;
         }
         this.positionProvider.updateObjectPosition(this.sprite,param2,param1);
         _loc3_ = param1 / 1000;
         this.time += _loc3_;
         this.time %= INTERVAL;
         var _loc4_:Number = Math.sin(Math.PI * 2 * this.time / INTERVAL) * 0.5 + 0.5;
         var _loc5_:Number = MIN_SCALE + (MAX_SCALE - MIN_SCALE) * _loc4_;
         this.sprite.scaleX = _loc5_;
         this.sprite.scaleY = _loc5_;
         this.sprite.scaleZ = _loc5_;
         this.sprite.rotation += ROTATION_SPEED * _loc3_ * _loc4_;
         this.omni.attenuationBegin = NEAR_1 + (NEAR_2 - NEAR_1) * _loc4_;
         this.omni.attenuationEnd = FAR_1 + (FAR_2 - FAR_1) * _loc4_;
         return true;
      }
      
      public function destroy() : void
      {
         this.container.removeChild(this.sprite);
         this.container.removeChild(this.omni);
         this.sprite = null;
         this.container = null;
         this.positionProvider.destroy();
         this.positionProvider = null;
         super.storeInPool();
      }
      
      public function kill() : void
      {
         this.alive = false;
      }
      
      public function get owner() : ClientObject
      {
         return null;
      }
   }
}
