package alternativa.tanks.model.shop.items.crystallitem
{
   import alternativa.init.Main;
   import alternativa.osgi.service.locale.ILocaleService;
   import alternativa.tanks.model.shop.ShopWindow;
   import alternativa.tanks.model.shop.items.base.ShopItemBase;
   import alternativa.tanks.model.shop.items.base.ShopItemSkins;
   import alternativa.tanks.model.shop.items.utils.FormatUtils;
   import controls.base.LabelBase;
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.text.TextFieldAutoSize;
   
   public class CrystalPackageItem extends ShopItemBase
   {
      
      public static var localeService:ILocaleService = Main.osgi.getService(ILocaleService) as ILocaleService;
      
      private static const LEFT_PADDING:int = 18;
      
      private static const RIGHT_PADDING:int = 18;
      
      private static const TOP_PADDING:int = 17;
      
      private static const BOTTOM_PADDING:int = 17;
      
      private static const CRYSTAL_ICON_X:int = 153;
      
      private static const CRYSTAL_ICON_Y:int = -2;
      
      private static const CRYSTALS_TEXT_LABEL_COLOR:uint = 23704;
      
      private static const MONEY_TEXT_LABEL_COLOR:uint = 4144959;
       
      
      private var crystalsIcon:Bitmap;
      
      private var crystalLabel:LabelBase;
      
      private var crystalBlueIcon:Bitmap;
      
      private var priceLabel:LabelBase;
      
      private var presentLabel:LabelBase;
      
      private var presentSecondLabel:LabelBase;
      
      private var presentIcon:Bitmap;
      
      private var additionalData:Object;
      
      public function CrystalPackageItem(itemId:String, additionalData:Object)
      {
         this.additionalData = additionalData;
         super(itemId,ShopItemSkins.GREEN);
      }
      
      override protected function init() : void
      {
         super.init();
         if(this.hasPresent)
         {
            this.initPackageWithPresent();
         }
         else
         {
            this.initPackageWithoutPresent();
         }
         this.initCrystalsAndPriceInnerLabels();
         this.render();
      }
      
      private function initCrystalsAndPriceInnerLabels() : void
      {
         this.crystalLabel = new LabelBase();
         this.crystalLabel.text = FormatUtils.valueToString(this.additionalData.crystalls_count,0,false);
         this.crystalLabel.color = CRYSTALS_TEXT_LABEL_COLOR;
         this.crystalLabel.autoSize = TextFieldAutoSize.LEFT;
         this.crystalLabel.size = 30;
         this.crystalLabel.bold = true;
         this.crystalLabel.mouseEnabled = false;
         addChild(this.crystalLabel);
         this.crystalBlueIcon = new Bitmap(CrystalPackageItemIcons.crystalBlue);
         addChild(this.crystalBlueIcon);
         this.priceLabel = new LabelBase();
         fixChineseCurrencyLabelRendering(this.priceLabel);
         this.priceLabel.text = FormatUtils.valueToString(this.additionalData.price,0,false) + " " + this.additionalData.currency;
         this.priceLabel.color = MONEY_TEXT_LABEL_COLOR;
         this.priceLabel.autoSize = TextFieldAutoSize.LEFT;
         this.priceLabel.size = 22;
         this.priceLabel.bold = true;
         this.priceLabel.mouseEnabled = false;
         addChild(this.priceLabel);
      }
      
      private function initPackageWithPresent() : void
      {
         if(ShopWindow.haveDoubleCrystalls)
         {
            setSkin(ShopItemSkins.RED);
         }
         this.presentLabel = new LabelBase();
         this.presentLabel.text = "+" + FormatUtils.valueToString(this.additionalData.bonus_crystalls,0,false);
         this.presentLabel.color = 16777215;
         this.presentLabel.autoSize = TextFieldAutoSize.LEFT;
         this.presentLabel.size = 22;
         this.presentLabel.bold = true;
         this.presentLabel.mouseEnabled = false;
         addChild(this.presentLabel);
         this.presentSecondLabel = new LabelBase();
         this.presentSecondLabel.text = "в подарок!";
         this.presentSecondLabel.color = 16777215;
         this.presentSecondLabel.autoSize = TextFieldAutoSize.LEFT;
         this.presentSecondLabel.size = 18;
         this.presentSecondLabel.mouseEnabled = false;
         addChild(this.presentSecondLabel);
         this.presentIcon = new Bitmap(CrystalPackageItemIcons.crystalWhite);
         addChild(this.presentIcon);
      }
      
      private function initPackageWithoutPresent() : void
      {
         setSkin(ShopItemSkins.GREY);
      }
      
      private function get hasPresent() : Boolean
      {
         return this.additionalData.bonus_crystalls > 0;
      }
      
      private function render() : void
      {
         this.crystalLabel.x = LEFT_PADDING;
         this.crystalLabel.y = TOP_PADDING;
         this.crystalBlueIcon.x = this.crystalLabel.x + this.crystalLabel.width + 3;
         this.crystalBlueIcon.y = TOP_PADDING + 8;
         this.priceLabel.x = LEFT_PADDING;
         this.priceLabel.y = this.crystalLabel.y + this.crystalLabel.height - 5;
         if(this.crystalsIcon)
         {
            this.crystalsIcon.x = CRYSTAL_ICON_X;
            this.crystalsIcon.y = CRYSTAL_ICON_Y;
         }
         if(this.hasPresent)
         {
            this.presentIcon.x = WIDTH - RIGHT_PADDING - this.presentIcon.width;
            this.presentLabel.x = this.presentIcon.x - this.presentLabel.width;
            this.presentSecondLabel.x = this.presentLabel.x;
            this.presentSecondLabel.y = HEIGHT - BOTTOM_PADDING - this.presentSecondLabel.height;
            this.presentLabel.y = this.presentSecondLabel.y - this.presentSecondLabel.height + 4;
            this.presentIcon.y = this.presentLabel.y + 5;
         }
      }
      
      override public function set gridPosition(param1:int) : void
      {
         super.gridPosition = param1;
         var _loc2_:BitmapData = CrystalPackageItemIcons.crystalsPackages[gridPosition];
         if(!_loc2_ && param1 != 0)
         {
            _loc2_ = CrystalPackageItemIcons.crystalsPackages[CrystalPackageItemIcons.crystalsPackages.length - 1];
         }
         if(_loc2_)
         {
            this.crystalsIcon = new Bitmap(_loc2_);
            addChildAt(this.crystalsIcon,2);
         }
         this.render();
      }
   }
}
