package scpacker.resource.images
{
   import flash.display.BitmapData;
   import flash.utils.Dictionary;
   
   public class ImageResourceList
   {
       
      
      public var images:Dictionary;
      
      private var ids:Vector.<String>;
      
      public function ImageResourceList()
      {
         super();
         this.images = new Dictionary();
         this.ids = new Vector.<String>();
      }
      
      public function add(img:ImageResource) : void
      {
         if(this.images[img.id] == null)
         {
            if(img.bitmapData == null)
            {
               throw new Error("Bitmap null! " + img.id);
            }
            this.images[img.id] = img;
            this.ids.push(img.id);
            trace("Загрузили " + img.id + ": " + img.bitmapData);
         }
         else
         {
            img.bitmapData = null;
         }
      }
      
      public function getImage(key:String) : ImageResource
      {
         return this.images[key];
      }
      
      public function isLoaded(key:String) : Boolean
      {
         return !(this.images[key] == null || this.images[key].bitmapData as BitmapData == null);
      }
      
      public function clear() : void
      {
         var s:String = null;
         for each(s in this.ids)
         {
            this.images[s].bitmapData = null;
            this.images[s] = null;
         }
         this.images = new Dictionary();
         this.ids = new Vector.<String>();
      }
      
      public function getIds() : Vector.<String>
      {
         return this.ids;
      }
   }
}
