package alternativa.tanks.gui.shopitems.item.kits.description
{
   import alternativa.osgi.service.locale.ILocaleService;
   import alternativa.tanks.gui.shopitems.item.kits.KitPackage;
   import alternativa.tanks.gui.shopitems.item.kits.description.panel.KitPackageDescriptionPanel;
   import assets.Diamond;
   import controls.Money;
   import controls.base.LabelBase;
   import flash.display.Sprite;
   import flash.text.TextFormatAlign;
   import forms.ColorConstants;
   import projects.tanks.client.panel.model.shop.kitpackage.KitPackageItemInfo;
   
   public class KitPackageDescriptionView extends Sprite
   {
      
      public static const LEFT_TOP_MARGIN:int = 12;
      
      public static const ITEM_HEIGHT:int = 17;
      
      public static const WIDTH:int = 350;
      
      [Inject]
      public static var localeService:ILocaleService;
       
      
      private var kitPackage:KitPackage;
      
      private var discount:int;
      
      public function KitPackageDescriptionView()
      {
         super();
      }
      
      public function show(kit:KitPackage, sale:int) : void
      {
         this.kitPackage = kit;
         this.discount = sale;
         this.addPanel();
         this.addHeader();
         this.addRows();
         this.addSummary();
         this.addSaveValue();
         this.addProfit();
      }
      
      private function addPanel() : void
      {
         var _loc1_:KitPackageDescriptionPanel = new KitPackageDescriptionPanel();
         _loc1_.resize(this.kitPackage.getItemInfos().length + 2);
         addChild(_loc1_);
      }
      
      private function addHeader() : void
      {
         var _loc2_:LabelBase = null;
         var _loc1_:LabelBase = new LabelBase();
         _loc1_.color = ColorConstants.GREEN_LABEL;
         _loc1_.align = TextFormatAlign.LEFT;
         _loc1_.text = "Состав комплекта";
         _loc1_.x = LEFT_TOP_MARGIN;
         _loc1_.y = LEFT_TOP_MARGIN;
         addChild(_loc1_);
         _loc2_ = new LabelBase();
         _loc2_.color = ColorConstants.GREEN_LABEL;
         _loc2_.align = TextFormatAlign.RIGHT;
         _loc2_.text = "Цена в гараже";
         _loc2_.x = WIDTH - _loc2_.width - _loc1_.x;
         _loc2_.y = _loc1_.y;
         addChild(_loc2_);
      }
      
      private function addRows() : void
      {
         var _loc2_:KitPackageItemInfo = null;
         var _loc3_:KitPackageDescriptionRow = null;
         var _loc1_:int = LEFT_TOP_MARGIN + ITEM_HEIGHT;
         for each(_loc2_ in this.kitPackage.getItemInfos())
         {
            _loc3_ = new KitPackageDescriptionRow(_loc2_);
            _loc3_.y = _loc1_;
            addChild(_loc3_);
            _loc1_ += ITEM_HEIGHT;
         }
      }
      
      private function addSummary() : void
      {
         var _loc1_:LabelBase = null;
         _loc1_ = new LabelBase();
         _loc1_.color = ColorConstants.GREEN_LABEL;
         _loc1_.align = TextFormatAlign.LEFT;
         _loc1_.text = "Итого:";
         _loc1_.x = LEFT_TOP_MARGIN;
         _loc1_.y = LEFT_TOP_MARGIN + (this.kitPackage.getItemInfos().length + 1) * ITEM_HEIGHT;
         addChild(_loc1_);
         var _loc2_:Diamond = new Diamond();
         _loc2_.x = WIDTH - _loc1_.x - _loc2_.width;
         _loc2_.y = _loc1_.y + 4;
         addChild(_loc2_);
         var _loc3_:LabelBase = new LabelBase();
         _loc3_.color = ColorConstants.GREEN_LABEL;
         _loc3_.align = TextFormatAlign.RIGHT;
         _loc3_.text = Money.numToString(this.getKitPrice(),false);
         _loc3_.x = _loc2_.x - _loc3_.width - 1;
         _loc3_.y = _loc1_.y;
         addChild(_loc3_);
      }
      
      private function addSaveValue() : void
      {
         var _loc1_:LabelBase = null;
         _loc1_ = new LabelBase();
         _loc1_.color = ColorConstants.GREEN_LABEL;
         _loc1_.align = TextFormatAlign.LEFT;
         _loc1_.text = "Со скидкой " + this.discount + "%";
         _loc1_.x = LEFT_TOP_MARGIN;
         _loc1_.y = LEFT_TOP_MARGIN + (this.kitPackage.getItemInfos().length + 2) * ITEM_HEIGHT + LEFT_TOP_MARGIN;
         addChild(_loc1_);
         var _loc2_:Diamond = new Diamond();
         _loc2_.x = WIDTH - _loc1_.x - _loc2_.width;
         _loc2_.y = _loc1_.y + 4;
         addChild(_loc2_);
         var _loc3_:LabelBase = new LabelBase();
         _loc3_.color = ColorConstants.GREEN_LABEL;
         _loc3_.align = TextFormatAlign.RIGHT;
         _loc3_.text = Money.numToString(this.getKitPrice() * ((100 - this.discount) / 100),false);
         _loc3_.x = _loc2_.x - _loc3_.width - 1;
         _loc3_.y = _loc1_.y;
         addChild(_loc3_);
      }
      
      private function addProfit() : void
      {
         var _loc2_:KitPackageItemInfo = new KitPackageItemInfo(1,this.getKitPrice() - this.getKitPrice() * ((100 - this.discount) / 100),"Выгода:");
         var _loc3_:KitPackageDescriptionRow = new KitPackageDescriptionRow(_loc2_);
         _loc3_.y = LEFT_TOP_MARGIN + (this.kitPackage.getItemInfos().length + 3) * ITEM_HEIGHT + LEFT_TOP_MARGIN;
         addChild(_loc3_);
      }
      
      private function getKitPrice() : int
      {
         var _loc2_:KitPackageItemInfo = null;
         var _loc1_:int = 0;
         for each(_loc2_ in this.kitPackage.getItemInfos())
         {
            _loc1_ += _loc2_.crystalPrice * _loc2_.count;
         }
         return _loc1_;
      }
   }
}
