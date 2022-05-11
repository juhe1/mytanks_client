package alternativa.tanks.models.battlefield.gui.statistics.fps
{
   import alternativa.init.Main;
   import alternativa.tanks.model.PingService;
   import alternativa.tanks.utils.MathUtils;
   import controls.Label;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.TimerEvent;
   import flash.filters.DropShadowFilter;
   import flash.text.TextFieldAutoSize;
   import flash.utils.Timer;
   import flash.utils.getTimer;
   import scpacker.networking.INetworker;
   import scpacker.networking.Network;
   
   public class FPSText extends Sprite
   {
       
      
      private const OFFSET_X:int = 70;
      
      private const OFFSET_Y:int = 74;
      
      private const FPS_OFFSET_X:int = 60;
      
      private const NUM_FRAMES:int = 10;
      
      private var fps:Label;
      
      private var label:Label;
      
      private var ping:Label;
      
      private var pingLabel:Label;
      
      private var tfDelay:int = 0;
      
      private var tfTimer:int;
      
      private var filter:DropShadowFilter;
      
      private var timer:Timer;
      
      public var colored:Boolean = false;
      
      public function FPSText(color:Boolean = false)
      {
         this.fps = new Label();
         this.label = new Label();
         this.ping = new Label();
         this.pingLabel = new Label();
         this.filter = new DropShadowFilter(0,0,0,1,2,2,3,3,false,false,false);
         super();
         this.colored = color;
         addEventListener(Event.ADDED_TO_STAGE,this.onAddedToStage);
         addEventListener(Event.REMOVED_FROM_STAGE,this.onRemovedFromStage);
      }
      
      private function onAddedToStage(e:Event) : void
      {
         this.label.autoSize = TextFieldAutoSize.LEFT;
         this.label.color = 16777215;
         this.label.text = "FPS: ";
         this.label.selectable = false;
         addChild(this.label);
         this.fps.autoSize = TextFieldAutoSize.RIGHT;
         this.fps.color = 16777215;
         this.fps.text = Number(stage.frameRate).toFixed(2);
         this.fps.selectable = false;
         this.fps.bold = true;
         if(this.colored)
         {
            this.fps.filters = [this.filter];
         }
         addChild(this.fps);
         this.pingLabel.autoSize = TextFieldAutoSize.LEFT;
         this.pingLabel.color = 16777215;
         this.pingLabel.text = "PING: ";
         this.pingLabel.selectable = false;
         addChild(this.pingLabel);
         this.ping.autoSize = TextFieldAutoSize.RIGHT;
         this.ping.color = 16777215;
         this.ping.text = "0";
         this.ping.selectable = false;
         this.ping.bold = true;
         if(this.colored)
         {
            this.ping.filters = [this.filter];
         }
         addChild(this.ping);
         this.tfTimer = getTimer();
         this.onResize(null);
         this.timer = new Timer(1000);
         this.timer.addEventListener(TimerEvent.TIMER,this.sendRequest);
         this.timer.start();
         stage.addEventListener(Event.ENTER_FRAME,this.onEnterFrame);
         stage.addEventListener(Event.RESIZE,this.onResize);
      }
      
      private function onRemovedFromStage(e:Event) : void
      {
         this.timer.removeEventListener(TimerEvent.TIMER,this.sendRequest);
         this.timer.stop();
         stage.removeEventListener(Event.ENTER_FRAME,this.onEnterFrame);
         stage.removeEventListener(Event.RESIZE,this.onResize);
      }
      
      private function sendRequest(e:TimerEvent) : void
      {
         Network(Main.osgi.getService(INetworker)).send("battle;ping");
         PingService.setReqTime();
      }
      
      private function onEnterFrame(e:Event) : void
      {
         var delta:uint = 0;
         var now:int = 0;
         var deltaP:int = 0;
         var pingInt:int = 0;
         var offset:Number = NaN;
         var r:String = null;
         var g:String = null;
         if(++this.tfDelay >= this.NUM_FRAMES)
         {
            delta = this.tfTimer;
            this.tfTimer = getTimer();
            delta = this.tfTimer - delta;
            this.fps.text = Number(1000 * this.tfDelay / delta).toFixed(2);
            if(this.colored)
            {
               offset = Number(this.fps.text) / 60;
               r = MathUtils.clamp(255 * (1 - offset) + 150,0,255).toString(16);
               g = MathUtils.clamp(255 * offset + 150,0,255).toString(16);
               this.fps.color = uint("0x" + (r == "0" ? "00" : r) + (g == "0" ? "00" : g) + "00");
               this.fps.filters = [this.filter];
            }
            else
            {
               this.fps.color = 16777215;
               this.fps.filters = null;
            }
            now = getTimer();
            deltaP = now - PingService.getResTime();
            pingInt = PingService.getPing();
            if(pingInt > 0)
            {
               this.ping.text = pingInt.toString();
               if(deltaP > 2000)
               {
                  this.ping.text = "999";
               }
               if(this.colored)
               {
                  if(Number(this.ping.text) > 500)
                  {
                     this.ping.color = 16711680;
                  }
                  else if(Number(this.ping.text) > 200)
                  {
                     this.ping.color = 16776960;
                  }
                  else
                  {
                     this.ping.color = 65297;
                  }
                  this.ping.filters = [this.filter];
               }
               else
               {
                  this.ping.color = 16777215;
                  this.ping.filters = null;
               }
            }
            this.tfDelay = 0;
         }
      }
      
      private function onResize(e:Event) : void
      {
         x = stage.stageWidth - this.OFFSET_X;
         y = stage.stageHeight - this.OFFSET_Y;
         this.fps.x = this.FPS_OFFSET_X - this.fps.width;
         this.fps.y = this.ping.y - this.ping.height;
         this.label.y = this.ping.y - this.ping.height;
         this.ping.x = this.FPS_OFFSET_X - this.ping.width;
      }
   }
}
