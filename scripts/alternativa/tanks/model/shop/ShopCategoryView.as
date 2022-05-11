package alternativa.tanks.model.shop
{
   import flash.display.Sprite;
   
   public class ShopCategoryView extends Sprite
   {
      
      private static const GAP:int = 10;
       
      
      public var headerText:String;
      
      public var descriptionText:String;
      
      public var categoryId:String;
      
      public var header:ShopCategoryHeader;
      
      public var items:ShopCategoryViewGrid;
      
      public function ShopCategoryView(param1:String, param2:String, param3:String)
      {
         super();
         this.headerText = param1;
         this.descriptionText = param2;
         this.categoryId = param3;
         this.init();
      }
      
      private function init() : void
      {
         this.header = new ShopCategoryHeader(this.headerText,this.descriptionText);
         addChild(this.header);
         this.items = new ShopCategoryViewGrid();
         addChild(this.items);
      }
      
      public function addItem(param1:ItemBase) : void
      {
         this.items.addItem(param1);
      }
      
      public function render(param1:int) : void
      {
         this.header.render(param1);
         this.items.render();
         this.items.y = this.header.y + this.header.height + GAP;
      }
      
      public function destroy() : void
      {
         this.header = null;
         this.items.destroy();
         this.items = null;
      }
   }
}
