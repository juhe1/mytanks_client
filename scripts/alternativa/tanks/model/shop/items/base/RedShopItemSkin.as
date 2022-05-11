package alternativa.tanks.model.shop.items.base
{
   public class RedShopItemSkin extends ButtonItemSkin
   {
      
[Embed(source="1056.png")]
      private static const normalStateClass:Class;
      
[Embed(source="822.png")]
      private static const overStateClass:Class;
       
      
      public function RedShopItemSkin()
      {
         super();
         normalState = new normalStateClass().bitmapData;
         overState = new overStateClass().bitmapData;
      }
   }
}
