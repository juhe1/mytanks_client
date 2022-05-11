package alternativa.tanks.model.shop
{
   import controls.TankWindowInner;
   import fl.containers.ScrollPane;
   import fl.controls.ScrollPolicy;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.utils.Dictionary;
   import forms.ColorConstants;
   import utils.ScrollStyleUtils;
   
   public class ShopCategorysView extends Sprite
   {
      
      private static const VERTICAL_GAP:int = 20;
      
      private static const AROUND_GAP:int = 25;
      
      private static const SCROLL_GAP:int = 5;
      
      private static const SCROLL_PANE_BOTTOM_PADDING:int = 15;
      
      private static const SCROLL_SHIFT_GAP:int = 5;
      
      private static const SCROLL_SPEED_MULTIPLIER:int = 3;
       
      
      private var scrollPane:ScrollPane;
      
      private var scrollContainer:Sprite;
      
      private var scrollPaneBottomPadding:Sprite;
      
      private var inner:TankWindowInner;
      
      private var categoriesPosition:Vector.<ShopCategoryView>;
      
      private var categories:Dictionary;
      
      private var _width:int;
      
      private var _height:int;
      
      public function ShopCategorysView()
      {
         super();
         this.categories = new Dictionary();
         this.categoriesPosition = new Vector.<ShopCategoryView>();
         this.inner = new TankWindowInner(0,0,TankWindowInner.GREEN);
         addChild(this.inner);
         this.scrollContainer = new Sprite();
         this.scrollPaneBottomPadding = new Sprite();
         this.scrollContainer.addChild(this.scrollPaneBottomPadding);
         this.scrollPane = new ScrollPane();
         ScrollStyleUtils.setGreenStyle(this.scrollPane);
         this.scrollPane.horizontalScrollPolicy = ScrollPolicy.OFF;
         this.scrollPane.verticalScrollPolicy = ScrollPolicy.AUTO;
         this.scrollPane.source = this.scrollContainer;
         this.scrollPane.update();
         this.scrollPane.focusEnabled = false;
         this.scrollPane.addEventListener(MouseEvent.MOUSE_WHEEL,onMouseWheel,true);
         addChild(this.scrollPane);
      }
      
      private static function onMouseWheel(param1:MouseEvent) : void
      {
         param1.delta *= SCROLL_SPEED_MULTIPLIER;
      }
      
      public function render(param1:int, param2:int) : void
      {
         var _loc4_:ShopCategoryView = null;
         _loc4_ = null;
         this._width = param1;
         this._height = param2;
         this.scrollPane.y = SCROLL_GAP;
         this.scrollPane.setSize(param1 + SCROLL_SHIFT_GAP,param2 - SCROLL_GAP * 2);
         this.inner.width = param1;
         this.inner.height = param2;
         var _loc3_:int = -12;
         for each(_loc4_ in this.categoriesPosition)
         {
            _loc4_.x = AROUND_GAP;
            _loc4_.render(this._width - AROUND_GAP * 2 - (this.scrollPane.verticalScrollBar.width - SCROLL_SHIFT_GAP - 1));
            _loc4_.y = _loc3_ + VERTICAL_GAP;
            _loc3_ = _loc4_.y + _loc4_.height;
         }
         this.fixScrollPaneBottomPadding(_loc3_);
         this.scrollPane.update();
      }
      
      private function fixScrollPaneBottomPadding(param1:int) : void
      {
         this.scrollPaneBottomPadding.graphics.lineStyle(1,ColorConstants.WHITE,0);
         this.scrollPaneBottomPadding.graphics.beginFill(ColorConstants.WHITE,0);
         this.scrollPaneBottomPadding.graphics.drawRect(0,0,1,SCROLL_PANE_BOTTOM_PADDING);
         this.scrollPaneBottomPadding.graphics.endFill();
         this.scrollPaneBottomPadding.x = AROUND_GAP;
         this.scrollPaneBottomPadding.y = param1;
      }
      
      public function addCategory(param1:ShopCategoryView) : void
      {
         this.categories[param1.categoryId] = param1;
         this.categoriesPosition.push(param1);
         this.scrollContainer.addChild(param1);
      }
      
      public function addItem(param1:String, param2:ItemBase) : void
      {
         ShopCategoryView(this.categories[param1]).addItem(param2);
      }
      
      override public function get width() : Number
      {
         return this._width;
      }
      
      override public function get height() : Number
      {
         return this._height;
      }
      
      public function destroy() : void
      {
         var _loc1_:ShopCategoryView = null;
         for each(_loc1_ in this.categories)
         {
            _loc1_.destroy();
         }
         this.categories = null;
         this.categoriesPosition = null;
         this.scrollPane.removeEventListener(MouseEvent.MOUSE_WHEEL,onMouseWheel,true);
         this.scrollPane = null;
      }
   }
}
