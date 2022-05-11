package scpacker.resource.images
{
   import alternativa.init.Main;
   import alternativa.osgi.service.storage.IStorageService;
   import alternativa.resource.StubBitmapData;
   import com.lorentz.SVG.display.SVGImage;
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.Loader;
   import flash.events.Event;
   import flash.events.IOErrorEvent;
   import flash.net.URLLoader;
   import flash.net.URLLoaderDataFormat;
   import flash.net.URLRequest;
   import flash.utils.ByteArray;
   import flash.utils.Dictionary;
   import scpacker.resource.ResourceUtil;
   import scpacker.resource.cache.CacheURLLoader;
   import scpacker.resource.failed.FailedResource;
   import sineysoft.WebpSwc;
   import specter.resource.ImageType;
   import specter.utils.Logger;
   
   public class ImageResourceLoader
   {
       
      
      public var path:String;
      
      public var list:ImageResourceList;
      
      public var inbattleList:ImageResourceList;
      
      public var queue:Vector.<ImageResource>;
      
      public var status:int = 0;
      
      private var length:int = 0;
      
      private var lengthFailed:int = 0;
      
      private var failedResources:Dictionary;
      
      private var config:Dictionary;
      
      public function ImageResourceLoader(path:String)
      {
         this.failedResources = new Dictionary();
         super();
         this.path = path;
         this.list = new ImageResourceList();
         this.inbattleList = new ImageResourceList();
         this.queue = new Vector.<ImageResource>();
         this.config = new Dictionary();
         var loader:URLLoader = new URLLoader();
         loader.addEventListener(Event.COMPLETE,this.parse);
         loader.load(new URLRequest(path));
      }
      
      public function reload() : void
      {
         this.list.clear();
         this.list = new ImageResourceList();
         this.list.images = this.inbattleList.images;
         this.inbattleList = new ImageResourceList();
         this.queue = new Vector.<ImageResource>();
         var loader:URLLoader = new URLLoader();
         loader.addEventListener(Event.COMPLETE,this.parse);
         loader.load(new URLRequest(this.path));
      }
      
      private function parse(e:Event) : void
      {
         var path:String = null;
         var oldPath:String = null;
         var newPath:String = null;
         var obj:Object = null;
         var multiframed:Boolean = false;
         var multiframeInfo:MultiframeResourceData = null;
         var res:ImageResource = null;
         var config:Object = JSON.parse(e.target.data);
         if(config.id == "IMAGES")
         {
            for each(obj in config.items)
            {
               if(!this.list.getImage(obj.name))
               {
                  multiframed = obj.multiframe == null ? Boolean(Boolean(false)) : Boolean(Boolean(obj.multiframe));
                  multiframeInfo = null;
                  if(multiframed)
                  {
                     multiframeInfo = new MultiframeResourceData();
                     multiframeInfo.fps = obj.fps;
                     multiframeInfo.heigthFrame = obj.frame_heigth;
                     multiframeInfo.widthFrame = obj.frame_width;
                     multiframeInfo.numFrames = obj.num_frames;
                  }
                  path = obj.src;
                  if(IStorageService(Main.osgi.getService(IStorageService)).getStorage().data["use_old_textures"] == true && (path.search("hull/") != -1 || path.search("turret/") != -1))
                  {
                     oldPath = path.split("/")[1];
                     newPath = oldPath + "_old";
                     path = path.replace(oldPath,newPath);
                  }
                  res = new ImageResource(path,obj.name,multiframed,multiframeInfo,obj.src);
                  this.queue.push(res);
                  this.config[obj.name] = res;
               }
            }
            this.loadQueue();
         }
      }
      
      private function loadQueue() : void
      {
         var obj:ImageResource = null;
         for each(obj in this.queue)
         {
            this.loadImage(obj);
            ++this.length;
         }
      }
      
      private function loadImage(img:ImageResource, isFirst:* = true) : void
      {
         var prefix:String = null;
         var svg:SVGImage = null;
         var f:Function = null;
         prefix = null;
         var loader:Object = null;
         f = null;
         var url:String = null;
         prefix = !!Game.local ? "" : "resources/";
         if(img.id.indexOf("preview") >= 0)
         {
            img.url = prefix + img.bitmapData as String;
            this.list.add(img);
            if(this.length == 1 && this.lengthFailed <= 0)
            {
               this.status = 1;
               ResourceUtil.onCompleteLoading();
               this.failedResources = new Dictionary();
            }
            --this.length;
            return;
         }
         if(isFirst && img.id != "criticalHitTexture" && (img.id.indexOf("skybox") >= 0 || img.id.indexOf("details") >= 0 || img.id.indexOf("lightmap") >= 0 || img.url.indexOf("colormaps") >= 0))
         {
            if(this.length == 1 && this.lengthFailed <= 0)
            {
               this.status = 1;
               ResourceUtil.onCompleteLoading();
               this.failedResources = new Dictionary();
            }
            --this.length;
            return;
         }
         switch(img.type)
         {
            case ImageType.SVG:
               svg = new SVGImage();
               f = svg.addListener(function():void
               {
                  img.bitmapData = new BitmapData(svg.width,svg.height,false,0);
                  BitmapData(img.bitmapData).draw(svg,svg.transform.matrix);
                  svg.removeListener(f);
               });
               svg.loadURL(prefix + img.bitmapData as String);
               break;
            case ImageType.WEBP:
               loader = new URLLoader();
               loader.dataFormat = URLLoaderDataFormat.BINARY;
               loader.addEventListener(Event.COMPLETE,function(e:Event):void
               {
                  var bitmapData:BitmapData = WebpSwc.decode(ByteArray(e.currentTarget.data));
                  if(!bitmapData)
                  {
                     bitmapData = new BitmapData(100,100,true,16777215);
                  }
                  var url:String = img.bitmapData as String;
                  if(url.indexOf("?") >= 0)
                  {
                     url = url.split("?")[0];
                  }
                  list.add(new ImageResource(bitmapData,img.id,img.animatedMaterial,img.multiframeData,prefix + url));
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
               });
               loader.addEventListener(IOErrorEvent.IO_ERROR,function(e:IOErrorEvent):void
               {
                  Main.debug.showAlert("Can\'t load resource: " + prefix + img.bitmapData);
                  var url:String = img.bitmapData as String;
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
                  url = img.bitmapData as String;
                  if(url.indexOf("?") >= 0)
                  {
                     url = url.split("?")[0] + "?rand=" + Math.random();
                  }
                  else
                  {
                     url += "?rand=" + Math.random();
                  }
                  img.bitmapData = url;
                  if(failedImage.failedCount >= 3)
                  {
                     Main.debug.showAlert("Can\'t load resource: " + prefix + img.bitmapData + " after 3 attempts.");
                     img.bitmapData = new StubBitmapData(16711680);
                     --lengthFailed;
                     list.add(new ImageResource(img.bitmapData,img.id,img.animatedMaterial,img.multiframeData,prefix + url));
                     if(length == 1 && lengthFailed <= 0)
                     {
                        status = 1;
                        ResourceUtil.onCompleteLoading();
                        failedResources = new Dictionary();
                     }
                     --length;
                  }
                  else
                  {
                     loadImage(img);
                  }
               });
               loader.load(new URLRequest(prefix + img.bitmapData as String));
               break;
            case ImageType.COMMON:
               loader = new CacheURLLoader();
               loader.dataFormat = URLLoaderDataFormat.BINARY;
               loader.addEventListener(Event.COMPLETE,function(event:Event):void
               {
                  var nativeLoader:Loader = new Loader();
                  nativeLoader.contentLoaderInfo.addEventListener(Event.COMPLETE,function(e:Event):void
                  {
                     var bitmapData:BitmapData = Bitmap(e.target.content).bitmapData;
                     var url:String = img.bitmapData as String;
                     if(url.indexOf("?") >= 0)
                     {
                        url = url.split("?")[0];
                     }
                     list.add(new ImageResource(bitmapData,img.id,img.animatedMaterial,img.multiframeData,prefix + url));
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
                  });
                  try
                  {
                     nativeLoader.loadBytes(event.target.data);
                  }
                  catch(e:Error)
                  {
                     Logger.warn("nativeLoader.loadBytes(" + event.target.data + ")" + e.getStackTrace());
                  }
               });
               loader.addEventListener(IOErrorEvent.IO_ERROR,function(e:IOErrorEvent):void
               {
                  Logger.warn("IO error: " + prefix + img.bitmapData);
                  Main.debug.showAlert("Can\'t load resource: " + prefix + img.bitmapData);
                  var url:String = img.bitmapData as String;
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
                  url = img.bitmapData as String;
                  if(url.indexOf("?") >= 0)
                  {
                     url = url.split("?")[0] + "?rand=" + Math.random();
                  }
                  else
                  {
                     url += "?rand=" + Math.random();
                  }
                  img.bitmapData = url;
                  if(failedImage.failedCount >= 3)
                  {
                     Main.debug.showAlert("Can\'t load resource: " + prefix + img.bitmapData + " after 3 attempts.");
                     img.bitmapData = new StubBitmapData(16711680);
                     --lengthFailed;
                     list.add(new ImageResource(img.bitmapData,img.id,img.animatedMaterial,img.multiframeData,prefix + url));
                     if(length == 1 && lengthFailed <= 0)
                     {
                        status = 1;
                        ResourceUtil.onCompleteLoading();
                        failedResources = new Dictionary();
                     }
                     --length;
                  }
                  else
                  {
                     loadImage(img);
                  }
               });
               url = img.bitmapData as String;
               if(url.indexOf("?") >= 0)
               {
                  url = url.split("?")[0];
               }
               loader.load(new URLRequest(prefix + url));
               break;
            case ImageType.JPEG2000:
         }
      }
      
      public function loadForBattle(id:String) : void
      {
         if(!this.inbattleList.isLoaded(id))
         {
            ResourceUtil.loading.push(id);
            this.loadImageSingle(this.config[id]);
         }
      }
      
      public function loadFor(id:String) : void
      {
         if(!this.inbattleList.isLoaded(id))
         {
            this.loadImage(this.config[id],false);
            ++this.length;
         }
      }
      
      private function loadImageSingle(img:ImageResource) : void
      {
         var prefix:String = null;
         var svg:SVGImage = null;
         var f:Function = null;
         prefix = null;
         var loader:Object = null;
         svg = null;
         f = null;
         prefix = !!Game.local ? "" : "resources/";
         if(!img)
         {
            return;
         }
         switch(img.type)
         {
            case ImageType.SVG:
               svg = new SVGImage();
               f = svg.addListener(function():void
               {
                  img.bitmapData = new BitmapData(svg.width,svg.height,false,0);
                  BitmapData(img.bitmapData).draw(svg,svg.transform.matrix);
                  svg.removeListener(f);
               });
               svg.loadURL(prefix + img.bitmapData as String);
               break;
            case ImageType.WEBP:
               loader = new URLLoader();
               loader.dataFormat = URLLoaderDataFormat.BINARY;
               loader.addEventListener(Event.COMPLETE,function(e:Event):void
               {
                  var bitmapData:BitmapData = WebpSwc.decode(ByteArray(e.currentTarget.data));
                  if(!bitmapData)
                  {
                     bitmapData = new BitmapData(100,100,true,16777215);
                  }
                  var url:String = img.bitmapData as String;
                  if(url.indexOf("?") >= 0)
                  {
                     url = url.split("?")[0];
                  }
                  inbattleList.add(new ImageResource(bitmapData,img.id,img.animatedMaterial,img.multiframeData,prefix + url));
                  var failedImage:FailedResource = failedResources[url];
                  if(failedImage != null)
                  {
                     --lengthFailed;
                  }
                  ResourceUtil.loading.removeAt(ResourceUtil.loading.indexOf(img.id));
                  if(ResourceUtil.loading.length == 0)
                  {
                     ResourceUtil.onCompleteLoading();
                  }
                  if(length == 1 && lengthFailed <= 0)
                  {
                     --length;
                  }
               });
               loader.addEventListener(IOErrorEvent.IO_ERROR,function(e:IOErrorEvent):void
               {
                  Main.debug.showAlert("Can\'t load resource: " + prefix + img.bitmapData);
                  var url:String = img.bitmapData as String;
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
                  url = img.bitmapData as String;
                  if(url.indexOf("?") >= 0)
                  {
                     url = url.split("?")[0] + "?rand=" + Math.random();
                  }
                  else
                  {
                     url += "?rand=" + Math.random();
                  }
                  img.bitmapData = url;
                  if(failedImage.failedCount >= 3)
                  {
                     Main.debug.showAlert("Can\'t load resource: " + prefix + img.bitmapData + " after 3 attempts.");
                     img.bitmapData = new StubBitmapData(16711680);
                     --lengthFailed;
                     inbattleList.add(new ImageResource(img.bitmapData,img.id,img.animatedMaterial,img.multiframeData,prefix + url));
                     ResourceUtil.loading.removeAt(ResourceUtil.loading.indexOf(img.id));
                     if(ResourceUtil.loading.length == 0)
                     {
                        ResourceUtil.onCompleteLoading();
                     }
                     if(length == 1 && lengthFailed <= 0)
                     {
                        status = 1;
                        failedResources = new Dictionary();
                     }
                     --length;
                  }
                  else
                  {
                     loadImage(img);
                  }
               });
               loader.load(new URLRequest(prefix + img.bitmapData as String));
               break;
            case ImageType.COMMON:
               loader = new CacheURLLoader();
               loader.dataFormat = URLLoaderDataFormat.BINARY;
               Logger.log("Start loading resource: " + img.id);
               loader.addEventListener(Event.COMPLETE,function(event:Event):void
               {
                  var nativeLoader:Loader = new Loader();
                  nativeLoader.contentLoaderInfo.addEventListener(Event.COMPLETE,function(e:Event):void
                  {
                     var bitmapData:BitmapData = Bitmap(e.target.content).bitmapData;
                     Logger.log("Resource loaded: " + img.id);
                     var url:String = img.bitmapData as String;
                     if(url.indexOf("?") >= 0)
                     {
                        url = url.split("?")[0];
                     }
                     inbattleList.add(new ImageResource(bitmapData,img.id,img.animatedMaterial,img.multiframeData,prefix + url));
                     var failedImage:FailedResource = failedResources[url];
                     if(failedImage != null)
                     {
                        --lengthFailed;
                     }
                     ResourceUtil.loading.removeAt(ResourceUtil.loading.indexOf(img.id));
                     if(ResourceUtil.loading.length == 0)
                     {
                        ResourceUtil.onCompleteLoading();
                     }
                     if(length == 1 && lengthFailed <= 0)
                     {
                        --length;
                     }
                  });
                  nativeLoader.loadBytes(event.target.data);
               });
               loader.addEventListener(IOErrorEvent.IO_ERROR,function(e:IOErrorEvent):void
               {
                  Main.debug.showAlert("Can\'t load resource: " + prefix + img.bitmapData);
                  var url:String = img.bitmapData as String;
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
                  url = img.bitmapData as String;
                  if(url.indexOf("?") >= 0)
                  {
                     url = url.split("?")[0] + "?rand=" + Math.random();
                  }
                  else
                  {
                     url += "?rand=" + Math.random();
                  }
                  img.bitmapData = url;
                  if(failedImage.failedCount >= 3)
                  {
                     Main.debug.showAlert("Can\'t load resource: " + prefix + img.bitmapData + " after 3 attempts.");
                     img.bitmapData = new StubBitmapData(16711680);
                     --lengthFailed;
                     inbattleList.add(new ImageResource(img.bitmapData,img.id,img.animatedMaterial,img.multiframeData,prefix + url));
                     ResourceUtil.loading.removeAt(ResourceUtil.loading.indexOf(img.id));
                     if(ResourceUtil.loading.length == 0)
                     {
                        ResourceUtil.onCompleteLoading();
                     }
                     if(length == 1 && lengthFailed <= 0)
                     {
                        status = 1;
                        failedResources = new Dictionary();
                     }
                     --length;
                  }
                  else
                  {
                     loadImage(img);
                  }
               });
               loader.load(new URLRequest(prefix + img.bitmapData as String));
               break;
            case ImageType.JPEG2000:
         }
      }
   }
}
