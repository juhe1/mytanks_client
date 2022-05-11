package alternativa.tanks.models.sfx.shoot.shaft
{
   import alternativa.engine3d.materials.Material;
   import alternativa.math.Vector3;
   import alternativa.tanks.sfx.IGraphicEffect;
   
   public interface ShaftTrailEffect extends IGraphicEffect
   {
       
      
      function init(param1:Vector3, param2:Vector3, param3:Number, param4:Number, param5:Material, param6:int) : void;
   }
}
