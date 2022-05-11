package alternativa.tanks.models.sfx.colortransform
{
   import alternativa.model.IModel;
   import alternativa.object.ClientObject;
   import com.alternativaplatform.projects.tanks.client.warfare.models.colortransform.ColorTransformModelBase;
   import com.alternativaplatform.projects.tanks.client.warfare.models.colortransform.IColorTransformModelBase;
   
   public class ColorTransformModel extends ColorTransformModelBase implements IColorTransformModelBase, IColorTransformModel
   {
       
      
      public function ColorTransformModel()
      {
         super();
         _interfaces.push(IModel,IColorTransformModel);
      }
      
      public function initObject(clientObject:ClientObject, colorTransforms:Array) : void
      {
         var numEntries:uint = colorTransforms.length;
         var entries:Vector.<ColorTransformEntry> = new Vector.<ColorTransformEntry>(numEntries);
         for(var i:int = 0; i < numEntries; i++)
         {
            entries[i] = new ColorTransformEntry(colorTransforms[i]);
         }
         clientObject.putParams(ColorTransformModel,entries);
      }
      
      public function getModelData(clientObject:ClientObject) : Vector.<ColorTransformEntry>
      {
         return Vector.<ColorTransformEntry>(clientObject.getParams(ColorTransformModel));
      }
   }
}
