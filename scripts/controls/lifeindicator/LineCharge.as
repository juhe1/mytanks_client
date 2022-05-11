package controls.lifeindicator
{
   public class LineCharge extends HorizontalBar
   {
      
[Embed(source="844.png")]
      private static const bitmapLeft:Class;
      
[Embed(source="1163.png")]
      private static const bitmapCenter:Class;
      
[Embed(source="1210.png")]
      private static const bitmapRight:Class;
       
      
      public function LineCharge()
      {
         super(new bitmapLeft().bitmapData,new bitmapCenter().bitmapData,new bitmapRight().bitmapData);
      }
   }
}
