package alternativa.tanks.gui.shopitems.item.kits.description
{
   import flash.utils.Dictionary;
   import projects.tanks.client.panel.model.shop.kitpackage.KitPackageItemInfo;
   
   public class KitsInfoData
   {
      
      private static var data:Dictionary = new Dictionary();
       
      
      public function KitsInfoData()
      {
         super();
      }
      
      public static function setData(key:String, info:Vector.<KitPackageItemInfo>, discount:int) : void
      {
         data[key] = new KitsData(info,discount);
      }
      
      public static function getData(key:String) : KitsData
      {
         return data[key];
      }
   }
}
