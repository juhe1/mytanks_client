package alternativa.tanks.engine3d
{
   import alternativa.engine3d.materials.TextureMaterial;
   import alternativa.tanks.materials.AnimatedPaintMaterial;
   import alternativa.tanks.materials.PaintMaterial;
   import flash.display.BitmapData;
   import scpacker.resource.images.ImageResource;
   
   public interface ITextureMaterialRegistry
   {
       
      
      function getAnimatedPaint(param1:ImageResource, param2:BitmapData, param3:BitmapData, param4:String) : AnimatedPaintMaterial;
      
      function getPaint1(param1:ImageResource, param2:BitmapData, param3:BitmapData, param4:String) : PaintMaterial;
      
      function set resoluion(param1:Number) : void;
      
      function get useMipMapping() : Boolean;
      
      function set useMipMapping(param1:Boolean) : void;
      
      function getMaterial(param1:MaterialType, param2:BitmapData, param3:Number, param4:Boolean = true) : TextureMaterial;
      
      function clear() : void;
      
      function getDump() : String;
      
      function disposeMaterial(param1:TextureMaterial) : void;
   }
}
