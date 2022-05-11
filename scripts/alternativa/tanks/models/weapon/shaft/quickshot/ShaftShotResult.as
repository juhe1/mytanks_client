package alternativa.tanks.models.weapon.shaft.quickshot
{
   import alternativa.math.Vector3;
   import alternativa.tanks.models.tank.TankData;
   
   public class ShaftShotResult
   {
       
      
      public var targets:Array;
      
      public var hitPoints:Array;
      
      public var dir:Vector3;
      
      public function ShaftShotResult()
      {
         this.targets = [];
         this.hitPoints = [];
         this.dir = new Vector3();
         super();
      }
      
      public function toJSON() : String
      {
         var obj:Object = new Object();
         obj.targets = this.targets;
         obj.hitPoints = this.hitPoints;
         obj.dir = this.dir;
         return JSON.stringify(obj,function(key:*, v:*):*
         {
            var vector:* = undefined;
            var tank:* = undefined;
            if(v is Vector3)
            {
               vector = v as Vector3;
               return {
                  "x":vector.x,
                  "y":vector.y,
                  "z":vector.z
               };
            }
            if(v is TankData)
            {
               tank = v as TankData;
               return {"target_id":tank.userName};
            }
            return v;
         });
      }
   }
}
