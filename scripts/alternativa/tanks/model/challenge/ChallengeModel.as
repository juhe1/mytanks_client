package alternativa.tanks.model.challenge
{
   import alternativa.init.Main;
   import alternativa.tanks.model.challenge.server.ChallengeServerData;
   import alternativa.tanks.model.panel.IPanel;
   import flash.display.DisplayObjectContainer;
   import flash.events.Event;
   import flash.events.MouseEvent;
   
   public class ChallengeModel implements IChallenge
   {
       
      
      private var panelModel:IPanel;
      
      private var dialogsLayer:DisplayObjectContainer;
      
      private var window:ChallengeWindow;
      
      public function ChallengeModel()
      {
         super();
         this.dialogsLayer = Main.dialogsLayer;
      }
      
      public function show(quest:ChallengeServerData) : void
      {
         this.panelModel = Main.osgi.getService(IPanel) as IPanel;
         this.panelModel.blur();
         this.window = new ChallengeWindow(quest.specialChallenge != null);
         this.dialogsLayer.addChild(this.window);
         Main.stage.addEventListener(Event.RESIZE,this.alignWindow);
         this.window.closeBtn.addEventListener(MouseEvent.CLICK,this.closeWindow);
         this.alignWindow(null);
         this.window.show(quest);
      }
      
      public function updateQuest(quest:ChallengeServerData) : void
      {
         if(this.window == null)
         {
            return;
         }
         this.window.show(quest);
      }
      
      private function alignWindow(e:Event) : void
      {
         this.window.x = Math.round((Main.stage.stageWidth - this.window.width) * 0.5);
         this.window.y = Math.round((Main.stage.stageHeight - this.window.height) * 0.5);
      }
      
      private function closeWindow(e:MouseEvent = null) : void
      {
         this.panelModel.unblur();
         this.dialogsLayer.removeChild(this.window);
         Main.stage.removeEventListener(Event.RESIZE,this.alignWindow);
         this.window = null;
      }
   }
}
