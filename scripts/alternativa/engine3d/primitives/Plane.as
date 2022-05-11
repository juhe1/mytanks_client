package alternativa.engine3d.primitives
{
   import alternativa.engine3d.alternativa3d;
   import alternativa.engine3d.core.Face;
   import alternativa.engine3d.core.Object3D;
   import alternativa.engine3d.core.Vertex;
   import alternativa.engine3d.core.Wrapper;
   import alternativa.engine3d.materials.Material;
   import alternativa.engine3d.objects.Mesh;
   
   use namespace alternativa3d;
   
   public class Plane extends Mesh
   {
       
      
      public function Plane(param1:Number = 100, param2:Number = 100, param3:uint = 1, param4:uint = 1, param5:Boolean = true, param6:Boolean = false, param7:Boolean = false, param8:Material = null, param9:Material = null)
      {
         var _loc16_:Number = NaN;
         var _loc10_:int = 0;
         var _loc11_:int = 0;
         super();
         if(param3 < 1)
         {
            throw new ArgumentError(param3 + " width segments not enough.");
         }
         if(param4 < 1)
         {
            throw new ArgumentError(param4 + " length segments not enough.");
         }
         var _loc13_:int = param3 + 1;
         var _loc14_:int = param4 + 1;
         var _loc15_:Number = param1 * 0.5;
         _loc16_ = param2 * 0.5;
         var _loc17_:Number = 1 / param3;
         var _loc18_:Number = 1 / param4;
         var _loc19_:Number = param1 / param3;
         var _loc20_:Number = param2 / param4;
         var _loc21_:Vector.<Vertex> = new Vector.<Vertex>();
         var _loc22_:int = 0;
         _loc10_ = 0;
         while(_loc10_ < _loc13_)
         {
            _loc11_ = 0;
            while(_loc11_ < _loc14_)
            {
               var _loc23_:* = _loc22_++;
               _loc21_[_loc23_] = this.createVertex(_loc10_ * _loc19_ - _loc15_,_loc11_ * _loc20_ - _loc16_,0,_loc10_ * _loc17_,(param4 - _loc11_) * _loc18_);
               _loc11_++;
            }
            _loc10_++;
         }
         _loc10_ = 0;
         while(_loc10_ < _loc13_)
         {
            _loc11_ = 0;
            while(_loc11_ < _loc14_)
            {
               if(_loc10_ < param3 && _loc11_ < param4)
               {
                  this.createFace(_loc21_[_loc10_ * _loc14_ + _loc11_],_loc21_[(_loc10_ + 1) * _loc14_ + _loc11_],_loc21_[(_loc10_ + 1) * _loc14_ + _loc11_ + 1],_loc21_[_loc10_ * _loc14_ + _loc11_ + 1],0,0,1,0,param6,param7,param9);
               }
               _loc11_++;
            }
            _loc10_++;
         }
         if(param5)
         {
            _loc22_ = 0;
            _loc10_ = 0;
            while(_loc10_ < _loc13_)
            {
               _loc11_ = 0;
               while(_loc11_ < _loc14_)
               {
                  _loc23_ = _loc22_++;
                  _loc21_[_loc23_] = this.createVertex(_loc10_ * _loc19_ - _loc15_,_loc11_ * _loc20_ - _loc16_,0,(param3 - _loc10_) * _loc17_,(param4 - _loc11_) * _loc18_);
                  _loc11_++;
               }
               _loc10_++;
            }
            _loc10_ = 0;
            while(_loc10_ < _loc13_)
            {
               _loc11_ = 0;
               while(_loc11_ < _loc14_)
               {
                  if(_loc10_ < param3 && _loc11_ < param4)
                  {
                     this.createFace(_loc21_[(_loc10_ + 1) * _loc14_ + _loc11_ + 1],_loc21_[(_loc10_ + 1) * _loc14_ + _loc11_],_loc21_[_loc10_ * _loc14_ + _loc11_],_loc21_[_loc10_ * _loc14_ + _loc11_ + 1],0,0,-1,0,param6,param7,param8);
                  }
                  _loc11_++;
               }
               _loc10_++;
            }
         }
         boundMinX = -_loc15_;
         boundMinY = -_loc16_;
         boundMinZ = 0;
         boundMaxX = _loc15_;
         boundMaxY = _loc16_;
         boundMaxZ = 0;
      }
      
      private function createVertex(param1:Number, param2:Number, param3:Number, param4:Number, param5:Number) : Vertex
      {
         var _loc6_:Vertex = new Vertex();
         _loc6_.x = param1;
         _loc6_.y = param2;
         _loc6_.z = param3;
         _loc6_.u = param4;
         _loc6_.v = param5;
         _loc6_.next = vertexList;
         vertexList = _loc6_;
         return _loc6_;
      }
      
      private function createFace(param1:Vertex, param2:Vertex, param3:Vertex, param4:Vertex, param5:Number, param6:Number, param7:Number, param8:Number, param9:Boolean, param10:Boolean, param11:Material) : void
      {
         var _loc12_:Vertex = null;
         var _loc13_:Face = null;
         if(param9)
         {
            param5 = -param5;
            param6 = -param6;
            param7 = -param7;
            param8 = -param8;
            _loc12_ = param1;
            param1 = param4;
            param4 = _loc12_;
            _loc12_ = param2;
            param2 = param3;
            param3 = _loc12_;
         }
         if(param10)
         {
            _loc13_ = new Face();
            _loc13_.material = param11;
            _loc13_.wrapper = new Wrapper();
            _loc13_.wrapper.vertex = param1;
            _loc13_.wrapper.next = new Wrapper();
            _loc13_.wrapper.next.vertex = param2;
            _loc13_.wrapper.next.next = new Wrapper();
            _loc13_.wrapper.next.next.vertex = param3;
            _loc13_.normalX = param5;
            _loc13_.normalY = param6;
            _loc13_.normalZ = param7;
            _loc13_.offset = param8;
            _loc13_.next = faceList;
            faceList = _loc13_;
            _loc13_ = new Face();
            _loc13_.material = param11;
            _loc13_.wrapper = new Wrapper();
            _loc13_.wrapper.vertex = param1;
            _loc13_.wrapper.next = new Wrapper();
            _loc13_.wrapper.next.vertex = param3;
            _loc13_.wrapper.next.next = new Wrapper();
            _loc13_.wrapper.next.next.vertex = param4;
            _loc13_.normalX = param5;
            _loc13_.normalY = param6;
            _loc13_.normalZ = param7;
            _loc13_.offset = param8;
            _loc13_.next = faceList;
            faceList = _loc13_;
         }
         else
         {
            _loc13_ = new Face();
            _loc13_.material = param11;
            _loc13_.wrapper = new Wrapper();
            _loc13_.wrapper.vertex = param1;
            _loc13_.wrapper.next = new Wrapper();
            _loc13_.wrapper.next.vertex = param2;
            _loc13_.wrapper.next.next = new Wrapper();
            _loc13_.wrapper.next.next.vertex = param3;
            _loc13_.wrapper.next.next.next = new Wrapper();
            _loc13_.wrapper.next.next.next.vertex = param4;
            _loc13_.normalX = param5;
            _loc13_.normalY = param6;
            _loc13_.normalZ = param7;
            _loc13_.offset = param8;
            _loc13_.next = faceList;
            faceList = _loc13_;
         }
      }
      
      override public function clone() : Object3D
      {
         var _loc1_:Plane = new Plane();
         _loc1_.clonePropertiesFrom(this);
         return _loc1_;
      }
   }
}
