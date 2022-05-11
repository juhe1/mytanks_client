package alternativa.tanks.models.dom.cp
{
   import flash.display.BitmapData;
   import flash.display.Graphics;
   import flash.display.Sprite;
   import flash.geom.Point;
   
   public class DrawMask extends Sprite
   {
      
      private static const d:Number = 0.785398;
      
      private static const a:Number = 2.35619;
      
      private static const u:Number = 3.92699;
      
      private static const v:Number = 5.49779;
      
      private static var p:Vector.<Point>;
       
      
      private var n:Number;
      
      public var off:int = 0;
      
      public function DrawMask(param1:int)
      {
         super();
         if(p == null)
         {
            createPoints();
         }
         this.n = param1;
      }
      
      private static function createPoints() : void
      {
         p = new Vector.<Point>(6);
         p[0] = new Point(1,0);
         p[1] = new Point(1,1);
         p[2] = new Point(0,1);
         p[3] = new Point(0,0);
         p[4] = new Point(0.5,0);
         p[5] = new Point(0.5,0.5);
      }
      
      public function drawMaskPoint(param1:BitmapData, param2:Number) : void
      {
         var _loc3_:Number = 0;
         var _loc4_:Number = 0;
         var _loc5_:Number = 0;
         var _loc6_:Number = 2 * Math.PI * param2;
         if(_loc6_ < d)
         {
            _loc5_ = 0;
            _loc3_ = 0.5 * this.n * (1 + Math.tan(_loc6_));
            _loc4_ = 0;
         }
         else if(_loc6_ < a)
         {
            _loc5_ = 1;
            _loc3_ = this.n;
            _loc4_ = 0.5 * this.n * (1 - 1 / Math.tan(_loc6_));
         }
         else if(_loc6_ < u)
         {
            _loc5_ = 2;
            _loc3_ = 0.5 * this.n * (1 - Math.tan(_loc6_));
            _loc4_ = this.n;
         }
         else if(_loc6_ < v)
         {
            _loc5_ = 3;
            _loc3_ = 0;
            _loc4_ = 0.5 * this.n * (1 + 1 / Math.tan(_loc6_));
         }
         else
         {
            _loc5_ = 4;
            _loc3_ = 0.5 * this.n * (1 + Math.tan(_loc6_));
            _loc4_ = 0;
         }
         var _loc7_:Graphics = this.graphics;
         _loc7_.clear();
         var _loc8_:Point = p[5];
         _loc7_.beginBitmapFill(param1);
         _loc7_.moveTo(_loc3_,_loc4_);
         while(_loc5_ < 6)
         {
            _loc8_ = p[_loc5_];
            _loc7_.lineTo(this.n * _loc8_.x,this.n * _loc8_.y);
            _loc5_++;
         }
         _loc7_.lineTo(_loc3_,_loc4_);
         _loc7_.endFill();
      }
   }
}
