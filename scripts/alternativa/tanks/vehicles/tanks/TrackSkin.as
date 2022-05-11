package alternativa.tanks.vehicles.tanks
{
   import alternativa.engine3d.core.Face;
   import alternativa.engine3d.core.Vertex;
   import alternativa.engine3d.materials.Material;
   import alternativa.engine3d.materials.UVMatrixProvider;
   import alternativa.tanks.materials.TrackMaterial;
   import flash.geom.Matrix;
   import flash.utils.Dictionary;
   
   public class TrackSkin
   {
       
      
      private var uvsProvider:UVMatrixProvider;
      
      private var faces:Vector.<Face>;
      
      private var vertices:Vector.<Vertex>;
      
      private var ratio:Number;
      
      private var distance:Number = 0;
      
      public var material:TrackMaterial;
      
      public function TrackSkin()
      {
         this.faces = new Vector.<Face>();
         super();
      }
      
      private static function getRatio(param1:Face) : Number
      {
         var _vertices:Vector.<Vertex> = param1.vertices;
         return getRatioForVertices(_vertices[0],_vertices[1]);
      }
      
      private static function getRatioForVertices(vertex1:Vertex, vertex2:Vertex) : Number
      {
         var dx:Number = vertex1.x - vertex2.x;
         var dy:Number = vertex1.y - vertex2.y;
         var dz:Number = vertex1.z - vertex2.z;
         var vertexDistanceXYZ:Number = Math.sqrt(dx * dx + dy * dy + dz * dz);
         var du:Number = vertex1.u - vertex2.u;
         var dv:Number = vertex1.v - vertex2.v;
         var vertexDistanceUV:Number = Math.sqrt(du * du + dv * dv);
         return vertexDistanceUV / vertexDistanceXYZ;
      }
      
      public function addFace(_face:Face) : void
      {
         this.faces.push(_face);
      }
      
      public function init() : void
      {
         var polygon:Face = null;
         var newVertex:* = undefined;
         var vertex:Vertex = null;
         var co:Number = 0;
         var dictionary:Dictionary = new Dictionary();
         for each(polygon in this.faces)
         {
            for each(vertex in polygon.vertices)
            {
               dictionary[vertex] = true;
            }
            co += getRatio(polygon);
         }
         this.ratio = co / this.faces.length;
         this.vertices = new Vector.<Vertex>();
         for(newVertex in dictionary)
         {
            this.vertices.push(newVertex);
         }
      }
      
      public function move(delta:Number) : void
      {
         var m:Matrix = null;
         this.distance += delta * this.ratio;
         if(this.uvsProvider != null)
         {
            m = this.uvsProvider.getMatrix();
            m.tx = this.distance;
         }
      }
      
      public function setMaterial(newMaterial:Material) : void
      {
         newMaterial.name = "track";
         var face:Face = null;
         var trackMat:TrackMaterial = null;
         for each(face in this.faces)
         {
            face.material = newMaterial;
         }
         if(newMaterial is TrackMaterial)
         {
            this.material = newMaterial as TrackMaterial;
            trackMat = newMaterial as TrackMaterial;
            this.uvsProvider = trackMat.uvMatrixProvider;
         }
      }
      
      public function destroy() : *
      {
         var f:Face = null;
         var v:Vertex = null;
         if(this.faces != null)
         {
            for each(f in this.faces)
            {
               f.destroy();
               f = null;
            }
            this.faces = null;
         }
         if(this.vertices != null)
         {
            for each(v in this.vertices)
            {
               v = null;
            }
            this.vertices = null;
         }
      }
   }
}
