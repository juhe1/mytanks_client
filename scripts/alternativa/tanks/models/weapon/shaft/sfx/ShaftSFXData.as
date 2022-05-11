package alternativa.tanks.models.weapon.shaft.sfx
{
   import alternativa.engine3d.materials.Material;
   import alternativa.tanks.engine3d.TextureAnimation;
   import flash.media.Sound;
   
   public class ShaftSFXData
   {
       
      
      public var zoomModeSound:Sound;
      
      public var targetingSound:Sound;
      
      public var shotSound:Sound;
      
      public var explosionSound:Sound;
      
      public var trailMaterial:Material;
      
      public var trailLength:Number = 500;
      
      public var explosionAnimation:TextureAnimation;
      
      public var muzzleFlashAnimation:TextureAnimation;
      
      public function ShaftSFXData()
      {
         super();
      }
   }
}
