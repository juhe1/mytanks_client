package alternativa.tanks.models.effects.common
{
   import alternativa.object.ClientObject;
   import alternativa.tanks.bonuses.IBonus;
   
   public interface IBonusCommonModel
   {
       
      
      function getBonus(param1:ClientObject, param2:String, param3:int, param4:Boolean) : IBonus;
   }
}
