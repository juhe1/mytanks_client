package alternativa.tanks.config
{
   import alternativa.proplib.PropLibRegistry;
   import alternativa.utils.TaskSequence;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import specter.utils.Logger;
   
   [Event(name="complete",type="flash.events.Event")]
   public class Config extends EventDispatcher
   {
       
      
      public var json:String;
      
      public var map:TanksMap;
      
      public var propLibRegistry:PropLibRegistry;
      
      private var taskSequence:TaskSequence;
      
      public function Config()
      {
         super();
      }
      
      public function load(url:String, mapId:String) : void
      {
         Logger.log("Loading map config");
         this.taskSequence = new TaskSequence();
         this.taskSequence.addTask(new ConfigXMLLoader(url,this));
         this.taskSequence.addTask(new PropLibsLoader(this));
         this.map = new TanksMap(this,mapId);
         this.taskSequence.addTask(this.map);
         this.taskSequence.addEventListener(Event.COMPLETE,this.onSequenceComplete);
         this.taskSequence.run();
      }
      
      private function onSequenceComplete(event:Event) : void
      {
         this.taskSequence = null;
         dispatchEvent(new Event(Event.COMPLETE));
      }
   }
}

import alternativa.tanks.config.Config;
import alternativa.utils.Task;
import flash.events.Event;
import flash.net.URLLoader;
import flash.net.URLLoaderDataFormat;
import flash.net.URLRequest;
import specter.utils.Logger;

class ConfigXMLLoader extends Task
{
    
   
   private var config:Config;
   
   private var loader:URLLoader;
   
   private var url:String;
   
   function ConfigXMLLoader(url:String, config:Config)
   {
      super();
      this.url = url;
      this.config = config;
   }
   
   override public function run() : void
   {
      Logger.log("Loading map config from: " + this.url);
      this.loader = new URLLoader();
      this.loader.dataFormat = URLLoaderDataFormat.TEXT;
      this.loader.addEventListener(Event.COMPLETE,this.onLoadingComplete);
      this.loader.load(new URLRequest(this.url));
   }
   
   private function onLoadingComplete(event:Event) : void
   {
      this.config.json = String(this.loader.data);
      this.loader = null;
      completeTask();
      Logger.log("Loaded map config");
   }
}
