package scpacker.gui
{
   import alternativa.init.Main;
   import controls.Label;
   import controls.statassets.BlackRoundRect;
   import flash.display.Sprite;
   import flash.events.Event;
   
   public class ServerMessage extends Sprite
   {
       
      
      private var bg:BlackRoundRect;
      
      private var label:Label;
      
      public function ServerMessage(str:String)
      {
         this.bg = new BlackRoundRect();
         this.label = new Label();
         super();
         addChild(this.bg);
         addChild(this.label);
         this.label.text = str;
         this.label.size = 14;
         this.label.x = 10;
         this.bg.width = this.label.width + 20;
         this.bg.height = this.label.height + 30;
         this.label.y = this.bg.height / 2 - this.label.height / 2 - 2;
         Main.stage.addEventListener(Event.RESIZE,this.resize);
         this.resize(null);
      }
      
      private function resize(e:Event) : void
      {
         this.x = Main.stage.stageWidth / 2 - this.width / 2;
         this.y = Main.stage.stageHeight / 2 - this.height / 2;
      }
   }
}
