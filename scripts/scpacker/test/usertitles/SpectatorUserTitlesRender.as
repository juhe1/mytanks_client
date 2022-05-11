package scpacker.test.usertitles
{
   import alternativa.init.Main;
   import alternativa.math.Vector3;
   import alternativa.tanks.display.usertitle.UserTitle;
   import alternativa.tanks.models.battlefield.BattlefieldModel;
   import alternativa.tanks.models.battlefield.IBattleField;
   import alternativa.tanks.models.tank.TankData;
   import flash.events.KeyboardEvent;
   import flash.utils.Timer;
   
   public class SpectatorUserTitlesRender implements UserTitlesRender
   {
       
      
      public var show:Boolean = true;
      
      public var hideHUD:Boolean = false;
      
      private var hideHUDTimer:Timer;
      
      public function SpectatorUserTitlesRender()
      {
         super();
         (Main.osgi.getService(IBattleField) as BattlefieldModel).toDestroy.push(this);
         Main.stage.addEventListener(KeyboardEvent.KEY_DOWN,this.onKeyDown);
         Main.stage.addEventListener(KeyboardEvent.KEY_UP,this.onKeyUp);
      }
      
      public function destroy(b:Boolean) : void
      {
         Main.stage.addEventListener(KeyboardEvent.KEY_DOWN,this.onKeyDown);
         Main.stage.addEventListener(KeyboardEvent.KEY_UP,this.onKeyUp);
      }
      
      private function onKeyDown(e:KeyboardEvent) : void
      {
         if(e.keyCode == 220)
         {
            this.show = !this.show;
         }
      }
      
      private function HUD() : void
      {
         if(this.hideHUD)
         {
            Main.contentUILayer.visible = false;
         }
         else
         {
            Main.contentUILayer.visible = true;
         }
      }
      
      private function onKeyUp(e:KeyboardEvent) : void
      {
      }
      
      public function render() : void
      {
      }
      
      public function setBattlefield(model:IBattleField) : void
      {
      }
      
      public function setLocalData(model:TankData) : void
      {
      }
      
      public function updateTitle(tankData:TankData, cameraPos:Vector3) : void
      {
         if(this.show)
         {
            tankData.tank.title.show();
         }
         else
         {
            tankData.tank.title.hide();
         }
      }
      
      public function configurateTitle(tankData:TankData) : void
      {
         var configFlags:int = UserTitle.BIT_LABEL | UserTitle.BIT_EFFECTS;
         configFlags |= UserTitle.BIT_HEALTH;
         var title:UserTitle = tankData.tank.title;
         title.setLabelText(tankData.userName);
         title.setRank(tankData.userRank);
         title.setTeamType(tankData.teamType);
         title.setHealth(tankData.health);
         title.setConfiguration(configFlags);
      }
   }
}
