package alternativa.tanks.model.challenge
{
   import alternativa.init.Main;
   import alternativa.osgi.service.locale.ILocaleService;
   import alternativa.tanks.locale.constants.TextConst;
   import assets.icons.GarageItemBackground;
   import controls.DefaultButton;
   import controls.Label;
   import controls.TankWindowInner;
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.Sprite;
   import forms.TankWindowWithHeader;
   
   public class ChallengeCongratulationWindow extends Sprite
   {
      
[Embed(source="774.png")]
      private static const congratsBitmap:Class;
      
[Embed(source="1104.png")]
      private static const healthBitmap:Class;
      
[Embed(source="889.png")]
      private static const armorBitmap:Class;
      
[Embed(source="867.png")]
      private static const damageBitmap:Class;
      
[Embed(source="997.png")]
      private static const n2oBitmap:Class;
      
[Embed(source="996.png")]
      private static const mineBitmap:Class;
      
[Embed(source="826.png")]
      private static const cryBitmap:Class;
      
[Embed(source="951.png")]
      private static const flowBitmap:Class;
      
[Embed(source="938.png")]
      private static const impulseBitmap:Class;
      
[Embed(source="1035.png")]
      private static const white_khokhlomaBitmap:Class;
      
[Embed(source="961.png")]
      private static const floraBitmap:Class;
      
[Embed(source="1048.png")]
      private static const foresterBitmap:Class;
      
[Embed(source="1111.png")]
      private static const lavaBitmap:Class;
      
[Embed(source="978.png")]
      private static const leadBitmap:Class;
      
[Embed(source="1159.png")]
      private static const marineBitmap:Class;
      
[Embed(source="843.png")]
      private static const marshBitmap:Class;
      
[Embed(source="1105.png")]
      private static const metallicBitmap:Class;
      
[Embed(source="1172.png")]
      private static const safariBitmap:Class;
      
[Embed(source="1187.png")]
      private static const stormBitmap:Class;
      
[Embed(source="927.png")]
      private static const maryBitmap:Class;
       
      
      private var bitmap:Bitmap;
      
      private var window:TankWindowWithHeader;
      
      private var innerWindow:TankWindowInner;
      
      private var congratsText:Label;
      
      public var closeBtn:DefaultButton;
      
      public var windowWidth;
      
      public var windowHeight;
      
      public function ChallengeCongratulationWindow(prizes:Array)
      {
         this.bitmap = new Bitmap(new congratsBitmap().bitmapData);
         this.window = TankWindowWithHeader.createWindow(ILocaleService(Main.osgi.getService(ILocaleService)).getText(TextConst.CONGRATS_WINDOW_TEXT));
         this.innerWindow = new TankWindowInner(0,0,TankWindowInner.GREEN);
         this.congratsText = new Label();
         this.closeBtn = new DefaultButton();
         super();
         this.window.width = 460;
         this.windowWidth = 460;
         this.window.height = 405;
         this.windowHeight = 405;
         addChild(this.window);
         this.innerWindow.width = this.window.width - 30;
         this.innerWindow.height = this.window.height - 65;
         this.innerWindow.x = 15;
         this.innerWindow.y = 15;
         addChild(this.innerWindow);
         this.bitmap.x = this.innerWindow.width / 2 - this.bitmap.width / 2;
         this.bitmap.y = 5;
         this.innerWindow.addChild(this.bitmap);
         this.congratsText.color = 5898034;
         this.congratsText.text = ILocaleService(Main.osgi.getService(ILocaleService)).getText(TextConst.CONGRATS_WINDOW_CONGRATS_TEXT);
         this.congratsText.x = 5;
         this.congratsText.y = this.bitmap.height + 10;
         this.innerWindow.addChild(this.congratsText);
         this.closeBtn.x = this.window.width - this.closeBtn.width - 15;
         this.closeBtn.y = this.window.height - this.closeBtn.height - 15;
         this.closeBtn.label = ILocaleService(Main.osgi.getService(ILocaleService)).getText(TextConst.FREE_BONUSES_WINDOW_BUTTON_CLOSE_TEXT);
         addChild(this.closeBtn);
         this.setPrizes(prizes);
      }
      
      private function setPrizes(prizes:Array) : void
      {
         var prize:ChallengePrizeInfo = null;
         var panel:GarageItemBackground = null;
         var previewBd:BitmapData = null;
         var preview:Bitmap = null;
         var numLabel:Label = null;
         var i:int = 0;
         for each(prize in prizes)
         {
            panel = new GarageItemBackground(GarageItemBackground.ENGINE_NORMAL);
            panel.x = prizes.length < 2 ? Number(this.innerWindow.width / 2 - panel.width / 2) : Number(i + 10);
            panel.y = this.congratsText.y + this.congratsText.height + 10;
            this.innerWindow.addChild(panel);
            previewBd = this.getBitmap(prize.nameId);
            preview = new Bitmap(previewBd);
            preview.x = panel.width / 2 - preview.width / 2;
            preview.y = panel.height / 2 - preview.height / 2;
            panel.addChild(preview);
            numLabel = new Label();
            panel.addChild(numLabel);
            numLabel.size = 16;
            numLabel.color = 5898034;
            numLabel.text = "×" + prize.count;
            numLabel.x = panel.width - numLabel.width - 15;
            numLabel.y = panel.height - numLabel.height - 10;
            i += panel.width + 10;
         }
      }
      
      private function getBitmap(id:String) : BitmapData
      {
         switch(id)
         {
            case "health_m0":
               return new healthBitmap().bitmapData;
            case "armor_m0":
               return new armorBitmap().bitmapData;
            case "double_damage_m0":
               return new damageBitmap().bitmapData;
            case "n2o_m0":
               return new n2oBitmap().bitmapData;
            case "mine_m0":
               return new mineBitmap().bitmapData;
            case "crystalls_m0":
               return new cryBitmap().bitmapData;
            case "flow_m0":
               return new flowBitmap().bitmapData;
            case "storm_m0":
               return new stormBitmap().bitmapData;
            case "mary_m0":
               return new maryBitmap().bitmapData;
            case "safari_m0":
               return new safariBitmap().bitmapData;
            case "lead_m0":
               return new leadBitmap().bitmapData;
            case "lava_m0":
               return new lavaBitmap().bitmapData;
            case "metallic_m0":
               return new metallicBitmap().bitmapData;
            case "forester_m0":
               return new foresterBitmap().bitmapData;
            case "marsh_m0":
               return new marshBitmap().bitmapData;
            case "marine_m0":
               return new marineBitmap().bitmapData;
            case "flora_m0":
               return new floraBitmap().bitmapData;
            case "impulse_m0":
               return new impulseBitmap().bitmapData;
            case "white_khokhloma_m0":
               return new white_khokhlomaBitmap().bitmapData;
            default:
               return new cryBitmap().bitmapData;
         }
      }
   }
}
