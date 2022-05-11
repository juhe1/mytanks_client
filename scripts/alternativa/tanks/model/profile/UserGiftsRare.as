package alternativa.tanks.model.profile
{
   public class UserGiftsRare
   {
       
      
      public function UserGiftsRare()
      {
         super();
      }
      
      public static function getRare(name:String) : int
      {
         if(name == "Обычный")
         {
            return 0;
         }
         if(name == "Редкий")
         {
            return 1;
         }
         if(name == "Уникаль.")
         {
            return 2;
         }
         return 0;
      }
   }
}
