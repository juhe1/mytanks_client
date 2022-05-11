package alternativa.utils
{
   import flash.utils.ByteArray;
   
   public class ByteArrayMap
   {
       
      
      private var _data:Object;
      
      public function ByteArrayMap(data:Object = null)
      {
         super();
         this._data = data == null ? {} : data;
      }
      
      public function get data() : Object
      {
         return this._data;
      }
      
      public function set data(o:Object) : void
      {
         this._data = o;
      }
      
      public function getValue(key:String) : ByteArray
      {
         return this._data[key];
      }
      
      public function putValue(key:String, value:ByteArray) : void
      {
         this._data[key] = value;
      }
      
      public function destroy() : *
      {
         var key:ByteArray = null;
         for each(key in this._data)
         {
            key.clear();
            key = null;
         }
         this._data = null;
      }
   }
}
