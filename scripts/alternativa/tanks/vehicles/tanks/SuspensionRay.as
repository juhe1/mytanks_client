package alternativa.tanks.vehicles.tanks
{
   import alternativa.engine3d.core.Camera3D;
   import alternativa.math.Vector3;
   import alternativa.physics.Body;
   import alternativa.physics.BodyState;
   import alternativa.physics.collision.types.RayIntersection;
   import flash.display.Graphics;
   import flash.geom.Vector3D;
   
   public class SuspensionRay
   {
      
      private static var _v:Vector3 = new Vector3();
      
      private static var _worldUp:Vector3 = new Vector3();
      
      private static var _groundUp:Vector3;
      
      private static var _groundForward:Vector3 = new Vector3();
      
      private static var _groundRight:Vector3 = new Vector3();
      
      private static var _relVel:Vector3 = new Vector3();
      
      public static var _force:Vector3 = new Vector3();
      
      private static var _p:Vector3D = new Vector3D();
       
      
      public var collisionGroup:int;
      
      private var body:Body;
      
      public var relPos:Vector3;
      
      public var relDir:Vector3;
      
      public var worldPos:Vector3;
      
      public var worldDir:Vector3;
      
      public var globalOrigin:Vector3;
      
      private var lastCollided:Boolean = false;
      
      private var lastIntersection:RayIntersection;
      
      private var prevDisplacement:Number = 0;
      
      private var predicate:RayPredicate;
      
      public function SuspensionRay(body:Body, relPos:Vector3, relDir:Vector3)
      {
         this.relPos = new Vector3();
         this.relDir = new Vector3();
         this.worldPos = new Vector3();
         this.worldDir = new Vector3();
         this.globalOrigin = new Vector3();
         this.lastIntersection = new RayIntersection();
         super();
         this.body = body;
         this.relPos.vCopy(relPos);
         this.relDir.vCopy(relDir);
         this.predicate = new RayPredicate(body);
      }
      
      public function setRelPos(value:Vector3) : void
      {
         this.relPos.vCopy(value);
      }
      
      public function setRelPosXYZ(x:Number, y:Number, z:Number) : void
      {
         this.relPos.x = x;
         this.relPos.y = y;
         this.relPos.z = z;
      }
      
      public function calculateIntersection(maxLength:Number) : Boolean
      {
         this.body.baseMatrix.transformVector(this.relDir,this.worldDir);
         this.body.baseMatrix.transformVector(this.relPos,this.worldPos);
         var p:Vector3 = this.body.state.pos;
         this.worldPos.x += p.x;
         this.worldPos.y += p.y;
         this.worldPos.z += p.z;
         if(this.lastCollided)
         {
            this.prevDisplacement = maxLength - this.lastIntersection.t;
         }
         return this.lastCollided = this.body.world.collisionDetector.intersectRay(this.worldPos,this.worldDir,this.collisionGroup,maxLength,this.predicate,this.lastIntersection);
      }
      
      public function addForce(dt:Number, throttle:Number, maxSpeed:Number, slipTerm:int, springCoeff:Number, data:SuspensionData, fwdBrake:Boolean) : void
      {
         var len:Number = NaN;
         var state:BodyState = null;
         var relSpeed:Number = NaN;
         var bState:BodyState = null;
         len = NaN;
         state = null;
         relSpeed = NaN;
         bState = null;
         var slipSpeed:Number = NaN;
         var sideFriction:Number = NaN;
         var frictionForce:Number = NaN;
         var fwdFriction:Number = NaN;
         if(!this.lastCollided)
         {
            return;
         }
         _groundUp = this.lastIntersection.normal;
         _v.x = this.body.baseMatrix.b;
         _v.y = this.body.baseMatrix.f;
         _v.z = this.body.baseMatrix.j;
         _groundRight.x = _v.y * _groundUp.z - _v.z * _groundUp.y;
         _groundRight.y = _v.z * _groundUp.x - _v.x * _groundUp.z;
         _groundRight.z = _v.x * _groundUp.y - _v.y * _groundUp.x;
         len = _groundRight.x * _groundRight.x + _groundRight.y * _groundRight.y + _groundRight.z * _groundRight.z;
         if(len == 0)
         {
            _groundRight.x = 1;
         }
         else
         {
            len = Math.sqrt(len);
            _groundRight.x /= len;
            _groundRight.y /= len;
            _groundRight.z /= len;
         }
         _groundForward.x = _groundUp.y * _groundRight.z - _groundUp.z * _groundRight.y;
         _groundForward.y = _groundUp.z * _groundRight.x - _groundUp.x * _groundRight.z;
         _groundForward.z = _groundUp.x * _groundRight.y - _groundUp.y * _groundRight.x;
         state = this.body.state;
         _v.x = this.lastIntersection.pos.x - state.pos.x;
         _v.y = this.lastIntersection.pos.y - state.pos.y;
         _v.z = this.lastIntersection.pos.z - state.pos.z;
         var rot:Vector3 = state.rotation;
         _relVel.x = rot.y * _v.z - rot.z * _v.y + state.velocity.x;
         _relVel.y = rot.z * _v.x - rot.x * _v.z + state.velocity.y;
         _relVel.z = rot.x * _v.y - rot.y * _v.x + state.velocity.z;
         if(this.lastIntersection.primitive.body != null)
         {
            bState = this.lastIntersection.primitive.body.state;
            _v.x = this.lastIntersection.pos.x - bState.pos.x;
            _v.y = this.lastIntersection.pos.y - bState.pos.y;
            _v.z = this.lastIntersection.pos.z - bState.pos.z;
            rot = bState.rotation;
            _relVel.x -= rot.y * _v.z - rot.z * _v.y + bState.velocity.x;
            _relVel.y -= rot.z * _v.x - rot.x * _v.z + bState.velocity.y;
            _relVel.z -= rot.x * _v.y - rot.y * _v.x + bState.velocity.z;
         }
         relSpeed = Math.sqrt(_relVel.x * _relVel.x + _relVel.y * _relVel.y + _relVel.z * _relVel.z);
         var fwdSpeed:Number = _relVel.x * _groundForward.x + _relVel.y * _groundForward.y + _relVel.z * _groundForward.z;
         if(throttle > 0 && fwdSpeed < maxSpeed || throttle < 0 && -fwdSpeed < maxSpeed)
         {
            _v.x = this.worldPos.x + data.forceOffset * this.worldDir.x;
            _v.y = this.worldPos.y + data.forceOffset * this.worldDir.y;
            _v.z = this.worldPos.z + data.forceOffset * this.worldDir.z;
            _force.x = throttle * _groundForward.x;
            _force.y = throttle * _groundForward.y;
            _force.z = throttle * _groundForward.z;
            this.body.addWorldForce(_v,_force);
         }
         _worldUp.x = this.body.baseMatrix.c;
         _worldUp.y = this.body.baseMatrix.g;
         _worldUp.z = this.body.baseMatrix.k;
         var t:Number = this.lastIntersection.t;
         var currDisplacement:Number = data.rayLength - t;
         var springForce:Number = springCoeff * currDisplacement * (_worldUp.x * this.lastIntersection.normal.x + _worldUp.y * this.lastIntersection.normal.y + _worldUp.z * this.lastIntersection.normal.z);
         var upSpeed:Number = (currDisplacement - this.prevDisplacement) / dt;
         springForce += upSpeed * data.dampingCoeff;
         if(springForce < 0)
         {
            springForce = 0;
         }
         _force.x = -springForce * this.worldDir.x;
         _force.y = -springForce * this.worldDir.y;
         _force.z = -springForce * this.worldDir.z;
         if(relSpeed > 0.001)
         {
            slipSpeed = _relVel.vDot(_groundRight);
            sideFriction = slipTerm == 0 || slipSpeed >= 0 && slipTerm > 0 || slipSpeed <= 0 && slipTerm < 0 ? Number(Number(data.staticFriction)) : Number(Number(2 * data.dynamicFriction));
            frictionForce = sideFriction * springForce * slipSpeed / relSpeed;
            if(slipSpeed > -data.smallVel && slipSpeed < data.smallVel)
            {
               frictionForce *= slipSpeed / data.smallVel;
               if(slipSpeed < 0)
               {
                  frictionForce = -frictionForce;
               }
            }
            _force.x -= frictionForce * _groundRight.x;
            _force.y -= frictionForce * _groundRight.y;
            _force.z -= frictionForce * _groundRight.z;
            if(fwdBrake)
            {
               fwdFriction = 0.3 * data.staticFriction;
            }
            else if(fwdSpeed * throttle <= 0)
            {
               fwdFriction = 0.5 * data.staticFriction;
            }
            else
            {
               fwdFriction = data.dynamicFriction;
            }
            frictionForce = fwdFriction * springForce * fwdSpeed / relSpeed;
            if(fwdSpeed > -data.smallVel && fwdSpeed < data.smallVel)
            {
               frictionForce *= fwdSpeed / data.smallVel;
               if(fwdSpeed < 0)
               {
                  frictionForce = -frictionForce;
               }
            }
            _force.x -= frictionForce * _groundForward.x;
            _force.y -= frictionForce * _groundForward.y;
            _force.z -= frictionForce * _groundForward.z;
         }
         _v.x = this.worldPos.x + data.forceOffset * this.worldDir.x;
         _v.y = this.worldPos.y + data.forceOffset * this.worldDir.y;
         _v.z = this.worldPos.z + data.forceOffset * this.worldDir.z;
         this.body.addWorldForce(_v,_force);
      }
      
      public function debugDraw(g:Graphics, camera:Camera3D, data:SuspensionData) : void
      {
         _v.vCopy(this.worldPos).vAddScaled(data.rayLength,this.worldDir);
         this.drawLine(g,camera,this.worldPos,_v,16776960,4);
         if(this.lastCollided)
         {
            this.drawLine(g,camera,this.worldPos,this.lastIntersection.pos,16711680,4);
            _v.vCopy(this.lastIntersection.pos).vAddScaled(data.rayLength,this.lastIntersection.normal);
            this.drawLine(g,camera,this.lastIntersection.pos,_v,65535,1);
         }
      }
      
      public function getGlobalOrigin() : Vector3
      {
         return this.worldPos;
      }
      
      private function drawLine(g:Graphics, camera:Camera3D, wBegin:Vector3, wEnd:Vector3, color:int, thickness:int = 0, alpha:Number = 1) : void
      {
      }
   }
}

import alternativa.physics.Body;
import alternativa.physics.collision.IRayCollisionPredicate;

class RayPredicate implements IRayCollisionPredicate
{
    
   
   private var body:Body;
   
   function RayPredicate(body:Body)
   {
      super();
      this.body = body;
   }
   
   public function considerBody(body:Body) : Boolean
   {
      return this.body != body;
   }
}
