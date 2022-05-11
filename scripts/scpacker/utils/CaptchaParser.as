package scpacker.utils
{
   import flash.display.Bitmap;
   import flash.display.Loader;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.utils.ByteArray;
   
   public class CaptchaParser
   {
       
      
      public function CaptchaParser()
      {
         super();
      }
      
      public static function parse(packet:String, onBitmapParsedHandler:Function) : void
      {
         var loader:Loader = null;
         var byte:String = null;
         loader = null;
         var byteArray:ByteArray = new ByteArray();
         var i:int = 0;
         var bytes:Array = packet.split(",");
         for each(byte in bytes)
         {
            byteArray.writeByte(parseInt(byte));
            i++;
         }
         loader = new Loader();
         loader.contentLoaderInfo.addEventListener(Event.COMPLETE,function(param1:Event):void
         {
            onBitmapParsedHandler.apply(null,[loader.content as Bitmap]);
            (param1.target as EventDispatcher).removeEventListener(param1.type,arguments.callee);
         });
         loader.loadBytes(byteArray);
      }
   }
}
