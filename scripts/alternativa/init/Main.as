package alternativa.init
{
   import alternativa.console.Console;
   import alternativa.console.IConsole;
   import alternativa.debug.Debug;
   import alternativa.debug.dump.ClassDumper;
   import alternativa.debug.dump.ModelDumper;
   import alternativa.debug.dump.ObjectDumper;
   import alternativa.debug.dump.ResourceDumper;
   import alternativa.debug.dump.SpaceDumper;
   import alternativa.model.general.dispatcher.DispatcherModel;
   import alternativa.network.AlternativaNetworkClient;
   import alternativa.network.CommandSocket;
   import alternativa.network.command.ControlCommand;
   import alternativa.network.command.SpaceCommand;
   import alternativa.network.handler.ControlCommandHandler;
   import alternativa.osgi.bundle.IBundleActivator;
   import alternativa.osgi.service.alert.IAlertService;
   import alternativa.osgi.service.console.IConsoleService;
   import alternativa.osgi.service.debug.IDebugService;
   import alternativa.osgi.service.dump.IDumpService;
   import alternativa.osgi.service.loader.ILoaderService;
   import alternativa.osgi.service.loader.LoadingProgress;
   import alternativa.osgi.service.log.ILogService;
   import alternativa.osgi.service.log.LogLevel;
   import alternativa.osgi.service.mainContainer.IMainContainerService;
   import alternativa.osgi.service.network.INetworkService;
   import alternativa.osgi.service.storage.IStorageService;
   import alternativa.protocol.Protocol;
   import alternativa.protocol.codec.ClassCodec;
   import alternativa.protocol.codec.ControlRootCodec;
   import alternativa.protocol.codec.ResourceCodec;
   import alternativa.protocol.codec.SpaceRootCodec;
   import alternativa.protocol.factory.CodecFactory;
   import alternativa.protocol.factory.ICodecFactory;
   import alternativa.register.ClassInfo;
   import alternativa.register.ClassRegister;
   import alternativa.register.ModelsRegister;
   import alternativa.register.ResourceRegister;
   import alternativa.register.SpaceRegister;
   import alternativa.resource.ResourceInfo;
   import alternativa.resource.ResourceType;
   import alternativa.resource.ResourceWrapper;
   import alternativa.resource.factory.ImageResourceFactory;
   import alternativa.resource.factory.LibraryResourceFactory;
   import alternativa.resource.factory.MovieClipResourceFactory;
   import alternativa.resource.factory.SoundResourceFactory;
   import alternativa.service.AddressService;
   import alternativa.service.DummyLogService;
   import alternativa.service.IAddressService;
   import alternativa.service.IClassService;
   import alternativa.service.IModelService;
   import alternativa.service.IProtocolService;
   import alternativa.service.IResourceService;
   import alternativa.service.ISpaceService;
   import alternativa.service.Logger;
   import alternativa.service.ProtocolService;
   import alternativa.service.ServerLogService;
   import alternativa.tanks.loader.ILoaderWindowService;
   import alternativa.types.Long;
   import alternativa.types.LongFactory;
   import flash.display.DisplayObjectContainer;
   import flash.display.Stage;
   import flash.events.Event;
   import flash.net.SharedObject;
   import swfaddress.SWFAddressEvent;
   
   public class Main implements IBundleActivator
   {
      
      public static var stage:Stage;
      
      public static var mainContainer:DisplayObjectContainer;
      
      public static var backgroundLayer:DisplayObjectContainer;
      
      public static var contentLayer:DisplayObjectContainer;
      
      public static var contentUILayer:DisplayObjectContainer;
      
      public static var systemLayer:DisplayObjectContainer;
      
      public static var systemUILayer:DisplayObjectContainer;
      
      public static var dialogsLayer:DisplayObjectContainer;
      
      public static var noticesLayer:DisplayObjectContainer;
      
      public static var cursorLayer:DisplayObjectContainer;
      
      public static var controlHandler:ControlCommandHandler;
      
      public static var codecFactory:ICodecFactory;
      
      public static var loadingProgress:LoadingProgress;
      
      public static var debug:Debug;
      
      public static var osgi:OSGi;
      
      public static var currentPortIndex:int;
      
      public static var logger:ILogService;
      
      private static const SHOW_LOG_MSGS:String = "show_log_msgs";
      
      private static const SHOW_ALL_LOG_MSGS:String = "show_all_log_msgs";
      
      private static var controlSocket:CommandSocket;
      
      private static var networkClient:AlternativaNetworkClient;
       
      
      public function Main()
      {
         super();
      }
      
      public static function onMainLibrariesLoaded(loadedLibraries:Array) : void
      {
         var libraryWrapper:ResourceWrapper = null;
         var connectedPort:int = 0;
         var index:int = 0;
         var loadingProgressId:int = 0;
         var loaderService:ILoaderService = null;
         for(var i:int = 0; i < loadedLibraries.length; i++)
         {
            libraryWrapper = new ResourceWrapper(loadedLibraries[i]);
            IResourceService(Main.osgi.getService(IResourceService)).registerResource(libraryWrapper);
         }
         currentPortIndex = 0;
         var ports:Array = INetworkService(Main.osgi.getService(INetworkService)).ports;
         var storage:SharedObject = IStorageService(Main.osgi.getService(IStorageService)).getStorage();
         if(storage.data.port != null)
         {
            connectedPort = storage.data.port;
            index = ports.indexOf(connectedPort);
            if(index != -1)
            {
               ports.splice(index,1);
               ports.unshift(connectedPort);
            }
         }
         try
         {
            loadingProgressId = 0;
            loaderService = Main.osgi.getService(ILoaderService) as ILoaderService;
            loaderService.loadingProgress.startProgress(loadingProgressId);
            loaderService.loadingProgress.setStatus(loadingProgressId,"Connection to port " + ports[currentPortIndex]);
            controlSocket = networkClient.newConnection(ports[currentPortIndex],Main.controlHandler);
         }
         catch(e:Error)
         {
            Main.tryNextPort();
         }
         var showLogMessages:Boolean = stage.loaderInfo.parameters[SHOW_LOG_MSGS] != null;
         var showOnlyErrors:Boolean = stage.loaderInfo.parameters[SHOW_ALL_LOG_MSGS] == null;
         if(osgi.getService(IDebugService) != null)
         {
            logger = new ServerLogService(controlSocket,stage,!!showOnlyErrors ? [LogLevel.LOG_ERROR] : null);
         }
         else if(showLogMessages || !showOnlyErrors)
         {
            logger = new ServerLogService(controlSocket,stage,!!showOnlyErrors ? [LogLevel.LOG_ERROR] : null);
         }
         else
         {
            logger = new DummyLogService();
         }
      }
      
      public static function tryNextPort() : void
      {
         var loaderWindow:ILoaderWindowService = null;
         var alertService:IAlertService = null;
         writeVarsToConsoleChannel("NETWORK","tryNextPort");
         currentPortIndex += 1;
         writeVarsToConsoleChannel("NETWORK","   currentPortIndex: %1",currentPortIndex);
         var server:String = INetworkService(Main.osgi.getService(INetworkService)).server;
         var ports:Array = INetworkService(Main.osgi.getService(INetworkService)).ports;
         writeVarsToConsoleChannel("NETWORK","   currentPort: %1",ports[currentPortIndex]);
         var loaderService:ILoaderService = Main.osgi.getService(ILoaderService) as ILoaderService;
         var loadingProgressId:int = 0;
         loaderService.loadingProgress.setProgress(loadingProgressId,currentPortIndex * (1 / ports.length));
         if(ports[currentPortIndex] != null)
         {
            try
            {
               writeVarsToConsoleChannel("NETWORK","   newConnection to port %1",ports[currentPortIndex]);
               loaderService.loadingProgress.setStatus(loadingProgressId,"Connection to port " + ports[currentPortIndex]);
               controlSocket = networkClient.newConnection(ports[currentPortIndex],Main.controlHandler);
            }
            catch(e:Error)
            {
               Main.tryNextPort();
            }
         }
         else
         {
            loaderWindow = Main.osgi.getService(ILoaderWindowService) as ILoaderWindowService;
            loaderWindow.hideLoaderWindow();
            alertService = Main.osgi.getService(IAlertService) as IAlertService;
            alertService.showAlert("Connection to server " + server + " failed");
         }
      }
      
      public static function writeToConsole(message:String, color:uint = 0) : void
      {
      }
      
      public static function writeVarsToConsole(message:String, ... vars) : void
      {
         for(var i:int = 0; i < vars.length; i++)
         {
            message = message.replace("%" + (i + 1),vars[i]);
         }
      }
      
      public static function writeVarsToConsoleChannel(channel:String, message:String, ... vars) : void
      {
         for(var i:int = 0; i < vars.length; i++)
         {
            message = message.replace("%" + (i + 1),vars[i]);
         }
         Logger.log(1,message);
      }
      
      public static function hideConsole() : void
      {
         IConsoleService(Main.osgi.getService(IConsoleService)).hideConsole();
      }
      
      public static function showConsole() : void
      {
         IConsoleService(Main.osgi.getService(IConsoleService)).showConsole();
      }
      
      private static function onAddressChange(e:Event) : void
      {
      }
      
      public function start(_osgi:OSGi) : void
      {
         osgi = _osgi;
         osgi.registerService(IClassService,new ClassRegister());
         osgi.registerService(ISpaceService,new SpaceRegister());
         var modelsRegister:IModelService = new ModelsRegister();
         osgi.registerService(IModelService,modelsRegister);
         var resourceRegister:IResourceService = new ResourceRegister();
         osgi.registerService(IResourceService,resourceRegister);
         var addressService:IAddressService = new AddressService();
         osgi.registerService(IAddressService,addressService);
         if(addressService.getBaseURL() != "" && addressService.getBaseURL() != "undefined")
         {
            addressService.addEventListener(SWFAddressEvent.CHANGE,onAddressChange);
         }
         else
         {
            osgi.unregisterService(IAddressService);
         }
         var dumpService:IDumpService = IDumpService(osgi.getService(IDumpService));
         dumpService.registerDumper(new SpaceDumper());
         dumpService.registerDumper(new ObjectDumper());
         dumpService.registerDumper(new ClassDumper());
         dumpService.registerDumper(new ResourceDumper());
         dumpService.registerDumper(new ModelDumper());
         codecFactory = new CodecFactory();
         osgi.registerService(IProtocolService,new ProtocolService(codecFactory));
         codecFactory.registerCodec(ControlCommand,new ControlRootCodec(codecFactory));
         codecFactory.registerCodec(SpaceCommand,new SpaceRootCodec(codecFactory));
         codecFactory.registerCodec(ResourceInfo,new ResourceCodec(codecFactory));
         codecFactory.registerCodec(ClassInfo,new ClassCodec(codecFactory));
         var controlProtocol:Protocol = new Protocol(codecFactory,ControlCommand);
         var server:String = INetworkService(osgi.getService(INetworkService)).server;
         var resourcesURL:String = INetworkService(osgi.getService(INetworkService)).resourcesPath;
         networkClient = new AlternativaNetworkClient(server,controlProtocol);
         controlHandler = new ControlCommandHandler(server);
         var long0:Long = LongFactory.getLong(0,0);
         var long1:Long = LongFactory.getLong(0,1);
         var long2:Long = LongFactory.getLong(0,2);
         modelsRegister.register("0","0");
         modelsRegister.register("0","1");
         modelsRegister.register("0","2");
         modelsRegister.add(new DispatcherModel());
         stage = IMainContainerService(osgi.getService(IMainContainerService)).stage;
         mainContainer = IMainContainerService(osgi.getService(IMainContainerService)).mainContainer;
         backgroundLayer = IMainContainerService(osgi.getService(IMainContainerService)).backgroundLayer;
         contentLayer = IMainContainerService(osgi.getService(IMainContainerService)).contentLayer;
         contentUILayer = IMainContainerService(osgi.getService(IMainContainerService)).contentUILayer;
         systemLayer = IMainContainerService(osgi.getService(IMainContainerService)).systemLayer;
         systemUILayer = IMainContainerService(osgi.getService(IMainContainerService)).systemUILayer;
         dialogsLayer = IMainContainerService(osgi.getService(IMainContainerService)).dialogsLayer;
         noticesLayer = IMainContainerService(osgi.getService(IMainContainerService)).noticesLayer;
         cursorLayer = IMainContainerService(osgi.getService(IMainContainerService)).cursorLayer;
         resourceRegister.registerResourceFactory(new LibraryResourceFactory(),ResourceType.LIBRARY);
         resourceRegister.registerResourceFactory(new SoundResourceFactory(),ResourceType.MP3);
         resourceRegister.registerResourceFactory(new MovieClipResourceFactory(),ResourceType.MOVIE_CLIP);
         resourceRegister.registerResourceFactory(new ImageResourceFactory(),ResourceType.IMAGE);
         loadingProgress = ILoaderService(osgi.getService(ILoaderService)).loadingProgress;
         debug = new Debug();
         osgi.registerService(IAlertService,debug);
         var debugService:Object = osgi.getService(IDebugService);
         var console:Console = new Console(stage,debugService != null);
         osgi.registerService(IConsole,console);
         if(logger == null)
         {
            logger = new Logger();
         }
         osgi.registerService(ILogService,logger);
      }
      
      public function stop(osgi:OSGi) : void
      {
      }
   }
}
