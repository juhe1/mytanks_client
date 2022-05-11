package alternativa.tanks.gui
{
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.Sprite;
   
   public class UpgradeIndicator extends Sprite
   {
      
[Embed(source="1034.png")]
      private static const bitmapUpgradeIconFull:Class;
      
      private static const upgradeIconFullBd:BitmapData = new bitmapUpgradeIconFull().bitmapData;
      
[Embed(source="1170.png")]
      private static const bitmapUpgradeIconEmpty:Class;
      
      private static const upgradeIconEmptyBd:BitmapData = new bitmapUpgradeIconEmpty().bitmapData;
       
      
      private var cells:Array;
      
      private var space:int = 2;
      
      private var cellsNum:int = 3;
      
      private var _value:int;
      
      public function UpgradeIndicator()
      {
         var cell:Bitmap = null;
         super();
         this.cells = new Array();
         for(var i:int = 0; i < this.cellsNum; i++)
         {
            cell = new Bitmap(upgradeIconEmptyBd);
            addChild(cell);
            this.cells.push(cell);
            cell.x = i * (cell.width + this.space);
         }
      }
      
      public function set value(v:int) : void
      {
         var cell:Bitmap = null;
         if(v > this.cellsNum)
         {
            this._value = this.cellsNum;
         }
         else if(v < 0)
         {
            this._value = 0;
         }
         else
         {
            this._value = v;
         }
         for(var i:int = 0; i < this.cellsNum; i++)
         {
            cell = this.cells[i] as Bitmap;
            if(i < this._value)
            {
               cell.bitmapData = upgradeIconFullBd;
            }
            else
            {
               cell.bitmapData = upgradeIconEmptyBd;
            }
         }
      }
   }
}
