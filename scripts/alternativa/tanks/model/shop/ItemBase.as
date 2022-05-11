package alternativa.tanks.model.shop
{
   import flash.display.Sprite;
   
   public class ItemBase extends Sprite
   {
       
      
      private var _gridPosition:int;
      
      public function ItemBase()
      {
         super();
      }
      
      public function destroy() : void
      {
      }
      
      public function get gridPosition() : int
      {
         return this._gridPosition;
      }
      
      public function set gridPosition(param1:int) : void
      {
         this._gridPosition = param1;
      }
   }
}
