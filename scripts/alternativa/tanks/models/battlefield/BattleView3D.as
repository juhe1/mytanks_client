package alternativa.tanks.models.battlefield
{
   import alternativa.engine3d.alternativa3d;
   import alternativa.engine3d.containers.KDContainer;
   import alternativa.engine3d.core.Light3D;
   import alternativa.engine3d.core.Object3D;
   import alternativa.engine3d.core.Object3DContainer;
   import alternativa.engine3d.core.Shadow;
   import alternativa.engine3d.core.View;
   import alternativa.engine3d.materials.TextureMaterial;
   import alternativa.engine3d.objects.Decal;
   import alternativa.init.Main;
   import alternativa.math.Vector3;
   import alternativa.physics.collision.ICollisionDetector;
   import alternativa.tanks.camera.GameCamera;
   import alternativa.tanks.display.AxisIndicator;
   import alternativa.tanks.models.battlefield.decals.DecalFactory;
   import alternativa.tanks.models.battlefield.decals.FadingDecalsRenderer;
   import alternativa.tanks.models.battlefield.decals.Queue;
   import alternativa.tanks.models.battlefield.decals.RotationState;
   import alternativa.tanks.models.battlefield.scene3dcontainer.Object3DContainerProxy;
   import alternativa.tanks.models.battlefield.scene3dcontainer.Scene3DContainer;
   import flash.display.Sprite;
   import flash.display.StageQuality;
   import flash.geom.Point;
   import flash.utils.Dictionary;
   
   use namespace alternativa3d;
   
   public class BattleView3D extends Sprite
   {
      
      private static const MAX_TEMPORARY_DECALS:int = 10;
      
      private static const DECAL_FADING_TIME_MS:int = 20000;
      
      public static const MAX_SCREEN_SIZE:int = 10;
       
      
      public var camera:GameCamera;
      
      private var rootContainer:Object3DContainer;
      
      private var skyboxContainer:Object3DContainer;
      
      private var mainContainer:Object3DContainer;
      
      private var frontContainer:Object3DContainer;
      
      private var mapContainer:Object3DContainer;
      
      private var mapContainerProxy:Object3DContainerProxy;
      
      private var frontContainerProxy:Object3DContainerProxy;
      
      private var _showAxisIndicator:Boolean;
      
      private var axisIndicator:AxisIndicator;
      
      private var decalFactory:DecalFactory;
      
      private const temporaryDecals:Queue = new Queue();
      
      private const allDecals:Dictionary = new Dictionary();
      
      private var fadingDecalRenderer:FadingDecalsRenderer;
      
      public var overlay:Sprite;
      
      private const BG_COLOR:uint = 10066176;
      
      private var container:Point;
      
      public const shaftRaycastExcludedObjects:Dictionary = new Dictionary();
      
      private var ambientShadows:AmbientShadows;
      
      private const excludedObjects:Dictionary = new Dictionary();
      
      public function BattleView3D(showAxisIndicator:Boolean, collisionDetector:ICollisionDetector, bs:BattlefieldModel)
      {
         this.container = new Point();
         super();
         mouseEnabled = false;
         tabEnabled = false;
         focusRect = false;
         this.camera = new GameCamera();
         this.camera.nearClipping = 10;
         this.camera.farClipping = 50000;
         this.camera.view = new View(100,100);
         this.camera.view.hideLogo();
         this.camera.view.focusRect = false;
         this.camera.softTransparency = true;
         this.camera.softAttenuation = 130;
         this.camera.softTransparencyStrength = 1;
         this.camera.z += 10000;
         this.camera.rotationX = Math.PI;
         this.decalFactory = new DecalFactory(collisionDetector);
         this.fadingDecalRenderer = bs.fadingDecalRenderer;
         addChild(this.camera.view);
         this.mapContainerProxy = new Object3DContainerProxy();
         this.rootContainer = new Object3DContainer();
         this.rootContainer.addChild(this.skyboxContainer = new Object3DContainer());
         this.rootContainer.addChild(this.mainContainer = new Object3DContainer());
         this.rootContainer.addChild(this.frontContainer = new Object3DContainer());
         this.frontContainerProxy = new Object3DContainerProxy(this.frontContainer);
         this.rootContainer.addChild(this.camera);
         Main.stage.quality = StageQuality.HIGH;
         this.overlay = new Sprite();
         addChild(this.overlay);
         this.showAxisIndicator = false;
         this.ambientShadows = new AmbientShadows(this.camera);
      }
      
      public function addObjectToExclusion(param1:Object3D) : void
      {
         this.excludedObjects[param1] = true;
      }
      
      public function removeObjectFromExclusion(param1:Object3D) : void
      {
         delete this.excludedObjects[param1];
      }
      
      public function getExcludedObjects() : Dictionary
      {
         return this.excludedObjects;
      }
      
      public function enableAmbientShadows(param1:Boolean) : void
      {
         if(param1)
         {
            this.ambientShadows.enable();
         }
         else
         {
            this.ambientShadows.disable();
         }
      }
      
      public function addAmbientShadow(param1:Shadow) : void
      {
         this.ambientShadows.add(param1);
      }
      
      public function removeAmbientShadow(param1:Shadow) : void
      {
         this.ambientShadows.remove(param1);
      }
      
      public function addDecal(param1:Vector3, param2:Vector3, param3:Number, param4:TextureMaterial, param5:RotationState = null, param6:Boolean = false) : void
      {
         var _loc6_:Decal = this.createDecal(param1,param2,param3,param4,param5);
         if(_loc6_ != null && !param6)
         {
            this.temporaryDecals.put(_loc6_);
            if(this.temporaryDecals.getSize() > MAX_TEMPORARY_DECALS)
            {
               this.fadingDecalRenderer.add(this.temporaryDecals.pop());
            }
         }
      }
      
      private function createDecal(param1:Vector3, param2:Vector3, param3:Number, param4:TextureMaterial, param5:RotationState = null) : Decal
      {
         var _loc6_:Decal = null;
         if(param5 == null)
         {
            param5 = RotationState.USE_RANDOM_ROTATION;
         }
         _loc6_ = this.decalFactory.createDecal(param1,param2,param3,param4,KDContainer(this._mapContainer),param5);
         KDContainer(this._mapContainer).addChildAt(_loc6_,0);
         this.allDecals[_loc6_] = true;
         return _loc6_;
      }
      
      public function removeDecal(param1:Decal) : void
      {
         if(param1 != null)
         {
            KDContainer(this._mapContainer).removeChild(param1);
            delete this.allDecals[param1];
         }
      }
      
      public function enableSoftParticles() : void
      {
         this.camera.softTransparency = true;
      }
      
      public function disableSoftParticles() : void
      {
         this.camera.softTransparency = false;
      }
      
      public function enableFog() : void
      {
         this.camera.fogNear = 5000;
         this.camera.fogFar = 10000;
         this.camera.fogStrength = 1;
         this.camera.fogAlpha = 0.35;
      }
      
      public function disableFog() : void
      {
         this.camera.fogStrength = 0;
      }
      
      public function set showAxisIndicator(value:Boolean) : void
      {
         if(this._showAxisIndicator == value)
         {
            return;
         }
         this._showAxisIndicator = value;
         if(value)
         {
            this.axisIndicator = new AxisIndicator(50);
            addChild(this.axisIndicator);
         }
         else
         {
            removeChild(this.axisIndicator);
            this.axisIndicator = null;
         }
      }
      
      public function resize(w:Number, h:Number) : void
      {
         this.camera.view.width = w;
         this.camera.view.height = h;
         if(this._showAxisIndicator)
         {
            this.axisIndicator.y = (h + this.camera.view.height >> 1) - 2 * this.axisIndicator.size;
         }
         this.camera.updateFov();
         this.container.x = this.stage.stageWidth - this.camera.view.width >> 1;
         this.container.y = this.stage.stageHeight - this.camera.view.height >> 1;
      }
      
      public function getX() : Number
      {
         return this.container.x;
      }
      
      public function getY() : Number
      {
         return this.container.y;
      }
      
      public function update() : void
      {
         if(this._showAxisIndicator)
         {
            this.axisIndicator.update(this.camera);
         }
         this.camera.render();
      }
      
      public function get _mapContainer() : Object3DContainer
      {
         return this.mapContainer;
      }
      
      public function set _mapContainer(value:Object3DContainer) : void
      {
         if(this.mapContainer != null)
         {
            this.mainContainer.removeChild(this.mapContainer);
            this.mapContainer = null;
         }
         this.mapContainerProxy.setContainer(value);
         this.mapContainer = value;
         if(this.mapContainer != null)
         {
            this.mainContainer.addChild(this.mapContainer);
         }
         this.frontContainer.name = "FRONT CONTAINER";
         this.mapContainer.name = "MAP CONTAINER";
         this.mapContainer.mouseEnabled = true;
         this.mapContainer.mouseChildren = true;
      }
      
      public function initLights(lights:Vector.<Light3D>) : void
      {
         var l:Light3D = null;
         for each(l in lights)
         {
            this.skyboxContainer.addChild(l);
         }
      }
      
      public function clearContainers() : void
      {
         this.clear(this.rootContainer);
         this.clear(this.mapContainer);
         this.clear(this.skyboxContainer);
         this.clear(this.frontContainer);
      }
      
      private function clear(container:Object3DContainer) : void
      {
         while(container.numChildren > 0)
         {
            container.removeChildAt(0);
         }
      }
      
      public function addDynamicObject(object:Object3D) : void
      {
         if(this.mapContainer != null)
         {
            this.mapContainer.addChild(object);
            if(object.name != Object3DNames.STATIC && object.name != Object3DNames.TANK_PART)
            {
               this.shaftRaycastExcludedObjects[object] = true;
            }
         }
      }
      
      public function removeDynamicObject(object:Object3D) : void
      {
         if(this.mapContainer != null)
         {
            this.mapContainer.removeChild(object);
            if(object.name != Object3DNames.STATIC && object.name != Object3DNames.TANK_PART)
            {
               delete this.shaftRaycastExcludedObjects[object];
            }
         }
      }
      
      public function getFrontContainer() : Scene3DContainer
      {
         return this.frontContainerProxy;
      }
      
      public function getMapContainer() : Scene3DContainer
      {
         return this.mapContainerProxy;
      }
      
      public function setSkyBox(param1:Object3D) : void
      {
         if(this.skyboxContainer.numChildren > 0)
         {
            this.skyboxContainer.removeChildAt(0);
         }
         this.skyboxContainer.addChild(param1);
      }
   }
}
