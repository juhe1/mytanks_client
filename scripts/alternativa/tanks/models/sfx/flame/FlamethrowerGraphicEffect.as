package alternativa.tanks.models.sfx.flame
{
   import alternativa.console.ConsoleVarFloat;
   import alternativa.engine3d.core.Object3D;
   import alternativa.math.Matrix3;
   import alternativa.math.Vector3;
   import alternativa.object.ClientObject;
   import alternativa.physics.collision.types.RayIntersection;
   import alternativa.tanks.camera.GameCamera;
   import alternativa.tanks.engine3d.TextureAnimation;
   import alternativa.tanks.models.battlefield.scene3dcontainer.Scene3DContainer;
   import alternativa.tanks.models.tank.TankData;
   import alternativa.tanks.models.weapon.weakening.IWeaponWeakeningModel;
   import alternativa.tanks.physics.CollisionGroup;
   import alternativa.tanks.physics.TanksCollisionDetector;
   import alternativa.tanks.sfx.IGraphicEffect;
   import alternativa.tanks.utils.objectpool.ObjectPool;
   import alternativa.tanks.utils.objectpool.PooledObject;
   import flash.utils.getTimer;
   
   public class FlamethrowerGraphicEffect extends PooledObject implements IGraphicEffect
   {
      
      private static const ANIMATION_FPS:Number = 30;
      
      private static const START_SCALE:Number = 0.5;
      
      private static const END_SCALE:Number = 4;
      
      private static var particleBaseSize:ConsoleVarFloat = new ConsoleVarFloat("flame_base_size",100,1,1000);
      
      private static var matrix:Matrix3 = new Matrix3();
      
      private static var particlePosition:Vector3 = new Vector3();
      
      private static var barrelOrigin:Vector3 = new Vector3();
      
      private static var gunDirection:Vector3 = new Vector3();
      
      private static var xAxis:Vector3 = new Vector3();
      
      private static var globalMuzzlePosition:Vector3 = new Vector3();
      
      private static var intersection:RayIntersection = new RayIntersection();
       
      
      private var range:Number;
      
      private var scalePerDistance:Number;
      
      private var coneHalfAngleTan:Number;
      
      private var maxParticles:int;
      
      private var particleSpeed:Number;
      
      private var localMuzzlePosition:Vector3;
      
      private var turret:Object3D;
      
      private var sfxData:FlamethrowerSFXData;
      
      private var container:Scene3DContainer;
      
      private var particles:Vector.<Particle>;
      
      private var numParticles:int;
      
      private var numFrames:int;
      
      private var collisionDetector:TanksCollisionDetector;
      
      private var dead:Boolean;
      
      private var emissionDelta:int;
      
      private var nextEmissionTime:int;
      
      private var time:int;
      
      private var collisionGroup:int = 16;
      
      private var weakeningModel:IWeaponWeakeningModel;
      
      private var shooterData:TankData;
      
      private var animatedTexture:TextureAnimation;
      
      public function FlamethrowerGraphicEffect(objectPool:ObjectPool)
      {
         this.localMuzzlePosition = new Vector3();
         this.particles = new Vector.<Particle>();
         super(objectPool);
      }
      
      public function init(shooterData:TankData, range:Number, coneAngle:Number, maxParticles:int, particleSpeed:Number, muzzleLocalPos:Vector3, turret:Object3D, sfxData:FlamethrowerSFXData, collisionDetector:TanksCollisionDetector, weakeningModel:IWeaponWeakeningModel) : void
      {
         this.shooterData = shooterData;
         this.range = range;
         this.scalePerDistance = 2 * (END_SCALE - START_SCALE) / range;
         this.coneHalfAngleTan = Math.tan(0.5 * coneAngle);
         this.maxParticles = maxParticles;
         this.particleSpeed = particleSpeed;
         this.localMuzzlePosition.vCopy(muzzleLocalPos);
         this.turret = turret;
         this.sfxData = sfxData;
         this.collisionDetector = collisionDetector;
         this.weakeningModel = weakeningModel;
         this.numFrames = sfxData.materials.length;
         this.emissionDelta = 1000 * range / (maxParticles * particleSpeed);
         this.time = this.nextEmissionTime = getTimer();
         this.particles.length = maxParticles;
         this.dead = false;
         this.animatedTexture = sfxData.data;
      }
      
      public function get owner() : ClientObject
      {
         return null;
      }
      
      public function addToContainer(container:Scene3DContainer) : void
      {
         this.container = container;
      }
      
      public function play(millis:int, camera:GameCamera) : Boolean
      {
         var particle:Particle = null;
         particle = null;
         var velocity:Vector3 = null;
         var scale:Number = NaN;
         var size:Number = NaN;
         if(!this.dead && this.numParticles < this.maxParticles && this.time >= this.nextEmissionTime)
         {
            this.nextEmissionTime += this.emissionDelta;
            this.tryToAddParticle();
         }
         var dt:Number = 0.001 * millis;
         for(var i:int = 0; i < this.numParticles; i++)
         {
            particle = this.particles[i];
            particlePosition.x = particle.x;
            particlePosition.y = particle.y;
            particlePosition.z = particle.z;
            if(particle.distance > this.range || this.collisionDetector.intersectRayWithStatic(particlePosition,particle.velocity,this.collisionGroup,dt,null,intersection))
            {
               this.removeParticle(i--);
            }
            else
            {
               velocity = particle.velocity;
               particle.x += dt * velocity.x;
               particle.y += dt * velocity.y;
               particle.z += dt * velocity.z;
               particle.distance += this.particleSpeed * dt;
               particle.update(dt);
               scale = START_SCALE + this.scalePerDistance * particle.distance;
               if(scale > END_SCALE)
               {
                  scale = END_SCALE;
               }
               size = scale * particleBaseSize.value;
               particle.width = size;
               particle.height = size;
               particle.updateColorTransofrm(this.range,this.sfxData.colorTransformPoints);
            }
         }
         this.time += millis;
         return !this.dead || this.numParticles > 0;
      }
      
      public function destroy() : void
      {
         while(this.numParticles > 0)
         {
            this.removeParticle(0);
         }
         this.collisionDetector = null;
         this.turret = null;
         this.shooterData = null;
         this.sfxData = null;
      }
      
      public function kill() : void
      {
         this.dead = true;
      }
      
      override protected function getClass() : Class
      {
         return FlamethrowerGraphicEffect;
      }
      
      private function tryToAddParticle() : void
      {
         var offset:Number = NaN;
         var barrelLength:Number = NaN;
         matrix.setRotationMatrix(this.turret.rotationX,this.turret.rotationY,this.turret.rotationZ);
         barrelOrigin.x = 0;
         barrelOrigin.y = 0;
         barrelOrigin.z = this.localMuzzlePosition.z;
         barrelOrigin.vTransformBy3(matrix);
         barrelOrigin.x += this.turret.x;
         barrelOrigin.y += this.turret.y;
         barrelOrigin.z += this.turret.z;
         gunDirection.x = matrix.b;
         gunDirection.y = matrix.f;
         gunDirection.z = matrix.j;
         offset = Math.random() * 50;
         if(!this.collisionDetector.intersectRayWithStatic(barrelOrigin,gunDirection,CollisionGroup.STATIC,this.localMuzzlePosition.y + offset,null,intersection))
         {
            barrelLength = this.localMuzzlePosition.y;
            globalMuzzlePosition.x = barrelOrigin.x + gunDirection.x * barrelLength;
            globalMuzzlePosition.y = barrelOrigin.y + gunDirection.y * barrelLength;
            globalMuzzlePosition.z = barrelOrigin.z + gunDirection.z * barrelLength;
            xAxis.x = matrix.a;
            xAxis.y = matrix.e;
            xAxis.z = matrix.i;
            this.addParticle(globalMuzzlePosition,gunDirection,xAxis,offset);
         }
      }
      
      private function addParticle(globalMuzzlePosition:Vector3, direction:Vector3, gunAxisX:Vector3, offset:Number) : void
      {
         var particle:Particle = null;
         particle = Particle.getParticle(this.animatedTexture);
         particle.currFrame = Math.random() * this.numFrames;
         var angle:Number = 2 * Math.PI * Math.random();
         matrix.fromAxisAngle(direction,angle);
         gunAxisX.vTransformBy3(matrix);
         var d:Number = this.range * this.coneHalfAngleTan * Math.random();
         direction.x = direction.x * this.range + gunAxisX.x * d;
         direction.y = direction.y * this.range + gunAxisX.y * d;
         direction.z = direction.z * this.range + gunAxisX.z * d;
         direction.vNormalize();
         particle.velocity.x = this.particleSpeed * direction.x;
         particle.velocity.y = this.particleSpeed * direction.y;
         particle.velocity.z = this.particleSpeed * direction.z;
         particle.velocity.vAdd(this.shooterData.tank.state.velocity);
         particle.distance = offset;
         particle.x = globalMuzzlePosition.x + offset * direction.x;
         particle.y = globalMuzzlePosition.y + offset * direction.y;
         particle.z = globalMuzzlePosition.z + offset * direction.z;
         var _loc8_:* = this.numParticles++;
         this.particles[_loc8_] = particle;
         this.container.addChild(particle);
      }
      
      private function removeParticle(index:int) : void
      {
         var particle:Particle = this.particles[index];
         this.particles[index] = this.particles[--this.numParticles];
         this.particles[this.numParticles] = null;
         particle.dispose();
         particle.destroy();
         particle = null;
      }
   }
}

