package alternativa.tanks.models.weapon
{
   import alternativa.engine3d.core.Object3D;
   import alternativa.math.Matrix4;
   import alternativa.math.Vector3;
   
   public class WeaponUtils
   {
      
      private static var instance:WeaponUtils;
      
      private static var turretMatrix:Matrix4 = new Matrix4();
      
      private static var localBarrelOrigin:Vector3 = new Vector3();
       
      
      public function WeaponUtils()
      {
         super();
      }
      
      public static function getInstance() : WeaponUtils
      {
         if(instance == null)
         {
            instance = new WeaponUtils();
         }
         return instance;
      }
      
      public function calculateMainGunParams(param1:Object3D, param2:Vector3, param3:AllGlobalGunParams) : void
      {
         turretMatrix.setFromMatrix3D(param1.concatenatedMatrix);
         turretMatrix.transformVector(param2,param3.muzzlePosition);
         localBarrelOrigin.x = param2.x;
         localBarrelOrigin.z = param2.z;
         turretMatrix.transformVector(localBarrelOrigin,param3.barrelOrigin);
         param3.elevationAxis.x = turretMatrix.a;
         param3.elevationAxis.y = turretMatrix.e;
         param3.elevationAxis.z = turretMatrix.i;
         param3.direction.x = turretMatrix.b;
         param3.direction.y = turretMatrix.f;
         param3.direction.z = turretMatrix.j;
      }
      
      public function calculateGunParams(turret:Object3D, localMuzzlePosition:Vector3, globalMuzzlePosition:Vector3, barrelOrigin:Vector3, turretAxisX:Vector3, turretAxisY:Vector3) : void
      {
         turretMatrix.setMatrix(turret.x,turret.y,turret.z,turret.rotationX,turret.rotationY,turret.rotationZ);
         turretMatrix.transformVector(localMuzzlePosition,globalMuzzlePosition);
         localBarrelOrigin.x = localMuzzlePosition.x;
         localBarrelOrigin.z = localMuzzlePosition.z;
         turretMatrix.transformVector(localBarrelOrigin,barrelOrigin);
         turretAxisX.x = turretMatrix.a;
         turretAxisX.y = turretMatrix.e;
         turretAxisX.z = turretMatrix.i;
         turretAxisY.x = turretMatrix.b;
         turretAxisY.y = turretMatrix.f;
         turretAxisY.z = turretMatrix.j;
      }
      
      public function calculateGunParamsAux(turret:Object3D, localMuzzlePosition:Vector3, globalMuzzlePosition:Vector3, turretAxisY:Vector3) : void
      {
         turretMatrix.setMatrix(turret.x,turret.y,turret.z,turret.rotationX,turret.rotationY,turret.rotationZ);
         turretMatrix.transformVector(localMuzzlePosition,globalMuzzlePosition);
         turretAxisY.x = turretMatrix.b;
         turretAxisY.y = turretMatrix.f;
         turretAxisY.z = turretMatrix.j;
      }
   }
}
