package controls.slider
{
   import assets.slider.slider_TRACK_CENTER;
   import assets.slider.slider_TRACK_LEFT;
   import assets.slider.slider_TRACK_RIGHT;
   import flash.display.Graphics;
   import flash.display.Sprite;
   import flash.geom.Matrix;
   
   public class SliderTrack extends Sprite
   {
       
      
      protected var track_bmpLeft:slider_TRACK_LEFT;
      
      protected var track_bmpCenter:slider_TRACK_CENTER;
      
      protected var track_bmpRight:slider_TRACK_RIGHT;
      
      protected var _width:int;
      
      protected var _showTrack:Boolean;
      
      protected var _minValue:Number = 0;
      
      protected var _maxValue:Number = 100;
      
      protected var _tick:Number = 10;
      
      public function SliderTrack(showtrack:Boolean = true)
      {
         this.track_bmpLeft = new slider_TRACK_LEFT(1,1);
         this.track_bmpCenter = new slider_TRACK_CENTER(1,1);
         this.track_bmpRight = new slider_TRACK_RIGHT(1,1);
         super();
         this._showTrack = showtrack;
      }
      
      override public function set width(w:Number) : void
      {
         this._width = w;
         this.draw();
      }
      
      protected function draw() : void
      {
         var matrix:Matrix = null;
         var tickDelta:Number = NaN;
         var curTickX:Number = NaN;
         var g:Graphics = this.graphics;
         g.clear();
         g.beginBitmapFill(this.track_bmpLeft);
         g.drawRect(0,0,5,30);
         g.endFill();
         matrix = new Matrix();
         matrix.translate(5,0);
         g.beginBitmapFill(this.track_bmpCenter,matrix);
         g.drawRect(5,0,this._width - 11,30);
         g.endFill();
         matrix = new Matrix();
         matrix.translate(this._width - 6,0);
         g.beginBitmapFill(this.track_bmpRight,matrix);
         g.drawRect(this._width - 6,0,6,30);
         g.endFill();
         if(this._showTrack)
         {
            tickDelta = width / ((this._maxValue - this._minValue) / this._tick);
            curTickX = tickDelta;
            while(curTickX < this._width)
            {
               g.lineStyle(0,16777215,0.4);
               g.moveTo(curTickX,5);
               g.lineTo(curTickX,25);
               curTickX += tickDelta;
            }
         }
      }
      
      public function set minValue(minValue:Number) : void
      {
         this._minValue = minValue;
         this.draw();
      }
      
      public function set maxValue(maxValue:Number) : void
      {
         this._maxValue = maxValue;
         this.draw();
      }
      
      public function set tickInterval(tick:Number) : void
      {
         this._tick = tick;
         this.draw();
      }
   }
}