import alternativa.engine3d.alternativa3d;
import alternativa.math.Vector3;
import alternativa.tanks.engine3d.AnimatedSprite3D;
import alternativa.tanks.engine3d.TextureAnimation;
import alternativa.tanks.models.sfx.colortransform.ColorTransformEntry;
import flash.geom.ColorTransform;

class Particle extends AnimatedSprite3D
{
   
   private static var INITIAL_POOL_SIZE:int = 20;
   
   private static var pool:Vector.<Particle> = new Vector.<Particle>(INITIAL_POOL_SIZE);
   
   private static var poolIndex:int = -1;
    
   
   public var velocity:Vector3;
   
   public var distance:Number = 0;
   
   public var currFrame:Number;
   
   function Particle(animData:TextureAnimation)
   {
      this.velocity = new Vector3();
      super(100,100);
      colorTransform = new ColorTransform();
      this.softAttenuation = 140;
      super.setAnimationData(animData);
      super.setFrameIndex(0);
      super.looped = true;
   }
   
   public static function getParticle(animData:TextureAnimation) : Particle
   {
      return new Particle(animData);
   }
   
   public function dispose() : void
   {
      alternativa3d::removeFromParent();
      material = null;
      var _loc1_:* = ++poolIndex;
      pool[_loc1_] = this;
   }
   
