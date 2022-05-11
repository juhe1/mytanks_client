package alternativa.tanks.vehicles.tanks
{
   import alternativa.engine3d.core.Camera3D;
   import alternativa.engine3d.objects.Mesh;
   import alternativa.math.Matrix3;
   import alternativa.math.Matrix4;
   import alternativa.math.Quaternion;
   import alternativa.math.Vector3;
   import alternativa.physics.CollisionPrimitiveListItem;
   import alternativa.physics.altphysics;
   import alternativa.physics.collision.primitives.CollisionBox;
   import alternativa.physics.rigid.Body3D;
   import alternativa.tanks.display.usertitle.UserTitle;
   import alternativa.tanks.models.battlefield.logic.updaters.HullTransformUpdater;
   import alternativa.tanks.models.battlefield.logic.updaters.LocalHullTransformUpdater;
   import alternativa.tanks.models.battlefield.scene3dcontainer.Scene3DContainer;
   import alternativa.tanks.models.tank.TankData;
   import alternativa.tanks.models.tank.turret.TurretController;
   import alternativa.tanks.models.weapon.AllGlobalGunParams;
   import alternativa.tanks.models.weapon.WeaponUtils;
   import com.alternativaplatform.projects.tanks.client.commons.types.Vector3d;
   import flash.display.Graphics;
   import flash.utils.Dictionary;
   
   use namespace altphysics;
   
   public class Tank extends Body3D
   {
      
      private static const FORWARD:int = 1;
      
      private static const BACK:int = 2;
      
      private static const LEFT:int = 4;
      
      private static const RIGHT:int = 8;
      
      private static const TURRET_LEFT:int = 16;
      
      private static const TURRET_RIGHT:int = 32;
      
      private static const CENTER_TURRET:int = 64;
      
      private static const REVERSE_TURN_BIT:int = 128;
      
      private static const PI:Number = Math.PI;
      
      private static const PI2:Number = 2 * Math.PI;
      
      private static var _m:Matrix3 = new Matrix3();
      
      private static var _orient:Quaternion = new Quaternion();
      
      private static var _pos:Vector3 = new Vector3();
      
      private static var _v:Vector3 = new Vector3();
      
      private static var _vin:Vector.<Number> = Vector.<Number>([0,0,0]);
      
      private static var _vout:Vector.<Number> = Vector.<Number>([0,0,0]);
       
      
      public var tankData:TankData;
      
      public var maxSpeed:Number = 0;
      
      private var maxSpeedSmoother:IValueSmoother;
      
      public var maxTurnSpeed:Number = 0;
      
      private var maxTurnSpeedSmoother:ValueSmoother;
      
      public var maxTurretTurnSpeed:Number = 0;
      
      private var maxTurretTurnSpeedSmoother:ValueSmoother;
      
      public var turretTurnAcceleration:Number = 0;
      
      public var turretTurnSpeed:Number = 0;
      
      public var mass:Number;
      
      public var suspensionData:SuspensionData;
      
      public var skinZCorrection:Number = 0;
      
      public var mainCollisionBox:CollisionBox;
      
      public var visibilityPoints:Vector.<Vector3>;
      
      private const RAY_OFFSET:Number = 5;
      
      private var dimensions:Vector3;
      
      private var _skin:TankSkin;
      
      private var _title:UserTitle;
      
      public var leftTrack:Track;
      
      public var rightTrack:Track;
      
      private var trackSpeed:calculateTrackSpeed;
      
      public var leftThrottle:Number = 0;
      
      public var rightThrottle:Number = 0;
      
      private var leftBrake:Boolean;
      
      private var rightBrake:Boolean;
      
      private var bbs:Dictionary;
      
      private var container:Scene3DContainer;
      
      private var _showCollisionGeometry:Boolean;
      
      private var titleContainer:Scene3DContainer;
      
      private var local:Boolean;
      
      private var jumpActivated:Boolean;
      
      private var shpereRadius:Number;
      
      public var hullTransformUpdater:HullTransformUpdater;
      
      private var notLockedHullUpdater:HullTransformUpdater;
      
      private var lockedHullTransformUpdater:LocalHullTransformUpdater;
      
      public var interpolatedPosition:Vector3;
      
      public var interpolatedOrientation:Quaternion;
      
      public var skinCenterOffset:Vector3;
      
      private const _acceleration:Number = 0;
      
      private var turretController:TurretController;
      
      private var animatedTracks:Boolean;
      
      public function Tank(skin:TankSkin, mass:Number, maxSpeed:Number, maxTurnSpeed:Number, turretMaxTurnSpeed:Number, turretTurnAcceleration:Number, isLocal:Boolean, titleContainer:Scene3DContainer, rayLength:Number = 50, rayOptimalLength:Number = 25, dampingCoeff:Number = 1000, friction:Number = 0.1, rays:Number = 5)
      {
         this.maxTurnSpeedSmoother = new ValueSmoother(0.3,10,0,0);
         this.maxTurretTurnSpeedSmoother = new ValueSmoother(0.3,10,0,0);
         this.suspensionData = new SuspensionData();
         this.dimensions = new Vector3();
         this.trackSpeed = new calculateTrackSpeed();
         this.bbs = new Dictionary();
         this.skinCenterOffset = new Vector3();
         super(0,Matrix3.ZERO,isLocal);
         this._skin = skin;
         this.maxSpeed = maxSpeed;
         this.maxTurnSpeed = maxTurnSpeed;
         this.maxTurretTurnSpeed = turretMaxTurnSpeed;
         this.turretTurnAcceleration = turretTurnAcceleration;
         this.titleContainer = titleContainer;
         this.local = isLocal;
         this._title = new UserTitle(this.local);
         this.lockedHullTransformUpdater = new LocalHullTransformUpdater(this);
         if(isLocal)
         {
            this.maxSpeedSmoother = new SecureValueSmoother(100,1000,0,0);
         }
         else
         {
            this.maxSpeedSmoother = new ValueSmoother(100,1000,0,0);
         }
         var mesh:Mesh = skin.hullDescriptor.mesh;
         mesh.calculateBounds();
         var dimensions:Vector3 = new Vector3(2 * mesh.boundMaxX,2 * mesh.boundMaxY,mesh.boundMaxZ);
         this.setMassAndDimensions(mass,dimensions);
         this.createTracks(rays,dimensions.y * 0.8,dimensions.x - 40);
         this.suspensionData.rayLength = rayLength;
         this.suspensionData.rayOptimalLength = rayOptimalLength;
         this.suspensionData.dampingCoeff = dampingCoeff;
         material.friction = friction;
         this.setOptimalZCorrection();
         var raduis:Vector3 = this.calculateSizeFromMesh(mesh);
         var hall:Vector3 = new Vector3(raduis.x / 2,raduis.y / 2,raduis.z / 2);
         var p1:Number = 2 * hall.z - (this.suspensionData.rayOptimalLength - 10);
         this.interpolatedOrientation = new Quaternion();
         this.interpolatedPosition = new Vector3();
      }
      
      override public function addWorldForceScaled(pos:Vector3, force:Vector3, scale:Number) : void
      {
         if(isNaN(pos.x) || isNaN(pos.y) || isNaN(pos.z))
         {
            return;
         }
         if(isNaN(force.x) || isNaN(force.y) || isNaN(force.z))
         {
            return;
         }
         super.addWorldForceScaled(pos,force,scale);
      }
      
      public function getAllGunParams(param1:AllGlobalGunParams, muzzles:Vector.<Vector3>, param2:int = 0) : void
      {
         WeaponUtils.getInstance().calculateMainGunParams(this.skin.turretMesh,muzzles[param2],param1);
      }
      
      public function setTurretController(controller:TurretController) : void
      {
         this.turretController = controller;
      }
      
      public function getTurretController() : TurretController
      {
         return this.turretController;
      }
      
      public function lockTransformUpdate() : void
      {
         this.hullTransformUpdater = this.lockedHullTransformUpdater;
         this.hullTransformUpdater.reset();
      }
      
      public function unlockTransformUpdate() : void
      {
         this.hullTransformUpdater = this.notLockedHullUpdater;
         this.hullTransformUpdater.reset();
      }
      
      private function calculateSkinCenterOffset(param1:Vector3) : void
      {
         var _loc2_:Mesh = this.skin.hullMesh;
         _loc2_.calculateBounds();
         this.skinCenterOffset.x = -0.5 * (_loc2_.boundMinX + _loc2_.boundMaxX);
         this.skinCenterOffset.y = -0.5 * (_loc2_.boundMinY + _loc2_.boundMaxY);
         this.skinCenterOffset.z = -0.5 * param1.z - this.suspensionData.rayOptimalLength + 10;
      }
      
      public function setAnimationTracks(value:Boolean) : void
      {
         this.animatedTracks = value;
      }
      
      public function getBoundSphereRadius() : Number
      {
         return this.shpereRadius;
      }
      
      private function setBoundSphereRadius(radius:Vector3, p1:Number) : void
      {
         var _loc3_:Vector3 = new Vector3(radius.x,radius.y,p1 / 2);
         var _loc4_:Matrix4 = this.mainCollisionBox.transform;
         this.shpereRadius = _loc3_.vLength() + Math.abs(_loc4_.k);
      }
      
      private function calculateSizeFromMesh(mesh:Mesh) : Vector3
      {
         return new Vector3(mesh.boundMaxX - mesh.boundMinX,mesh.boundMaxY - mesh.boundMinY,mesh.boundMaxZ - mesh.boundMinZ);
      }
      
      public function setMaxTurretTurnSpeed(value:Number, immediate:Boolean) : void
      {
         if(immediate)
         {
            this.maxTurretTurnSpeed = value;
            this.maxTurretTurnSpeedSmoother.reset(value);
         }
         else
         {
            this.maxTurretTurnSpeedSmoother.targetValue = value;
         }
      }
      
      public function setMaxTurnSpeed(value:Number, immediate:Boolean) : void
      {
         if(immediate)
         {
            this.maxTurnSpeed = value;
            this.maxTurnSpeedSmoother.reset(value);
         }
         else
         {
            this.maxTurnSpeedSmoother.targetValue = value;
         }
      }
      
      public function setMaxSpeed(value:Number, immediate:Boolean) : void
      {
         if(immediate)
         {
            this.maxSpeed = value;
            this.maxSpeedSmoother.reset(value);
         }
         else
         {
            this.maxSpeedSmoother.targetValue = value;
         }
      }
      
      public function get collisionGroup() : int
      {
         return collisionPrimitives.head.primitive.collisionGroup;
      }
      
      public function set collisionGroup(value:int) : void
      {
         var item:CollisionPrimitiveListItem = collisionPrimitives.head;
         while(item != null)
         {
            item.primitive.collisionGroup = value;
            item = item.next;
         }
      }
      
      public function set tracksCollisionGroup(value:int) : void
      {
         this.leftTrack.collisionGroup = value;
         this.rightTrack.collisionGroup = value;
      }
      
      public function setMassAndDimensions(mass:Number, dimensions:Vector3) : void
      {
         var xx:Number = NaN;
         var yy:Number = NaN;
         var zz:Number = NaN;
         if(isNaN(mass) || mass <= 0)
         {
            throw new ArgumentError("Wrong mass");
         }
         if(dimensions == null || dimensions.x <= 0 || dimensions.y <= 0 || dimensions.z <= 0)
         {
            throw new ArgumentError("Wrong dimensions");
         }
         this.mass = mass;
         this.dimensions.vCopy(dimensions);
         if(mass == Infinity)
         {
            invMass = 0;
            invInertia.copy(Matrix3.ZERO);
         }
         else
         {
            invMass = 1 / mass;
            xx = dimensions.x * dimensions.x;
            yy = dimensions.y * dimensions.y;
            zz = dimensions.z * dimensions.z;
            invInertia.a = 12 * invMass / (yy + zz);
            invInertia.f = 12 * invMass / (zz + xx);
            invInertia.k = 12 * invMass / (xx + yy);
         }
         this.setupCollisionPrimitives();
      }
      
      override public function addToContainer(container:Scene3DContainer) : void
      {
         if(this.container != null)
         {
            this.removeFromContainer();
         }
         this.container = container;
         this._skin.addToContainer(container);
         if(this._title != null)
         {
            this._title.addToContainer(this.titleContainer);
         }
         if(this._showCollisionGeometry)
         {
            this.addDebugBoxesToContainer(container);
         }
         var raduis:Vector3 = this.calculateSizeFromMesh(this.skin.hullMesh);
         var hall:Vector3 = new Vector3(raduis.x / 2,raduis.y / 2,raduis.z / 2);
         var p1:Number = 2 * raduis.z - (this.suspensionData.rayOptimalLength - 10);
         this.setBoundSphereRadius(raduis,p1);
         this.calculateSkinCenterOffset(raduis);
      }
      
      override public function removeFromContainer() : void
      {
         this._skin.removeFromContainer();
         if(this._title != null)
         {
            this._title.removeFromContainer();
         }
         if(this._showCollisionGeometry)
         {
            this.removeDebugBoxesFromContainer();
         }
         this.container = null;
      }
      
      public function createTracks(raysNum:int, trackLength:Number, widthBetween:Number) : void
      {
         this.leftTrack = new Track(this,raysNum,new Vector3(-0.5 * widthBetween,0,-0.5 * this.dimensions.z + this.RAY_OFFSET),trackLength);
         this.rightTrack = new Track(this,raysNum,new Vector3(0.5 * widthBetween,0,-0.5 * this.dimensions.z + this.RAY_OFFSET),trackLength);
      }
      
      public function setThrottle(throttleLeft:Number, throttleRight:Number) : void
      {
         this.leftThrottle = throttleLeft;
         this.rightThrottle = throttleRight;
      }
      
      public function setBrakes(lb:Boolean, rb:Boolean) : void
      {
         this.leftBrake = lb;
         this.rightBrake = rb;
      }
      
      public function rotateTurret(timeFactor:Number, stopAtZero:Boolean) : Boolean
      {
         var sign:Boolean = this._skin.turretDirection < 0;
         this.turretTurnSpeed += timeFactor * this.turretTurnAcceleration;
         if(this.turretTurnSpeed < -this.maxTurretTurnSpeed)
         {
            this.turretTurnSpeed = -this.maxTurretTurnSpeed;
         }
         else if(this.turretTurnSpeed > this.maxTurretTurnSpeed)
         {
            this.turretTurnSpeed = this.maxTurretTurnSpeed;
         }
         this.turretDir += this.turretTurnSpeed * (timeFactor < 0 ? -timeFactor : timeFactor);
         if(stopAtZero && sign != this._skin.turretDirection < 0)
         {
            this.turretTurnSpeed = 0;
            this._skin.turretDirection = 0;
            return true;
         }
         return false;
      }
      
      public function rotateTurretDo(timeFactor:Number, stopAt:Number) : Boolean
      {
         var sign:Boolean = this._skin.turretDirection < stopAt;
         this.turretTurnSpeed += timeFactor * this.turretTurnAcceleration;
         if(this.turretTurnSpeed < -this.maxTurretTurnSpeed)
         {
            this.turretTurnSpeed = -this.maxTurretTurnSpeed;
         }
         else if(this.turretTurnSpeed > this.maxTurretTurnSpeed)
         {
            this.turretTurnSpeed = this.maxTurretTurnSpeed;
         }
         this.turretDir += this.turretTurnSpeed * (timeFactor < 0 ? -timeFactor : timeFactor);
         if(sign != this._skin.turretDirection < stopAt)
         {
            this._skin.turretDirection = this.turretTurnSpeed = stopAt;
            return true;
         }
         return false;
      }
      
      public function stopTurret() : void
      {
         this.turretTurnSpeed = 0;
      }
      
      public function get turretDirSign() : int
      {
         return this._skin.turretDirection < 0 ? int(int(-1)) : (this._skin.turretDirection > 0 ? int(int(1)) : int(int(0)));
      }
      
      public function get skin() : TankSkin
      {
         return this._skin;
      }
      
      public function interpolatePhysicsState(t:Number) : void
      {
         interpolate(t,this.interpolatedPosition,this.interpolatedOrientation);
         this.interpolatedOrientation.normalize();
         if(this.hullTransformUpdater != null)
         {
            this.hullTransformUpdater.update(t);
         }
      }
      
      override public function updateSkin(t:Number) : void
      {
         var avel:Number = NaN;
         var Speed:Number = NaN;
         this.interpolatePhysicsState(t);
         _pos.x += this.skinZCorrection * _m.c;
         _pos.y += this.skinZCorrection * _m.g;
         _pos.z += this.skinZCorrection * _m.k;
         this.skin.updateTransform(_pos,_orient);
         this.skin.turretMesh.matrix.transformVectors(_vin,_vout);
         _pos.x = _vout[0];
         _pos.y = _vout[1];
         _pos.z = _vout[2];
         _pos.z += !!this.local ? 0 : 200;
         this._title.update(_pos);
         if(this.animatedTracks)
         {
            avel = Math.abs(this.state.rotation.z);
            Speed = this.getVelocity();
            this._skin.updateTracks(this.trackSpeed.calcTrackSpeed(Speed,avel,this.tankData.ctrlBits,this.leftTrack.lastContactsNum,this.contactsNum,this.maxSpeed,-1),this.trackSpeed.calcTrackSpeed(Speed,avel,this.tankData.ctrlBits,this.rightTrack.lastContactsNum,this.contactsNum,this.maxSpeed,1));
         }
      }
      
      public function updatePhysicsState() : void
      {
         this.interpolatePhysicsState(1);
         this.hullTransformUpdater.update(0);
      }
      
      public function getBarrelOrigin(param1:Vector3, muzzles:Vector.<Vector3>, param2:int = 0) : void
      {
         param1.vCopy(muzzles[param2]);
         param1.y = 0;
      }
      
      public function jump() : void
      {
         this.jumpActivated = true;
      }
      
      override public function beforePhysicsStep(dt:Number) : void
      {
         var d:Number = NaN;
         var limit:Number = NaN;
         if(this.maxSpeed != this.maxSpeedSmoother.targetValue)
         {
            this.maxSpeed = this.maxSpeedSmoother.update(dt);
         }
         if(this.maxTurnSpeed != this.maxTurnSpeedSmoother.targetValue)
         {
            this.maxTurnSpeed = this.maxTurnSpeedSmoother.update(dt);
         }
         if(this.maxTurretTurnSpeed != this.maxTurretTurnSpeedSmoother.targetValue)
         {
            this.maxTurretTurnSpeed = this.maxTurretTurnSpeedSmoother.update(dt);
         }
         var slipTerm:int = this.leftThrottle > this.rightThrottle ? int(int(-1)) : (this.leftThrottle < this.rightThrottle ? int(int(1)) : int(int(0)));
         var weight:Number = this.mass * world._gravity.vLength();
         var k:Number = this.leftThrottle != this.rightThrottle && !(this.leftBrake || this.rightBrake) && state.rotation.vLength() > this.maxTurnSpeed ? Number(Number(0.1)) : Number(Number(1));
         this.leftTrack.addForces(dt,k * this.leftThrottle,this.maxSpeed,slipTerm,weight,this.suspensionData,this.leftBrake);
         this.rightTrack.addForces(dt,k * this.rightThrottle,this.maxSpeed,slipTerm,weight,this.suspensionData,this.rightBrake);
         if(this.rightTrack.lastContactsNum >= this.rightTrack.raysNum >> 1 || this.leftTrack.lastContactsNum >= this.leftTrack.raysNum >> 1)
         {
            d = world._gravity.x * baseMatrix.c + world._gravity.y * baseMatrix.g + world._gravity.z * baseMatrix.k;
            limit = Math.SQRT1_2 * world._gravity.vLength();
            if(d < -limit || d > limit)
            {
               _v.x = (baseMatrix.c * d - world._gravity.x) / invMass;
               _v.y = (baseMatrix.g * d - world._gravity.y) / invMass;
               _v.z = (baseMatrix.k * d - world._gravity.z) / invMass;
               addForce(_v);
            }
         }
      }
      
      public function setOptimalZCorrection() : void
      {
         this.skinZCorrection = -0.5 * this.dimensions.z - this.suspensionData.rayOptimalLength + this.RAY_OFFSET;
      }
      
      public function getPhysicsState(pos:Vector3d, orient:Vector3d, linVel:Vector3d, angVel:Vector3d) : void
      {
         this.vector3To3d(state.pos,pos);
         state.orientation.getEulerAngles(_v);
         orient.x = _v.x;
         orient.y = _v.y;
         orient.z = _v.z;
         this.vector3To3d(state.velocity,linVel);
         this.vector3To3d(state.rotation,angVel);
      }
      
      public function getVelocity() : Number
      {
         return state.velocity.vLength();
      }
      
      public function setPhysicsState(pos:Vector3d, orient:Vector3d, linVel:Vector3d, angVel:Vector3d) : void
      {
         this.vector3dTo3(pos,state.pos);
         _orient.setFromAxisAngleComponents(1,0,0,orient.x);
         state.orientation.copy(_orient);
         _orient.setFromAxisAngleComponents(0,1,0,orient.y);
         state.orientation.append(_orient);
         state.orientation.normalize();
         _orient.setFromAxisAngleComponents(0,0,1,orient.z);
         state.orientation.append(_orient);
         state.orientation.normalize();
         this.vector3dTo3(linVel,state.velocity);
         this.vector3dTo3(angVel,state.rotation);
         prevState.copy(state);
      }
      
      public function get turretDir() : Number
      {
         return this._skin.turretDirection;
      }
      
      public function set turretDir(value:Number) : void
      {
         if(this._skin == null)
         {
            return;
         }
         if(value > PI)
         {
            this._skin.turretDirection = value - PI2;
         }
         else if(value < -PI)
         {
            this._skin.turretDirection = value + PI2;
         }
         else
         {
            this._skin.turretDirection = value;
         }
      }
      
      public function get title() : UserTitle
      {
         return this._title;
      }
      
      public function debugDraw(g:Graphics, camera:Camera3D) : void
      {
         this.leftTrack.debugDraw(g,camera,this.suspensionData);
         this.rightTrack.debugDraw(g,camera,this.suspensionData);
      }
      
      public function get showCollisionGeometry() : Boolean
      {
         return this._showCollisionGeometry;
      }
      
      public function set showCollisionGeometry(value:Boolean) : void
      {
         if(this._showCollisionGeometry == value)
         {
            return;
         }
         this._showCollisionGeometry = value;
         if(this._showCollisionGeometry)
         {
            if(this.container != null)
            {
               this.addDebugBoxesToContainer(this.container);
            }
         }
         else if(this.container != null)
         {
            this.removeDebugBoxesFromContainer();
         }
      }
      
      public function setHullTransformUpdater(hull_:HullTransformUpdater) : void
      {
         this.hullTransformUpdater = hull_;
         this.notLockedHullUpdater = hull_;
         this.hullTransformUpdater.reset();
      }
      
      private function setupCollisionPrimitives() : void
      {
         var key:* = undefined;
         var prim:CollisionBox = null;
         var item:CollisionPrimitiveListItem = null;
         var hs:Vector3 = this.dimensions.vClone().vScale(0.5);
         var sizeX:Number = hs.x;
         var sizeY:Number = hs.y;
         var sizeZ:Number = hs.z;
         var m:Matrix4 = new Matrix4();
         if(collisionPrimitives == null)
         {
            hs.y = 0.8 * sizeY;
            this.mainCollisionBox = new CollisionBox(hs,0);
            addCollisionPrimitive(this.mainCollisionBox);
            hs.y = sizeY;
            hs.z = sizeZ / 3;
            m.l = 2 * sizeZ / 3;
            addCollisionPrimitive(new CollisionBox(hs,0),m);
            this.visibilityPoints = Vector.<Vector3>([new Vector3(),new Vector3(),new Vector3(),new Vector3(),new Vector3(),new Vector3()]);
         }
         else
         {
            item = collisionPrimitives.head;
            hs.y = 0.8 * sizeY;
            prim = CollisionBox(item.primitive);
            prim.hs.vCopy(hs);
            item = item.next;
            hs.y = sizeY;
            hs.z = sizeZ / 3;
            m.l = 2 * sizeZ / 3;
            prim = CollisionBox(item.primitive);
            prim.hs.vCopy(hs);
            prim.localTransform.copy(m);
         }
         Vector3(this.visibilityPoints[0]).vReset(-sizeX,sizeY,0);
         Vector3(this.visibilityPoints[1]).vReset(sizeX,sizeY,0);
         Vector3(this.visibilityPoints[2]).vReset(-sizeX,0,0);
         Vector3(this.visibilityPoints[3]).vReset(sizeX,0,0);
         Vector3(this.visibilityPoints[4]).vReset(-sizeX,-sizeY,0);
         Vector3(this.visibilityPoints[5]).vReset(sizeX,-sizeY,0);
         this.removeDebugBoxesFromContainer();
         for(key in this.bbs)
         {
            delete this.bbs[key];
         }
      }
      
      private function vector3To3d(v:Vector3, result:Vector3d) : void
      {
         result.x = v.x;
         result.y = v.y;
         result.z = v.z;
      }
      
      private function vector3dTo3(v:Vector3d, result:Vector3) : void
      {
         result.x = v.x;
         result.y = v.y;
         result.z = v.z;
      }
      
      private function addDebugBoxesToContainer(container:Scene3DContainer) : void
      {
      }
      
      private function removeDebugBoxesFromContainer() : void
      {
      }
      
      public function destroy(fully:Boolean = false) : *
      {
         var v:Vector3 = null;
         if(this.mainCollisionBox != null)
         {
            this.mainCollisionBox.destroy();
         }
         this.mainCollisionBox = null;
         if(this._skin != null)
         {
            this._skin.destroy(fully);
         }
         if(!fully)
         {
            return;
         }
         this.skinCenterOffset = null;
         this.interpolatedPosition = null;
         for each(v in this.visibilityPoints)
         {
            v = null;
         }
         this._skin = null;
      }
   }
}

