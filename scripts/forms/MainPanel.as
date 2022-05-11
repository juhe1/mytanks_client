package forms
{
   import alternativa.init.Main;
   import alternativa.osgi.service.locale.ILocaleService;
   import controls.PlayerInfo;
   import controls.rangicons.RangIconNormal;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.events.TimerEvent;
   import flash.utils.Timer;
   import forms.events.MainButtonBarEvents;
   
   public class MainPanel extends Sprite
   {
       
      
      public var rangIcon:RangIconNormal;
      
      public var playerInfo:PlayerInfo;
      
      public var buttonBar:ButtonBar;
      
      private var _rang:int;
      
      private var _isTester:Boolean = false;
      
      public function MainPanel()
      {
         this.rangIcon = new RangIconNormal();
         this.playerInfo = new PlayerInfo();
         super();
         this._isTester = this.isTester;
         this.buttonBar = new ButtonBar();
         addEventListener(Event.ADDED_TO_STAGE,this.configUI);
      }
      
      public function set rang(value:int) : void
      {
         this._rang = value;
         this.playerInfo.rang = value;
         this.rangIcon.rang1 = this._rang;
      }
      
      public function get rang() : int
      {
         return this._rang;
      }
      
      private function configUI(e:Event) : void
      {
         this.y = 3;
         addChild(this.rangIcon);
         addChild(this.playerInfo);
         addChild(this.buttonBar);
         var localeService:ILocaleService = Main.osgi.getService(ILocaleService) as ILocaleService;
         this.rangIcon.y = -2;
         this.rangIcon.x = 2;
         removeEventListener(Event.ADDED_TO_STAGE,this.configUI);
         this.playerInfo.indicators.changeButton.addEventListener(MouseEvent.CLICK,this.listClick);
         this.buttonBar.addButton = this.playerInfo.indicators.changeButton;
         stage.addEventListener(Event.RESIZE,this.onResize);
         this.onResize(null);
         var timer:Timer = new Timer(100,1);
         timer.addEventListener(TimerEvent.TIMER_COMPLETE,function(e:TimerEvent):void
         {
            onResize(null);
         });
         timer.start();
      }
      
      private function listClick(e:MouseEvent) : void
      {
         this.buttonBar.dispatchEvent(new MainButtonBarEvents(1));
      }
      
      public function onResize(e:Event) : void
      {
         var minWidth:int = int(Math.max(1000,stage.stageWidth));
         this.buttonBar.x = minWidth - this.buttonBar.width - 7;
         this.playerInfo.width = minWidth - this.buttonBar.width;
      }
      
      public function hide() : void
      {
         stage.removeEventListener(Event.RESIZE,this.onResize);
      }
      
      public function get isTester() : Boolean
      {
         return this._isTester;
      }
      
      public function set isTester(value:Boolean) : void
      {
         this._isTester = value;
         this.buttonBar.isTester = this._isTester;
         this.buttonBar.draw();
         this.onResize(null);
      }
   }
}
