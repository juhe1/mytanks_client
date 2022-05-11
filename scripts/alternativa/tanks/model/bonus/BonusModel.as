package alternativa.tanks.model.bonus
{
   import alternativa.init.Main;
   import alternativa.model.IModel;
   import alternativa.model.IObjectLoadListener;
   import alternativa.object.ClientObject;
   import alternativa.osgi.service.locale.ILocaleService;
   import alternativa.service.IModelService;
   import alternativa.tanks.gui.ConfugirationsNewbiesWindow;
   import alternativa.tanks.gui.CongratulationsWindow;
   import alternativa.tanks.gui.CongratulationsWindowPresent;
   import alternativa.tanks.gui.CongratulationsWindowWithBanner;
   import alternativa.tanks.locale.constants.TextConst;
   import alternativa.tanks.model.panel.IPanel;
   import alternativa.types.Long;
   import flash.display.DisplayObjectContainer;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import projects.tanks.client.panel.model.bonus.BonusModelBase;
   import projects.tanks.client.panel.model.bonus.IBonusModelBase;
   
   public class BonusModel extends BonusModelBase implements IBonusModelBase, IObjectLoadListener, IBonus
   {
       
      
      private var clientObject:ClientObject;
      
      private var panelModel:IPanel;
      
      private var dialogsLayer:DisplayObjectContainer;
      
      private var bonusWindow:CongratulationsWindowWithBanner;
      
      private var bonusWindowPresent:CongratulationsWindowPresent;
      
      private var bonusWindowNewbies:Sprite;
      
      private var newRules:Sprite;
      
      public function BonusModel()
      {
         super();
         _interfaces.push(IModel,IBonus,IBonusModelBase,IObjectLoadListener);
         this.dialogsLayer = Main.dialogsLayer;
         var modelRegister:IModelService = Main.osgi.getService(IModelService) as IModelService;
         this.panelModel = (modelRegister.getModelsByInterface(IPanel) as Vector.<IModel>)[0] as IPanel;
      }
      
      public function showBonuses(clientObject:ClientObject, items:Array, bannerObjectId:String) : void
      {
         if(items.length > 0)
         {
            this.panelModel.blur();
            this.bonusWindow = new CongratulationsWindowWithBanner(ILocaleService(Main.osgi.getService(ILocaleService)).getText(TextConst.FREE_BONUSES_WINDOW_MESSAGE_TEXT),items,null);
            this.dialogsLayer.addChild(this.bonusWindow);
            this.bonusWindow.closeButton.addEventListener(MouseEvent.CLICK,this.closeWindow);
            this.alignWindow();
            Main.stage.addEventListener(Event.RESIZE,this.alignWindow);
         }
      }
      
      public function showCrystals(clientObject:ClientObject, count:int, banner:Long) : void
      {
         this.panelModel.blur();
         this.bonusWindowPresent = new CongratulationsWindowPresent(CongratulationsWindowPresent.CRYSTALS,null,count);
         this.dialogsLayer.addChild(this.bonusWindowPresent);
         this.bonusWindowPresent.closeButton.addEventListener(MouseEvent.CLICK,this.closeWindowPresent);
         this.alignWindowPresent();
         Main.stage.addEventListener(Event.RESIZE,this.alignWindowPresent);
      }
      
      public function showNoSupplies(clientObject:ClientObject, banner:Long) : void
      {
         this.panelModel.blur();
         this.bonusWindowPresent = new CongratulationsWindowPresent(CongratulationsWindowPresent.NOSUPPLIES,null);
         this.dialogsLayer.addChild(this.bonusWindowPresent);
         this.bonusWindowPresent.closeButton.addEventListener(MouseEvent.CLICK,this.closeWindowPresent);
         this.alignWindowPresent();
         Main.stage.addEventListener(Event.RESIZE,this.alignWindowPresent);
      }
      
      public function showDoubleCrystalls(clientObject:ClientObject, banner:Long) : void
      {
         this.panelModel.blur();
         this.bonusWindowPresent = new CongratulationsWindowPresent(CongratulationsWindowPresent.DOUBLE_CRYSTALLS,null);
         this.dialogsLayer.addChild(this.bonusWindowPresent);
         this.bonusWindowPresent.closeButton.addEventListener(MouseEvent.CLICK,this.closeWindowPresent);
         this.alignWindowPresent();
         Main.stage.addEventListener(Event.RESIZE,this.alignWindowPresent);
      }
      
      public function showNubeUpScore() : void
      {
         this.panelModel.blur();
         var bonus:ConfugirationsNewbiesWindow = new ConfugirationsNewbiesWindow(TextConst.NEWBIES_BONUSES_WINDOW_MESSAGE_TEXT);
         this.bonusWindowNewbies = bonus;
         this.dialogsLayer.addChild(bonus);
         bonus.closeButton.addEventListener(MouseEvent.CLICK,this.closeWindowPresentNewbies);
         this.alignWindowNewbies();
         Main.stage.addEventListener(Event.RESIZE,this.alignWindowNewbies);
      }
      
      public function showNubeNewRank() : void
      {
         this.panelModel.blur();
         var bonus:ConfugirationsNewbiesWindow = new ConfugirationsNewbiesWindow(TextConst.NEWBIES_BONUSES_NEW_RANK_WINDOW_MESSAGE_TEXT);
         this.bonusWindowNewbies = bonus;
         this.dialogsLayer.addChild(bonus);
         bonus.closeButton.addEventListener(MouseEvent.CLICK,this.closeWindowPresentNewbies);
         this.alignWindowNewbies();
         Main.stage.addEventListener(Event.RESIZE,this.alignWindowNewbies);
      }
      
      public function showRulesUpdate() : void
      {
         this.panelModel.blur();
         var bonus:CongratulationsWindow = new CongratulationsWindow("Танкисты!\nБыли обновлены <a href = \"http://mytanksforum.net\"><u>Правила игры</u></a>, нажимая кнопку «Закрыть» вы соглашаетесь с этими правилами.",[],true);
         this.newRules = bonus;
         this.dialogsLayer.addChild(bonus);
         bonus.closeButton.addEventListener(MouseEvent.CLICK,this.closeWindowNewRules);
         this.alignNewRules();
         Main.stage.addEventListener(Event.RESIZE,this.alignNewRules);
      }
      
      public function objectLoaded(object:ClientObject) : void
      {
         this.clientObject = this.clientObject;
      }
      
      public function objectUnloaded(object:ClientObject) : void
      {
         if(this.bonusWindow != null && this.dialogsLayer.contains(this.bonusWindow))
         {
            this.closeWindow();
            this.bonusWindow.closeButton.removeEventListener(MouseEvent.CLICK,this.closeWindow);
            Main.stage.removeEventListener(Event.RESIZE,this.alignWindow);
            this.bonusWindow = null;
         }
         this.clientObject = null;
      }
      
      public function get congratulationsWindow() : CongratulationsWindowWithBanner
      {
         return this.bonusWindow;
      }
      
      private function alignWindowNewbies(e:Event = null) : void
      {
         this.bonusWindowNewbies.x = Math.round((Main.stage.stageWidth - this.bonusWindowNewbies.width) * 0.5);
         this.bonusWindowNewbies.y = Math.round((Main.stage.stageHeight - this.bonusWindowNewbies.height) * 0.5);
      }
      
      private function alignNewRules(e:Event = null) : void
      {
         this.newRules.x = Math.round((Main.stage.stageWidth - this.newRules.width) * 0.5);
         this.newRules.y = Math.round((Main.stage.stageHeight - this.newRules.height) * 0.5);
      }
      
      private function alignWindow(e:Event = null) : void
      {
         this.bonusWindow.x = Math.round((Main.stage.stageWidth - this.bonusWindow.width) * 0.5);
         this.bonusWindow.y = Math.round((Main.stage.stageHeight - this.bonusWindow.height) * 0.5);
      }
      
      private function alignWindowPresent(e:Event = null) : void
      {
         this.bonusWindowPresent.x = Math.round((Main.stage.stageWidth - this.bonusWindowPresent.width) * 0.5);
         this.bonusWindowPresent.y = Math.round((Main.stage.stageHeight - this.bonusWindowPresent.height) * 0.5);
      }
      
      private function closeWindow(e:MouseEvent = null) : void
      {
         this.panelModel.unblur();
         this.dialogsLayer.removeChild(this.bonusWindow);
      }
      
      private function closeWindowPresent(e:MouseEvent = null) : void
      {
         this.panelModel.unblur();
         this.dialogsLayer.removeChild(this.bonusWindowPresent);
      }
      
      private function closeWindowPresentNewbies(e:MouseEvent = null) : void
      {
         this.panelModel.unblur();
         this.dialogsLayer.removeChild(this.bonusWindowNewbies);
      }
      
      private function closeWindowNewRules(e:MouseEvent = null) : void
      {
         this.panelModel.unblur();
         this.dialogsLayer.removeChild(this.newRules);
      }
   }
}