import com.reygazu.anticheat.variables.SecureNumber;

class SecureValueSmoother implements IValueSmoother
{
    
   
   public var currentValue:SecureNumber;
   
   public var targetValue_:SecureNumber;
   
   public var smoothingSpeedUp:SecureNumber;
   
   public var smoothingSpeedDown:SecureNumber;
   
   function SecureValueSmoother(smoothingSpeedUp:Number, smoothingSpeedDown:Number, targetValue:Number, currentValue:Number)
   {
      this.currentValue = new SecureNumber("SecureValueSmoother::currentValue");
      this.targetValue_ = new SecureNumber("SecureValueSmoother::targetValue_");
      this.smoothingSpeedUp = new SecureNumber("SecureValueSmoother::smoothingSpeedUp");
      this.smoothingSpeedDown = new SecureNumber("SecureValueSmoother::smoothingSpeedDown");
      super();
      this.smoothingSpeedUp.value = smoothingSpeedUp;
      this.smoothingSpeedDown.value = smoothingSpeedDown;
      this.targetValue_.value = targetValue;
      this.currentValue.value = currentValue;
   }
   
   public function reset(value:Number) : void
   {
      this.currentValue.value = value;
      this.targetValue_.value = value;
   }
   
   public function update(dt:Number) : Number
   {
      if(this.currentValue.value < this.targetValue_.value)
      {
         this.currentValue.value += this.smoothingSpeedUp.value * dt;
         if(this.currentValue.value > this.targetValue_.value)
         {
            this.currentValue.value = this.targetValue_.value;
         }
      }
      else if(this.currentValue.value > this.targetValue_.value)
      {
         this.currentValue.value -= this.smoothingSpeedDown.value * dt;
         if(this.currentValue.value < this.targetValue_.value)
         {
            this.currentValue.value = this.targetValue_.value;
         }
      }
      return this.currentValue.value;
   }
   
