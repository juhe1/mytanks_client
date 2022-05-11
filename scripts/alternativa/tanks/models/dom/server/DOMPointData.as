package alternativa.tanks.models.dom.server
{
   import alternativa.math.Vector3;
   
   public class DOMPointData
   {
       
      
      public var pos:Vector3;
      
      public var id:int;
      
      public var radius:Number;
      
      public var score:Number;
      
      public var occupatedUsers:Vector.<String>;
      
      public function DOMPointData()
      {
         super();
      }
   }
}
