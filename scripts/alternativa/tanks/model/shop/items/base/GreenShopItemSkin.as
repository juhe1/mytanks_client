package alternativa.tanks.model.shop.items.base
{
   public class GreenShopItemSkin extends ButtonItemSkin
   {
      
[Embed(source="1130.png")]
      private static const normalStateClass:Class;
      
[Embed(source="775.png")]
      private static const overStateClass:Class;
       
      
      public function GreenShopItemSkin()
      {
         super();
         normalState = new normalStateClass().bitmapData;
         overState = new overStateClass().bitmapData;
      }
   }
}
