package scpacker.resource.listener
{
   import flash.utils.Dictionary;
   
   public class ResourceLoaderListener
   {
      
      public static var listeners:Vector.<Function> = new Vector.<Function>();
      
      private static var isCalled:Dictionary = new Dictionary();
       
      
      public function ResourceLoaderListener()
      {
         super();
      }
      
      public static function addEventListener(fun:Function) : void
      {
         listeners.push(fun);
      }
      
      public static function loadedComplete() : void
      {
         var resource:Function = null;
         for each(resource in listeners)
         {
            resource.call();
            isCalled[resource] = true;
         }
      }
      
      public static function removeListener(f:Function) : void
      {
         var l:Function = null;
         for each(l in listeners)
         {
            if(l == f)
            {
               listeners.removeAt(listeners.indexOf(l));
               l = null;
            }
         }
      }
      
      public static function clearListeners(safely:Boolean = true) : void
      {
         var l:* = undefined;
         for each(l in listeners)
         {
            if(isCalled[l])
            {
               isCalled[l] = null;
            }
            else if(safely)
            {
               l.call();
            }
            listeners.removeAt(listeners.indexOf(l));
            l = null;
         }
         isCalled = new Dictionary();
         listeners = new Vector.<Function>();
      }
   }
}
