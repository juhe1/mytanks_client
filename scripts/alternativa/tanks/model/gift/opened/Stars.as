package alternativa.tanks.model.gift.opened
{
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.BlendMode;
   import flash.display.PixelSnapping;
   import flash.display.Sprite;
   import flash.geom.ColorTransform;
   
   public class Stars extends Sprite
   {
       
      
      private var stars:Array;
      
      private var count:int;
      
      private var radius:Number;
      
      public function Stars(param1:BitmapData, param2:BitmapData, param3:int, param4:Number)
      {
         var _loc6_:Sprite = null;
         var _loc7_:Number = NaN;
         _loc6_ = null;
         _loc7_ = NaN;
         var _loc8_:Number = NaN;
         var _loc9_:Number = NaN;
         this.stars = new Array();
         super();
         this.count = param3;
         this.radius = param4;
         var _loc5_:int = 0;
         while(_loc5_ < param3)
         {
            _loc6_ = new Sprite();
            _loc6_.addChild(new Bitmap(param1,PixelSnapping.NEVER,true));
            _loc6_.addChild(new Bitmap(param2,PixelSnapping.NEVER,true));
            _loc7_ = 0.4 + Math.random();
            _loc6_.getChildAt(0).scaleX = _loc7_;
            _loc6_.getChildAt(0).scaleY = _loc7_;
            _loc6_.getChildAt(0).x = -_loc6_.getChildAt(0).width / 2;
            _loc6_.getChildAt(0).y = -_loc6_.getChildAt(0).height / 2;
            _loc6_.getChildAt(0).blendMode = BlendMode.ADD;
            _loc6_.getChildAt(1).scaleX = _loc7_;
            _loc6_.getChildAt(1).scaleY = _loc7_;
            _loc6_.getChildAt(1).x = -_loc6_.getChildAt(1).width / 2;
            _loc6_.getChildAt(1).y = -_loc6_.getChildAt(1).height / 2;
            addChild(_loc6_);
            this.stars.push(_loc6_);
            _loc8_ = Math.random() * Math.PI * 2;
            _loc9_ = param4 / 3 + Math.random() * param4 * 2 / 3;
            _loc6_.x = Math.cos(_loc8_) * _loc9_;
            _loc6_.y = Math.sin(_loc8_) * _loc9_;
            if(_loc5_ == 0)
            {
               _loc6_.x = 0;
               _loc6_.y = 0;
            }
            _loc6_.rotation = Math.random() * 180;
            _loc5_++;
         }
      }
      
      public function update() : void
      {
         var _loc4_:Sprite = null;
         var _loc1_:Number = NaN;
         var _loc2_:Number = NaN;
         _loc4_ = null;
         var _loc3_:int = 0;
         while(_loc3_ < this.count)
         {
            _loc4_ = this.stars[_loc3_];
            _loc4_.rotation += 2;
            if(_loc4_.rotation > 180)
            {
               _loc4_.rotation = 0;
            }
            if(_loc4_.rotation < 90)
            {
               _loc1_ = _loc4_.rotation / 90;
            }
            else
            {
               _loc1_ = 1 - (_loc4_.rotation - 90) / 90;
            }
            _loc2_ = 0.2 + 0.8 * _loc1_;
            _loc4_.alpha = _loc1_;
            _loc4_.scaleX = _loc2_;
            _loc4_.scaleY = _loc2_;
            _loc3_++;
         }
      }
      
      public function colorize(param1:ColorTransform) : void
      {
         var _loc3_:Sprite = null;
         var _loc2_:int = 0;
         while(_loc2_ < this.count)
         {
            _loc3_ = this.stars[_loc2_];
            _loc3_.getChildAt(0).transform.colorTransform = param1;
            _loc2_++;
         }
      }
   }
}
