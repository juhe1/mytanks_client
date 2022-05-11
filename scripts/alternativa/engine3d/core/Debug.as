package alternativa.engine3d.core
{
   import alternativa.engine3d.alternativa3d;
   import flash.display.Sprite;
   
   use namespace alternativa3d;
   
   public class Debug
   {
      
      public static const BOUNDS:int = 8;
      
      public static const EDGES:int = 16;
      
      public static const NODES:int = 128;
      
      public static const LIGHTS:int = 256;
      
      public static const BONES:int = 512;
      
      private static const boundVertexList:Vertex = Vertex.createList(8);
      
      private static const nodeVertexList:Vertex = Vertex.createList(4);
       
      
      public function Debug()
      {
         super();
      }
      
      alternativa3d static function drawEdges(param1:Camera3D, param2:Face, param3:int) : void
      {
         var _loc6_:Number = NaN;
         var _loc9_:Wrapper = null;
         var _loc10_:Vertex = null;
         var _loc11_:Number = NaN;
         var _loc12_:Number = NaN;
         var _loc4_:Number = param1.viewSizeX;
         var _loc5_:Number = param1.viewSizeY;
         var _loc7_:Sprite = param1.view.canvas;
         _loc7_.graphics.lineStyle(0,param3);
         var _loc8_:Face = param2;
         while(_loc8_ != null)
         {
            _loc9_ = _loc8_.wrapper;
            _loc10_ = _loc9_.vertex;
            _loc6_ = 1 / _loc10_.cameraZ;
            _loc11_ = _loc10_.cameraX * _loc4_ * _loc6_;
            _loc12_ = _loc10_.cameraY * _loc5_ * _loc6_;
            _loc7_.graphics.moveTo(_loc11_,_loc12_);
            _loc9_ = _loc9_.next;
            while(_loc9_ != null)
            {
               _loc10_ = _loc9_.vertex;
               _loc6_ = 1 / _loc10_.cameraZ;
               _loc7_.graphics.lineTo(_loc10_.cameraX * _loc4_ * _loc6_,_loc10_.cameraY * _loc5_ * _loc6_);
               _loc9_ = _loc9_.next;
            }
            _loc7_.graphics.lineTo(_loc11_,_loc12_);
            _loc8_ = _loc8_.processNext;
         }
      }
      
      alternativa3d static function drawBounds(param1:Camera3D, param2:Object3D, param3:Number, param4:Number, param5:Number, param6:Number, param7:Number, param8:Number, param9:int = -1, param10:Number = 1) : void
      {
         var _loc11_:Vertex = null;
         var _loc23_:Number = NaN;
         var _loc12_:Vertex = boundVertexList;
         _loc12_.x = param3;
         _loc12_.y = param4;
         _loc12_.z = param5;
         var _loc13_:Vertex = _loc12_.next;
         _loc13_.x = param6;
         _loc13_.y = param4;
         _loc13_.z = param5;
         var _loc14_:Vertex = _loc13_.next;
         _loc14_.x = param3;
         _loc14_.y = param7;
         _loc14_.z = param5;
         var _loc15_:Vertex = _loc14_.next;
         _loc15_.x = param6;
         _loc15_.y = param7;
         _loc15_.z = param5;
         var _loc16_:Vertex = _loc15_.next;
         _loc16_.x = param3;
         _loc16_.y = param4;
         _loc16_.z = param8;
         var _loc17_:Vertex = _loc16_.next;
         _loc17_.x = param6;
         _loc17_.y = param4;
         _loc17_.z = param8;
         var _loc18_:Vertex = _loc17_.next;
         _loc18_.x = param3;
         _loc18_.y = param7;
         _loc18_.z = param8;
         var _loc19_:Vertex = _loc18_.next;
         _loc19_.x = param6;
         _loc19_.y = param7;
         _loc19_.z = param8;
         _loc11_ = _loc12_;
         while(_loc11_ != null)
         {
            _loc11_.cameraX = param2.ma * _loc11_.x + param2.mb * _loc11_.y + param2.mc * _loc11_.z + param2.md;
            _loc11_.cameraY = param2.me * _loc11_.x + param2.mf * _loc11_.y + param2.mg * _loc11_.z + param2.mh;
            _loc11_.cameraZ = param2.mi * _loc11_.x + param2.mj * _loc11_.y + param2.mk * _loc11_.z + param2.ml;
            if(_loc11_.cameraZ <= 0)
            {
               return;
            }
            _loc11_ = _loc11_.next;
         }
         var _loc20_:Number = param1.viewSizeX;
         var _loc21_:Number = param1.viewSizeY;
         _loc11_ = _loc12_;
         while(_loc11_ != null)
         {
            _loc23_ = 1 / _loc11_.cameraZ;
            _loc11_.cameraX = _loc11_.cameraX * _loc20_ * _loc23_;
            _loc11_.cameraY = _loc11_.cameraY * _loc21_ * _loc23_;
            _loc11_ = _loc11_.next;
         }
         var _loc22_:Sprite = param1.view.canvas;
         _loc22_.graphics.lineStyle(0,param9 < 0 ? (param2.culling > 0 ? uint(uint(16776960)) : uint(uint(65280))) : uint(uint(param9)),param10);
         _loc22_.graphics.moveTo(_loc12_.cameraX,_loc12_.cameraY);
         _loc22_.graphics.lineTo(_loc13_.cameraX,_loc13_.cameraY);
         _loc22_.graphics.lineTo(_loc15_.cameraX,_loc15_.cameraY);
         _loc22_.graphics.lineTo(_loc14_.cameraX,_loc14_.cameraY);
         _loc22_.graphics.lineTo(_loc12_.cameraX,_loc12_.cameraY);
         _loc22_.graphics.moveTo(_loc16_.cameraX,_loc16_.cameraY);
         _loc22_.graphics.lineTo(_loc17_.cameraX,_loc17_.cameraY);
         _loc22_.graphics.lineTo(_loc19_.cameraX,_loc19_.cameraY);
         _loc22_.graphics.lineTo(_loc18_.cameraX,_loc18_.cameraY);
         _loc22_.graphics.lineTo(_loc16_.cameraX,_loc16_.cameraY);
         _loc22_.graphics.moveTo(_loc12_.cameraX,_loc12_.cameraY);
         _loc22_.graphics.lineTo(_loc16_.cameraX,_loc16_.cameraY);
         _loc22_.graphics.moveTo(_loc13_.cameraX,_loc13_.cameraY);
         _loc22_.graphics.lineTo(_loc17_.cameraX,_loc17_.cameraY);
         _loc22_.graphics.moveTo(_loc15_.cameraX,_loc15_.cameraY);
         _loc22_.graphics.lineTo(_loc19_.cameraX,_loc19_.cameraY);
         _loc22_.graphics.moveTo(_loc14_.cameraX,_loc14_.cameraY);
         _loc22_.graphics.lineTo(_loc18_.cameraX,_loc18_.cameraY);
      }
      
      alternativa3d static function drawKDNode(param1:Camera3D, param2:Object3D, param3:int, param4:Number, param5:Number, param6:Number, param7:Number, param8:Number, param9:Number, param10:Number, param11:Number) : void
      {
         var _loc12_:Vertex = null;
         var _loc20_:Number = NaN;
         var _loc13_:Vertex = nodeVertexList;
         var _loc14_:Vertex = _loc13_.next;
         var _loc15_:Vertex = _loc14_.next;
         var _loc16_:Vertex = _loc15_.next;
         if(param3 == 0)
         {
            _loc13_.x = param4;
            _loc13_.y = param6;
            _loc13_.z = param10;
            _loc14_.x = param4;
            _loc14_.y = param9;
            _loc14_.z = param10;
            _loc15_.x = param4;
            _loc15_.y = param9;
            _loc15_.z = param7;
            _loc16_.x = param4;
            _loc16_.y = param6;
            _loc16_.z = param7;
         }
         else if(param3 == 1)
         {
            _loc13_.x = param8;
            _loc13_.y = param4;
            _loc13_.z = param10;
            _loc14_.x = param5;
            _loc14_.y = param4;
            _loc14_.z = param10;
            _loc15_.x = param5;
            _loc15_.y = param4;
            _loc15_.z = param7;
            _loc16_.x = param8;
            _loc16_.y = param4;
            _loc16_.z = param7;
         }
         else
         {
            _loc13_.x = param5;
            _loc13_.y = param6;
            _loc13_.z = param4;
            _loc14_.x = param8;
            _loc14_.y = param6;
            _loc14_.z = param4;
            _loc15_.x = param8;
            _loc15_.y = param9;
            _loc15_.z = param4;
            _loc16_.x = param5;
            _loc16_.y = param9;
            _loc16_.z = param4;
         }
         _loc12_ = _loc13_;
         while(_loc12_ != null)
         {
            _loc12_.cameraX = param2.ma * _loc12_.x + param2.mb * _loc12_.y + param2.mc * _loc12_.z + param2.md;
            _loc12_.cameraY = param2.me * _loc12_.x + param2.mf * _loc12_.y + param2.mg * _loc12_.z + param2.mh;
            _loc12_.cameraZ = param2.mi * _loc12_.x + param2.mj * _loc12_.y + param2.mk * _loc12_.z + param2.ml;
            if(_loc12_.cameraZ <= 0)
            {
               return;
            }
            _loc12_ = _loc12_.next;
         }
         var _loc17_:Number = param1.viewSizeX;
         var _loc18_:Number = param1.viewSizeY;
         _loc12_ = _loc13_;
         while(_loc12_ != null)
         {
            _loc20_ = 1 / _loc12_.cameraZ;
            _loc12_.cameraX = _loc12_.cameraX * _loc17_ * _loc20_;
            _loc12_.cameraY = _loc12_.cameraY * _loc18_ * _loc20_;
            _loc12_ = _loc12_.next;
         }
         var _loc19_:Sprite = param1.view.canvas;
         _loc19_.graphics.lineStyle(0,param3 == 0 ? uint(uint(16711680)) : (param3 == 1 ? uint(uint(65280)) : uint(uint(255))),param11);
         _loc19_.graphics.moveTo(_loc13_.cameraX,_loc13_.cameraY);
         _loc19_.graphics.lineTo(_loc14_.cameraX,_loc14_.cameraY);
         _loc19_.graphics.lineTo(_loc15_.cameraX,_loc15_.cameraY);
         _loc19_.graphics.lineTo(_loc16_.cameraX,_loc16_.cameraY);
         _loc19_.graphics.lineTo(_loc13_.cameraX,_loc13_.cameraY);
      }
      
      alternativa3d static function drawBone(param1:Camera3D, param2:Number, param3:Number, param4:Number, param5:Number, param6:Number, param7:int) : void
      {
         var _loc11_:Number = NaN;
         var _loc12_:Number = NaN;
         var _loc13_:Number = NaN;
         var _loc14_:Number = NaN;
         var _loc15_:Sprite = null;
         var _loc8_:Number = param4 - param2;
         var _loc9_:Number = param5 - param3;
         var _loc10_:Number = Math.sqrt(_loc8_ * _loc8_ + _loc9_ * _loc9_);
         if(_loc10_ > 0.001)
         {
            _loc8_ /= _loc10_;
            _loc9_ /= _loc10_;
            _loc11_ = _loc9_ * param6;
            _loc12_ = -_loc8_ * param6;
            _loc13_ = -_loc9_ * param6;
            _loc14_ = _loc8_ * param6;
            if(_loc10_ > param6 * 2)
            {
               _loc10_ = param6;
            }
            else
            {
               _loc10_ /= 2;
            }
            _loc15_ = param1.view.canvas;
            _loc15_.graphics.lineStyle(1,param7);
            _loc15_.graphics.beginFill(param7,0.6);
            _loc15_.graphics.moveTo(param2,param3);
            _loc15_.graphics.lineTo(param2 + _loc8_ * _loc10_ + _loc11_,param3 + _loc9_ * _loc10_ + _loc12_);
            _loc15_.graphics.lineTo(param4,param5);
            _loc15_.graphics.lineTo(param2 + _loc8_ * _loc10_ + _loc13_,param3 + _loc9_ * _loc10_ + _loc14_);
            _loc15_.graphics.lineTo(param2,param3);
            _loc15_.graphics.endFill();
         }
      }
   }
}
