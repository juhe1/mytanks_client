package alternativa.tanks.model.challenge.greenpanel
{
   import alternativa.tanks.model.challenge.greenpanel.black.BlackPack;
   import alternativa.tanks.model.challenge.greenpanel.gray.GrayPacket;
   import alternativa.tanks.model.challenge.greenpanel.green.GreenPack;
   import flash.display.Bitmap;
   import flash.display.Sprite;
   
   public class GreenPanel extends Sprite
   {
       
      
      private var texturePack:Object;
      
      private var topLeftCorner:Bitmap;
      
      private var topCenterLine:Bitmap;
      
      private var topRightCorner:Bitmap;
      
      private var bottomLeftCorner:Bitmap;
      
      private var bottomCenterLine:Bitmap;
      
      private var bottomRightCorner:Bitmap;
      
      private var leftLine:Bitmap;
      
      private var dailyQuestPanelRightLine:Bitmap;
      
      private var dailyQuestPanelBackground:Bitmap;
      
      private var _width:int;
      
      private var _height:int;
      
      private var state:State;
      
      public function GreenPanel(param1:int, param2:int)
      {
         this.texturePack = GreenPack;
         this.state = State.CURRENT;
         super();
         this._width = param1;
         this._height = param2;
         this.drawTopLine();
         this.drawBottomLine();
         this.drawLeftLine();
         this.drawRightLine();
         this.drawBackground();
         this.updatePanelSize();
      }
      
      private function drawTopLine() : void
      {
         this.topLeftCorner = new Bitmap(this.texturePack._topLeftCorner);
         addChild(this.topLeftCorner);
         this.topCenterLine = new Bitmap(this.texturePack._topCenterLine);
         addChild(this.topCenterLine);
         this.topRightCorner = new Bitmap(this.texturePack._topRightCorner);
         addChild(this.topRightCorner);
      }
      
      private function drawBottomLine() : void
      {
         this.bottomLeftCorner = new Bitmap(this.texturePack._bottomLeftCorner);
         addChild(this.bottomLeftCorner);
         this.bottomCenterLine = new Bitmap(this.texturePack._bottomCenterLine);
         addChild(this.bottomCenterLine);
         this.bottomRightCorner = new Bitmap(this.texturePack._bottomRightCorner);
         addChild(this.bottomRightCorner);
      }
      
      private function drawLeftLine() : void
      {
         this.leftLine = new Bitmap(this.texturePack._leftLine);
         addChild(this.leftLine);
      }
      
      private function drawRightLine() : void
      {
         this.dailyQuestPanelRightLine = new Bitmap(this.texturePack._dailyQuestPanelRightLine);
         addChild(this.dailyQuestPanelRightLine);
      }
      
      private function drawBackground() : void
      {
         this.dailyQuestPanelBackground = new Bitmap(this.texturePack._dailyQuestPanelBackground);
         addChild(this.dailyQuestPanelBackground);
      }
      
      private function updatePanelSize() : void
      {
         if(this.state == State.CURRENT)
         {
            this.texturePack = GreenPack;
         }
         else if(this.state == State.BLOCKED)
         {
            this.texturePack = GrayPacket;
         }
         else
         {
            this.texturePack = BlackPack;
         }
         this.drawTopLine();
         this.drawBottomLine();
         this.drawLeftLine();
         this.drawRightLine();
         this.drawBackground();
         this.topCenterLine.x = this.topLeftCorner.width;
         this.topRightCorner.x = this._width - this.topRightCorner.width;
         this.topCenterLine.width = this.topRightCorner.x - this.topCenterLine.x;
         this.bottomLeftCorner.y = this._height - this.bottomLeftCorner.height;
         this.bottomCenterLine.y = this.bottomLeftCorner.y;
         this.bottomCenterLine.x = this.bottomLeftCorner.width;
         this.bottomCenterLine.width = this.topCenterLine.width;
         this.bottomRightCorner.y = this.bottomLeftCorner.y;
         this.bottomRightCorner.x = this.topRightCorner.x;
         this.leftLine.y = this.topLeftCorner.height;
         this.leftLine.height = this._height - this.topLeftCorner.height - this.bottomLeftCorner.height;
         this.dailyQuestPanelRightLine.y = this.leftLine.y;
         this.dailyQuestPanelRightLine.x = this.bottomRightCorner.x;
         this.dailyQuestPanelRightLine.height = this.leftLine.height;
         this.dailyQuestPanelBackground.y = this.topLeftCorner.height + this.topLeftCorner.y;
         this.dailyQuestPanelBackground.x = this.topLeftCorner.width;
         this.dailyQuestPanelBackground.height = this._height - this.bottomLeftCorner.height - this.topLeftCorner.height;
         this.dailyQuestPanelBackground.width = this._width - this.topLeftCorner.width - this.topRightCorner.width;
      }
      
      public function setState(state:State) : void
      {
         if(this.state == state)
         {
            return;
         }
         this.state = state;
         this.updatePanelSize();
      }
      
      override public function get width() : Number
      {
         return this._width;
      }
      
      override public function set width(param1:Number) : void
      {
         this._width = param1;
         this.updatePanelSize();
      }
      
      override public function get height() : Number
      {
         return this._height;
      }
      
      override public function set height(param1:Number) : void
      {
         this._height = param1;
         this.updatePanelSize();
      }
   }
}
