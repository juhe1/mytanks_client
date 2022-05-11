package alternativa.tanks.models.battlefield.effects.levelup.rangs
{
   import flash.display.BitmapData;
   
   public class BigRangIcon
   {
      
[Embed(source="1183.png")]
      private static const rang_1:Class;
      
[Embed(source="1182.png")]
      private static const rang_2:Class;
      
[Embed(source="1181.png")]
      private static const rang_3:Class;
      
[Embed(source="1180.png")]
      private static const rang_4:Class;
      
      private static const rang_5:Class = BigRangIcon_rang_5;
      
      private static const rang_6:Class = BigRangIcon_rang_6;
      
      private static const rang_7:Class = BigRangIcon_rang_7;
      
      private static const rang_8:Class = BigRangIcon_rang_8;
      
      private static const rang_9:Class = BigRangIcon_rang_9;
      
[Embed(source="771.png")]
      private static const rang_10:Class;
      
[Embed(source="772.png")]
      private static const rang_11:Class;
      
[Embed(source="768.png")]
      private static const rang_12:Class;
      
[Embed(source="769.png")]
      private static const rang_13:Class;
      
[Embed(source="765.png")]
      private static const rang_14:Class;
      
[Embed(source="767.png")]
      private static const rang_15:Class;
      
[Embed(source="762.png")]
      private static const rang_16:Class;
      
[Embed(source="764.png")]
      private static const rang_17:Class;
      
[Embed(source="760.png")]
      private static const rang_18:Class;
      
[Embed(source="761.png")]
      private static const rang_19:Class;
      
[Embed(source="795.png")]
      private static const rang_20:Class;
      
[Embed(source="797.png")]
      private static const rang_21:Class;
      
[Embed(source="798.png")]
      private static const rang_22:Class;
      
[Embed(source="799.png")]
      private static const rang_23:Class;
      
[Embed(source="800.png")]
      private static const rang_24:Class;
      
[Embed(source="789.png")]
      private static const rang_25:Class;
      
[Embed(source="790.png")]
      private static const rang_26:Class;
      
[Embed(source="791.png")]
      private static const rang_27:Class;
      
[Embed(source="792.png")]
      private static const rang_28:Class;
      
[Embed(source="793.png")]
      private static const rang_29:Class;
      
[Embed(source="783.png")]
      private static const rang_30:Class;
      
      private static var rangs:Array = [new rang_1(),new rang_2(),new rang_3(),new rang_4(),new rang_5(),new rang_6(),new rang_7(),new rang_8(),new rang_9(),new rang_10(),new rang_11(),new rang_12(),new rang_13(),new rang_14(),new rang_15(),new rang_16(),new rang_17(),new rang_18(),new rang_19(),new rang_20(),new rang_21(),new rang_22(),new rang_23(),new rang_24(),new rang_25(),new rang_26(),new rang_27(),new rang_28(),new rang_29(),new rang_30()];
       
      
      public function BigRangIcon()
      {
         super();
      }
      
      public static function getRangIcon(rang:int) : BitmapData
      {
         return rangs[rang - 1].bitmapData;
      }
   }
}
