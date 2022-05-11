package scpacker.gui.combo
{
   import assets.windowinner.bitmaps.WindowInnerBottom;
   import assets.windowinner.bitmaps.WindowInnerLeft;
   import assets.windowinner.bitmaps.WindowInnerRight;
   import assets.windowinner.bitmaps.WindowInnerTop;
   import assets.windowinner.elemets.WindowInnerBottomLeftCorner;
   import assets.windowinner.elemets.WindowInnerBottomRightCorner;
   import assets.windowinner.elemets.WindowInnerTopLeftCorner;
   import assets.windowinner.elemets.WindowInnerTopRightCorner;
   import flash.display.BitmapData;
   import flash.display.Graphics;
   import flash.display.Shape;
   import flash.display.Sprite;
   
   public class DPLBackground extends Sprite
   {
      
[Embed(source="1123.png")]
      private static const b:Class;
       
      
      private var bgBMP:BitmapData;
      
      private var _width:int = 0;
      
      private var _height:int = 0;
      
      private var tl:WindowInnerTopLeftCorner;
      
      private var tr:WindowInnerTopRightCorner;
      
      private var bl:WindowInnerBottomLeftCorner;
      
      private var br:WindowInnerBottomRightCorner;
      
      private var topBMP:WindowInnerTop;
      
      private var bottomBMP:WindowInnerBottom;
      
      private var leftBMP:WindowInnerLeft;
      
      private var rightBMP:WindowInnerRight;
      
      private var bg:Sprite;
      
      private var top:Shape;
      
      private var bottom:Shape;
      
      private var left:Shape;
      
      private var right:Shape;
      
      public function DPLBackground(param1:int, param2:int)
      {
         this.bgBMP = new b().bitmapData;
         this.tl = new WindowInnerTopLeftCorner();
         this.tr = new WindowInnerTopRightCorner();
         this.bl = new WindowInnerBottomLeftCorner();
         this.br = new WindowInnerBottomRightCorner();
         this.topBMP = new WindowInnerTop(0,0);
         this.bottomBMP = new WindowInnerBottom(0,0);
         this.leftBMP = new WindowInnerLeft(0,0);
         this.rightBMP = new WindowInnerRight(0,0);
         this.bg = new Sprite();
         this.top = new Shape();
         this.bottom = new Shape();
         this.left = new Shape();
         this.right = new Shape();
         super();
         this._width = param1;
         this._height = param2;
         addChild(this.bg);
         addChild(this.top);
         addChild(this.bottom);
         addChild(this.left);
         addChild(this.right);
         addChild(this.tl);
         addChild(this.tr);
         addChild(this.bl);
         addChild(this.br);
         this.draw();
      }
      
      protected function draw() : void
      {
         var _loc1_:Graphics = null;
         _loc1_ = this.bg.graphics;
         _loc1_.clear();
         _loc1_.beginBitmapFill(this.bgBMP);
         _loc1_.drawRect(1,1,this._width - 2,this._height - 2);
         _loc1_.endFill();
         _loc1_ = this.top.graphics;
         _loc1_.clear();
         _loc1_.beginBitmapFill(this.topBMP);
         _loc1_.drawRect(0,0,this._width - 12,6);
         _loc1_.endFill();
         this.top.x = 6;
         _loc1_ = this.bottom.graphics;
         _loc1_.clear();
         _loc1_.beginBitmapFill(this.bottomBMP);
         _loc1_.drawRect(0,0,this._width - 12,6);
         _loc1_.endFill();
         this.bottom.x = 6;
         this.bottom.y = this._height - 6;
         _loc1_ = this.left.graphics;
         _loc1_.clear();
         _loc1_.beginBitmapFill(this.leftBMP);
         _loc1_.drawRect(0,0,6,this._height - 12);
         _loc1_.endFill();
         this.left.x = 0;
         this.left.y = 6;
         _loc1_ = this.right.graphics;
         _loc1_.clear();
         _loc1_.beginBitmapFill(this.rightBMP);
         _loc1_.drawRect(0,0,6,this._height - 12);
         _loc1_.endFill();
         this.right.x = this._width - 6;
         this.right.y = 6;
         this.tl.x = 0;
         this.tl.y = 0;
         this.tr.x = this._width - this.tr.width;
         this.tr.y = 0;
         this.bl.x = 0;
         this.bl.y = this._height - this.bl.height;
         this.br.x = this._width - this.br.width;
         this.br.y = this._height - this.br.height;
      }
      
      override public function set width(param1:Number) : void
      {
         if(this._width == int(param1))
         {
            return;
         }
         this._width = param1;
         this.draw();
      }
      
      override public function get width() : Number
      {
         return this._width;
      }
      
      override public function set height(param1:Number) : void
      {
         if(this._height == int(param1))
         {
            return;
         }
         this._height = param1;
         this.draw();
      }
      
      override public function get height() : Number
      {
         return this._height;
      }
      
      public function setSize(param1:int, param2:int) : void
      {
         this._width = param1;
         this._height = param2;
         this.draw();
      }
   }
}
