package alternativa.tanks.vehicles.tanks
{
   import alternativa.engine3d.objects.Mesh;
   import alternativa.math.Vector3;
   import alternativa.tanks.models.battlefield.Object3DNames;
   
   public class TankSkinTurret extends TankSkinPart
   {
       
      
      public var flagMountPoint:Vector3;
      
      public var mesh1:Mesh;
      
      public var shaftMuzzle:Vector3;
      
      public function TankSkinTurret(mesh:Mesh, flagMountPoint:Vector3, muzzle:Vector3)
      {
         super(mesh,false);
         this.flagMountPoint = flagMountPoint;
         this.mesh1 = mesh;
         this.shaftMuzzle = muzzle;
         mesh.shadowMapAlphaThreshold = 0.1;
         mesh.calculateVerticesNormalsBySmoothingGroups(0.01);
         mesh.name = Object3DNames.TANK_PART;
      }
      
      override protected function getMesh() : Mesh
      {
         return this.mesh1;
      }
   }
}
