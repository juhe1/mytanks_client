package alternativa.tanks.models.battlefield.gamemode
{
   import alternativa.engine3d.core.ShadowMap;
   import alternativa.engine3d.lights.DirectionalLight;
   import alternativa.init.Main;
   import alternativa.math.Matrix3;
   import alternativa.math.Vector3;
   import alternativa.osgi.service.storage.IStorageService;
   import alternativa.tanks.camera.GameCamera;
   import alternativa.tanks.model.panel.IBattleSettings;
   import alternativa.tanks.models.battlefield.BattleView3D;
   import flash.display.BitmapData;
   import flash.geom.Vector3D;
   
   public class HalloweenGameMode implements IGameMode
   {
       
      
      private var camera:GameCamera;
      
      public function HalloweenGameMode()
      {
         super();
      }
      
      public function applyChanges(viewport:BattleView3D) : void
      {
         var camera:GameCamera = viewport.camera;
         this.camera = camera;
         camera.directionalLight = new DirectionalLight(1315346);
         var direction:Vector3D = new Vector3D(1,1,1);
         var matrix:Matrix3 = new Matrix3();
         matrix.setRotationMatrix(-2.6,0.16,-2.8);
         var vector:Vector3 = new Vector3(0,1,0);
         vector.vTransformBy3(matrix);
         direction.x = vector.x;
         direction.y = vector.y;
         direction.z = vector.z;
         camera.directionalLight.lookAt(direction.x,direction.y,direction.z);
         camera.ambientColor = 602185;
         camera.shadowMap = new ShadowMap(2048,7500,15000,1,10000);
         camera.directionalLightStrength = 1;
         camera.shadowMapStrength = 1.5;
         camera.shadowMap.bias = 1;
         camera.useShadowMap = true;
         camera.deferredLighting = true;
         camera.fogColor = 8880256;
         camera.fogNear = 5000;
         camera.fogFar = 10000;
         camera.fogAlpha = 0.25;
         camera.ssao = true;
         camera.ssaoRadius = Number(400);
         camera.ssaoRange = Number(450);
         camera.ssaoColor = 2636880;
         camera.ssaoAlpha = Number(1.5);
      }
      
      public function applyChangesBeforeSettings(settings:IBattleSettings) : void
      {
         if(settings.fog && this.camera.fogStrength != 1)
         {
            this.camera.fogStrength = 1;
            this.camera.fogColor = 8880256;
            this.camera.fogNear = 5000;
            this.camera.fogFar = 10000;
            this.camera.fogAlpha = 0.25;
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
         return skybox;
      }
   }
}
