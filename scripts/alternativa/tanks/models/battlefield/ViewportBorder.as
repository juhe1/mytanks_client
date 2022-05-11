package alternativa.tanks.models.battlefield
{
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.Graphics;
   import flash.geom.Matrix;
   
   public class ViewportBorder
   {
      
[Embed(source="1010.png")]
      private static var bmpClassCorner1:Class;
      
      private static var bmdCorner1:BitmapData = Bitmap(new bmpClassCorner1()).bitmapData;
      
[Embed(source="1009.png")]
      private static var bmpClassCorner2:Class;
      
      private static var bmdCorner2:BitmapData = Bitmap(new bmpClassCorner2()).bitmapData;
      
[Embed(source="1012.png")]
      private static var bmpClassCorner3:Class;
      
      private static var bmdCorner3:BitmapData = Bitmap(new bmpClassCorner3()).bitmapData;
      
[Embed(source="1011.png")]
      private static var bmpClassCorner4:Class;
      
      private static var bmdCorner4:BitmapData = Bitmap(new bmpClassCorner4()).bitmapData;
      
[Embed(source="883.png")]
      private static var bmpClassBorderLeft:Class;
      
      private static var bmdBorderLeft:BitmapData = Bitmap(new bmpClassBorderLeft()).bitmapData;
      
[Embed(source="986.png")]
      private static var bmpClassBorderRight:Class;
      
      private static var bmdBorderRight:BitmapData = Bitmap(new bmpClassBorderRight()).bitmapData;
      
[Embed(source="796.png")]
      private static var bmpClassBorderTop:Class;
      
      private static var bmdBorderTop:BitmapData = Bitmap(new bmpClassBorderTop()).bitmapData;
      
[Embed(source="1201.png")]
      private static var bmpClassBorderBottom:Class;
      
      private static var bmdBorderBottom:BitmapData = Bitmap(new bmpClassBorderBottom()).bitmapData;
       
      
      public function ViewportBorder()
      {
         super();
      }
      
      public function draw(g:Graphics, w:int, h:int) : void
      {
         this.fillBorderRect(g,bmdCorner1,4 - bmdCorner1.width,4 - bmdCorner1.height,bmdCorner1.width,bmdCorner1.height);
         this.fillBorderRect(g,bmdCorner2,w - 4,4 - bmdCorner2.height,bmdCorner2.width,bmdCorner2.height);
         this.fillBorderRect(g,bmdCorner3,4 - bmdCorner3.width,h - 4,bmdCorner3.width,bmdCorner3.height);
         this.fillBorderRect(g,bmdCorner4,w - 4,h - 4,bmdCorner4.width,bmdCorner4.height);
         this.fillBorderRect(g,bmdBorderTop,4,4 - bmdBorderTop.height,w - 2 * 4,bmdBorderTop.height);
         this.fillBorderRect(g,bmdBorderBottom,4,h - 4,w - 2 * 4,bmdBorderBottom.height);
         this.fillBorderRect(g,bmdBorderLeft,4 - bmdBorderLeft.width,4,bmdBorderLeft.width,h - 2 * 4);
         this.fillBorderRect(g,bmdBorderRight,w - 4,4,bmdBorderRight.width,h - 2 * 4);
      }
      
      private function fillBorderRect(g:Graphics, bitmap:BitmapData, x:int, y:int, w:int, h:int) : void
      {
         var m:Matrix = new Matrix();
         m.tx = x;
         m.ty = y;
         g.beginBitmapFill(bitmap,m);
         g.drawRect(x,y,w,h);
         g.endFill();
      }
   }
}
