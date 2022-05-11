package alternativa.tanks.models.sfx.shoot.plasma
{
   import alternativa.engine3d.core.Camera3D;
   import alternativa.engine3d.core.Object3D;
   import alternativa.init.Main;
   import alternativa.math.Vector3;
   import alternativa.model.IModel;
   import alternativa.model.IObjectLoadListener;
   import alternativa.object.ClientObject;
   import alternativa.service.IModelService;
   import alternativa.tanks.engine3d.MaterialType;
   import alternativa.tanks.engine3d.TextureAnimation;
   import alternativa.tanks.models.battlefield.BattlefieldModel;
   import alternativa.tanks.models.battlefield.IBattleField;
   import alternativa.tanks.models.sfx.AnimatedLightEffect;
   import alternativa.tanks.models.sfx.LightDataManager;
   import alternativa.tanks.models.sfx.MuzzlePositionProvider;
   import alternativa.tanks.models.sfx.SpriteShotEffect;
   import alternativa.tanks.models.sfx.colortransform.ColorTransformEntry;
   import alternativa.tanks.models.sfx.colortransform.IColorTransformModel;
   import alternativa.tanks.models.sfx.shoot.ICommonShootSFX;
   import alternativa.tanks.models.weapon.plasma.PlasmaShot;
   import alternativa.tanks.services.materialregistry.IMaterialRegistry;
   import alternativa.tanks.services.objectpool.IObjectPoolService;
   import alternativa.tanks.sfx.AnimatedSpriteEffectNew;
   import alternativa.tanks.sfx.EffectsPair;
   import alternativa.tanks.sfx.Sound3D;
   import alternativa.tanks.sfx.Sound3DEffect;
   import alternativa.tanks.sfx.SoundOptions;
   import alternativa.tanks.sfx.StaticObject3DPositionProvider;
   import alternativa.tanks.utils.GraphicsUtils;
   import com.alternativaplatform.projects.tanks.client.warfare.models.sfx.shoot.plasma.IPlasmaShootSFXModelBase;
   import com.alternativaplatform.projects.tanks.client.warfare.models.sfx.shoot.plasma.PlasmaShootSFXModelBase;
   import flash.display.BitmapData;
   import flash.geom.ColorTransform;
   import scpacker.resource.ResourceType;
   import scpacker.resource.ResourceUtil;
   
   public class PlasmaSFXModel extends PlasmaShootSFXModelBase implements IPlasmaShootSFXModelBase, ICommonShootSFX, IPlasmaSFX, IObjectLoadListener
   {
      
      private static var materialRegistry:IMaterialRegistry;
      
      private static var objectPoolService:IObjectPoolService;
      
      private static var turretPosition:Vector3 = new Vector3();
      
      private static var bfModel:BattlefieldModel;
       
      
      public function PlasmaSFXModel()
      {
         super();
         _interfaces.push(IModel,IPlasmaShootSFXModelBase,ICommonShootSFX,IPlasmaSFX,IObjectLoadListener);
         materialRegistry = IMaterialRegistry(Main.osgi.getService(IMaterialRegistry));
         objectPoolService = IObjectPoolService(Main.osgi.getService(IObjectPoolService));
         bfModel = Main.osgi.getService(IBattleField) as BattlefieldModel;
      }
      
      public function initObject(clientObject:ClientObject, explosionSoundId:String, explosionTextureId:String, plasmaTextureId:String, shotSoundId:String, shotTextureId:String) : void
      {
         var data:PlasmaSFXData = new PlasmaSFXData();
         var flashTexture:BitmapData = ResourceUtil.getResource(ResourceType.IMAGE,shotTextureId).bitmapData;
         data.shotFlashMaterial = materialRegistry.textureMaterialRegistry.getMaterial(MaterialType.EFFECT,flashTexture,1,false);
         var plasmaTexture:BitmapData = ResourceUtil.getResource(ResourceType.IMAGE,plasmaTextureId).bitmapData;
         data.shotMaterials = materialRegistry.materialSequenceRegistry.getSequence(MaterialType.EFFECT,plasmaTexture,plasmaTexture.height,PlasmaShot.SIZE / plasmaTexture.height).materials;
         var explosionTexture:BitmapData = ResourceUtil.getResource(ResourceType.IMAGE,explosionTextureId).bitmapData;
         data.explosionMaterials = materialRegistry.materialSequenceRegistry.getSequence(MaterialType.EFFECT,explosionTexture,explosionTexture.height,3).materials;
         trace(flashTexture,plasmaTexture,explosionTexture);
         data.shotSound = ResourceUtil.getResource(ResourceType.SOUND,shotSoundId).sound;
         data.explosionSound = ResourceUtil.getResource(ResourceType.SOUND,explosionSoundId).sound;
         data.explosionData = GraphicsUtils.getTextureAnimation(null,explosionTexture,200,200);
         data.explosionData.fps = 30;
         data.shotData = GraphicsUtils.getTextureAnimation(null,plasmaTexture,150,150);
         data.shotData.fps = 20;
         clientObject.putParams(PlasmaSFXModel,data);
      }
      
      public function createShotEffects(clientObject:ClientObject, muzzleLocalPos:Vector3, turret:Object3D, camera:Camera3D) : EffectsPair
      {
         var sound:Sound3D = null;
         var data:PlasmaSFXData = this.getPlasmaSFXData(clientObject);
         var shotEffect:SpriteShotEffect = SpriteShotEffect(objectPoolService.objectPool.getObject(SpriteShotEffect));
         shotEffect.init(data.shotFlashMaterial,muzzleLocalPos,turret,10,120,50,50,data.colorTransform);
         var soundEffect:Sound3DEffect = null;
         if(data.shotSound != null)
         {
            sound = Sound3D.create(data.shotSound,SoundOptions.nearRadius,SoundOptions.farRadius,SoundOptions.farDelimiter,0.8);
            turretPosition.x = turret.x;
            turretPosition.y = turret.y;
            turretPosition.z = turret.z;
            soundEffect = Sound3DEffect.create(objectPoolService.objectPool,null,turretPosition,sound);
         }
         this.createMuzzleLightEffect(muzzleLocalPos,turret,clientObject);
         return new EffectsPair(shotEffect,soundEffect);
      }
      
      private function createMuzzleLightEffect(param1:Vector3, param2:Object3D, turretObject:ClientObject) : void
      {
         var _loc3_:AnimatedLightEffect = AnimatedLightEffect(objectPoolService.objectPool.getObject(AnimatedLightEffect));
         var _loc4_:MuzzlePositionProvider = MuzzlePositionProvider(objectPoolService.objectPool.getObject(MuzzlePositionProvider));
         _loc4_.init(param2,param1);
         _loc3_.init(_loc4_,LightDataManager.getLightDataExplosion(turretObject.id));
         bfModel.addGraphicEffect(_loc3_);
      }
      
      public function createExplosionEffects(clientObject:ClientObject, pos:Vector3, camera:Camera3D, weakeningCoeff:Number) : EffectsPair
      {
         var data:PlasmaSFXData = this.getPlasmaSFXData(clientObject);
         var size:Number = 300 * (1 + weakeningCoeff);
         var explosionEffect:AnimatedSpriteEffectNew = AnimatedSpriteEffectNew(objectPoolService.objectPool.getObject(AnimatedSpriteEffectNew));
         var animation:TextureAnimation = data.explosionData;
         var position:StaticObject3DPositionProvider = StaticObject3DPositionProvider(objectPoolService.objectPool.getObject(StaticObject3DPositionProvider));
         position.init(pos,50);
         explosionEffect.init(size,size,animation,6.28 * Math.random(),position);
         this.createExplosionLightEffect(pos,clientObject);
         return new EffectsPair(explosionEffect,null);
      }
      
      private function createExplosionLightEffect(param1:Vector3, turretObject:ClientObject) : void
      {
         var _loc2_:AnimatedLightEffect = AnimatedLightEffect(objectPoolService.objectPool.getObject(AnimatedLightEffect));
         var _loc3_:StaticObject3DPositionProvider = StaticObject3DPositionProvider(objectPoolService.objectPool.getObject(StaticObject3DPositionProvider));
         _loc3_.init(param1,110);
         _loc2_.init(_loc3_,LightDataManager.getLightDataExplosion(turretObject.id));
         bfModel.addGraphicEffect(_loc2_);
      }
      
      public function getPlasmaSFXData(clientObject:ClientObject) : PlasmaSFXData
      {
         return PlasmaSFXData(clientObject.getParams(PlasmaSFXModel));
      }
      
      public function objectLoaded(clientObject:ClientObject) : void
      {
         var sfxData:PlasmaSFXData = null;
         var colorTransforms:Vector.<ColorTransformEntry> = null;
         var ctStruct:ColorTransformEntry = null;
         var modelService:IModelService = IModelService(Main.osgi.getService(IModelService));
         var colorTransformModel:IColorTransformModel = IColorTransformModel(modelService.getModelForObject(clientObject,IColorTransformModel));
         if(colorTransformModel != null)
         {
            sfxData = this.getPlasmaSFXData(clientObject);
            colorTransforms = colorTransformModel.getModelData(clientObject);
            ctStruct = colorTransforms[0];
            sfxData.colorTransform = new ColorTransform(ctStruct.redMultiplier,ctStruct.greenMultiplier,ctStruct.blueMultiplier,ctStruct.alphaMultiplier,ctStruct.redOffset,ctStruct.greenOffset,ctStruct.blueOffset,ctStruct.alphaOffset);
         }
      }
      
      public function objectUnloaded(clientObject:ClientObject) : void
      {
      }
   }
}
