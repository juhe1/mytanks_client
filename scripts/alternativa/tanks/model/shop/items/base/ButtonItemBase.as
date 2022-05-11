package alternativa.tanks.model.shop.items.base
{
   import alternativa.tanks.model.shop.ItemBase;
   import flash.display.Bitmap;
   import flash.events.MouseEvent;
   
   public class ButtonItemBase extends ItemBase
   {
      
      private static const DOWN_PIXELS:int = 1;
       
      
      protected var normalState:Bitmap;
      
      protected var overState:Bitmap;
      
      protected var previousY:int;
      
      public function ButtonItemBase(param1:ButtonItemSkin)
      {
         super();
         this.initAndAppendSkin(param1);
         this.init();
      }
      
      private function initAndAppendSkin(param1:ButtonItemSkin) : void
      {
         this.normalState = new Bitmap(param1.normalState);
         this.overState = new Bitmap(param1.overState);
         addChildAt(this.overState,0);
         addChildAt(this.normalState,0);
         this.overState.visible = false;
      }
      
      protected function init() : void
      {
         buttonMode = true;
         addEventListener(MouseEvent.MOUSE_OVER,this.onMouseEvent);
         addEventListener(MouseEvent.MOUSE_OUT,this.onMouseEvent);
         addEventListener(MouseEvent.MOUSE_DOWN,this.onMouseEvent);
         addEventListener(MouseEvent.MOUSE_UP,this.onMouseEvent);
      }
      
      public function setSkin(param1:ButtonItemSkin) : void
      {
         removeChild(this.normalState);
         removeChild(this.overState);
         this.initAndAppendSkin(param1);
      }
      
      private function onMouseEvent(param1:MouseEvent) : void
      {
         this.overState.visible = param1.type == MouseEvent.MOUSE_OVER;
         this.normalState.visible = !this.overState.visible;
         switch(param1.type)
         {
            case MouseEvent.MOUSE_OVER:
               this.previousY = y;
               break;
            case MouseEvent.MOUSE_OUT:
               y = this.previousY;
               break;
            case MouseEvent.MOUSE_UP:
               y = this.previousY;
               break;
            case MouseEvent.MOUSE_DOWN:
               y = this.previousY + DOWN_PIXELS;
         }
      }
      
      override public function destroy() : void
      {
         removeEventListener(MouseEvent.MOUSE_OVER,this.onMouseEvent);
         removeEventListener(MouseEvent.MOUSE_OUT,this.onMouseEvent);
         removeEventListener(MouseEvent.MOUSE_DOWN,this.onMouseEvent);
         removeEventListener(MouseEvent.MOUSE_UP,this.onMouseEvent);
      }
   }
}
