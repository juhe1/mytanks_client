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
   
   public class Box extends Mesh
   {
       
      
      public function Box(param1:Number = 100, param2:Number = 100, param3:Number = 100, param4:uint = 1, param5:uint = 1, param6:uint = 1, param7:Boolean = false, param8:Boolean = false, param9:Material = null, param10:Material = null, param11:Material = null, param12:Material = null, param13:Material = null, param14:Material = null)
      {
         var _loc21_:Number = NaN;
         var _loc15_:int = 0;
         var _loc16_:int = 0;
         var _loc17_:int = 0;
         super();
         if(param4 < 1)
         {
            throw new ArgumentError(param4 + " width segments not enough.");
         }
         if(param5 < 1)
         {
            throw new ArgumentError(param5 + " length segments not enough.");
         }
         if(param6 < 1)
         {
            throw new ArgumentError(param6 + " height segments not enough.");
         }
         var _loc18_:int = param4 + 1;
         var _loc19_:int = param5 + 1;
         var _loc20_:int = param6 + 1;
         _loc21_ = param1 * 0.5;
         var _loc22_:Number = param2 * 0.5;
         var _loc23_:Number = param3 * 0.5;
         var _loc24_:Number = 1 / param4;
         var _loc25_:Number = 1 / param5;
         var _loc26_:Number = 1 / param6;
         var _loc27_:Number = param1 / param4;
         var _loc28_:Number = param2 / param5;
         var _loc29_:Number = param3 / param6;
         var _loc30_:Vector.<Vertex> = new Vector.<Vertex>();
         var _loc31_:int = 0;
         _loc15_ = 0;
         while(_loc15_ < _loc18_)
         {
            _loc16_ = 0;
            while(_loc16_ < _loc19_)
            {
               var _loc33_:* = _loc31_++;
               _loc30_[_loc33_] = this.createVertex(_loc15_ * _loc27_ - _loc21_,_loc16_ * _loc28_ - _loc22_,-_loc23_,(param4 - _loc15_) * _loc24_,(param5 - _loc16_) * _loc25_);
               _loc16_++;
            }
            _loc15_++;
         }
         _loc15_ = 0;
         while(_loc15_ < _loc18_)
         {
            _loc16_ = 0;
            while(_loc16_ < _loc19_)
            {
               if(_loc15_ < param4 && _loc16_ < param5)
               {
                  this.createFace(_loc30_[(_loc15_ + 1) * _loc19_ + _loc16_ + 1],_loc30_[(_loc15_ + 1) * _loc19_ + _loc16_],_loc30_[_loc15_ * _loc19_ + _loc16_],_loc30_[_loc15_ * _loc19_ + _loc16_ + 1],0,0,-1,_loc23_,param7,param8,param13);
               }
               _loc16_++;
            }
            _loc15_++;
         }
         var _loc32_:uint = _loc18_ * _loc19_;
         _loc15_ = 0;
         while(_loc15_ < _loc18_)
         {
            _loc16_ = 0;
            while(_loc16_ < _loc19_)
            {
               _loc33_ = _loc31_++;
               _loc30_[_loc33_] = this.createVertex(_loc15_ * _loc27_ - _loc21_,_loc16_ * _loc28_ - _loc22_,_loc23_,_loc15_ * _loc24_,(param5 - _loc16_) * _loc25_);
               _loc16_++;
            }
            _loc15_++;
         }
         _loc15_ = 0;
         while(_loc15_ < _loc18_)
         {
            _loc16_ = 0;
            while(_loc16_ < _loc19_)
            {
               if(_loc15_ < param4 && _loc16_ < param5)
               {
                  this.createFace(_loc30_[_loc32_ + _loc15_ * _loc19_ + _loc16_],_loc30_[_loc32_ + (_loc15_ + 1) * _loc19_ + _loc16_],_loc30_[_loc32_ + (_loc15_ + 1) * _loc19_ + _loc16_ + 1],_loc30_[_loc32_ + _loc15_ * _loc19_ + _loc16_ + 1],0,0,1,_loc23_,param7,param8,param14);
               }
               _loc16_++;
            }
            _loc15_++;
         }
         _loc32_ += _loc18_ * _loc19_;
         _loc15_ = 0;
         while(_loc15_ < _loc18_)
         {
            _loc17_ = 0;
            while(_loc17_ < _loc20_)
            {
               _loc33_ = _loc31_++;
               _loc30_[_loc33_] = this.createVertex(_loc15_ * _loc27_ - _loc21_,-_loc22_,_loc17_ * _loc29_ - _loc23_,_loc15_ * _loc24_,(param6 - _loc17_) * _loc26_);
               _loc17_++;
            }
            _loc15_++;
         }
         _loc15_ = 0;
         while(_loc15_ < _loc18_)
         {
            _loc17_ = 0;
            while(_loc17_ < _loc20_)
            {
               if(_loc15_ < param4 && _loc17_ < param6)
               {
                  this.createFace(_loc30_[_loc32_ + _loc15_ * _loc20_ + _loc17_],_loc30_[_loc32_ + (_loc15_ + 1) * _loc20_ + _loc17_],_loc30_[_loc32_ + (_loc15_ + 1) * _loc20_ + _loc17_ + 1],_loc30_[_loc32_ + _loc15_ * _loc20_ + _loc17_ + 1],0,-1,0,_loc22_,param7,param8,param11);
               }
               _loc17_++;
            }
            _loc15_++;
         }
         _loc32_ += _loc18_ * _loc20_;
         _loc15_ = 0;
         while(_loc15_ < _loc18_)
         {
            _loc17_ = 0;
            while(_loc17_ < _loc20_)
            {
               _loc33_ = _loc31_++;
               _loc30_[_loc33_] = this.createVertex(_loc15_ * _loc27_ - _loc21_,_loc22_,_loc17_ * _loc29_ - _loc23_,(param4 - _loc15_) * _loc24_,(param6 - _loc17_) * _loc26_);
               _loc17_++;
            }
            _loc15_++;
         }
         _loc15_ = 0;
         while(_loc15_ < _loc18_)
         {
            _loc17_ = 0;
            while(_loc17_ < _loc20_)
            {
               if(_loc15_ < param4 && _loc17_ < param6)
               {
                  this.createFace(_loc30_[_loc32_ + _loc15_ * _loc20_ + _loc17_],_loc30_[_loc32_ + _loc15_ * _loc20_ + _loc17_ + 1],_loc30_[_loc32_ + (_loc15_ + 1) * _loc20_ + _loc17_ + 1],_loc30_[_loc32_ + (_loc15_ + 1) * _loc20_ + _loc17_],0,1,0,_loc22_,param7,param8,param12);
               }
               _loc17_++;
            }
            _loc15_++;
         }
         _loc32_ += _loc18_ * _loc20_;
         _loc16_ = 0;
         while(_loc16_ < _loc19_)
         {
            _loc17_ = 0;
            while(_loc17_ < _loc20_)
            {
               _loc33_ = _loc31_++;
               _loc30_[_loc33_] = this.createVertex(-_loc21_,_loc16_ * _loc28_ - _loc22_,_loc17_ * _loc29_ - _loc23_,(param5 - _loc16_) * _loc25_,(param6 - _loc17_) * _loc26_);
               _loc17_++;
            }
            _loc16_++;
         }
         _loc16_ = 0;
         while(_loc16_ < _loc19_)
         {
            _loc17_ = 0;
            while(_loc17_ < _loc20_)
            {
               if(_loc16_ < param5 && _loc17_ < param6)
               {
                  this.createFace(_loc30_[_loc32_ + _loc16_ * _loc20_ + _loc17_],_loc30_[_loc32_ + _loc16_ * _loc20_ + _loc17_ + 1],_loc30_[_loc32_ + (_loc16_ + 1) * _loc20_ + _loc17_ + 1],_loc30_[_loc32_ + (_loc16_ + 1) * _loc20_ + _loc17_],-1,0,0,_loc21_,param7,param8,param9);
               }
               _loc17_++;
            }
            _loc16_++;
         }
         _loc32_ += _loc19_ * _loc20_;
         _loc16_ = 0;
         while(_loc16_ < _loc19_)
         {
            _loc17_ = 0;
            while(_loc17_ < _loc20_)
            {
               _loc33_ = _loc31_++;
               _loc30_[_loc33_] = this.createVertex(_loc21_,_loc16_ * _loc28_ - _loc22_,_loc17_ * _loc29_ - _loc23_,_loc16_ * _loc25_,(param6 - _loc17_) * _loc26_);
               _loc17_++;
            }
            _loc16_++;
         }
         _loc16_ = 0;
         while(_loc16_ < _loc19_)
         {
            _loc17_ = 0;
            while(_loc17_ < _loc20_)
            {
               if(_loc16_ < param5 && _loc17_ < param6)
               {
                  this.createFace(_loc30_[_loc32_ + _loc16_ * _loc20_ + _loc17_],_loc30_[_loc32_ + (_loc16_ + 1) * _loc20_ + _loc17_],_loc30_[_loc32_ + (_loc16_ + 1) * _loc20_ + _loc17_ + 1],_loc30_[_loc32_ + _loc16_ * _loc20_ + _loc17_ + 1],1,0,0,_loc21_,param7,param8,param10);
               }
               _loc17_++;
            }
            _loc16_++;
         }
         boundMinX = -_loc21_;
         boundMinY = -_loc22_;
         boundMinZ = -_loc23_;
         boundMaxX = _loc21_;
         boundMaxY = _loc22_;
         boundMaxZ = _loc23_;
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
         var _loc1_:Box = new Box();
         _loc1_.clonePropertiesFrom(this);
         return _loc1_;
      }
   }
}
