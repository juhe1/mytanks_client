package alternativa.tanks.model.gift.server
{
   public class GiftServerItem
   {
       
      
      public var id:String;
      
      public var rare:int;
      
      public var count:int;
      
      public function GiftServerItem(id:String, rare:int, count:int)
      {
         super();
         this.id = id;
         this.rare = rare;
         this.count = count;
      }
   }
}
