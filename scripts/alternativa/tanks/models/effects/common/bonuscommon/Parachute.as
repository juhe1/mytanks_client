package alternativa.tanks.models.effects.common.bonuscommon
{
   import alternativa.engine3d.core.Object3DContainer;
   import alternativa.engine3d.objects.Mesh;
   import alternativa.math.Vector3;
   
   public class Parachute extends Object3DContainer
   {
      
      public static const RADIUS:Number = 266;
      
      public static const NUM_STRAPS:int = 12;
       
      
      private var ownAlpha:Number = 1;
      
      private var alphaMultiplier:Number = 1;
      
      public function Parachute(outerMeshSource:Mesh, innerMeshSource:Mesh)
      {
         super();
         this.addMesh(Mesh(outerMeshSource.clone()));
         this.addMesh(Mesh(innerMeshSource.clone()));
      }
      
      private function addMesh(mesh:Mesh) : void
      {
         mesh.shadowMapAlphaThreshold = 0.1;
         mesh.calculateVerticesNormalsBySmoothingGroups(0.01);
         addChild(mesh);
         mesh.name = "parachute";
      }
      
      public function recycle() : void
      {
         this.ownAlpha = 1;
         this.alphaMultiplier = 1;
         scaleX = 1;
         scaleY = 1;
         scaleZ = 1;
         alpha = 1;
         BonusCache.putParachute(this);
      }
      
      public function getAlpha() : Number
      {
         return this.ownAlpha;
      }
      
      public function setAlpha(value:Number) : void
      {
         this.ownAlpha = value;
         this.updateAlpha();
      }
      
      private function updateAlpha() : void
      {
         alpha = this.alphaMultiplier * this.ownAlpha;
      }
      
      public function readPosition(result:Vector3) : void
      {
         result.x = x;
         result.y = y;
         result.z = z;
      }
      
      public function setAlphaMultiplier(value:Number) : void
      {
         this.alphaMultiplier = value;
         this.updateAlpha();
      }
   }
}
