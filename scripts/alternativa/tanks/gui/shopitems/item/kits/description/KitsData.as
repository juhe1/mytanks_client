package alternativa.tanks.gui.shopitems.item.kits.description
{
   import projects.tanks.client.panel.model.shop.kitpackage.KitPackageItemInfo;
   
   public class KitsData
   {
       
      
      public var info:Vector.<KitPackageItemInfo>;
      
      public var discount:int;
      
      public function KitsData(kitInfo:Vector.<KitPackageItemInfo>, sale:int)
      {
         super();
         this.info = kitInfo;
         this.discount = sale;
      }
   }
}
