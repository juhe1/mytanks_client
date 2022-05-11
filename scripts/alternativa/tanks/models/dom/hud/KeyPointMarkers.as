package alternativa.tanks.models.dom.hud
{
   import alternativa.console.ConsoleVarFloat;
   import alternativa.engine3d.alternativa3d;
   import alternativa.engine3d.core.Camera3D;
   import alternativa.engine3d.core.Object3D;
   import alternativa.math.Matrix4;
   import alternativa.math.Vector3;
   import alternativa.tanks.models.battlefield.BattlefieldModel;
   
   use namespace alternativa3d;
   
   public class KeyPointMarkers
   {
      
      private static const CON_HIDE_SCALE:ConsoleVarFloat = new ConsoleVarFloat("ph_scale",0.12,0.00001,10);
      
      private static const CON_FULL_HIDE_SCALE:ConsoleVarFloat = new ConsoleVarFloat("pfh_scale",0.1,0.00001,10);
      
      private static const m:Matrix4 = new Matrix4();
      
      private static const m1:Matrix4 = new Matrix4();
      
      private static const v:Vector3 = new Vector3();
      
      private static const pointPosition:Vector3 = new Vector3();
      
      private static const cameraPosition:Vector3 = new Vector3();
      
      private static const direction:Vector3 = new Vector3();
       
      
      private var camera:Camera3D;
      
      private var markers:Vector.<KeyPointMarker>;
      
      public var battleService:BattlefieldModel;
      
      public function KeyPointMarkers(param1:Camera3D, battle:BattlefieldModel)
      {
         super();
         this.markers = new Vector.<KeyPointMarker>();
         this.battleService = battle;
         this.camera = param1;
      }
      
      private static function getPerspectiveScale(param1:Camera3D, param2:Vector3) : Number
      {
         var _loc3_:Number = Math.cos(param1.rotationX);
         var _loc4_:Number = Math.sin(param1.rotationX);
         var _loc5_:Number = Math.cos(param1.rotationY);
         var _loc6_:Number = Math.sin(param1.rotationY);
         var _loc7_:Number = Math.cos(param1.rotationZ);
         var _loc8_:Number = Math.sin(param1.rotationZ);
         var _loc9_:Number = _loc7_ * _loc6_ * _loc3_ + _loc8_ * _loc4_;
         var _loc10_:Number = -_loc7_ * _loc4_ + _loc6_ * _loc8_ * _loc3_;
         var _loc11_:Number = _loc5_ * _loc3_;
         var _loc12_:Number = -_loc9_ * param1.x - _loc10_ * param1.y - _loc11_ * param1.z;
         var _loc13_:Number = param1.view.width * 0.5;
         var _loc14_:Number = param1.view.height * 0.5;
         var _loc15_:Number = Math.sqrt(_loc13_ * _loc13_ + _loc14_ * _loc14_) / Math.tan(param1.fov * 0.5);
         var _loc16_:Number = _loc9_ * param2.x + _loc10_ * param2.y + _loc11_ * param2.z + _loc12_;
         return _loc15_ / _loc16_;
      }
      
      private static function composeObject3DMatrix(param1:Object3D) : Matrix4
      {
         var _loc2_:Number = Math.cos(param1.rotationX);
         var _loc3_:Number = Math.sin(param1.rotationX);
         var _loc4_:Number = Math.cos(param1.rotationY);
         var _loc5_:Number = Math.sin(param1.rotationY);
         var _loc6_:Number = Math.cos(param1.rotationZ);
         var _loc7_:Number = Math.sin(param1.rotationZ);
         var _loc8_:Number = _loc6_ * _loc5_;
         var _loc9_:Number = _loc7_ * _loc5_;
         var _loc10_:Number = _loc4_ * param1.scaleX;
         var _loc11_:Number = _loc3_ * param1.scaleY;
         var _loc12_:Number = _loc2_ * param1.scaleY;
         var _loc13_:Number = _loc2_ * param1.scaleZ;
         var _loc14_:Number = _loc3_ * param1.scaleZ;
         m1.a = _loc6_ * _loc10_;
         m1.b = _loc8_ * _loc11_ - _loc7_ * _loc12_;
         m1.c = _loc8_ * _loc13_ + _loc7_ * _loc14_;
         m1.d = param1.x;
         m1.e = _loc7_ * _loc10_;
         m1.f = _loc9_ * _loc11_ + _loc6_ * _loc12_;
         m1.g = _loc9_ * _loc13_ - _loc6_ * _loc14_;
         m1.h = param1.y;
         m1.i = -_loc5_ * param1.scaleX;
         m1.j = _loc4_ * _loc11_;
         m1.k = _loc4_ * _loc13_;
         m1.l = param1.z;
         return m1;
      }
      
      public function show() : void
      {
         var _loc1_:KeyPointMarker = null;
         for each(_loc1_ in this.markers)
         {
            _loc1_.visible = true;
         }
      }
      
      public function addMarker(param1:KeyPointMarker) : void
      {
         param1.visible = false;
         this.battleService.bfData.viewport.overlay.addChild(param1);
         this.markers.push(param1);
      }
      
      public function render(param1:int, param2:int) : void
      {
         var _loc4_:KeyPointMarker = null;
         var _loc3_:Matrix4 = this.calculateProjectionMatrix();
         for each(_loc4_ in this.markers)
         {
            this.updateMarker(_loc4_,_loc3_);
         }
      }
      
      private function updateMarker(param1:KeyPointMarker, param2:Matrix4) : void
      {
         var _loc7_:Number = NaN;
         param1.readPosition3D(v);
         var vect:Vector3 = v;
         v.vTransformBy4(param2);
         this.projectToView(v);
         var _loc4_:Number = this.getMarginY();
         var _loc5_:Boolean = this.isPointInsideViewport(v.x,v.y,15,_loc4_);
         var distance:Number = vect.distanceTo(new Vector3(this.camera.x,this.camera.y,this.camera.z));
         if(v.z > 0 && _loc5_)
         {
            _loc7_ = 1;
            if(_loc7_ == 0)
            {
               param1.visible = false;
               param1.alpha = 0;
            }
            else
            {
               param1.visible = true;
               param1.alpha = _loc7_;
            }
         }
         else
         {
            param1.alpha = 1;
            param1.visible = false;
         }
         if(distance < 5000)
         {
            param1.alpha = distance / (5000 * (5000 / distance) * (5000 / distance) * (5000 / distance));
         }
         param1.x = int(v.x + this.battleService.getWidth() / 2 - 12);
         param1.y = int(v.y + this.battleService.getHeight() / 2 - 12);
         param1.update();
      }
      
      private function projectToView(param1:Vector3) : void
      {
         var _loc2_:Number = NaN;
         var _loc3_:Number = NaN;
         if(param1.z > 0.001)
         {
            param1.x = param1.x * this.camera.viewSizeX / param1.z;
            param1.y = param1.y * this.camera.viewSizeY / param1.z;
         }
         else if(param1.z < -0.001)
         {
            param1.x = -param1.x * this.camera.viewSizeX / param1.z;
            param1.y = -param1.y * this.camera.viewSizeY / param1.z;
         }
         else
         {
            _loc2_ = this.battleService.getDiagonalSquared();
            _loc3_ = Math.sqrt(param1.x * param1.x + param1.y * param1.y);
            param1.x *= _loc2_ / _loc3_;
            param1.y *= _loc2_ / _loc3_;
         }
      }
      
      private function getMarginY() : int
      {
         switch(this.battleService.screenSize)
         {
            case 10:
               return 70;
            case 9:
               return 40;
            default:
               return 15;
         }
      }
      
      private function isPointInsideViewport(param1:Number, param2:Number, param3:Number, param4:Number) : Boolean
      {
         var _loc6_:Number = this.battleService.getWidth() / 2 - param3;
         var _loc7_:Number = this.battleService.getHeight() / 2 - param4;
         return param1 >= -_loc6_ && param1 <= _loc6_ && param2 >= -_loc7_ && param2 <= _loc7_;
      }
      
      private function calculateProjectionMatrix() : Matrix4
      {
         var _loc5_:Number = NaN;
         var _loc6_:Number = NaN;
         var _loc7_:Number = NaN;
         var _loc15_:Number = NaN;
         var _loc1_:Number = this.camera.viewSizeX / this.camera.focalLength;
         var _loc2_:Number = this.camera.viewSizeY / this.camera.focalLength;
         var _loc3_:Number = Math.cos(this.camera.rotationX);
         var _loc4_:Number = Math.sin(this.camera.rotationX);
         _loc5_ = Math.cos(this.camera.rotationY);
         _loc6_ = Math.sin(this.camera.rotationY);
         _loc7_ = Math.cos(this.camera.rotationZ);
         var _loc8_:Number = Math.sin(this.camera.rotationZ);
         var _loc9_:Number = _loc7_ * _loc6_;
         var _loc10_:Number = _loc8_ * _loc6_;
         var _loc11_:Number = _loc5_ * this.camera.scaleX;
         var _loc12_:Number = _loc4_ * this.camera.scaleY;
         var _loc13_:Number = _loc3_ * this.camera.scaleY;
         var _loc14_:Number = _loc3_ * this.camera.scaleZ;
         _loc15_ = _loc4_ * this.camera.scaleZ;
         m.a = _loc7_ * _loc11_ * _loc1_;
         m.b = (_loc9_ * _loc12_ - _loc8_ * _loc13_) * _loc2_;
         m.c = _loc9_ * _loc14_ + _loc8_ * _loc15_;
         m.d = this.camera.x;
         m.e = _loc8_ * _loc11_ * _loc1_;
         m.f = (_loc10_ * _loc12_ + _loc7_ * _loc13_) * _loc2_;
         m.g = _loc10_ * _loc14_ - _loc7_ * _loc15_;
         m.h = this.camera.y;
         m.i = -_loc6_ * this.camera.scaleX * _loc1_;
         m.j = _loc5_ * _loc12_ * _loc2_;
         m.k = _loc5_ * _loc14_;
         m.l = this.camera.z;
         var _loc16_:Object3D = this.camera;
         while(_loc16_._parent != null)
         {
            _loc16_ = _loc16_._parent;
            m.append(composeObject3DMatrix(_loc16_));
         }
         m.invert();
         return m;
      }
   }
}
