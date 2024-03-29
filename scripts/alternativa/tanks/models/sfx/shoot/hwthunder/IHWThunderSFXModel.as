package alternativa.tanks.models.sfx.shoot.hwthunder
{
   import alternativa.engine3d.core.Object3D;
   import alternativa.math.Vector3;
   import alternativa.object.ClientObject;
   import alternativa.tanks.sfx.EffectsPair;
   
   public interface IHWThunderSFXModel
   {
       
      
      function createShotEffects(param1:ClientObject, param2:Vector3, param3:Object3D) : EffectsPair;
      
      function createExplosionEffects(param1:ClientObject, param2:Vector3) : EffectsPair;
   }
}
