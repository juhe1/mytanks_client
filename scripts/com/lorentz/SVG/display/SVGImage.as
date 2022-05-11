package com.lorentz.SVG.display
{
   import com.lorentz.SVG.display.base.ISVGViewPort;
   import com.lorentz.SVG.display.base.SVGElement;
   import com.lorentz.SVG.utils.Base64AsyncDecoder;
   import flash.display.Bitmap;
   import flash.display.Loader;
   import flash.events.Event;
   import flash.events.IOErrorEvent;
   import flash.geom.Rectangle;
   import flash.net.URLRequest;
   import flash.utils.ByteArray;
   
   public class SVGImage extends SVGElement implements ISVGViewPort
   {
       
      
      private var _svgHrefChanged:Boolean = false;
      
      private var _svgHref:String;
      
      private var listeners:Vector.<Function>;
      
      protected var _loader:Loader;
      
      protected var _base64AsyncDecoder:Base64AsyncDecoder;
      
      public function SVGImage()
      {
         this.listeners = new Vector.<Function>();
         super("image");
      }
      
      public function get svgPreserveAspectRatio() : String
      {
         return getAttribute("preserveAspectRatio") as String;
      }
      
      public function set svgPreserveAspectRatio(value:String) : void
      {
         setAttribute("preserveAspectRatio",value);
      }
      
      public function get svgX() : String
      {
         return getAttribute("x") as String;
      }
      
      public function set svgX(value:String) : void
      {
         setAttribute("x",value);
      }
      
      public function get svgY() : String
      {
         return getAttribute("y") as String;
      }
      
      public function set svgY(value:String) : void
      {
         setAttribute("y",value);
      }
      
      public function get svgWidth() : String
      {
         return getAttribute("width") as String;
      }
      
      public function set svgWidth(value:String) : void
      {
         setAttribute("width",value);
      }
      
      public function get svgHeight() : String
      {
         return getAttribute("height") as String;
      }
      
      public function set svgHeight(value:String) : void
      {
         setAttribute("height",value);
      }
      
      public function get svgOverflow() : String
      {
         return getAttribute("overflow") as String;
      }
      
      public function set svgOverflow(value:String) : void
      {
         setAttribute("overflow",value);
      }
      
      public function get svgHref() : String
      {
         return this._svgHref;
      }
      
      public function set svgHref(value:String) : void
      {
         if(this._svgHref != value)
         {
            this._svgHref = value;
            this._svgHrefChanged = true;
            invalidateProperties();
         }
      }
      
      public function loadURL(url:String) : void
      {
         if(this._loader != null)
         {
            content.removeChild(this._loader);
            this._loader = null;
         }
         if(url != null)
         {
            this._loader = new Loader();
            this._loader.contentLoaderInfo.addEventListener(Event.COMPLETE,this.loadComplete);
            this._loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR,this.loadError);
            this._loader.load(new URLRequest(url));
            content.addChild(this._loader);
         }
      }
      
      public function addListener(f:Function) : Function
      {
         this.listeners.push(f);
         return f;
      }
      
      public function removeListener(f:Function) : void
      {
         var ind:int = this.listeners.indexOf(f);
         if(ind != -1)
         {
            this.listeners.removeAt(ind);
         }
         trace(ind);
      }
      
      public function loadBase64(content:String) : void
      {
         var base64String:String = content.replace(/^data:[a-z\/]*;base64,/,"");
         this._base64AsyncDecoder = new Base64AsyncDecoder(base64String);
         this._base64AsyncDecoder.addEventListener(Base64AsyncDecoder.COMPLETE,this.base64AsyncDecoder_completeHandler);
         this._base64AsyncDecoder.addEventListener(Base64AsyncDecoder.ERROR,this.base64AsyncDecoder_errorHandler);
         this._base64AsyncDecoder.decode();
      }
      
      private function base64AsyncDecoder_completeHandler(e:Event) : void
      {
         this.loadBytes(this._base64AsyncDecoder.bytes);
         this._base64AsyncDecoder = null;
      }
      
      private function base64AsyncDecoder_errorHandler(e:Event) : void
      {
         trace(this._base64AsyncDecoder.errorMessage);
         this._base64AsyncDecoder = null;
      }
      
      public function loadBytes(byteArray:ByteArray) : void
      {
         if(this._loader != null)
         {
            content.removeChild(this._loader);
            this._loader = null;
         }
         if(byteArray != null)
         {
            this._loader = new Loader();
            this._loader.contentLoaderInfo.addEventListener(Event.COMPLETE,this.loadComplete);
            this._loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR,this.loadError);
            this._loader.loadBytes(byteArray);
            content.addChild(this._loader);
         }
      }
      
      override protected function commitProperties() : void
      {
         super.commitProperties();
         if(this._svgHrefChanged)
         {
            this._svgHrefChanged = false;
            if(this.svgHref != null && this.svgHref != "")
            {
               if(this.svgHref.match(/^data:[a-z\/]*;base64,/))
               {
                  this.loadBase64(this.svgHref);
                  beginASyncValidation("loadImage");
               }
               else
               {
                  this.loadURL(document.resolveURL(this.svgHref));
                  beginASyncValidation("loadImage");
               }
            }
         }
      }
      
      private function loadComplete(event:Event) : void
      {
         var f:Function = null;
         if(this._loader.content is Bitmap)
         {
            (this._loader.content as Bitmap).smoothing = true;
         }
         for each(f in this.listeners)
         {
            f.call();
         }
         endASyncValidation("loadImage");
      }
      
      private function loadError(e:IOErrorEvent) : void
      {
         trace("Failed to load image" + e.text);
         endASyncValidation("loadImage");
      }
      
      override protected function getContentBox() : Rectangle
      {
         if(this._loader == null || this._loader.content == null)
         {
            return null;
         }
         return new Rectangle(0,0,this._loader.content.width,this._loader.content.height);
      }
      
      override public function clone() : Object
      {
         var c:SVGImage = super.clone() as SVGImage;
         c.svgHref = this.svgHref;
         return c;
      }
   }
}
