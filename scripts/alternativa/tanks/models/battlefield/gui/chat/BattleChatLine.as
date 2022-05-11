package alternativa.tanks.models.battlefield.gui.chat
{
   import alternativa.tanks.models.battlefield.common.MessageLine;
   import controls.Label;
   import controls.chat.ChatPermissionsLevel;
   import controls.rangicons.RangIconSmall;
   import flash.display.Bitmap;
   import flash.events.MouseEvent;
   import flash.system.System;
   
   public class BattleChatLine extends MessageLine
   {
       
      
      private var msgLabel:Label;
      
      private var output:Label;
      
      private var _nameFrom:Label;
      
      private var _rank:int;
      
      private var senderName:String;
      
      private var rankIcon:RangIconSmall;
      
      public var chatLevel:Bitmap;
      
      private var _namesWidth:int = 0;
      
      private var _width:int;
      
      public function BattleChatLine(lineWidth:int, messageLabel:String, rank:int, chatPermissions:int, name:String, text:String, textColor:uint = 16777215)
      {
         this.output = new Label();
         this._nameFrom = new Label();
         super();
         this.rankIcon = new RangIconSmall(rank);
         this.rankIcon.mouseEnabled = false;
         this.rankIcon.y = 3;
         this._rank = rank;
         this._width = lineWidth;
         this.output.color = 16777215;
         this.output.multiline = true;
         this.output.wordWrap = true;
         this.output.mouseEnabled = false;
         this.senderName = name;
         this._nameFrom.color = textColor;
         this._nameFrom.text = name + ": ";
         this._nameFrom.thickness = 50;
         this._nameFrom.sharpness = 0;
         var fx:int = 0;
         if(rank > -1)
         {
            addChild(this.rankIcon);
         }
         if(chatPermissions > 0 && this.chatLevel == null)
         {
            this.chatLevel = new Bitmap(ChatPermissionsLevel.getBD(chatPermissions));
            this.chatLevel.y = 3;
            addChild(this.chatLevel);
            this.rankIcon.x = this.chatLevel.x + this.chatLevel.width;
            fx += this.chatLevel.width;
         }
         if(messageLabel != null)
         {
            this.msgLabel = new Label();
            this.msgLabel.thickness = 0;
            this.msgLabel.text = messageLabel;
            addChild(this.msgLabel);
            fx = this.msgLabel.textWidth + 2;
            if(chatPermissions > 0 && this.chatLevel != null)
            {
               this.msgLabel.x += this.chatLevel != null ? this.chatLevel.width : 0;
            }
            fx += this.chatLevel != null ? this.chatLevel.width : 0;
         }
         this.rankIcon.x = fx;
         fx += this.rankIcon.width - 3;
         addChild(this._nameFrom);
         this._nameFrom.x = fx;
         fx += this._nameFrom.textWidth;
         addChild(this.output);
         this._namesWidth = fx;
         if(this._namesWidth > this._width / 2)
         {
            this.output.y = 15;
            this.output.x = 0;
            this.output.width = this._width - 5;
         }
         else
         {
            this.output.x = this._namesWidth + 3;
            this.output.y = 0;
            this.output.width = this._width - this._namesWidth - 8;
         }
         this.output.text = text;
         addEventListener(MouseEvent.CLICK,this.onMouseClick);
      }
      
      private function onMouseClick(event:MouseEvent) : void
      {
         if(this.senderName != null)
         {
            System.setClipboard(this.senderName);
         }
      }
      
      override public function set width(value:Number) : void
      {
         this._width = int(value);
         if(this._namesWidth > this._width / 2 && this.output.text.length * 8 > this._width - this._namesWidth)
         {
            this.output.y = 21;
            this.output.x = 0;
            this.output.width = this._width - 5;
            this.output.height = 20;
         }
         else
         {
            this.output.x = this._namesWidth;
            this.output.y = 0;
            this.output.width = this._width - this._namesWidth - 5;
            this.output.height = 20;
         }
      }
   }
}
