package controls.slider
{
   import assets.slider.slider_THUMB_CENTER;
   import assets.slider.slider_THUMB_LEFT;
   import assets.slider.slider_THUMB_RIGHT;
   import flash.display.Graphics;
   import flash.display.Sprite;
   import flash.geom.Matrix;
   
   public class SliderThumb extends Sprite
   {
       
      
      protected var thumb_bmpLeft:slider_THUMB_LEFT;
      
      protected var thumb_bmpCenter:slider_THUMB_CENTER;
      
      protected var thumb_bmpRight:slider_THUMB_RIGHT;
      
      protected var _width:int;
      
      public function SliderThumb()
      {
         this.thumb_bmpLeft = new slider_THUMB_LEFT(1,1);
         this.thumb_bmpCenter = new slider_THUMB_CENTER(1,1);
         this.thumb_bmpRight = new slider_THUMB_RIGHT(1,1);
         super();
         buttonMode = true;
      }
      
      override public function set width(w:Number) : void
      {
         this._width = w;
         this.draw();
      }
      
      protected function draw() : void
      {
         var matrix:Matrix = null;
         var g:Graphics = this.graphics;
         g.clear();
         g.beginBitmapFill(this.thumb_bmpLeft);
         g.drawRect(0,0,10,30);
         g.endFill();
         matrix = new Matrix();
         matrix.translate(10,0);
         g.beginBitmapFill(this.thumb_bmpCenter,matrix);
         g.drawRect(10,0,this._width - 20,30);
         g.endFill();
         matrix = new Matrix();
         matrix.translate(this._width - 10,0);
         g.beginBitmapFill(this.thumb_bmpRight,matrix);
         g.drawRect(this._width - 10,0,10,30);
         g.endFill();
      }
   }
}
