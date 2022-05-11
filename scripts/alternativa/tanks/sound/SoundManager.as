package alternativa.tanks.sound
{
   import alternativa.math.Vector3;
   import alternativa.object.ClientObject;
   import alternativa.tanks.camera.GameCamera;
   import alternativa.tanks.sfx.ISound3DEffect;
   import flash.events.Event;
   import flash.media.Sound;
   import flash.media.SoundChannel;
   import flash.media.SoundTransform;
   import flash.utils.Dictionary;
   
   public class SoundManager implements ISoundManager
   {
       
      
      private var maxDistanceSqr:Number;
      
      private var maxSounds:int = 10;
      
      private var maxSounds3D:int = 20;
      
      private var effects:Vector.<SoundEffectData>;
      
      private var numEffects:int;
      
      private var sounds:Dictionary;
      
      private var numSounds:int;
      
      private var _position:Vector3;
      
      private var sortingStack:Vector.<int>;
      
      public function SoundManager()
      {
         this.effects = new Vector.<SoundEffectData>();
         this.sounds = new Dictionary();
         this._position = new Vector3();
         this.sortingStack = new Vector.<int>();
         super();
      }
      
      public static function createSoundManager(testSound:Sound) : ISoundManager
      {
         var channel:SoundChannel = testSound.play(0,1,new SoundTransform(0));
         if(channel != null)
         {
            channel.stop();
            return new SoundManager();
         }
         return new DummySoundManager();
      }
      
      public function set maxDistance(value:Number) : void
      {
         this.maxDistanceSqr = value * value;
      }
      
      public function playSound(sound:Sound, startTime:int = 0, loops:int = 0, soundTransform:SoundTransform = null) : SoundChannel
      {
         if(this.numSounds == this.maxSounds || sound == null)
         {
            return null;
         }
         var channel:SoundChannel = sound.play(startTime,loops,soundTransform);
         if(channel == null)
         {
            return null;
         }
         this.addSoundChannel(channel);
         return channel;
      }
      
      public function stopSound(channel:SoundChannel) : void
      {
         if(channel == null || this.sounds[channel] == null)
         {
            return;
         }
         this.removeSoundChannel(channel);
      }
      
      public function stopAllSounds() : void
      {
         var channel:* = undefined;
         for(channel in this.sounds)
         {
            this.removeSoundChannel(channel as SoundChannel);
         }
      }
      
      public function addEffect(effect:ISound3DEffect) : void
      {
         if(this.getEffectIndex(effect) > -1)
         {
            return;
         }
         effect.enabled = true;
         this.effects.push(SoundEffectData.create(0,effect));
         ++this.numEffects;
      }
      
      public function removeEffect(effect:ISound3DEffect) : void
      {
         var data:SoundEffectData = null;
         for(var i:int = 0; i < this.numEffects; i++)
         {
            data = this.effects[i];
            if(data.effect == effect)
            {
               effect.destroy();
               SoundEffectData.destroy(data);
               this.effects.splice(i,1);
               --this.numEffects;
               return;
            }
         }
      }
      
      public function removeAllEffects() : void
      {
         var data:SoundEffectData = null;
         while(this.effects.length > 0)
         {
            data = this.effects.pop();
            data.effect.destroy();
            SoundEffectData.destroy(data);
         }
         this.numEffects = 0;
      }
      
      public function updateSoundEffects(millis:int, camera:GameCamera) : void
      {
         var data:SoundEffectData = null;
         var i:int = 0;
         var numSounds:int = 0;
         if(this.numEffects == 0)
         {
            return;
         }
         this.sortEffects(camera.pos);
         var num:int = 0;
         for(i = 0; i < this.numEffects; i++)
         {
            data = this.effects[i];
            numSounds = data.effect.numSounds;
            if(numSounds == 0)
            {
               data.effect.destroy();
               SoundEffectData.destroy(data);
               this.effects.splice(i,1);
               --this.numEffects;
               i--;
            }
            else
            {
               if(data.distanceSqr > this.maxDistanceSqr || num + numSounds > this.maxSounds3D)
               {
                  break;
               }
               data.effect.enabled = true;
               data.effect.play(millis,camera);
               num += numSounds;
            }
         }
         while(i < this.numEffects)
         {
            data = this.effects[i];
            data.effect.enabled = false;
            if(data.effect.numSounds == 0)
            {
               data.effect.destroy();
               SoundEffectData.destroy(data);
               this.effects.splice(i,1);
               --this.numEffects;
               i--;
            }
            i++;
         }
      }
      
      public function killEffectsByOwner(owner:ClientObject) : void
      {
         var soundEffectData:SoundEffectData = null;
         var effect:ISound3DEffect = null;
         for(var i:int = 0; i < this.numEffects; i++)
         {
            soundEffectData = this.effects[i];
            effect = soundEffectData.effect;
            if(effect.owner == owner)
            {
               effect.kill();
            }
         }
      }
      
      private function addSoundChannel(channel:SoundChannel) : void
      {
         channel.addEventListener(Event.SOUND_COMPLETE,this.onSoundComplete);
         this.sounds[channel] = true;
         ++this.numSounds;
      }
      
      private function removeSoundChannel(channel:SoundChannel) : void
      {
         channel.stop();
         channel.removeEventListener(Event.SOUND_COMPLETE,this.onSoundComplete);
         delete this.sounds[channel];
         --this.numSounds;
      }
      
      private function onSoundComplete(e:Event) : void
      {
         this.stopSound(e.target as SoundChannel);
      }
      
      private function getEffectIndex(effect:ISound3DEffect) : int
      {
         for(var i:int = 0; i < this.numEffects; i++)
         {
            if(SoundEffectData(this.effects[i]).effect == effect)
            {
               return i;
            }
         }
         return -1;
      }
      
      private function sortEffects(cameraPos:Vector3) : void
      {
         var i:int = 0;
         var j:int = 0;
         var sortingStackIndex:int = 0;
         var sortingMedian:Number = NaN;
         var data:SoundEffectData = null;
         var sortingLeft:SoundEffectData = null;
         var sortingRight:SoundEffectData = null;
         var dx:Number = NaN;
         var dy:Number = NaN;
         var dz:Number = NaN;
         var left:int = 0;
         var right:int = this.numEffects - 1;
         for(i = 0; i < this.numEffects; i++)
         {
            data = this.effects[i];
            data.effect.readPosition(this._position);
            dx = cameraPos.x - this._position.x;
            dy = cameraPos.y - this._position.y;
            dz = cameraPos.z - this._position.z;
            data.distanceSqr = dx * dx + dy * dy + dz * dz;
         }
         if(this.numEffects == 1)
         {
            return;
         }
         this.sortingStack[0] = left;
         this.sortingStack[1] = right;
         sortingStackIndex = 2;
         while(sortingStackIndex > 0)
         {
            j = right = this.sortingStack[--sortingStackIndex];
            sortingMedian = SoundEffectData(this.effects[right + (i = int(this.sortingStack[--sortingStackIndex])) >> 1]).distanceSqr;
            do
            {
               while((sortingLeft = this.effects[i]).distanceSqr < sortingMedian)
               {
                  i++;
               }
               while((sortingRight = this.effects[j]).distanceSqr > sortingMedian)
               {
                  j--;
               }
               if(i <= j)
               {
                  var _loc14_:* = i++;
                  this.effects[_loc14_] = sortingRight;
                  var _loc15_:* = j--;
                  this.effects[_loc15_] = sortingLeft;
               }
            }
            while(i <= j);
            
            if(left < j)
            {
               _loc14_ = sortingStackIndex++;
               this.sortingStack[_loc14_] = left;
               _loc15_ = sortingStackIndex++;
               this.sortingStack[_loc15_] = j;
            }
            if(i < right)
            {
               _loc14_ = sortingStackIndex++;
               this.sortingStack[_loc14_] = i;
               _loc15_ = sortingStackIndex++;
               this.sortingStack[_loc15_] = right;
            }
         }
      }
   }
}

import alternativa.tanks.sfx.ISound3DEffect;

class SoundEffectData
{
   
   private static var pool:Vector.<SoundEffectData> = new Vector.<SoundEffectData>();
   
   private static var numObjects:int;
    
   
   public var distanceSqr:Number;
   
   public var effect:ISound3DEffect;
   
   function SoundEffectData(distanceSqr:Number, effect:ISound3DEffect)
   {
      super();
      this.distanceSqr = distanceSqr;
      this.effect = effect;
   }
   
   public static function create(distanceSqr:Number, effect:ISound3DEffect) : SoundEffectData
   {
      var data:SoundEffectData = null;
      if(numObjects > 0)
      {
         data = pool[--numObjects];
         pool[numObjects] = null;
         data.distanceSqr = distanceSqr;
         data.effect = effect;
         return data;
      }
      return new SoundEffectData(distanceSqr,effect);
   }
   
   public static function destroy(data:SoundEffectData) : void
   {
      data.effect = null;
      var _loc2_:* = numObjects++;
      pool[_loc2_] = data;
   }
}
