package controls.base
{
   import controls.ColorButton;
   
   public class ColorButtonBase extends ColorButton
   {
       
      
      public function ColorButtonBase()
      {
         super();
      }
      
      override public function configUI() : void
      {
         super.configUI();
         _label.sharpness = 40;
         _label.thickness = 70;
      }
   }
}