   public function updateColorTransofrm(maxDistance:Number, points:Vector.<ColorTransformEntry>) : void
   {
      var point1:ColorTransformEntry = null;
      var point2:ColorTransformEntry = null;
      var i:int = 0;
      if(points == null)
      {
         return;
      }
      var t:Number = this.distance / maxDistance;
      if(t <= 0)
      {
         point1 = points[0];
         this.copyStructToColorTransform(point1,colorTransform);
      }
      else if(t >= 1)
      {
         point1 = points[points.length - 1];
         this.copyStructToColorTransform(point1,colorTransform);
      }
      else
      {
         i = 1;
         point1 = points[0];
         point2 = points[1];
         while(point2.t < t)
         {
            i++;
            point1 = point2;
            point2 = points[i];
         }
         t = (t - point1.t) / (point2.t - point1.t);
         this.interpolateColorTransform(point1,point2,t,colorTransform);
      }
      alpha = colorTransform.alphaMultiplier;
   }
   
   private function interpolateColorTransform(ct1:ColorTransformEntry, ct2:ColorTransformEntry, t:Number, result:ColorTransform) : void
   {
      result.alphaMultiplier = ct1.alphaMultiplier + t * (ct2.alphaMultiplier - ct1.alphaMultiplier);
      result.alphaOffset = ct1.alphaOffset + t * (ct2.alphaOffset - ct1.alphaOffset);
      result.redMultiplier = ct1.redMultiplier + t * (ct2.redMultiplier - ct1.redMultiplier);
      result.redOffset = ct1.redOffset + t * (ct2.redOffset - ct1.redOffset);
      result.greenMultiplier = ct1.greenMultiplier + t * (ct2.greenMultiplier - ct1.greenMultiplier);
      result.greenOffset = ct1.greenOffset + t * (ct2.greenOffset - ct1.greenOffset);
      result.blueMultiplier = ct1.blueMultiplier + t * (ct2.blueMultiplier - ct1.blueMultiplier);
      result.blueOffset = ct1.blueOffset + t * (ct2.blueOffset - ct1.blueOffset);
   }
   
   private function copyStructToColorTransform(source:ColorTransformEntry, result:ColorTransform) : void
   {
      result.alphaMultiplier = source.alphaMultiplier;
      result.alphaOffset = source.alphaOffset;
      result.redMultiplier = source.redMultiplier;
      result.redOffset = source.redOffset;
      result.greenMultiplier = source.greenMultiplier;
      result.greenOffset = source.greenOffset;
      result.blueMultiplier = source.blueMultiplier;
      result.blueOffset = source.blueOffset;
   }
}
