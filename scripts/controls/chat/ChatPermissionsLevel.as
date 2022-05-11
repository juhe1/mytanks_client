package controls.chat
{
   import flash.display.BitmapData;
   import flash.display.MovieClip;
   
   public class ChatPermissionsLevel extends MovieClip
   {
      
[Embed(source="1119.png")]
      private static const developer:Class;
      
[Embed(source="1161.png")]
      private static const admin:Class;
      
[Embed(source="928.png")]
      private static const moder:Class;
      
[Embed(source="1088.png")]
      private static const candidate:Class;
      
[Embed(source="968.png")]
      private static const event:Class;
      
[Embed(source="882.png")]
      private static const event_org:Class;
      
[Embed(source="1160.png")]
      private static const cm:Class;
      
[Embed(source="776.png")]
      private static const tester:Class;
      
[Embed(source="1066.png")]
      private static const tester_gold:Class;
      
[Embed(source="1042.png")]
      private static const sponsor:Class;
       
      
      public function ChatPermissionsLevel()
      {
         super();
      }
      
      public static function getBD(id:int) : BitmapData
      {
         switch(id)
         {
            case 1:
               return new developer().bitmapData;
            case 2:
               return new admin().bitmapData;
            case 3:
               return new moder().bitmapData;
            case 4:
               return new candidate().bitmapData;
            case 5:
               return new event().bitmapData;
            case 6:
               return new event_org().bitmapData;
            case 7:
               return new cm().bitmapData;
            case 8:
               return new tester().bitmapData;
            case 9:
               return new tester_gold().bitmapData;
            case 10:
               return new sponsor().bitmapData;
            default:
               return new admin().bitmapData;
         }
      }
   }
}
