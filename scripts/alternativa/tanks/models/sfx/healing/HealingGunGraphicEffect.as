package alternativa.tanks.models.sfx.healing
{
   import alternativa.console.ConsoleVarFloat;
   import alternativa.engine3d.alternativa3d;
   import alternativa.engine3d.core.Object3D;
   import alternativa.engine3d.materials.Material;
   import alternativa.init.Main;
   import alternativa.math.Matrix4;
   import alternativa.math.Vector3;
   import alternativa.object.ClientObject;
   import alternativa.tanks.camera.GameCamera;
   import alternativa.tanks.engine3d.AnimatedSprite3D;
   import alternativa.tanks.engine3d.TextureAnimation;
   import alternativa.tanks.models.battlefield.BattlefieldModel;
   import alternativa.tanks.models.battlefield.IBattleField;
   import alternativa.tanks.models.battlefield.scene3dcontainer.Scene3DContainer;
   import alternativa.tanks.models.sfx.LightDataManager;
   import alternativa.tanks.models.sfx.MuzzlePositionProvider;
   import alternativa.tanks.models.sfx.OmniStreamLightEffect;
   import alternativa.tanks.models.sfx.TubeLightEffect;
   import alternativa.tanks.models.tank.TankData;
   import alternativa.tanks.services.objectpool.IObjectPoolService;
   import alternativa.tanks.sfx.IGraphicEffect;
   import alternativa.tanks.sfx.SFXUtils;
   import com.alternativaplatform.projects.tanks.client.warfare.models.tankparts.weapon.healing.IsisActionType;
   
   use namespace alternativa3d;
   
   public class HealingGunGraphicEffect implements IGraphicEffect
   {
      
      private static var endPositionOffset:ConsoleVarFloat = new ConsoleVarFloat("izida_end_offset",150,0,500);
      
      private static var turretMatrix:Matrix4 = new Matrix4();
      
      private static var targetMatrix:Matrix4 = new Matrix4();
      
      private static var endPosition:Vector3 = new Vector3();
      
      private static var startPosition:Vector3 = new Vector3();
      
      private static var direction:Vector3 = new Vector3();
      
      private static var cameraPosition:Vector3 = new Vector3();
      
      private static var objectPoolService:IObjectPoolService = IObjectPoolService(Main.osgi.getService(IObjectPoolService));
       
      
      private var bfModel:BattlefieldModel;
      
      private var container:Scene3DContainer;
      
      private var shaftPlane:Shaft;
      
      private var spark:AnimatedSprite3D;
      
      private var shaftEnd:AnimatedSprite3D;
      
      private var turret:Object3D;
      
      private var localSourcePosition:Vector3;
      
      private var targetObject:Object3D;
      
      private var localTargetPosition:Vector3;
      
      private var dead:Boolean;
      
      private var currentFrame:int;
      
      private var frameRate:Number = 0.015;
      
      private var time:int;
      
      private var _mode:IsisActionType;
      
      private var sfxData:HealingGunSFXData;
      
      private var sparkMaterials:TextureAnimation;
      
      private var shaftMaterials:Vector.<Material>;
      
      private var shaftEndMaterials:Vector.<Material>;
      
      private var shaftEndFrame:int;
      
      private var listener:IHealingGunEffectListener;
      
      private var lightEffect:OmniStreamLightEffect;
      
      private var beamEffect:TubeLightEffect;
      
      private var stateLightEffectCreatedFor:IsisActionType;
      
      private var targetTankData:TankData;
      
      public function HealingGunGraphicEffect(listener:IHealingGunEffectListener)
      {
         this.bfModel = Main.osgi.getService(IBattleField) as BattlefieldModel;
         this.localSourcePosition = new Vector3();
         this.localTargetPosition = new Vector3();
         super();
         this.listener = listener;
         this.shaftPlane = new Shaft();
         this.shaftPlane.init(100,100);
         this.spark = new AnimatedSprite3D(120,120);
         this.shaftEnd = new AnimatedSprite3D(200,200);
         this.spark.softAttenuation = 0;
         this.shaftEnd.softAttenuation = 0;
         this.shaftEnd.originY = 0.65;
      }
      
      public function createGraphics() : void
      {
         if(this.shaftPlane == null)
         {
            this.shaftPlane = new Shaft();
            this.shaftPlane.init(100,100);
         }
         if(this.spark == null)
         {
            this.spark = new AnimatedSprite3D(120,120);
            this.spark.softAttenuation = 0;
         }
         if(this.shaftEnd == null)
         {
            this.shaftEnd = new AnimatedSprite3D(200,200);
            this.shaftEnd.softAttenuation = 0;
            this.shaftEnd.originY = 0.65;
         }
      }
      
      public function init(mode:IsisActionType, sfxData:HealingGunSFXData, turret:Object3D, localSourcePosition:Vector3, targetData:TankData) : void
      {
         this.sfxData = sfxData;
         this.turret = turret;
         this._mode = mode;
         this.targetTankData = targetData;
         this.localSourcePosition.vCopy(localSourcePosition);
         this.dead = false;
         this.currentFrame = 0;
         this.time = 0;
         this.updateMode();
         this.createLightEffect(mode,targetData);
      }
      
      private function createLightEffect(param1:IsisActionType, targetData:TankData) : void
      {
         if(this.lightEffect != null)
         {
            this.stopLightEffect();
         }
         this.lightEffect = OmniStreamLightEffect(objectPoolService.objectPool.getObject(OmniStreamLightEffect));
         var _loc2_:MuzzlePositionProvider = MuzzlePositionProvider(objectPoolService.objectPool.getObject(MuzzlePositionProvider));
         _loc2_.init(this.turret,this.localSourcePosition);
         switch(param1)
         {
            case IsisActionType.DAMAGE:
               this.lightEffect.init(_loc2_,LightDataManager.getLightData(targetData.turret.id,"enemy_start"),LightDataManager.getLightData(targetData.turret.id,"enemy_loop"));
               break;
            case IsisActionType.HEAL:
               this.lightEffect.init(_loc2_,LightDataManager.getLightData(targetData.turret.id,"friendly_start"),LightDataManager.getLightData(targetData.turret.id,"friendly_loop"));
               break;
            default:
               this.lightEffect.init(_loc2_,LightDataManager.getLightData(targetData.turret.id,"idle_start"),LightDataManager.getLightData(targetData.turret.id,"idle_loop"));
         }
         this.stateLightEffectCreatedFor = param1;
         this.bfModel.addGraphicEffect(this.lightEffect);
      }
      
      public function set mode(value:IsisActionType) : void
      {
         if(this._mode == value)
         {
            return;
         }
         this._mode = value;
         this.updateMode();
      }
      
      public function setTargetParams(targetObject:Object3D, localTargetPosition:Vector3, targetTankData:TankData, mode:IsisActionType, showBeamLight:Boolean) : void
      {
         this.targetObject = targetObject;
         this.localTargetPosition.vCopy(localTargetPosition);
         this.createLightEffect(mode,targetTankData);
         if(showBeamLight)
         {
            this.createBeamLight(mode,targetTankData,localTargetPosition);
         }
      }
      
      public function get owner() : ClientObject
      {
         return null;
      }
      
      public function play(millis:int, camera:GameCamera) : Boolean
      {
         var len:int = 0;
         if(this.dead)
         {
            return false;
         }
         this.createGraphics();
         this.time += millis;
         turretMatrix.setMatrix(this.turret.x,this.turret.y,this.turret.z,this.turret.rotationX,this.turret.rotationY,this.turret.rotationZ);
         turretMatrix.transformVector(this.localSourcePosition,startPosition);
         this.spark.x = startPosition.x;
         this.spark.y = startPosition.y;
         this.spark.z = startPosition.z;
         var frame:int = int(this.time * this.frameRate);
         if(frame > this.currentFrame)
         {
            this.currentFrame = frame;
            this.spark.setFrameIndex(frame);
            if(this._mode == IsisActionType.DAMAGE || this._mode == IsisActionType.HEAL)
            {
               len = this.shaftEndMaterials.length;
               this.shaftEndFrame = (this.shaftEndFrame + 1) % len;
               if(this._mode == IsisActionType.HEAL)
               {
                  this.shaftEnd.setFrameIndex(this.shaftEndFrame);
               }
               else
               {
                  this.shaftEnd.setFrameIndex(int(len - this.shaftEndFrame - 1));
               }
            }
         }
         if(this._mode == IsisActionType.DAMAGE || this._mode == IsisActionType.HEAL)
         {
            this.updateShaft(camera);
         }
         return true;
      }
      
      public function addToContainer(container:Scene3DContainer) : void
      {
         this.container = container;
         this.updateMode();
      }
      
      public function destroy() : void
      {
         if(this.shaftPlane != null)
         {
            this.shaftPlane.removeFromParent();
         }
         if(this.shaftEnd != null)
         {
            this.shaftEnd.removeFromParent();
         }
         if(this.spark != null)
         {
            this.spark.removeFromParent();
         }
         this.container = null;
         this.shaftPlane.setMaterialToAllFaces(null);
         this.lightEffect.stop();
         if(this.beamEffect != null)
         {
            this.beamEffect.kill();
         }
         this.lightEffect = null;
         this.beamEffect = null;
         this.sfxData = null;
         this.sparkMaterials = null;
         this.shaftMaterials = this.shaftEndMaterials = null;
         this.turret = this.targetObject = null;
         this.listener.onEffectDestroyed(this);
      }
      
      public function kill() : void
      {
         this.dead = true;
      }
      
      private function updateShaft(camera:GameCamera) : void
      {
         this.shaftPlane.setMaterialToAllFaces(this.getRandomFrame(this.shaftMaterials));
         targetMatrix.setMatrix(this.targetObject.x,this.targetObject.y,this.targetObject.z,this.targetObject.rotationX,this.targetObject.rotationY,this.targetObject.rotationZ);
         targetMatrix.transformVector(this.localTargetPosition,endPosition);
         direction.vDiff(endPosition,startPosition);
         var beamLength:Number = direction.vLength() - endPositionOffset.value;
         if(beamLength < 0)
         {
            beamLength = 10;
         }
         this.shaftPlane.length = beamLength;
         direction.vNormalize();
         endPosition.x = startPosition.x + beamLength * direction.x;
         endPosition.y = startPosition.y + beamLength * direction.y;
         endPosition.z = startPosition.z + beamLength * direction.z;
         this.shaftEnd.x = endPosition.x;
         this.shaftEnd.y = endPosition.y;
         this.shaftEnd.z = endPosition.z;
         cameraPosition.x = camera.x;
         cameraPosition.y = camera.y;
         cameraPosition.z = camera.z;
         SFXUtils.alignObjectPlaneToView(this.shaftPlane,startPosition,direction,cameraPosition);
      }
      
      private function createBeamLight(param1:IsisActionType, param2:TankData, param3:Vector3) : void
      {
         if(this.beamEffect != null)
         {
            this.beamEffect.kill();
            this.beamEffect = null;
         }
         if(param1 == IsisActionType.IDLE)
         {
            return;
         }
         var _loc4_:MuzzlePositionProvider = MuzzlePositionProvider(objectPoolService.objectPool.getObject(MuzzlePositionProvider));
         var _loc5_:MuzzlePositionProvider = MuzzlePositionProvider(objectPoolService.objectPool.getObject(MuzzlePositionProvider));
         _loc4_.init(this.turret,this.localSourcePosition);
         _loc5_.init(this.targetObject,this.localTargetPosition);
         this.beamEffect = TubeLightEffect(objectPoolService.objectPool.getObject(TubeLightEffect));
         switch(param1)
         {
            case IsisActionType.DAMAGE:
               this.beamEffect.init(_loc4_,_loc5_,LightDataManager.getLightData(param2.turret.id,"enemy_beam"),true);
               break;
            case IsisActionType.HEAL:
               this.beamEffect.init(_loc4_,_loc5_,LightDataManager.getLightData(param2.turret.id,"friendly_beam"),true);
         }
         this.bfModel.addGraphicEffect(this.beamEffect);
      }
      
      private function stopLightEffect() : void
      {
         this.lightEffect.stop();
         this.lightEffect = null;
      }
      
      private function updateMode() : void
      {
         if(this.container == null)
         {
            return;
         }
         switch(this._mode)
         {
            case IsisActionType.IDLE:
               this.setIdleMode();
               break;
            case IsisActionType.HEAL:
               this.setHealMode();
               break;
            case IsisActionType.DAMAGE:
               this.setDamageMode();
         }
      }
      
      private function setIdleMode() : void
      {
         this.createGraphics();
         this.shaftPlane.removeFromParent();
         this.shaftEnd.removeFromParent();
         if(this.spark.parent == null)
         {
            this.container.addChild(this.spark);
         }
         this.sparkMaterials = this.sfxData.idleSparkData;
         this.spark.setAnimationData(this.sfxData.idleSparkData);
         this.spark.setFrameIndex(0);
      }
      
      private function setHealMode() : void
      {
         this.createGraphics();
         if(this.shaftPlane.parent == null)
         {
            this.container.addChild(this.shaftPlane);
            this.container.addChild(this.shaftEnd);
            this.shaftMaterials = this.sfxData.healShaftMaterials;
            this.shaftPlane.material = this.shaftMaterials[0];
            this.shaftEndMaterials = this.sfxData.healShaftEndMaterials;
            this.shaftEnd.setAnimationData(this.sfxData.healShaftEndData);
            this.shaftEnd.setFrameIndex(0);
         }
         if(this.spark.parent == null)
         {
            this.container.addChild(this.spark);
         }
         this.sparkMaterials = this.sfxData.healSparkData;
         this.spark.setAnimationData(this.sfxData.healSparkData);
         this.spark.setFrameIndex(0);
      }
      
      private function setDamageMode() : void
      {
         this.createGraphics();
         if(this.shaftPlane.parent == null)
         {
            this.container.addChild(this.shaftPlane);
            this.container.addChild(this.shaftEnd);
            this.shaftMaterials = this.sfxData.damageShaftMaterials;
            this.shaftPlane.material = this.shaftMaterials[0];
            this.shaftEndMaterials = this.sfxData.damageShaftEndMaterials;
            this.shaftEnd.setAnimationData(this.sfxData.damageShaftEndData);
            this.shaftEnd.setFrameIndex(0);
         }
         if(this.spark.parent == null)
         {
            this.container.addChild(this.spark);
         }
         this.sparkMaterials = this.sfxData.damageSparkData;
         this.spark.setAnimationData(this.sfxData.damageSparkData);
         this.spark.setFrameIndex(0);
      }
      
      private function getRandomFrame(materials:Vector.<Material>) : Material
      {
         return materials[int(Math.random() * materials.length)];
      }
   }
}

