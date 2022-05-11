package scpacker.networking.connecting
{
   import alternativa.init.Main;
   import flash.events.Event;
   import flash.net.URLLoader;
   import flash.net.URLLoaderDataFormat;
   import flash.net.URLRequest;
   import scpacker.networking.INetworker;
   import scpacker.networking.Network;
   import specter.utils.Logger;
   
   public class ServerConnectionServiceImpl implements ServerConnectionService
   {
       
      
      private var loader:URLLoader;
      
      private var networker:Network;
      
      private var connectionListener:Function;
      
      public function ServerConnectionServiceImpl()
      {
         super();
      }
      
      public function connect(urlConfig:String, connectionListener:Function) : void
      {
         this.networker = new Network();
         this.connectionListener = connectionListener;
         this.networker.connectionListener = connectionListener;
         Logger.log("Created listener for connection");
         this.loader = new URLLoader();
         this.loader.dataFormat = URLLoaderDataFormat.TEXT;
         this.loader.addEventListener(Event.COMPLETE,this.onComplete);
         this.loader.load(new URLRequest(urlConfig));
      }
      
      private function onComplete(e:Event) : void
      {
         this.loader.removeEventListener(Event.COMPLETE,this.onComplete);
         var json:Object = JSON.parse(this.loader.data);
         var ip:String = json.ip;
         var port:int = json.port;
         this.networker.connect(ip,port);
         Logger.log("Connected to: " + ip + ":" + port);
         Main.osgi.registerService(INetworker,this.networker);
      }
   }
}
