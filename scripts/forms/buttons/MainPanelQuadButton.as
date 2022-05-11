package forms.buttons
{
   import controls.Label;
   import controls.panel.BaseButton;
   import flash.display.Bitmap;
   import flash.events.MouseEvent;
   import flash.text.TextFieldAutoSize;
   
   public class MainPanelQuadButton extends BaseButton
   {
      
      private static const LABEL_POSITION_Y:int = 4;
       
      
      private var _buttonOverBitmap:Bitmap;
      
      private var _buttonNormalBitmap:Bitmap;
      
      private var _labelBase:Label;
      
      protected var previousY:int;
      
      public var savelLabel:String;
      
      public function MainPanelQuadButton(param1:Bitmap, param2:Bitmap)
      {
         this._buttonNormalBitmap = param2;
         this._buttonOverBitmap = param1;
         super();
         super.type = 1;
         this.createLabel();
      }
      
      private function createLabel() : void
      {
         this._labelBase = new Label();
         this._labelBase.x = width / 2 - this._labelBase.width / 2;
         this._labelBase.y = 6;
         this._labelBase.autoSize = TextFieldAutoSize.CENTER;
         this._labelBase.mouseEnabled = false;
         addChild(this._labelBase);
      }
      
      override protected function configUI() : void
      {
         addChild(this._buttonNormalBitmap);
         addChild(this._buttonOverBitmap);
         this._buttonOverBitmap.visible = false;
      }
      
      override protected function addListeners() : void
      {
         buttonMode = true;
         mouseEnabled = true;
         mouseChildren = true;
         addEventListener(MouseEvent.MOUSE_OVER,this.onMouseEvent);
         addEventListener(MouseEvent.MOUSE_OUT,this.onMouseEvent);
         addEventListener(MouseEvent.MOUSE_DOWN,this.onMouseEvent);
         addEventListener(MouseEvent.MOUSE_UP,this.onMouseEvent);
      }
      
      override protected function removeListeners() : void
      {
         buttonMode = false;
         mouseEnabled = false;
         mouseChildren = false;
         removeEventListener(MouseEvent.MOUSE_OVER,this.onMouseEvent);
         removeEventListener(MouseEvent.MOUSE_OUT,this.onMouseEvent);
         removeEventListener(MouseEvent.MOUSE_DOWN,this.onMouseEvent);
         removeEventListener(MouseEvent.MOUSE_UP,this.onMouseEvent);
      }
      
      override protected function onMouseEvent(param1:MouseEvent) : void
      {
         switch(param1.type)
         {
            case MouseEvent.MOUSE_OVER:
               this.previousY = y;
               this._buttonOverBitmap.visible = true;
               break;
            case MouseEvent.MOUSE_OUT:
               y = this.previousY;
               this._buttonOverBitmap.visible = false;
               break;
            case MouseEvent.MOUSE_DOWN:
               y = this.previousY + 1;
               this._buttonOverBitmap.visible = false;
               break;
            case MouseEvent.MOUSE_UP:
               y = this.previousY;
               this._buttonOverBitmap.visible = false;
         }
      }
      
      override public function set label(param1:String) : void
      {
         this._labelBase.htmlText = param1;
         this.savelLabel = param1;
      }
   }
}
