package alternativa.debug
{
   import alternativa.init.Main;
   import alternativa.osgi.service.alert.IAlertService;
   import alternativa.osgi.service.console.IConsoleService;
   import alternativa.osgi.service.dump.IDumpService;
   import alternativa.service.IAddressService;
   import flash.display.DisplayObjectContainer;
   import flash.display.Shape;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.utils.Dictionary;
   import flash.utils.setInterval;
   
   public class Debug implements IDebugCommandProvider, IDebugCommandHandler, IAlertService
   {
      
      private static var errorWindow:ErrorWindow;
      
      private static var serverMessageWindow:ServerMessageWindow;
       
      
      private var _handlers:Dictionary;
      
      private var _commandList:Array;
      
      private var layer:DisplayObjectContainer;
      
      public function Debug()
      {
         super();
         this.layer = Main.noticesLayer;
         errorWindow = new ErrorWindow();
         serverMessageWindow = new ServerMessageWindow();
         this._handlers = new Dictionary();
         this._commandList = new Array();
         this.registerCommand("dump",this);
         this.registerCommand("hide",this);
         this.registerCommand("show",this);
         this.registerCommand("help",this);
         this.registerCommand("clear",this);
         this.registerCommand("spam",this);
         this.registerCommand("reload",this);
         this.registerCommand("getPath",this);
         var console:EventDispatcher = IConsoleService(Main.osgi.getService(IConsoleService)).console as EventDispatcher;
         if(console != null)
         {
            console.addEventListener(Event.COMPLETE,this.consoleCommand);
         }
         Main.stage.addEventListener(Event.RESIZE,this.onStageResize);
      }
      
      private function consoleCommand(e:Event) : void
      {
         var command:String = IConsoleService(Main.osgi.getService(IConsoleService)).console.getCommand();
         var result:String = this.executeCommand(command);
         if(result != null && result != "")
         {
            IConsoleService(Main.osgi.getService(IConsoleService)).writeToConsoleChannel("COMMAND",result);
         }
      }
      
      public function execute(command:String) : String
      {
         var result:String = null;
         var stringsArray:Array = null;
         var strings:Vector.<String> = null;
         var dumpService:IDumpService = null;
         var i:int = 0;
         stringsArray = command.split(" ");
         var name:String = stringsArray.shift();
         switch(name)
         {
            case "help":
               result = "\n";
               for(i = 0; i < this._commandList.length; i++)
               {
                  result += "\t  " + this._commandList[i] + "\n";
               }
               result += "\n";
               break;
            case "dump":
               strings = Vector.<String>(stringsArray);
               dumpService = IDumpService(Main.osgi.getService(IDumpService));
               if(dumpService != null)
               {
                  result = dumpService.dump(strings);
               }
               break;
            case "hide":
               IConsoleService(Main.osgi.getService(IConsoleService)).hideConsole();
               break;
            case "show":
               IConsoleService(Main.osgi.getService(IConsoleService)).showConsole();
               break;
            case "clear":
               IConsoleService(Main.osgi.getService(IConsoleService)).clearConsole();
               break;
            case "spam":
               setInterval(this.spam,25);
               break;
            case "reload":
               IAddressService(Main.osgi.getService(IAddressService)).reload();
               break;
            case "getPath":
               result = IAddressService(Main.osgi.getService(IAddressService)).getPath();
               break;
            default:
               result = "Unknown command";
         }
         return result;
      }
      
      private function spam() : void
      {
         var s:Shape = null;
         for(var i:int = 0; i < 3000; i++)
         {
            s = new Shape();
         }
      }
      
      public function executeCommand(command:String) : String
      {
         var result:String = null;
         var name:String = command.split(" ")[0];
         if(this._handlers[name] != null)
         {
            result = IDebugCommandHandler(this._handlers[name]).execute(command);
         }
         else
         {
            result = "Unknown command";
         }
         return result;
      }
      
      public function registerCommand(command:String, handler:IDebugCommandHandler) : void
      {
         this._handlers[command] = handler;
         this._commandList.push(command);
      }
      
      public function unregisterCommand(command:String) : void
      {
         this._commandList.splice(this._commandList.indexOf(command),1);
         delete this._handlers[command];
      }
      
      private function onStageResize(e:Event = null) : void
      {
         if(this.layer.contains(errorWindow))
         {
            errorWindow.x = Math.round((Main.stage.stageWidth - errorWindow.currentSize.x) * 0.5);
            errorWindow.y = Math.round((Main.stage.stageHeight - errorWindow.currentSize.y) * 0.5);
         }
         if(this.layer.contains(serverMessageWindow))
         {
            serverMessageWindow.x = Math.round((Main.stage.stageWidth - serverMessageWindow.currentSize.x) * 0.5);
            serverMessageWindow.y = Math.round((Main.stage.stageHeight - serverMessageWindow.currentSize.y) * 0.5);
         }
      }
      
      private function openWindow() : void
      {
         if(!this.layer.contains(errorWindow))
         {
            this.layer.addChild(errorWindow);
            this.onStageResize();
         }
      }
      
      private function closeWindow() : void
      {
         if(this.layer.contains(errorWindow))
         {
            this.layer.removeChild(errorWindow);
         }
      }
      
      public function showAlert(message:String) : void
      {
         this.showServerMessageWindow(message);
      }
      
      public function showErrorWindow(message:String) : void
      {
         errorWindow.text = message;
         this.openWindow();
      }
      
      public function hideErrorWindow() : void
      {
         this.closeWindow();
      }
      
      public function showServerMessageWindow(message:String) : void
      {
         serverMessageWindow.text = message;
         if(!this.layer.contains(serverMessageWindow))
         {
            this.layer.addChild(serverMessageWindow);
            this.onStageResize();
         }
      }
      
      public function hideServerMessageWindow() : void
      {
         if(this.layer.contains(serverMessageWindow))
         {
            this.layer.removeChild(serverMessageWindow);
         }
      }
   }
}