import alternativa.engine3d.alternativa3d;
import alternativa.engine3d.core.Face;
import alternativa.engine3d.core.Sorting;
import alternativa.engine3d.core.Vertex;
import alternativa.engine3d.core.Wrapper;
import alternativa.engine3d.materials.Material;
import alternativa.engine3d.objects.Mesh;

use namespace alternativa3d;

class Shaft extends Mesh
{
    
   
   private var a:Vertex;
   
   private var b:Vertex;
   
   private var c:Vertex;
   
   private var d:Vertex;
   
   private var face:Face;
   
   function Shaft()
   {
      super();
      this.a = this.createVertex(-1,0,0,0,1);
      this.b = this.createVertex(1,0,0,1,1);
      this.c = this.createVertex(1,1,0,1,0);
      this.d = this.createVertex(-1,1,0,0,0);
      this.face = this.createQuad(this.a,this.b,this.c,this.d);
      calculateFacesNormals();
      sorting = Sorting.DYNAMIC_BSP;
      shadowMapAlphaThreshold = 2;
      depthMapAlphaThreshold = 2;
      useShadowMap = false;
      useLight = false;
   }
   
   public function set material(value:Material) : void
   {
      this.face.material = value;
   }
   
   public function init(width:Number, length:Number) : void
   {
      var hw:Number = width / 2;
      boundMinX = this.a.x = this.d.x = -hw;
      boundMaxX = this.b.x = this.c.x = hw;
      boundMinY = 0;
      boundMaxY = this.d.y = this.c.y = length;
      this.a.v = this.b.v = 1;
      boundMinZ = boundMaxZ = 0;
   }
   
