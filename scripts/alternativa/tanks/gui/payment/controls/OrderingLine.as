package alternativa.tanks.gui.payment.controls
{
   import alternativa.tanks.gui.icons.CrystalIcon;
   import controls.base.LabelBase;
   import flash.display.Bitmap;
   import flash.display.Sprite;
   import flash.text.TextFieldAutoSize;
   import flash.text.TextFormatAlign;
   
   public class OrderingLine extends Sprite
   {
       
      
      protected var _width:Number;
      
      protected var descriptionLabel:LabelBase;
      
      protected var crystalsLabel:LabelBase;
      
      protected var crystalsIcon:Bitmap;
      
      public function OrderingLine(param1:String, param2:int)
      {
         super();
         this.descriptionLabel = this.createLabel(param1);
         addChild(this.descriptionLabel);
         this.crystalsLabel = this.createLabel(param2.toString());
         addChild(this.crystalsLabel);
         this.crystalsIcon = CrystalIcon.createSmallInstance();
         this.crystalsIcon.y = 4;
         addChild(this.crystalsIcon);
      }
      
      private function createLabel(param1:String) : LabelBase
      {
         var _loc2_:LabelBase = null;
         _loc2_ = new LabelBase();
         _loc2_.autoSize = TextFieldAutoSize.LEFT;
         _loc2_.wordWrap = false;
         _loc2_.multiline = true;
         _loc2_.align = TextFormatAlign.LEFT;
         _loc2_.text = param1;
         _loc2_.size = 12;
         _loc2_.color = 5898034;
         return _loc2_;
      }
      
      override public function set width(param1:Number) : void
      {
         this._width = param1;
         var _loc2_:Number = this.crystalsLabel.width + this.crystalsIcon.width;
         this.crystalsLabel.x = this._width - _loc2_;
         this.crystalsIcon.x = this.crystalsLabel.x + this.crystalsLabel.width;
      }
   }
}
