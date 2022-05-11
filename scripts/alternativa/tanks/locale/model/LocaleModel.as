package alternativa.tanks.locale.model
{
   import alternativa.model.IModel;
   import alternativa.model.IObjectLoadListener;
   import alternativa.object.ClientObject;
   import com.alternativaplatform.client.models.core.users.model.localized.ILocalizedModelBase;
   import com.alternativaplatform.client.models.core.users.model.localized.LocalizedModelBase;
   
   public class LocaleModel extends LocalizedModelBase implements ILocalizedModelBase, IObjectLoadListener
   {
       
      
      public function LocaleModel()
      {
         super();
         _interfaces.push(IModel);
         _interfaces.push(ILocalizedModelBase);
         _interfaces.push(IObjectLoadListener);
      }
      
      public function objectLoaded(object:ClientObject) : void
      {
      }
      
      public function objectUnloaded(object:ClientObject) : void
      {
      }
   }
}
