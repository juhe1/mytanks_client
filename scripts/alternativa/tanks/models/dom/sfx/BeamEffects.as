package alternativa.tanks.models.dom.sfx
{
   import alternativa.object.ClientObject;
   import alternativa.tanks.models.battlefield.BattlefieldModel;
   import alternativa.tanks.sfx.IGraphicEffect;
   import flash.utils.Dictionary;
   
   public class BeamEffects
   {
       
      
      private var effects:Dictionary;
      
      private var battleService:BattlefieldModel;
      
      public function BeamEffects(battleService:BattlefieldModel)
      {
         super();
         this.effects = new Dictionary();
         this.battleService = battleService;
      }
      
      public function addEffect(param1:ClientObject, param2:IGraphicEffect) : void
      {
         this.effects[param1] = param2;
         this.battleService.addGraphicEffect(param2);
      }
      
      public function removeEffect(param1:ClientObject) : void
      {
         var _loc2_:IGraphicEffect = this.effects[param1];
         if(_loc2_ != null)
         {
            _loc2_.kill();
            delete this.effects[param1];
         }
      }
   }
}
