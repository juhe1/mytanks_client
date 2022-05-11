package alternativa.debug
{
   public interface IDebugCommandProvider
   {
       
      
      function registerCommand(param1:String, param2:IDebugCommandHandler) : void;
      
      function unregisterCommand(param1:String) : void;
      
      function executeCommand(param1:String) : String;
   }
}
