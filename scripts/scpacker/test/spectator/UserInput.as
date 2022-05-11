package scpacker.test.spectator
{
   public interface UserInput
   {
       
      
      function getForwardDirection() : int;
      
      function getSideDirection() : int;
      
      function getVerticalDirection() : int;
      
      function isAcceleratied() : Boolean;
      
      function getYawDirection() : int;
      
      function getPitchDirection() : int;
      
      function isRotating() : Boolean;
      
      function reset() : void;
   }
}
