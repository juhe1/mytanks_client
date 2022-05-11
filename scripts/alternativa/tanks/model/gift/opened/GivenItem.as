package alternativa.tanks.model.gift.opened
{
   import flash.display.BitmapData;
   
   public class GivenItem
   {
       
      
      public var preview:BitmapData;
      
      public var itemName:String;
      
      public var rarity:int;
      
      public function GivenItem(preview:BitmapData, itemName:String, rarity:int)
      {
         super();
         this.preview = preview;
         this.itemName = itemName;
         this.rarity = rarity;
      }
   }
}
