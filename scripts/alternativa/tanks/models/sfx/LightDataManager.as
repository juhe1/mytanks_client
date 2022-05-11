package alternativa.tanks.models.sfx
{
   import flash.utils.Dictionary;
   
   public class LightDataManager
   {
      
      private static var data:Dictionary = new Dictionary();
      
      private static var colors:Dictionary = new Dictionary();
       
      
      public function LightDataManager()
      {
         super();
      }
      
      public static function init(json_:String) : void
      {
         var item:Object = null;
         var turretId:String = null;
         var animations:Vector.<LightingEffectRecord> = null;
         var anim:Object = null;
         var json:Object = JSON.parse(json_);
         var items:Array = json.data;
         for each(item in items)
         {
            if(item.turret.split("_")[0] == "bonus")
            {
               colors[item.turret] = item.color;
            }
            else
            {
               turretId = item.turret;
               animations = new Vector.<LightingEffectRecord>();
               for each(anim in item.animation)
               {
                  animations.push(new LightingEffectRecord(anim.attenuationBegin,anim.attenuationEnd,anim.color,anim.intensity,anim.time));
               }
               data[turretId] = new LightAnimation(animations);
            }
         }
      }
      
      public static function getLightDataMuzzle(turretId:String) : LightAnimation
      {
         return data[turretId + "_muzzle"];
      }
      
      public static function getLightDataShot(turretId:String) : LightAnimation
      {
         return data[turretId + "_shot"];
      }
      
      public static function getLightDataExplosion(turretId:String) : LightAnimation
      {
         return data[turretId + "_explosion"];
      }
      
      public static function getLightData(turretId:String, effectName:String) : LightAnimation
      {
         return data[turretId + "_" + effectName];
      }
      
      public static function getBonusLightColor(bonusId:String) : uint
      {
         return colors[bonusId];
      }
   }
}
