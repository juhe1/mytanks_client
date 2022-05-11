package com.alternativaplatform.projects.tanks.client.warfare.models.colortransform.struct
{
   public class ColorTransformStruct
   {
       
      
      public var t:Number = 0;
      
      public var redMultiplier:Number = 0;
      
      public var greenMultiplier:Number = 0;
      
      public var blueMultiplier:Number = 0;
      
      public var alphaMultiplier:Number = 0;
      
      public var redOffset:int = 0;
      
      public var greenOffset:int = 0;
      
      public var blueOffset:int = 0;
      
      public var alphaOffset:int = 0;
      
      public function ColorTransformStruct(t:Number, redMultiplier:Number, greenMultiplier:Number, blueMultiplier:Number, alphaMultiplier:Number, redOffset:int, greenOffset:int, blueOffset:int, alphaOffset:int)
      {
         super();
         this.t = t;
         this.redMultiplier = redMultiplier;
         this.greenMultiplier = greenMultiplier;
         this.blueMultiplier = blueMultiplier;
         this.alphaMultiplier = alphaMultiplier;
         this.redOffset = redOffset;
         this.greenOffset = greenOffset;
         this.blueOffset = blueOffset;
         this.alphaOffset = alphaOffset;
      }
   }
}
