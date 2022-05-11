package alternativa.tanks.models.dom.hud.panel
{
   import alternativa.tanks.display.SquareSectorIndicator;
   import alternativa.tanks.models.dom.Point;
   import controls.Label;
   import flash.display.Sprite;
   import flash.geom.ColorTransform;
   
   public class KeyPointHUDIndicator extends Sprite
   {
      
      private static const SIZE:int = 36;
      
      private static const FONT_COLOR_RED:uint = 16742221;
      
      private static const FONT_COLOR_BLUE:uint = 4760319;
      
      private static const FONT_COLOR_NEUTRAL:uint = 16777215;
      
      private static const BG_COLOR_RED:uint = 9249024;
      
      private static const BG_COLOR_BLUE:uint = 16256;
       
      
      private var point:Point;
      
      private var label:Label;
      
      private var progressIndicator:SquareSectorIndicator;
      
      private var score:Number = 0;
      
      public function KeyPointHUDIndicator(param1:Point)
      {
         super();
         this.point = param1;
         this.createProgressIndicator();
         this.createLabel();
         this.update();
      }
      
      public static function getColor(param1:int) : uint
      {
         if(param1 >= 100)
         {
            return FONT_COLOR_BLUE;
         }
         if(param1 <= -100)
         {
            return FONT_COLOR_RED;
         }
         return FONT_COLOR_NEUTRAL;
      }
      
      private function createProgressIndicator() : void
      {
         this.progressIndicator = new SquareSectorIndicator(SIZE,0,0,0);
         addChild(this.progressIndicator);
      }
      
      private function createLabel() : void
      {
         this.label = new Label();
         this.label.size = 18;
         this.label.bold = true;
         this.label.color = getColor(this.point.clientProgress);
         this.label.text = this.point.id == 0 ? "A" : (this.point.id == 1 ? "B" : (this.point.id == 2 ? "C" : (this.point.id == 3 ? "D" : (this.point.id == 4 ? "E" : (this.point.id == 5 ? "F" : "G")))));
      }
      
      public function getLabel() : Label
      {
         return this.label;
      }
      
      public function update() : void
      {
         this.updateScore();
         this.updateVisibility();
      }
      
      private function updateVisibility() : void
      {
         this.label.visible = true;
         this.progressIndicator.visible = true;
      }
      
      private function setColorOffset(param1:uint) : void
      {
         var _loc2_:ColorTransform = this.progressIndicator.transform.colorTransform;
         _loc2_.redOffset = param1;
         _loc2_.greenOffset = param1;
         _loc2_.blueOffset = param1;
         this.progressIndicator.transform.colorTransform = _loc2_;
      }
      
      private function getLabelColor() : uint
      {
         if(this.point.clientProgress >= 100)
         {
            return FONT_COLOR_BLUE;
         }
         if(this.point.clientProgress <= -100)
         {
            return FONT_COLOR_RED;
         }
         return FONT_COLOR_NEUTRAL;
      }
      
      private function updateScore() : void
      {
         if(this.score != this.point.clientProgress)
         {
            this.score = this.point.clientProgress;
            if(this.score < 0)
            {
               this.progressIndicator.setColor(BG_COLOR_RED,1);
            }
            else if(this.score > 0)
            {
               this.progressIndicator.setColor(BG_COLOR_BLUE,1);
            }
            else
            {
               this.progressIndicator.setColor(0,0);
            }
            this.label.color = this.getLabelColor();
            this.progressIndicator.setProgress(Math.abs(this.score) / 100);
         }
      }
      
      [Obfuscation(rename="false")]
      override public function get width() : Number
      {
         return SIZE;
      }
      
      [Obfuscation(rename="false")]
      override public function get height() : Number
      {
         return SIZE;
      }
   }
}
