package alternativa.tanks.model.challenge
{
   import alternativa.init.Main;
   import alternativa.osgi.service.locale.ILocaleService;
   import alternativa.tanks.locale.constants.TextConst;
   import alternativa.tanks.model.challenge.greenpanel.GreenPanel;
   import alternativa.tanks.model.challenge.server.ChallengeServerData;
   import controls.DefaultButton;
   import controls.Label;
   import controls.TankWindowInner;
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.events.TimerEvent;
   import flash.utils.Timer;
   import forms.TankWindowWithHeader;
   import forms.garage.GarageButton;
   import scpacker.networking.INetworker;
   import scpacker.networking.Network;
   
   public class ChallengeWindow extends Sprite
   {
      
      private static const noQuestBitmap:Class = ChallengeWindow_noQuestBitmap;
       
      
      private var bitmap:Bitmap;
      
      private var window:TankWindowWithHeader;
      
      private var innerWindow:TankWindowInner;
      
      private var panel:GreenPanel;
      
      private var specialPanel:SpecialChallengePanel;
      
      private var task:Label;
      
      private var taskValue:Label;
      
      private var progressLabel:Label;
      
      private var prize:Label;
      
      private var prizeValue:Label;
      
      private var completed:Label;
      
      public var changeBtn:GarageButton;
      
      public var closeBtn:DefaultButton;
      
      private var special:Boolean;
      
      private var offset:int;
      
      public function ChallengeWindow(specialChallenge:Boolean = false)
      {
         this.bitmap = new Bitmap(new noQuestBitmap().bitmapData);
         this.window = TankWindowWithHeader.createWindow(ILocaleService(Main.osgi.getService(ILocaleService)).getText(TextConst.MAIN_PANEL_BUTTON_CHALLENGE));
         this.innerWindow = new TankWindowInner(0,0,TankWindowInner.GREEN);
         this.panel = new GreenPanel(250,90);
         this.task = new Label();
         this.taskValue = new Label();
         this.progressLabel = new Label();
         this.prize = new Label();
         this.prizeValue = new Label();
         this.completed = new Label();
         this.changeBtn = new GarageButton();
         this.closeBtn = new DefaultButton();
         super();
         this.special = specialChallenge;
         if(this.special)
         {
            this.offset = 280;
         }
         this.createWindow();
         this.addPanel();
      }
      
      private function createWindow() : void
      {
         this.window.width = 300 + this.offset;
         this.window.height = 350;
         addChild(this.window);
         this.innerWindow.width = this.window.width - 30 - this.offset;
         this.innerWindow.height = this.window.height - 125;
         this.innerWindow.x = 15;
         this.innerWindow.y = 15;
         addChild(this.innerWindow);
         if(this.special)
         {
            this.specialPanel = new SpecialChallengePanel(this.innerWindow.width,this.innerWindow.height);
            this.specialPanel.x = this.innerWindow.x + this.innerWindow.width + 10;
            this.specialPanel.y = this.innerWindow.y;
            addChild(this.specialPanel);
         }
         this.changeBtn.x = this.window.width / 2 - this.changeBtn.width / 2 - this.offset / 2;
         this.changeBtn.y = this.window.height - this.changeBtn.height - 50;
         this.changeBtn.label = ILocaleService(Main.osgi.getService(ILocaleService)).getText(TextConst.CHALLENGES_WINDOW_BUTTON_CHANGE_TEXT);
         this.changeBtn.addEventListener(MouseEvent.CLICK,this.onChangeQuest);
         addChild(this.changeBtn);
         this.closeBtn.x = this.window.width - this.closeBtn.width - 10;
         this.closeBtn.y = this.window.height - this.closeBtn.height - 10;
         this.closeBtn.label = ILocaleService(Main.osgi.getService(ILocaleService)).getText(TextConst.FREE_BONUSES_WINDOW_BUTTON_CLOSE_TEXT);
         addChild(this.closeBtn);
      }
      
      private function addPanel() : void
      {
         this.bitmap.x = this.innerWindow.width / 2 - this.bitmap.width / 2;
         this.bitmap.y = 5;
         this.innerWindow.addChild(this.bitmap);
         this.panel.x = 10;
         this.panel.y = 125;
         this.innerWindow.addChild(this.panel);
         this.completed.color = 5898034;
         this.completed.text = ILocaleService(Main.osgi.getService(ILocaleService)).getText(TextConst.CHALLENGES_WINDOW_LABEL_COMPLETE_TEXT);
         this.completed.x = 10;
         this.completed.y = this.window.height - this.completed.height - 10;
         this.window.addChild(this.completed);
         this.task.color = 5898034;
         this.task.text = ILocaleService(Main.osgi.getService(ILocaleService)).getText(TextConst.CHALLENGES_WINDOW_LABEL_CHALLENGE_TEXT);
         this.task.x = 5;
         this.task.y = 5;
         this.panel.addChild(this.task);
         this.taskValue.color = 16777215;
         this.taskValue.x = 5;
         this.taskValue.y = 20;
         this.panel.addChild(this.taskValue);
         this.progressLabel.color = 16777215;
         this.progressLabel.x = this.panel.width - this.progressLabel.width - 5;
         this.progressLabel.y = 20;
         this.panel.addChild(this.progressLabel);
         this.prize.color = 5898034;
         this.prize.text = ILocaleService(Main.osgi.getService(ILocaleService)).getText(TextConst.CHALLENGES_WINDOW_LABEL_PRIZE_TEXT);
         this.prize.x = 5;
         this.prize.y = 55;
         this.panel.addChild(this.prize);
         this.prizeValue.color = 16777215;
         this.prizeValue.x = 5;
         this.prizeValue.y = 80;
         this.panel.addChild(this.prizeValue);
      }
      
      public function setChallegneData(quest:ChallengeServerData) : void
      {
         var prize:String = null;
         this.taskValue.text = quest.description;
         if(quest.changeCost > 0)
         {
            this.changeBtn.setInfo(quest.changeCost);
         }
         this.completed.text = this.completed.text.split(":")[0] + ": " + quest.completed;
         this.progressLabel.text = quest.progress + "/" + quest.target_progress;
         this.progressLabel.x = this.panel.width - this.progressLabel.width - 5;
         this.prize.y = 55;
         this.prizeValue.text = "";
         this.prizeValue.y = 80;
         var countPrizes:int = quest.prizes.length;
         for each(prize in quest.prizes)
         {
            this.prizeValue.text += prize + "\n";
         }
         this.prize.y -= countPrizes * (this.prize.height - 9);
         this.prizeValue.y = this.prize.y + 15;
      }
      
      public function show(quest:ChallengeServerData) : void
      {
         this.setChallegneData(quest);
         this.innerWindow.removeChild(this.bitmap);
         this.createNewIcon(quest.id.split("_" + quest.target_progress)[0]);
         if(quest.specialChallenge != null)
         {
            this.specialPanel.setChallegneData(quest.specialChallenge);
         }
      }
      
      private function onChangeQuest(event:MouseEvent) : void
      {
         var buttonTimer:Timer = null;
         Network(Main.osgi.getService(INetworker)).send("lobby;change_quest;");
         this.changeBtn.enable = false;
         buttonTimer = new Timer(1000,1);
         buttonTimer.addEventListener(TimerEvent.TIMER,function(event:TimerEvent = null):void
         {
            changeBtn.enable = true;
            buttonTimer.stop();
            buttonTimer = null;
         });
         buttonTimer.start();
      }
      
      private function createNewIcon(id:String) : void
      {
         this.bitmap = new Bitmap(this.getBitmapData(id));
         this.bitmap.x = this.innerWindow.width / 2 - this.bitmap.width / 2;
         this.bitmap.y = 5;
         this.innerWindow.addChild(this.bitmap);
      }
      
      private function getBitmapData(id:String) : BitmapData
      {
         switch(id)
         {
            case "kill":
               return new ChallengesIcons.battleTypeBitmap().bitmapData;
            case "damage":
               return new ChallengesIcons.battleTypeBitmap().bitmapData;
            case "score":
               return new ChallengesIcons.winScoreBitmap().bitmapData;
            case "score_dm":
               return new ChallengesIcons.winScoreTypeBitmap().bitmapData;
            case "score_tdm":
               return new ChallengesIcons.winScoreTypeBitmap().bitmapData;
            case "score_ctf":
               return new ChallengesIcons.winScoreTypeBitmap().bitmapData;
            case "score_dom":
               return new ChallengesIcons.winScoreTypeBitmap().bitmapData;
            case "flag_capture":
               return new ChallengesIcons.battleTypeBitmap().bitmapData;
            case "flag_return":
               return new ChallengesIcons.battleTypeBitmap().bitmapData;
            case "capture_point":
               return new ChallengesIcons.battleTypeBitmap().bitmapData;
            case "neutralize_point":
               return new ChallengesIcons.battleTypeBitmap().bitmapData;
            case "win_score":
               return new ChallengesIcons.winScoreBitmap().bitmapData;
            case "win_cry":
               return new ChallengesIcons.winCryBitmap().bitmapData;
            case "first_place":
               return new ChallengesIcons.firstPlaceBitmap().bitmapData;
            case "first_place_dm":
               return new ChallengesIcons.firstPlaceBitmap().bitmapData;
            case "first_place_tdm":
               return new ChallengesIcons.firstPlaceBitmap().bitmapData;
            case "first_place_ctf":
               return new ChallengesIcons.firstPlaceBitmap().bitmapData;
            case "first_place_dom":
               return new ChallengesIcons.firstPlaceBitmap().bitmapData;
            default:
               return new noQuestBitmap().bitmapData;
         }
      }
   }
}
