package alternativa.tanks.vehicles.tanks
{
   import alternativa.engine3d.objects.Mesh;
   import alternativa.math.Vector3;
   import alternativa.tanks.models.battlefield.Object3DNames;
   
   public class TankSkinHull extends TankSkinPart
   {
       
      
      public var turretMountPoint:Vector3;
      
      public var mesh1:Mesh;
      
      public function TankSkinHull(mesh2:Mesh, turretMountPoint:Vector3)
      {
         super(mesh2,true);
         this.mesh1 = mesh2;
         this.turretMountPoint = turretMountPoint;
         mesh2.shadowMapAlphaThreshold = 0.1;
         mesh2.calculateVerticesNormalsBySmoothingGroups(0.01);
         mesh2.name = Object3DNames.TANK_PART;
      }
      
      override protected function getMesh() : Mesh
      {
         return this.mesh1;
      }
   }
}
