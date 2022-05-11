package scpacker.resource.tanks
{
   import flash.utils.Dictionary;
   
   public class TankResourceList
   {
       
      
      public var models:Dictionary;
      
      public function TankResourceList()
      {
         super();
         this.models = new Dictionary();
      }
      
      public function add(model:TankResource) : void
      {
         if(this.models[model.id] == null)
         {
            if(model.mesh == null)
            {
               throw new Error("Model null!");
            }
            this.models[model.id] = model;
         }
         else
         {
            trace("Model arleady registered!");
         }
      }
      
      public function getModel(key:String) : TankResource
      {
         return this.models[key];
      }
   }
}
