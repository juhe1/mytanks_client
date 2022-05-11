package alternativa.tanks.models.battlefield.gamemode
{
   import alternativa.tanks.model.panel.IBattleSettings;
   import alternativa.tanks.models.battlefield.BattleView3D;
   import flash.display.BitmapData;
   
   public class DefaultGameModel implements IGameMode
   {
       
      
      public function DefaultGameModel()
      {
         super();
      }
      
      public function applyChanges(viewport:BattleView3D) : void
      {
         viewport.camera.useLight = false;
         viewport.camera.useShadowMap = false;
         viewport.camera.deferredLighting = false;
      }
      
      public function applyChangesBeforeSettings(settings:IBattleSettings) : void
      {
      }
      
      public function applyColorchangesToSkybox(skybox:BitmapData) : BitmapData
      {
         return skybox;
      }
   }
}
