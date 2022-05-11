package alternativa.tanks.display.usertitle.addition
{
   import controls.TankWindow;
   import flash.display.Sprite;
   
   public class DebugTitle extends Sprite
   {
       
      
      private var window:TankWindow;
      
      public function DebugTitle()
      {
         this.window = new TankWindow();
         super();
         this.window.width = 100;
         this.window.header = 70;
         addChild(this.window);
      }
   }
}
