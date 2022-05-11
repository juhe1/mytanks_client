package controls.rangicons
{
   import flash.display.Bitmap;
   import flash.display.DisplayObject;
   import flash.display.MovieClip;
   
   public class RangIconNormal extends RangIcon
   {
      
[Embed(source="863.png")]
      private static const p1:Class;
      
[Embed(source="864.png")]
      private static const p2:Class;
      
[Embed(source="861.png")]
      private static const p3:Class;
      
[Embed(source="862.png")]
      private static const p4:Class;
      
[Embed(source="855.png")]
      private static const p5:Class;
      
[Embed(source="856.png")]
      private static const p6:Class;
      
[Embed(source="853.png")]
      private static const p7:Class;
      
[Embed(source="854.png")]
      private static const p8:Class;
      
[Embed(source="858.png")]
      private static const p9:Class;
      
      private static const p10:Class = RangIconNormal_p10;
      
      private static const p11:Class = RangIconNormal_p11;
      
      private static const p12:Class = RangIconNormal_p12;
      
      private static const p13:Class = RangIconNormal_p13;
      
      private static const p14:Class = RangIconNormal_p14;
      
      private static const p15:Class = RangIconNormal_p15;
      
      private static const p16:Class = RangIconNormal_p16;
      
      private static const p17:Class = RangIconNormal_p17;
      
      private static const p18:Class = RangIconNormal_p18;
      
      private static const p19:Class = RangIconNormal_p19;
      
      private static const p20:Class = RangIconNormal_p20;
      
      private static const p21:Class = RangIconNormal_p21;
      
      private static const p22:Class = RangIconNormal_p22;
      
      private static const p23:Class = RangIconNormal_p23;
      
      private static const p24:Class = RangIconNormal_p24;
      
      private static const p25:Class = RangIconNormal_p25;
      
      private static const p26:Class = RangIconNormal_p26;
      
[Embed(source="963.png")]
      private static const p27:Class;
      
[Embed(source="964.png")]
      private static const p28:Class;
      
[Embed(source="965.png")]
      private static const p29:Class;
      
[Embed(source="960.png")]
      private static const p30:Class;
       
      
      public var g:MovieClip;
      
      private var gl:DisplayObject;
      
      private var rangs1:Array;
      
      public function RangIconNormal(param1:int = 1)
      {
         this.rangs1 = [new p1(),new p2(),new p3(),new p4(),new p5(),new p6(),new p7(),new p8(),new p9(),new p10(),new p11(),new p12(),new p13(),new p14(),new p15(),new p16(),new p17(),new p18(),new p19(),new p20(),new p21(),new p22(),new p23(),new p24(),new p25(),new p26(),new p27(),new p28(),new p29(),new p30()];
         addFrameScript(0,this.frame1);
         super(param1);
         this.removeChildren();
         this._rang = param1;
         this.addChild(new Bitmap(this.rangs1[param1 - 1].bitmapData));
      }
      
      public function set glow(param1:Boolean) : void
      {
         this.gl.visible = param1;
      }
      
      public function set rang1(param1:int) : void
      {
         this.removeChildren();
         this._rang = param1;
         this.addChild(new Bitmap(this.rangs1[param1 - 1].bitmapData));
      }
      
      private function frame1() : void
      {
         stop();
      }
   }
}
