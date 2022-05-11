package alternativa.tanks.models.battlefield.gui.statistics.table.renderuser
{
   import controls.Label;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.system.System;
   import flash.text.TextFieldAutoSize;
   import flash.text.TextFormatAlign;
   
   public class StatisticsListUserLabel extends Sprite
   {
       
      
      private var label:Label;
      
      public function StatisticsListUserLabel(nickname:String, color:uint)
      {
         this.label = new Label();
         super();
         this.label.text = nickname;
         this.label.autoSize = TextFieldAutoSize.NONE;
         this.label.color = color;
         this.label.align = TextFormatAlign.LEFT;
         this.label.width = 135;
         this.label.height = 20;
         addChild(this.label);
         addEventListener(MouseEvent.CLICK,this.onMouseClick);
      }
      
      private function onMouseClick(event:MouseEvent) : void
      {
         System.setClipboard(event.currentTarget.label.text);
      }
   }
}
