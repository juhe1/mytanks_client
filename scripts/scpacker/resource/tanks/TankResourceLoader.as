package scpacker.resource.tanks
{
   import alternativa.engine3d.core.Object3D;
   import alternativa.engine3d.loaders.Parser3DS;
   import alternativa.engine3d.objects.Mesh;
   import alternativa.init.Main;
   import alternativa.osgi.service.storage.IStorageService;
   import flash.events.Event;
   import flash.events.IOErrorEvent;
   import flash.geom.Vector3D;
   import flash.net.URLLoader;
   import flash.net.URLLoaderDataFormat;
   import flash.net.URLRequest;
   import flash.utils.ByteArray;
   import flash.utils.Dictionary;
   import scpacker.resource.ResourceUtil;
   import scpacker.resource.cache.CacheURLLoader;
   import scpacker.resource.failed.FailedResource;
   import specter.utils.Logger;
   
   public class TankResourceLoader
   {
       
      
      private var path:String;
      
      public var list:TankResourceList;
      
      private var queue:Vector.<TankResource>;
      
      private var length:int = 0;
      
      public var status:int = 0;
      
      private var lengthFailed:int = 0;
      
      private var failedResources:Dictionary;
      
      public function TankResourceLoader(path:String)
      {
         this.failedResources = new Dictionary();
         super();
         this.path = path;
         this.list = new TankResourceList();
         this.queue = new Vector.<TankResource>();
         var loader:URLLoader = new URLLoader();
         loader.addEventListener(Event.COMPLETE,this.parse);
         loader.load(new URLRequest(path));
      }
      
      private function parse(e:Event) : void
      {
         var path:String = null;
         var oldPath:String = null;
         var newPath:String = null;
         var obj:Object = null;
         var config:Object = JSON.parse(e.target.data);
         if(config.id == "MODELS")
         {
            for each(obj in config.items)
            {
               path = obj.src;
               if(IStorageService(Main.osgi.getService(IStorageService)).getStorage().data["use_old_textures"] == true && (path.search("hull/") != -1 || path.search("turret/") != -1))
               {
                  oldPath = path.split("/")[1];
                  newPath = oldPath + "_old";
                  path = path.replace(oldPath,newPath);
               }
               this.queue.push(new TankResource(null,obj.name,path));
               ++this.length;
            }
            this.loadQueue();
         }
      }
      
      private function loadQueue() : void
      {
         var file:TankResource = null;
         for each(file in this.queue)
         {
            this.loadModel(file);
         }
      }
      
      private function loadModel(str:TankResource) : void
      {
         var prefix:String = null;
         var loader:CacheURLLoader = null;
         prefix = null;
         loader = null;
         prefix = !!Game.local ? "" : "resources/";
         loader = new CacheURLLoader();
         loader.dataFormat = URLLoaderDataFormat.BINARY;
         loader.addEventListener(Event.COMPLETE,function(e:Event):void
         {
            var flagMount:Vector3D = null;
            var turretMount:Vector3D = null;
            var obj:Object3D = null;
            var bytes:ByteArray = ByteArray(loader.data);
            var parser:Parser3DS = new Parser3DS();
            var muzzles:Vector.<Vector3D> = new Vector.<Vector3D>();
            parser.parse(bytes);
            for each(obj in parser.objects)
            {
               if(obj.name.split("0")[0] == "muzzle")
               {
                  muzzles.push(new Vector3D(obj.x,obj.y,obj.z));
               }
               if(obj.name.indexOf("fmnt") >= 0)
               {
                  flagMount = new Vector3D(obj.x,obj.y,obj.z);
               }
               if(obj.name == "mount")
               {
                  turretMount = new Vector3D(obj.x,obj.y,obj.z);
               }
            }
            if(parser.objects.length < 1)
            {
               Logger.log("Invalid mesh width 0 objects: " + str.next as String);
               return;
            }
            var tnk:TankResource = new TankResource(Mesh(parser.objects[0]),str.id,null,muzzles,flagMount,turretMount);
            tnk.objects = parser.objects;
            list.add(tnk);
            var url:String = str.next as String;
            if(url.indexOf("?") >= 0)
            {
               url = url.split("?")[0];
            }
            var failedImage:FailedResource = failedResources[url];
            if(failedImage != null)
            {
               --lengthFailed;
            }
            if(length == 1 && lengthFailed <= 0)
            {
               status = 1;
               ResourceUtil.onCompleteLoading();
               failedResources = new Dictionary();
            }
            --length;
            muzzles = null;
         });
         loader.load(new URLRequest(prefix + (str.next as String)));
         loader.addEventListener(IOErrorEvent.IO_ERROR,function(e:IOErrorEvent):void
         {
            Main.debug.showAlert("Coun\'t load resouce: " + prefix + (str.next as String));
            var url:String = str.next as String;
            if(url.indexOf("?") >= 0)
            {
               url = url.split("?")[0];
            }
            var failedImage:FailedResource = failedResources[url];
            if(failedImage == null)
            {
               failedImage = new FailedResource();
               failedResources[url] = failedImage;
               ++lengthFailed;
            }
            ++failedImage.failedCount;
            url = str.next as String;
            if(url.indexOf("?") >= 0)
            {
               url = url.split("?")[0] + "?rand=" + Math.random();
            }
            else
            {
               url += "?rand=" + Math.random();
            }
            str.next = url;
            if(failedImage.failedCount >= 3)
            {
               Main.debug.showAlert("Coun\'t load resouce: " + prefix + str.next + " before 3 attempt.");
               return;
            }
            loadModel(str);
         });
      }
   }
}
