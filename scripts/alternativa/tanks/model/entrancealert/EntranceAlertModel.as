package alternativa.tanks.model.entrancealert
{
   import alternativa.init.Main;
   import alternativa.model.IModel;
   import alternativa.object.ClientObject;
   import alternativa.service.IModelService;
   import alternativa.tanks.gui.EntranceAlertWindow;
   import alternativa.tanks.model.panel.IPanel;
   import flash.display.DisplayObjectContainer;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import projects.tanks.client.panel.model.entrancealert.EntranceAlertModelBase;
   import projects.tanks.client.panel.model.entrancealert.IEntranceAlertModelBase;
   
   public class EntranceAlertModel extends EntranceAlertModelBase implements IEntranceAlertModelBase
   {
       
      
      private var panelModel:IPanel;
      
      private var dialogsLayer:DisplayObjectContainer;
      
      private var window:EntranceAlertWindow;
      
      public function EntranceAlertModel()
      {
         super();
         this.dialogsLayer = Main.dialogsLayer;
         var modelRegister:IModelService = Main.osgi.getService(IModelService) as IModelService;
         this.panelModel = (modelRegister.getModelsByInterface(IPanel) as Vector.<IModel>)[0] as IPanel;
      }
      
      public function showAlert(clientObject:ClientObject) : void
      {
         this.panelModel.blur();
         this.window = new EntranceAlertWindow();
         this.dialogsLayer.addChild(this.window);
         this.window.closeButton.addEventListener(MouseEvent.CLICK,this.closeWindow);
         this.alignWindow(null);
         Main.stage.addEventListener(Event.RESIZE,this.alignWindow);
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
      }
   }
}
