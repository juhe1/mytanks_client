package alternativa.tanks.models.sfx.colortransform
{
   import alternativa.object.ClientObject;
   
   public interface IColorTransformModel
   {
       
      
      function getModelData(param1:ClientObject) : Vector.<ColorTransformEntry>;
   }
}
