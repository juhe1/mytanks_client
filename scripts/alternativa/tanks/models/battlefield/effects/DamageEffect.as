package alternativa.tanks.models.battlefield.effects
{
   import alternativa.engine3d.core.MipMapping;
   import alternativa.engine3d.core.Object3D;
   import alternativa.engine3d.materials.TextureMaterial;
   import alternativa.init.Main;
   import alternativa.math.Vector3;
   import alternativa.physics.RayHit;
   import alternativa.tanks.models.battlefield.BattlefieldModel;
   import alternativa.tanks.models.battlefield.IBattleField;
   import alternativa.tanks.vehicles.tanks.Tank;
   import controls.Label;
   import flash.display.BitmapData;
   import flash.display.BlendMode;
   import flash.filters.GlowFilter;
   
   public class DamageEffect
   {
      
      private static const origin:Vector3 = new Vector3();
      
      private static const upDirection:Vector3 = new Vector3(0,0,1);
      
      private static const rayHit:RayHit = new RayHit();
       
      
      private var battlefield:BattlefieldModel;
      
      public function DamageEffect()
      {
         super();
         this.battlefield = Main.osgi.getService(IBattleField) as BattlefieldModel;
      }
      
      public function createEffect(tank:Tank, damage:int) : void
      {
         var tankObject:Object3D = tank.skin.turretMesh;
         this.createLabel(tank.id,350,damage,tankObject);
      }
      
      private function createLabel(tankId:int, height:Number, damage:int, tank:Object3D) : void
      {
         var damageLabel:Label = null;
         damageLabel = new Label();
         damageLabel.text = damage.toString();
         damageLabel.filters = [new GlowFilter(0,0.8,4,4,3)];
         damageLabel.textColor = 16777215;
         damageLabel.size = 18;
         var damageBitmap:BitmapData = new BitmapData(damageLabel.textWidth + 20,damageLabel.textHeight + 10,true,16777215);
         damageBitmap.draw(damageLabel);
         var damageTexture:TextureMaterial = new TextureMaterial(damageBitmap,false,true,MipMapping.PER_PIXEL,1);
         var damageEffect:DamageUpEffect = DamageUpEffect(this.battlefield.getObjectPool().getObject(DamageUpEffect));
         damageEffect.init(500,50,30,0,height * 0.8,height * 0.15,0.75,0,0,125,tank,damageTexture,BlendMode.NORMAL);
         this.battlefield.addGraphicEffect(damageEffect);
      }
   }
}
