package alternativa.tanks.models.battlefield.effects.levelup
{
   import alternativa.engine3d.core.MipMapping;
   import alternativa.engine3d.core.Object3D;
   import alternativa.engine3d.materials.TextureMaterial;
   import alternativa.init.Main;
   import alternativa.math.Vector3;
   import alternativa.physics.RayHit;
   import alternativa.tanks.engine3d.MaterialType;
   import alternativa.tanks.models.battlefield.BattlefieldModel;
   import alternativa.tanks.models.battlefield.IBattleField;
   import alternativa.tanks.models.battlefield.effects.levelup.levelup.LightBeamEffect;
   import alternativa.tanks.models.battlefield.effects.levelup.levelup.LightWaveEffect;
   import alternativa.tanks.models.battlefield.effects.levelup.levelup.SparkEffect;
   import alternativa.tanks.models.battlefield.effects.levelup.rangs.BigRangIcon;
   import alternativa.tanks.services.materialregistry.IMaterialRegistry;
   import alternativa.tanks.vehicles.tanks.Tank;
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.BlendMode;
   
   public class LevelUpEffect
   {
      
[Embed(source="1146.png")]
      private static const BeamTexture:Class;
      
      private static const beamBitmapData:BitmapData = new BeamTexture().bitmapData;
      
[Embed(source="759.png")]
      private static const SparkTexture:Class;
      
      private static const sparkBitmapData:BitmapData = new SparkTexture().bitmapData;
      
[Embed(source="1189.png")]
      private static const WaveTexture:Class;
      
      private static const waveBitmapData:BitmapData = new WaveTexture().bitmapData;
      
      private static const origin:Vector3 = new Vector3();
      
      private static const upDirection:Vector3 = new Vector3(0,0,1);
      
      private static const rayHit:RayHit = new RayHit();
      
      private static var materialRegistry:IMaterialRegistry;
       
      
      private var battlefield:BattlefieldModel;
      
      public function LevelUpEffect()
      {
         super();
         this.battlefield = Main.osgi.getService(IBattleField) as BattlefieldModel;
         materialRegistry = IMaterialRegistry(Main.osgi.getService(IMaterialRegistry));
      }
      
      private static function getAvailableHeight(param1:Number, param2:Number, param3:Number, param4:Number) : Number
      {
         return 2000;
      }
      
      public function createEffect(param1:Tank, param2:int) : void
      {
         var _loc3_:Object3D = param1.skin.turretMesh;
         var _loc4_:Number = this.getEffectHeight(_loc3_.x,_loc3_.y,_loc3_.z);
         this.createLightBeams(_loc4_,_loc3_);
         this.createLabel(param1.id,_loc4_,param2,_loc3_);
         this.createSparks(_loc4_,_loc3_);
         this.createWave(_loc3_);
      }
      
      private function getEffectHeight(param1:Number, param2:Number, param3:Number) : Number
      {
         var _loc6_:Number = getAvailableHeight(param1,param2,param3,2000);
         return Math.max(500,_loc6_);
      }
      
      private function createLightBeams(param1:Number, param2:Object3D) : void
      {
         var _loc9_:Number = NaN;
         var _loc10_:Number = NaN;
         var _loc11_:LightBeamEffect = null;
         var _loc5_:Number = 0;
         var _loc6_:Number = Math.PI * 2 / 6;
         var _loc7_:TextureMaterial = materialRegistry.textureMaterialRegistry.getMaterial(MaterialType.EFFECT,beamBitmapData,beamBitmapData.height / beamBitmapData.width,false);
         var _loc8_:int = 0;
         while(_loc8_ < 6)
         {
            _loc9_ = Math.sin(_loc5_) * 90;
            _loc10_ = Math.cos(_loc5_) * 90;
            _loc11_ = LightBeamEffect(this.battlefield.getObjectPool().getObject(LightBeamEffect));
            _loc11_.init(500,200,30,param1,0.8,0.5,_loc9_,_loc10_,-50,param2,_loc7_);
            this.battlefield.addGraphicEffect(_loc11_);
            _loc5_ += _loc6_;
            _loc8_++;
         }
      }
      
      private function createLabel(param1:int, param2:Number, param3:int, param4:Object3D) : void
      {
         var rangBitmap:Bitmap = new Bitmap(BigRangIcon.getRangIcon(param3));
         var _loc8_:BitmapData = new BitmapData(rangBitmap.width,rangBitmap.height,true,0);
         _loc8_.draw(rangBitmap);
         var _loc9_:TextureMaterial = new TextureMaterial(_loc8_,false,true,MipMapping.PER_PIXEL,1);
         var _loc10_:SparkEffect = SparkEffect(this.battlefield.getObjectPool().getObject(SparkEffect));
         _loc10_.init(500,270,270,0,param2 * 0.8,param2 * 0.15,0.35,0,0,50,param4,_loc9_,BlendMode.NORMAL);
         this.battlefield.addGraphicEffect(_loc10_);
      }
      
      private function createSparks(param1:Number, param2:Object3D) : void
      {
         var _loc3_:int = 0;
         var _loc4_:Number = NaN;
         var _loc5_:TextureMaterial = null;
         var _loc6_:int = 0;
         var _loc7_:Number = NaN;
         var _loc8_:Number = NaN;
         var _loc9_:Number = NaN;
         var _loc10_:Number = NaN;
         var _loc11_:SparkEffect = null;
         _loc3_ = 15;
         _loc4_ = 100;
         _loc5_ = materialRegistry.textureMaterialRegistry.getMaterial(MaterialType.EFFECT,sparkBitmapData,sparkBitmapData.height / sparkBitmapData.width,false);
         _loc6_ = 0;
         while(_loc6_ < _loc3_)
         {
            _loc7_ = Math.PI * 2 * Math.random();
            _loc8_ = Math.sin(_loc7_) * _loc4_;
            _loc9_ = Math.cos(_loc7_) * _loc4_;
            _loc10_ = -110 * _loc6_ - 50;
            _loc11_ = SparkEffect(this.battlefield.getObjectPool().getObject(SparkEffect));
            _loc11_.init(400,150,150,_loc7_,param1 * 0.7,param1 * 0.15,0.7,_loc8_,_loc9_,_loc10_,param2,_loc5_,BlendMode.ADD);
            this.battlefield.addGraphicEffect(_loc11_);
            _loc6_++;
         }
      }
      
      private function createWave(param1:Object3D) : void
      {
         var _loc2_:TextureMaterial = materialRegistry.textureMaterialRegistry.getMaterial(MaterialType.EFFECT,waveBitmapData,waveBitmapData.height / waveBitmapData.width,false);
         var _loc3_:LightWaveEffect = LightWaveEffect(this.battlefield.getObjectPool().getObject(LightWaveEffect));
         _loc3_.init(900,220,3,true,param1,_loc2_);
         this.battlefield.addGraphicEffect(_loc3_);
      }
   }
}
