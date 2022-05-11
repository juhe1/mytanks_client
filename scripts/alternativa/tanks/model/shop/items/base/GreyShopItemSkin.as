package alternativa.tanks.model.shop.items.base
{
   public class GreyShopItemSkin extends ButtonItemSkin
   {
      
[Embed(source="1156.png")]
      private static const normalStateClass:Class;
      
[Embed(source="1037.png")]
      private static const overStateClass:Class;
       
      
      public function GreyShopItemSkin()
      {
         super();
         normalState = new normalStateClass().bitmapData;
         overState = new overStateClass().bitmapData;
      }
   }
}
