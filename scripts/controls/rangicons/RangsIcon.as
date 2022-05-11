package controls.rangicons
{
   import flash.display.BitmapData;
   import flash.display.DisplayObject;
   import flash.display.MovieClip;
   
   public class RangsIcon extends RangIcon
   {
      
      private static const p1:Class = RangsIcon_p1;
      
      private static const p2:Class = RangsIcon_p2;
      
      private static const p3:Class = RangsIcon_p3;
      
      private static const p4:Class = RangsIcon_p4;
      
      private static const p5:Class = RangsIcon_p5;
      
      private static const p6:Class = RangsIcon_p6;
      
      private static const p7:Class = RangsIcon_p7;
      
      private static const p8:Class = RangsIcon_p8;
      
      private static const p9:Class = RangsIcon_p9;
      
      private static const p10:Class = RangsIcon_p10;
      
      private static const p11:Class = RangsIcon_p11;
      
      private static const p12:Class = RangsIcon_p12;
      
      private static const p13:Class = RangsIcon_p13;
      
      private static const p14:Class = RangsIcon_p14;
      
      private static const p15:Class = RangsIcon_p15;
      
      private static const p16:Class = RangsIcon_p16;
      
      private static const p17:Class = RangsIcon_p17;
      
      private static const p18:Class = RangsIcon_p18;
      
      private static const p19:Class = RangsIcon_p19;
      
      private static const p20:Class = RangsIcon_p20;
      
      private static const p21:Class = RangsIcon_p21;
      
      private static const p22:Class = RangsIcon_p22;
      
      private static const p23:Class = RangsIcon_p23;
      
      private static const p24:Class = RangsIcon_p24;
      
      private static const p25:Class = RangsIcon_p25;
      
      private static const p26:Class = RangsIcon_p26;
      
      private static const p27:Class = RangsIcon_p27;
      
      private static const p28:Class = RangsIcon_p28;
      
      private static const p29:Class = RangsIcon_p29;
      
      private static const p30:Class = RangsIcon_p30;
      
      private static var rangs:Array = [new p1(),new p2(),new p3(),new p4(),new p5(),new p6(),new p7(),new p8(),new p9(),new p10(),new p11(),new p12(),new p13(),new p14(),new p15(),new p16(),new p17(),new p18(),new p19(),new p20(),new p21(),new p22(),new p23(),new p24(),new p25(),new p26(),new p27(),new p28(),new p29(),new p30()];
       
      
      public var g:MovieClip;
      
      private var gl:DisplayObject;
      
      private var rangs1:Array;
      
      public function RangsIcon()
      {
         this.rangs1 = [new p1(),new p2(),new p3(),new p4(),new p5(),new p6(),new p7(),new p8(),new p9(),new p10(),new p11(),new p12(),new p13(),new p14(),new p15(),new p16(),new p17(),new p18(),new p19(),new p20(),new p21(),new p22(),new p23(),new p24(),new p25(),new p26(),new p27(),new p28(),new p29(),new p30()];
         super();
      }
      
      public static function getBD(param1:int) : BitmapData
      {
         return rangs[param1 - 1].bitmapData;
      }
      
      public function RangIconNormal(param1:int = 1) : *
      {
      }
   }
}
