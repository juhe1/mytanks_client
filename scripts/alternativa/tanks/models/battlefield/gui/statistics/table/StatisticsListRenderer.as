package alternativa.tanks.models.battlefield.gui.statistics.table
{
   import alternativa.tanks.models.battlefield.gui.statistics.table.renderuser.StatisticsListUserLabel;
   import controls.Label;
   import controls.rangicons.RangIconSmall;
   import controls.resultassets.ResultWindowBlueNormal;
   import controls.resultassets.ResultWindowBlueSelected;
   import controls.resultassets.ResultWindowGreenNormal;
   import controls.resultassets.ResultWindowGreenSelected;
   import controls.resultassets.ResultWindowRedNormal;
   import controls.resultassets.ResultWindowRedSelected;
   import fl.controls.listClasses.CellRenderer;
   import fl.controls.listClasses.ListData;
   import flash.display.DisplayObject;
   import flash.display.DisplayObjectContainer;
   import flash.display.Sprite;
   import flash.text.TextFieldAutoSize;
   import flash.text.TextFormatAlign;
   
   public class StatisticsListRenderer extends CellRenderer
   {
      
      private static const RANK_ICON_X:int = 2;
      
      private static const RANK_ICON_Y:int = 3;
       
      
      private var nicon:DisplayObject;
      
      public function StatisticsListRenderer()
      {
         super();
         this.mouseChildren = true;
         this.useHandCursor = false;
         this.buttonMode = false;
      }
      
      override public function set data(value:Object) : void
      {
         _data = value;
         this.nicon = this.myIcon(_data);
      }
      
      override public function set listData(value:ListData) : void
      {
         _listData = value;
         label = _listData.label;
         if(this.nicon != null)
         {
            setStyle("icon",this.nicon);
         }
      }
      
      override protected function drawBackground() : void
      {
      }
      
      override protected function drawLayout() : void
      {
      }
      
      override protected function drawIcon() : void
      {
         var oldIcon:DisplayObject = icon;
         var iconStyle:Object = getStyleValue("icon");
         if(iconStyle != null)
         {
            icon = getDisplayObjectInstance(iconStyle);
         }
         if(icon != null)
         {
            addChildAt(icon,1);
         }
         if(oldIcon != null && oldIcon != icon && oldIcon.parent == this)
         {
            removeChild(oldIcon);
         }
      }
      
      private function myIcon(data:Object) : Sprite
      {
         var bg:DisplayObject = null;
         var label:Label = null;
         var rankIcon:RangIconSmall = null;
         var dataItem:StatisticsData = StatisticsData(data);
         switch(dataItem.type)
         {
            case ViewStatistics.BLUE:
               bg = !!dataItem.self ? new ResultWindowBlueSelected() : new ResultWindowBlueNormal();
               break;
            case ViewStatistics.GREEN:
               bg = !!dataItem.self ? new ResultWindowGreenSelected() : new ResultWindowGreenNormal();
               break;
            case ViewStatistics.RED:
               bg = !!dataItem.self ? new ResultWindowRedSelected() : new ResultWindowRedNormal();
         }
         var container:Sprite = new Sprite();
         container.addChild(bg);
         if(dataItem.playerRank > 0)
         {
            rankIcon = new RangIconSmall(dataItem.playerRank);
            rankIcon.x = RANK_ICON_X;
            rankIcon.y = RANK_ICON_Y;
            container.addChild(rankIcon);
         }
         var x:int = TableConst.LABELS_OFFSET;
         var nickname:StatisticsListUserLabel = new StatisticsListUserLabel(dataItem.playerName == "" ? "None" : dataItem.playerName,16777215);
         nickname.x = x;
         container.addChild(nickname);
         x += nickname.width;
         if(dataItem.score > -1)
         {
            label = this.createCell(container,dataItem.score.toString(),16777215,TextFormatAlign.RIGHT,TableConst.SCORE_WIDTH,x);
            x += label.width;
         }
         label = this.createCell(container,dataItem.kills.toString(),16777215,TextFormatAlign.RIGHT,TableConst.KILLS_WIDTH,x);
         x += label.width;
         label = this.createCell(container,dataItem.deaths.toString(),16777215,TextFormatAlign.RIGHT,TableConst.DEATHS_WIDTH,x);
         x += label.width;
         var coeff:Number = dataItem.kills / dataItem.deaths;
         var s:String = dataItem.deaths == 0 || dataItem.kills == 0 ? "—" : coeff.toFixed(2);
         label = this.createCell(container,s,16777215,TextFormatAlign.RIGHT,TableConst.RATIO_WIDTH,x);
         x += label.width;
         if(dataItem.reward > -1)
         {
            label = this.createCell(container,dataItem.reward.toString(),16777215,TextFormatAlign.RIGHT,TableConst.REWARD_WIDTH,x);
         }
         bg.width = width;
         bg.height = TableConst.ROW_HEIGHT - 2;
         return container;
      }
      
      private function createCell(container:DisplayObjectContainer, text:String, color:uint, align:String, width:int, x:int) : Label
      {
         var label:Label = new Label();
         label.autoSize = TextFieldAutoSize.NONE;
         label.text = text;
         label.color = color;
         label.align = align;
         label.x = x;
         label.width = width;
         label.height = TableConst.ROW_HEIGHT;
         container.addChild(label);
         return label;
      }
   }
}
