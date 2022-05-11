package scpacker.resource
{
   import alternativa.init.Main;
   import flash.events.Event;
   import flash.events.IOErrorEvent;
   import flash.events.SecurityErrorEvent;
   import flash.media.Sound;
   import flash.media.SoundLoaderContext;
   import flash.net.URLLoader;
   import flash.net.URLRequest;
   import scpacker.resource.cache.SoundCacheLoader;
   
   public class SoundResourceLoader
   {
       
      
      private var path:String;
      
      public var list:SoundResourcesList;
      
      public var status:int = 0;
      
      public function SoundResourceLoader(path:String)
      {
         super();
         this.path = path;
         this.list = new SoundResourcesList();
         this.load();
      }
      
      private function load() : void
      {
         var loader:URLLoader = new URLLoader();
         loader.addEventListener(Event.COMPLETE,this.parse);
         loader.load(new URLRequest(this.path));
      }
      
      private function parse(e:Event) : void
      {
         var config:Object = null;
         var temp:Object = null;
         var obj:Object = null;
         try
         {
            config = JSON.parse(e.target.data);
            if(config.id != "SOUNDS")
            {
               throw new Error("file dont sound\'s resource");
            }
            for each(obj in config.items)
            {
               temp = obj;
               this.loadSound(obj);
            }
            this.status = 1;
            ResourceUtil.onCompleteLoading();
         }
         catch(e:Error)
         {
            throw e;
         }
      }
      
      private function loadSound(configObject:Object) : void
      {
         var soundLoader:Sound = null;
         soundLoader = null;
         var prefix:String = !!Game.local ? "" : "resources/";
         soundLoader = new SoundCacheLoader();
         soundLoader.addEventListener(Event.COMPLETE,function(e:Event):void
         {
            list.add(new SoundResource(soundLoader,configObject.name));
         });
         soundLoader.addEventListener(IOErrorEvent.IO_ERROR,function(e:Event):void
         {
            Main.debug.showAlert("Can\'t load sound resource: " + configObject.src);
         });
         soundLoader.addEventListener(SecurityErrorEvent.SECURITY_ERROR,function(e:Event):void
         {
         });
         configObject.src = (configObject.src as String).split("?")[0];
         soundLoader.load(new URLRequest(prefix + configObject.src),new SoundLoaderContext());
      }
   }
}
