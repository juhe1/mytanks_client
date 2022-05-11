package alternativa.tanks.models.dom.hud
{
   import alternativa.math.Vector3;
   import alternativa.tanks.models.dom.Point;
   import alternativa.tanks.models.dom.sfx.PointState;
   import flash.display.Bitmap;
   import flash.display.DisplayObject;
   import flash.display.PixelSnapping;
   import flash.display.Sprite;
   import utils.SectorMask;
   
   public class KeyPointMarker extends Sprite
   {
       
      
      private var point:Point;
      
      private var imageBlue:Bitmap;
      
      private var imageRed:Bitmap;
      
      private var sectorMask:SectorMask;
      
      private var score:Number = 0;
      
      private var container:Sprite;
      
      public function KeyPointMarker(point:Point)
      {
         super();
         this.point = point;
         this.container = new Sprite();
         this.createImages();
      }
      
      private static function createMarkerBitmap(param1:PointState) : Bitmap
      {
         return new Bitmap(MarkerBitmaps.getMarkerBitmapData(param1),PixelSnapping.AUTO,true);
      }
      
      private function createImages() : void
      {
         this.imageBlue = createMarkerBitmap(PointState.BLUE);
         this.imageRed = createMarkerBitmap(PointState.RED);
         addChild(createMarkerBitmap(PointState.NEUTRAL));
         addChild(this.container);
         this.sectorMask = new SectorMask(this.imageBlue.width);
         this.container.addChild(this.sectorMask);
         addChild(new Bitmap(MarkerBitmaps.getLetterImage(this.point.id == 0 ? "A" : (this.point.id == 1 ? "B" : (this.point.id == 2 ? "C" : (this.point.id == 3 ? "D" : (this.point.id == 4 ? "E" : (this.point.id == 5 ? "F" : "G"))))))));
         this.paintItGray();
         this.setScore(45);
      }
      
      public function update() : void
      {
         this.setScore(this.point.clientProgress);
      }
      
      private function setScore(param1:Number) : void
      {
         var _loc2_:Number = NaN;
         if(param1 < -100)
         {
            param1 = -100;
         }
         else if(param1 > 100)
         {
            param1 = 100;
         }
         if(this.score != param1)
         {
            if(param1 == 0)
            {
               this.paintItGray();
            }
            else
            {
               _loc2_ = Math.abs(param1) / 100;
               this.sectorMask.setProgress(1 - _loc2_,1);
               if(param1 < 0)
               {
                  this.paintItRed();
               }
               else if(param1 > 0)
               {
                  this.paintItBlue();
               }
            }
            this.score = param1;
         }
      }
      
      public function readPosition3D(param1:Vector3) : void
      {
         this.point.readPos(param1);
      }
      
      private function paintItGray() : void
      {
         this.container.visible = false;
      }
      
      private function paintItRed() : void
      {
         this.container.visible = true;
         this.swapObjects(this.imageBlue,this.imageRed);
         this.container.mask = this.sectorMask;
      }
      
      private function paintItBlue() : void
      {
         this.container.visible = true;
         this.swapObjects(this.imageRed,this.imageBlue);
         this.container.mask = this.sectorMask;
      }
      
      private function swapObjects(param1:DisplayObject, param2:DisplayObject) : void
      {
         if(param2.parent == null)
         {
            if(param1.parent != null)
            {
               this.container.removeChild(param1);
            }
            this.container.addChild(param2);
         }
      }
   }
}
