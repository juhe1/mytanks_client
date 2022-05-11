package alternativa.tanks.gui
{
   import alternativa.init.Main;
   import alternativa.model.IModel;
   import alternativa.osgi.service.locale.ILocaleService;
   import alternativa.resource.StubBitmapData;
   import alternativa.service.IModelService;
   import alternativa.service.IResourceService;
   import alternativa.tanks.gui.shopitems.item.kits.KitPackage;
   import alternativa.tanks.gui.shopitems.item.kits.description.KitPackageDescriptionView;
   import alternativa.tanks.gui.shopitems.item.kits.description.KitsData;
   import alternativa.tanks.gui.shopitems.item.kits.description.KitsInfoData;
   import alternativa.tanks.locale.constants.TextConst;
   import alternativa.tanks.model.GarageModel;
   import alternativa.tanks.model.IItemEffect;
   import alternativa.tanks.model.ItemParams;
   import alternativa.tanks.model.panel.IPanel;
   import alternativa.tanks.model.user.IUserData;
   import alternativa.tanks.model.user.UserData;
   import assets.scroller.color.ScrollThumbSkinGreen;
   import assets.scroller.color.ScrollTrackGreen;
   import com.alternativaplatform.projects.tanks.client.commons.models.itemtype.ItemTypeEnum;
   import com.alternativaplatform.projects.tanks.client.commons.types.ItemProperty;
   import com.alternativaplatform.projects.tanks.client.garage.garage.ItemInfo;
   import com.alternativaplatform.projects.tanks.client.garage.item.ItemPropertyValue;
   import com.alternativaplatform.projects.tanks.client.garage.item.ModificationInfo;
   import controls.Label;
   import controls.NumStepper;
   import controls.TankWindow;
   import controls.TankWindowHeader;
   import controls.TankWindowInner;
   import fl.containers.ScrollPane;
   import fl.controls.ScrollPolicy;
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.DisplayObject;
   import flash.display.Shape;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import flash.net.URLRequest;
   import flash.net.navigateToURL;
   import flash.text.TextFieldType;
   import flash.utils.Dictionary;
   import forms.garage.GarageButton;
   import forms.garage.GarageRenewalButton;
   import projects.tanks.client.panel.model.shop.kitpackage.KitPackageItemInfo;
   import scpacker.resource.ResourceType;
   import scpacker.resource.ResourceUtil;
   import scpacker.resource.images.ImageResource;
   
   public class ItemInfoPanel extends Sprite
   {
      
[Embed(source="907.png")]
      private static const bitmapArea:Class;
      
      private static const areaBd:BitmapData = new bitmapArea().bitmapData;
      
[Embed(source="1132.png")]
      private static const bitmapArmorWear:Class;
      
      private static const damageBd:BitmapData = new bitmapArmorWear().bitmapData;
      
[Embed(source="852.png")]
      private static const bitmapArmor:Class;
      
      private static const armorBd:BitmapData = new bitmapArmor().bitmapData;
      
[Embed(source="925.png")]
      private static const bitmapEnergyConsumption:Class;
      
      private static const energyConsumptionBd:BitmapData = new bitmapEnergyConsumption().bitmapData;
      
[Embed(source="1200.png")]
      private static const bitmapPower:Class;
      
      private static const powerBd:BitmapData = new bitmapPower().bitmapData;
      
[Embed(source="1072.png")]
      private static const bitmapRange:Class;
      
      private static const rangeBd:BitmapData = new bitmapRange().bitmapData;
      
[Embed(source="1057.png")]
      private static const bitmapRateOfFire:Class;
      
      private static const rateOfFireBd:BitmapData = new bitmapRateOfFire().bitmapData;
      
[Embed(source="859.png")]
      private static const bitmapResourceWear:Class;
      
      private static const resourceWearBd:BitmapData = new bitmapResourceWear().bitmapData;
      
[Embed(source="1114.png")]
      private static const bitmapResource:Class;
      
      private static const resourceBd:BitmapData = new bitmapResource().bitmapData;
      
[Embed(source="884.png")]
      private static const bitmapSpread:Class;
      
      private static const spreadBd:BitmapData = new bitmapSpread().bitmapData;
      
[Embed(source="908.png")]
      private static const bitmapTurretRotationRate:Class;
      
      private static const turretRotationRateBd:BitmapData = new bitmapTurretRotationRate().bitmapData;
      
[Embed(source="1192.png")]
      private static const bitmapSpeed:Class;
      
      private static const speedBd:BitmapData = new bitmapSpeed().bitmapData;
      
[Embed(source="786.png")]
      private static const bitmapTurnSpeed:Class;
      
      private static const turnspeedBd:BitmapData = new bitmapTurnSpeed().bitmapData;
      
[Embed(source="1131.png")]
      private static const bitmapFireResistance:Class;
      
      private static const fireResistanceBd:BitmapData = new bitmapFireResistance().bitmapData;
      
[Embed(source="969.png")]
      private static const bitmapPlasmaResistance:Class;
      
      private static const plasmaResistanceBd:BitmapData = new bitmapPlasmaResistance().bitmapData;
      
[Embed(source="1064.png")]
      private static const bitmapMechResistance:Class;
      
      private static const mechResistanceBd:BitmapData = new bitmapMechResistance().bitmapData;
      
[Embed(source="874.png")]
      private static const bitmapRailResistance:Class;
      
      private static const railResistanceBd:BitmapData = new bitmapRailResistance().bitmapData;
      
[Embed(source="1039.png")]
      private static const bitmapTerminatorResistance:Class;
      
      private static const terminatorResistanceBd:BitmapData = new bitmapTerminatorResistance().bitmapData;
      
[Embed(source="829.png")]
      private static const bitmapCriticalChance:Class;
      
      private static const criticalChanceBd:BitmapData = new bitmapCriticalChance().bitmapData;
      
[Embed(source="754.png")]
      private static const bitmapHeatingTime:Class;
      
      private static const heatingTimeBd:BitmapData = new bitmapHeatingTime().bitmapData;
      
[Embed(source="894.png")]
      private static const bitmapMineResistance:Class;
      
      private static const mineResistanceBd:BitmapData = new bitmapMineResistance().bitmapData;
      
[Embed(source="970.png")]
      private static const bitmapVampireResistance:Class;
      
      private static const vampireResistanceBd:BitmapData = new bitmapVampireResistance().bitmapData;
      
[Embed(source="1074.png")]
      private static const bitmapThunderResistance:Class;
      
      private static const thunderResistanceBd:BitmapData = new bitmapThunderResistance().bitmapData;
      
[Embed(source="1207.png")]
      private static const bitmapFreezeResistance:Class;
      
      private static const freezeResistanceBd:BitmapData = new bitmapFreezeResistance().bitmapData;
      
[Embed(source="1021.png")]
      private static const bitmapRicochetResistance:Class;
      
      private static const ricochetResistanceBd:BitmapData = new bitmapRicochetResistance().bitmapData;
      
[Embed(source="1113.png")]
      private static const bitmapHealingRadius:Class;
      
      private static const healingRadiusBd:BitmapData = new bitmapHealingRadius().bitmapData;
      
[Embed(source="1013.png")]
      private static const bitmapHealRate:Class;
      
      private static const healRateBd:BitmapData = new bitmapHealRate().bitmapData;
      
[Embed(source="785.png")]
      private static const bitmapVampireRate:Class;
      
      private static const vampireRateBd:BitmapData = new bitmapVampireRate().bitmapData;
      
[Embed(source="842.png")]
      private static const shaftResistance:Class;
      
      private static const shaftResistanceBd:BitmapData = new shaftResistance().bitmapData;
      
[Embed(source="806.png")]
      private static const bitmapPropertiesLeft:Class;
      
      private static const propertiesLeftBd:BitmapData = new bitmapPropertiesLeft().bitmapData;
      
[Embed(source="848.png")]
      private static const bitmapPropertiesCenter:Class;
      
      private static const propertiesCenterBd:BitmapData = new bitmapPropertiesCenter().bitmapData;
      
[Embed(source="1204.png")]
      private static const bitmapPropertiesRight:Class;
      
      private static const propertiesRightBd:BitmapData = new bitmapPropertiesRight().bitmapData;
      
[Embed(source="1154.png")]
      private static const bitmapUpgradeTableLeft:Class;
      
      private static const upgradeTableLeftBd:BitmapData = new bitmapUpgradeTableLeft().bitmapData;
      
[Embed(source="1014.png")]
      private static const bitmapUpgradeTableCenter:Class;
      
      private static const upgradeTableCenterBd:BitmapData = new bitmapUpgradeTableCenter().bitmapData;
      
[Embed(source="1003.png")]
      private static const bitmapUpgradeTableRight:Class;
      
      private static const upgradeTableRightBd:BitmapData = new bitmapUpgradeTableRight().bitmapData;
      
[Embed(source="1083.png")]
      private static const bitmapDamageShaft:Class;
      
      private static const shaftDamageBd:BitmapData = new bitmapDamageShaft().bitmapData;
      
[Embed(source="804.png")]
      private static const bitmapFireRateShaft:Class;
      
      private static const shaftFireRateBd:BitmapData = new bitmapFireRateShaft().bitmapData;
      
      public static const INVENTORY_MAX_VALUE:int = 9999;
      
      public static const INVENTORY_MIN_VALUE:int = 1;
       
      
      private var resourceRegister:IResourceService;
      
      private var modelRegister:IModelService;
      
      private var localeService:ILocaleService;
      
      private var panelModel:IPanel;
      
      private var window:TankWindow;
      
      public var size:Point;
      
      public const margin:int = 11;
      
      private const bottomMargin:int = 64;
      
      private var inner:TankWindowInner;
      
      private var preview:Bitmap;
      
      private var previewVisible:Boolean;
      
      public var nameTf:Label;
      
      public var descrTf:Label;
      
      public var buttonBuy:GarageButton;
      
      public var buttonEquip:GarageButton;
      
      public var buttonUpgrade:GarageButton;
      
      public var buttonSkin:GarageButton;
      
      public var buttonBuyCrystals:GarageRenewalButton;
      
      public var inventoryNumStepper:NumStepper;
      
      private const buttonSize:Point = new Point(120,50);
      
      public var areaIcon:ItemPropertyIcon;
      
      public var armorIcon:ItemPropertyIcon;
      
      public var damageIcon:ItemPropertyIcon;
      
      public var damagePerSecondIcon:ItemPropertyIcon;
      
      public var energyConsumptionIcon:ItemPropertyIcon;
      
      public var powerIcon:ItemPropertyIcon;
      
      public var rangeIcon:ItemPropertyIcon;
      
      public var rateOfFireIcon:ItemPropertyIcon;
      
      public var resourceIcon:ItemPropertyIcon;
      
      public var resourceWearIcon:ItemPropertyIcon;
      
      public var shotWearIcon:ItemPropertyIcon;
      
      public var timeWearIcon:ItemPropertyIcon;
      
      public var shotTimeWearIcon:ItemPropertyIcon;
      
      public var spreadIcon:ItemPropertyIcon;
      
      public var turretRotationRateIcon:ItemPropertyIcon;
      
      public var damageAngleIcon:ItemPropertyIcon;
      
      public var speedIcon:ItemPropertyIcon;
      
      public var turnSpeedIcon:ItemPropertyIcon;
      
      public var criticalChanceIcon:ItemPropertyIcon;
      
      public var heatingTimeIcon:ItemPropertyIcon;
      
      public var mechResistanceIcon:ItemPropertyIcon;
      
      public var plasmaResistanceIcon:ItemPropertyIcon;
      
      public var fireResistanceIcon:ItemPropertyIcon;
      
      public var railResistanceIcon:ItemPropertyIcon;
      
      public var mineResistanceIcon:ItemPropertyIcon;
      
      public var terminatorResistanceIcon:ItemPropertyIcon;
      
      public var vampireResistanceIcon:ItemPropertyIcon;
      
      public var thunderResistanceIcon:ItemPropertyIcon;
      
      public var freezeResistanceIcon:ItemPropertyIcon;
      
      public var ricochetResistanceIcon:ItemPropertyIcon;
      
      public var shaftResistanceIcon:ItemPropertyIcon;
      
      public var healingRadiusIcon:ItemPropertyIcon;
      
      public var healRateIcon:ItemPropertyIcon;
      
      public var vampireRateIcon:ItemPropertyIcon;
      
      public var shaftDamageIcon:ItemPropertyIcon;
      
      public var shaftRateOfFireIcon:ItemPropertyIcon;
      
      private const iconSpace:int = 10;
      
      private var visibleIcons:Array;
      
      private var id:String;
      
      private var params:ItemParams;
      
      private var info:ItemInfo;
      
      private var type:ItemTypeEnum;
      
      private var upgradeProperties:Array;
      
      private var scrollPane:ScrollPane;
      
      private var scrollContainer:Sprite;
      
      private var propertiesPanel:Sprite;
      
      private var propertiesPanelLeft:Bitmap;
      
      private var propertiesPanelCenter:Bitmap;
      
      private var propertiesPanelRight:Bitmap;
      
      private var area:Shape;
      
      private var area2:Shape;
      
      private var areaRect:Rectangle;
      
      private var areaRect2:Rectangle;
      
      private var horizMargin:int = 12;
      
      private var vertMargin:int = 9;
      
      private var spaceModule:int = 3;
      
      private var cutPreview:int = 0;
      
      private var hidePreviewLimit:int = 275;
      
      private var timeIndicator:Label;
      
      public var requiredCrystalsNum:int;
      
      private var modTable:ModTable;
      
      public var availableSkins:Array;
      
      public var skinsParams:Dictionary;
      
      private var skinText:String;
      
      private var isKit:Boolean = false;
      
      private var kitView:KitPackageDescriptionView;
      
      public function ItemInfoPanel()
      {
         super();
         this.resourceRegister = Main.osgi.getService(IResourceService) as IResourceService;
         this.modelRegister = Main.osgi.getService(IModelService) as IModelService;
         this.localeService = Main.osgi.getService(ILocaleService) as ILocaleService;
         this.panelModel = Main.osgi.getService(IPanel) as IPanel;
         this.availableSkins = new Array();
         this.skinsParams = new Dictionary();
         this.kitView = new KitPackageDescriptionView();
         this.size = new Point(400,300);
         this.window = new TankWindow(this.size.x,this.size.y);
         addChild(this.window);
         this.window.headerLang = this.localeService.getText(TextConst.GUI_LANG);
         this.window.header = TankWindowHeader.INFORMATION;
         this.inner = new TankWindowInner(164,106,TankWindowInner.GREEN);
         this.inner.showBlink = true;
         addChild(this.inner);
         this.inner.x = this.margin;
         this.inner.y = this.margin;
         this.area = new Shape();
         this.area2 = new Shape();
         this.areaRect = new Rectangle();
         this.areaRect2 = new Rectangle(this.horizMargin,this.vertMargin,0,0);
         this.scrollContainer = new Sprite();
         this.scrollContainer.x = this.margin + 1;
         this.scrollContainer.y = this.margin + 1;
         this.scrollContainer.addChild(this.area);
         this.scrollContainer.addChild(this.area2);
         this.scrollPane = new ScrollPane();
         addChild(this.scrollPane);
         this.confScroll();
         this.scrollPane.horizontalScrollPolicy = ScrollPolicy.OFF;
         this.scrollPane.verticalScrollPolicy = ScrollPolicy.AUTO;
         this.scrollPane.source = this.scrollContainer;
         this.scrollPane.focusEnabled = false;
         this.scrollPane.x = this.margin + 1;
         this.scrollPane.y = this.margin + 1 + this.spaceModule;
         var userModel:UserData = Main.osgi.getService(IUserData) as UserData;
         var userName:String = userModel.name;
         this.nameTf = new Label();
         this.nameTf.type = TextFieldType.DYNAMIC;
         this.nameTf.text = "Hello, " + userName + "!";
         this.nameTf.size = 18;
         this.nameTf.color = 381208;
         this.scrollContainer.addChild(this.nameTf);
         this.nameTf.x = this.horizMargin - 3;
         this.nameTf.y = this.vertMargin - 7;
         this.descrTf = new Label();
         this.descrTf.multiline = true;
         this.descrTf.wordWrap = true;
         this.descrTf.color = 381208;
         this.descrTf.htmlText = "Description";
         this.scrollContainer.addChild(this.descrTf);
         this.descrTf.x = this.horizMargin - 3;
         this.preview = new Bitmap();
         this.buttonBuy = new GarageButton();
         this.buttonEquip = new GarageButton();
         this.buttonUpgrade = new GarageButton();
         this.buttonSkin = new GarageButton();
         this.buttonBuyCrystals = new GarageRenewalButton();
         this.buttonBuy.icon = null;
         this.buttonBuy.label = this.localeService.getText(TextConst.GARAGE_INFO_PANEL_BUTTON_BUY_TEXT);
         this.buttonEquip.label = this.localeService.getText(TextConst.GARAGE_INFO_PANEL_BUTTON_EQUIP_TEXT);
         this.buttonUpgrade.label = this.localeService.getText(TextConst.GARAGE_INFO_PANEL_BUTTON_UPGRADE_TEXT);
         this.buttonBuyCrystals.label = this.localeService.getText(TextConst.GARAGE_INFO_PANEL_BUTTON_ADD_CRYSTALS_TEXT);
         this.buttonBuyCrystals.addEventListener(MouseEvent.CLICK,function(e:MouseEvent):void
         {
            navigateToURL(new URLRequest("http://mytankspay.net/pay.php?cry=" + (-(panelModel.crystal >= params.price ? params.price : -params.price) - panelModel.crystal) + "&nick=" + panelModel.userName),"_self");
         });
         this.buttonSkin.label = "";
         addChild(this.buttonBuy);
         addChild(this.buttonEquip);
         addChild(this.buttonUpgrade);
         addChild(this.buttonSkin);
         this.buttonSkin.visible = false;
         addChild(this.buttonBuyCrystals);
         this.inventoryNumStepper = new NumStepper();
         addChild(this.inventoryNumStepper);
         this.inventoryNumStepper.value = 1;
         this.inventoryNumStepper.minValue = 1;
         this.inventoryNumStepper.maxValue = ItemInfoPanel.INVENTORY_MAX_VALUE;
         this.inventoryNumStepper.visible = false;
         this.inventoryNumStepper.addEventListener(Event.CHANGE,this.inventoryNumChanged);
         this.propertiesPanel = new Sprite();
         this.propertiesPanelLeft = new Bitmap(propertiesLeftBd);
         this.propertiesPanel.addChild(this.propertiesPanelLeft);
         this.propertiesPanelCenter = new Bitmap(propertiesCenterBd);
         this.propertiesPanel.addChild(this.propertiesPanelCenter);
         this.propertiesPanelRight = new Bitmap(propertiesRightBd);
         this.propertiesPanel.addChild(this.propertiesPanelRight);
         this.propertiesPanelCenter.x = this.propertiesPanelLeft.width;
         this.propertiesPanel.x = this.horizMargin;
         this.propertiesPanel.y = Math.round(this.vertMargin * 2 + this.nameTf.textHeight - 7);
         this.areaIcon = new ItemPropertyIcon(areaBd,this.localeService.getText(TextConst.GARAGE_INFO_PANEL_DISTANCE_UNIT_TEXT));
         this.armorIcon = new ItemPropertyIcon(armorBd,this.localeService.getText(TextConst.GARAGE_INFO_PANEL_HEALTH_UNIT_TEXT));
         this.damageIcon = new ItemPropertyIcon(damageBd,this.localeService.getText(TextConst.GARAGE_INFO_PANEL_HEALTH_UNIT_TEXT));
         this.damagePerSecondIcon = new ItemPropertyIcon(damageBd,this.localeService.getText(TextConst.GARAGE_INFO_PANEL_DAMAGE_SPEED_UNIT_TEXT));
         this.energyConsumptionIcon = new ItemPropertyIcon(energyConsumptionBd,this.localeService.getText(TextConst.GARAGE_INFO_PANEL_POWER_UNIT_TEXT));
         this.powerIcon = new ItemPropertyIcon(powerBd,this.localeService.getText(TextConst.GARAGE_INFO_PANEL_POWER_UNIT_TEXT));
         this.rangeIcon = new ItemPropertyIcon(rangeBd,this.localeService.getText(TextConst.GARAGE_INFO_PANEL_DISTANCE_UNIT_TEXT));
         this.rateOfFireIcon = new ItemPropertyIcon(rateOfFireBd,this.localeService.getText(TextConst.GARAGE_INFO_PANEL_RATE_OF_FIRE_UNIT_TEXT));
         this.resourceIcon = new ItemPropertyIcon(resourceBd,this.localeService.getText(TextConst.GARAGE_INFO_PANEL_RESOURCE_UNIT_TEXT));
         this.resourceWearIcon = new ItemPropertyIcon(resourceWearBd,this.localeService.getText(TextConst.GARAGE_INFO_PANEL_RESOURCE_UNIT_TEXT));
         this.shotWearIcon = new ItemPropertyIcon(resourceWearBd,this.localeService.getText(TextConst.GARAGE_INFO_PANEL_RESOURCE_SHOT_WEAR_UNIT_TEXT));
         this.timeWearIcon = new ItemPropertyIcon(resourceWearBd,this.localeService.getText(TextConst.GARAGE_INFO_PANEL_RESOURCE_TIME_WEAR_UNIT_TEXT));
         this.shotTimeWearIcon = new ItemPropertyIcon(resourceWearBd,this.localeService.getText(TextConst.GARAGE_INFO_PANEL_RESOURCE_SHOT_TIME_WEAR_UNIT_TEXT));
         this.spreadIcon = new ItemPropertyIcon(spreadBd,this.localeService.getText(TextConst.GARAGE_INFO_PANEL_ANGLE_UNIT_TEXT));
         this.turretRotationRateIcon = new ItemPropertyIcon(turretRotationRateBd,this.localeService.getText(TextConst.GARAGE_INFO_PANEL_TURN_SPEED_UNIT_TEXT));
         this.damageAngleIcon = new ItemPropertyIcon(spreadBd,this.localeService.getText(TextConst.GARAGE_INFO_PANEL_ANGLE_UNIT_TEXT));
         this.speedIcon = new ItemPropertyIcon(speedBd,this.localeService.getText(TextConst.GARAGE_INFO_PANEL_SPEED_UNIT_TEXT));
         this.turnSpeedIcon = new ItemPropertyIcon(turnspeedBd,this.localeService.getText(TextConst.GARAGE_INFO_PANEL_TURN_SPEED_UNIT_TEXT));
         this.criticalChanceIcon = new ItemPropertyIcon(criticalChanceBd,this.localeService.getText(TextConst.GARAGE_INFO_PANEL_CRITICAL_CHANCE_UNIT_TEXT));
         this.heatingTimeIcon = new ItemPropertyIcon(heatingTimeBd,this.localeService.getText(TextConst.GARAGE_INFO_PANEL_HEATING_TIME_UNIT_TEXT));
         this.mechResistanceIcon = new ItemPropertyIcon(mechResistanceBd,"%");
         this.fireResistanceIcon = new ItemPropertyIcon(fireResistanceBd,"%");
         this.plasmaResistanceIcon = new ItemPropertyIcon(plasmaResistanceBd,"%");
         this.railResistanceIcon = new ItemPropertyIcon(railResistanceBd,"%");
         this.terminatorResistanceIcon = new ItemPropertyIcon(terminatorResistanceBd,"%");
         this.mineResistanceIcon = new ItemPropertyIcon(mineResistanceBd,"%");
         this.vampireResistanceIcon = new ItemPropertyIcon(vampireResistanceBd,"%");
         this.thunderResistanceIcon = new ItemPropertyIcon(thunderResistanceBd,"%");
         this.freezeResistanceIcon = new ItemPropertyIcon(freezeResistanceBd,"%");
         this.ricochetResistanceIcon = new ItemPropertyIcon(ricochetResistanceBd,"%");
         this.shaftResistanceIcon = new ItemPropertyIcon(shaftResistanceBd,"%");
         this.healingRadiusIcon = new ItemPropertyIcon(healingRadiusBd,this.localeService.getText(TextConst.GARAGE_INFO_PANEL_DISTANCE_UNIT_TEXT));
         this.healRateIcon = new ItemPropertyIcon(healRateBd,this.localeService.getText(TextConst.GARAGE_INFO_PANEL_DAMAGE_SPEED_UNIT_TEXT));
         this.vampireRateIcon = new ItemPropertyIcon(vampireRateBd,this.localeService.getText(TextConst.GARAGE_INFO_PANEL_DAMAGE_SPEED_UNIT_TEXT));
         this.shaftDamageIcon = new ItemPropertyIcon(shaftDamageBd,"hp");
         this.shaftRateOfFireIcon = new ItemPropertyIcon(shaftFireRateBd,"shot/min");
         this.timeIndicator = new Label();
         this.timeIndicator.size = 18;
         this.timeIndicator.color = 381208;
         this.visibleIcons = new Array();
         this.modTable = new ModTable();
         this.modTable.x = this.horizMargin;
      }
      
      public function hide() : void
      {
         this.resourceRegister = null;
         this.modelRegister = null;
         this.panelModel = null;
         this.window = null;
         this.inner = null;
         this.preview = null;
         this.nameTf = null;
         this.descrTf = null;
         this.visibleIcons = null;
         this.id = null;
         this.type = null;
         this.upgradeProperties = null;
         this.scrollPane = null;
         this.scrollContainer = null;
         this.propertiesPanel = null;
         this.propertiesPanelLeft = null;
         this.propertiesPanelCenter = null;
         this.propertiesPanelRight = null;
         this.area = null;
         this.area2 = null;
         this.areaRect = null;
         this.areaRect2 = null;
         this.buttonBuy = null;
         this.buttonEquip = null;
         this.buttonUpgrade = null;
         this.buttonSkin = null;
         this.buttonBuyCrystals = null;
         this.areaIcon = null;
         this.armorIcon = null;
         this.damageIcon = null;
         this.damagePerSecondIcon = null;
         this.energyConsumptionIcon = null;
         this.powerIcon = null;
         this.rangeIcon = null;
         this.rateOfFireIcon = null;
         this.resourceIcon = null;
         this.resourceWearIcon = null;
         this.shotWearIcon = null;
         this.timeWearIcon = null;
         this.shotTimeWearIcon = null;
         this.spreadIcon = null;
         this.turretRotationRateIcon = null;
         this.damageAngleIcon = null;
         this.speedIcon = null;
         this.turnSpeedIcon = null;
         this.criticalChanceIcon = null;
         this.heatingTimeIcon = null;
         this.mechResistanceIcon = null;
         this.fireResistanceIcon = null;
         this.plasmaResistanceIcon = null;
         this.railResistanceIcon = null;
         this.terminatorResistanceIcon = null;
         this.mineResistanceIcon = null;
         this.vampireResistanceIcon = null;
         this.thunderResistanceIcon = null;
         this.freezeResistanceIcon = null;
         this.ricochetResistanceIcon = null;
         this.shaftResistanceIcon = null;
         this.healingRadiusIcon = null;
         this.healRateIcon = null;
         this.vampireRateIcon = null;
         this.vampireRateIcon = null;
         this.vampireRateIcon = null;
         this.vampireRateIcon = null;
         this.vampireRateIcon = null;
         this.shaftRateOfFireIcon = null;
         this.shaftDamageIcon = null;
      }
      
      private function confScroll() : void
      {
         this.scrollPane.setStyle("downArrowUpSkin",ScrollArrowDownGreen);
         this.scrollPane.setStyle("downArrowDownSkin",ScrollArrowDownGreen);
         this.scrollPane.setStyle("downArrowOverSkin",ScrollArrowDownGreen);
         this.scrollPane.setStyle("downArrowDisabledSkin",ScrollArrowDownGreen);
         this.scrollPane.setStyle("upArrowUpSkin",ScrollArrowUpGreen);
         this.scrollPane.setStyle("upArrowDownSkin",ScrollArrowUpGreen);
         this.scrollPane.setStyle("upArrowOverSkin",ScrollArrowUpGreen);
         this.scrollPane.setStyle("upArrowDisabledSkin",ScrollArrowUpGreen);
         this.scrollPane.setStyle("trackUpSkin",ScrollTrackGreen);
         this.scrollPane.setStyle("trackDownSkin",ScrollTrackGreen);
         this.scrollPane.setStyle("trackOverSkin",ScrollTrackGreen);
         this.scrollPane.setStyle("trackDisabledSkin",ScrollTrackGreen);
         this.scrollPane.setStyle("thumbUpSkin",ScrollThumbSkinGreen);
         this.scrollPane.setStyle("thumbDownSkin",ScrollThumbSkinGreen);
         this.scrollPane.setStyle("thumbOverSkin",ScrollThumbSkinGreen);
         this.scrollPane.setStyle("thumbDisabledSkin",ScrollThumbSkinGreen);
      }
      
      private function hideAllIcons() : void
      {
         var icon:DisplayObject = null;
         Main.writeVarsToConsoleChannel("GARAGE WINDOW","hideAllIcons");
         for(var i:int = 0; i < this.visibleIcons.length; i++)
         {
            icon = this.visibleIcons[i] as DisplayObject;
            if(this.propertiesPanel.contains(icon))
            {
               this.propertiesPanel.removeChild(icon);
            }
         }
      }
      
      private function showIcons() : void
      {
         var icon:DisplayObject = null;
         Main.writeVarsToConsoleChannel("GARAGE WINDOW","showIcons");
         for(var i:int = 0; i < this.visibleIcons.length; i++)
         {
            icon = this.visibleIcons[i] as DisplayObject;
            if(!this.propertiesPanel.contains(icon))
            {
               this.propertiesPanel.addChild(icon);
            }
            icon.visible = true;
         }
      }
      
      public function showItemInfo(itemId:String, itemParams:ItemParams, storeItem:Boolean, itemInfo:ItemInfo = null, mountedItems:Array = null) : void
      {
         var i:int = 0;
         var p:ItemPropertyValue = null;
         var j:int = 0;
         var pv:ItemPropertyValue = null;
         var data:KitsData = null;
         var kitPackage:Vector.<KitPackageItemInfo> = null;
         var mods:Array = null;
         var text:Array = null;
         var m:int = 0;
         var modInfo:ModificationInfo = null;
         var row:ModInfoRow = null;
         var maxWidth:int = 0;
         var modProperties:Array = null;
         var rank:int = 0;
         var cost:int = 0;
         var acceptableNum:int = 0;
         var itemEffectModel:IItemEffect = null;
         Main.writeVarsToConsoleChannel("GARAGE WINDOW"," ");
         Main.writeVarsToConsoleChannel("GARAGE WINDOW","showItemInfooooo (itemId: %1)",itemId);
         this.id = itemId;
         this.type = itemParams.itemType;
         this.params = itemParams;
         this.info = itemInfo;
         this.nameTf.text = itemParams.name;
         this.descrTf.htmlText = itemParams.description;
         var resource:ImageResource = ResourceUtil.getResource(ResourceType.IMAGE,itemId + "_preview") as ImageResource;
         var previewBd:BitmapData = null;
         if(resource != null)
         {
            previewBd = resource.bitmapData as BitmapData;
         }
         else
         {
            previewBd = new StubBitmapData(16711680);
         }
         this.preview.bitmapData = previewBd;
         var showProperties:Boolean = !(this.type == ItemTypeEnum.ARMOR || this.type == ItemTypeEnum.WEAPON);
         this.hideAllIcons();
         this.visibleIcons = new Array();
         var properties:Array = itemParams.itemProperties;
         if(itemId.indexOf("shaft_") < 0)
         {
            if(properties != null)
            {
               for(i = 0; i < properties.length; i++)
               {
                  p = properties[i] as ItemPropertyValue;
                  switch(p.property)
                  {
                     case ItemProperty.ARMOR:
                        Main.writeVarsToConsoleChannel("GARAGE WINDOW","ItemProperty: ARMOR");
                        if(showProperties)
                        {
                           this.armorIcon.labelText = p.value;
                        }
                        else
                        {
                           this.armorIcon.labelText = "";
                        }
                        this.visibleIcons[5] = this.armorIcon;
                        break;
                     case ItemProperty.DAMAGE:
                        Main.writeVarsToConsoleChannel("GARAGE WINDOW","ItemProperty: DAMAGE");
                        if(showProperties)
                        {
                           this.damageIcon.labelText = p.value;
                        }
                        else
                        {
                           this.damageIcon.labelText = "";
                        }
                        this.visibleIcons[5] = this.damageIcon;
                        break;
                     case ItemProperty.DAMAGE_PER_SECOND:
                        Main.writeVarsToConsoleChannel("GARAGE WINDOW","ItemProperty: DAMAGE_PER_SECOND");
                        if(showProperties)
                        {
                           this.damagePerSecondIcon.labelText = p.value;
                        }
                        else
                        {
                           this.damagePerSecondIcon.labelText = "";
                        }
                        this.visibleIcons[5] = this.damagePerSecondIcon;
                        break;
                     case ItemProperty.AIMING_ERROR:
                        Main.writeVarsToConsoleChannel("GARAGE WINDOW","ItemProperty: AIMING_ERROR");
                        if(showProperties)
                        {
                           this.spreadIcon.labelText = p.value;
                        }
                        else
                        {
                           this.spreadIcon.labelText = "";
                        }
                        this.visibleIcons[8] = this.spreadIcon;
                        break;
                     case ItemProperty.CONE_ANGLE:
                        Main.writeVarsToConsoleChannel("GARAGE WINDOW","ItemProperty: CONE_ANGLE");
                        if(showProperties)
                        {
                           this.damageAngleIcon.labelText = p.value;
                        }
                        else
                        {
                           this.damageAngleIcon.labelText = "";
                        }
                        this.visibleIcons[8] = this.damageAngleIcon;
                        break;
                     case ItemProperty.SHOT_AREA:
                        Main.writeVarsToConsoleChannel("GARAGE WINDOW","ItemProperty: SHOT_AREA");
                        if(showProperties)
                        {
                           this.areaIcon.labelText = p.value;
                        }
                        else
                        {
                           this.areaIcon.labelText = "";
                        }
                        this.visibleIcons[10] = this.areaIcon;
                        break;
                     case ItemProperty.SHOT_FREQUENCY:
                        Main.writeVarsToConsoleChannel("GARAGE WINDOW","ItemProperty: SHOT_FREQUENCY");
                        if(showProperties)
                        {
                           this.rateOfFireIcon.labelText = p.value;
                        }
                        else
                        {
                           this.rateOfFireIcon.labelText = "";
                        }
                        this.visibleIcons[6] = this.rateOfFireIcon;
                        break;
                     case ItemProperty.SHAFT_DAMAGE:
                        Main.writeVarsToConsoleChannel("GARAGE WINDOW","ItemProperty: SHOT_FREQUENCY");
                        if(showProperties)
                        {
                           this.shaftDamageIcon.labelText = p.value;
                        }
                        else
                        {
                           this.shaftDamageIcon.labelText = "";
                        }
                        this.visibleIcons[7] = this.shaftDamageIcon;
                        break;
                     case ItemProperty.SHAFT_FIRE_RATE:
                        Main.writeVarsToConsoleChannel("GARAGE WINDOW","ItemProperty: SHOT_FREQUENCY");
                        if(showProperties)
                        {
                           this.shaftRateOfFireIcon.labelText = p.value;
                        }
                        else
                        {
                           this.shaftRateOfFireIcon.labelText = "";
                        }
                        this.visibleIcons[8] = this.shaftRateOfFireIcon;
                        break;
                     case ItemProperty.SHOT_RANGE:
                        Main.writeVarsToConsoleChannel("GARAGE WINDOW","ItemProperty: SHOT_RANGE");
                        if(showProperties)
                        {
                           this.rangeIcon.labelText = p.value;
                        }
                        else
                        {
                           this.rangeIcon.labelText = "";
                        }
                        this.visibleIcons[9] = this.rangeIcon;
                        break;
                     case ItemProperty.TURRET_TURN_SPEED:
                        Main.writeVarsToConsoleChannel("GARAGE WINDOW","ItemProperty: TURRET_TURN_SPEED");
                        if(showProperties)
                        {
                           this.turretRotationRateIcon.labelText = p.value;
                        }
                        else
                        {
                           this.turretRotationRateIcon.labelText = "";
                        }
                        this.visibleIcons[7] = this.turretRotationRateIcon;
                        break;
                     case ItemProperty.SPEED:
                        Main.writeVarsToConsoleChannel("GARAGE WINDOW","ItemProperty: SPEED");
                        if(showProperties)
                        {
                           this.speedIcon.labelText = p.value;
                        }
                        else
                        {
                           this.speedIcon.labelText = "";
                        }
                        this.visibleIcons[11] = this.speedIcon;
                        break;
                     case ItemProperty.TURN_SPEED:
                        Main.writeVarsToConsoleChannel("GARAGE WINDOW","ItemProperty: TURN_SPEED");
                        if(showProperties)
                        {
                           this.turnSpeedIcon.labelText = p.value;
                        }
                        else
                        {
                           this.turnSpeedIcon.labelText = "";
                        }
                        this.visibleIcons[12] = this.turnSpeedIcon;
                        break;
                     case ItemProperty.CRITICAL_CHANCE:
                        Main.writeVarsToConsoleChannel("GARAGE WINDOW","ItemProperty: CRITICAL_CHANCE");
                        if(showProperties)
                        {
                           this.criticalChanceIcon.labelText = p.value;
                        }
                        else
                        {
                           this.criticalChanceIcon.labelText = "";
                        }
                        this.visibleIcons[25] = this.criticalChanceIcon;
                        break;
                     case ItemProperty.HEATING_TIME:
                        Main.writeVarsToConsoleChannel("GARAGE WINDOW","ItemProperty: HEATING_TIME");
                        if(showProperties)
                        {
                           this.heatingTimeIcon.labelText = p.value;
                        }
                        else
                        {
                           this.heatingTimeIcon.labelText = "";
                        }
                        this.visibleIcons[26] = this.heatingTimeIcon;
                        break;
                     case ItemProperty.MECH_RESISTANCE:
                        Main.writeVarsToConsoleChannel("GARAGE WINDOW","ItemProperty: MECH_RESISTANCE");
                        if(showProperties)
                        {
                           this.mechResistanceIcon.labelText = p.value;
                        }
                        else
                        {
                           this.mechResistanceIcon.labelText = "";
                        }
                        this.visibleIcons[13] = this.mechResistanceIcon;
                        break;
                     case ItemProperty.FIRE_RESISTANCE:
                        Main.writeVarsToConsoleChannel("GARAGE WINDOW","ItemProperty: FIRE_RESISTANCE");
                        if(showProperties)
                        {
                           this.fireResistanceIcon.labelText = p.value;
                        }
                        else
                        {
                           this.fireResistanceIcon.labelText = "";
                        }
                        this.visibleIcons[14] = this.fireResistanceIcon;
                        break;
                     case ItemProperty.PLASMA_RESISTANCE:
                        Main.writeVarsToConsoleChannel("GARAGE WINDOW","ItemProperty: PLASMA_RESISTANCE");
                        if(showProperties)
                        {
                           this.plasmaResistanceIcon.labelText = p.value;
                        }
                        else
                        {
                           this.plasmaResistanceIcon.labelText = "";
                        }
                        this.visibleIcons[15] = this.plasmaResistanceIcon;
                        break;
                     case ItemProperty.RAIL_RESISTANCE:
                        Main.writeVarsToConsoleChannel("GARAGE WINDOW","ItemProperty: RAIL_RESISTANCE");
                        if(showProperties)
                        {
                           this.railResistanceIcon.labelText = p.value;
                        }
                        this.visibleIcons[16] = this.railResistanceIcon;
                        break;
                     case ItemProperty.TERMINATOR_RESISTANCE:
                        Main.writeVarsToConsoleChannel("GARAGE WINDOW","ItemProperty: TERMINATOR_RESISTANCE");
                        if(showProperties)
                        {
                           this.terminatorResistanceIcon.labelText = p.value;
                        }
                        this.visibleIcons[17] = this.terminatorResistanceIcon;
                        break;
                     case ItemProperty.MINE_RESISTANCE:
                        Main.writeVarsToConsoleChannel("GARAGE WINDOW","ItemProperty: TERMINATOR_RESISTANCE");
                        if(showProperties)
                        {
                           this.mineResistanceIcon.labelText = p.value;
                        }
                        this.visibleIcons[24] = this.mineResistanceIcon;
                        break;
                     case ItemProperty.VAMPIRE_RESISTANCE:
                        Main.writeVarsToConsoleChannel("GARAGE WINDOW","ItemProperty: VAMPIRE_RESISTANCE");
                        if(showProperties)
                        {
                           this.vampireResistanceIcon.labelText = p.value;
                        }
                        else
                        {
                           this.vampireResistanceIcon.labelText = "";
                        }
                        this.visibleIcons[18] = this.vampireResistanceIcon;
                        break;
                     case ItemProperty.THUNDER_RESISTANCE:
                        Main.writeVarsToConsoleChannel("GARAGE WINDOW","ItemProperty: THUNDER_RESISTANCE");
                        if(showProperties)
                        {
                           this.thunderResistanceIcon.labelText = p.value;
                        }
                        else
                        {
                           this.thunderResistanceIcon.labelText = "";
                        }
                        this.visibleIcons[19] = this.thunderResistanceIcon;
                        break;
                     case ItemProperty.FREEZE_RESISTANCE:
                        Main.writeVarsToConsoleChannel("GARAGE WINDOW","ItemProperty: VAMPIRE_RESISTANCE");
                        if(showProperties)
                        {
                           this.freezeResistanceIcon.labelText = p.value;
                        }
                        else
                        {
                           this.freezeResistanceIcon.labelText = "";
                        }
                        this.visibleIcons[20] = this.freezeResistanceIcon;
                        break;
                     case ItemProperty.RICOCHET_RESISTANCE:
                        Main.writeVarsToConsoleChannel("GARAGE WINDOW","ItemProperty: VAMPIRE_RESISTANCE");
                        if(showProperties)
                        {
                           this.ricochetResistanceIcon.labelText = p.value;
                        }
                        else
                        {
                           this.ricochetResistanceIcon.labelText = "";
                        }
                        this.visibleIcons[21] = this.ricochetResistanceIcon;
                        break;
                     case ItemProperty.SHAFT_RESISTANCE:
                        Main.writeVarsToConsoleChannel("GARAGE WINDOW","ItemProperty: VAMPIRE_RESISTANCE");
                        if(showProperties)
                        {
                           this.shaftResistanceIcon.labelText = p.value;
                        }
                        else
                        {
                           this.shaftResistanceIcon.labelText = "";
                        }
                        this.visibleIcons[22] = this.shaftResistanceIcon;
                        break;
                     case ItemProperty.HEALING_RADUIS:
                        Main.writeVarsToConsoleChannel("GARAGE WINDOW","ItemProperty: HEALING_RADUIS");
                        if(showProperties)
                        {
                           this.healingRadiusIcon.labelText = p.value;
                        }
                        else
                        {
                           this.healingRadiusIcon.labelText = "";
                        }
                        this.visibleIcons[23] = this.healingRadiusIcon;
                        break;
                     case ItemProperty.HEAL_RATE:
                        Main.writeVarsToConsoleChannel("GARAGE WINDOW","ItemProperty: HEAL_RATE");
                        if(showProperties)
                        {
                           this.healRateIcon.labelText = p.value;
                        }
                        else
                        {
                           this.healRateIcon.labelText = "";
                        }
                        this.visibleIcons[5] = this.healRateIcon;
                        break;
                     case ItemProperty.VAMPIRE_RATE:
                        Main.writeVarsToConsoleChannel("GARAGE WINDOW","ItemProperty: VAMPIRE_RATE");
                        if(showProperties)
                        {
                           this.vampireRateIcon.labelText = p.value;
                        }
                        else
                        {
                           this.vampireRateIcon.labelText = "";
                        }
                        this.visibleIcons[6] = this.vampireRateIcon;
                        break;
                  }
               }
               Main.writeVarsToConsoleChannel("GARAGE WINDOW"," ");
            }
         }
         else
         {
            for(j = 0; j < properties.length; j++)
            {
               pv = properties[j] as ItemPropertyValue;
               switch(pv.property)
               {
                  case ItemProperty.TURRET_TURN_SPEED:
                     Main.writeVarsToConsoleChannel("GARAGE WINDOW","ItemProperty: TURRET_TURN_SPEED");
                     if(showProperties)
                     {
                        this.turretRotationRateIcon.labelText = p.value;
                     }
                     else
                     {
                        this.turretRotationRateIcon.labelText = "";
                     }
                     this.visibleIcons[4] = this.turretRotationRateIcon;
                     break;
                  case ItemProperty.SHAFT_DAMAGE:
                     Main.writeVarsToConsoleChannel("GARAGE WINDOW","ItemProperty: SHOT_FREQUENCY");
                     if(showProperties)
                     {
                        this.shaftDamageIcon.labelText = p.value;
                     }
                     else
                     {
                        this.shaftDamageIcon.labelText = "";
                     }
                     this.visibleIcons[2] = this.shaftDamageIcon;
                     break;
                  case ItemProperty.SHAFT_FIRE_RATE:
                     Main.writeVarsToConsoleChannel("GARAGE WINDOW","ItemProperty: SHOT_FREQUENCY");
                     if(showProperties)
                     {
                        this.shaftRateOfFireIcon.labelText = p.value;
                     }
                     else
                     {
                        this.shaftRateOfFireIcon.labelText = "";
                     }
                     this.visibleIcons[3] = this.shaftRateOfFireIcon;
                     break;
                  case ItemProperty.SHOT_FREQUENCY:
                     Main.writeVarsToConsoleChannel("GARAGE WINDOW","ItemProperty: SHOT_FREQUENCY");
                     if(showProperties)
                     {
                        this.rateOfFireIcon.labelText = p.value;
                     }
                     else
                     {
                        this.rateOfFireIcon.labelText = "";
                     }
                     this.visibleIcons[1] = this.rateOfFireIcon;
                     break;
                  case ItemProperty.DAMAGE:
                     Main.writeVarsToConsoleChannel("GARAGE WINDOW","ItemProperty: SHOT_FREQUENCY");
                     if(showProperties)
                     {
                        this.damageIcon.labelText = p.value;
                     }
                     else
                     {
                        this.damageIcon.labelText = "";
                     }
                     this.visibleIcons[0] = this.damageIcon;
                     break;
               }
            }
         }
         Main.writeVarsToConsoleChannel("GARAGE WINDOW","   visibleIcons.length before: %1",this.visibleIcons.length);
         i = 0;
         while(i < this.visibleIcons.length)
         {
            if(this.visibleIcons[i] == null)
            {
               this.visibleIcons.splice(i,1);
            }
            else
            {
               i++;
            }
         }
         Main.writeVarsToConsoleChannel("GARAGE WINDOW","   visibleIcons.length after: %1",this.visibleIcons.length);
         if(this.visibleIcons.length > 0)
         {
            this.showIcons();
            if(!this.scrollContainer.contains(this.propertiesPanel))
            {
               this.scrollContainer.addChild(this.propertiesPanel);
            }
         }
         else if(this.scrollContainer.contains(this.propertiesPanel))
         {
            this.scrollContainer.removeChild(this.propertiesPanel);
         }
         if(itemParams.itemType == ItemTypeEnum.KIT)
         {
            data = KitsInfoData.getData(itemParams.baseItemId);
            if(data != null)
            {
               kitPackage = data.info;
               this.isKit = true;
               this.hideKitInfoPanel();
               this.kitView = new KitPackageDescriptionView();
               this.addKitInfoPanel();
               this.kitView.show(new KitPackage(kitPackage),data.discount);
            }
            else
            {
               this.isKit = false;
               this.hideKitInfoPanel();
            }
         }
         else
         {
            this.isKit = false;
            this.hideKitInfoPanel();
         }
         if(this.type == ItemTypeEnum.ARMOR || this.type == ItemTypeEnum.WEAPON)
         {
            this.propertiesPanelLeft.bitmapData = upgradeTableLeftBd;
            this.propertiesPanelCenter.bitmapData = upgradeTableCenterBd;
            this.propertiesPanelRight.bitmapData = upgradeTableRightBd;
            mods = itemParams.modifications;
            this.showModTable();
            this.modTable.changeRowCount(mods.length);
            this.modTable.select(itemParams.modificationIndex);
            for(m = 0; m < mods.length; m++)
            {
               modInfo = ModificationInfo(mods[m]);
               Main.writeVarsToConsoleChannel("GARAGE WINDOW","   modInfo: %1",modInfo);
               row = ModInfoRow(this.modTable.rows[m]);
               if(row != null)
               {
                  row.costLabel.text = modInfo.crystalPrice.toString();
                  if(maxWidth < row.costLabel.width)
                  {
                     maxWidth = row.costLabel.width;
                  }
                  this.modTable.maxCostWidth = maxWidth;
                  Main.writeVarsToConsoleChannel("GARAGE WINDOW","   maxCostWidth: %1",this.modTable.maxCostWidth);
                  Main.writeVarsToConsoleChannel("GARAGE WINDOW","   constWidth: %1",this.modTable.constWidth);
                  row.rankIcon.rang = modInfo.rankId;
                  text = new Array();
                  modProperties = modInfo.itemProperties;
                  if(itemId.indexOf("shaft_") < 0)
                  {
                     Main.writeVarsToConsoleChannel("GARAGE WINDOW","   modProperties: %1",modProperties);
                     for(i = 0; i < modProperties.length; i++)
                     {
                        p = modProperties[i] as ItemPropertyValue;
                        switch(p.property)
                        {
                           case ItemProperty.ARMOR:
                              text[5] = p.value;
                              break;
                           case ItemProperty.DAMAGE:
                              text[5] = p.value;
                              break;
                           case ItemProperty.DAMAGE_PER_SECOND:
                              text[5] = p.value;
                              break;
                           case ItemProperty.AIMING_ERROR:
                              text[8] = p.value;
                              break;
                           case ItemProperty.CONE_ANGLE:
                              text[8] = p.value;
                              break;
                           case ItemProperty.SHOT_AREA:
                              text[10] = p.value;
                              break;
                           case ItemProperty.SHOT_FREQUENCY:
                              text[6] = p.value;
                              break;
                           case ItemProperty.SHAFT_DAMAGE:
                              text[7] = p.value;
                              break;
                           case ItemProperty.SHAFT_FIRE_RATE:
                              text[8] = p.value;
                              break;
                           case ItemProperty.SHOT_RANGE:
                              text[9] = p.value;
                              break;
                           case ItemProperty.TURRET_TURN_SPEED:
                              text[7] = p.value;
                              break;
                           case ItemProperty.SPEED:
                              text[11] = p.value;
                              break;
                           case ItemProperty.TURN_SPEED:
                              text[12] = p.value;
                              break;
                           case ItemProperty.MECH_RESISTANCE:
                              text[13] = p.value;
                              break;
                           case ItemProperty.FIRE_RESISTANCE:
                              text[14] = p.value;
                              break;
                           case ItemProperty.PLASMA_RESISTANCE:
                              text[15] = p.value;
                              break;
                           case ItemProperty.RAIL_RESISTANCE:
                              text[16] = p.value;
                              break;
                           case ItemProperty.VAMPIRE_RESISTANCE:
                              text[17] = p.value;
                              break;
                           case ItemProperty.SHAFT_RESISTANCE:
                              text[18] = p.value;
                              break;
                           case ItemProperty.HEALING_RADUIS:
                              text[18] = p.value;
                              break;
                           case ItemProperty.CRITICAL_CHANCE:
                              text[19] = p.value;
                              break;
                           case ItemProperty.HEATING_TIME:
                              text[20] = p.value;
                              break;
                           case ItemProperty.HEAL_RATE:
                              text[5] = p.value;
                              break;
                           case ItemProperty.VAMPIRE_RATE:
                              text[6] = p.value;
                              break;
                        }
                     }
                  }
                  else
                  {
                     for(i = 0; i < modProperties.length; i++)
                     {
                        p = modProperties[i] as ItemPropertyValue;
                        switch(p.property)
                        {
                           case ItemProperty.SHAFT_DAMAGE:
                              text[2] = p.value;
                              break;
                           case ItemProperty.SHAFT_FIRE_RATE:
                              text[3] = p.value;
                              break;
                           case ItemProperty.DAMAGE:
                              text[0] = p.value;
                              break;
                           case ItemProperty.TURRET_TURN_SPEED:
                              text[4] = p.value;
                              break;
                           case ItemProperty.SHOT_FREQUENCY:
                              text[1] = p.value;
                              break;
                        }
                     }
                  }
                  i = 0;
                  while(i < text.length)
                  {
                     if(text[i] == null)
                     {
                        text.splice(i,1);
                     }
                     else
                     {
                        i++;
                     }
                  }
                  row.setLabelsNum(text.length);
                  row.setLabelsText(text);
               }
            }
            this.modTable.correctNonintegralValues();
         }
         else
         {
            this.propertiesPanelLeft.bitmapData = propertiesLeftBd;
            this.propertiesPanelCenter.bitmapData = propertiesCenterBd;
            this.propertiesPanelRight.bitmapData = propertiesRightBd;
            this.hideModTable();
         }
         if(storeItem)
         {
            this.buttonBuy.visible = true;
            this.buttonEquip.visible = false;
            this.buttonUpgrade.visible = false;
         }
         else if(this.type == ItemTypeEnum.INVENTORY)
         {
            this.buttonBuy.visible = true;
            this.buttonEquip.visible = false;
            this.buttonUpgrade.visible = false;
         }
         else
         {
            this.buttonBuy.visible = false;
            if(this.type == ItemTypeEnum.PLUGIN)
            {
               this.buttonEquip.visible = false;
               this.buttonUpgrade.visible = false;
               this.buttonBuyCrystals.visible = false;
            }
            else
            {
               this.buttonEquip.visible = true;
               if(this.type == ItemTypeEnum.ARMOR || this.type == ItemTypeEnum.WEAPON)
               {
                  this.buttonUpgrade.visible = itemParams.modificationIndex < 3 && itemParams.modifications.length > 1;
               }
               else
               {
                  this.buttonUpgrade.visible = false;
               }
            }
         }
         if(this.buttonBuy.visible)
         {
            rank = this.panelModel.rank >= this.params.rankId ? int(this.params.rankId) : int(-this.params.rankId);
            if(this.type == ItemTypeEnum.INVENTORY)
            {
               cost = this.panelModel.crystal >= this.inventoryNumStepper.value * this.params.price ? int(this.inventoryNumStepper.value * this.params.price) : int(-this.inventoryNumStepper.value * this.params.price);
               this.inventoryNumStepper.visible = true;
               acceptableNum = Math.min(ItemInfoPanel.INVENTORY_MAX_VALUE,Math.floor(this.panelModel.crystal / this.params.price));
               if(rank > 0)
               {
                  if(acceptableNum > 0)
                  {
                     this.inventoryNumStepper.enabled = true;
                     this.inventoryNumStepper.alpha = 1;
                  }
                  else
                  {
                     this.inventoryNumStepper.enabled = false;
                     this.inventoryNumStepper.alpha = 0.7;
                  }
               }
               else
               {
                  this.inventoryNumStepper.enabled = false;
                  this.inventoryNumStepper.alpha = 0.7;
               }
            }
            else
            {
               cost = this.panelModel.crystal >= this.params.price ? int(this.params.price) : int(-this.params.price);
               this.inventoryNumStepper.visible = false;
            }
            this.buttonBuy.setInfo(cost,rank);
            this.buttonBuy.enable = cost >= 0 && rank > 0;
            if(rank > 0 && cost < 0)
            {
               this.requiredCrystalsNum = -cost - this.panelModel.crystal;
               this.buttonBuyCrystals.visible = true;
               this.buttonBuyCrystals.setInfo(this.requiredCrystalsNum,this.requiredCrystalsNum * GarageModel.buyCrystalRate);
            }
            else
            {
               this.buttonBuyCrystals.visible = false;
            }
         }
         else if(this.buttonUpgrade.visible)
         {
            this.inventoryNumStepper.visible = false;
            cost = this.params.nextModificationPrice > this.panelModel.crystal ? int(-this.params.nextModificationPrice) : int(this.params.nextModificationPrice);
            rank = this.panelModel.rank >= this.params.nextModificationRankId ? int(this.params.nextModificationRankId) : int(-this.params.nextModificationRankId);
            this.buttonUpgrade.setInfo(cost,rank);
            this.buttonUpgrade.enable = cost > 0 && rank > 0;
            if(this.params.nextModificationPrice > this.panelModel.crystal && this.panelModel.rank >= this.params.nextModificationRankId)
            {
               this.requiredCrystalsNum = -cost - this.panelModel.crystal;
               this.buttonBuyCrystals.visible = true;
               this.buttonBuyCrystals.setInfo(this.requiredCrystalsNum,this.requiredCrystalsNum * GarageModel.buyCrystalRate);
            }
            else
            {
               this.buttonBuyCrystals.visible = false;
            }
         }
         else
         {
            this.inventoryNumStepper.visible = false;
            this.buttonBuyCrystals.visible = false;
         }
         this.posButtons();
         if(this.type == ItemTypeEnum.PLUGIN && !storeItem)
         {
            if(!this.scrollContainer.contains(this.timeIndicator))
            {
               this.scrollContainer.addChild(this.timeIndicator);
            }
            itemEffectModel = (this.modelRegister.getModelsByInterface(IItemEffect) as Vector.<IModel>)[0] as IItemEffect;
            this.timeRemaining = new Date(itemEffectModel.getTimeRemaining(itemId));
         }
         else if(this.scrollContainer.contains(this.timeIndicator))
         {
            this.scrollContainer.removeChild(this.timeIndicator);
         }
      }
      
      private function posButtons() : void
      {
         var buttonY:int = this.size.y - this.margin - this.buttonSize.y + 1;
         if(this.buttonBuy.visible)
         {
            this.buttonBuy.y = buttonY;
            if(this.type == ItemTypeEnum.INVENTORY)
            {
               this.inventoryNumStepper.x = -7;
               this.inventoryNumStepper.y = this.buttonBuy.y + Math.round((this.buttonSize.y - this.inventoryNumStepper.height) * 0.5);
               this.buttonBuy.x = this.inventoryNumStepper.x + this.inventoryNumStepper.width + 10;
            }
            else
            {
               this.buttonBuy.x = this.margin;
            }
         }
         if(this.buttonEquip.visible)
         {
            this.buttonEquip.y = buttonY;
            this.buttonEquip.x = this.size.x - this.margin - this.buttonSize.x;
         }
         if(this.buttonUpgrade.visible)
         {
            this.buttonUpgrade.y = buttonY;
            this.buttonUpgrade.x = this.margin;
         }
         if(this.buttonBuyCrystals.visible)
         {
            this.buttonBuyCrystals.y = buttonY;
            if(this.buttonBuy.visible)
            {
               this.buttonBuyCrystals.x = this.buttonBuy.x + this.buttonSize.x + 15;
            }
            else
            {
               this.buttonBuyCrystals.x = this.buttonUpgrade.x + this.buttonSize.x + 15;
            }
         }
      }
      
      private function addKitInfoPanel() : void
      {
         if(!this.scrollContainer.contains(this.kitView))
         {
            this.scrollContainer.addChild(this.kitView);
         }
      }
      
      private function hideKitInfoPanel() : void
      {
         if(this.scrollContainer.contains(this.kitView))
         {
            this.scrollContainer.removeChild(this.kitView);
         }
      }
      
      public function getSkinText() : String
      {
         return this.skinText;
      }
      
      public function resize(width:int, height:int) : void
      {
         var minContainerHeight:int = 0;
         var iconsNum:int = 0;
         var iconY:int = 0;
         var iconsWidth:int = 0;
         var summWidth:int = 0;
         var leftMargin:int = 0;
         var coords:Array = null;
         var i:int = 0;
         var icon:ItemPropertyIcon = null;
         var m:int = 0;
         var row:ModInfoRow = null;
         Main.writeVarsToConsoleChannel("GARAGE WINDOW","ItemInfoPanel resize width: %1, height: %2",width,height);
         this.scrollPane.update();
         this.size.x = width;
         this.size.y = height;
         this.window.width = width;
         this.window.height = height;
         this.inner.width = width - this.margin * 2;
         this.inner.height = height - this.margin - this.bottomMargin;
         this.areaRect.width = width - this.margin * 2 - 2;
         this.areaRect2.width = this.areaRect.width - this.horizMargin * 2;
         this.descrTf.x = this.horizMargin - 3;
         this.descrTf.width = this.areaRect2.width;
         if(this.visibleIcons != null)
         {
            iconsNum = this.visibleIcons.length;
            if(iconsNum > 0)
            {
               minContainerHeight = this.propertiesPanel.y + this.propertiesPanel.height + this.vertMargin;
               this.propertiesPanelRight.x = this.areaRect2.width - this.propertiesPanelRight.width;
               this.propertiesPanelCenter.width = this.propertiesPanelRight.x - this.propertiesPanelCenter.x;
               iconY = 6;
               iconsWidth = armorBd.width * iconsNum + this.iconSpace * (iconsNum - 1);
               summWidth = iconsWidth;
               if(this.scrollContainer.contains(this.modTable))
               {
                  summWidth += this.modTable.constWidth;
               }
               Main.writeVarsToConsoleChannel("GARAGE WINDOW","   summWidth: %1",summWidth);
               leftMargin = Math.round((this.propertiesPanel.width - summWidth) * 0.5);
               Main.writeVarsToConsoleChannel("GARAGE WINDOW","   leftMargin: %1",leftMargin);
               coords = new Array();
               for(i = 0; i < iconsNum; i++)
               {
                  icon = this.visibleIcons[i] as ItemPropertyIcon;
                  icon.x = leftMargin + i * (armorBd.width + this.iconSpace);
                  icon.y = iconY;
                  if(this.type == ItemTypeEnum.ARMOR || this.type == ItemTypeEnum.WEAPON)
                  {
                     coords.push(this.propertiesPanel.x + icon.x - this.modTable.x + armorBd.width * 0.5);
                  }
               }
               Main.writeVarsToConsoleChannel("GARAGE WINDOW","   coords: %1",coords);
               if(this.type == ItemTypeEnum.ARMOR || this.type == ItemTypeEnum.WEAPON)
               {
                  this.modTable.y = this.propertiesPanel.y + 6 + icon.height + 2;
                  this.modTable.resizeSelection(this.areaRect2.width);
                  for(m = 0; m < 4; m++)
                  {
                     row = ModInfoRow(this.modTable.rows[m]);
                     if(row != null)
                     {
                        row.setLabelsPos(coords);
                        row.setConstPartCoord(leftMargin + iconsWidth + row.hSpace);
                     }
                  }
               }
               this.descrTf.y = this.propertiesPanel.y + this.propertiesPanel.height + this.vertMargin - 4;
            }
            else
            {
               this.descrTf.y = this.areaRect2.y + 24 - 7;
            }
         }
         else
         {
            this.descrTf.y = this.areaRect2.y + 24 - 7;
         }
         minContainerHeight += this.vertMargin + this.descrTf.textHeight - 4;
         var withoutPreviewHeight:int = minContainerHeight;
         if(this.preview.bitmapData != null)
         {
            this.previewVisible = true;
            this.preview.x = this.horizMargin - (this.horizMargin + this.cutPreview);
            if(iconsNum > 0)
            {
               this.preview.y = this.propertiesPanel.y + this.propertiesPanel.height + this.vertMargin;
            }
            else
            {
               this.preview.y = this.areaRect2.y + 24;
            }
            this.descrTf.x = this.preview.x + this.preview.width - this.cutPreview - 3;
            this.descrTf.width = this.areaRect2.width - this.descrTf.x - 3;
            minContainerHeight = Math.max(this.descrTf.y + 3 + this.descrTf.textHeight + this.vertMargin,this.preview.y + this.preview.height + this.vertMargin);
         }
         else
         {
            minContainerHeight = this.descrTf.y + 3 + this.descrTf.textHeight + this.vertMargin;
         }
         var containerHeight:int = Math.max(minContainerHeight,height - this.margin - this.bottomMargin - 2 - this.spaceModule * 2);
         var delta:int = this.preview.y + this.preview.height + 10 + this.kitView.height - containerHeight + 15;
         this.areaRect.height = containerHeight + (!!this.isKit ? (delta > 0 ? delta : 0) : 0);
         this.areaRect2.height = this.area.height - this.vertMargin * 2;
         if(containerHeight > height - this.margin - this.bottomMargin - 2 - this.spaceModule * 2)
         {
            this.previewVisible = false;
            this.descrTf.x = this.horizMargin - 3;
            this.descrTf.width = this.areaRect2.width;
            minContainerHeight = withoutPreviewHeight;
            containerHeight = Math.max(minContainerHeight,height - this.margin - this.bottomMargin - 2 - this.spaceModule * 2);
            this.areaRect.height = containerHeight;
            this.areaRect2.height = this.area.height - this.vertMargin * 2;
         }
         this.area.graphics.clear();
         this.area.graphics.beginFill(16711680,0);
         this.area.graphics.drawRect(this.areaRect.x,this.areaRect.y,this.areaRect.width,this.areaRect.height);
         if(this.previewVisible)
         {
            this.showPreview();
         }
         else
         {
            this.hidePreview();
         }
         this.posButtons();
         this.scrollPane.setSize(width - this.margin * 2 - 2 + 6,height - this.margin - this.bottomMargin - 2 - this.spaceModule * 2);
         this.scrollPane.update();
         if(this.scrollContainer.contains(this.timeIndicator))
         {
            this.timeIndicator.x = this.areaRect2.x + this.areaRect2.width - this.timeIndicator.width + 3;
            this.timeIndicator.y = this.areaRect2.y - 7;
         }
         if(this.isKit)
         {
            if(this.kitView != null)
            {
               this.kitView.x = Math.round((this.scrollContainer.width - this.kitView.width) * 0.5);
               this.kitView.y = this.preview.y + this.preview.height + 10;
            }
         }
      }
      
      public function hideModTable() : void
      {
         if(this.scrollContainer.contains(this.modTable))
         {
            this.scrollContainer.removeChild(this.modTable);
         }
      }
      
      public function showModTable() : void
      {
         if(!this.scrollContainer.contains(this.modTable))
         {
            this.scrollContainer.addChild(this.modTable);
         }
      }
      
      public function hidePreview() : void
      {
         if(this.scrollContainer.contains(this.preview))
         {
            this.scrollContainer.removeChild(this.preview);
         }
      }
      
      public function showPreview() : void
      {
         var previewId:String = null;
         var resource:ImageResource = null;
         var previewBd:BitmapData = null;
         if(!this.scrollContainer.contains(this.preview))
         {
            this.scrollContainer.addChild(this.preview);
            if(this.id != null)
            {
               previewId = (GarageModel.getItemParams(this.id) as ItemParams).previewId;
               if(previewId != null)
               {
                  resource = ResourceUtil.getResource(ResourceType.IMAGE,previewId + "_preview") as ImageResource;
                  previewBd = null;
                  if(resource != null)
                  {
                     previewBd = resource.bitmapData as BitmapData;
                  }
                  else
                  {
                     previewBd = new StubBitmapData(16711680);
                  }
                  this.preview.bitmapData = previewBd;
               }
            }
         }
      }
      
      public function set timeRemaining(time:Date) : void
      {
         var dataString:String = null;
         Main.writeVarsToConsoleChannel("TIME INDICATOR"," ");
         var timeString:String = (time.hours < 10 ? "0" + String(time.hours) : String(time.hours)) + ":" + (time.minutes < 10 ? "0" + String(time.minutes) : String(time.minutes));
         var monthString:String = time.month + 1 < 10 ? "0" + String(time.month + 1) : String(time.month + 1);
         var dayString:String = time.date < 10 ? "0" + String(time.date) : String(time.date);
         if(this.localeService.getText(TextConst.GUI_LANG) == "ru")
         {
            dataString = dayString + "-" + monthString + "-" + String(time.fullYear);
         }
         else
         {
            dataString = monthString + "-" + dayString + "-" + String(time.fullYear);
         }
         this.timeIndicator.text = dayString != "NaN" ? timeString + "  " + dataString : " ";
         Main.writeVarsToConsoleChannel("TIME INDICATOR","set remainingDate: " + timeString + " " + dataString);
         this.resize(this.size.x,this.size.y);
      }
      
      private function inventoryNumChanged(e:Event = null) : void
      {
         Main.writeVarsToConsoleChannel("GARAGE WINDOW","inventoryNumChanged");
         Main.writeVarsToConsoleChannel("GARAGE WINDOW","totalPrice: " + this.params.price * this.inventoryNumStepper.value);
         var rank:int = this.panelModel.rank >= this.params.rankId ? int(this.params.rankId) : int(-this.params.rankId);
         var cost:int = this.panelModel.crystal >= this.params.price * this.inventoryNumStepper.value ? int(this.params.price * this.inventoryNumStepper.value) : int(-this.params.price * this.inventoryNumStepper.value);
         this.buttonBuy.setInfo(cost,rank);
         this.buttonBuy.enable = cost >= 0 && rank > 0;
         if(rank > 0 && cost < 0)
         {
            this.requiredCrystalsNum = -cost - this.panelModel.crystal;
            this.buttonBuyCrystals.visible = true;
            this.buttonBuyCrystals.setInfo(this.requiredCrystalsNum,this.requiredCrystalsNum * GarageModel.buyCrystalRate);
         }
         else
         {
            this.buttonBuyCrystals.visible = false;
         }
         this.posButtons();
      }
   }
}
