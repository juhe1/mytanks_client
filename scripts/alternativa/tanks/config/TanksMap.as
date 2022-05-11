package alternativa.tanks.config
{
   import alternativa.engine3d.containers.KDContainer;
   import alternativa.engine3d.core.Object3D;
   import alternativa.engine3d.objects.Occluder;
   import alternativa.engine3d.objects.Sprite3D;
   import alternativa.init.Main;
   import alternativa.physics.collision.CollisionPrimitive;
   import alternativa.tanks.config.loaders.MapLoader;
   import alternativa.tanks.models.battlefield.BattlefieldModel;
   import alternativa.tanks.models.battlefield.IBattleField;
   import alternativa.tanks.models.battlefield.hidableobjects.HidableObject3DWrapper;
   import flash.events.Event;
   import specter.utils.Logger;
   
   public class TanksMap extends ResourceLoader
   {
       
      
      public var mapContainer:KDContainer;
      
      private var loader:MapLoader;
      
      private var spawnMarkers:Object;
      
      private var ctfFlags:Object;
      
      public var mapId:String;
      
      public function TanksMap(config:Config, idMap:String)
      {
         this.spawnMarkers = {};
         this.ctfFlags = {};
         this.mapId = idMap;
         super("Tank map loader",config);
      }
      
      override public function run() : void
      {
         this.loader = new MapLoader();
         this.loader.addEventListener(Event.COMPLETE,this.onLoadingComplete);
         this.loader.load("maps/" + this.mapId + ".xml",config.propLibRegistry);
      }
      
      public function get collisionPrimitives() : Vector.<CollisionPrimitive>
      {
         return this.loader.collisionPrimitives;
      }
      
      private function onLoadingComplete(e:Event) : void
      {
         var sprite:Sprite3D = null;
         this.mapContainer = this.createKDContainer(this.loader.objects,this.loader.occluders);
         this.mapContainer.threshold = 0.1;
         this.mapContainer.ignoreChildrenInCollider = true;
         this.mapContainer.calculateBounds();
         var bfModel:BattlefieldModel = BattlefieldModel(Main.osgi.getService(IBattleField));
         this.mapContainer.name = "Visual Kd-tree";
         for each(sprite in this.loader.sprites)
         {
            this.mapContainer.addChild(sprite);
            bfModel.hidableObjects.add(new HidableObject3DWrapper(sprite));
         }
         bfModel.build(this.mapContainer,this.collisionPrimitives,this.loader.lights);
         completeTask();
         Logger.log("Loaded map");
      }
      
      private function createKDContainer(objects:Vector.<Object3D>, occluders:Vector.<Occluder>) : KDContainer
      {
         var container:KDContainer = new KDContainer();
         container.createTree(objects,occluders);
         return container;
      }
      
      public function destroy() : *
      {
         this.loader.destroy();
         this.loader = null;
         this.mapContainer.destroyTree();
         this.mapContainer.destroy();
         this.mapContainer = null;
      }
   }
}

import alternativa.engine3d.core.Object3D;

class SpawnMarkersData
{
    
   
   public var markers:Vector.<Object3D>;
   
   function SpawnMarkersData()
   {
      super();
   }
}
