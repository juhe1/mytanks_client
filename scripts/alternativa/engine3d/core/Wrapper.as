package alternativa.engine3d.core
{
   import alternativa.engine3d.alternativa3d;
   
   use namespace alternativa3d;
   
   public class Wrapper
   {
      
      alternativa3d static var collector:Wrapper;
       
      
      alternativa3d var next:Wrapper;
      
      alternativa3d var vertex:Vertex;
      
      public function Wrapper()
      {
         super();
      }
      
      alternativa3d static function create() : Wrapper
      {
         var _loc1_:Wrapper = null;
         if(collector != null)
         {
            _loc1_ = collector;
            collector = collector.next;
            _loc1_.next = null;
            return _loc1_;
         }
         return new Wrapper();
      }
      
      alternativa3d function create() : Wrapper
      {
         var _loc1_:Wrapper = null;
         if(collector != null)
         {
            _loc1_ = collector;
            collector = collector.next;
            _loc1_.next = null;
            return _loc1_;
         }
         return new Wrapper();
      }
      
      public function getWrapper() : Wrapper
      {
         return this;
      }
      
      public function destroy() : void
      {
         if(this.vertex != null)
         {
            this.vertex = null;
         }
      }
   }
}
