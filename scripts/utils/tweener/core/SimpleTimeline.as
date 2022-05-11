package utils.tweener.core
{
   public class SimpleTimeline extends TweenCore
   {
       
      
      protected var _firstChild:TweenCore;
      
      protected var _lastChild:TweenCore;
      
      public var autoRemoveChildren:Boolean;
      
      public function SimpleTimeline(param1:Object = null)
      {
         super(0,param1);
      }
      
      public function insert(param1:TweenCore, param2:* = 0) : TweenCore
      {
         var _loc3_:SimpleTimeline = param1.timeline;
         if(!param1.cachedOrphan && _loc3_)
         {
            _loc3_.remove(param1,true);
         }
         param1.timeline = this;
         param1.cachedStartTime = Number(param2) + param1.delay;
         if(param1.gc)
         {
            param1.setEnabled(true,true);
         }
         if(param1.cachedPaused && _loc3_ != this)
         {
            param1.cachedPauseTime = param1.cachedStartTime + (this.rawTime - param1.cachedStartTime) / param1.cachedTimeScale;
         }
         if(this._lastChild)
         {
            this._lastChild.nextNode = param1;
         }
         else
         {
            this._firstChild = param1;
         }
         param1.prevNode = this._lastChild;
         this._lastChild = param1;
         param1.nextNode = null;
         param1.cachedOrphan = false;
         return param1;
      }
      
      public function remove(param1:TweenCore, param2:Boolean = false) : void
      {
         if(param1.cachedOrphan)
         {
            return;
         }
         if(!param2)
         {
            param1.setEnabled(false,true);
         }
         if(param1.nextNode)
         {
            param1.nextNode.prevNode = param1.prevNode;
         }
         else if(this._lastChild == param1)
         {
            this._lastChild = param1.prevNode;
         }
         if(param1.prevNode)
         {
            param1.prevNode.nextNode = param1.nextNode;
         }
         else if(this._firstChild == param1)
         {
            this._firstChild = param1.nextNode;
         }
         param1.cachedOrphan = true;
      }
      
      override public function renderTime(param1:Number, param2:Boolean = false, param3:Boolean = false) : void
      {
         var _loc4_:Number = NaN;
         var _loc5_:TweenCore = null;
         var _loc6_:TweenCore = this._firstChild;
         this.cachedTotalTime = param1;
         this.cachedTime = param1;
         while(_loc6_)
         {
            _loc5_ = _loc6_.nextNode;
            if(_loc6_.active || param1 >= _loc6_.cachedStartTime && !_loc6_.cachedPaused && !_loc6_.gc)
            {
               if(!_loc6_.cachedReversed)
               {
                  _loc6_.renderTime((param1 - _loc6_.cachedStartTime) * _loc6_.cachedTimeScale,param2,false);
               }
               else
               {
                  _loc4_ = !!_loc6_.cacheIsDirty ? Number(Number(Number(_loc6_.totalDuration))) : Number(Number(Number(_loc6_.cachedTotalDuration)));
                  _loc6_.renderTime(_loc4_ - (param1 - _loc6_.cachedStartTime) * _loc6_.cachedTimeScale,param2,false);
               }
            }
            _loc6_ = _loc5_;
         }
      }
      
      public function get rawTime() : Number
      {
         return this.cachedTotalTime;
      }
   }
}
