package alternativa.tanks.models.battlefield.effects.graffiti
{
   import flash.display.BitmapData;
   
   public class TexturesManager
   {
      
[Embed(source="940.png")]
      private static const graffiti_default:Class;
      
[Embed(source="770.png")]
      private static const graffiti_boo:Class;
      
[Embed(source="753.png")]
      private static const graffiti_fireball:Class;
      
[Embed(source="1152.png")]
      private static const graffiti_firegraff:Class;
      
[Embed(source="1046.png")]
      private static const graffiti_fart:Class;
      
[Embed(source="782.png")]
      private static const graffiti_gg:Class;
      
[Embed(source="845.png")]
      private static const graffiti_glhf:Class;
      
[Embed(source="979.png")]
      private static const graffiti_heart:Class;
      
[Embed(source="924.png")]
      private static const graffiti_music:Class;
      
[Embed(source="1007.png")]
      private static const graffiti_swag:Class;
      
[Embed(source="1168.png")]
      private static const graffiti_subwaytank:Class;
      
[Embed(source="1099.png")]
      private static const graffiti_money:Class;
       
      
      public function TexturesManager()
      {
         super();
      }
      
      public static function getBD(id:String) : BitmapData
      {
         switch(id)
         {
            case "graffiti_boo":
               return new graffiti_boo().bitmapData;
            case "graffiti_fireball":
               return new graffiti_fireball().bitmapData;
            case "graffiti_firegraff":
               return new graffiti_firegraff().bitmapData;
            case "graffiti_fart":
               return new graffiti_fart().bitmapData;
            case "graffiti_gg":
               return new graffiti_gg().bitmapData;
            case "graffiti_glhf":
               return new graffiti_glhf().bitmapData;
            case "graffiti_heart":
               return new graffiti_heart().bitmapData;
            case "graffiti_music":
               return new graffiti_music().bitmapData;
            case "graffiti_swag":
               return new graffiti_swag().bitmapData;
            case "graffiti_subwaytank":
               return new graffiti_subwaytank().bitmapData;
            case "graffiti_money":
               return new graffiti_money().bitmapData;
            default:
               return new graffiti_default().bitmapData;
         }
      }
   }
}
