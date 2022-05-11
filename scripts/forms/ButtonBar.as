package forms
{
   import alternativa.init.Main;
   import alternativa.osgi.service.locale.ILocaleService;
   import alternativa.tanks.locale.constants.TextConst;
   import controls.panel.BaseButton;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import forms.buttons.MainPanelChallengeButton;
   import forms.buttons.MainPanelDonateButton;
   import forms.buttons.MainPanelFriendsButton;
   import forms.buttons.MainPanelRatingButton;
   import forms.buttons.MainPanelSocialNetsButton;
   import forms.buttons.MainPanelSpinsButton;
   import forms.events.MainButtonBarEvents;
   
   public class ButtonBar extends Sprite
   {
       
      
      public var battlesButton:MainPanelBattlesButton;
      
      public var garageButton:MainPanelGarageButton;
      
      public var statButton:MainPaneHallButton;
      
      public var socialNetsButton:MainPanelSocialNetsButton;
      
      public var bugsButton:MainPanelBugButton;
      
      public var settingsButton:MainPanelConfigButton;
      
      public var soundButton:MainPanelSoundButton;
      
      public var helpButton:MainPanelHelpButton;
      
      public var closeButton:MainPanelCloseButton;
      
      public var addButton:BaseButton;
      
      public var donateButton:MainPanelDonateButton;
      
      public var ratingButton:MainPanelRatingButton;
      
      public var challengeButton:MainPanelChallengeButton;
      
      public var friendsButton:MainPanelFriendsButton;
      
      public var spinsButton:MainPanelSpinsButton;
      
      private var _soundOn:Boolean = true;
      
      private var soundIcon:MovieClip;
      
      public var isTester:Boolean = false;
      
      public function ButtonBar()
      {
         this.battlesButton = new MainPanelBattlesButton();
         this.garageButton = new MainPanelGarageButton();
         this.statButton = new MainPaneHallButton();
         this.socialNetsButton = new MainPanelSocialNetsButton();
         this.bugsButton = new MainPanelBugButton();
         this.settingsButton = new MainPanelConfigButton();
         this.soundButton = new MainPanelSoundButton();
         this.helpButton = new MainPanelHelpButton();
         this.closeButton = new MainPanelCloseButton();
         this.donateButton = new MainPanelDonateButton();
         this.ratingButton = new MainPanelRatingButton();
         this.challengeButton = new MainPanelChallengeButton();
         this.friendsButton = new MainPanelFriendsButton();
         this.spinsButton = new MainPanelSpinsButton();
         super();
         var localeService:ILocaleService = Main.osgi.getService(ILocaleService) as ILocaleService;
         addChild(this.battlesButton);
         this.battlesButton.type = 4;
         this.battlesButton.label = localeService.getText(TextConst.MAIN_PANEL_BUTTON_BATTLES);
         this.battlesButton.addEventListener(MouseEvent.CLICK,this.listClick);
         addChild(this.garageButton);
         this.garageButton.type = 5;
         this.garageButton.label = localeService.getText(TextConst.MAIN_PANEL_BUTTON_GARAGE);
         this.garageButton.addEventListener(MouseEvent.CLICK,this.listClick);
         addChild(this.friendsButton);
         this.friendsButton.type = 15;
         this.friendsButton.addEventListener(MouseEvent.CLICK,this.listClick);
         addChild(this.socialNetsButton);
         this.socialNetsButton.type = 14;
         this.socialNetsButton.addEventListener(MouseEvent.CLICK,this.listClick);
         addChild(this.spinsButton);
         this.spinsButton.type = 13;
         this.spinsButton.addEventListener(MouseEvent.CLICK,this.listClick);
         this.bugsButton.type = 11;
         this.bugsButton.addEventListener(MouseEvent.CLICK,this.listClick);
         addChild(this.settingsButton);
         this.settingsButton.type = 7;
         this.settingsButton.addEventListener(MouseEvent.CLICK,this.listClick);
         addChild(this.soundButton);
         this.soundButton.type = 8;
         this.soundButton.addEventListener(MouseEvent.CLICK,this.listClick);
         this.soundIcon = this.soundButton.getChildByName("icon") as MovieClip;
         addChild(this.helpButton);
         this.helpButton.type = 9;
         this.helpButton.addEventListener(MouseEvent.CLICK,this.listClick);
         addChild(this.closeButton);
         this.closeButton.type = 10;
         this.closeButton.addEventListener(MouseEvent.CLICK,this.listClick);
         addChild(this.donateButton);
         this.donateButton.label = localeService.getText(TextConst.MAIN_PANEL_BUTTON_SHOP);
         this.donateButton.addEventListener(MouseEvent.CLICK,this.listClick);
         addChild(this.ratingButton);
         this.ratingButton.label = localeService.getText(TextConst.MAIN_PANEL_BUTTON_RATING);
         this.ratingButton.type = 2;
         this.ratingButton.addEventListener(MouseEvent.CLICK,this.listClick);
         addChild(this.challengeButton);
         this.challengeButton.label = localeService.getText(TextConst.MAIN_PANEL_BUTTON_CHALLENGE);
         this.challengeButton.type = 3;
         this.challengeButton.addEventListener(MouseEvent.CLICK,this.listClick);
         this.draw();
      }
      
      public function draw() : void
      {
         this.ratingButton.x = this.donateButton.x + this.donateButton.width + 5;
         this.challengeButton.x = this.ratingButton.x + this.ratingButton.width + 5;
         this.battlesButton.x = this.challengeButton.x + this.challengeButton.width + 5;
         this.garageButton.x = this.battlesButton.x + this.battlesButton.width;
         this.friendsButton.x = this.garageButton.x + this.garageButton.width + 5;
         this.spinsButton.x = this.friendsButton.x + this.friendsButton.width + 2;
         this.socialNetsButton.x = this.spinsButton.x + this.spinsButton.width;
         this.settingsButton.x = this.socialNetsButton.x + this.socialNetsButton.width + 1;
         this.soundButton.x = this.settingsButton.x + this.settingsButton.width;
         this.helpButton.x = this.soundButton.x + this.soundButton.width;
         this.closeButton.x = this.helpButton.x + this.helpButton.width + 11;
         this.soundIcon.gotoAndStop(!!this.soundOn ? 1 : 2);
      }
      
      public function set soundOn(value:Boolean) : void
      {
         this._soundOn = value;
         this.draw();
      }
      
      public function get soundOn() : Boolean
      {
         return this._soundOn;
      }
      
      public function listClick(e:MouseEvent) : void
      {
         var target:BaseButton = null;
         var trget:BaseButton = null;
         var i:int = 0;
         if(e.currentTarget as BaseButton != null)
         {
            target = e.currentTarget as BaseButton;
            if(target.enable)
            {
               dispatchEvent(new MainButtonBarEvents(target.type));
            }
            if(target == this.soundButton)
            {
               this.soundOn = !this.soundOn;
            }
            if(target == this.battlesButton || target == this.garageButton || target == this.statButton)
            {
               for(i = 0; i < 3; i++)
               {
                  trget = getChildAt(i) as BaseButton;
                  trget.enable = target != trget;
               }
            }
         }
      }
   }
}
