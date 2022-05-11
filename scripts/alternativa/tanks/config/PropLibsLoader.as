package alternativa.tanks.config
{
   import alternativa.proplib.PropLibRegistry;
   import alternativa.utils.TaskSequence;
   import flash.events.Event;
   
   public class PropLibsLoader extends ResourceLoader
   {
       
      
      private var libRegistry:PropLibRegistry;
      
      private var sequence:TaskSequence;
      
      public function PropLibsLoader(config:Config)
      {
         this.libRegistry = new PropLibRegistry();
         super("Props library loader",config);
      }
      
      override public function run() : void
      {
         var lib:Object = null;
         var libPath:Object = null;
         this.sequence = new TaskSequence();
         var jsonParser:Object = JSON.parse(config.json);
         for each(lib in jsonParser.items)
         {
            if(lib.name == config.map.mapId + ".xml")
            {
               for each(libPath in lib.libs)
               {
                  this.sequence.addTask(new PropLibLoadingTask(libPath as String,this.libRegistry));
                  trace("load lib: " + libPath);
               }
            }
         }
         this.sequence.addEventListener(Event.COMPLETE,this.onProplobsLoadingComplete);
         this.sequence.run();
      }
      
      private function onProplobsLoadingComplete(e:Event) : void
      {
         this.sequence = null;
         config.propLibRegistry = this.libRegistry;
         completeTask();
      }
   }
}

import alternativa.proplib.PropLibRegistry;
import alternativa.proplib.PropLibrary;
import alternativa.utils.TARAParser;
import alternativa.utils.Task;
import flash.events.Event;
import flash.net.URLLoaderDataFormat;
import flash.net.URLRequest;
import scpacker.resource.cache.CacheURLLoader;
import specter.utils.Logger;

class PropLibLoadingTask extends Task
{
    
   
   private var url:String;
   
   private var libRegistry:PropLibRegistry;
   
   private var loader:CacheURLLoader;
   
   function PropLibLoadingTask(url:String, libRegistry:PropLibRegistry)
   {
      super();
      this.url = url;
      this.libRegistry = libRegistry;
   }
   
   override public function run() : void
   {
      this.loader = new CacheURLLoader();
      this.loader.dataFormat = URLLoaderDataFormat.BINARY;
      this.loader.addEventListener(Event.COMPLETE,this.onLoadingComplete);
      this.loader.load(new URLRequest(this.url));
   }
   
   private function onLoadingComplete(event:Event) : void
   {
      var propLibrary:PropLibrary = new PropLibrary(TARAParser.parse(this.loader.data));
      this.libRegistry.addLibrary(propLibrary);
      completeTask();
      Logger.log("Loaded prop: " + this.url);
   }
}
