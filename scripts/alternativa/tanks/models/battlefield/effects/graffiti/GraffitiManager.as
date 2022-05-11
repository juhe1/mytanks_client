package alternativa.tanks.models.battlefield.effects.graffiti
{
   import alternativa.engine3d.materials.TextureMaterial;
   import alternativa.init.Main;
   import alternativa.math.Vector3;
   import alternativa.physics.collision.types.RayIntersection;
   import alternativa.tanks.models.battlefield.BattlefieldModel;
   import alternativa.tanks.models.battlefield.IBattleField;
   import alternativa.tanks.models.battlefield.decals.RotationState;
   import alternativa.tanks.physics.CollisionGroup;
   import alternativa.tanks.services.objectpool.IObjectPoolService;
   import alternativa.tanks.sfx.ISound3DEffect;
   import alternativa.tanks.sfx.Sound3D;
   import alternativa.tanks.sfx.Sound3DEffect;
   import alternativa.tanks.sfx.SoundOptions;
   import flash.display.BitmapData;
   import flash.media.Sound;
   import scpacker.networking.INetworker;
   import scpacker.networking.Network;
   import scpacker.resource.ResourceType;
   import scpacker.resource.ResourceUtil;
   
   public class GraffitiManager
   {
      
      private static var battlefieldModel:BattlefieldModel = Main.osgi.getService(IBattleField) as BattlefieldModel;
       
      
      public function GraffitiManager()
      {
         super();
      }
      
      public static function putGraffiti(id:String) : void
      {
         var js:Object = null;
         var ray:RayIntersection = new RayIntersection();
         var origin:Vector3 = new Vector3(battlefieldModel.getBattlefieldData().viewport.camera.x,battlefieldModel.getBattlefieldData().viewport.camera.y,battlefieldModel.getBattlefieldData().viewport.camera.z);
         var direction:Vector3 = new Vector3(battlefieldModel.getBattlefieldData().viewport.camera.zAxis.x,battlefieldModel.getBattlefieldData().viewport.camera.zAxis.y,battlefieldModel.getBattlefieldData().viewport.camera.zAxis.z);
         if(battlefieldModel.getBattlefieldData().collisionDetector.raycastStatic(origin,direction,CollisionGroup.STATIC,10000,ray))
         {
            js = new Object();
            js.rayPos = ray.pos;
            js.origin = origin;
            Network(Main.osgi.getService(INetworker)).send("battle;activate_graffiti;" + id + ";" + JSON.stringify(js));
         }
      }
      
      public static function createGraffiti(pos:Vector3, muzzlePoint:Vector3, name:String) : void
      {
         var texture:TextureMaterial = new TextureMaterial(getTexture(name));
         var graffitiSound:Sound = ResourceUtil.getResource(ResourceType.SOUND,"sprayer").sound as Sound;
         playSoundEffect(graffitiSound,pos);
         battlefieldModel.addDecal(pos,muzzlePoint,150,texture,RotationState.WITHOUT_ROTATION,true);
      }
      
      private static function getTexture(id:String) : BitmapData
      {
         return TexturesManager.getBD(id);
      }
      
      public static function playSoundEffect(effectSound:Sound, pos:Vector3) : void
      {
         var soundEffect:ISound3DEffect = createSoundEffect(effectSound,pos);
         if(soundEffect != null)
         {
            battlefieldModel.addSound3DEffect(soundEffect);
         }
      }
      
      private static function createSoundEffect(effectSound:Sound, pos:Vector3) : ISound3DEffect
      {
         var sound:Sound3D = Sound3D.create(effectSound,SoundOptions.nearRadius,SoundOptions.farRadius,SoundOptions.farDelimiter,1.5);
         return Sound3DEffect.create(IObjectPoolService(Main.osgi.getService(IObjectPoolService)).objectPool,null,pos,sound);
      }
   }
}
