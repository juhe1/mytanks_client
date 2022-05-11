package controls.slider
{
   import controls.Slider;
   import flash.events.Event;
   import flash.events.MouseEvent;
   
   public class SelectRank extends Slider
   {
       
      
      private var _minRang:int = 0;
      
      private var _maxRang:int = 0;
      
      private var _currentRang:int = 1;
      
      public var _maxRangRange:int = 27;
      
      private var sthumb:SelectRankThumb;
      
      protected var _thumbTick:Number;
      
      public function SelectRank()
      {
         this.sthumb = new SelectRankThumb();
         super();
         removeChild(track);
         track = new SliderTrack(false);
         addChild(track);
         removeChild(thumb);
         addChild(this.sthumb);
         _thumb_width = 36;
      }
      
      override protected function UnConfigUI(e:Event) : void
      {
         stage.removeEventListener(MouseEvent.MOUSE_UP,this.onMouseUp);
         stage.removeEventListener(MouseEvent.MOUSE_MOVE,this.dragThumb);
      }
      
      override protected function ConfigUI(e:Event) : void
      {
         this.sthumb.leftDrag.addEventListener(MouseEvent.MOUSE_DOWN,onMouseDown);
         this.sthumb.rightDrag.addEventListener(MouseEvent.MOUSE_DOWN,onMouseDown);
         this.sthumb.centerDrag.addEventListener(MouseEvent.MOUSE_DOWN,onMouseDown);
         stage.addEventListener(MouseEvent.MOUSE_UP,this.onMouseUp);
      }
      
      protected function checkMinRang() : void
      {
         if(this._minRang < _minValue)
         {
            this._minRang = _minValue;
         }
         else if(this._minRang < this._currentRang - this._maxRangRange)
         {
            this._minRang = this._currentRang - this._maxRangRange;
            this._maxRang = this._currentRang;
         }
         else if(this._minRang < this._maxRang - this._maxRangRange)
         {
            this._maxRang = this._minRang + this._maxRangRange;
         }
         else if(this._minRang > this._currentRang)
         {
            this._minRang = this._currentRang;
         }
      }
      
      protected function checkMaxRang() : void
      {
         if(this._maxRang > _maxValue)
         {
            this._maxRang = _maxValue;
         }
         else if(this._maxRang > this._currentRang + this._maxRangRange)
         {
            this._maxRang = this._currentRang + this._maxRangRange;
            this._minRang = this._currentRang;
         }
         else if(this._maxRang > this._minRang + this._maxRangRange)
         {
            this._minRang = this._maxRang - this._maxRangRange;
         }
         else if(this._maxRang < this._currentRang)
         {
            this._maxRang = this._currentRang;
         }
      }
      
      public function get minRang() : int
      {
         return this._minRang;
      }
      
      public function set minRang(minRang:int) : void
      {
         this._minRang = minRang;
      }
      
      public function get maxRang() : int
      {
         return this._maxRang;
      }
      
      public function set maxRang(maxRang:int) : void
      {
         this._maxRang = maxRang;
      }
      
      public function get currentRang() : int
      {
         return this._currentRang;
      }
      
      public function set currentRang(currentRang:int) : void
      {
         this._currentRang = currentRang;
         value = this._minRang = this._maxRang = this._currentRang;
      }
      
      override public function set width(w:Number) : void
      {
         super.width = w;
         var rz:int = _maxValue - _minValue;
         this._thumbTick = (_width + 2 - _thumb_width) / rz;
         this.drawThumb();
      }
      
      override protected function onMouseUp(e:MouseEvent) : void
      {
         if(e != null)
         {
            stage.removeEventListener(MouseEvent.MOUSE_MOVE,this.dragThumb);
         }
      }
      
      override protected function dragThumb(e:MouseEvent) : void
      {
         var leftFlag:Boolean = trgt.mouseX < curThumbX;
         var rightFlag:Boolean = trgt.mouseX > curThumbX;
         var maxMinRangFlag:Boolean = this._minRang < this._currentRang;
         var minMaxRangFlag:Boolean = this._maxRang > this._currentRang;
         var rz:int = 0;
         if(trgt == this.sthumb.leftDrag && (leftFlag || maxMinRangFlag))
         {
            this._minRang += int((this.sthumb.leftDrag.mouseX - curThumbX) / this._thumbTick);
            this.checkMinRang();
            this.checkMaxRang();
         }
         else if(trgt == this.sthumb.rightDrag && (rightFlag || minMaxRangFlag))
         {
            this._maxRang += int((this.sthumb.rightDrag.mouseX - curThumbX) / this._thumbTick);
            this.checkMinRang();
            this.checkMaxRang();
         }
         else if(trgt == this.sthumb.centerDrag && ((leftFlag || maxMinRangFlag) && (rightFlag || minMaxRangFlag)))
         {
            this._minRang += int((this.sthumb.centerDrag.mouseX - curThumbX) / this._thumbTick);
            this._maxRang += int((this.sthumb.centerDrag.mouseX - curThumbX) / this._thumbTick);
            if(this._minRang < _minValue)
            {
               rz = this._maxRang - this._minRang;
               this._minRang = _minValue;
               this._maxRang = _minValue + rz;
            }
            if(this._maxRang > _maxValue)
            {
               rz = this._maxRang - this._minRang;
               this._maxRang = _maxValue;
               this._minRang = this._maxRang - rz;
            }
            rz = this._maxRang - this._minRang;
            if(this._minRang > this._currentRang)
            {
               this._minRang = this._currentRang;
               this._maxRang = this._minRang + rz;
            }
            if(this._maxRang < this._currentRang)
            {
               this._maxRang = this._currentRang;
               this._minRang = this._maxRang - rz;
            }
         }
         this.drawThumb();
      }
      
      private function drawThumb() : void
      {
         var rz:int = this._maxRang - this._minRang;
         this.sthumb.width = _thumb_width + this._thumbTick * rz;
         this.sthumb.x = int(this._thumbTick * (this._minRang - _minValue));
         this.sthumb.minRang = this._minRang;
         this.sthumb.maxRang = this._maxRang;
      }
   }
}
