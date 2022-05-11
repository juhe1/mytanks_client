package alternativa.model
{
   import alternativa.object.ClientObject;
   
   public interface IObjectLoadListener
   {
       
      
      function objectLoaded(param1:ClientObject) : void;
      
      function objectUnloaded(param1:ClientObject) : void;
   }
}
