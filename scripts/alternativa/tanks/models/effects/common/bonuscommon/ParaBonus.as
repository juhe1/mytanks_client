package alternativa.tanks.models.effects.common.bonuscommon
{
   import alternativa.engine3d.alternativa3d;
   import alternativa.engine3d.lights.OmniLight;
   import alternativa.engine3d.materials.Material;
   import alternativa.engine3d.objects.Mesh;
   import alternativa.init.Main;
   import alternativa.math.Vector3;
   import alternativa.physics.BodyState;
   import alternativa.physics.PhysicsScene;
   import alternativa.physics.altphysics;
   import alternativa.physics.collision.CollisionPrimitive;
   import alternativa.physics.collision.ICollisionPredicate;
   import alternativa.physics.collision.types.RayIntersection;
   import alternativa.tanks.bonuses.BonusState;
   import alternativa.tanks.bonuses.IBonus;
   import alternativa.tanks.bonuses.IBonusListener;
   import alternativa.tanks.models.battlefield.BattlefieldModel;
   import alternativa.tanks.models.battlefield.IBattleField;
   import alternativa.tanks.models.battlefield.hidableobjects.HidableObject3DWrapper;
   import alternativa.tanks.models.battlefield.scene3dcontainer.Scene3DContainer;
   import alternativa.tanks.physics.CollisionGroup;
   import alternativa.tanks.physics.TanksCollisionDetector;
   import alternativa.tanks.vehicles.tanks.Tank;
   import flash.geom.ColorTransform;
   import flash.utils.Dictionary;
   
   use namespace altphysics;
   
   public class ParaBonus implements IBonus, ICollisionPredicate
   {
      
      private static const BIG_VALUE:Number = 10000000000;
      
      private static const BOX_MASS:Number = 20;
      
      private static const BOX_HALF_SIZE:Number = 75;
      
      private static const PARACHUTE_MASS:Number = 10;
      
      private static const PARACHUTE_RADIUS:Number = 180;
      
      private static const CORDS_LENGTH:Number = 400;
      
      private static const TAKEN_ANIMATION_TIME:int = 2000;
      
      private static const FLASH_DURATION:int = 300;
      
      private static const ALPHA_DURATION:int = TAKEN_ANIMATION_TIME - FLASH_DURATION;
      
      private static const MAX_ADDITIVE_VALUE:int = 204;
      
      private static const ADDITIVE_SPEED_UP:Number = Number(MAX_ADDITIVE_VALUE) / FLASH_DURATION;
      
      private static const ADDITIVE_SPEED_DOWN:Number = Number(MAX_ADDITIVE_VALUE) / (TAKEN_ANIMATION_TIME - FLASH_DURATION);
      
      private static const UP_SPEED:Number = 300;
      
      private static const ANGLE_SPEED:Number = 2;
      
      private static const PHYSICS_STATE_FULL:int = 1;
      
      private static const PHYSICS_STATE_PARABOX:int = 2;
      
      private static const PHYSICS_STATE_BOX:int = 3;
      
      private static const WARNING_TIME:int = 8000;
      
      private static const PARACHUTE_REMOVAL_TIME:int = 2000;
      
      private static const BLINK_INTERVAL:int = 500;
      
      private static const DELTA_ALPHA:Number = 0.5;
      
      private static const MIN_ALPHA:Number = 1 - DELTA_ALPHA;
      
      private static const COEFF:Number = 10;
      
      private static const defaultState:BodyState = new BodyState();
      
      private static var pools:Dictionary = new Dictionary();
      
      private static var _v:Vector3 = new Vector3();
      
      private static const _rayHit:RayIntersection = new RayIntersection();
      
      private static const N:Vector3 = new Vector3();
      
      private static const P:Vector3 = new Vector3();
      
      private static const P1:Vector3 = new Vector3();
      
      private static const X:Vector3 = new Vector3();
      
      private static const Y:Vector3 = new Vector3();
      
      private static const Y1:Vector3 = new Vector3();
      
      private static const origin:Vector3 = new Vector3();
       
      
      private var _bonusId:String;
      
      private var bonusState:int;
      
      private var bonusListener:IBonusListener;
      
      public var parachute:Parachute;
      
      public var cordsMesh:Cords;
      
      private var timeToLive:int;
      
      private var currBlinkInterval:int;
      
      private var visibilitySwitchTime:int;
      
      private var takenAnimationTime:int;
      
      private var parachuteTimeLeft:int;
      
      private var additiveValue:int;
      
      private var alphaSpeed:Number;
      
      private var physicsState:int;
      
      private var pool:Pool;
      
      public var skin:BonusMesh;
      
      public var light:OmniLight;
      
      private var hidabbleWrapper:HidableObject3DWrapper;
      
      private var _boxMesh:Mesh;
      
      private var _parachuteMesh:Mesh;
      
      private var _parachuteInnerMesh:Mesh;
      
      private var _cordMaterial:Material;
      
      private var fallSpeed:Number = 200;
      
      private var fallPrecision:int = 3;
      
      private var landingPrecision:int = 3;
      
      private var fallController:FallController;
      
      private var landingController:LandingController;
      
      private var landingControllerInited:Boolean;
      
      public var trigger:BonusTrigger;
      
      public function ParaBonus(pool:Pool, boxMesh:Mesh, parachuteMesh:Mesh, parachuteInnerMesh:Mesh, cordMaterial:Material)
      {
         super();
         this.pool = pool;
         this._boxMesh = boxMesh;
         this._parachuteMesh = parachuteMesh;
         this._parachuteInnerMesh = parachuteInnerMesh;
         this._cordMaterial = cordMaterial;
         this.fallController = new FallController(this);
         this.landingController = new LandingController(this);
         this.trigger = new BonusTrigger(this);
      }
      
      public static function create(bonusData:BonusCommonData) : ParaBonus
      {
         var pool:Pool = pools[bonusData];
         if(pool == null)
         {
            pool = new Pool();
            pools[bonusData] = pool;
         }
         if(pool.numObjects == 0)
         {
            return new ParaBonus(pool,bonusData.boxMesh,bonusData.parachuteMesh,bonusData.parachuteInnerMesh,bonusData.cordMaterial);
         }
         var bonus:ParaBonus = pool.objects[--pool.numObjects];
         pool.objects[pool.numObjects] = null;
         return bonus;
      }
      
      public static function deletePool(bonusData:BonusCommonData) : void
      {
         delete pools[bonusData];
      }
      
      private static function isFlatSurface(groundNormal:Vector3) : Boolean
      {
         return groundNormal.z > BonusConst.COS_ONE_DEGREE;
      }
      
      public function init(bonusId:String, timeToLive:int, isFalling:Boolean) : void
      {
         this._bonusId = bonusId;
         if(BonusCache.isBonusMeshCacheEmpty(this.bonusId))
         {
            this.skin = new BonusMesh(this._bonusId,this._boxMesh);
         }
         else
         {
            this.skin = BonusCache.getBonusMesh(this._bonusId);
         }
         var colorLight:uint = 16745512;
         if(bonusId.indexOf("health") >= 0)
         {
            colorLight = 65280;
         }
         if(bonusId.indexOf("armor") >= 0)
         {
            colorLight = 16777215;
         }
         if(bonusId.indexOf("damage") >= 0)
         {
            colorLight = 65535;
         }
         if(bonusId.indexOf("nitro") >= 0)
         {
            colorLight = 16711680;
         }
         if(bonusId.indexOf("crystall") >= 0)
         {
            colorLight = 8454143;
         }
         if(bonusId.indexOf("gold") >= 0)
         {
            colorLight = 16777088;
         }
         this.light = new OmniLight(colorLight,150,500);
         this.hidabbleWrapper = new HidableObject3DWrapper(this.skin);
         this.createParachuteAndCords(this._parachuteMesh,this._parachuteInnerMesh,this._cordMaterial);
         this.timeToLive = timeToLive < 0 ? int(int(int.MAX_VALUE)) : int(int(timeToLive));
         this.bonusState = !!isFalling ? int(int(BonusState.FALLING)) : int(int(BonusState.RESTING));
         this.skin.alpha = 1;
         var colorTransform:ColorTransform = this.skin.colorTransform;
         if(colorTransform != null)
         {
            colorTransform.redOffset = 0;
            colorTransform.greenOffset = 0;
            colorTransform.blueOffset = 0;
         }
         this.additiveValue = 0;
         this.cordsMesh.alpha = 1;
         this.visibilitySwitchTime = 0;
         this.takenAnimationTime = TAKEN_ANIMATION_TIME;
         this.parachuteTimeLeft = PARACHUTE_REMOVAL_TIME;
         this.currBlinkInterval = BLINK_INTERVAL;
      }
      
      private function getGroundPointAndNormal(spawnPosition:Vector3, point:Vector3, normal:Vector3) : void
      {
         var collisionDetector:TanksCollisionDetector = BattlefieldModel(Main.osgi.getService(IBattleField)).bfData.collisionDetector;
         if(collisionDetector.raycastStatic(spawnPosition,Vector3.DOWN,CollisionGroup.STATIC,BIG_VALUE,_rayHit))
         {
            normal.vCopy(_rayHit.normal);
            point.vCopy(_rayHit.pos);
         }
         else
         {
            normal.vCopy(Vector3.Z_AXIS);
            point.vCopy(spawnPosition);
            point.z -= 1000;
         }
      }
      
      public function get bonusId() : String
      {
         return this._bonusId;
      }
      
      public function isFalling() : Boolean
      {
         return this.bonusState == BonusState.FALLING;
      }
      
      public function readBonusPosition(result:Vector3) : void
      {
         result.x = this.skin.x;
         result.y = this.skin.y;
         result.z = this.skin.z;
      }
      
      public function setBonusPosition(x:Number, y:Number, z:Number) : void
      {
         this.skin.x = x;
         this.skin.y = y;
         this.skin.z = z;
      }
      
      public function setRestingState(x:Number, y:Number, z:Number) : void
      {
         this.setBonusPosition(x,y,z);
         if(this.bonusState != BonusState.RESTING)
         {
            this.bonusState = BonusState.RESTING;
            this.detachParachute();
         }
      }
      
      public function setTakenState() : void
      {
         this.takenAnimationTime = TAKEN_ANIMATION_TIME;
         this.skin.setAlpha(1);
         if(this.bonusState == BonusState.FALLING)
         {
            this.detachParachute();
         }
         this.bonusState = BonusState.TAKEN;
      }
      
      public function setRemovedState() : void
      {
         this.bonusState = BonusState.REMOVING;
      }
      
      public function attach(pos:Vector3, rigidWorld:PhysicsScene, container:Scene3DContainer, listener:IBonusListener) : void
      {
         var fallTime:Number = NaN;
         var minPivotZ:Number = NaN;
         var startingAngleZ:Number = NaN;
         this.light.x = pos.x;
         this.light.y = pos.y;
         this.light.z = pos.z - 400;
         if(container != null)
         {
            container.addChild(this.skin);
            BattlefieldModel(Main.osgi.getService(IBattleField)).hidableObjects.add(this.hidabbleWrapper);
         }
         if(this.bonusState == BonusState.FALLING)
         {
            this.parachute.x = pos.x;
            this.parachute.y = pos.y;
            this.parachute.z = pos.z + 0.5 * CORDS_LENGTH;
            container.addChild(this.parachute);
            container.addChild(this.cordsMesh);
            this.physicsState = PHYSICS_STATE_FULL;
         }
         else
         {
            this.physicsState = PHYSICS_STATE_BOX;
         }
         this.bonusListener = listener;
         this.getGroundPointAndNormal(pos,P,N);
         if(this.bonusState == BonusState.FALLING)
         {
            if(isFlatSurface(N))
            {
               fallTime = this.calculateFallTime(pos,P);
               P1.vCopy(P);
            }
            else
            {
               X.vCross2(N,Vector3.Z_AXIS);
               X.vNormalize();
               Y.vCross2(N,X);
               Y1.vCross2(Vector3.Z_AXIS,X);
               origin.vCopy(pos);
               origin.vAddScaled(-BonusConst.BONUS_HALF_SIZE,Y1);
               P1.vCopy(P);
               P1.vAddScaled(-BonusConst.BONUS_HALF_SIZE / N.z,Y);
               if(BattlefieldModel(Main.osgi.getService(IBattleField)).bfData.collisionDetector.raycastStatic(origin,Vector3.DOWN,CollisionGroup.STATIC,BIG_VALUE,_rayHit))
               {
                  if(P.z < _rayHit.pos.z && _rayHit.pos.z < P1.z)
                  {
                     P1.vAddScaled(BonusConst.BONUS_HALF_SIZE / N.z * (P1.z - _rayHit.pos.z) / (P1.z - P.z),Y);
                  }
               }
               fallTime = this.calculateFallTime(pos,P1);
               this.landingController.init(P1,N);
               this.landingControllerInited = true;
            }
            minPivotZ = P1.z + BonusConst.BONUS_HALF_SIZE + BonusConst.BONUS_OFFSET_Z;
            startingAngleZ = this.getStartingAngleZ();
            this.skin.x = pos.x;
            this.skin.y = pos.y;
            this.skin.z = pos.z;
            this.skin.rotationX = 0;
            this.skin.rotationY = 0;
            this.skin.rotationZ = startingAngleZ;
            this.updateTriggerFromMesh();
            this.fallController.init(pos,this.fallSpeed,minPivotZ,-fallTime,0,startingAngleZ);
         }
         this.trigger.activate(BattlefieldModel(Main.osgi.getService(IBattleField)));
      }
      
      private function updateTriggerFromMesh() : void
      {
         this.trigger.update(this.skin.x,this.skin.y,this.skin.z,this.skin.rotationX,this.skin.rotationY,this.skin.rotationZ);
      }
      
      public function onLandingComplete() : void
      {
         this.landingControllerInited = false;
      }
      
      private function getStartingAngleZ() : Number
      {
         return Math.PI * 10 * parseInt(this.bonusId.split("_")[1]) / 180;
      }
      
      private function calculateFallTime(spawnPosition:Vector3, groundTouchPoint:Vector3) : Number
      {
         return (spawnPosition.z - groundTouchPoint.z - BonusConst.BONUS_HALF_SIZE) / this.fallSpeed;
      }
      
      public function update(param1:int, param2:int, param3:Number) : Boolean
      {
         var _loc4_:int = 0;
         this.timeToLive -= param2;
         this.light.x = this.skin.x;
         this.light.y = this.skin.y;
         this.light.z = this.skin.z;
         if(this.bonusState == BonusState.FALLING)
         {
            for(_loc4_ = 0; _loc4_ < this.fallPrecision; _loc4_++)
            {
               this.fallController.runBeforePhysicsUpdate(param2 / this.fallPrecision);
               this.fallController.interpolatePhysicsState(param3);
               this.fallController.render();
            }
            return true;
         }
         if(this.bonusState == BonusState.TAKEN)
         {
            if(this.takenAnimationTime < 0)
            {
               return false;
            }
            this.playTakenAnimation(param2);
         }
         if(this.bonusState == BonusState.RESTING && this.landingControllerInited)
         {
            for(_loc4_ = 0; _loc4_ < this.landingPrecision; _loc4_++)
            {
               this.landingController.runBeforePhysicsUpdate(param2 / this.landingPrecision);
               this.landingController.interpolatePhysicsState(param3);
               this.landingController.render();
            }
         }
         if(this.parachuteTimeLeft > 0)
         {
            this.parachuteTimeLeft -= param2;
            if(this.parachuteTimeLeft <= 0)
            {
               this.removeParachuteGraphics();
               this.removeParachutePhysics();
            }
            else
            {
               this.cordsMesh.setAlpha(this.parachuteTimeLeft / PARACHUTE_REMOVAL_TIME);
               this.parachute.setAlpha(this.parachuteTimeLeft / PARACHUTE_REMOVAL_TIME);
               this.parachute.z -= this.fallSpeed / 2000 * param2;
               this.cordsMesh.updateVertices();
            }
         }
         if((this.bonusState == BonusState.RESTING || this.bonusState == BonusState.REMOVING) && this.timeToLive < WARNING_TIME)
         {
            this.playWarningAnimation(param1,param2);
         }
         if(this.bonusState == BonusState.REMOVING && this.timeToLive > WARNING_TIME)
         {
            return false;
         }
         return this.bonusState != BonusState.REMOVED;
      }
      
      public function destroy() : void
      {
         this.skin.alternativa3d::removeFromParent();
         this.skin.recycle();
         this.skin = null;
         BattlefieldModel(Main.osgi.getService(IBattleField)).hidableObjects.remove(this.hidabbleWrapper);
         if(this.skin != null)
         {
            this.skin = null;
         }
         this.removeParachuteGraphics();
         this.removeParachutePhysics();
         var _loc1_:* = this.pool.numObjects++;
         this.pool.objects[_loc1_] = this;
         this.trigger.deactivate();
      }
      
      public function considerCollision(primitive:CollisionPrimitive) : Boolean
      {
         if(primitive.body is Tank)
         {
            this.onTankCollision();
         }
         return false;
      }
      
      public function onTriggerActivated() : void
      {
         this.onTankCollision();
         this.setTakenState();
         this.trigger.deactivate();
      }
      
      public function onStaticCollision() : void
      {
         this.bonusState = BonusState.RESTING;
         this.detachParachute();
         if(this.bonusListener != null)
         {
            this.bonusListener.onBonusDropped(this);
         }
         if(this.landingControllerInited)
         {
            this.landingController.start();
         }
      }
      
      private function detachParachute() : void
      {
         this.startParachuteDissolving();
      }
      
      private function startParachuteDissolving() : void
      {
         this.parachuteTimeLeft = PARACHUTE_REMOVAL_TIME;
      }
      
      private function onTankCollision() : void
      {
         this.bonusListener.onTankCollision(this);
      }
      
      private function createParachuteAndCords(parachuteMesh:Mesh, parachuteInnerMesh:Mesh, cordsMaterial:Material) : void
      {
         if(BonusCache.isParachuteCacheEmpty())
         {
            this.parachute = new Parachute(parachuteMesh,parachuteInnerMesh);
         }
         else
         {
            this.parachute = BonusCache.getParachute();
         }
         if(BonusCache.isCordsCacheEmpty())
         {
            this.cordsMesh = new Cords(Parachute.RADIUS,BOX_HALF_SIZE,Parachute.NUM_STRAPS,cordsMaterial);
         }
         else
         {
            this.cordsMesh = BonusCache.getCords();
         }
         this.cordsMesh.init(this.skin,this.parachute);
      }
      
      private function removeParachuteGraphics() : void
      {
         if(this.parachute != null)
         {
            this.parachute.alternativa3d::removeFromParent();
            this.parachute.recycle();
            this.parachute = null;
         }
         if(this.cordsMesh != null)
         {
            this.cordsMesh.alternativa3d::removeFromParent();
            this.cordsMesh.recycle();
            this.cordsMesh = null;
         }
      }
      
      private function removeParachutePhysics() : void
      {
         if(this.physicsState == PHYSICS_STATE_PARABOX)
         {
            if(this.parachute != null)
            {
               this.parachute = null;
            }
            this.physicsState = PHYSICS_STATE_BOX;
         }
      }
      
      private function playWarningAnimation(time:int, deltaMsec:Number) : void
      {
         if(this.skin == null)
         {
            return;
         }
         if(this.visibilitySwitchTime == 0)
         {
            this.alphaSpeed = -COEFF * DELTA_ALPHA / this.currBlinkInterval;
            this.visibilitySwitchTime = time + this.currBlinkInterval;
         }
         else
         {
            this.skin.alpha += this.alphaSpeed * deltaMsec;
            if(this.bonusState == BonusState.REMOVING && this.alphaSpeed < 0)
            {
               if(this.skin.alpha <= 0)
               {
                  this.bonusState = BonusState.REMOVED;
               }
            }
            else
            {
               if(this.skin.alpha < MIN_ALPHA)
               {
                  this.skin.alpha = MIN_ALPHA;
               }
               if(time >= this.visibilitySwitchTime)
               {
                  if(this.currBlinkInterval > 22)
                  {
                     this.currBlinkInterval -= 12;
                  }
                  this.visibilitySwitchTime += this.currBlinkInterval;
                  if(this.alphaSpeed < 0)
                  {
                     this.alphaSpeed = COEFF * DELTA_ALPHA / this.currBlinkInterval;
                     this.skin.alpha = MIN_ALPHA;
                  }
                  else
                  {
                     this.alphaSpeed = -COEFF * DELTA_ALPHA / this.currBlinkInterval;
                     this.skin.alpha = 1;
                  }
               }
            }
         }
         if(this.currBlinkInterval < 22)
         {
            this.skin.alpha = 0;
         }
      }
      
      private function playTakenAnimation(millis:int) : void
      {
         var dt:Number = millis * 0.001;
         this.skin.z += (UP_SPEED * this.takenAnimationTime / TAKEN_ANIMATION_TIME + UP_SPEED * 0.1) * dt;
         this.skin.rotationZ += (ANGLE_SPEED * this.takenAnimationTime / TAKEN_ANIMATION_TIME + ANGLE_SPEED * 0.1) * dt;
         if(this.takenAnimationTime > TAKEN_ANIMATION_TIME - FLASH_DURATION)
         {
            this.additiveValue += ADDITIVE_SPEED_UP * millis;
            if(this.additiveValue > MAX_ADDITIVE_VALUE)
            {
               this.additiveValue = MAX_ADDITIVE_VALUE;
            }
         }
         else
         {
            this.additiveValue -= ADDITIVE_SPEED_DOWN * millis;
            if(this.additiveValue < 0)
            {
               this.additiveValue = 0;
            }
         }
         var colorTransform:ColorTransform = this.skin.colorTransform;
         if(colorTransform == null)
         {
            colorTransform = new ColorTransform();
            this.skin.colorTransform = colorTransform;
         }
         colorTransform.redOffset = this.additiveValue;
         colorTransform.blueOffset = this.additiveValue;
         colorTransform.greenOffset = this.additiveValue;
         if(this.takenAnimationTime < ALPHA_DURATION)
         {
            this.skin.alpha = this.takenAnimationTime / ALPHA_DURATION;
         }
         this.takenAnimationTime -= millis;
      }
   }
}

import alternativa.tanks.models.effects.common.bonuscommon.ParaBonus;

class Pool
{
    
   
   public var objects:Vector.<ParaBonus>;
   
   public var numObjects:int;
   
   function Pool()
   {
      this.objects = new Vector.<ParaBonus>();
      super();
   }
}
