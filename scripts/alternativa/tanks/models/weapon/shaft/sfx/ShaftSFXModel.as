package alternativa.tanks.models.weapon.shaft.sfx
{
   import alternativa.engine3d.core.Object3D;
   import alternativa.engine3d.materials.TextureMaterial;
   import alternativa.init.Main;
   import alternativa.math.Vector3;
   import alternativa.object.ClientObject;
   import alternativa.tanks.models.battlefield.BattlefieldModel;
   import alternativa.tanks.models.battlefield.IBattleField;
   import alternativa.tanks.models.sfx.MuzzlePositionProvider;
   import alternativa.tanks.models.sfx.shoot.shaft.ShaftTrailEffect;
   import alternativa.tanks.models.sfx.shoot.shaft.TrailEffect1;
   import alternativa.tanks.models.sfx.shoot.shaft.TrailEffect2;
   import alternativa.tanks.services.objectpool.IObjectPoolService;
   import alternativa.tanks.sfx.AnimatedSpriteEffectNew;
   import alternativa.tanks.sfx.MobileSound3DEffect;
   import alternativa.tanks.sfx.Sound3D;
   import alternativa.tanks.sfx.Sound3DEffect;
   import alternativa.tanks.sfx.SoundOptions;
   import alternativa.tanks.sfx.StaticObject3DPositionProvider;
   import alternativa.tanks.utils.GraphicsUtils;
   import alternativa.tanks.utils.objectpool.ObjectPool;
   import flash.display.BitmapData;
   import flash.media.Sound;
   import scpacker.gui.AlertBugWindow;
   import scpacker.resource.ResourceType;
   import scpacker.resource.ResourceUtil;
   
   public class ShaftSFXModel implements ShaftSFX
   {
      
      private static const ZOOM_MODE_SOUND_VOLUME:Number = 0.7;
      
      public static const MUZZLE_FLASH_SIZE:Number = 200;
      
      public static const EXPLOSION_WIDTH:Number = 250;
      
      private static const EXPLOSION_OFFSET_TO_CAMERA:Number = 110;
      
      private static const EXPLOSION_SOUND_VOLUME:Number = 0.8;
      
      private static const CHARGING_SOUND_FADE_TIME_MS:int = 1000;
      
      private static const vectorToHitPoint:Vector3 = new Vector3();
      
      private static const TRAIL_DURATION:int = 1000;
      
      private static var objectPoolService:IObjectPoolService;
       
      
      private const SHOT_SOUND_VOLUME:Number = 0.4;
      
      private var battlefieldModel:BattlefieldModel;
      
      public function ShaftSFXModel()
      {
         super();
         objectPoolService = IObjectPoolService(Main.osgi.getService(IObjectPoolService));
         this.battlefieldModel = Main.osgi.getService(IBattleField) as BattlefieldModel;
      }
      
      public function initObject(clientObject:ClientObject, manualModeEffect:String, targetingSound:String, explosionId:String, trailTexture:String, muzzleFlashTexture:String) : void
      {
         var alert:AlertBugWindow = null;
         var sfxData:ShaftSFXData = null;
         var trailBitmapData:BitmapData = null;
         var trailMaterial:TextureMaterial = null;
         var exlpBitmap:BitmapData = null;
         var muzzleFlash:BitmapData = null;
         alert = null;
         try
         {
            sfxData = new ShaftSFXData();
            sfxData.zoomModeSound = ResourceUtil.getResource(ResourceType.SOUND,manualModeEffect).sound as Sound;
            sfxData.targetingSound = ResourceUtil.getResource(ResourceType.SOUND,targetingSound).sound as Sound;
            sfxData.shotSound = ResourceUtil.getResource(ResourceType.SOUND,"shaft_shot").sound as Sound;
            sfxData.explosionSound = ResourceUtil.getResource(ResourceType.SOUND,"shaft_explosion_sound").sound as Sound;
            trailBitmapData = ResourceUtil.getResource(ResourceType.IMAGE,trailTexture).bitmapData as BitmapData;
            trailMaterial = new TextureMaterial(trailBitmapData);
            sfxData.trailMaterial = trailMaterial;
            exlpBitmap = ResourceUtil.getResource(ResourceType.IMAGE,explosionId).bitmapData as BitmapData;
            sfxData.explosionAnimation = GraphicsUtils.getTextureAnimation(null,exlpBitmap,200,200);
            sfxData.explosionAnimation.fps = 30;
            muzzleFlash = ResourceUtil.getResource(ResourceType.IMAGE,muzzleFlashTexture).bitmapData as BitmapData;
            sfxData.muzzleFlashAnimation = GraphicsUtils.getTextureAnimation(null,muzzleFlash,60,53);
            sfxData.muzzleFlashAnimation.fps = 4;
            clientObject.putParams(ShaftSFXModel,sfxData);
         }
         catch(e:Error)
         {
            alert = new AlertBugWindow();
            alert.text = "Произошла ошибка: " + e.getStackTrace();
            Main.stage.addChild(alert);
         }
      }
      
      public function createManualModeEffects(turretObj:ClientObject, clientObject:ClientObject, obj:Object3D) : MobileSound3DEffect
      {
         var sfxData:ShaftSFXData = turretObj.getParams(ShaftSFXModel) as ShaftSFXData;
         var soundData:ShaftSFXUserData = clientObject.getParams(ShaftSFXUserData) != null ? clientObject.getParams(ShaftSFXUserData) as ShaftSFXUserData : new ShaftSFXUserData();
         soundData.manualModeEffect = MobileSound3DEffect(objectPoolService.objectPool.getObject(MobileSound3DEffect));
         var sound:Sound3D = Sound3D.create(sfxData.zoomModeSound,SoundOptions.nearRadius,SoundOptions.farRadius,SoundOptions.farDelimiter,ZOOM_MODE_SOUND_VOLUME);
         soundData.manualModeEffect.init(null,sound,obj,0,9999);
         this.battlefieldModel.addSound3DEffect(soundData.manualModeEffect);
         clientObject.putParams(ShaftSFXUserData,soundData);
         return soundData.manualModeEffect;
      }
      
      public function fadeChargingEffect(turretObj:ClientObject, clientObject:ClientObject) : void
      {
         var sfxData:ShaftSFXData = turretObj.getParams(ShaftSFXModel) as ShaftSFXData;
         var soundData:ShaftSFXUserData = clientObject.getParams(ShaftSFXUserData) != null ? clientObject.getParams(ShaftSFXUserData) as ShaftSFXUserData : new ShaftSFXUserData();
         if(soundData.manualModeEffect != null)
         {
            soundData.manualModeEffect.fade(CHARGING_SOUND_FADE_TIME_MS);
         }
      }
      
      public function createShotSoundEffect(turretObj:ClientObject, owner:ClientObject, param1:Vector3) : void
      {
         var sfxData:ShaftSFXData = turretObj.getParams(ShaftSFXModel) as ShaftSFXData;
         var _loc2_:Sound3D = Sound3D.create(sfxData.shotSound,1000,5000,5,this.SHOT_SOUND_VOLUME);
         var _loc3_:Sound3DEffect = Sound3DEffect.create(objectPoolService.objectPool,owner,param1,_loc2_);
         this.battlefieldModel.addSound3DEffect(_loc3_);
      }
      
      public function createMuzzleFlashEffect(turretObj:ClientObject, param1:Vector3, param2:Object3D) : void
      {
         var sfxData:ShaftSFXData = turretObj.getParams(ShaftSFXModel) as ShaftSFXData;
         var pool:ObjectPool = this.battlefieldModel.getObjectPool();
         var pos:MuzzlePositionProvider = MuzzlePositionProvider(pool.getObject(MuzzlePositionProvider));
         pos.init(param2,param1,10);
         var animSprite:AnimatedSpriteEffectNew = AnimatedSpriteEffectNew(pool.getObject(AnimatedSpriteEffectNew));
         animSprite.init(70,63,sfxData.muzzleFlashAnimation,0,pos);
         this.battlefieldModel.addGraphicEffect(animSprite);
      }
      
      public function stopManualSound(clientObject:ClientObject) : void
      {
         var soundData:ShaftSFXUserData = clientObject.getParams(ShaftSFXUserData) == null ? null : clientObject.getParams(ShaftSFXUserData) as ShaftSFXUserData;
         if(soundData == null)
         {
            soundData = new ShaftSFXUserData();
            clientObject.putParams(ShaftSFXUserData,soundData);
         }
         if(soundData.manualModeEffect != null)
         {
            soundData.manualModeEffect.kill();
         }
      }
      
      public function playTargetingSound(turretObj:ClientObject, clientObject:ClientObject, play:Boolean) : void
      {
         var alert:AlertBugWindow = null;
         var sfxData:ShaftSFXData = null;
         var soundData:ShaftSFXUserData = null;
         alert = null;
         try
         {
            sfxData = turretObj.getParams(ShaftSFXModel) as ShaftSFXData;
            soundData = clientObject.getParams(ShaftSFXUserData) == null ? null : clientObject.getParams(ShaftSFXUserData) as ShaftSFXUserData;
            if(soundData == null)
            {
               soundData = new ShaftSFXUserData();
               clientObject.putParams(ShaftSFXUserData,soundData);
            }
            if(play)
            {
               if(soundData.turretSoundChannel == null)
               {
                  soundData.turretSoundChannel = this.battlefieldModel.soundManager.playSound(sfxData.targetingSound,0,9999);
               }
            }
            else if(soundData.turretSoundChannel != null)
            {
               this.battlefieldModel.soundManager.stopSound(soundData.turretSoundChannel);
               soundData.turretSoundChannel = null;
            }
         }
         catch(e:Error)
         {
            alert = new AlertBugWindow();
            alert.text = "Произошла ошибка: " + e.getStackTrace();
            Main.stage.addChild(alert);
         }
      }
      
      public function createHitPointsGraphicEffects(turretObject:ClientObject, owner:ClientObject, pos1:Vector3, pos2:Vector3, param3:Vector3, param4:Vector3, param5:Vector3) : void
      {
         var sfxData:ShaftSFXData = turretObject.getParams(ShaftSFXModel) as ShaftSFXData;
         if(pos1 != null)
         {
            this.createEffectsForPoint(turretObject,owner,sfxData,pos1,param3,param4,param5,false);
         }
         if(pos2 != null)
         {
            this.createEffectsForPoint(turretObject,owner,sfxData,pos2,param3,param4,param5,true);
         }
      }
      
      private function createEffectsForPoint(turretObject:ClientObject, owner:ClientObject, sfxData:ShaftSFXData, param1:Vector3, param2:Vector3, param3:Vector3, param4:Vector3, param5:Boolean) : void
      {
         var _loc7_:Number = NaN;
         var _loc6_:Number = sfxData.trailLength;
         vectorToHitPoint.vDiff(param1,param2);
         if(vectorToHitPoint.vDot(param3) > 0)
         {
            _loc7_ = vectorToHitPoint.vLength();
            if(_loc7_ > _loc6_)
            {
               _loc7_ = _loc6_;
            }
            this.createTrailEffect(sfxData,TrailEffect1,param1,param4,_loc7_,_loc7_ / _loc6_);
            if(param5)
            {
               this.createTrailEffect(sfxData,TrailEffect2,param1,param4,_loc7_,0.5);
            }
         }
         this.createExplosionGraphicEffect(turretObject,owner,sfxData,param1);
         this.createExplosionSoundEffect(turretObject,owner,sfxData,param1);
      }
      
      private function createExplosionGraphicEffect(turretObject:ClientObject, owner:ClientObject, sfxData:ShaftSFXData, param1:Vector3) : void
      {
         var _loc2_:StaticObject3DPositionProvider = StaticObject3DPositionProvider(objectPoolService.objectPool.getObject(StaticObject3DPositionProvider));
         _loc2_.init(param1,EXPLOSION_OFFSET_TO_CAMERA);
         var _loc3_:AnimatedSpriteEffectNew = AnimatedSpriteEffectNew(objectPoolService.objectPool.getObject(AnimatedSpriteEffectNew));
         _loc3_.init(EXPLOSION_WIDTH * 3,2.5 * EXPLOSION_WIDTH,sfxData.explosionAnimation,0,_loc2_);
         this.battlefieldModel.addGraphicEffect(_loc3_);
      }
      
      private function createExplosionSoundEffect(turretObject:ClientObject, owner:ClientObject, sfxData:ShaftSFXData, param1:Vector3) : void
      {
         var _loc2_:Sound3D = Sound3D.create(sfxData.explosionSound,1000,5000,5,EXPLOSION_SOUND_VOLUME);
         var _loc3_:Sound3DEffect = Sound3DEffect(objectPoolService.objectPool.getObject(Sound3DEffect));
         _loc3_.init(owner,param1,_loc2_,100);
         this.battlefieldModel.addSound3DEffect(_loc3_);
      }
      
      private function createTrailEffect(sfxData:ShaftSFXData, param1:Class, param2:Vector3, param3:Vector3, param4:Number, param5:Number) : void
      {
         var _loc6_:ShaftTrailEffect = ShaftTrailEffect(objectPoolService.objectPool.getObject(param1));
         _loc6_.init(param2,param3,param4,param5,sfxData.trailMaterial,TRAIL_DURATION);
         this.battlefieldModel.addGraphicEffect(_loc6_);
      }
   }
}
