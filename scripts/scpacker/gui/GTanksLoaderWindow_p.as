package scpacker.gui
{
   import flash.utils.ByteArray;
   import mx.core.MovieClipLoaderAsset;
   
   public class GTanksLoaderWindow_p extends MovieClipLoaderAsset
   {
      
      private static var bytes:ByteArray = null;
       
      [Embed(source="GTanksLoaderWindow_p_dataClass.swf", mimeType="application/octet-stream")]
      public var dataClass:Class;
      
      public function GTanksLoaderWindow_p()
      {
         super();
         initialWidth = 14960 / 20;
         initialHeight = 1440 / 20;
      }
      
      override public function get movieClipData() : ByteArray
      {
         if(bytes == null)
         {
            bytes = ByteArray(new this.dataClass());
         }
         return bytes;
      }
   }
}
