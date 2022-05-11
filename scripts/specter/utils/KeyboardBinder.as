package specter.utils
{
   import flash.display.InteractiveObject;
   import flash.events.KeyboardEvent;
   import flash.ui.Keyboard;
   
   public class KeyboardBinder
   {
       
      
      protected var keyBindings:Object;
      
      private var eventSource:InteractiveObject;
      
      public function KeyboardBinder(source:InteractiveObject)
      {
         super();
         this.eventSource = source;
         this.keyBindings = {};
      }
      
      public function enable() : void
      {
         this.eventSource.addEventListener(KeyboardEvent.KEY_DOWN,this.onKey);
         this.eventSource.addEventListener(KeyboardEvent.KEY_UP,this.onKey);
      }
      
      public function disable() : void
      {
         this.eventSource.removeEventListener(KeyboardEvent.KEY_DOWN,this.onKey);
         this.eventSource.removeEventListener(KeyboardEvent.KEY_UP,this.onKey);
      }
      
      private function onKey(e:KeyboardEvent) : void
      {
         var func:Function = this.keyBindings[e.keyCode];
         if(func != null)
         {
            func.call(this,e.type == KeyboardEvent.KEY_DOWN);
         }
      }
      
      public function bindKey(keyCode:uint, func:Function) : void
      {
         if(func != null)
         {
            this.keyBindings[keyCode] = func;
         }
      }
      
      public function bind(keyCode:String, func:Function) : void
      {
         if(func != null)
         {
            this.keyBindings[Keyboard[keyCode]] = func;
         }
      }
      
      public function unbindKey(keyCode:uint) : void
      {
         delete this.keyBindings[keyCode];
      }
      
      public function unbindAll() : void
      {
         var code:* = null;
         for(code in this.keyBindings)
         {
            delete this.keyBindings[code];
         }
      }
   }
}
