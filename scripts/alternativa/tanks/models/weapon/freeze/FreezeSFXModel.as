package alternativa.tanks.models.weapon.freeze
{
   import alternativa.engine3d.core.Object3D;
   import alternativa.init.Main;
   import alternativa.math.Vector3;
   import alternativa.model.IModel;
   import alternativa.model.IObjectLoadListener;
   import alternativa.object.ClientObject;
   import alternativa.osgi.service.log.LogLevel;
   import alternativa.service.IModelService;
   import alternativa.service.Logger;
   import alternativa.tanks.engine3d.MaterialType;
   import alternativa.tanks.models.battlefield.BattlefieldModel;
   import alternativa.tanks.models.battlefield.IBattleField;
   import alternativa.tanks.models.sfx.CollisionObject3DPositionProvider;
   import alternativa.tanks.models.sfx.LightDataManager;
   import alternativa.tanks.models.sfx.MuzzlePositionProvider;
   import alternativa.tanks.models.sfx.OmniStreamLightEffect;
   import alternativa.tanks.models.sfx.colortransform.ColorTransformEntry;
   import alternativa.tanks.models.sfx.colortransform.IColorTransformModel;
   import alternativa.tanks.models.tank.TankData;
   import alternativa.tanks.models.weapon.common.WeaponCommonData;
   import alternativa.tanks.services.materialregistry.IMaterialRegistry;
   import alternativa.tanks.services.objectpool.IObjectPoolService;
   import alternativa.tanks.sfx.IGraphicEffect;
   import alternativa.tanks.sfx.ISound3DEffect;
   import alternativa.tanks.sfx.MobileSound3DEffect;
   import alternativa.tanks.sfx.Sound3D;
   import alternativa.tanks.sfx.SoundOptions;
   import com.alternativaplatform.projects.tanks.client.warfare.models.tankparts.weapon.freeze.FreezeSFXModelBase;
   import com.alternativaplatform.projects.tanks.client.warfare.models.tankparts.weapon.freeze.IFreezeSFXModelBase;
   import flash.display.BitmapData;
   import flash.utils.Dictionary;
   import scpacker.resource.ResourceType;
   import scpacker.resource.ResourceUtil;
   
   public class FreezeSFXModel extends FreezeSFXModelBase implements IFreezeSFXModelBase, IObjectLoadListener, IFreezeSFXModel
   {
      
      private static const MIPMAP_RESOLUTION:Number = 2;
      
      private static const SOUND_VOLUME:Number = 1;
      
      private static var materialRegistry:IMaterialRegistry;
      
      private static var objectPoolService:IObjectPoolService;
       
      
      private var battlefield:IBattleField;
      
      private var freezeModel:IFreezeModel;
      
      private var graphicEffects:Dictionary;
      
      private var soundEffects:Dictionary;
      
      private var bfModel:BattlefieldModel;
      
      private var muzzleLightEffect:OmniStreamLightEffect;
      
      private var lightEffect:OmniStreamLightEffect;
      
      public function FreezeSFXModel()
      {
         this.graphicEffects = new Dictionary();
         this.soundEffects = new Dictionary();
         this.bfModel = Main.osgi.getService(IBattleField) as BattlefieldModel;
         super();
         _interfaces.push(IModel,IObjectLoadListener,IFreezeSFXModel);
         materialRegistry = IMaterialRegistry(Main.osgi.getService(IMaterialRegistry));
         objectPoolService = IObjectPoolService(Main.osgi.getService(IObjectPoolService));
      }
      
      public function initObject(clientObject:ClientObject, particleSpeed:Number, particleTextureResourceId:String, planeTextureResourceId:String, shotSoundResourceId:String) : void
      {
         this.cacheInterfaces();
         var sfxData:FreezeSFXData = new FreezeSFXData();
         var particleTexture:BitmapData = ResourceUtil.getResource(ResourceType.IMAGE,particleTextureResourceId).bitmapData;
         sfxData.particleMaterials = materialRegistry.materialSequenceRegistry.getSequence(MaterialType.EFFECT,particleTexture,particleTexture.height,MIPMAP_RESOLUTION).materials;
         var planeTexture:BitmapData = ResourceUtil.getResource(ResourceType.IMAGE,planeTextureResourceId).bitmapData;
         sfxData.planeMaterials = materialRegistry.materialSequenceRegistry.getSequence(MaterialType.EFFECT,planeTexture,250,MIPMAP_RESOLUTION).materials;
         sfxData.particleSpeed = 100 * particleSpeed;
         sfxData.shotSound = ResourceUtil.getResource(ResourceType.SOUND,shotSoundResourceId).sound;
         clientObject.putParams(FreezeSFXModel,sfxData);
      }
      
      public function createEffects(tankData:TankData, weaponCommonData:WeaponCommonData) : void
      {
         var message:String = null;
         var sound3d:Sound3D = null;
         var soundEffect:MobileSound3DEffect = null;
         var sfxData:FreezeSFXData = this.getSFXData(tankData.turret);
         if(sfxData == null)
         {
            message = "SFX data not found";
            Logger.log(LogLevel.LOG_ERROR,message);
            throw new Error(message);
         }
         var freezeData:FreezeData = this.freezeModel.getFreezeData(tankData.turret);
         if(freezeData == null)
         {
            message = "Freeze data not found";
            Logger.log(LogLevel.LOG_ERROR,message);
            throw new Error(message);
         }
         var graphicEffect:FreezeGraphicEffect = FreezeGraphicEffect(objectPoolService.objectPool.getObject(FreezeGraphicEffect));
         graphicEffect.init(tankData,freezeData.damageAreaRange,freezeData.damageAreaConeAngle,sfxData.particleSpeed,weaponCommonData.muzzles[0],tankData.tank.skin.turretMesh,sfxData,this.battlefield.getBattlefieldData().collisionDetector);
         this.battlefield.addGraphicEffect(graphicEffect);
         this.createLightEffect(weaponCommonData.muzzles[0],tankData.tank.skin.turretMesh,tankData.turret);
         this.graphicEffects[tankData] = graphicEffect;
         if(sfxData.shotSound != null)
         {
            sound3d = Sound3D.create(sfxData.shotSound,SoundOptions.nearRadius,SoundOptions.farRadius,SoundOptions.farDelimiter,SOUND_VOLUME);
            soundEffect = MobileSound3DEffect(objectPoolService.objectPool.getObject(MobileSound3DEffect));
            soundEffect.init(null,sound3d,tankData.tank.skin.turretMesh,0,1);
            this.battlefield.addSound3DEffect(soundEffect);
            this.soundEffects[tankData] = soundEffect;
         }
      }
      
      public function createLightEffect(param1:Vector3, param2:Object3D, turretObject:ClientObject) : void
      {
         var _loc3_:MuzzlePositionProvider = null;
         var _loc4_:CollisionObject3DPositionProvider = null;
         if(this.muzzleLightEffect == null)
         {
            this.muzzleLightEffect = OmniStreamLightEffect(objectPoolService.objectPool.getObject(OmniStreamLightEffect));
            _loc3_ = MuzzlePositionProvider(objectPoolService.objectPool.getObject(MuzzlePositionProvider));
            _loc3_.init(param2,param1);
            this.muzzleLightEffect.init(_loc3_,LightDataManager.getLightDataMuzzle(turretObject.id),LightDataManager.getLightDataShot(turretObject.id));
            this.bfModel.addGraphicEffect(this.muzzleLightEffect);
         }
         if(this.lightEffect == null)
         {
            this.lightEffect = OmniStreamLightEffect(objectPoolService.objectPool.getObject(OmniStreamLightEffect));
            _loc4_ = CollisionObject3DPositionProvider(objectPoolService.objectPool.getObject(CollisionObject3DPositionProvider));
            _loc4_.init(param2,param1,this.bfModel.bfData.collisionDetector,1500);
            this.lightEffect.init(_loc4_,LightDataManager.getLightDataMuzzle(turretObject.id),LightDataManager.getLightDataShot(turretObject.id));
            this.bfModel.addGraphicEffect(this.lightEffect);
         }
      }
      
      public function destroyEffects(tankData:TankData) : void
      {
         var graphicEffect:IGraphicEffect = this.graphicEffects[tankData];
         if(graphicEffect != null)
         {
            delete this.graphicEffects[tankData];
            graphicEffect.kill();
            if(this.muzzleLightEffect != null)
            {
               this.muzzleLightEffect.stop();
               this.muzzleLightEffect = null;
            }
            if(this.lightEffect != null)
            {
               this.lightEffect.stop();
               this.lightEffect = null;
            }
         }
         var soundEffect:ISound3DEffect = this.soundEffects[tankData];
         if(soundEffect != null)
         {
            delete this.soundEffects[tankData];
            soundEffect.kill();
         }
      }
      
      public function objectLoaded(object:ClientObject) : void
      {
         var colorTransforms:Vector.<ColorTransformEntry> = null;
         var sfxData:FreezeSFXData = null;
         var modelService:IModelService = IModelService(Main.osgi.getService(IModelService));
         var colorTransformModel:IColorTransformModel = IColorTransformModel(modelService.getModelForObject(object,IColorTransformModel));
         if(colorTransformModel != null)
         {
            colorTransforms = colorTransformModel.getModelData(object);
            if(colorTransforms != null)
            {
               sfxData = this.getSFXData(object);
               sfxData.colorTransformPoints = colorTransforms;
            }
         }
      }
      
      public function objectUnloaded(object:ClientObject) : void
      {
      }
      
      private function cacheInterfaces() : void
      {
         var modelService:IModelService = null;
         if(this.battlefield == null)
         {
            modelService = IModelService(Main.osgi.getService(IModelService));
            this.battlefield = IBattleField(modelService.getModelsByInterface(IBattleField)[0]);
            this.freezeModel = IFreezeModel(modelService.getModelsByInterface(IFreezeModel)[0]);
         }
      }
      
      private function getSFXData(clientObject:ClientObject) : FreezeSFXData
      {
         return FreezeSFXData(clientObject.getParams(FreezeSFXModel));
      }
   }
}
