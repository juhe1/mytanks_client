package controls
{
   import assets.window.bitmaps.WindowBGTile;
   import assets.window.bitmaps.WindowBottom;
   import assets.window.bitmaps.WindowLeft;
   import assets.window.bitmaps.WindowRight;
   import assets.window.bitmaps.WindowTop;
   import assets.window.elemets.WindowBottomLeftCorner;
   import assets.window.elemets.WindowBottomRightCorner;
   import assets.window.elemets.WindowTopLeftCorner;
   import assets.window.elemets.WindowTopRightCorner;
   import flash.display.Shape;
   import flash.display.Sprite;
   
   public class TankWindow2 extends Sprite
   {
       
      
      private var _width:int;
      
      private var _height:int;
      
      private var tl:WindowTopLeftCorner;
      
      private var tr:WindowTopRightCorner;
      
      private var bl:WindowBottomLeftCorner;
      
      private var br:WindowBottomRightCorner;
      
      private var bgBMP:WindowBGTile;
      
      private var topBMP:WindowTop;
      
      private var bottomBMP:WindowBottom;
      
      private var leftBMP:WindowLeft;
      
      private var rightBMP:WindowRight;
      
      public var bg:Sprite;
      
      public var bg1:Sprite;
      
      public var bg2:Sprite;
      
      public var bg3:Sprite;
      
      private var top:Shape;
      
      private var bottom:Shape;
      
      private var left:Shape;
      
      private var right:Shape;
      
      private var mcHeader:TankWindowHeader;
      
      private var _header:int = 0;
      
      public function TankWindow2(width:int = -1, height:int = -1)
      {
         this.tl = new WindowTopLeftCorner();
         this.tr = new WindowTopRightCorner();
         this.bl = new WindowBottomLeftCorner();
         this.br = new WindowBottomRightCorner();
         this.bgBMP = new WindowBGTile(0,0);
         this.topBMP = new WindowTop(0,0);
         this.bottomBMP = new WindowBottom(0,0);
         this.leftBMP = new WindowLeft(0,0);
         this.rightBMP = new WindowRight(0,0);
         this.bg = new Sprite();
         this.bg1 = new Sprite();
         this.bg2 = new Sprite();
         this.bg3 = new Sprite();
         this.top = new Shape();
         this.bottom = new Shape();
         this.left = new Shape();
         this.right = new Shape();
         super();
         this._width = width;
         this._height = height;
         this.ConfigUI();
         this.draw();
      }
      
      override public function set width(w:Number) : void
      {
         this._width = int(w);
         this.draw();
      }
      
      override public function get width() : Number
      {
         return this._width;
      }
      
      override public function set height(h:Number) : void
      {
         this._height = int(h);
         this.draw();
      }
      
      override public function get height() : Number
      {
         return this._height;
      }
      
      private function ConfigUI() : void
      {
         this._width = this._width == -1 ? int(scaleX * 100) : int(this._width);
         this._height = this._height == -1 ? int(scaleY * 100) : int(this._height);
         scaleX = 1;
         scaleY = 1;
         addChild(this.bg);
         addChild(this.bg1);
         addChild(this.bg3);
         addChild(this.bg2);
         addChild(this.top);
         addChild(this.bottom);
         addChild(this.left);
         addChild(this.right);
         addChild(this.tl);
         addChild(this.tr);
         addChild(this.bl);
         addChild(this.br);
      }
      
      public function set header(value:int) : void
      {
         this._header = value;
         this.mcHeader = new TankWindowHeader(value,Game.currLocale.toLowerCase());
         addChild(this.mcHeader);
         if(value > 19)
         {
            this.mcHeader.x = -13;
         }
         else
         {
            this.mcHeader.y = -13;
         }
         this.draw();
      }
      
      private function draw() : void
      {
         this.bg.graphics.clear();
         this.bg.graphics.beginBitmapFill(this.bgBMP);
         this.bg.graphics.drawRect(7,7,this._width - 14,7);
         this.bg.graphics.endFill();
         this.bg1.graphics.clear();
         this.bg1.graphics.beginBitmapFill(this.bgBMP);
         this.bg1.graphics.drawRect(7,7,7,this._height - 14);
         this.bg1.graphics.endFill();
         this.bg2.graphics.clear();
         this.bg2.graphics.beginBitmapFill(this.bgBMP);
         this.bg2.graphics.drawRect(this._width - 14,7,7,this._height - 14);
         this.bg2.graphics.endFill();
         this.bg3.graphics.clear();
         this.bg3.graphics.beginBitmapFill(this.bgBMP);
         this.bg3.graphics.drawRect(7,this._height - 14,this._width - 14,7);
         this.bg3.graphics.endFill();
         this.top.graphics.clear();
         this.top.graphics.beginBitmapFill(this.topBMP);
         this.top.graphics.drawRect(0,0,this._width - 22,11);
         this.top.graphics.endFill();
         this.top.x = 11;
         this.bottom.graphics.clear();
         this.bottom.graphics.beginBitmapFill(this.bottomBMP);
         this.bottom.graphics.drawRect(0,0,this._width - 22,11);
         this.bottom.graphics.endFill();
         this.bottom.x = 11;
         this.bottom.y = this._height - 11;
         this.left.graphics.clear();
         this.left.graphics.beginBitmapFill(this.leftBMP);
         this.left.graphics.drawRect(0,0,11,this._height - 22);
         this.left.graphics.endFill();
         this.left.x = 0;
         this.left.y = 11;
         this.right.graphics.clear();
         this.right.graphics.beginBitmapFill(this.rightBMP);
         this.right.graphics.drawRect(0,0,11,this._height - 22);
         this.right.graphics.endFill();
         this.right.x = this._width - 11;
         this.right.y = 11;
         this.tl.x = 0;
         this.tl.y = 0;
         this.tr.x = this._width - this.tr.width;
         this.tr.y = 0;
         this.bl.x = 0;
         this.bl.y = this._height - this.bl.height;
         this.br.x = this._width - this.br.width;
         this.br.y = this._height - this.br.height;
         if(this.mcHeader != null)
         {
            if(this._header > 19)
            {
               this.mcHeader.y = int(this._height / 2);
            }
            else
            {
               this.mcHeader.x = int(this._width / 2);
            }
         }
      }
   }
}
