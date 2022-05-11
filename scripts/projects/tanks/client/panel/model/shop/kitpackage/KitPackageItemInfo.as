package projects.tanks.client.panel.model.shop.kitpackage
{
   public class KitPackageItemInfo
   {
       
      
      private var _count:int;
      
      private var _crystalPrice:int;
      
      private var _itemName:String;
      
      public function KitPackageItemInfo(param1:int = 0, param2:int = 0, param3:String = null)
      {
         super();
         this._count = param1;
         this._crystalPrice = param2;
         this._itemName = param3;
      }
      
      public function get count() : int
      {
         return this._count;
      }
      
      public function set count(param1:int) : void
      {
         this._count = param1;
      }
      
      public function get crystalPrice() : int
      {
         return this._crystalPrice;
      }
      
      public function set crystalPrice(param1:int) : void
      {
         this._crystalPrice = param1;
      }
      
      public function get itemName() : String
      {
         return this._itemName;
      }
      
      public function set itemName(param1:String) : void
      {
         this._itemName = param1;
      }
      
      public function toString() : String
      {
         var _loc1_:String = "KitPackageItemInfo [";
         _loc1_ += "count = " + this.count + " ";
         _loc1_ += "crystalPrice = " + this.crystalPrice + " ";
         _loc1_ += "itemName = " + this.itemName + " ";
         return _loc1_ + "]";
      }
   }
}