   public function get length() : Number
   {
      return this.d.y;
   }
   
   public function set length(value:Number) : void
   {
      if(value < 10)
      {
         value = 10;
      }
      boundMaxY = this.d.y = this.c.y = value;
   }
   
   private function createVertex(x:Number, y:Number, z:Number, u:Number, v:Number) : Vertex
   {
      var newVertex:Vertex = new Vertex();
      newVertex.next = vertexList;
      vertexList = newVertex;
      newVertex.x = x;
      newVertex.y = y;
      newVertex.z = z;
      newVertex.u = u;
      newVertex.v = v;
      return newVertex;
   }
   
   private function createQuad(a:Vertex, b:Vertex, c:Vertex, d:Vertex) : Face
   {
      var newFace:Face = new Face();
      newFace.next = faceList;
      faceList = newFace;
      newFace.wrapper = new Wrapper();
      newFace.wrapper.vertex = a;
      newFace.wrapper.next = new Wrapper();
      newFace.wrapper.next.vertex = b;
      newFace.wrapper.next.next = new Wrapper();
      newFace.wrapper.next.next.vertex = c;
      newFace.wrapper.next.next.next = new Wrapper();
      newFace.wrapper.next.next.next.vertex = d;
      return newFace;
   }
   
   override public function destroy() : void
   {
      var buf:Vertex = null;
      var buf1:Face = null;
      this.a = null;
      this.b = null;
      this.c = null;
      this.d = null;
      this.face.destroy();
      this.face = null;
      if(vertexList != null)
      {
         while(vertexList.next != null)
         {
            buf = vertexList;
            vertexList = null;
            vertexList = buf.next;
         }
         vertexList = null;
      }
      if(faceList != null)
      {
         while(faceList.next != null)
         {
            buf1 = faceList;
            faceList.wrapper.vertex = null;
            faceList.wrapper = null;
            faceList = null;
            faceList = buf1.next;
         }
         faceList = null;
      }
      captureListeners = null;
      bubbleListeners = null;
   }
}
