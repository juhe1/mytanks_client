package alternativa.tanks.models.battlefield.effects.graffiti
{
   import alternativa.init.Main;
   import alternativa.object.ClientObject;
   import alternativa.tanks.models.battlefield.BattlefieldModel;
   import alternativa.tanks.models.battlefield.IBattleField;
   import flash.display.DisplayObjectContainer;
   import flash.events.Event;
   import flash.events.KeyboardEvent;
   import flash.events.MouseEvent;
   import flash.events.TimerEvent;
   import flash.ui.Keyboard;
   import flash.utils.Dictionary;
   import flash.utils.Timer;
   
   public class GraffitiModel
   {
      
      private static const COOLDOWN_TIME:int = 30;
       
      
      private var seconds:int = 0;
      
      private var battlefieldModel:BattlefieldModel;
      
      private var guiLayer:DisplayObjectContainer;
      
      private var menu:GraffitiMenu;
      
      private var numGraffitis:int;
      
      private var currId:int = 0;
      
      private var toggle:Boolean = false;
      
      private var graffitisByIndex:Dictionary;
      
      private var canPut:Boolean = true;
      
      private var countDownTimer:Timer;
      
      public function GraffitiModel()
      {
         this.graffitisByIndex = new Dictionary();
         super();
         this.battlefieldModel = Main.osgi.getService(IBattleField) as BattlefieldModel;
         this.guiLayer = Main.contentLayer;
         this.menu = new GraffitiMenu();
      }
      
      public function initGraffitis(items:Array) : void
      {
         this.numGraffitis = items.length;
         for(var i:int = 0; i < this.numGraffitis; i++)
         {
            this.graffitisByIndex[i] = items[i];
         }
         this.initButtons();
      }
      
      public function objectLoaded(object:ClientObject) : void
      {
         this.menu.visible = false;
         this.guiLayer.addChild(this.menu);
         this.guiLayer.stage.addEventListener(Event.RESIZE,this.onResize);
         this.guiLayer.stage.addEventListener(KeyboardEvent.KEY_DOWN,this.onKeyDown);
         this.guiLayer.stage.addEventListener(KeyboardEvent.KEY_UP,this.onKeyUp);
         this.onResize(null);
      }
      
      public function objectUnloaded(object:ClientObject) : void
      {
         this.guiLayer.removeChild(this.menu);
         this.guiLayer.stage.removeEventListener(Event.RESIZE,this.onResize);
         this.guiLayer.stage.removeEventListener(KeyboardEvent.KEY_DOWN,this.onKeyDown);
         this.guiLayer.stage.removeEventListener(KeyboardEvent.KEY_UP,this.onKeyUp);
      }
      
      private function initButtons() : void
      {
         if(this.numGraffitis <= 1)
         {
            this.menu.lockNextButton();
            this.menu.lockPrevButton();
         }
         else
         {
            this.menu.unlockNextButton();
            this.menu.lockPrevButton();
         }
         this.menu.addEventNextClick(this.nextClick);
         this.menu.addEventPrevClick(this.prevClick);
      }
      
      private function updateButtons() : void
      {
         if(this.currId == 0)
         {
            this.menu.lockPrevButton();
         }
         if(this.currId == 0 && this.numGraffitis > 1)
         {
            this.menu.lockPrevButton();
            this.menu.unlockNextButton();
         }
         if(this.currId > 0)
         {
            this.menu.unlockPrevButton();
         }
         if(this.currId > 0 && this.currId < this.numGraffitis - 1)
         {
            this.menu.unlockPrevButton();
            this.menu.unlockNextButton();
         }
         if(this.currId == this.numGraffitis - 1)
         {
            this.menu.lockNextButton();
         }
      }
      
      private function nextClick(e:MouseEvent) : void
      {
         if(this.currId < this.numGraffitis - 1)
         {
            ++this.currId;
            this.menu.showPreview(this.graffitisByIndex[this.currId].id,this.graffitisByIndex[this.currId].name,this.graffitisByIndex[this.currId].count);
            this.updateButtons();
         }
      }
      
      private function prevClick(e:MouseEvent) : void
      {
         if(this.currId > 0)
         {
            --this.currId;
            this.menu.showPreview(this.graffitisByIndex[this.currId].id,this.graffitisByIndex[this.currId].name,this.graffitisByIndex[this.currId].count);
            this.updateButtons();
         }
      }
      
      private function onResize(e:Event) : void
      {
         this.menu.x = Math.round((Main.stage.stageWidth - this.menu.width) * 0.5);
         this.menu.y = Math.round((Main.stage.stageHeight - this.menu.height) * 0.5);
      }
      
      private function startCooldown() : void
      {
         this.countDownTimer = new Timer(1000);
         this.countDownTimer.addEventListener(TimerEvent.TIMER,this.showLockTime);
         this.countDownTimer.start();
      }
      
      private function showLockTime(e:TimerEvent = null) : void
      {
         var time:int = COOLDOWN_TIME - this.seconds;
         this.menu.updateLockTime(time);
         ++this.seconds;
         if(time <= 0)
         {
            this.countDownTimer.removeEventListener(TimerEvent.TIMER,this.showLockTime);
            this.countDownTimer.stop();
            this.seconds = 0;
            this.canPut = true;
            this.menu.unLockGraffiti();
            if(this.menu.visible)
            {
               this.menu.showPreview(this.graffitisByIndex[this.currId].id,this.graffitisByIndex[this.currId].name,this.graffitisByIndex[this.currId].count);
            }
         }
      }
      
      private function onKeyDown(e:KeyboardEvent) : void
      {
         switch(e.keyCode)
         {
            case Keyboard.R:
               if(this.toggle || this.graffitisByIndex[this.currId] == null)
               {
                  return;
               }
               this.menu.openMenu(this.graffitisByIndex[this.currId]);
               this.toggle = !this.toggle;
               break;
         }
      }
      
      private function onKeyUp(e:KeyboardEvent) : void
      {
         var i:* = undefined;
         var newDict:Dictionary = null;
         var k:* = undefined;
         switch(e.keyCode)
         {
            case Keyboard.R:
               if(!this.toggle || this.graffitisByIndex[this.currId] == null)
               {
                  return;
               }
               if(!this.canPut)
               {
                  this.menu.closeMenu();
                  this.toggle = !this.toggle;
                  return;
               }
               GraffitiManager.putGraffiti(this.graffitisByIndex[this.currId].id);
               this.canPut = false;
               this.menu.lockGraffiti();
               this.startCooldown();
               this.menu.closeMenu();
               --this.graffitisByIndex[this.currId].count;
               if(this.graffitisByIndex[this.currId].count <= 0)
               {
                  delete this.graffitisByIndex[this.currId];
                  --this.numGraffitis;
                  this.currId = 0;
                  i = 0;
                  newDict = new Dictionary();
                  for(k in this.graffitisByIndex)
                  {
                     newDict[i] = this.graffitisByIndex[k];
                     i++;
                  }
                  this.graffitisByIndex = newDict;
               }
               this.toggle = !this.toggle;
               break;
         }
      }
   }
}
