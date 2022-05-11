package scpacker.test.anticheat
{
   import alternativa.tanks.models.battlefield.BattlefieldModel;
   import com.reygazu.anticheat.variables.SecureInt;
   import flash.events.TimerEvent;
   import flash.utils.Timer;
   import flash.utils.getTimer;
   
   public class SpeedHackChecker
   {
       
      
      private const checkInterval:SecureInt = new SecureInt("checkInterval");
      
      private const threshold:SecureInt = new SecureInt("threshold");
      
      private const maxErrors:SecureInt = new SecureInt("maxErrors");
      
      private var errorCounter:SecureInt;
      
      private var battleEventDispatcher:BattlefieldModel;
      
      private var timer:Timer;
      
      private var localTime:int;
      
      private var systemTime:Number;
      
      private var deltas:Array;
      
      public function SpeedHackChecker(param1:BattlefieldModel)
      {
         this.errorCounter = new SecureInt("errorCounter");
         super();
         this.checkInterval.value = 5000;
         this.threshold.value = 300;
         this.maxErrors.value = 3;
         this.errorCounter.value = 0;
         this.deltas = [];
         this.battleEventDispatcher = param1;
         this.localTime = getTimer();
         this.systemTime = new Date().time;
         this.timer = new Timer(this.checkInterval.value);
         this.timer.addEventListener(TimerEvent.TIMER,this.onTimer);
         this.timer.start();
      }
      
      public function stop() : void
      {
         this.timer.stop();
      }
      
      private function onTimer(param1:TimerEvent) : void
      {
         var _timer:int = getTimer();
         var _systemTime:Number = new Date().time;
         var delta:Number = _timer - this.localTime - _systemTime + this.systemTime;
         if(Math.abs(delta) > this.threshold.value)
         {
            this.deltas.push(delta);
            this.errorCounter.value += 1;
            if(this.errorCounter.value >= this.maxErrors.value)
            {
               this.stop();
               this.battleEventDispatcher.cheatDetected();
            }
         }
         else
         {
            this.errorCounter.value = 0;
            this.deltas.length = 0;
         }
         this.localTime = _timer;
         this.systemTime = _systemTime;
      }
   }
}
