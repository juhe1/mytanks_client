package alternativa.tanks.models.longterm
{
   import alternativa.model.IModel;
   import alternativa.object.ClientObject;
   import alternativa.types.Long;
   import com.alternativaplatform.projects.tanks.client.warfare.models.common.longterm.ILongTermBonusModelBase;
   import com.alternativaplatform.projects.tanks.client.warfare.models.common.longterm.LongTermBonusModelBase;
   
   public class LongTermBonusModel extends LongTermBonusModelBase implements ILongTermBonusModelBase
   {
       
      
      public function LongTermBonusModel()
      {
         super();
         _interfaces.push(IModel,ILongTermBonusModelBase);
      }
      
      public function effectStart(clientObject:ClientObject, tankId:Long, durationSec:int) : void
      {
      }
      
      public function effectStop(clientObject:ClientObject, tankId:Long) : void
      {
      }
   }
}
