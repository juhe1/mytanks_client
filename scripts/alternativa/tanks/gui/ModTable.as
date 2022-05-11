package alternativa.tanks.gui
{
   import controls.Label;
   import flash.display.BitmapData;
   import flash.display.Shape;
   import flash.display.Sprite;
   import flash.geom.Matrix;
   
   public class ModTable extends Sprite
   {
      
[Embed(source="756.png")]
      private static const bitmapUpgradeSelectionLeft:Class;
      
      private static const selectionLeftBd:BitmapData = new bitmapUpgradeSelectionLeft().bitmapData;
      
[Embed(source="757.png")]
      private static const bitmapUpgradeSelectionCenter:Class;
      
      private static const selectionCenterBd:BitmapData = new bitmapUpgradeSelectionCenter().bitmapData;
      
[Embed(source="1055.png")]
      private static const bitmapUpgradeSelectionRight:Class;
      
      private static const selectionRightBd:BitmapData = new bitmapUpgradeSelectionRight().bitmapData;
       
      
      private var _maxCostWidth:int;
      
      public var constWidth:int;
      
      public var rows:Array;
      
      public const vSpace:int = 0;
      
      private var selection:Shape;
      
      private var selectedRowIndex:int = -1;
      
      private var xt:Boolean;
      
      private var rowCount:int = 4;
      
      public function ModTable()
      {
         var row:ModInfoRow = null;
         super();
         this.rows = new Array();
         this.selection = new Shape();
         addChild(this.selection);
         this.selection.x = 3;
         for(var i:int = 0; i < this.rowCount; i++)
         {
            row = new ModInfoRow();
            addChild(row);
            row.y = (row.h + this.vSpace) * i;
            this.rows.push(row);
            row.upgradeIndicator.value = i;
         }
      }
      
      public function changeRowCount(num:int) : void
      {
         var row:ModInfoRow = null;
         var _row:ModInfoRow = null;
         var i:int = 0;
         row = null;
         this.rowCount = num;
         for each(_row in this.rows)
         {
            removeChild(_row);
         }
         this.rows = new Array();
         for(i = 0; i < this.rowCount; i++)
         {
            row = new ModInfoRow();
            if(num == 1)
            {
               row.hideUpgradeIndicator();
            }
            addChild(row);
            row.y = (row.h + this.vSpace) * i;
            this.rows.push(row);
            row.upgradeIndicator.value = i;
         }
      }
      
      public function select(index:int) : void
      {
         var row:ModInfoRow = null;
         if(this.selectedRowIndex != -1)
         {
            row = ModInfoRow(this.rows[this.selectedRowIndex]);
            if(row != null)
            {
               row.unselect();
            }
         }
         this.selectedRowIndex = index;
         this.selection.y = (ModInfoRow(this.rows[0]).h + this.vSpace) * index;
         row = ModInfoRow(this.rows[this.selectedRowIndex]);
         if(row != null)
         {
            row.select();
         }
      }
      
      public function resizeSelection(w:int) : void
      {
         var width:int = w - 6;
         var m:Matrix = new Matrix();
         this.selection.graphics.clear();
         this.selection.graphics.beginBitmapFill(selectionLeftBd);
         this.selection.graphics.drawRect(0,0,selectionLeftBd.width,selectionLeftBd.height);
         this.selection.graphics.beginBitmapFill(selectionCenterBd);
         this.selection.graphics.drawRect(selectionLeftBd.width,0,width - selectionLeftBd.width - selectionRightBd.width,selectionCenterBd.height);
         m.tx = width - selectionRightBd.width;
         this.selection.graphics.beginBitmapFill(selectionRightBd,m);
         this.selection.graphics.drawRect(width - selectionRightBd.width,0,selectionRightBd.width,selectionRightBd.height);
      }
      
      public function correctNonintegralValues() : void
      {
         var n:int = 0;
         var label:Label = null;
         var index:int = 0;
         var nonintegralIndexes:Array = new Array();
         var row:ModInfoRow = this.rows[0] as ModInfoRow;
         var l:int = row.labels.length;
         for(var i:int = 0; i < this.rowCount; i++)
         {
            row = this.rows[i] as ModInfoRow;
            for(n = 0; n < l; n++)
            {
               label = row.labels[n] as Label;
               if(label.text.indexOf(".") != -1)
               {
                  nonintegralIndexes.push(n);
               }
            }
         }
         for(i = 0; i < this.rowCount; i++)
         {
            row = this.rows[i];
            for(n = 0; n < nonintegralIndexes.length; n++)
            {
               index = nonintegralIndexes[n];
               label = row.labels[index] as Label;
               if(label.text.indexOf(".") == -1)
               {
                  label.text += ".0";
               }
            }
         }
      }
      
      public function get maxCostWidth() : int
      {
         return this._maxCostWidth;
      }
      
      public function set maxCostWidth(value:int) : void
      {
         this._maxCostWidth = value;
         var row:ModInfoRow = this.rows[0] as ModInfoRow;
         this.constWidth = row.upgradeIndicator.width + row.rankIcon.width + 3 + row.crystalIcon.width + this._maxCostWidth + row.hSpace * 3;
         for(var i:int = 0; i < this.rowCount; i++)
         {
            row = this.rows[i] as ModInfoRow;
            row.costWidth = this._maxCostWidth;
         }
      }
   }
}
