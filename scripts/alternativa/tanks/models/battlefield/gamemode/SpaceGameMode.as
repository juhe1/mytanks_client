package alternativa.tanks.models.battlefield.gamemode
{
   import alternativa.engine3d.core.ShadowMap;
   import alternativa.engine3d.lights.DirectionalLight;
   import alternativa.init.Main;
   import alternativa.osgi.service.storage.IStorageService;
   import alternativa.tanks.camera.GameCamera;
   import alternativa.tanks.model.panel.IBattleSettings;
   import alternativa.tanks.models.battlefield.BattleView3D;
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   
   public class SpaceGameMode implements IGameMode
   {
       
      
      private var camera:GameCamera;
      
      public function SpaceGameMode()
      {
         super();
      }
      
      public function applyChanges(viewport:BattleView3D) : void
      {
         var light:DirectionalLight = null;
         var camera:GameCamera = null;
         light = null;
         camera = viewport.camera;
         this.camera = camera;
         camera.directionalLightStrength = 1;
         camera.ambientColor = 989739;
         camera.deferredLighting = true;
         light = new DirectionalLight(2698547);
         light.useShadowMap = true;
         light.rotationX = -2.420796;
         light.rotationY = -1.1;
         light.rotationZ = 7.15;
         light.intensity = 1;
         camera.directionalLight = light;
         camera.shadowMap = new ShadowMap(2048,5000,10000,0,0);
         camera.shadowMapStrength = 1;
         camera.shadowMap.bias = 0.5;
         camera.shadowMap.biasMultiplier = 30;
         camera.shadowMap.additionalSpace = 10000;
         camera.shadowMap.alphaThreshold = 0.1;
         camera.useShadowMap = true;
      }
      
      public function applyChangesBeforeSettings(settings:IBattleSettings) : void
      {
         if(settings.fog && this.camera.fogStrength != 1)
         {
            this.camera.fogStrength = 1;
         }
         else if(!settings.fog)
         {
            this.camera.fogStrength = 0;
         }
         if(settings.shadows && !this.camera.useShadowMap)
         {
            this.camera.useShadowMap = true;
            if(this.camera.directionalLight != null)
            {
               this.camera.directionalLight.useShadowMap = true;
            }
            this.camera.shadowMapStrength = 1;
         }
         else if(!settings.shadows)
         {
            this.camera.useShadowMap = false;
            if(this.camera.directionalLight != null)
            {
               this.camera.directionalLight.useShadowMap = false;
            }
            this.camera.shadowMapStrength = 0;
         }
         if(settings.defferedLighting && this.camera.directionalLightStrength != 1)
         {
            this.camera.directionalLight.intensity = 1;
            this.camera.directionalLightStrength = 1;
            this.camera.deferredLighting = true;
            this.camera.deferredLightingStrength = 1;
         }
         else if(!settings.defferedLighting)
         {
            this.camera.directionalLight.intensity = 0;
            this.camera.directionalLightStrength = 0;
            this.camera.deferredLighting = false;
            this.camera.deferredLightingStrength = 0;
         }
         if(IStorageService(Main.osgi.getService(IStorageService)).getStorage().data["use_ssao"] != null)
         {
            this.camera.ssao = IStorageService(Main.osgi.getService(IStorageService)).getStorage().data["use_ssao"];
         }
         else
         {
            this.camera.ssao = false;
         }
      }
      
      public function applyColorchangesToSkybox(skybox:BitmapData) : BitmapData
      {
         var btm:BitmapData = new BitmapData(1,1,false,1382169 + 7559484);
         skybox.colorTransform(skybox.rect,new Bitmap(btm).transform.colorTransform);
         return skybox;
      }
   }
}
