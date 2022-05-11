package alternativa.tanks.model
{
   import alternativa.init.Main;
   import alternativa.model.IModel;
   import alternativa.service.IModelService;
   import com.alternativaplatform.projects.tanks.client.garage.effects.effectableitem.EffectableItemModelBase;
   import com.alternativaplatform.projects.tanks.client.garage.effects.effectableitem.IEffectableItemModelBase;
   import flash.utils.Dictionary;
   
   public class ItemEffectModel extends EffectableItemModelBase implements IEffectableItemModelBase, IItemEffect
   {
       
      
      private var modelRegister:IModelService;
      
      private var remainingTime:Dictionary;
      
      private var timers:Dictionary;
      
      private var idByTimer:Dictionary;
      
      public function ItemEffectModel()
      {
         super();
         _interfaces.push(IModel);
         _interfaces.push(IItemEffect);
         _interfaces.push(IEffectableItemModelBase);
         this.remainingTime = new Dictionary();
         this.idByTimer = new Dictionary();
         this.modelRegister = Main.osgi.getService(IModelService) as IModelService;
      }
      
      public function setRemaining(clientObject:String, remaining:Number) : void
      {
         var i:int = 0;
         this.remainingTime[clientObject] = remaining;
         var listeners:Vector.<IModel> = this.modelRegister.getModelsByInterface(IItemEffectListener);
         if(listeners != null)
         {
            for(i = 0; i < listeners.length; i++)
            {
               (listeners[i] as IItemEffectListener).setTimeRemaining(clientObject,remaining);
            }
         }
      }
      
      public function effectStopped(clientObject:String) : void
      {
         var i:int = 0;
         this.remainingTime[clientObject] = null;
         var listeners:Vector.<IModel> = this.modelRegister.getModelsByInterface(IItemEffectListener);
         if(listeners != null)
         {
            for(i = 0; i < listeners.length; i++)
            {
               (listeners[i] as IItemEffectListener).effectStopped(clientObject);
            }
         }
      }
      
      public function getTimeRemaining(itemId:String) : Number
      {
         return Number(this.remainingTime[itemId]);
      }
   }
}
