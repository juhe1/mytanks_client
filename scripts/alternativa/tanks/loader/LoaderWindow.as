package alternativa.tanks.loader
{
   import alternativa.init.TanksServicesActivator;
   import alternativa.osgi.service.console.IConsoleService;
   import alternativa.osgi.service.focus.IFocusListener;
   import alternativa.osgi.service.loader.ILoaderService;
   import alternativa.osgi.service.loader.ILoadingProgressListener;
   import alternativa.osgi.service.mainContainer.IMainContainerService;
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.DisplayObjectContainer;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.TimerEvent;
   import flash.text.TextField;
   import flash.utils.Dictionary;
   import flash.utils.Timer;
   
   public class LoaderWindow extends Sprite implements ILoadingProgressListener, ILoaderWindowService, IFocusListener
   {
      
[Embed(source="1185.png")]
      private static const bitmapWindowSmall:Class;
      
      private static const windowBitmapSmall:BitmapData = new bitmapWindowSmall().bitmapData;
      
[Embed(source="1118.png")]
      private static const bitmapWindowMedium:Class;
      
      private static const windowBitmapMedium:BitmapData = new bitmapWindowMedium().bitmapData;
      
[Embed(source="1106.png")]
      private static const bitmapWindowBig:Class;
      
      private static const windowBitmapBig:BitmapData = new bitmapWindowBig().bitmapData;
       
      
      private var console:IConsoleService;
      
      private var layer:DisplayObjectContainer;
      
      private var windowBmp:Bitmap;
      
      private var showTimer:Timer;
      
      private var hideTimer:Timer;
      
      private var showDelay:int = 1000;
      
      private var hideDelay:int = 10000;
      
      private var resourcesId:Array;
      
      private var lock:Boolean = false;
      
      private const SIZE_SMALL:String = "SizeSmall";
      
      private const SIZE_MEDIUM:String = "SizeMedium";
      
      private const SIZE_BIG:String = "SizeBig";
      
      private var size:String;
      
      private var batchByProcess:Dictionary;
      
      private var processesForBatch:Dictionary;
      
      private var processesWithoutBatch:Dictionary;
      
      private var batchBlocks:Dictionary;
      
      private var processBlocksList:Array;
      
      private var progressSlots:Array;
      
      private const slotsNum:int = 4;
      
      public function LoaderWindow()
      {
         var i:int = 0;
         i = 0;
         var slot:Bitmap = null;
         super();
         this.size = this.SIZE_SMALL;
         this.layer = (TanksServicesActivator.osgi.getService(IMainContainerService) as IMainContainerService).systemUILayer;
         this.console = TanksServicesActivator.osgi.getService(IConsoleService) as IConsoleService;
         this.resourcesId = new Array();
         this.batchByProcess = new Dictionary();
         this.processesForBatch = new Dictionary();
         this.processesWithoutBatch = new Dictionary();
         this.batchBlocks = new Dictionary();
         this.processBlocksList = new Array();
         this.progressSlots = new Array();
         this.windowBmp = new Bitmap(windowBitmapSmall);
         addChild(this.windowBmp);
         for(i = 0; i < this.slotsNum; i++)
         {
            slot = new Bitmap(ProgressBar.barBd);
            addChild(slot);
            slot.x = 17;
            slot.y = 50 + i * 37;
            if(i != 0)
            {
               slot.visible = false;
            }
            slot.visible = false;
            this.progressSlots.push(slot);
         }
         this.showTimer = new Timer(this.showDelay,1);
         this.hideTimer = new Timer(this.hideDelay,1);
         this.showTimer.addEventListener(TimerEvent.TIMER_COMPLETE,this.onShowTimerComplemete);
         this.hideTimer.addEventListener(TimerEvent.TIMER_COMPLETE,this.onHideTimerComplemete);
         (TanksServicesActivator.osgi.getService(ILoaderService) as ILoaderService).loadingProgress.addEventListener(this);
      }
      
      private function setSize(value:String) : void
      {
         var i:int = 0;
         var slot:Bitmap = null;
         this.size = value;
         switch(value)
         {
            case this.SIZE_SMALL:
               this.windowBmp.bitmapData = windowBitmapSmall;
               for(i = 0; i < this.slotsNum; i++)
               {
                  slot = this.progressSlots[i] as Bitmap;
                  if(i == 0)
                  {
                     slot.visible = true;
                  }
                  else
                  {
                     slot.visible = false;
                  }
               }
               break;
            case this.SIZE_MEDIUM:
               this.windowBmp.bitmapData = windowBitmapMedium;
               for(i = 0; i < this.slotsNum; i++)
               {
                  slot = this.progressSlots[i] as Bitmap;
                  if(i < 2)
                  {
                     slot.visible = true;
                  }
                  else
                  {
                     slot.visible = false;
                  }
               }
               break;
            case this.SIZE_BIG:
               this.windowBmp.bitmapData = windowBitmapBig;
               for(i = 0; i < this.slotsNum; i++)
               {
                  slot = this.progressSlots[i] as Bitmap;
                  slot.visible = true;
               }
         }
      }
      
      private function redraw() : void
      {
         var processBlock:ProcessBlock = null;
         var i:int = 0;
         var l:int = this.processBlocksList.length;
         if(l > 1)
         {
            if(this.processBlocksList.length == 2)
            {
               this.setSize(this.SIZE_MEDIUM);
               for(i = 0; i < this.processBlocksList.length; i++)
               {
                  processBlock = this.processBlocksList[i] as ProcessBlock;
                  processBlock.y = 35 + i * 37;
               }
            }
            else
            {
               this.setSize(this.SIZE_BIG);
               for(i = 0; i < this.processBlocksList.length; i++)
               {
                  processBlock = this.processBlocksList[i] as ProcessBlock;
                  processBlock.y = 35 + i * 37;
               }
            }
         }
         else
         {
            this.setSize(this.SIZE_SMALL);
            processBlock = this.processBlocksList[0] as ProcessBlock;
            if(processBlock != null)
            {
               processBlock.y = 35;
            }
         }
      }
      
      private function addProgress(processId:Object) : ProcessBlock
      {
         var batchBlock:ProcessBlock = null;
         this.console.writeToConsoleChannel("LOADER WINDOW","addProgress   batchId: %1",processId);
         if(this.batchBlocks[processId] == null)
         {
            batchBlock = new ProcessBlock(processId);
            addChild(batchBlock);
            this.batchBlocks[processId] = batchBlock;
            this.processBlocksList.push(batchBlock);
            batchBlock.x = 17;
            this.redraw();
         }
         return batchBlock;
      }
      
      private function removeProgress(processId:Object) : void
      {
         var index:int = 0;
         this.console.writeToConsoleChannel("LOADER WINDOW","removeProgress   batchId: %1",processId);
         var batchBlock:ProcessBlock = this.batchBlocks[processId];
         if(batchBlock != null)
         {
            if(contains(batchBlock))
            {
               removeChild(batchBlock);
            }
            delete this.batchBlocks[processId];
            index = this.processBlocksList.indexOf(batchBlock);
            if(index != -1)
            {
               this.processBlocksList.splice(index,1);
            }
            this.redraw();
         }
      }
      
      private function addProgressWithoutBatch(processId:Object) : ProcessBlock
      {
         var processBlock:ProcessBlock = null;
         this.console.writeToConsoleChannel("LOADER WINDOW","addProgressWithoutBatch   processId: %1",processId);
         if(this.processesWithoutBatch[processId] == null)
         {
            processBlock = new ProcessBlock(processId);
            addChild(processBlock);
            this.processesWithoutBatch[processId] = processBlock;
            this.processBlocksList.push(processBlock);
            processBlock.x = 17;
            this.redraw();
         }
         return processBlock;
      }
      
      private function removeProgressWithoutBatch(processId:Object) : void
      {
         var index:int = 0;
         this.console.writeToConsoleChannel("LOADER WINDOW","removeProgressWithoutBatch   processId: %1",processId);
         var processBlock:ProcessBlock = this.processesWithoutBatch[processId];
         if(processBlock != null)
         {
            if(contains(processBlock))
            {
               removeChild(processBlock);
            }
            delete this.processesWithoutBatch[processId];
            index = this.processBlocksList.indexOf(processBlock);
            if(index != -1)
            {
               this.processBlocksList.splice(index,1);
            }
            this.redraw();
         }
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
      
      public function processStarted(processId:Object) : void
      {
         this.console.writeToConsoleChannel("LOADER WINDOW","processStarted   processId: %1",processId);
         var batchId:int = this.batchByProcess[processId] != null ? int(int(this.batchByProcess[processId])) : int(int(-1));
         if(batchId != -1)
         {
            if(this.batchBlocks[batchId] == null)
            {
               this.addProgress(batchId);
            }
         }
         else if(this.processesWithoutBatch[processId] == null)
         {
            this.addProgressWithoutBatch(processId);
         }
         this.hideTimer.stop();
         if(this.resourcesId.indexOf(processId) == -1)
         {
            this.resourcesId.push(processId);
         }
         if(!this.lock && !this.showTimer.running && !this.layer.contains(this))
         {
            this.showTimer.reset();
            this.showTimer.start();
         }
      }
      
      public function processStoped(processId:Object) : void
      {
         var currentBatchProcesses:Array = null;
         var index:int = 0;
         this.console.writeToConsoleChannel("LOADER WINDOW","processStoped   processId: %1",processId);
         var batchId:int = this.batchByProcess[processId] != null ? int(int(this.batchByProcess[processId])) : int(int(-1));
         if(batchId != -1)
         {
            currentBatchProcesses = this.processesForBatch[batchId] as Array;
            index = currentBatchProcesses.indexOf(processId);
            if(index != -1)
            {
               currentBatchProcesses.splice(index,1);
               if(currentBatchProcesses.length == 0)
               {
                  this.processesForBatch[batchId] = null;
                  this.removeProgress(batchId);
               }
            }
         }
         else
         {
            this.removeProgressWithoutBatch(processId);
         }
         index = this.resourcesId.indexOf(processId);
         if(index != -1)
         {
            this.resourcesId.splice(index,1);
         }
         if(this.resourcesId.length == 0)
         {
            this.console.writeToConsoleChannel("LOADER WINDOW","   all processes completed");
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
      
      public function changeStatus(processId:Object, value:String) : void
      {
         var processBlock:ProcessBlock = null;
         var statusLabel:TextField = null;
         var s:String = null;
         this.console.writeToConsoleChannel("LOADER WINDOW","changeStatus   processId: %1, value: %2",processId,value);
         var batchId:int = this.batchByProcess[processId] != null ? int(int(this.batchByProcess[processId])) : int(int(-1));
         if(batchId != -1)
         {
            processBlock = this.batchBlocks[batchId] as ProcessBlock;
         }
         else
         {
            processBlock = this.processesWithoutBatch[processId] as ProcessBlock;
         }
         if(processBlock != null)
         {
            statusLabel = processBlock.statusLabel;
            if(statusLabel != null)
            {
               if(value.length > 100)
               {
                  s = value.slice(0,99) + "...";
               }
               else
               {
                  s = value;
               }
               statusLabel.text = value;
            }
         }
      }
      
      public function changeProgress(processId:Object, value:Number) : void
      {
         var processBlock:ProcessBlock = null;
         this.console.writeToConsoleChannel("LOADER WINDOW","changeProgress   processId: %1, value: %2",processId,value);
         var batchId:int = this.batchByProcess[processId] != null ? int(int(this.batchByProcess[processId])) : int(int(-1));
         if(batchId != -1)
         {
            processBlock = this.batchBlocks[batchId] as ProcessBlock;
         }
         else
         {
            processBlock = this.processesWithoutBatch[processId] as ProcessBlock;
         }
         this.console.writeToConsoleChannel("LOADER WINDOW","   processBlock: %1",processBlock);
         if(processBlock != null)
         {
            this.console.writeToConsoleChannel("LOADER WINDOW","   processBlock processId: %1",processBlock.processId);
            processBlock.progressBar.progress = value;
         }
      }
      
      public function setBatchIdForProcess(batchId:int, processId:Object) : void
      {
         this.console.writeToConsoleChannel("LOADER WINDOW","setBatchIdForProcess   batchId: %1, processId: %2",batchId,processId);
         this.batchByProcess[processId] = batchId;
         if(this.processesForBatch[batchId] == null)
         {
            this.processesForBatch[batchId] = new Array();
         }
         (this.processesForBatch[batchId] as Array).push(processId);
      }
      
      public function showLoaderWindow() : void
      {
         this.onShowTimerComplemete();
      }
      
      public function hideLoaderWindow() : void
      {
         this.showTimer.stop();
         this.onHideTimerComplemete();
      }
      
      public function lockLoaderWindow() : void
      {
         this.console.writeToConsoleChannel("LOADER WINDOW","lockLoaderWindow");
         if(!this.lock)
         {
            this.lock = true;
            this.showTimer.stop();
            this.hideTimer.stop();
         }
      }
      
      public function unlockLoaderWindow() : void
      {
         this.console.writeToConsoleChannel("LOADER WINDOW","unlockLoaderWindow");
         if(this.lock)
         {
            this.lock = false;
         }
      }
      
      private function onShowTimerComplemete(e:TimerEvent = null) : void
      {
         this.showTimer.stop();
         this.show();
      }
      
      private function onHideTimerComplemete(e:TimerEvent = null) : void
      {
         this.hideTimer.stop();
         this.hide();
      }
      
      private function show() : void
      {
         if(!this.layer.contains(this))
         {
            this.layer.addChild(this);
            Game._stage.addEventListener(Event.RESIZE,this.align);
            this.align();
         }
      }
      
      private function hide() : void
      {
         if(this.layer.contains(this))
         {
            Game._stage.removeEventListener(Event.RESIZE,this.align);
            this.layer.removeChild(this);
         }
      }
      
      private function align(e:Event = null) : void
      {
         this.x = Game._stage.stageWidth - this.width >>> 1;
         this.y = Game._stage.stageHeight - this.height >>> 1;
      }
   }
}
