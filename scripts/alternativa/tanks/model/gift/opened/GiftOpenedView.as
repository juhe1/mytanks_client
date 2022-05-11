package alternativa.tanks.model.gift.opened
{
   import alternativa.init.Main;
   import controls.DefaultButton;
   import controls.Label;
   import controls.TankWindow;
   import controls.TankWindowInner;
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.BlendMode;
   import flash.display.PixelSnapping;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.events.TimerEvent;
   import flash.geom.ColorTransform;
   import flash.text.TextFieldAutoSize;
   import flash.text.TextFormat;
   import flash.utils.Timer;
   import flash.utils.getTimer;
   
   public class GiftOpenedView extends Sprite
   {
      
[Embed(source="1199.png")]
      private static const Shine:Class;
      
      private static const shine:BitmapData = new Shine().bitmapData;
      
[Embed(source="1025.png")]
      private static const Mote:Class;
      
      private static const mote:BitmapData = new Mote().bitmapData;
      
[Embed(source="1092.png")]
      private static const Star:Class;
      
      private static const star:BitmapData = new Star().bitmapData;
      
[Embed(source="857.png")]
      private static const Highlight:Class;
      
      private static const highlight:BitmapData = new Highlight().bitmapData;
      
[Embed(source="1094.png")]
      private static const Background:Class;
      
      private static const backgroundImg:BitmapData = new Background().bitmapData;
      
      private static const STATE_SELECT:int = 0;
      
      private static const STATE_OPEN:int = 1;
      
      private static const STATE_DELAY:int = 2;
      
      private static const STATE_PRESENT:int = 3;
      
      private static const STATE_SWITCH:int = 4;
      
      private static const STATE_COMPLETE:int = 5;
      
      private static const STATE_MULTIPLIER:int = 6;
      
      private static const STATE_LIGHT_UP:int = 7;
      
      private static const OPEN_BUTTON_WIDTH:Number = 135;
      
      private static const OPEN_TIME:Number = 35 / 60;
      
      private static const LIGHT_UP_TIME:Number = 1;
      
      private static const PRESENT_MIDDLE_TIME:Number = 15 / 60;
      
      private static const PRESENT_APPEAR_TIME:Number = 20 / 60;
      
      private static const PRESENT_TIME:Number = PRESENT_APPEAR_TIME + 40 / 60;
      
      private static const PRESENT_DISAPPEAR_TIME:Number = PRESENT_TIME + 10 / 60;
      
      private static const MARGIN:int = 11;
      
      private static const WINDOW_WIDTH:int = 537 + MARGIN * 2;
      
      private static const BUTTON_PANEL_HEIGHT:int = 27;
      
      private static const WINDOW_HEIGHT:int = 456 + MARGIN * 2 + BUTTON_PANEL_HEIGHT;
       
      
      private var color:ColorTransform;
      
      private var bgClosed:Sprite;
      
      private var bgOpen:Sprite;
      
      private var bgLight:Sprite;
      
      private var shine1:Sprite;
      
      private var shine2:Sprite;
      
      private var dust:Dust;
      
      private var stars:Stars;
      
      private var label:Label;
      
      private var present:Sprite;
      
      private var window:TankWindow;
      
      private var inner:TankWindowInner;
      
      private var timer:int = 0;
      
      private var state:int = 0;
      
      private var closeBtn:DefaultButton;
      
      private var preview:Bitmap;
      
      private var itemName:String;
      
      private var openTime:int;
      
      private var givenItems:Array;
      
      private var currentGivenItemsIndex:int;
      
      public function GiftOpenedView(givenItems:Array)
      {
         var i:GivenItem = null;
         var bg:Bitmap = null;
         var textFormat:TextFormat = null;
         var item:GivenItem = null;
         super();
         this.givenItems = givenItems;
         givenItems.sort(function sort(a:GivenItem, b:GivenItem):int
         {
            return a.rarity - b.rarity;
         });
         for each(i in givenItems)
         {
            trace("    ",i.itemName," ",i.rarity);
         }
         this.window = new TankWindow(WINDOW_WIDTH,WINDOW_HEIGHT);
         this.color = new ColorTransform();
         this.bgClosed = new Sprite();
         this.bgOpen = new Sprite();
         this.bgLight = new Sprite();
         this.shine1 = new Sprite();
         this.shine2 = new Sprite();
         this.dust = new Dust(mote,16,WINDOW_WIDTH - 100,WINDOW_HEIGHT - 40);
         this.stars = new Stars(star,highlight,16,WINDOW_WIDTH / 2 - 80);
         this.present = new Sprite();
         this.label = new Label();
         addChild(this.window);
         this.inner = new TankWindowInner(WINDOW_WIDTH - 2 * MARGIN,WINDOW_HEIGHT - 2 * MARGIN - BUTTON_PANEL_HEIGHT - 5,TankWindowInner.GREEN);
         this.inner.x = MARGIN;
         this.inner.y = MARGIN;
         this.window.addChild(this.inner);
         bg = new Bitmap(backgroundImg);
         bg.width = this.inner.width;
         bg.height = this.inner.height;
         this.inner.addChild(bg);
         this.shine1.addChild(new Bitmap(shine,PixelSnapping.NEVER,true));
         this.shine1.blendMode = BlendMode.ADD;
         this.shine2.addChild(new Bitmap(shine,PixelSnapping.NEVER,true));
         this.shine2.blendMode = BlendMode.ADD;
         textFormat = new TextFormat();
         textFormat.align = "center";
         this.label.autoSize = TextFieldAutoSize.CENTER;
         this.label.defaultTextFormat = textFormat;
         this.label.size = 35;
         this.label.x = -(this.inner.width - 100) / 2;
         this.label.y = WINDOW_HEIGHT / 6;
         this.inner.addChild(this.bgOpen);
         this.inner.addChild(this.bgLight);
         this.inner.addChild(this.dust);
         this.inner.addChild(this.stars);
         this.inner.addChild(this.present);
         this.inner.addChild(this.bgClosed);
         this.closeBtn = new DefaultButton();
         this.closeBtn.x = this.window.width / 2 - this.closeBtn.width / 2;
         this.closeBtn.y = this.window.height - this.closeBtn.height - 10;
         this.closeBtn.label = "Закрыть";
         this.closeBtn.width = 93;
         this.closeBtn.addEventListener(MouseEvent.CLICK,this.onClose);
         this.window.addChild(this.closeBtn);
         this.currentGivenItemsIndex = 1;
         item = givenItems[0];
         this.startAnimation(item.preview,item.itemName,item.rarity);
      }
      
      private function startAnimation(preview:BitmapData, itemName:String, rarity:int) : void
      {
         var color:ColorTransform = null;
         this.preview = new Bitmap(preview);
         this.itemName = itemName;
         while(this.present.numChildren > 0)
         {
            this.present.removeChildAt(0);
         }
         this.shine1.getChildAt(0).x = -this.shine1.getChildAt(0).width / 2;
         this.shine1.getChildAt(0).y = -this.shine1.getChildAt(0).height / 2;
         this.shine1.x = WINDOW_WIDTH / 2;
         this.shine1.y = WINDOW_HEIGHT / 2;
         this.shine1.width = 410;
         this.shine1.height = 410;
         this.shine1.blendMode = BlendMode.ADD;
         this.shine2.getChildAt(0).x = -this.shine1.getChildAt(0).width / 2;
         this.shine2.getChildAt(0).y = -this.shine1.getChildAt(0).height / 2;
         this.shine2.x = WINDOW_WIDTH / 2;
         this.shine2.y = WINDOW_HEIGHT / 2;
         this.shine2.width = 410;
         this.shine2.height = 410;
         this.shine2.blendMode = BlendMode.ADD;
         this.dust.x = 50;
         this.dust.y = 20;
         this.dust.alpha = 0;
         this.stars.x = WINDOW_WIDTH / 2;
         this.stars.y = WINDOW_HEIGHT / 2;
         this.stars.alpha = 1;
         this.present.x = WINDOW_WIDTH / 2;
         this.present.y = WINDOW_HEIGHT / 2;
         this.present.alpha = 0;
         this.label.x = -(this.inner.width - 100) / 2;
         this.label.y = WINDOW_HEIGHT / 6;
         this.state = STATE_LIGHT_UP;
         this.timer = getTimer();
         this.dust.alpha = 0;
         this.bgLight.alpha = 0;
         color = new ColorTransform();
         if(rarity == 0)
         {
         }
         if(rarity == 1)
         {
            color.redMultiplier = 0;
            color.greenMultiplier = 0.9;
            color.blueMultiplier = 1.5;
         }
         if(rarity == 2)
         {
            color.redMultiplier = 1;
            color.greenMultiplier = 0.3;
            color.blueMultiplier = 1.5;
         }
         if(rarity == 3)
         {
            color.redMultiplier = 1.2;
            color.greenMultiplier = 0.1;
            color.blueMultiplier = 0;
         }
         if(rarity == 4)
         {
            color.redMultiplier = 1.2;
            color.greenMultiplier = 1.2;
            color.blueMultiplier = 0;
         }
         this.closeBtn.visible = false;
         this.colorize(color);
         addEventListener(Event.ENTER_FRAME,this.onEnterFrame,false,0,true);
         Main.stage.addEventListener(Event.RESIZE,this.resize);
         this.resize(null);
         var endTimer:Timer = new Timer(2000,1);
         endTimer.addEventListener(TimerEvent.TIMER_COMPLETE,this.finishAnimation);
         endTimer.start();
         this.openTime = getTimer();
      }
      
      private function finishAnimation(e:TimerEvent) : void
      {
         var item:GivenItem = null;
         if(this.closeBtn.visible)
         {
            return;
         }
         this.bgLight.alpha = 1;
         this.dust.alpha = 1;
         this.stars.alpha = 1;
         if(!this.present.contains(this.preview))
         {
            this.present.addChild(this.preview);
            this.present.addChild(this.label);
            this.label.text = this.itemName;
            this.label.x = -this.label.width / 2;
            this.preview.x = -this.preview.width / 2;
            this.preview.y = -this.preview.height / 2;
         }
         if(!this.inner.contains(this.dust))
         {
            this.inner.addChild(this.dust);
            this.inner.addChild(this.stars);
            this.inner.addChild(this.present);
         }
         this.dust.alpha = 1;
         this.stars.alpha = 1;
         this.present.alpha = 1;
         this.present.scaleX = 1;
         this.present.scaleY = 1;
         if(this.currentGivenItemsIndex < this.givenItems.length)
         {
            item = this.givenItems[this.currentGivenItemsIndex];
            this.startAnimation(item.preview,item.itemName,item.rarity);
            ++this.currentGivenItemsIndex;
         }
         else
         {
            this.closeBtn.visible = true;
         }
      }
      
      private function resize(e:Event) : void
      {
         this.x = Main.stage.stageWidth / 2 - WINDOW_WIDTH / 2;
         this.y = Main.stage.stageHeight / 2 - WINDOW_HEIGHT / 2;
      }
      
      private function onClose(e:MouseEvent) : void
      {
         this.parent.removeChild(this);
         removeEventListener(Event.ENTER_FRAME,this.onEnterFrame);
      }
      
      private function onEnterFrame(param1:Event) : void
      {
         var _loc3_:Number = NaN;
         var _loc4_:Number = NaN;
         var _loc2_:Number = (getTimer() - this.timer) / 1000;
         if(this.state == STATE_LIGHT_UP)
         {
            _loc3_ = _loc2_ / LIGHT_UP_TIME;
            if(_loc3_ < 1)
            {
               this.bgLight.alpha = _loc3_;
               this.dust.alpha = _loc3_;
               this.stars.alpha = _loc3_;
            }
            else
            {
               this.bgLight.alpha = 1;
               this.dust.alpha = 1;
               this.stars.alpha = 1;
               this.timer = getTimer();
               this.state = STATE_DELAY;
            }
         }
         else if(this.state == STATE_DELAY)
         {
            if(_loc2_ < 0.5)
            {
               this.present.addChild(this.preview);
               this.present.addChild(this.label);
               this.label.text = this.itemName;
               this.label.x = -this.label.width / 2;
               this.preview.x = -this.preview.width / 2;
               this.preview.y = -this.preview.height / 2;
               this.present.alpha = 0;
               this.timer = getTimer();
               this.state = STATE_PRESENT;
            }
         }
         else if(this.state == STATE_PRESENT)
         {
            if(_loc2_ < PRESENT_MIDDLE_TIME)
            {
               _loc3_ = _loc2_ / PRESENT_MIDDLE_TIME;
               _loc3_ = Math.pow(_loc3_,1 / 3);
               _loc4_ = 0.35 + (0.65 + 0.1) * _loc3_;
               this.present.alpha = _loc3_;
               this.present.scaleX = _loc4_;
               this.present.scaleY = _loc4_;
            }
            else if(_loc2_ < PRESENT_APPEAR_TIME)
            {
               this.inner.addChild(this.dust);
               this.inner.addChild(this.stars);
               this.inner.addChild(this.present);
               this.dust.alpha = 1;
               this.stars.alpha = 1;
               _loc3_ = 1 - (_loc2_ - PRESENT_MIDDLE_TIME) / (PRESENT_APPEAR_TIME - PRESENT_MIDDLE_TIME);
               _loc4_ = 1 + 0.1 * _loc3_;
               this.present.alpha = 1;
               this.present.scaleX = _loc4_;
               this.present.scaleY = _loc4_;
            }
            else if(_loc2_ < PRESENT_TIME)
            {
               this.present.alpha = 1;
               this.present.scaleX = 1;
               this.present.scaleY = 1;
            }
            else if(_loc2_ < PRESENT_DISAPPEAR_TIME)
            {
               this.timer = getTimer();
               this.state = STATE_COMPLETE;
            }
         }
         this.shine1.rotation += 0.3;
         this.shine2.rotation -= 0.3;
         this.dust.update();
         this.stars.update();
      }
      
      private function interpolate(param1:ColorTransform, param2:ColorTransform, param3:Number) : void
      {
         this.color.redMultiplier = param1.redMultiplier + (param2.redMultiplier - param1.redMultiplier) * param3;
         this.color.greenMultiplier = param1.greenMultiplier + (param2.greenMultiplier - param1.greenMultiplier) * param3;
         this.color.blueMultiplier = param1.blueMultiplier + (param2.blueMultiplier - param1.blueMultiplier) * param3;
      }
      
      private function colorize(param1:ColorTransform) : void
      {
         this.bgLight.transform.colorTransform = param1;
         this.shine1.transform.colorTransform = param1;
         this.shine2.transform.colorTransform = param1;
         this.dust.transform.colorTransform = param1;
         this.stars.colorize(param1);
      }
   }
}
