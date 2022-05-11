package alternativa.tanks.models.sfx.healing
{
   import alternativa.engine3d.core.Object3D;
   import alternativa.math.Vector3;
   import alternativa.tanks.models.battlefield.IBattleField;
   import alternativa.tanks.models.tank.TankData;
   import alternativa.tanks.sfx.ISpecialEffect;
   import alternativa.tanks.utils.objectpool.ObjectPool;
   import alternativa.tanks.utils.objectpool.PooledObject;
   import com.alternativaplatform.projects.tanks.client.warfare.models.tankparts.weapon.healing.IsisActionType;
   
   public class HealingGunSFX extends PooledObject implements IHealingGunEffectListener
   {
      
      private static var cameraEffect:HealingGunCameraEffect = new HealingGunCameraEffect();
       
      
      public var targetData:TankData;
      
      private var graphicEffect:HealingGunGraphicEffect;
      
      private var soundEffect:HealingGunSoundEffect;
      
      private var battlefield:IBattleField;
      
      private var graphicEffectDestroyed:Boolean;
      
      private var soundEffectDestroyed:Boolean;
      
      public function HealingGunSFX(objectPool:ObjectPool)
      {
         super(objectPool);
         this.graphicEffect = new HealingGunGraphicEffect(this);
         this.soundEffect = new HealingGunSoundEffect(this);
      }
      
      public function init(mode:IsisActionType, sfxData:HealingGunSFXData, turret:Object3D, localSourcePosition:Vector3, tankData:TankData) : void
      {
         this.graphicEffect.init(mode,sfxData,turret,localSourcePosition,tankData);
         this.soundEffect.init(mode,sfxData,turret);
         this.graphicEffectDestroyed = false;
         this.soundEffectDestroyed = false;
      }
      
      public function set mode(value:IsisActionType) : void
      {
         this.graphicEffect.mode = value;
         this.soundEffect.mode = value;
      }
      
      public function addToBattlefield(battlefield:IBattleField) : void
      {
         this.battlefield = battlefield;
         if(this.isLocalTarget() && cameraEffect.refCounter == 1)
         {
            battlefield.addFollowCameraModifier(cameraEffect);
         }
         battlefield.addGraphicEffect(this.graphicEffect);
         battlefield.addSound3DEffect(this.soundEffect);
      }
      
      public function destroy() : void
      {
         if(this.isLocalTarget())
         {
            --cameraEffect.refCounter;
         }
         this.graphicEffect.kill();
         this.soundEffect.kill();
         this.targetData = null;
         this.battlefield = null;
      }
      
      public function setTargetParams(targetData:TankData, ownerData:TankData, target:Object3D, localTargetPosition:Vector3, mode:IsisActionType) : void
      {
         var showBeamLight:Boolean = true;
         if(this.isLocalTarget())
         {
            --cameraEffect.refCounter;
         }
         this.targetData = targetData;
         if(this.isLocalTarget())
         {
            ++cameraEffect.refCounter;
            if(this.battlefield != null && cameraEffect.refCounter == 1)
            {
               this.battlefield.addFollowCameraModifier(cameraEffect);
            }
         }
         if(targetData != null)
         {
            showBeamLight = true;
         }
         this.graphicEffect.setTargetParams(target,localTargetPosition,ownerData,mode,showBeamLight);
      }
      
      public function onEffectDestroyed(effect:ISpecialEffect) : void
      {
         if(effect == this.graphicEffect)
         {
            this.graphicEffectDestroyed = true;
         }
         if(effect == this.soundEffect)
         {
            this.soundEffectDestroyed = true;
         }
         if(this.graphicEffectDestroyed && this.soundEffectDestroyed)
         {
            storeInPool();
         }
      }
      
      override protected function getClass() : Class
      {
         return HealingGunSFX;
      }
      
      private function isLocalTarget() : Boolean
      {
         return this.targetData != null && this.targetData == TankData.localTankData;
      }
   }
}
