package alternativa.tanks.models.effects.common.bonuscommon
{
   public class BattleBonusState
   {
       
      
      public var pivotZ:Number = 0;
      
      public var angleX:Number = 0;
      
      public var angleZ:Number = 0;
      
      public function BattleBonusState()
      {
         super();
      }
      
      public function interpolate(s1:BattleBonusState, s2:BattleBonusState, t:Number) : void
      {
         this.pivotZ = s1.pivotZ + t * (s2.pivotZ - s1.pivotZ);
         this.angleX = s1.angleX + t * (s2.angleX - s1.angleX);
         this.angleZ = s1.angleZ + t * (s2.angleZ - s1.angleZ);
      }
      
      public function copy(src:BattleBonusState) : void
      {
         this.pivotZ = src.pivotZ;
         this.angleX = src.angleX;
         this.angleZ = src.angleZ;
      }
   }
}
