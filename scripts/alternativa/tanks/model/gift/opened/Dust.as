package alternativa.tanks.model.gift.opened
{
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.BlendMode;
   import flash.display.PixelSnapping;
   import flash.display.Sprite;
   
   public class Dust extends Sprite
   {
       
      
      private var motes:Array;
      
      private var count:int;
      
      private var bottom:Number;
      
      public function Dust(param1:BitmapData, param2:int, param3:Number, param4:Number)
      {
         var _loc7_:Bitmap = null;
         var _loc8_:Number = NaN;
         this.motes = new Array();
         super();
         this.count = param2;
         this.bottom = param4;
         var _loc5_:Number = param3 / param2;
         var _loc6_:int = 0;
         while(_loc6_ < param2)
         {
            _loc7_ = new Bitmap(param1,PixelSnapping.NEVER,true);
            _loc7_.x = _loc6_ * _loc5_;
            _loc7_.y = Math.random() * param3;
            _loc8_ = 0.2 + Math.random();
            _loc7_.scaleX = _loc8_;
            _loc7_.scaleY = _loc8_;
            _loc7_.blendMode = BlendMode.ADD;
            addChild(_loc7_);
            this.motes.push(_loc7_);
            _loc6_++;
         }
      }
      
      public function update() : void
      {
         var _loc4_:Bitmap = null;
         _loc4_ = null;
         var _loc1_:Number = this.bottom / 3;
         var _loc2_:Number = _loc1_ + _loc1_;
         var _loc3_:int = 0;
         while(_loc3_ < this.count)
         {
            _loc4_ = this.motes[_loc3_];
            _loc4_.y += 2;
            if(_loc4_.y > this.bottom)
            {
               _loc4_.y = 0;
            }
            if(_loc4_.y < _loc1_)
            {
               _loc4_.alpha = _loc4_.y / _loc1_;
            }
            else if(_loc4_.y < _loc2_)
            {
               _loc4_.alpha = 1;
            }
            else
            {
               _loc4_.alpha = 1 - (_loc4_.y - _loc2_) / _loc1_;
            }
            _loc3_++;
         }
      }
   }
}
