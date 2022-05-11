package alternativa.tanks.models.sfx
{
   public class LightingEffectRecord
   {
       
      
      private var _attenuationBegin:Number;
      
      private var _attenuationEnd:Number;
      
      private var _color:uint;
      
      private var _intensity:Number;
      
      private var _time:int;
      
      public function LightingEffectRecord(_attenuationBegin:Number = 0, _attenuationEnd:Number = 0, _color:uint = 0, _intensity:Number = 0, _time:int = 0)
      {
         super();
         this._attenuationBegin = _attenuationBegin;
         this._attenuationEnd = _attenuationEnd;
         this._color = _color;
         this._intensity = _intensity;
         this._time = _time;
      }
      
      public function get attenuationBegin() : Number
      {
         return this._attenuationBegin;
      }
      
      public function set attenuationBegin(param1:Number) : void
      {
         this._attenuationBegin = param1;
      }
      
      public function get attenuationEnd() : Number
      {
         return this._attenuationEnd;
      }
      
      public function set attenuationEnd(param1:Number) : void
      {
         this._attenuationEnd = param1;
      }
      
      public function get color() : uint
      {
         return this._color;
      }
      
      public function set color(param1:uint) : void
      {
         this._color = param1;
      }
      
      public function get intensity() : Number
      {
         return this._intensity;
      }
      
      public function set intensity(param1:Number) : void
      {
         this._intensity = param1;
      }
      
      public function get time() : int
      {
         return this._time;
      }
      
      public function set time(param1:int) : void
      {
         this._time = param1;
      }
      
      public function toString() : String
      {
         var _loc1_:String = "LightingEfectRecord [";
         _loc1_ += "attenuationBegin = " + this.attenuationBegin + " ";
         _loc1_ += "attenuationEnd = " + this.attenuationEnd + " ";
         _loc1_ += "color = " + this.color + " ";
         _loc1_ += "intensity = " + this.intensity + " ";
         _loc1_ += "time = " + this.time + " ";
         return _loc1_ + "]";
      }
   }
}
