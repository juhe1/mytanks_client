package alternativa.tanks.models.effects.common.bonuscommon
{
   import flash.utils.Dictionary;
   
   public class BonusCache
   {
      
      private static var parachuteCache:ObjectCache = new ObjectCache();
      
      private static var cordsCache:ObjectCache = new ObjectCache();
      
      private static var boxCaches:Dictionary = new Dictionary();
       
      
      public function BonusCache()
      {
         super();
      }
      
      public static function isParachuteCacheEmpty() : Boolean
      {
         return parachuteCache.isEmpty();
      }
      
      public static function getParachute() : Parachute
      {
         return Parachute(parachuteCache.get());
      }
      
      public static function putParachute(parachute:Parachute) : void
      {
         parachuteCache.put(parachute);
      }
      
      public static function isCordsCacheEmpty() : Boolean
      {
         return cordsCache.isEmpty();
      }
      
      public static function getCords() : Cords
      {
         return Cords(cordsCache.get());
      }
      
      public static function putCords(cords:Cords) : void
      {
         cordsCache.put(cords);
      }
      
      public static function isBonusMeshCacheEmpty(objectId:String) : Boolean
      {
         return getBonusMeshCache(objectId.split("_")[0]).isEmpty();
      }
      
      public static function getBonusMesh(objectId:String) : BonusMesh
      {
         return BonusMesh(getBonusMeshCache(objectId.split("_")[0]).get());
      }
      
      public static function putBonusMesh(bonusMesh:BonusMesh) : void
      {
         getBonusMeshCache(bonusMesh.getObjectId().split("_")[0]).put(bonusMesh);
      }
      
      private static function getBonusMeshCache(objectId:String) : ObjectCache
      {
         var cache:ObjectCache = boxCaches[objectId];
         if(cache == null)
         {
            cache = new ObjectCache();
            boxCaches[objectId] = cache;
         }
         return cache;
      }
      
      public static function destroy() : void
      {
         parachuteCache = new ObjectCache();
         cordsCache = new ObjectCache();
         boxCaches = new Dictionary();
      }
   }
}
