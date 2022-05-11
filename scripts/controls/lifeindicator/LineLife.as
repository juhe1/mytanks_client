package controls.lifeindicator
{
   public class LineLife extends HorizontalBar
   {
      
[Embed(source="850.png")]
      private static const bitmapLeft:Class;
      
[Embed(source="1150.png")]
      private static const bitmapCenter:Class;
      
[Embed(source="909.png")]
      private static const bitmapRight:Class;
       
      
      public function LineLife()
      {
         super(new bitmapLeft().bitmapData,new bitmapCenter().bitmapData,new bitmapRight().bitmapData);
      }
   }
}
