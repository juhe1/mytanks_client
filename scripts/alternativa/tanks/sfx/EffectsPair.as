package alternativa.tanks.sfx
{
   public class EffectsPair
   {
       
      
      public var graphicEffect:IGraphicEffect;
      
      public var soundEffect:ISound3DEffect;
      
      public var muzzleLightEffect;
      
      public var lightEffect;
      
      public function EffectsPair(graphicEffect:IGraphicEffect, soundEffect:ISound3DEffect, muzzleLightEffect:* = null, lightEffect:* = null)
      {
         super();
         this.graphicEffect = graphicEffect;
         this.soundEffect = soundEffect;
         this.muzzleLightEffect = muzzleLightEffect;
         this.lightEffect = lightEffect;
      }
   }
}
