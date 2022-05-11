package alternativa.tanks.models.effects.common.bonuscommon
{
   import alternativa.engine3d.objects.Mesh;
   import alternativa.init.Main;
   import alternativa.model.IModel;
   import alternativa.model.IObjectLoadListener;
   import alternativa.object.ClientObject;
   import alternativa.resource.StubBitmapData;
   import alternativa.service.IResourceService;
   import alternativa.tanks.bonuses.IBonus;
   import alternativa.tanks.engine3d.MaterialType;
   import alternativa.tanks.models.battlefield.BattlefieldModel;
   import alternativa.tanks.models.battlefield.IBattleField;
   import alternativa.tanks.models.effects.common.IBonusCommonModel;
   import alternativa.tanks.services.materialregistry.IMaterialRegistry;
   import com.alternativaplatform.projects.tanks.client.warfare.models.common.bonuscommon.BonusCommonModelBase;
   import com.alternativaplatform.projects.tanks.client.warfare.models.common.bonuscommon.IBonusCommonModelBase;
   import flash.display.BitmapData;
   import scpacker.resource.ResourceType;
   import scpacker.resource.ResourceUtil;
   import scpacker.resource.images.ImageResource;
   
   public class BonusCommonModel extends BonusCommonModelBase implements IBonusCommonModelBase, IBonusCommonModel, IObjectLoadListener
   {
      
      private static const MIPMAP_RESOLUTION:Number = 4;
      
      private static var materialRegistry:IMaterialRegistry;
       
      
      public function BonusCommonModel()
      {
         super();
         _interfaces.push(IModel,IBonusCommonModelBase,IBonusCommonModel,IObjectLoadListener);
         materialRegistry = IMaterialRegistry(Main.osgi.getService(IMaterialRegistry));
      }
      
      public function initObject(clientObject:ClientObject, boxResourceId:String, cordResourceId:String, disappearingTime:int, parachuteInnerResourceId:String, parachuteResourceId:String) : void
      {
         if(clientObject.getParams(BonusCommonModel) != null)
         {
            return;
         }
         var resourceService:IResourceService = Main.osgi.getService(IResourceService) as IResourceService;
         var bonusData:BonusCommonData = new BonusCommonData();
         bonusData.boxMesh = this.getMeshFromResource(resourceService,boxResourceId);
         bonusData.parachuteMesh = this.getMeshFromResource(resourceService,parachuteResourceId,true);
         bonusData.parachuteInnerMesh = this.getMeshFromResource(resourceService,parachuteInnerResourceId);
         bonusData.cordMaterial = materialRegistry.textureMaterialRegistry.getMaterial(MaterialType.EFFECT,ResourceUtil.getResource(ResourceType.IMAGE,cordResourceId).bitmapData as BitmapData,MIPMAP_RESOLUTION);
         bonusData.duration = disappearingTime * 1000;
         clientObject.putParams(BonusCommonModel,bonusData);
      }
      
      public function objectLoaded(object:ClientObject) : void
      {
      }
      
      public function objectUnloaded(object:ClientObject) : void
      {
         var data:BonusCommonData = BonusCommonData(object.getParams(BonusCommonModel));
         ParaBonus.deletePool(data);
      }
      
      public function getBonus(clientObject:ClientObject, bonusId:String, livingTime:int, isFalling:Boolean) : IBonus
      {
         var data:BonusCommonData = BonusCommonData(clientObject.getParams(BonusCommonModel));
         var bonus:ParaBonus = ParaBonus.create(data);
         bonus.init(bonusId,data.duration - livingTime,isFalling);
         return bonus;
      }
      
      private function getMeshFromResource(resourceService:IResourceService, resourceId:String, blacklisted:Boolean = false) : Mesh
      {
         var material:* = undefined;
         var bfModel:BattlefieldModel = null;
         var refMesh:Mesh = ResourceUtil.getResource(ResourceType.MODEL,resourceId).mesh as Mesh;
         if(ResourceUtil.getResource(ResourceType.IMAGE,resourceId) == null)
         {
            trace(resourceId);
            return null;
         }
         var texture:BitmapData = ResourceUtil.getResource(ResourceType.IMAGE,resourceId).bitmapData as BitmapData;
         if(texture == null)
         {
            texture = new StubBitmapData(65280);
         }
         var res:ImageResource = ResourceUtil.getResource(ResourceType.IMAGE,resourceId) as ImageResource;
         if(res.multiframeData != null)
         {
            material = materialRegistry.textureMaterialRegistry.getAnimatedPaint(res,ResourceUtil.getResource(ResourceType.IMAGE,"bonus_box_lightmap").bitmapData,ResourceUtil.getResource(ResourceType.IMAGE,"bonus_box_details").bitmapData,"bonus_box_details");
         }
         else
         {
            material = materialRegistry.textureMaterialRegistry.getMaterial(MaterialType.EFFECT,texture,MIPMAP_RESOLUTION);
         }
         if(blacklisted)
         {
            bfModel = BattlefieldModel(Main.osgi.getService(IBattleField));
            if(bfModel.blacklist.indexOf(material.getTextureResource()) == -1)
            {
               bfModel.blacklist.push(material.getTextureResource());
            }
         }
         var mesh:Mesh = Mesh(refMesh.clone());
         mesh.setMaterialToAllFaces(material);
         return mesh;
      }
   }
}
