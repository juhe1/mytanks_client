package scpacker.resource.images
{
   import alternativa.model.IResourceLoadListener;
   import alternativa.resource.StubBitmapData;
   import flash.display.Bitmap;
   import flash.display.Loader;
   import flash.events.ErrorEvent;
   import flash.events.Event;
   import flash.events.IOErrorEvent;
   import flash.net.URLLoader;
   import flash.net.URLLoaderDataFormat;
   import flash.net.URLRequest;
   import flash.utils.ByteArray;
   import scpacker.resource.cache.CacheURLLoader;
   import sineysoft.WebpSwc;
   import specter.resource.ImageType;
   
   public class ImageResource
   {
       
      
      public var bitmapData:Object;
      
      public var id:String;
      
      public var animatedMaterial:Boolean;
      
      public var multiframeData:MultiframeResourceData;
      
      public var url:String;
      
      private var imageLoader:Object;
      
      private var nativeLoader:Loader;
      
      private var completeLoadListeners:Vector.<IResourceLoadListener>;
      
      private var loading:Boolean = false;
      
      public var isWebP:Boolean = false;
      
      public var isSVG:Boolean = false;
      
      public var type:uint;
      
      public function ImageResource(bitmapData:Object, id:String, animatedMaterial:Boolean, multiframeData:MultiframeResourceData, url:String)
      {
         super();
         this.bitmapData = bitmapData;
         this.id = id;
         this.animatedMaterial = animatedMaterial;
         this.multiframeData = multiframeData;
         this.url = url;
         if(bitmapData is String)
         {
            if(String(bitmapData).toLowerCase().indexOf(".webp") != -1)
            {
               this.type = ImageType.WEBP;
            }
            else if(String(bitmapData).toLowerCase().indexOf(".svg") != -1)
            {
               this.type = ImageType.SVG;
            }
            else if(String(bitmapData).toLowerCase().indexOf(".jp2") != -1)
            {
               this.type = ImageType.JPEG2000;
            }
            else
            {
               this.type = ImageType.COMMON;
            }
         }
         this.completeLoadListeners = new Vector.<IResourceLoadListener>();
      }
      
      public function set completeLoadListener(object:IResourceLoadListener) : void
      {
         this.completeLoadListeners.push(object);
      }
      
      public function load() : void
      {
         if(this.loaded() || this.loading)
         {
            return;
         }
         if(this.type == ImageType.WEBP)
         {
            this.imageLoader = new URLLoader();
            this.imageLoader.dataFormat = URLLoaderDataFormat.BINARY;
            this.imageLoader.addEventListener(Event.COMPLETE,this.onPictureLoadingComplete);
            this.imageLoader.addEventListener(IOErrorEvent.IO_ERROR,this.onPictureLoadingError);
            this.imageLoader.load(new URLRequest(this.url));
         }
         else if(this.type == ImageType.COMMON)
         {
            this.imageLoader = new CacheURLLoader();
            this.imageLoader.dataFormat = URLLoaderDataFormat.BINARY;
            this.imageLoader.addEventListener(Event.COMPLETE,this.onPictureLoadingComplete);
            this.imageLoader.addEventListener(IOErrorEvent.IO_ERROR,this.onPictureLoadingError);
            this.imageLoader.load(new URLRequest(this.url));
         }
         this.loading = true;
      }
      
      private function onPictureLoadingComplete(e:Event) : void
      {
         var listener:IResourceLoadListener = null;
         if(this.type == ImageType.WEBP)
         {
            this.bitmapData = WebpSwc.decode(ByteArray(e.currentTarget.data));
            this.destroyImageLoader();
            if(this.completeLoadListeners != null)
            {
               for each(listener in this.completeLoadListeners)
               {
                  listener.resourceLoaded(this);
               }
            }
         }
         else
         {
            this.nativeLoader = new Loader();
            this.nativeLoader.contentLoaderInfo.addEventListener(Event.COMPLETE,this.onNativeLoaderComplete);
            this.nativeLoader.loadBytes(e.target.data);
         }
      }
      
      private function onNativeLoaderComplete(e:Event) : void
      {
         var listener:IResourceLoadListener = null;
         this.bitmapData = Bitmap(e.target.content).bitmapData;
         this.destroyImageLoader();
         if(this.completeLoadListeners != null)
         {
            for each(listener in this.completeLoadListeners)
            {
               listener.resourceLoaded(this);
            }
         }
      }
      
      private function destroyImageLoader() : void
      {
         if(this.imageLoader == null)
         {
            return;
         }
         if(this.type == ImageType.WEBP)
         {
            this.imageLoader.removeEventListener(Event.COMPLETE,this.onPictureLoadingComplete);
            this.imageLoader.removeEventListener(IOErrorEvent.IO_ERROR,this.onPictureLoadingError);
         }
         else if(this.type == ImageType.COMMON)
         {
            this.imageLoader.removeEventListener(Event.COMPLETE,this.onPictureLoadingComplete);
            this.imageLoader.removeEventListener(IOErrorEvent.IO_ERROR,this.onPictureLoadingError);
            if(this.nativeLoader != null)
            {
               this.nativeLoader.contentLoaderInfo.removeEventListener(Event.COMPLETE,this.onNativeLoaderComplete);
            }
         }
         this.imageLoader = null;
         this.loading = false;
      }
      
      private function onPictureLoadingError(e:ErrorEvent) : void
      {
         var listener:IResourceLoadListener = null;
         this.bitmapData = new StubBitmapData(16711680);
         this.destroyImageLoader();
         if(this.completeLoadListeners != null)
         {
            for each(listener in this.completeLoadListeners)
            {
               listener.resourceLoaded(this);
            }
         }
      }
      
      public function loaded() : Boolean
      {
         return this.bitmapData != null && !(this.bitmapData is String);
      }
      
      public function toString() : String
      {
         return "ImageResource:[ID: \"" + this.id + "\"; animated: " + this.animatedMaterial + "; URL:\"" + this.url + "\"; loading: " + this.loading + "; data: " + this.bitmapData + "]";
      }
      
      public function clone() : ImageResource
      {
         return new ImageResource(this.bitmapData,this.id,this.animatedMaterial,this.multiframeData,this.url);
      }
   }
}
