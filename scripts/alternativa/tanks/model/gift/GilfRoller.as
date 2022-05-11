package alternativa.tanks.model.gift
{
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.Sprite;
   
   public class GilfRoller extends Sprite
   {
      
[Embed(source="1015.png")]
      static var roller:Class;
      
      private static const rollerBMP:BitmapData = new roller().bitmapData;
       
      
      public var list:GiftRollerList;
      
      public function GilfRoller(items:Array, _width:Number = 0, _height:* = 0)
      {
         super();
         this.list = new GiftRollerList();
         this.list.width = _width - 3;
         this.list.height = _height;
         this.list.y = 16;
         addChild(this.list);
         this.list.initData(items);
         addChild(new Bitmap(rollerBMP));
      }
      
      public function init(items:Array) : void
      {
         this.list.initData(items);
      }
   }
}
