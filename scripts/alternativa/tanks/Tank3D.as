package alternativa.tanks
{
   import alternativa.engine3d.containers.ConflictContainer;
   import alternativa.engine3d.core.Face;
   import alternativa.engine3d.core.MipMapping;
   import alternativa.engine3d.core.Shadow;
   import alternativa.engine3d.core.Vertex;
   import alternativa.engine3d.materials.Material;
   import alternativa.engine3d.materials.TextureMaterial;
   import alternativa.engine3d.objects.Mesh;
   import alternativa.tanks.materials.AnimatedPaintMaterial;
   import alternativa.tanks.vehicles.tanks.TrackSkin;
   import flash.display.BitmapData;
   import flash.display.BlendMode;
   import flash.display.Shape;
   import scpacker.resource.images.ImageResource;
   import scpacker.resource.images.MultiframeResourceData;
   
   public class Tank3D extends ConflictContainer
   {
      
      private static var defaultColormap:BitmapData;
       
      
      private var hull:Tank3DPart;
      
      private var turret:Tank3DPart;
      
      private var colormap:BitmapData;
      
      private var animatedColormap:Boolean;
      
      private var multiframeData:MultiframeResourceData;
      
      private var leftTrackSkin:TrackSkin;
      
      private var rightTrackSkin:TrackSkin;
      
      public var shadow:Shadow;
      
      public function Tank3D(hull:Tank3DPart, turret:Tank3DPart, colormap:ImageResource)
      {
         super();
         resolveByAABB = true;
         this.setHull(hull);
         this.setTurret(turret);
         this.setColorMap(colormap);
         this.shadow = new Shadow(128,6,100,5000,10000,516,1);
         this.shadow.offset = 100;
         this.shadow.backFadeRange = 100;
      }
      
      private function getDefaultColormap() : BitmapData
      {
         if(defaultColormap == null)
         {
            defaultColormap = new BitmapData(1,1,false,6710886);
         }
         return defaultColormap;
      }
      
      public function setColorMap(colormap:ImageResource) : void
      {
         this.colormap = colormap != null ? colormap.bitmapData as BitmapData : this.getDefaultColormap();
         if(this.hull != null)
         {
            this.hull.animatedPaint = colormap != null ? Boolean(Boolean(colormap.animatedMaterial)) : Boolean(Boolean(false));
         }
         if(this.turret != null)
         {
            this.turret.animatedPaint = colormap != null ? Boolean(Boolean(colormap.animatedMaterial)) : Boolean(Boolean(false));
         }
         this.animatedColormap = colormap != null ? Boolean(Boolean(colormap.animatedMaterial)) : Boolean(Boolean(false));
         this.multiframeData = colormap != null ? colormap.multiframeData : null;
         this.updatePartTexture(this.hull);
         this.updatePartTexture(this.turret);
      }
      
      public function setHull(value:Tank3DPart) : void
      {
         if(this.hull != null)
         {
            removeChild(this.hull.mesh);
         }
         if(value == null)
         {
            return;
         }
         this.hull = value;
         addChild(this.hull.mesh);
         this.hull.mesh.x = 0;
         this.hull.mesh.y = 0;
         this.hull.mesh.z = 0;
         this.updatePartTexture(this.hull);
         this.updateMountPoint();
         this.shadow.addCaster(this.hull.mesh);
      }
      
      public function setTurret(value:Tank3DPart) : void
      {
         if(this.turret != null)
         {
            removeChild(this.turret.mesh);
         }
         if(value == null)
         {
            return;
         }
         this.turret = value;
         addChild(this.turret.mesh);
         this.updatePartTexture(this.turret);
         this.updateMountPoint();
         this.shadow.addCaster(this.turret.mesh);
      }
      
      private function updatePartTexture(part:Tank3DPart) : void
      {
         var material:Material = null;
         if(part == null || this.colormap == null)
         {
            return;
         }
         var shape:Shape = new Shape();
         shape.graphics.beginBitmapFill(this.colormap);
         shape.graphics.drawRect(0,0,part.lightmap.width,part.lightmap.height);
         var texture:BitmapData = new BitmapData(part.lightmap.width,part.lightmap.height,false,0);
         texture.draw(shape);
         texture.draw(part.lightmap,null,null,BlendMode.HARDLIGHT);
         texture.draw(part.details);
         if(this.animatedColormap)
         {
            material = new AnimatedPaintMaterial(this.colormap,part.lightmap,part.details,this.colormap.width / this.multiframeData.widthFrame,this.colormap.height / this.multiframeData.heigthFrame,this.multiframeData.fps,this.multiframeData.numFrames,1);
         }
         else
         {
            material = new TextureMaterial(texture,false,true,MipMapping.PER_PIXEL,part.mesh.calculateResolution(texture.width,texture.height));
         }
         this.createTrackSkins(part.mesh,material);
         part.mesh.setMaterialToAllFaces(material);
      }
      
      public function createTrackSkins(param1:Mesh, material:Material) : void
      {
         var _loc2_:Face = null;
         this.leftTrackSkin = new TrackSkin();
         this.rightTrackSkin = new TrackSkin();
         for each(_loc2_ in param1.faces)
         {
            if(_loc2_.id == "track" || _loc2_.material.name == "track")
            {
               this.addFaceToTrackSkin(_loc2_);
            }
         }
         this.leftTrackSkin.init();
         this.rightTrackSkin.init();
         this.leftTrackSkin.setMaterial(material.clone());
         this.rightTrackSkin.setMaterial(material.clone());
      }
      
      private function addFaceToTrackSkin(param1:Face) : void
      {
         var _loc2_:Vertex = param1.vertices[0];
         if(_loc2_.x < 0)
         {
            this.leftTrackSkin.addFace(param1);
         }
         else
         {
            this.rightTrackSkin.addFace(param1);
         }
      }
      
      private function updateMountPoint() : void
      {
         if(this.hull == null || this.turret == null)
         {
            return;
         }
         this.turret.mesh.x = this.hull.turretMountPoint.x;
         this.turret.mesh.y = this.hull.turretMountPoint.y;
         this.turret.mesh.z = this.hull.turretMountPoint.z;
      }
   }
}
