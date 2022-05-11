package alternativa.tanks.model.antiaddiction
{
   import alternativa.init.Main;
   import alternativa.model.IModel;
   import alternativa.model.IObjectLoadListener;
   import alternativa.object.ClientObject;
   import alternativa.osgi.service.mainContainer.IMainContainerService;
   import alternativa.service.IModelService;
   import alternativa.tanks.gui.AntiAddictionWindow;
   import alternativa.tanks.model.panel.IPanel;
   import flash.display.DisplayObjectContainer;
   import flash.events.Event;
   import forms.Alert;
   import forms.AlertAnswer;
   import projects.tanks.client.panel.model.antiaddictionalert.AntiAddictionAlertModelBase;
   import projects.tanks.client.panel.model.antiaddictionalert.IAntiAddictionAlertModelBase;
   
   public class AntiAddictionAlertModel extends AntiAddictionAlertModelBase implements IAntiAddictionAlert, IAntiAddictionAlertModelBase, IObjectLoadListener
   {
       
      
      private var dialogsLayer:DisplayObjectContainer;
      
      private var antiAddictionWindow:AntiAddictionWindow;
      
      private var clientObject:ClientObject;
      
      public function AntiAddictionAlertModel()
      {
         super();
         _interfaces.push(IModel);
         _interfaces.push(IAntiAddictionAlertModelBase);
         _interfaces.push(IAntiAddictionAlert);
         _interfaces.push(IObjectLoadListener);
         this.dialogsLayer = (Main.osgi.getService(IMainContainerService) as IMainContainerService).dialogsLayer as DisplayObjectContainer;
      }
      
      public function showAntiAddictionAlert(clientObject:ClientObject, minutesPlayedToday:int) : void
      {
         Main.writeVarsToConsoleChannel("AA MODEL","show aaAlert clientObject = %1",clientObject);
         this.showAntiAddictionWindow(minutesPlayedToday);
      }
      
      public function setIdNumberCheckResult(clientObject:ClientObject, result:Boolean) : void
      {
         var modelRegister:IModelService = Main.osgi.getService(IModelService) as IModelService;
         var panelModel:IPanel = modelRegister.getModelsByInterface(IPanel)[0] as IPanel;
         if(this.antiAddictionWindow != null && this.dialogsLayer.contains(this.antiAddictionWindow))
         {
            if(!result)
            {
               panelModel._showMessage("该身份证错误,请重新输入");
               this.antiAddictionWindow.enableButtons();
            }
            else
            {
               panelModel._showMessage("您的身份证信息已通过验证");
               panelModel.unblur();
               this.dialogsLayer.removeChild(this.antiAddictionWindow);
            }
         }
         else
         {
            panelModel.setIdNumberCheckResult(result);
         }
      }
      
      public function setIdNumberAndRealName(realName:String, idNumber:String) : void
      {
      }
      
      private function showAntiAddictionWindow(minutesPlayedToday:int) : void
      {
         var message:String = null;
         var alert:Alert = null;
         var modelRegister:IModelService = Main.osgi.getService(IModelService) as IModelService;
         var panelModel:IPanel = modelRegister.getModelsByInterface(IPanel)[0] as IPanel;
         if(minutesPlayedToday >= 210)
         {
            panelModel.blur();
            if(this.antiAddictionWindow != null && this.dialogsLayer.contains(this.antiAddictionWindow))
            {
               this.dialogsLayer.removeChild(this.antiAddictionWindow);
            }
            this.antiAddictionWindow = new AntiAddictionWindow(minutesPlayedToday);
            this.antiAddictionWindow.addEventListener(Event.COMPLETE,this.onIDCardEntered);
            this.antiAddictionWindow.addEventListener(Event.CANCEL,this.onIDCardCanceled);
            this.dialogsLayer.addChild(this.antiAddictionWindow);
            Main.stage.addEventListener(Event.RESIZE,this.alignAntiAddictionWindow);
            this.alignAntiAddictionWindow();
         }
         else
         {
            message = "";
            if(minutesPlayedToday >= 180)
            {
               message = "您累计在线时间已满3小时，请您下线休息，做适当身体活动。";
            }
            else if(minutesPlayedToday >= 120)
            {
               message = "您累计在线时间已满2小时。";
            }
            else if(minutesPlayedToday >= 60)
            {
               message = "您累计在线时间已满1小时。";
            }
            alert = new Alert();
            alert.showAlert(message,[AlertAnswer.OK]);
            this.dialogsLayer.addChild(alert);
         }
      }
      
      private function onIDCardEntered(e:Event) : void
      {
         this.setIdNumberAndRealName(this.antiAddictionWindow.realNameInput.value,this.antiAddictionWindow.idCardInput.value);
         this.antiAddictionWindow.disableButtons();
      }
      
      private function onIDCardCanceled(e:Event) : void
      {
         var modelRegister:IModelService = Main.osgi.getService(IModelService) as IModelService;
         var panelModel:IPanel = modelRegister.getModelsByInterface(IPanel)[0] as IPanel;
         panelModel.unblur();
         this.dialogsLayer.removeChild(this.antiAddictionWindow);
      }
      
      private function alignAntiAddictionWindow(e:Event = null) : void
      {
         this.antiAddictionWindow.x = Math.round((Main.stage.stageWidth - this.antiAddictionWindow.windowSize.x) * 0.5);
         this.antiAddictionWindow.y = Math.round((Main.stage.stageHeight - this.antiAddictionWindow.windowSize.y) * 0.5);
      }
      
      public function objectLoaded(object:ClientObject) : void
      {
         Main.writeVarsToConsoleChannel("AA MODEL","Loaded clientObject = %1",object);
         this.clientObject = object;
      }
      
      public function objectUnloaded(object:ClientObject) : void
      {
         if(this.antiAddictionWindow != null && this.dialogsLayer.contains(this.antiAddictionWindow))
         {
            this.dialogsLayer.removeChild(this.antiAddictionWindow);
         }
      }
   }
}
