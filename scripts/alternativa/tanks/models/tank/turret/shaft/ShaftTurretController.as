package alternativa.tanks.models.tank.turret.shaft
{
   import alternativa.init.Main;
   import alternativa.tanks.models.tank.ITank;
   import alternativa.tanks.models.tank.TankData;
   import alternativa.tanks.models.tank.TankModel;
   import alternativa.tanks.models.tank.turret.TurretController;
   import alternativa.tanks.vehicles.tanks.Tank;
   
   public class ShaftTurretController implements TurretController
   {
       
      
      private var tankData:TankData;
      
      private var tankModel:TankModel;
      
      private var playSound:Boolean = true;
      
      public function ShaftTurretController(tankData:TankData)
      {
         super();
         this.tankData = tankData;
         this.tankModel = Main.osgi.getService(ITank) as TankModel;
         tankData.sounds.playTurretSound(false);
      }
      
      public function rotateTurret(deltaSec:Number) : void
      {
         var tank:Tank = this.tankData.tank;
         var turretRotationDir:int = ((int(int(this.tankData.ctrlBits & TankModel.TURRET_LEFT)) || int(int(this.tankData.ctrlBits & TankModel.LEFT))) >> 4) - ((int(int(this.tankData.ctrlBits & TankModel.TURRET_RIGHT)) || int(int(this.tankData.ctrlBits & TankModel.RIGHT))) >> 5);
         var turretRotationDirAddition:int = ((this.tankData.ctrlBits & TankModel.LEFT) >> 2) - ((this.tankData.ctrlBits & TankModel.RIGHT) >> 3);
         if(turretRotationDir == 0)
         {
            turretRotationDir = turretRotationDirAddition;
         }
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
         if(this.playSound)
         {
            this.tankData.sounds.playTurretSound(this.tankData.tank.turretTurnSpeed != 0);
         }
      }
      
      public function enableTurretSound(value:Boolean) : void
      {
         this.playSound = value;
      }
   }
}
