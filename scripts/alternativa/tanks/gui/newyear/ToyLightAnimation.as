package alternativa.tanks.gui.newyear
{
   import alternativa.engine3d.lights.OmniLight;
   
   public class ToyLightAnimation
   {
       
      
      private var omni:OmniLight;
      
      private var up:Boolean = false;
      
      public function ToyLightAnimation(omni:OmniLight)
      {
         super();
         this.omni = omni;
      }
      
      public function update() : void
      {
         if(!this.up)
         {
            this.omni.intensity -= 0.01;
            if(this.omni.intensity <= 0)
            {
               this.up = true;
            }
         }
         else
         {
            this.omni.intensity += 0.01;
            if(this.omni.intensity >= 1)
            {
               this.up = false;
            }
         }
      }
   }
}
