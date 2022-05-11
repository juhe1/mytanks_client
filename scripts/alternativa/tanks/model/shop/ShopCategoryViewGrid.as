package alternativa.tanks.model.shop
{
   import flash.display.Sprite;
   
   public class ShopCategoryViewGrid extends Sprite
   {
       
      
      public var columnCount:int = 3;
      
      public var columnSpacing:int = 3;
      
      public var items:Vector.<ItemBase>;
      
      public function ShopCategoryViewGrid()
      {
         super();
         this.items = new Vector.<ItemBase>();
      }
      
      public function addItem(param1:ItemBase) : void
      {
         param1.gridPosition = this.items.length;
         this.items.push(param1);
         addChild(param1);
      }
      
      public function render() : void
      {
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc1_:int = this.items.length;
         for(var _loc2_:int = 0; _loc2_ < _loc1_; )
         {
            _loc3_ = _loc2_ % this.columnCount;
            _loc4_ = _loc2_ / this.columnCount;
            this.items[_loc2_].x = _loc3_ * this.items[_loc2_].width + _loc3_ * this.columnSpacing;
            this.items[_loc2_].y = _loc4_ * this.items[_loc2_].height + _loc4_ * this.columnSpacing;
            _loc2_++;
         }
      }
      
      public function destroy() : void
      {
         var _loc1_:ItemBase = null;
         for each(_loc1_ in this.items)
         {
            _loc1_.destroy();
         }
         this.items = null;
      }
   }
}
