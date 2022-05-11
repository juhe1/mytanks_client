package alternativa.tanks.model.achievement
{
   import alternativa.init.Main;
   import alternativa.osgi.service.locale.ILocaleService;
   import alternativa.tanks.gui.AchievementCongratulationsWindow;
   import alternativa.tanks.help.HelpService;
   import alternativa.tanks.help.IHelpService;
   import alternativa.tanks.help.achievements.FirstPurchaseHelper;
   import alternativa.tanks.help.achievements.SetEmailHelper;
   import alternativa.tanks.help.achievements.UpRankHelper;
   import alternativa.tanks.locale.constants.TextConst;
   import alternativa.tanks.model.panel.IPanel;
   import flash.display.DisplayObjectContainer;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import forms.events.MainButtonBarEvents;
   
   public class AchievementModel
   {
       
      
      private const HELPER_GROUP_KEY:String = "GarageModel";
      
      private var firstPurchaseHelper:FirstPurchaseHelper;
      
      private var setEmailHelper:SetEmailHelper;
      
      private var upRankHelper:UpRankHelper;
      
      private var currentAchievements:Vector.<Achievement>;
      
      private var helpService:HelpService;
      
      private var window:AchievementCongratulationsWindow;
      
      private var dialogsLayer:DisplayObjectContainer;
      
      private var panelModel:IPanel;
      
      private var state:State;
      
      public function AchievementModel()
      {
         super();
         this.firstPurchaseHelper = new FirstPurchaseHelper();
         this.setEmailHelper = new SetEmailHelper();
         this.upRankHelper = new UpRankHelper();
         this.helpService = Main.osgi.getService(IHelpService) as HelpService;
         this.helpService.registerHelper(this.HELPER_GROUP_KEY,800,this.firstPurchaseHelper,false);
         this.helpService.registerHelper(this.HELPER_GROUP_KEY,801,this.setEmailHelper,false);
         this.helpService.registerHelper(this.HELPER_GROUP_KEY,802,this.upRankHelper,false);
         this.currentAchievements = new Vector.<Achievement>();
         this.dialogsLayer = Main.dialogsLayer;
      }
      
      public function objectLoaded(activeAchievements:Vector.<Achievement>) : void
      {
         this.panelModel = Main.osgi.getService(IPanel) as IPanel;
         this.setAchievements(activeAchievements);
      }
      
      private function setAchievements(activeAchievements:Vector.<Achievement>) : void
      {
         var achivement:Achievement = null;
         for each(achivement in activeAchievements)
         {
            this.currentAchievements.push(achivement);
         }
         if(this.currentAchievements.length != 0)
         {
            this.showCurrentAchievementBubbles();
            this.alignHelpers();
            Main.stage.addEventListener(Event.RESIZE,this.alignHelpers);
         }
      }
      
      public function completeAchievement(achievement:Achievement) : void
      {
         this.removeAchievement(achievement);
         this.hideAllBubbles();
         this.panelModel.blur();
         var localeService:ILocaleService = ILocaleService(Main.osgi.getService(ILocaleService));
         var text:String = localeService.getText(achievement == Achievement.FIRST_PURCHASE ? TextConst.ACHIEVEMENT_COMPLETE_FIRST_PURCHASE_TEXT : TextConst.ACHIEVEMENT_COMPLETE_EMAIL_TEXT);
         this.window = new AchievementCongratulationsWindow();
         this.window.init(text);
         this.dialogsLayer.addChild(this.window);
         this.window.closeBtn.addEventListener(MouseEvent.CLICK,this.closeWindow);
         this.alignHelpers();
      }
      
      public function showNewRankCongratulationsWindow() : void
      {
         this.hideAllBubbles();
         this.panelModel.blur();
         var localeService:ILocaleService = ILocaleService(Main.osgi.getService(ILocaleService));
         var text:String = localeService.getText(TextConst.NEWBIES_BONUSES_NEW_RANK_WINDOW_MESSAGE_TEXT);
         this.window = new AchievementCongratulationsWindow();
         this.window.init(text);
         this.dialogsLayer.addChild(this.window);
         this.window.closeBtn.addEventListener(MouseEvent.CLICK,this.closeWindow);
         this.alignHelpers();
      }
      
      private function closeWindow(e:Event = null) : void
      {
         this.window.closeBtn.removeEventListener(MouseEvent.CLICK,this.closeWindow);
         this.dialogsLayer.removeChild(this.window);
         this.panelModel.unblur();
         this.showCurrentAchievementBubbles();
      }
      
      private function hideAllBubbles() : void
      {
         for(var i:int = 800; i < 803; i++)
         {
            this.helpService.hideHelper(this.HELPER_GROUP_KEY,i);
         }
         this.helpService.hideHelp();
      }
      
      private function removeAchievement(achievement:Achievement) : void
      {
         if(this.currentAchievements.indexOf(achievement) != -1)
         {
            this.currentAchievements.splice(this.currentAchievements.indexOf(achievement),1);
         }
      }
      
      private function newbies() : Boolean
      {
         if(this.panelModel == null)
         {
            return false;
         }
         return this.panelModel.rank == 1;
      }
      
      private function showCurrentAchievementBubbles() : void
      {
         var achievement:Achievement = null;
         for(var i:int = 800; i < 803; i++)
         {
            this.helpService.hideHelper(this.HELPER_GROUP_KEY,i);
         }
         for each(achievement in this.currentAchievements)
         {
            if(achievement == Achievement.FIRST_PURCHASE)
            {
               if(this.state != State.GARAGE && this.state != State.BATTLE)
               {
                  this.helpService.showHelper(this.HELPER_GROUP_KEY,800);
               }
            }
            else if(this.state != State.BATTLE)
            {
               this.helpService.showHelper(this.HELPER_GROUP_KEY,801);
            }
         }
         if(this.newbies() && this.state == State.BATTLE)
         {
            this.helpService.showHelper(this.HELPER_GROUP_KEY,802);
         }
      }
      
      public function changeSwitchPanelStateStart(typePanel:String) : void
      {
         switch(typePanel)
         {
            case MainButtonBarEvents.SETTINGS:
               if(this.containsAchievement(Achievement.SET_EMAIL))
               {
                  this.helpService.hideHelper(this.HELPER_GROUP_KEY,801);
               }
               this.helpService.hideHelper(this.HELPER_GROUP_KEY,802);
               break;
            case MainButtonBarEvents.GARAGE:
               if(this.containsAchievement(Achievement.FIRST_PURCHASE))
               {
                  this.helpService.hideHelper(this.HELPER_GROUP_KEY,800);
               }
               if(this.containsAchievement(Achievement.SET_EMAIL))
               {
                  this.helpService.hideHelper(this.HELPER_GROUP_KEY,801);
               }
               this.helpService.hideHelper(this.HELPER_GROUP_KEY,802);
               break;
            case MainButtonBarEvents.BATTLE:
               if(this.containsAchievement(Achievement.FIRST_PURCHASE))
               {
                  this.helpService.hideHelper(this.HELPER_GROUP_KEY,800);
               }
               if(this.containsAchievement(Achievement.SET_EMAIL))
               {
                  this.helpService.hideHelper(this.HELPER_GROUP_KEY,801);
               }
               this.helpService.hideHelper(this.HELPER_GROUP_KEY,802);
               break;
            case MainButtonBarEvents.HELP:
               if(this.state != State.BATTLE)
               {
                  this.hideAllBubbles();
               }
               this.helpService.hideHelper(this.HELPER_GROUP_KEY,802);
         }
      }
      
      public function changeSwitchPanelStateEnd(typePanel:String) : void
      {
         switch(typePanel)
         {
            case MainButtonBarEvents.GARAGE:
               if(this.containsAchievement(Achievement.SET_EMAIL) && !this.containsAchievement(Achievement.FIRST_PURCHASE))
               {
                  this.helpService.showHelper(this.HELPER_GROUP_KEY,801);
               }
               this.state = State.GARAGE;
               break;
            case MainButtonBarEvents.BATTLE:
               if(this.containsAchievement(Achievement.SET_EMAIL) && !this.containsAchievement(Achievement.FIRST_PURCHASE))
               {
                  this.helpService.showHelper(this.HELPER_GROUP_KEY,801);
               }
               if(this.containsAchievement(Achievement.FIRST_PURCHASE))
               {
                  this.helpService.showHelper(this.HELPER_GROUP_KEY,800);
               }
               this.state = State.BATTLES_LIST;
               break;
            case MainButtonBarEvents.HELP:
               if(this.state != State.BATTLE)
               {
                  this.showCurrentAchievementBubbles();
               }
         }
      }
      
      public function onEnterInBattle() : void
      {
         if(this.containsAchievement(Achievement.FIRST_PURCHASE))
         {
            this.helpService.hideHelper(this.HELPER_GROUP_KEY,800);
         }
         if(this.containsAchievement(Achievement.SET_EMAIL))
         {
            this.helpService.hideHelper(this.HELPER_GROUP_KEY,801);
         }
         this.state = State.BATTLE;
      }
      
      public function onLoadedInBattle() : void
      {
         if(this.newbies())
         {
            this.helpService.showHelper(this.HELPER_GROUP_KEY,802);
         }
      }
      
      private function containsAchievement(achievement:Achievement) : Boolean
      {
         var id:int = this.currentAchievements.indexOf(achievement);
         return id >= 0;
      }
      
      private function alignHelpers(event:Event = null) : void
      {
         var width:int = Math.max(1000,Main.stage.stageWidth);
         var heigth:int = Math.max(580,Main.stage.stageHeight);
         this.firstPurchaseHelper.targetPoint = new Point(width - 330,30);
         this.setEmailHelper.targetPoint = new Point(width - 115,30);
         this.upRankHelper.targetPoint = new Point(270,30);
         if(this.window != null)
         {
            this.window.x = Main.stage.stageWidth - this.window.width >> 1;
            this.window.y = Main.stage.stageHeight - this.window.height >> 1;
         }
      }
   }
}
