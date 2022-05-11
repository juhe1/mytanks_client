package controls.cellrenderer
{
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   
   public class CellUnavailable extends CellRendererDefault
   {
      
[Embed(source="1004.png")]
      private static const normalLeft:Class;
      
      private static const normalLeftData:BitmapData = Bitmap(new normalLeft()).bitmapData;
      
[Embed(source="828.png")]
      private static const normalCenter:Class;
      
      private static const normalCenterData:BitmapData = Bitmap(new normalCenter()).bitmapData;
      
[Embed(source="1079.png")]
      private static const normalRight:Class;
      
      private static const normalRightData:BitmapData = Bitmap(new normalRight()).bitmapData;
       
      
      public function CellUnavailable()
      {
         super();
         bmpLeft = normalLeftData;
         bmpCenter = normalCenterData;
         bmpRight = normalRightData;
      }
   }
}
