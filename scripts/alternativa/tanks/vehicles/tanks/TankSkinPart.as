package alternativa.tanks.vehicles.tanks
{
   import alternativa.engine3d.core.Sorting;
   import alternativa.engine3d.objects.Mesh;
   import alternativa.types.Long;
   import flash.display.BitmapData;
   import flash.display.BlendMode;
   import flash.display.IBitmapDrawable;
   import flash.display.Shape;
   
   public class TankSkinPart
   {
       
      
      public var partId:Long;
      
      public var details:BitmapData;
      
      public var lightmap:BitmapData;
      
      public var detailsHull:BitmapData;
      
      public var lightmapHull:BitmapData;
      
      public var mesh:Mesh;
      
      public var resolution:Number;
      
      public function TankSkinPart(mmesh:Mesh, isHull:Boolean = false)
      {
         super();
         this.details = new BitmapData(100,100);
         this.lightmap = new BitmapData(100,100);
         this.detailsHull = new BitmapData(100,100);
         this.lightmapHull = new BitmapData(100,100);
         this.mesh = mmesh;
         this.initMesh();
      }
      
      public function createTexture(colormap:BitmapData, isHull:Boolean = false) : BitmapData
      {
         var texture:BitmapData = new BitmapData(!!isHull ? int(int(this.lightmapHull.width)) : int(int(this.lightmap.width)),!!isHull ? int(int(this.lightmapHull.height)) : int(int(this.lightmap.height)),false,0);
         var shape:Shape = new Shape();
         shape.graphics.beginBitmapFill(colormap);
         shape.graphics.drawRect(0,0,!!isHull ? Number(Number(this.lightmapHull.width)) : Number(Number(this.lightmap.width)),!!isHull ? Number(Number(this.lightmapHull.height)) : Number(Number(this.lightmap.height)));
         texture.draw(shape);
         texture.draw(!!isHull ? this.lightmapHull : this.lightmap,null,null,BlendMode.HARDLIGHT);
         texture.draw(!!isHull ? this.detailsHull : this.details);
         return texture;
      }
      
      protected function getMesh() : Mesh
      {
         throw new Error("Not implemented");
      }
      
      private function initMesh() : void
      {
         if(this.mesh.sorting == Sorting.DYNAMIC_BSP)
         {
            return;
         }
         this.mesh.sorting = Sorting.DYNAMIC_BSP;
         this.mesh.calculateFacesNormals(true);
         this.mesh.optimizeForDynamicBSP();
         this.mesh.threshold = 0.01;
         this.resolution = this.mesh.calculateResolution(this.details.width,this.details.height);
      }
   }
}
