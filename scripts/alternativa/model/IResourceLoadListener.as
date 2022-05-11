package alternativa.model
{
   import alternativa.types.Long;
   
   public interface IResourceLoadListener
   {
       
      
      function resourceLoaded(param1:Object) : void;
      
      function resourceUnloaded(param1:Long) : void;
   }
}
