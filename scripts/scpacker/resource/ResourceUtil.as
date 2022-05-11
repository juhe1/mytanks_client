package scpacker.resource
{
   import alternativa.tanks.model.GarageModel;
   import com.alternativaplatform.projects.tanks.client.commons.types.TankParts;
   import flash.utils.Dictionary;
   import scpacker.resource.images.ImageResourceList;
   import scpacker.resource.images.ImageResourceLoader;
   import scpacker.resource.listener.ResourceLoaderListener;
   import scpacker.resource.tanks.TankResourceLoader;
   import specter.utils.Logger;
   
   public class ResourceUtil
   {
      
      public static var loading:Vector.<String>;
      
      public static var isInBattle:Boolean = false;
      
      private static var loaderSounds:SoundResourceLoader;
      
      private static var loaderModels:TankResourceLoader;
      
      private static var loaderImages:ImageResourceLoader;
      
      private static var sfxMap:Dictionary;
      
      public static var resourceLoaded:Boolean;
      
      private static var resourcesLength:int;
       
      
      public function ResourceUtil()
      {
         super();
         throw new Error("пошел нахуй, кста");
      }
      
      public static function getResource(type:ResourceType, key:String) : Object
      {
         var returningResource:Object = null;
         if(!resourceLoaded)
         {
            return null;
         }
         switch(type)
         {
            case ResourceType.IMAGE:
               if(!isInBattle)
               {
                  returningResource = loaderImages.list.getImage(key);
               }
               else
               {
                  returningResource = loaderImages.inbattleList.getImage(key);
               }
               break;
            case ResourceType.MODEL:
               returningResource = loaderModels.list.getModel(key);
               break;
            case ResourceType.SOUND:
               returningResource = loaderSounds.list.getSound(key);
         }
         return returningResource;
      }
      
      public static function checkBitmaps() : void
      {
         trace("finish");
      }
      
      public static function loadResource() : void
      {
         sfxMap = new Dictionary();
         sfxMap["railgun"] = "shot, chargingPart1, chargingPart2, chargingPart3";
         sfxMap["railgunxt"] = "shot, chargingPart1, chargingPart2, chargingPart3";
         sfxMap["smoky"] = "shot, explosion";
         sfxMap["smokyxt"] = "shot, explosion";
         sfxMap["flamethrower"] = "fire";
         sfxMap["twins"] = "explosionTexture, plasmaTexture, shotTexture";
         sfxMap["twins_xt"] = "explosionTexture, plasmaTexture, shotTexture";
         sfxMap["twinsxt"] = "explosionTexture, plasmaTexture, shotTexture";
         sfxMap["isida"] = "damagingRayId, damagingTargetBallId, damagingWeaponBallId, healingRayId, healingTargetBallId, healingWeaponBallId, idleWeaponBallId";
         sfxMap["thunder"] = "explosionResourceId, shotResourceId";
         sfxMap["thunder_xt"] = "explosionResourceId, shotResourceId";
         sfxMap["hwthunder"] = "explosionResourceId, shotResourceId";
         sfxMap["frezee"] = "particleTextureResourceId, planeTextureResourceId";
         sfxMap["frezeeny"] = "particleTextureResourceId, planeTextureResourceId";
         sfxMap["ricochet"] = "bumpFlashTextureId, explosionTextureId, shotFlashTextureId, shotTextureId, tailTrailTextureId";
         sfxMap["pumpkingun"] = "bumpFlashTextureId, explosionTextureId, shotFlashTextureId, shotTextureId, tailTrailTextureId";
         sfxMap["shaft"] = "explosionTexture, shot, trail";
         sfxMap["terminator"] = "shot, chargingPart1, chargingPart2, chargingPart3";
         sfxMap["snowman"] = "shot, fire, snow";
         loading = new Vector.<String>();
         loaderSounds = new SoundResourceLoader("resourceSound.json?rand=" + Math.random());
         loaderModels = new TankResourceLoader("resourceModels.json?rand=" + Math.random());
         loaderImages = new ImageResourceLoader("resourceImages.json?rand=" + Math.random());
      }
      
      public static function loadImages() : void
      {
         isInBattle = false;
         resourceLoaded = false;
         loaderImages.reload();
      }
      
      public static function unloadImages(saveList:Vector.<String> = null) : void
      {
         var s:String = null;
         var s1:String = null;
         isInBattle = true;
         loaderImages.inbattleList.clear();
         loaderImages.inbattleList = new ImageResourceList();
         if(GarageModel.mounted != null && loaderImages.list.getImage(GarageModel.mounted[2]))
         {
            loaderImages.inbattleList.add(loaderImages.list.getImage(GarageModel.mounted[0] + "_details").clone());
            loaderImages.inbattleList.add(loaderImages.list.getImage(GarageModel.mounted[1] + "_lightmap").clone());
            loaderImages.inbattleList.add(loaderImages.list.getImage(GarageModel.mounted[0] + "_details").clone());
            loaderImages.inbattleList.add(loaderImages.list.getImage(GarageModel.mounted[1] + "_lightmap").clone());
            loaderImages.inbattleList.add(loaderImages.list.getImage(GarageModel.mounted[2]).clone());
         }
         if(saveList)
         {
            for each(s in saveList)
            {
               if(loaderImages.list.getImage(s))
               {
                  loaderImages.inbattleList.add(loaderImages.list.getImage(s).clone());
                  Logger.log("Refreshing colormap: " + s);
               }
               else
               {
                  for each(s1 in getLoadListSingle(s))
                  {
                     if(loaderImages.list.getImage(s1))
                     {
                        Logger.log("Refreshing tank part: " + s1);
                        loaderImages.inbattleList.add(loaderImages.list.getImage(s1).clone());
                     }
                  }
               }
            }
         }
         loaderImages.inbattleList.add(loaderImages.list.getImage("flagRed").clone());
         loaderImages.inbattleList.add(loaderImages.list.getImage("flagBlue").clone());
         loaderImages.inbattleList.add(loaderImages.list.getImage("flagRedModel_img").clone());
         loaderImages.inbattleList.add(loaderImages.list.getImage("flagBlueModel_img").clone());
         loaderImages.inbattleList.add(loaderImages.list.getImage("pedestalRC").clone());
         loaderImages.inbattleList.add(loaderImages.list.getImage("pedestalBC").clone());
         loaderImages.inbattleList.add(loaderImages.list.getImage("pedestalNC").clone());
         loaderImages.inbattleList.add(loaderImages.list.getImage("explosionTexture").clone());
         loaderImages.inbattleList.add(loaderImages.list.getImage("shockWaveTexture").clone());
         loaderImages.inbattleList.add(loaderImages.list.getImage("smokeTexture").clone());
         loaderImages.inbattleList.add(loaderImages.list.getImage("criticalHitTexture").clone());
         loaderImages.inbattleList.add(loaderImages.list.getImage("deadTank").clone());
         loaderImages.inbattleList.add(loaderImages.list.getImage("cords").clone());
         loaderImages.inbattleList.add(loaderImages.list.getImage("parachute").clone());
         loaderImages.inbattleList.add(loaderImages.list.getImage("parachute_inner").clone());
         loaderImages.inbattleList.add(loaderImages.list.getImage("bonus_box_lightmap").clone());
         loaderImages.inbattleList.add(loaderImages.list.getImage("bonus_box_details").clone());
         loaderImages.inbattleList.add(loaderImages.list.getImage("bonus_box_gold").clone());
         loaderImages.inbattleList.add(loaderImages.list.getImage("bonus_box_spin").clone());
         loaderImages.inbattleList.add(loaderImages.list.getImage("bonus_box_ruby").clone());
         loaderImages.inbattleList.add(loaderImages.list.getImage("bonus_box_prize").clone());
         loaderImages.inbattleList.add(loaderImages.list.getImage("bonus_box_crystall").clone());
         loaderImages.inbattleList.add(loaderImages.list.getImage("bonus_box_armor").clone());
         loaderImages.inbattleList.add(loaderImages.list.getImage("bonus_box_health").clone());
         loaderImages.inbattleList.add(loaderImages.list.getImage("bonus_box_damage").clone());
         loaderImages.inbattleList.add(loaderImages.list.getImage("bonus_box_nitro").clone());
         loaderImages.inbattleList.add(loaderImages.list.getImage("blueMineTexture").clone());
         loaderImages.inbattleList.add(loaderImages.list.getImage("enemyMineTexture").clone());
         loaderImages.inbattleList.add(loaderImages.list.getImage("friendlyMineTexture_mine").clone());
         loaderImages.inbattleList.add(loaderImages.list.getImage("idleExplosionTexture_mine").clone());
         loaderImages.inbattleList.add(loaderImages.list.getImage("mainExplosionTextureId_mine").clone());
         loaderImages.inbattleList.add(loaderImages.list.getImage("redMineTexture_mine").clone());
         loaderImages.list.clear();
         loaderImages.list = new ImageResourceList();
         onCompleteLoading();
      }
      
      public static function onCompleteLoading() : void
      {
         if(loaderImages.status == 1 && loaderSounds.status == 1 && loaderModels.status == 1)
         {
            trace("загрузка завершена");
            resourceLoaded = true;
            ResourceLoaderListener.loadedComplete();
            ResourceLoaderListener.clearListeners();
         }
      }
      
      public static function addEventListener(src:Function) : Function
      {
         ResourceLoaderListener.addEventListener(src);
         return src;
      }
      
      public static function loadGraphicsFor(parts:TankParts) : void
      {
         var s:String = null;
         if(isDataPresent(parts))
         {
            onCompleteLoading();
         }
         var toLoad:Vector.<String> = getLoadList(parts);
         for each(s in toLoad)
         {
            loaderImages.loadForBattle(s);
         }
         toLoad = null;
      }
      
      public static function loadGraphics(toLoad:Vector.<String>) : void
      {
         var s:String = null;
         for each(s in toLoad)
         {
            if(loaderImages.inbattleList.isLoaded(s))
            {
               trace("Good");
            }
            loaderImages.loadFor(s);
         }
      }
      
      public static function getLoadListSingle(id:String) : Vector.<String>
      {
         var s:String = null;
         var toLoad:Vector.<String> = new Vector.<String>();
         toLoad.push(id + "_lightmap");
         toLoad.push(id + "_details");
         var partID:String = id.split("_")[0];
         if(sfxMap[partID])
         {
            for each(s in sfxMap[partID].split(", "))
            {
               toLoad.push(id + "_" + s);
            }
         }
         return toLoad;
      }
      
      public static function getLoadList(parts:TankParts) : Vector.<String>
      {
         var s:String = null;
         var toLoad:Vector.<String> = new Vector.<String>();
         toLoad.push(parts.hullObjectId + "_lightmap");
         toLoad.push(parts.hullObjectId + "_details");
         toLoad.push(parts.turretObjectId + "_lightmap");
         toLoad.push(parts.turretObjectId + "_details");
         toLoad.push(parts.coloringObjectId);
         for each(s in sfxMap[parts.turretObjectId.split("_")[0]].split(", "))
         {
            toLoad.push(parts.turretObjectId + "_" + s);
         }
         return toLoad;
      }
      
      public static function isDataPresent(parts:TankParts) : Boolean
      {
         var s:String = null;
         var toCheck:Vector.<String> = new Vector.<String>();
         toCheck.push(parts.hullObjectId + "_lightmap");
         toCheck.push(parts.hullObjectId + "_details");
         toCheck.push(parts.turretObjectId + "_lightmap");
         toCheck.push(parts.turretObjectId + "_details");
         toCheck.push(parts.coloringObjectId);
         for each(s in toCheck)
         {
            if(!loaderImages.inbattleList.isLoaded(s))
            {
               return false;
            }
         }
         toCheck = null;
         return true;
      }
   }
}
