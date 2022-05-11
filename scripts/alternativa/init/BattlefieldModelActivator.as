package alternativa.init
{
   import alternativa.model.IModel;
   import alternativa.osgi.bundle.IBundleActivator;
   import alternativa.service.IModelService;
   import alternativa.tanks.models.battlefield.BattlefieldModel;
   import alternativa.tanks.models.battlefield.mine.BattleMinesModel;
   import alternativa.tanks.models.ctf.CTFModel;
   import alternativa.tanks.models.tank.TankModel;
   import alternativa.tanks.models.tank.explosion.TankExplosionModel;
   
   public class BattlefieldModelActivator implements IBundleActivator
   {
       
      
      public var models:Vector.<IModel>;
      
      public var bm:BattlefieldModel;
      
      public function BattlefieldModelActivator()
      {
         this.models = new Vector.<IModel>();
         super();
      }
      
      public function start(_osgi:OSGi) : void
      {
         var modelsRegister:IModelService = _osgi.getService(IModelService) as IModelService;
         this.addModel(modelsRegister,this.bm = new BattlefieldModel());
         this.addModel(modelsRegister,new TankModel());
         this.addModel(modelsRegister,new TankExplosionModel());
         this.addModel(modelsRegister,new CTFModel());
         this.addModel(modelsRegister,new BattleMinesModel());
      }
      
      public function stop(_osgi:OSGi) : void
      {
         var model:IModel = null;
         var modelRegister:IModelService = _osgi.getService(IModelService) as IModelService;
         while(this.models.length > 0)
         {
            model = this.models.pop();
            modelRegister.remove(model.id);
         }
      }
      
      private function addModel(modelsRegister:IModelService, model:IModel) : void
      {
         modelsRegister.add(model);
         this.models.push(model);
      }
   }
}