   public function set targetValue(v:Number) : void
   {
      this.targetValue_.value = v;
   }
   
   public function get targetValue() : Number
   {
      return this.targetValue_.value;
   }
}

interface IValueSmoother
{
    
   
   function reset(param1:Number) : void;
   
   function update(param1:Number) : Number;
   
   function set targetValue(param1:Number) : void;
   
   function get targetValue() : Number;
}

class ValueSmoother implements IValueSmoother
{
    
   
   public var currentValue:Number;
   
   public var targetValue_:Number;
   
   public var smoothingSpeedUp:Number;
   
   public var smoothingSpeedDown:Number;
   
   function ValueSmoother(smoothingSpeedUp:Number, smoothingSpeedDown:Number, targetValue:Number, currentValue:Number)
   {
      super();
      this.smoothingSpeedUp = smoothingSpeedUp;
      this.smoothingSpeedDown = smoothingSpeedDown;
      this.targetValue_ = targetValue;
      this.currentValue = currentValue;
   }
   
   public function reset(value:Number) : void
   {
      this.currentValue = value;
      this.targetValue_ = value;
   }
   
   public function update(dt:Number) : Number
   {
      if(this.currentValue < this.targetValue_)
      {
         this.currentValue += this.smoothingSpeedUp * dt;
         if(this.currentValue > this.targetValue_)
         {
            this.currentValue = this.targetValue_;
         }
      }
      else if(this.currentValue > this.targetValue_)
      {
         this.currentValue -= this.smoothingSpeedDown * dt;
         if(this.currentValue < this.targetValue_)
         {
            this.currentValue = this.targetValue_;
         }
      }
      return this.currentValue;
   }
   
   public function set targetValue(v:Number) : void
   {
      this.targetValue_ = v;
   }
   
   public function get targetValue() : Number
   {
      return this.targetValue_;
   }
}
