package alternativa.tanks.gui
{
   import alternativa.init.Main;
   import alternativa.osgi.service.locale.ILocaleService;
   import alternativa.tanks.gui.payment.controls.OrderingLine;
   import controls.TankWindow;
   import controls.TankWindowInner;
   import controls.base.DefaultButtonBase;
   import flash.display.Bitmap;
   import flash.display.DisplayObject;
   import flash.display.Shape;
   import flash.display.Sprite;
   
   public class ThanksForPurchaseWindow extends Sprite
   {
      [Inject]
      public static var localeService:ILocaleService = Main.osgi.getService(ILocaleService) as ILocaleService;
       
      [Embed(source="1140.png")]
      private var bitmap:Class;
      
      public var closeButton:DefaultButtonBase;
      
      public var donationCrystals:int;
      
      private const windowMargin:int = 12;
      
      private const margin:int = 9;
      
      private var inner:Sprite;
      
      public function ThanksForPurchaseWindow(param2:int, param3:int, param4:int)
      {
         super();
         this.donationCrystals = param2;
         var _loc5_:int = this.windowMargin * 2 + this.margin * 2 + new this.bitmap().bitmapData.width;
         var _loc6_:TankWindow = new TankWindow();
         addChild(_loc6_);
         var _loc7_:TankWindowInner = new TankWindowInner(_loc5_ - this.windowMargin * 2,0,TankWindowInner.GREEN);
         this.inner = _loc7_;
         _loc6_.addChild(_loc7_);
         _loc7_.x = this.windowMargin;
         _loc7_.y = this.windowMargin;
         var _loc8_:Bitmap = new Bitmap(new this.bitmap().bitmapData);
         _loc8_.x = (_loc7_.width - _loc8_.width) / 2;
         this.addLine(_loc8_,this.windowMargin);
         var _loc9_:int = _loc7_.width * 0.8;
         var _loc10_:OrderingLine = new OrderingLine("Куплено кристаллов:",param2);
         _loc10_.width = _loc9_;
         this.centerAlign(_loc10_,_loc7_.width);
         this.addLine(_loc10_,0);
         if(param3 > 0)
         {
            _loc10_ = new OrderingLine("Бонус покупки пакета:",param3);
            _loc10_.width = _loc9_;
            this.centerAlign(_loc10_,_loc7_.width);
            this.addLine(_loc10_,-7);
         }
         if(param4 > 0)
         {
            _loc10_ = new OrderingLine("Карта «Двойной кристалл»:",param4);
            _loc10_.width = _loc9_;
            this.centerAlign(_loc10_,_loc7_.width);
            this.addLine(_loc10_,-7);
         }
         var _loc11_:Shape = new Shape();
         _loc11_.graphics.beginFill(5898034);
         for(var _loc12_:int = 0; _loc12_ < _loc9_ - 5; )
         {
            _loc11_.graphics.drawRect(_loc12_,0,1,1);
            _loc12_ += 3;
         }
         this.centerAlign(_loc11_,_loc7_.width);
         this.addLine(_loc11_,4);
         _loc10_ = new OrderingLine("Всего начислено кристаллов:",param4 + param2 + param3);
         _loc10_.width = _loc9_;
         this.centerAlign(_loc10_,_loc7_.width);
         this.addLine(_loc10_,1);
         _loc7_.height += this.windowMargin;
         this.closeButton = new DefaultButtonBase();
         if(localeService != null)
         {
            this.closeButton.label = "Закрыть";
         }
         this.closeButton.y = _loc7_.x + _loc7_.height + this.windowMargin;
         this.centerAlign(this.closeButton,_loc5_);
         _loc6_.addChild(this.closeButton);
         _loc6_.height = this.closeButton.y + this.closeButton.height + this.windowMargin;
         _loc6_.width = _loc5_;
         addChild(_loc6_);
      }
      
      private function centerAlign(param1:DisplayObject, param2:Number) : void
      {
         param1.x = (param2 - param1.width) / 2;
      }
      
      private function addLine(param1:DisplayObject, param2:int) : void
      {
         param1.y = this.inner.height + param2;
         this.inner.addChild(param1);
      }
   }
}
