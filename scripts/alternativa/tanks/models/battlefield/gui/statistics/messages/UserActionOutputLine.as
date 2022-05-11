package alternativa.tanks.models.battlefield.gui.statistics.messages
{
   import alternativa.tanks.models.battlefield.common.MessageContainer;
   import alternativa.tanks.models.battlefield.common.MessageLine;
   import controls.Label;
   import controls.rangicons.RangIconSmall;
   import flash.events.MouseEvent;
   import flash.system.System;
   import projects.tanks.client.battlefield.gui.models.statistics.UserStat;
   
   public class UserActionOutputLine extends MessageLine
   {
       
      
      private var userName:String;
      
      public function UserActionOutputLine(userStat:UserStat, actionText:String, affectedUserSrat:UserStat = null)
      {
         var nickLabelSharpness:int = 0;
         var label:Label = null;
         var rankIcon:RangIconSmall = null;
         super();
         nickLabelSharpness = 0;
         if(userStat != null)
         {
            this.userName = userStat.name;
            rankIcon = new RangIconSmall(userStat.rank);
            rankIcon.x = width + 4;
            rankIcon.y = 3;
            addChild(rankIcon);
            label = this.createLabel(userStat.name);
            label.thickness = 50;
            label.sharpness = nickLabelSharpness;
            label.x = rankIcon.x + rankIcon.width - 3;
            label.color = MessageContainer.getTeamFontColor(userStat.teamType);
            addChild(label);
            addEventListener(MouseEvent.CLICK,this.onMouseClick);
         }
         label = this.createLabel(actionText);
         label.x = width + 4;
         addChild(label);
         if(affectedUserSrat != null)
         {
            rankIcon = new RangIconSmall(affectedUserSrat.rank);
            rankIcon.x = width + 4;
            rankIcon.y = 3;
            addChild(rankIcon);
            label = this.createLabel(affectedUserSrat.name);
            label.x = rankIcon.x + rankIcon.width - 3;
            label.color = MessageContainer.getTeamFontColor(affectedUserSrat.teamType);
            label.thickness = 50;
            label.sharpness = nickLabelSharpness;
            addChild(label);
         }
      }
      
      private function onMouseClick(event:MouseEvent) : void
      {
         System.setClipboard(this.userName);
      }
      
      private function createLabel(text:String) : Label
      {
         var label:Label = new Label();
         label.mouseEnabled = false;
         label.text = text;
         return label;
      }
   }
}
