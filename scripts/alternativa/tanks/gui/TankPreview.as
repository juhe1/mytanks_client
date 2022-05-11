package alternativa.tanks.gui
{
   import alternativa.engine3d.alternativa3d;
   import alternativa.engine3d.containers.KDContainer;
   import alternativa.engine3d.core.Object3DContainer;
   import alternativa.engine3d.core.View;
   import alternativa.engine3d.materials.TextureMaterial;
   import alternativa.engine3d.objects.Mesh;
   import alternativa.init.Main;
   import alternativa.osgi.service.locale.ILocaleService;
   import alternativa.tanks.Tank3D;
   import alternativa.tanks.Tank3DPart;
   import alternativa.tanks.bg.IBackgroundService;
   import alternativa.tanks.camera.GameCamera;
   import alternativa.types.Long;
   import controls.TankWindow2;
   import controls.TankWindowHeader;
   import controls.TankWindowInner;
   import flash.display.Shape;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.events.TimerEvent;
   import flash.geom.Rectangle;
   import flash.utils.Timer;
   import flash.utils.clearInterval;
   import flash.utils.getTimer;
   import flash.utils.setInterval;
   import scpacker.resource.ResourceType;
   import scpacker.resource.ResourceUtil;
   import scpacker.resource.images.ImageResource;
   import scpacker.resource.tanks.TankResource;
   import specter.utils.Logger;
   
   public class TankPreview extends Sprite
   {
       
      
      private var window:TankWindow2;
      
      private const windowMargin:int = 11;
      
      private var inner:TankWindowInner;
      
      private var rootContainer:Object3DContainer;
      
      private var cameraContainer:Object3DContainer;
      
      private var camera:GameCamera;
      
      private var timer:Timer;
      
      private var tank:Tank3D;
      
      private var rotationSpeed:Number;
      
      private var lastTime:int;
      
      private var loadedCounter:int = 0;
      
      private var holdMouseX:int;
      
      private var lastMouseX:int;
      
      private var prelastMouseX:int;
      
      private var rate:Number;
      
      private var startAngle:Number = -150;
      
      private var holdAngle:Number;
      
      private var slowdownTimer:Timer;
      
      private var resetRateInt:uint;
      
      private var autoRotationDelay:int = 10000;
      
      private var autoRotationTimer:Timer;
      
      public var overlay:Shape;
      
      private var firstAutoRotation:Boolean = true;
      
      private var first_resize:Boolean = true;
      
      public function TankPreview(garageBoxId:Long, rotationSpeed:Number = 5)
      {
         var box:Mesh = null;
         var material:TextureMaterial = null;
         this.overlay = new Shape();
         super();
         this.rotationSpeed = rotationSpeed;
         this.window = new TankWindow2(400,300);
         var localeService:ILocaleService = ILocaleService(Main.osgi.getService(ILocaleService));
         this.window.header = TankWindowHeader.YOUR_TANK;
         addChild(this.window);
         this.rootContainer = new KDContainer();
         var boxResource:TankResource = ResourceUtil.getResource(ResourceType.MODEL,"garage_box_model") as TankResource;
         Main.writeVarsToConsoleChannel("TANK PREVIEW","\tgarageBoxId: %1",garageBoxId);
         Main.writeVarsToConsoleChannel("TANK PREVIEW","\tboxResource: %1",boxResource);
         var boxes:Vector.<Mesh> = new Vector.<Mesh>();
         var numObjects:int = boxResource.objects.length;
         Logger.log("Garage: " + numObjects + " " + boxResource.id);
         for(var i:int = 0; i < numObjects; i++)
         {
            box = boxResource.objects[i] as Mesh;
            if(box != null)
            {
               material = TextureMaterial(box.alternativa3d::faceList.material);
               Main.writeVarsToConsoleChannel("TEST","TankPreview::TankPreview() box texture=%1","E");
               material.texture = ResourceUtil.getResource(ResourceType.IMAGE,"garage_box_img").bitmapData;
               boxes.push(box);
            }
         }
         this.rootContainer.addChild(boxes[0]);
         this.rootContainer.addChild(boxes[2]);
         this.rootContainer.addChild(boxes[1]);
         this.rootContainer.addChild(boxes[3]);
         this.tank = new Tank3D(null,null,null);
         this.rootContainer.addChild(this.tank);
         this.tank.matrix.appendTranslation(-17,0,0);
         this.camera = new GameCamera();
         this.camera.view = new View(100,100,false);
         this.camera.view.hideLogo();
         this.camera.useShadowMap = true;
         this.camera.useLight = true;
         addChild(this.camera.view);
         addChild(this.overlay);
         this.overlay.x = 0;
         this.overlay.y = 9;
         this.overlay.width = 1500;
         this.overlay.height = 1300;
         this.overlay.graphics.clear();
         this.cameraContainer = new Object3DContainer();
         this.rootContainer.addChild(this.cameraContainer);
         this.cameraContainer.addChild(this.camera);
         this.camera.z = -740;
         this.cameraContainer.rotationX = -135 * Math.PI / 180;
         this.cameraContainer.rotationZ = this.startAngle * Math.PI / 180;
         this.inner = new TankWindowInner(0,0,TankWindowInner.TRANSPARENT);
         addChild(this.inner);
         this.inner.mouseEnabled = true;
         this.resize(400,300);
         this.autoRotationTimer = new Timer(this.autoRotationDelay,1);
         this.autoRotationTimer.addEventListener(TimerEvent.TIMER_COMPLETE,this.start);
         this.timer = new Timer(50);
         this.slowdownTimer = new Timer(20,1000000);
         this.slowdownTimer.addEventListener(TimerEvent.TIMER,this.slowDown);
         this.inner.addEventListener(MouseEvent.MOUSE_DOWN,this.onMouseDown);
         Main.stage.addEventListener(Event.ENTER_FRAME,this.onRender);
         this.start();
      }
      
      public function hide() : void
      {
         var bgService:IBackgroundService = Main.osgi.getService(IBackgroundService) as IBackgroundService;
         if(bgService != null)
         {
            bgService.drawBg();
         }
         this.stopAll();
         this.window = null;
         this.inner = null;
         this.rootContainer = null;
         this.cameraContainer = null;
         this.camera = null;
         this.timer = null;
         this.tank = null;
         Main.stage.removeEventListener(Event.ENTER_FRAME,this.onRender);
      }
      
      private function onMouseDown(e:MouseEvent) : void
      {
         if(this.autoRotationTimer.running)
         {
            this.autoRotationTimer.stop();
         }
         if(this.timer.running)
         {
            this.stop();
         }
         if(this.slowdownTimer.running)
         {
            this.slowdownTimer.stop();
         }
         this.resetRate();
         this.holdMouseX = Main.stage.mouseX;
         this.lastMouseX = this.holdMouseX;
         this.prelastMouseX = this.holdMouseX;
         this.holdAngle = this.cameraContainer.rotationZ;
         Main.writeToConsole("TankPreview onMouseMove holdAngle: " + this.holdAngle.toString());
         Main.stage.addEventListener(MouseEvent.MOUSE_UP,this.onMouseUp);
         Main.stage.addEventListener(MouseEvent.MOUSE_MOVE,this.onMouseMove);
      }
      
      private function onMouseMove(e:MouseEvent) : void
      {
         this.cameraContainer.rotationZ = this.holdAngle - (Main.stage.mouseX - this.holdMouseX) * 0.01;
         this.camera.render();
         this.rate = (Main.stage.mouseX - this.prelastMouseX) * 0.5;
         this.prelastMouseX = this.lastMouseX;
         this.lastMouseX = Main.stage.mouseX;
         clearInterval(this.resetRateInt);
         this.resetRateInt = setInterval(this.resetRate,50);
      }
      
      private function resetRate() : void
      {
         this.rate = 0;
      }
      
      private function onMouseUp(e:MouseEvent) : void
      {
         clearInterval(this.resetRateInt);
         Main.stage.removeEventListener(MouseEvent.MOUSE_UP,this.onMouseUp);
         Main.stage.removeEventListener(MouseEvent.MOUSE_MOVE,this.onMouseMove);
         if(Math.abs(this.rate) > 0)
         {
            this.slowdownTimer.reset();
            this.slowdownTimer.start();
         }
         else
         {
            this.autoRotationTimer.reset();
            this.autoRotationTimer.start();
         }
      }
      
      private function slowDown(e:TimerEvent) : void
      {
         this.cameraContainer.rotationZ -= this.rate * 0.01;
         this.camera.render();
         this.rate *= Math.exp(-0.02);
         if(Math.abs(this.rate) < 0.1)
         {
            this.slowdownTimer.stop();
            this.autoRotationTimer.reset();
            this.autoRotationTimer.start();
         }
      }
      
      public function setHull(hull:String) : void
      {
         if(hull.indexOf("HD_") != -1)
         {
            hull = hull.replace("HD_","");
         }
         var hullPart:Tank3DPart = new Tank3DPart();
         hullPart.details = ResourceUtil.getResource(ResourceType.IMAGE,hull + "_details").bitmapData;
         hullPart.lightmap = ResourceUtil.getResource(ResourceType.IMAGE,hull + "_lightmap").bitmapData;
         hullPart.mesh = ResourceUtil.getResource(ResourceType.MODEL,hull).mesh;
         hullPart.turretMountPoint = ResourceUtil.getResource(ResourceType.MODEL,hull).turretMount;
         this.tank.setHull(hullPart);
         if(this.loadedCounter < 3)
         {
            ++this.loadedCounter;
         }
         if(this.loadedCounter == 3)
         {
            if(this.firstAutoRotation && !this.timer.running && !this.slowdownTimer.running)
            {
               this.start();
            }
            this.camera.render();
         }
      }
      
      public function setTurret(turret:String) : void
      {
         var turretPart:Tank3DPart = new Tank3DPart();
         turretPart.details = ResourceUtil.getResource(ResourceType.IMAGE,turret + "_details").bitmapData;
         turretPart.lightmap = ResourceUtil.getResource(ResourceType.IMAGE,turret + "_lightmap").bitmapData;
         if(turret.indexOf("HD_") != -1)
         {
            turret = turret.replace("HD_","");
         }
         turretPart.mesh = ResourceUtil.getResource(ResourceType.MODEL,turret).mesh;
         turretPart.turretMountPoint = ResourceUtil.getResource(ResourceType.MODEL,turret).turretMount;
         this.tank.setTurret(turretPart);
         if(this.loadedCounter < 3)
         {
            ++this.loadedCounter;
         }
         if(this.loadedCounter == 3)
         {
            if(this.firstAutoRotation && !this.timer.running && !this.slowdownTimer.running)
            {
               this.start();
               this.camera.addShadow(this.tank.shadow);
            }
            this.camera.render();
         }
      }
      
      public function setColorMap(map:ImageResource) : void
      {
         this.tank.setColorMap(map);
         if(this.loadedCounter < 3)
         {
            ++this.loadedCounter;
         }
         if(this.loadedCounter == 3)
         {
            if(this.firstAutoRotation && !this.timer.running && !this.slowdownTimer.running)
            {
               this.start();
            }
            this.camera.render();
         }
      }
      
      public function resize(width:Number, height:Number, i:int = 0, j:int = 0) : void
      {
         this.window.width = width;
         this.window.height = height;
         this.window.alpha = 1;
         this.inner.width = width - this.windowMargin * 2;
         this.inner.height = height - this.windowMargin * 2;
         this.inner.x = this.windowMargin;
         this.inner.y = this.windowMargin;
         var bgService:IBackgroundService = Main.osgi.getService(IBackgroundService) as IBackgroundService;
         if(Main.stage.stageWidth >= 800 && !this.first_resize)
         {
            if(bgService != null)
            {
               bgService.drawBg(new Rectangle(Math.round(int(Math.max(1000,Main.stage.stageWidth)) / 3) + this.windowMargin,60 + this.windowMargin,this.inner.width,this.inner.height));
            }
         }
         this.first_resize = false;
         this.camera.view.width = width - this.windowMargin * 2 - 2;
         this.camera.view.height = height - this.windowMargin * 2 - 2;
         this.camera.view.x = this.windowMargin;
         this.camera.view.y = this.windowMargin;
         this.camera.render();
      }
      
      public function start(e:TimerEvent = null) : void
      {
         if(this.loadedCounter < 3)
         {
            this.autoRotationTimer.reset();
            this.autoRotationTimer.start();
         }
         else
         {
            this.firstAutoRotation = false;
            this.timer.addEventListener(TimerEvent.TIMER,this.onTimer);
            this.timer.reset();
            this.lastTime = getTimer();
            this.timer.start();
         }
      }
      
      public function onRender(e:Event) : void
      {
         this.camera.render();
      }
      
      public function stop() : void
      {
         this.timer.stop();
         this.timer.removeEventListener(TimerEvent.TIMER,this.onTimer);
      }
      
      public function stopAll() : void
      {
         this.timer.stop();
         this.timer.removeEventListener(TimerEvent.TIMER,this.onTimer);
         this.slowdownTimer.stop();
         this.slowdownTimer.removeEventListener(TimerEvent.TIMER,this.slowDown);
         this.autoRotationTimer.stop();
         this.slowdownTimer.removeEventListener(TimerEvent.TIMER_COMPLETE,this.start);
      }
      
      private function onTimer(e:TimerEvent) : void
      {
         var time:int = this.lastTime;
         this.lastTime = getTimer();
         this.cameraContainer.rotationZ -= this.rotationSpeed * (this.lastTime - time) * 0.001 * (Math.PI / 180);
      }
   }
}
