package alternativa.tanks.models.tank.turret.default
{
   import alternativa.init.Main;
   import alternativa.tanks.models.tank.ITank;
   import alternativa.tanks.models.tank.TankData;
   import alternativa.tanks.models.tank.TankModel;
   import alternativa.tanks.models.tank.turret.TurretController;
   import alternativa.tanks.vehicles.tanks.Tank;
   
   public class DefaultTurretController implements TurretController
   {
       
      
      private var tankData:TankData;
      
      private var tankModel:TankModel;
      
      public function DefaultTurretController(tankData:TankData)
      {
         super();
         this.tankData = tankData;
         this.tankModel = Main.osgi.getService(ITank) as TankModel;
      }
      
      public function rotateTurret(deltaSec:Number) : void
      {
         var tank:Tank = this.tankData.tank;
         var turretRotationDir:int = ((this.tankData.ctrlBits & TankModel.TURRET_LEFT) >> 4) - ((this.tankData.ctrlBits & TankModel.TURRET_RIGHT) >> 5);
         if(turretRotationDir != 0)
         {
            if((this.tankData.ctrlBits & TankModel.CENTER_TURRET) != 0)
            {
               this.tankData.ctrlBits &= ~TankModel.CENTER_TURRET;
               if(this.tankData.local)
               {
                  this.tankModel.controlBits &= ~TankModel.CENTER_TURRET;
               }
               if(tank.turretDirSign == turretRotationDir)
               {
                  tank.stopTurret();
                  this.tankData.sounds.playTurretSound(false);
               }
            }
            tank.rotateTurret(turretRotationDir * deltaSec,false);
         }
         else if((this.tankData.ctrlBits & TankModel.CENTER_TURRET) != 0)
         {
            if(tank.rotateTurret(-tank.turretDirSign * deltaSec,true))
            {
               this.tankData.ctrlBits &= ~TankModel.CENTER_TURRET;
               tank.stopTurret();
            }
         }
         else
         {
            tank.stopTurret();
         }
         this.tankData.sounds.playTurretSound(this.tankData.tank.turretTurnSpeed != 0);
      }
      
      public function enableTurretSound(value:Boolean) : void
      {
      }
   }
}
