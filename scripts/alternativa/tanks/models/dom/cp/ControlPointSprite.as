package alternativa.tanks.models.dom.cp
{
   import alternativa.engine3d.materials.TextureMaterial;
   import alternativa.engine3d.objects.Sprite3D;
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.geom.Matrix;
   import flash.geom.Rectangle;
   
   public class ControlPointSprite extends Sprite3D
   {
      
[Embed(source="1174.png")]
      private static const alphaC:Class;
      
[Embed(source="1198.png")]
      private static const blueC:Class;
      
[Embed(source="1102.png")]
      private static const redC:Class;
      
[Embed(source="1197.png")]
      private static const noneC:Class;
      
[Embed(source="773.png")]
      private static const charsC:Class;
      
      public static const BALANCE_ABS:int = 100;
      
      public static const BALANCE_NONE:int = 0;
      
      public static const BALANCE_RED:int = -100;
      
      public static const BALANCE_BLUE:int = 100;
      
      public static const blues:BitmapData = (new blueC() as Bitmap).bitmapData;
      
      public static const reds:BitmapData = (new redC() as Bitmap).bitmapData;
      
      public static const nones:BitmapData = (new noneC() as Bitmap).bitmapData;
      
      public static const chars:BitmapData = (new charsC() as Bitmap).bitmapData;
      
      public static const w:int = nones.width;
      
      public static const h:int = nones.height;
      
      public static const abds:BitmapData = (new alphaC() as Bitmap).bitmapData;
      
      public static var abd:BitmapData;
      
      public static var red:BitmapData;
      
      public static var blue:BitmapData;
      
      public static var none:BitmapData;
       
      
      public var progress:Number = 0;
      
      public var tm:TextureMaterial;
      
      public var currChar:int = 0;
      
      public var mask:DrawMask;
      
      public function ControlPointSprite(pointId:int)
      {
         this.mask = new DrawMask(w);
         super(w,h);
         this.currChar = pointId;
         material = this.tm = new TextureMaterial(none,false,false);
         scaleX = scaleY = scaleZ = 2;
      }
      
      public static function init() : void
      {
         prepareAbd();
         red = getTexture(reds);
         blue = getTexture(blues);
         none = getTexture(nones);
      }
      
      public static function destroy() : void
      {
         red.dispose();
         blue.dispose();
         none.dispose();
         red = blue = none = null;
      }
      
      public static function prepareAbd() : void
      {
         var _loc1_:uint = 0;
         var _loc3_:int = 0;
         abd = new BitmapData(w,h,true);
         var _loc2_:int = 0;
         while(_loc2_ < w)
         {
            _loc3_ = 0;
            while(_loc3_ < h)
            {
               _loc1_ = abds.getPixel32(_loc2_,_loc3_);
               _loc1_ <<= 24;
               abd.setPixel32(_loc2_,_loc3_,_loc1_);
               _loc3_++;
            }
            _loc2_++;
         }
      }
      
      public static function getTexture(param1:BitmapData) : BitmapData
      {
         var _loc3_:uint = 0;
         var _loc4_:uint = 0;
         var _loc5_:uint = 0;
         var _loc6_:uint = 0;
         var _loc7_:uint = 0;
         var _loc9_:int = 0;
         var _loc2_:BitmapData = new BitmapData(param1.width,param1.height,true);
         var _loc8_:int = 0;
         while(_loc8_ < w)
         {
            _loc9_ = 0;
            while(_loc9_ < h)
            {
               _loc3_ = abd.getPixel32(_loc8_,_loc9_);
               _loc4_ = param1.getPixel32(_loc8_,_loc9_);
               _loc3_ = _loc3_ >> 24 & 255;
               _loc5_ = _loc4_ >> 16 & 255;
               _loc6_ = _loc4_ >> 8 & 255;
               _loc7_ = _loc4_ & 255;
               _loc4_ = _loc3_ << 24 | _loc5_ << 16 | _loc6_ << 8 | _loc7_;
               _loc2_.setPixel32(_loc8_,_loc9_,_loc4_);
               _loc9_++;
            }
            _loc8_++;
         }
         return _loc2_;
      }
      
      public function drawChar(param1:BitmapData) : void
      {
         var _loc2_:Matrix = new Matrix();
         _loc2_.translate(96 - 64 * this.currChar,96);
         param1.draw(chars,_loc2_,null,null,new Rectangle(96,96,64,64));
      }
      
      public function redraw() : void
      {
         var _loc1_:BitmapData = new BitmapData(w,h,true,0);
         if(this.progress < -100)
         {
            this.progress = -100;
         }
         else if(this.progress > 100)
         {
            this.progress = 100;
         }
         if(this.progress == BALANCE_NONE)
         {
            _loc1_.draw(none);
            this.drawChar(_loc1_);
            this.tm.texture = _loc1_;
            return;
         }
         if(this.progress == BALANCE_RED)
         {
            _loc1_.draw(red);
            this.drawChar(_loc1_);
            this.tm.texture = _loc1_;
            return;
         }
         if(this.progress == BALANCE_BLUE)
         {
            _loc1_.draw(blue);
            this.drawChar(_loc1_);
            this.tm.texture = _loc1_;
            return;
         }
         if(this.progress < 0)
         {
            _loc1_.draw(none);
            this.mask.drawMaskPoint(red,1 + this.progress / BALANCE_ABS);
            _loc1_.draw(this.mask);
            this.drawChar(_loc1_);
            this.tm.texture = _loc1_;
         }
         else
         {
            _loc1_.draw(none);
            this.mask.drawMaskPoint(blue,1 - this.progress / BALANCE_ABS);
            _loc1_.draw(this.mask);
            this.drawChar(_loc1_);
            this.tm.texture = _loc1_;
         }
      }
   }
}
