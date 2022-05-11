package alternativa.tanks.model
{
   import scpacker.resource.images.ImageResource;
   
   public interface IGarage
   {
       
      
      function setHull(param1:String) : void;
      
      function setTurret(param1:String) : void;
      
      function setColorMap(param1:ImageResource) : void;
   }
}
