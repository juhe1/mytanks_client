package scpacker.networking.aes
{
   import alternativa.init.Main;
   import flash.display.Loader;
   import flash.events.Event;
   import flash.system.ApplicationDomain;
   import flash.system.LoaderContext;
   import flash.utils.ByteArray;
   import scpacker.gui.GTanksLoaderWindow;
   import scpacker.gui.IGTanksLoader;
   import scpacker.networking.INetworkListener;
   import scpacker.networking.Network;
   import scpacker.networking.commands.Command;
   import scpacker.networking.commands.Type;
   import scpacker.resource.cache.CacheURLLoader;
   import specter.utils.Logger;
   
   public class AESEncrypterModel implements INetworkListener
   {
       
      
      private var netwoker:Network;
      
      private var loader:Loader;
      
      public function AESEncrypterModel()
      {
         super();
      }
      
      public function onData(data:Command) : void
      {
         var aesBytes:ByteArray = null;
         var array:Array = null;
         var byte:String = null;
         var loaderContext:LoaderContext = null;
         if(data.type == Type.SYSTEM)
         {
            if(data.args[0] == "set_aes_data")
            {
               Logger.log("set_aes_data comming");
               try
               {
                  aesBytes = new ByteArray();
                  array = data.args[1].split(",");
                  for each(byte in array)
                  {
                     aesBytes.writeByte(parseInt(byte));
                  }
                  loaderContext = new LoaderContext(false,ApplicationDomain.currentDomain);
                  if(CacheURLLoader.isDesktop)
                  {
                     loaderContext.allowLoadBytesCodeExecution = true;
                  }
                  this.loader = new Loader();
                  this.loader.contentLoaderInfo.addEventListener(Event.COMPLETE,this.onAesLoadComplete);
                  this.loader.loadBytes(aesBytes,loaderContext);
               }
               catch(e:Error)
               {
                  Logger.warn("set_aes_data error: " + e.getStackTrace());
               }
               Logger.log("set_aes_data end");
            }
         }
      }
      
      private function onAesLoadComplete(e:Event) : void
      {
		 var aesClass:Class = this.loader.contentLoaderInfo.applicationDomain.getDefinition("Main") as Class;
		 this.netwoker.AESDecrypter = new aesClass();
         Logger.log("sdf " + this.netwoker.AESDecrypter);
         (Main.osgi.getService(IGTanksLoader) as GTanksLoaderWindow).hideLoaderWindow();
         (Main.osgi.getService(IGTanksLoader) as GTanksLoaderWindow).lockLoaderWindow();
         Authorization(Main.osgi.getService(IAuthorization)).init();
      }
      
      public function resourceLoaded(netwoker:Network) : void
      {
         this.netwoker = netwoker;
         netwoker.send("system;get_aes_data");
      }
   }
}
