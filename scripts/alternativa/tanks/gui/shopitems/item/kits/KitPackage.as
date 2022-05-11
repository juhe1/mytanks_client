package alternativa.tanks.gui.shopitems.item.kits
{
   import projects.tanks.client.panel.model.shop.kitpackage.KitPackageItemInfo;
   
   public class KitPackage
   {
       
      
      private var items:Vector.<KitPackageItemInfo>;
      
      public function KitPackage(kit:Vector.<KitPackageItemInfo>)
      {
         super();
         this.items = kit;
      }
      
      public function getItemInfos() : Vector.<KitPackageItemInfo>
      {
         return this.items;
      }
   }
}
