package alternativa.tanks.models.effects.common.bonuscommon
{
   public class ObjectCache
   {
       
      
      private var size:int;
      
      private var objects:Vector.<Object>;
      
      public function ObjectCache()
      {
         super();
         this.objects = new Vector.<Object>();
      }
      
      public function put(object:Object) : void
      {
         var key:* = this.size++;
         this.objects[key] = object;
      }
      
      public function get() : Object
      {
         if(this.isEmpty())
         {
            throw new Error();
         }
         --this.size;
         var object:Object = this.objects[this.size];
         this.objects[this.size] = null;
         return object;
      }
      
      public function isEmpty() : Boolean
      {
         return this.size == 0;
      }
   }
}
