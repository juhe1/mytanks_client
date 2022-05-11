package alternativa.tanks.models.battlefield
{
   import alternativa.engine3d.core.Camera3D;
   import alternativa.engine3d.core.Shadow;
   import flash.utils.Dictionary;
   
   public class AmbientShadows
   {
       
      
      private var camera:Camera3D;
      
      private const shadows:Dictionary = new Dictionary();
      
      private var enabled:Boolean;
      
      public function AmbientShadows(param1:Camera3D)
      {
         super();
         this.camera = param1;
      }
      
      public function add(param1:Shadow) : void
      {
         this.shadows[param1] = true;
         if(this.enabled)
         {
            this.camera.addShadow(param1);
         }
      }
      
      public function remove(param1:Shadow) : void
      {
         delete this.shadows[param1];
         if(this.enabled)
         {
            this.camera.removeShadow(param1);
         }
      }
      
      public function enable() : void
      {
         var _loc1_:* = undefined;
         if(!this.enabled)
         {
            this.enabled = true;
            for(_loc1_ in this.shadows)
            {
               this.camera.addShadow(_loc1_);
            }
         }
      }
      
      public function disable() : void
      {
         var _loc1_:* = undefined;
         if(this.enabled)
         {
            this.enabled = false;
            for(_loc1_ in this.shadows)
            {
               this.camera.removeShadow(_loc1_);
            }
         }
      }
   }
}
