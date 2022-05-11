package scpacker.gui
{
   import alternativa.init.Main;
   import alternativa.tanks.model.panel.IPanel;
   import alternativa.tanks.model.panel.PanelModel;
   import controls.TankWindow;
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.BlendMode;
   import flash.display.DisplayObjectContainer;
   import flash.display.Shape;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.TimerEvent;
   import flash.filters.BitmapFilterQuality;
   import flash.filters.BlurFilter;
   import flash.geom.Point;
   import flash.text.TextField;
   import flash.text.TextFormat;
   import flash.utils.Timer;
   
   public class GTanksLoaderWindow extends Sprite
   {
      
[Embed(source="1107.png")]
      private static const bitmapFuel:Class;
      
      private static const fuelBitmap:BitmapData = new bitmapFuel().bitmapData;
      
[Embed(source="1126.png")]
      private static const bitmapWindow:Class;
      
      private static const windowBitmap:BitmapData = new bitmapWindow().bitmapData;
      
      private static var p:Class = GTanksLoaderWindow_p;
       
      
      private var image:Bitmap;
      
      private var layer:DisplayObjectContainer;
      
      private var statusLabel:TextField;
      
      private var windowBmp:Bitmap;
      
      private var fuel:Shape;
      
      private var fuelMask:Shape;
      
      private var bubblesMask:Shape;
      
      private const fuelCoord:Point = new Point(30,79);
      
      private const tubeR:Number = 10.5;
      
      private var tubeL:Number = 7000;
      
      private var showTimer:Timer;
      
      private var fuelAnimTimer:Timer;
      
      private var bubblesAnimTimer:Timer;
      
      private var hideTimer:Timer;
      
      private var showDelay:int = 0;
      
      private var hideDelay:int = 10000;
      
      private var fuelAnimDelay:int = 25;
      
      private var bubblesAnimDelay:int = 25;
      
      private const fuelAnimPhases:Array = new Array(0.1,0.2,0.4,0.6,0.8,0.9,1);
      
      private var currentProcessId:Array;
      
      private var bubbles:Array;
      
      private var bubblesContainer:Sprite;
      
      private var lock:Boolean = false;
      
      private var window:TankWindow;
      
      private var newType:Boolean;
      
      private var imageLoader:GTanksLoaderImages;
      
      private var g:Sprite;
      
      private var _prog:Number = 0;
      
      private var t:Number = 0;
      
      public function GTanksLoaderWindow(newType:Boolean = true)
      {
         this.window = new TankWindow(610,305);
         this.g = new p();
         super();
         this.newType = newType;
         this.layer = Main.systemUILayer;
         this.imageLoader = Main.osgi.getService(GTanksLoaderImages) as GTanksLoaderImages;
         this.image = this.imageLoader.getRandomPict();
         this.image.x = 10;
         this.image.y = 11;
         addChild(this.window);
         addChild(this.image);
         this.currentProcessId = new Array();
         this.bubbles = new Array();
         this.windowBmp = new Bitmap(windowBitmap);
         this.windowBmp.width -= 5;
         this.windowBmp.y += 240;
         this.windowBmp.x += 13;
         if(newType)
         {
            addChild(this.windowBmp);
         }
         else
         {
            this.window.addChild(this.g);
            this.g.x = this.image.x;
            this.g.y = this.image.y + this.image.height + 10;
            this.window.height -= 15;
         }
         var tf:TextFormat = new TextFormat("Tahoma",10,16777215);
         this.statusLabel = new TextField();
         this.statusLabel.text = "Status";
         this.statusLabel.defaultTextFormat = tf;
         this.statusLabel.wordWrap = true;
         this.statusLabel.multiline = true;
         this.statusLabel.y = 38;
         this.statusLabel.x = 70;
         this.statusLabel.width = 172;
         this.fuel = new Shape();
         this.fuel.graphics.beginBitmapFill(fuelBitmap);
         this.fuel.graphics.drawRect(0,0,fuelBitmap.width,fuelBitmap.height);
         if(newType)
         {
            addChild(this.fuel);
         }
         this.fuel.x = this.windowBmp.x + 16;
         this.fuel.y = this.windowBmp.y + 17;
         this.fuel.width -= 5;
         this.fuelMask = new Shape();
         if(newType)
         {
            addChild(this.fuelMask);
         }
         this.fuelMask.graphics.beginFill(0,1);
         this.fuelMask.graphics.drawRect(0,0,1,fuelBitmap.height);
         this.fuelMask.x = this.fuel.x;
         this.fuelMask.y = this.fuel.y;
         this.fuel.mask = this.fuelMask;
         this.bubblesContainer = new Sprite();
         if(newType)
         {
            addChild(this.bubblesContainer);
         }
         this.bubblesContainer.blendMode = BlendMode.LIGHTEN;
         this.bubblesContainer.x = this.fuel.x;
         this.bubblesContainer.y = this.fuel.y;
         var filters:Array = new Array();
         filters.push(new BlurFilter(3,0,BitmapFilterQuality.LOW));
         this.bubblesContainer.filters = filters;
         this.bubblesMask = new Shape();
         if(newType)
         {
            addChild(this.bubblesMask);
         }
         this.bubblesMask.graphics.beginFill(0,16711680);
         this.bubblesMask.graphics.drawCircle(this.tubeR,this.tubeR,this.tubeR);
         this.bubblesMask.graphics.beginFill(0,65280);
         this.bubblesMask.graphics.drawCircle(this.tubeL - this.tubeR,this.tubeR,this.tubeR);
         this.bubblesMask.graphics.beginFill(0,255);
         this.bubblesMask.graphics.drawRect(this.tubeR,0,this.tubeL - this.tubeR * 2,this.tubeR * 2);
         this.bubblesMask.x = this.fuel.x;
         this.bubblesMask.y = this.fuel.y;
         this.bubblesContainer.mask = this.bubblesMask;
         this.showTimer = new Timer(this.showDelay,1);
         this.fuelAnimTimer = new Timer(this.fuelAnimDelay,this.fuelAnimPhases.length);
         this.bubblesAnimTimer = new Timer(this.bubblesAnimDelay,1000000);
         this.hideTimer = new Timer(this.hideDelay,1);
         this.layer.addEventListener(Event.ENTER_FRAME,this.animFuel);
         this.bubblesAnimTimer.addEventListener(TimerEvent.TIMER,this.animBubbles);
         this.bubblesAnimTimer.addEventListener(TimerEvent.TIMER_COMPLETE,this.stopBubblesAnim);
         var t_i:Timer = new Timer(Math.random() * 7000,1);
         t_i.addEventListener(TimerEvent.TIMER_COMPLETE,this.onChangeImage);
         t_i.reset();
         t_i.start();
         this.changeProgress(0,0);
         this.onShowTimerComplemete(null);
         this.unlockLoaderWindow();
      }
      
      private function onChangeImage(t:TimerEvent) : void
      {
         var time:Number = NaN;
         removeChild(this.image);
         this.image = this.imageLoader.getRandomPict();
         this.image.x = 10;
         this.image.y = 11;
         addChild(this.image);
         var tu:Timer = new Timer((time = Math.random() * 7000) <= 2000 ? Number(7000) : Number(time),1);
         tu.addEventListener(TimerEvent.TIMER_COMPLETE,this.onChangeImage);
         tu.start();
      }
      
      public function focusIn(focusedObject:Object) : void
      {
      }
      
      public function focusOut(exfocusedObject:Object) : void
      {
      }
      
      public function deactivate() : void
      {
         if(!this.lock)
         {
            this.hideLoaderWindow();
            this.lockLoaderWindow();
         }
      }
      
      public function activate() : void
      {
         if(this.lock)
         {
            this.unlockLoaderWindow();
         }
      }
      
      public function changeStatus(processId:int, value:String) : void
      {
         var s:String = null;
         if(value.length > 100)
         {
            s = value.slice(0,99) + "...";
         }
         else
         {
            s = value;
         }
         this.statusLabel.text = value;
      }
      
      public function changeProgress(processId:int, value:Number) : void
      {
         var index:int = 0;
         if(value == 0)
         {
            this.hideTimer.stop();
            this.currentProcessId.push(processId);
            if(!this.lock && !this.showTimer.running && !this.layer.contains(this))
            {
               this.showTimer.reset();
               this.showTimer.start();
            }
         }
         else if(value == 1)
         {
            index = this.currentProcessId.indexOf(processId);
            if(index != -1)
            {
               this.currentProcessId.splice(index,1);
            }
            if(this.currentProcessId.length == 0)
            {
               if(this.showTimer.running)
               {
                  this.showTimer.stop();
               }
               else if(!this.hideTimer.running)
               {
                  if(!this.lock)
                  {
                     this.hideTimer.reset();
                     this.hideTimer.start();
                  }
               }
               else if(this.lock)
               {
                  this.hideTimer.stop();
               }
            }
         }
      }
      
      public function hideLoaderWindow() : void
      {
         this.showTimer.stop();
         this.onHideTimerComplemete();
      }
      
      public function lockLoaderWindow() : void
      {
         if(!this.lock)
         {
            this.lock = true;
            this.showTimer.stop();
            this.hideTimer.stop();
         }
      }
      
      public function unlockLoaderWindow() : void
      {
         if(this.lock)
         {
            this.lock = false;
         }
      }
      
      private function onShowTimerComplemete(e:TimerEvent) : void
      {
         this.show();
         this.startFuelAnim();
         this.startBubblesAnim();
      }
      
      private function onHideTimerComplemete(e:TimerEvent = null) : void
      {
         this.bubblesAnimTimer.stop();
         this.fuelAnimTimer.stop();
         this.hideTimer.stop();
         this.hide();
      }
      
      private function show() : void
      {
         if(!this.layer.contains(this))
         {
            this.layer.addChild(this);
            Main.stage.addEventListener(Event.RESIZE,this.align);
            this.align();
         }
      }
      
      private function hide() : void
      {
         if(this.layer.contains(this))
         {
            Main.stage.removeEventListener(Event.RESIZE,this.align);
            this.layer.removeChild(this);
            this.fuelMask.width = 0;
         }
      }
      
      public function setFullAndClose(e:Event) : void
      {
         this.t += 500 / 50;
         if(this.t <= 500 && this.t > 0)
         {
            this.fuelMask.width = this.t;
            this.layer.addEventListener(Event.ENTER_FRAME,this.setFullAndClose);
         }
         else
         {
            this.layer.removeEventListener(Event.ENTER_FRAME,this.setFullAndClose);
            this.hideLoaderWindow();
            PanelModel(Main.osgi.getService(IPanel)).unlock();
         }
      }
      
      private function align(e:Event = null) : void
      {
         this.x = Main.stage.stageWidth - this.window.width >>> 1;
         this.y = Main.stage.stageHeight - this.window.height >>> 1;
      }
      
      private function startFuelAnim() : void
      {
         this.fuelAnimTimer.reset();
         this.fuelAnimTimer.start();
      }
      
      public function addProgress(p:Number) : void
      {
         this.show();
         this.t = this._prog;
         this._prog += p;
         this.tubeL = 7000;
         this.layer.addEventListener(Event.ENTER_FRAME,this.animFuel);
      }
      
      public function setProgress(p:Number) : void
      {
         this.show();
         this._prog = p;
         this.tubeL = 7000;
         this.t = 0;
         this.layer.addEventListener(Event.ENTER_FRAME,this.animFuel);
      }
      
      private function animFuel(e:Event) : void
      {
         this.t += this._prog / 50;
         if(this.t <= this._prog && this.t > 0)
         {
            this.fuelMask.width = this.t;
         }
         else
         {
            this.layer.removeEventListener(Event.ENTER_FRAME,this.animFuel);
         }
      }
      
      private function stopFuelAnim(e:TimerEvent) : void
      {
         this.fuelAnimTimer.stop();
      }
      
      private function startBubblesAnim() : void
      {
         this.bubblesAnimTimer.reset();
         this.bubblesAnimTimer.start();
      }
      
      private function animBubbles(e:TimerEvent) : void
      {
         var b:Bubble = null;
         if(this.bubblesAnimTimer.currentCount / 5 == Math.floor(this.bubblesAnimTimer.currentCount / 5))
         {
            b = this.createBubble();
         }
         for(var i:int = 0; i < this.bubbles.length; i++)
         {
            b = this.bubbles[i] as Bubble;
            ++b.time;
            if(b.time < b.lifeTime)
            {
               this.moveBubble(b);
            }
            else
            {
               this.deleteBubble(b);
            }
         }
      }
      
      private function createBubble() : Bubble
      {
         var b:Bubble = new Bubble(1 + Math.random() * 4,14 + Math.random() * 24);
         this.bubbles.push(b);
         this.bubblesContainer.addChild(b);
         b.x = this.tubeR * 2 * Math.random();
         b.y = this.tubeR * 2 * Math.random();
         return b;
      }
      
      private function moveBubble(b:Bubble) : void
      {
         var mod:Number = Math.abs(this.tubeL - b.x);
         var shift:Number = mod < this.tubeL * 0.35 ? Number(7 * (this.tubeL * 0.35 / (this.tubeL * 0.5))) : Number(7 * (mod / (this.tubeL * 0.5)));
         b.x += shift;
         var newY:Number = b.y + 2 - Math.random() * 4;
         if(newY < b.r)
         {
            newY = b.r;
         }
         else if(newY > this.tubeR * 2 - b.r)
         {
            newY = this.tubeR * 2 - b.r;
         }
         b.y = newY;
      }
      
      private function deleteBubble(b:Bubble) : void
      {
         this.bubbles.splice(this.bubbles.indexOf(b),1);
         this.bubblesContainer.removeChild(b);
      }
      
      private function stopBubblesAnim(e:TimerEvent) : void
      {
         this.bubblesAnimTimer.stop();
      }
   }
}
