package alternativa.models.object3ds
{
   import alternativa.object.ClientObject;
   import alternativa.resource.Tanks3DSResource;
   
   public interface IObject3DS
   {
       
      
      function getResource3DS(param1:ClientObject) : Tanks3DSResource;
   }
}
