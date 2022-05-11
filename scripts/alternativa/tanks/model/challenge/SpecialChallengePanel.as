package alternativa.tanks.model.challenge
{
   import alternativa.init.Main;
   import alternativa.osgi.service.locale.ILocaleService;
   import alternativa.tanks.locale.constants.TextConst;
   import alternativa.tanks.model.challenge.greenpanel.GreenPanel;
   import alternativa.tanks.model.challenge.server.ChallengeServerData;
   import controls.Label;
   import controls.TankWindowInner;
   import flash.display.Bitmap;
   import flash.display.Sprite;
   
   public class SpecialChallengePanel extends Sprite
   {
      
[Embed(source="794.png")]
      private static const noQuestBitmap:Class;
       
      
      private var bitmap:Bitmap;
      
      private var innerWindow:TankWindowInner;
      
      private var panel:GreenPanel;
      
      private var task:Label;
      
      private var taskValue:Label;
      
      private var progressLabel:Label;
      
      private var prize:Label;
      
      private var prizeValue:Label;
      
      private var innerWidth:int;
      
      private var innerHeight:int;
      
      public function SpecialChallengePanel(width:int, height:int)
      {
         this.bitmap = new Bitmap(new noQuestBitmap().bitmapData);
         this.innerWindow = new TankWindowInner(0,0,TankWindowInner.GREEN);
         this.panel = new GreenPanel(250,90);
         this.task = new Label();
         this.taskValue = new Label();
         this.progressLabel = new Label();
         this.prize = new Label();
         this.prizeValue = new Label();
         super();
         this.innerWidth = width;
         this.innerHeight = height;
         this.createPanel();
         this.addPanel();
      }
      
      private function createPanel() : void
      {
         this.innerWindow.width = this.innerWidth;
         this.innerWindow.height = this.innerHeight;
         addChild(this.innerWindow);
      }
      
      private function addPanel() : void
      {
         this.bitmap.x = this.innerWindow.width / 2 - this.bitmap.width / 2;
         this.bitmap.y = 5;
         this.innerWindow.addChild(this.bitmap);
         this.panel.x = 10;
         this.panel.y = 125;
         this.innerWindow.addChild(this.panel);
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
   }
}
