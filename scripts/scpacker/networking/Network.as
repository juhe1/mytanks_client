package scpacker.networking
{
   import alternativa.init.Main;
   import alternativa.osgi.service.alert.IAlertService;
   import alternativa.tanks.bg.IBackgroundService;
   import flash.events.Event;
   import flash.events.IOErrorEvent;
   import flash.events.ProgressEvent;
   import flash.events.SecurityErrorEvent;
   import flash.net.Socket;
   import flash.utils.ByteArray;
   import specter.utils.Logger;
   
   public class Network extends NetworkService
   {
       
      
      private var socket:Socket;
      
      private var keys:Array;
      
      private var lastKey:int = 1;
      
      public var AESDecrypter;
      
      public var AESKey:String = "F54BF833E76C15A12B7977CF5858FB96";
      
      public var iv:int = 1;
      
      public var connectionListener:Function;
      
      public function Network()
      {
         this.keys = new Array(1,2,3,4,5,6,7,8,9);
         super();
         this.socket = new Socket();
      }
      
      public function connect(ip:String, port:int) : void
      {
         this.socket.connect(ip,port);
         this.socket.addEventListener(ProgressEvent.SOCKET_DATA,this.onDataSocket);
         this.socket.addEventListener(Event.CONNECT,this.onConnected);
         this.socket.addEventListener(Event.CLOSE,this.onCloseConnecting);
         this.socket.addEventListener(IOErrorEvent.IO_ERROR,this.ioError);
         this.socket.addEventListener(SecurityErrorEvent.SECURITY_ERROR,this.securityError);
      }
      
      public function destroy() : void
      {
         this.socket.removeEventListener(ProgressEvent.SOCKET_DATA,this.onDataSocket);
         this.socket.removeEventListener(Event.CONNECT,this.onConnected);
         this.socket.removeEventListener(Event.CLOSE,this.onCloseConnecting);
         this.socket.removeEventListener(IOErrorEvent.IO_ERROR,this.ioError);
         this.socket.removeEventListener(SecurityErrorEvent.SECURITY_ERROR,this.securityError);
      }
      
      public function addEventListener(listener:INetworkListener) : void
      {
         addListener(listener);
      }
      
      public function removeEventListener(listener:INetworkListener) : void
      {
         removeListener(listener);
      }
      
      public function send(str:String) : void
      {
         try
         {
            var str:String = this.AESDecrypter == null ? this.crypt(str) : this.AESDecrypter.encrypt(str,this.AESKey);
            str += DELIM_COMMANDS_SYMBOL;
            this.socket.writeUTFBytes(str);
            this.socket.flush();
         }
         catch(e:Error)
         {
            Logger.warn("Error sending: " + e.message + "\n" + e.getStackTrace());
         }
      }
      
      private function crypt(request:String) : String
      {
         var key:int = (this.lastKey + 1) % this.keys.length;
         if(key <= 0)
         {
            key = 1;
         }
         this.lastKey = key;
         var _array:Array = request.split("");
         for(var i:int = 0; i < request.length; i++)
         {
            _array[i] = String.fromCharCode(request.charCodeAt(i) + (key + 1));
         }
         return key + _array.join("");
      }
      
      private function onConnected(e:Event) : void
      {
         if(this.connectionListener != null)
         {
            this.connectionListener.call();
         }
         Logger.log("onConnected()");
      }
      
      private function onDataSocket(e:Event) : void
      {
         var bytes:ByteArray = new ByteArray();
         var size:int = this.socket.bytesAvailable;
         this.socket.readBytes(bytes,0,size);
         var data:String = bytes.readUTFBytes(size);
         protocolDecrypt(data,this);
         bytes.clear();
         this.socket.flush();
      }
      
      private function onCloseConnecting(e:Event) : void
      {
         Logger.log("onCloseConnecting()");
         this.socket.close();
         var alertService:IAlertService = Main.osgi.getService(IAlertService) as IAlertService;
         alertService.showAlert("Connection closed by server!");
         for(var i:int = 0; i < Main.mainContainer.numChildren; i++)
         {
            Main.mainContainer.removeChildAt(1);
         }
         IBackgroundService(Main.osgi.getService(IBackgroundService)).drawBg();
         IBackgroundService(Main.osgi.getService(IBackgroundService)).showBg();
      }
      
      private function ioError(e:Event) : void
      {
         Logger.warn("IO error!");
         this.socket.close();
         var alertService:IAlertService = Main.osgi.getService(IAlertService) as IAlertService;
         alertService.showAlert("Connection to server " + "failed");
         for(var i:int = 0; i < Main.mainContainer.numChildren; i++)
         {
            Main.mainContainer.removeChildAt(1);
         }
         IBackgroundService(Main.osgi.getService(IBackgroundService)).drawBg();
         IBackgroundService(Main.osgi.getService(IBackgroundService)).showBg();
      }
      
      private function securityError(e:Event) : void
      {
         Logger.warn("Security error!");
         this.socket.close();
         var alertService:IAlertService = Main.osgi.getService(IAlertService) as IAlertService;
         alertService.showAlert("Connection to server " + "failed");
         for(var i:int = 0; i < Main.mainContainer.numChildren; i++)
         {
            Main.mainContainer.removeChildAt(1);
         }
         IBackgroundService(Main.osgi.getService(IBackgroundService)).drawBg();
         IBackgroundService(Main.osgi.getService(IBackgroundService)).showBg();
      }
      
      public function socketConnected() : Boolean
      {
         return this.socket.connected;
      }
   }
}
