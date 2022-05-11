package alternativa.tanks.model.achievement
{
   public class Achievement
   {
      
      public static const FIRST_PURCHASE:Achievement = new Achievement(0,"FIRST_PURCHASE");
      
      public static const SET_EMAIL:Achievement = new Achievement(1,"SET_EMAIL");
       
      
      private var _value:int;
      
      private var _name:String;
      
      public function Achievement(value:int, name:String)
      {
         super();
         this._value = value;
         this._name = name;
      }
      
      public static function get values() : Vector.<Achievement>
      {
         var values:Vector.<Achievement> = new Vector.<Achievement>();
         values.push(FIRST_PURCHASE);
         values.push(SET_EMAIL);
         return values;
      }
      
      public static function getById(id:int) : Achievement
      {
         if(id == 0)
         {
            return FIRST_PURCHASE;
         }
         return SET_EMAIL;
      }
      
      public function toString() : String
      {
         return "Achievement [" + this._name + "]";
      }
      
      public function get value() : int
      {
         return this._value;
      }
      
      public function get name() : String
      {
         return this._name;
      }
   }
}
