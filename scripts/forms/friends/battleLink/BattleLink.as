package forms.friends.battleLink
{
   import alternativa.init.Main;
   import alternativa.osgi.service.locale.ILocaleService;
   import alternativa.tanks.model.panel.IPanel;
   import alternativa.tanks.model.panel.PanelModel;
   import controls.Label;
   import flash.display.Bitmap;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import forms.ColorConstants;
   import scpacker.networking.INetworker;
   import scpacker.networking.Network;
   
   public class BattleLink extends Sprite
   {
      
      public static var localeService:ILocaleService;
       
      
      private var _userId:String;
      
      private var _label:Label;
      
      private var _labelCont:Sprite;
      
      private var _availableBattleIcon:Bitmap;
      
      public function BattleLink(param1:String)
      {
         super();
         this._userId = param1;
         if(param1 != null && param1 != "null" && param1 != "")
         {
            this.init();
            this.addEventListener(MouseEvent.CLICK,this.onBattleLinkClick,false,0,true);
         }
      }
      
      private function onBattleLinkClick(param1:MouseEvent) : void
      {
         if(PanelModel(Main.osgi.getService(IPanel)).isInBattle)
         {
            PanelModel(Main.osgi.getService(IPanel)).showQuitBattleDialog();
            return;
         }
         if(PanelModel(Main.osgi.getService(IPanel)).isBattleSelect)
         {
            Network(Main.osgi.getService(INetworker)).send("lobby;get_show_battle_info;" + this._userId);
         }
         else
         {
            PanelModel(Main.osgi.getService(IPanel)).showBattleSelect(null);
         }
      }
      
      private function init() : void
      {
         mouseChildren = true;
         mouseEnabled = true;
         buttonMode = true;
         tabEnabled = false;
         tabChildren = false;
         this._labelCont = new Sprite();
         addChild(this._labelCont);
         this._label = new Label();
         this._label.text = this._userId.split("@")[1];
         this._label.color = ColorConstants.GREEN_LABEL;
         this._labelCont.addChild(this._label);
         this._labelCont.y = -1;
         this._labelCont.useHandCursor = true;
      }
      
      public function removeEvents() : void
      {
         this.removeEventListener(MouseEvent.CLICK,this.onBattleLinkClick);
      }
      
      public function get labelCont() : Sprite
      {
         return this._labelCont;
      }
   }
}
