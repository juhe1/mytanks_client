package alternativa.tanks.model
{
   import alternativa.init.Main;
   import alternativa.model.IModel;
   import alternativa.object.ClientObject;
   import alternativa.service.IModelService;
   import com.alternativaplatform.projects.tanks.client.commons.models.itemtype.ItemTypeEnum;
   import com.alternativaplatform.projects.tanks.client.garage.item.IItemModelBase;
   import com.alternativaplatform.projects.tanks.client.garage.item.ItemModelBase;
   import com.alternativaplatform.projects.tanks.client.garage.item.ModificationInfo;
   import flash.utils.Dictionary;
   
   public class ItemModel extends ItemModelBase implements IItemModelBase, IItem
   {
       
      
      private var params:Dictionary;
      
      public function ItemModel()
      {
         super();
         _interfaces.push(IModel);
         _interfaces.push(IItem);
         _interfaces.push(IItemModelBase);
         this.params = new Dictionary();
      }
      
      public function initObject(clientObject:ClientObject, baseItemId:String, description:String, itemIndex:int, itemType:ItemTypeEnum, modificationIndex:int, modifications:Array, name:String, previewId:String) : void
      {
         var nextModInfo:ModificationInfo = null;
         var i:int = 0;
         var modInfo:ModificationInfo = ModificationInfo(modifications[modificationIndex]);
         if(modifications[modificationIndex + 1] != null)
         {
            nextModInfo = ModificationInfo(modifications[modificationIndex + 1]);
         }
         this.params[clientObject] = new ItemParams(baseItemId,description,itemType == ItemTypeEnum.INVENTORY,itemIndex,modInfo.itemProperties,itemType,modificationIndex,name,nextModInfo != null ? int(int(nextModInfo.crystalPrice)) : int(int(0)),nextModInfo != null ? nextModInfo.itemProperties : null,nextModInfo != null ? int(int(nextModInfo.rankId)) : int(int(0)),previewId,modInfo.crystalPrice,modInfo.rankId,modifications);
         Main.writeVarsToConsoleChannel("ITEM MODEL","initObject  baseItemId: %1",baseItemId);
         var modelRegister:IModelService = Main.osgi.getService(IModelService) as IModelService;
         var listeners:Vector.<IModel> = modelRegister.getModelsByInterface(IItemListener);
         if(listeners != null)
         {
            for(i = 0; i < listeners.length; i++)
            {
               (listeners[i] as IItemListener).itemLoaded(clientObject,this.params[clientObject]);
            }
         }
      }
      
      public function getParams(item:ClientObject) : ItemParams
      {
         return this.params[item];
      }
   }
}
