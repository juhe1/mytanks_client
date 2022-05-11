package controls.cellrenderer
{
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   
   public class CellNormal extends CellRendererDefault
   {
      
[Embed(source="872.png")]
      private static const normalLeft:Class;
      
      private static const normalLeftData:BitmapData = Bitmap(new normalLeft()).bitmapData;
      
[Embed(source="1108.png")]
      private static const normalCenter:Class;
      
      private static const normalCenterData:BitmapData = Bitmap(new normalCenter()).bitmapData;
      
[Embed(source="866.png")]
      private static const normalRight:Class;
      
      private static const normalRightData:BitmapData = Bitmap(new normalRight()).bitmapData;
       
      
      public function CellNormal()
      {
         super();
         bmpLeft = normalLeftData;
         bmpCenter = normalCenterData;
         bmpRight = normalRightData;
      }
   }
}
