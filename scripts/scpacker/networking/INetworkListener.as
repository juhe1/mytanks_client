package scpacker.networking
{
   import scpacker.networking.commands.Command;
   
   public interface INetworkListener
   {
       
      
      function onData(param1:Command) : void;
   }
}
