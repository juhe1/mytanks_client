package alternativa.tanks.model.shop
{
   import alternativa.init.Main;
   import alternativa.osgi.service.locale.ILocaleService;
   import controls.TankWindowInner;
   import controls.base.LabelBase;
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.Sprite;
   
   public class ShowWindowHeader extends Sprite
   {
      
      public static var localeService:ILocaleService = Main.osgi.getService(ILocaleService) as ILocaleService;
      
[Embed(source="881.png")]
      private static var crystalsImageClass:Class;
      
      private static const crystalsImage:BitmapData = new crystalsImageClass().bitmapData;
      
      public static const WINDOW_MARGIN:int = 11;
       
      
      private var headerIcon:Bitmap;
      
      private var header:LabelBase;
      
      private var headerInner:TankWindowInner;
      
      private var doubleCrystallsHeader:LabelBase;
      
      public function ShowWindowHeader()
      {
         this.doubleCrystallsHeader = new LabelBase();
         super();
         this.headerInner = new TankWindowInner(0,0,TankWindowInner.TRANSPARENT);
         addChild(this.headerInner);
         this.headerIcon = new Bitmap(crystalsImage);
         addChild(this.headerIcon);
         this.headerIcon.x = WINDOW_MARGIN;
         this.headerIcon.y = 5;
         this.header = new LabelBase();
         addChild(this.header);
         this.header.multiline = true;
         this.header.wordWrap = true;
         this.header.x = this.headerIcon.x + this.headerIcon.width + WINDOW_MARGIN;
         this.header.htmlText = "Здесь вы можете купить различные предметы, которые помогут вам разнообразить игру и могут быть полезными в битвах. Вы соглашаетесь с тем, что купленные предметы будут зачислены на ваш аккаунт после завершения оплаты. Купленные предметы, которые были зачислены на ваш аккаунт, не подлежат возврату.";
         if(ShopWindow.haveDoubleCrystalls)
         {
            this.doubleCrystallsHeader.multiline = true;
            this.doubleCrystallsHeader.wordWrap = true;
            this.doubleCrystallsHeader.x = this.headerIcon.x + this.headerIcon.width + WINDOW_MARGIN;
            this.doubleCrystallsHeader.htmlText = "<font color=\"#ffbe23\" size=\"+5\">У вас есть бонусная карта \"Двойной кристалл\"!\nСколько бы кристаллов вы ни купили, ещё столько же получите от нас в подарок!</font>";
            this.doubleCrystallsHeader.bold = true;
            this.doubleCrystallsHeader.color = 16760355;
            addChild(this.doubleCrystallsHeader);
         }
      }
      
      public function resize(width:int) : void
      {
         this.headerInner.width = width;
         this.headerInner.height = this.headerIcon.height + (!!ShopWindow.haveDoubleCrystalls ? 55 : 35);
         this.header.width = width - this.header.x - WINDOW_MARGIN;
         this.header.y = this.headerIcon.y + (this.headerIcon.height - this.header.textHeight >> 1);
         this.doubleCrystallsHeader.width = width - this.header.x - WINDOW_MARGIN;
         this.doubleCrystallsHeader.y = this.header.y + this.header.height;
      }
      
      override public function get height() : Number
      {
         return this.headerInner.height;
      }
   }
}
