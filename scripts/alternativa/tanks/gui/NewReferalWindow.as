package alternativa.tanks.gui
{
   import alternativa.init.Main;
   import alternativa.osgi.service.locale.ILocaleService;
   import alternativa.service.IModelService;
   import alternativa.tanks.locale.constants.ImageConst;
   import alternativa.tanks.locale.constants.TextConst;
   import alternativa.tanks.model.panel.IPanel;
   import alternativa.tanks.model.panel.PanelModel;
   import assets.Diamond;
   import assets.icons.CheckIcons;
   import controls.DefaultButton;
   import controls.Label;
   import controls.TankInput;
   import controls.TankWindow;
   import controls.TankWindowHeader;
   import controls.TankWindowInner;
   import controls.TextArea;
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.DisplayObject;
   import flash.display.Loader;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import flash.net.URLRequest;
   import flash.system.ApplicationDomain;
   import flash.system.LoaderContext;
   import flash.system.System;
   import flash.text.TextFieldAutoSize;
   import flash.text.TextFieldType;
   import forms.RegisterForm;
   import forms.stat.ReferralStatList;
   import forms.stat.ReferralWindowBigButton;
   import projects.tanks.client.panel.model.referals.RefererIncomeData;
   
   public class NewReferalWindow extends Sprite
   {
      
[Embed(source="1151.png")]
      private static const bitmapIntroPict:Class;
      
      private static const introPictBd:BitmapData = new bitmapIntroPict().bitmapData;
      
[Embed(source="1157.png")]
      private static const bitmapIconMail:Class;
      
      private static const iconMailBd:BitmapData = new bitmapIconMail().bitmapData;
      
[Embed(source="1196.png")]
      private static const bitmapIconLink:Class;
      
      private static const iconLinkBd:BitmapData = new bitmapIconLink().bitmapData;
      
[Embed(source="846.png")]
      private static const bitmapIconCode:Class;
      
      private static const iconCodeBd:BitmapData = new bitmapIconCode().bitmapData;
       
      
      private var localeService:ILocaleService;
      
      private var getLinkButton:ReferralWindowBigButton;
      
      private var getBannerButton:ReferralWindowBigButton;
      
      private var inviteByMailButton:ReferralWindowBigButton;
      
      public var closeButton:DefaultButton;
      
      public var statButton:ReferalStatButton;
      
      private var copyLinkButton:DefaultButton;
      
      private var copyBannerButton:DefaultButton;
      
      private var sendButton:DefaultButton;
      
      private var window:TankWindow;
      
      private var windowInner:TankWindowInner;
      
      private var introInner:TankWindowInner;
      
      private var statInner:TankWindowInner;
      
      private var countInner:TankWindowInner;
      
      private var crystalsInner:TankWindowInner;
      
      private var descrInner:TankWindowInner;
      
      private var introHeader:Bitmap;
      
      private var introPic:Bitmap;
      
      public var referalList:ReferralStatList;
      
      private var introContainer:Sprite;
      
      private var linkContainer:Sprite;
      
      private var bannerContainer:Sprite;
      
      private var mailContainer:Sprite;
      
      private var statContainer:Sprite;
      
      private var banner:DisplayObject;
      
      private var bannerLoadEffect:CheckIcons;
      
      private var infoLabel:Label;
      
      private var descrLabel:Label;
      
      private var linkURL:TankInput;
      
      private var bannerCode:TextArea;
      
      private var nameInputLabel:Label;
      
      public var nameInput:TankInput;
      
      private var enterMailLabel:Label;
      
      private var mailTextLabel:Label;
      
      private var addressInput:TankInput;
      
      private var mailText:TextArea;
      
      private var countLabel:Label;
      
      private var countLabelHeader:Label;
      
      private var crystalLabel:Label;
      
      private var crystalLabelHeader:Label;
      
      private var loader:Loader;
      
      public var windowSize:Point;
      
      private const windowMargin:int = 12;
      
      private const margin:int = 9;
      
      private const listmargin:int = 4;
      
      private const buttonSize:Point = new Point(104,33);
      
      private const bannerSize:Point = new Point(468,120);
      
      private const space:int = 0;
      
      private var state:int;
      
      private const STATE_INTRO:int = 0;
      
      private const STATE_LINK:int = 1;
      
      private const STATE_BANNER:int = 2;
      
      private const STATE_MAIL:int = 3;
      
      private const STATE_STAT:int = 4;
      
      private var messageTemplate:String;
      
      private var panelModel:IPanel;
      
      private const bottomMargin:int = 104;
      
      public var crystalIcon:Diamond;
      
      public function NewReferalWindow(hash:String, bannerCodeString:String, url:String, messageTemplate:String)
      {
         var tableLinkURL:String = null;
         super();
         this.messageTemplate = messageTemplate.split("\n\r").join("\n").split("\r\n").join("\n");
         this.localeService = Main.osgi.getService(ILocaleService) as ILocaleService;
         var modelRegister:IModelService = Main.osgi.getService(IModelService) as IModelService;
         this.panelModel = Main.osgi.getService(IPanel) as PanelModel;
         this.window = new TankWindow();
         addChild(this.window);
         this.window.headerLang = this.localeService.getText(TextConst.GUI_LANG);
         this.window.header = TankWindowHeader.REFERALS;
         this.getLinkButton = new ReferralWindowBigButton();
         this.getLinkButton.icon = iconLinkBd;
         addChild(this.getLinkButton);
         this.getLinkButton.label = this.localeService.getText(TextConst.REFERAL_WINDOW_BUTTON_GET_LINK_TEXT);
         this.getLinkButton.addEventListener(MouseEvent.CLICK,this.onLinkClick);
         this.getBannerButton = new ReferralWindowBigButton();
         this.getBannerButton.icon = iconCodeBd;
         addChild(this.getBannerButton);
         this.getBannerButton.label = this.localeService.getText(TextConst.REFERAL_WINDOW_BUTTON_GET_BANNER_TEXT);
         this.getBannerButton.addEventListener(MouseEvent.CLICK,this.onBannerClick);
         this.inviteByMailButton = new ReferralWindowBigButton();
         this.inviteByMailButton.icon = iconMailBd;
         addChild(this.inviteByMailButton);
         this.inviteByMailButton.label = this.localeService.getText(TextConst.REFERAL_WINDOW_BUTTON_INVITE_BY_EMAIL_TEXT);
         this.inviteByMailButton.addEventListener(MouseEvent.CLICK,this.onMailClick);
         this.statButton = new ReferalStatButton();
         addChild(this.statButton);
         this.statButton.label = this.localeService.getText(TextConst.REFERAL_WINDOW_BUTTON_STATISTICS_TEXT);
         this.statButton.addEventListener(MouseEvent.CLICK,this.onStatClick);
         this.closeButton = new DefaultButton();
         addChild(this.closeButton);
         this.closeButton.label = this.localeService.getText(TextConst.REFERAL_WINDOW_BUTTON_CLOSE_TEXT);
         this.descrInner = new TankWindowInner(0,0,TankWindowInner.GREEN);
         this.descrInner.x = this.windowMargin;
         this.descrInner.y = this.windowMargin;
         addChild(this.descrInner);
         this.descrInner.visible = false;
         this.descrLabel = new Label();
         this.descrLabel.color = 381208;
         this.descrLabel.multiline = true;
         this.descrLabel.wordWrap = true;
         addChild(this.descrLabel);
         this.descrLabel.visible = false;
         this.windowInner = new TankWindowInner(0,0,TankWindowInner.TRANSPARENT);
         this.windowInner.x = this.windowMargin;
         addChild(this.windowInner);
         this.windowInner.visible = false;
         this.introContainer = new Sprite();
         addChild(this.introContainer);
         this.introInner = new TankWindowInner(0,0,TankWindowInner.GREEN);
         this.introInner.x = this.windowMargin;
         this.introInner.y = this.windowMargin;
         this.introContainer.addChild(this.introInner);
         var headerBd:BitmapData = this.localeService.getImage(ImageConst.REFERAL_WINDOW_HEADER_IMAGE);
         this.introHeader = new Bitmap(headerBd);
         this.introContainer.addChild(this.introHeader);
         this.introPic = new Bitmap(introPictBd);
         this.introContainer.addChild(this.introPic);
         this.infoLabel = new Label();
         this.infoLabel.color = 381208;
         this.infoLabel.multiline = true;
         this.infoLabel.wordWrap = true;
         this.introContainer.addChild(this.infoLabel);
         switch(this.localeService.language)
         {
            case "ru":
               tableLinkURL = "http://forum.tankionline.com/posts/list/3210.page";
               break;
            case "en":
               tableLinkURL = "http://forum.tankionline.com/posts/list/1150.page";
               break;
            case "cn":
               tableLinkURL = "http://3dtank.com";
               break;
            default:
               tableLinkURL = "";
         }
         this.infoLabel.htmlText = this.localeService.getText(TextConst.REFERAL_WINDOW_INFO_TEXT,tableLinkURL);
         this.statContainer = new Sprite();
         addChild(this.statContainer);
         this.statInner = new TankWindowInner(0,0,TankWindowInner.GREEN);
         this.statContainer.addChild(this.statInner);
         this.countInner = new TankWindowInner(0,0,TankWindowInner.GREEN);
         this.statContainer.addChild(this.countInner);
         this.crystalsInner = new TankWindowInner(0,0,TankWindowInner.GREEN);
         this.statContainer.addChild(this.crystalsInner);
         this.countLabelHeader = new Label();
         this.countLabelHeader.text = this.localeService.getText(TextConst.REFERAL_WINDOW_COUNT_LABEL);
         this.statContainer.addChild(this.countLabelHeader);
         this.countLabel = new Label();
         this.countLabel.autoSize = TextFieldAutoSize.RIGHT;
         this.countLabel.color = 381208;
         this.countLabel.text = "0";
         this.statContainer.addChild(this.countLabel);
         this.crystalLabelHeader = new Label();
         this.crystalLabelHeader.text = this.localeService.getText(TextConst.REFERAL_WINDOW_SUMMARY_LABEL);
         this.statContainer.addChild(this.crystalLabelHeader);
         this.crystalIcon = new Diamond();
         this.statContainer.addChild(this.crystalIcon);
         this.crystalLabel = new Label();
         this.crystalLabel.autoSize = TextFieldAutoSize.RIGHT;
         this.crystalLabel.color = 381208;
         this.crystalLabel.text = "0";
         this.statContainer.addChild(this.crystalLabel);
         this.referalList = new ReferralStatList();
         this.statContainer.addChild(this.referalList);
         this.linkContainer = new Sprite();
         addChild(this.linkContainer);
         this.linkURL = new TankInput();
         this.linkURL.textField.type = TextFieldType.DYNAMIC;
         this.linkContainer.addChild(this.linkURL);
         this.linkURL.textField.text = url;
         this.copyLinkButton = new DefaultButton();
         this.linkContainer.addChild(this.copyLinkButton);
         this.copyLinkButton.width = 220;
         this.copyLinkButton.label = this.localeService.getText(TextConst.REFERAL_WINDOW_BUTTON_COPY_LINK_TEXT);
         this.copyLinkButton.addEventListener(MouseEvent.CLICK,this.copyLink);
         this.bannerContainer = new Sprite();
         addChild(this.bannerContainer);
         var context:LoaderContext = new LoaderContext(false,new ApplicationDomain());
         this.loader = new Loader();
         this.loader.load(new URLRequest("http://" + this.localeService.getText(TextConst.GAME_BASE_URL) + "/tankiref.swf?hash=" + hash + "&server=" + this.localeService.getText(TextConst.GAME_BASE_URL)),context);
         this.loader.contentLoaderInfo.addEventListener(Event.COMPLETE,this.addbanner);
         this.banner = new Sprite();
         this.bannerContainer.addChild(this.banner);
         with(this.banner as Sprite)
         {
            graphics.beginFill(0,0.5);
            graphics.drawRect(0,0,bannerSize.x,bannerSize.y);
         }
         this.bannerLoadEffect = new CheckIcons();
         this.bannerLoadEffect.gotoAndStop(RegisterForm.CALLSIGN_STATE_PROGRESS);
         this.bannerContainer.addChild(this.bannerLoadEffect);
         this.bannerCode = new TextArea();
         this.bannerCode.tf.text = bannerCodeString;
         this.bannerContainer.addChild(this.bannerCode);
         this.copyBannerButton = new DefaultButton();
         this.bannerContainer.addChild(this.copyBannerButton);
         this.copyBannerButton.label = this.localeService.getText(TextConst.REFERAL_WINDOW_BUTTON_COPY_BANNER_TEXT);
         this.copyBannerButton.addEventListener(MouseEvent.CLICK,this.copyBanner);
         this.copyBannerButton.width = 200;
         this.mailContainer = new Sprite();
         addChild(this.mailContainer);
         this.nameInputLabel = new Label();
         this.nameInputLabel.multiline = true;
         this.nameInputLabel.wordWrap = true;
         this.nameInputLabel.htmlText = this.localeService.getText(TextConst.INVITATION_SENDER_NAME_LABEL_TEXT);
         this.mailContainer.addChild(this.nameInputLabel);
         this.nameInput = new TankInput();
         this.nameInput.textField.type = TextFieldType.INPUT;
         this.mailContainer.addChild(this.nameInput);
         this.nameInput.textField.text = this.panelModel.userName;
         this.nameInput.textField.addEventListener(Event.CHANGE,this.onUsernameChange);
         this.enterMailLabel = new Label();
         this.enterMailLabel.multiline = true;
         this.enterMailLabel.wordWrap = true;
         this.enterMailLabel.htmlText = this.localeService.getText(TextConst.REFERAL_WINDOW_EMAIL_LABEL_TEXT);
         this.mailContainer.addChild(this.enterMailLabel);
         this.addressInput = new TankInput();
         this.mailContainer.addChild(this.addressInput);
         this.mailTextLabel = new Label();
         this.mailTextLabel.htmlText = this.localeService.getText(TextConst.REFERAL_WINDOW_LETTER_LABEL_TEXT);
         this.mailContainer.addChild(this.mailTextLabel);
         this.mailText = new TextArea();
         this.mailText.tf.type = TextFieldType.DYNAMIC;
         this.mailText.tf.text = this.messageTemplate.replace("%1",this.panelModel.userName);
         this.mailContainer.addChild(this.mailText);
         this.sendButton = new DefaultButton();
         this.mailContainer.addChild(this.sendButton);
         this.sendButton.label = this.localeService.getText(TextConst.REFERAL_WINDOW_BUTTON_SEND_TEXT);
         this.sendButton.addEventListener(MouseEvent.CLICK,this.sendLetter);
         this.windowSize = new Point(468 + this.windowMargin * 2 + 4,492);
         this.window.width = this.windowSize.x;
         this.window.height = this.windowSize.y;
         this.descrInner.width = this.windowSize.x - this.windowMargin * 2;
         this.descrInner.height = 75;
         this.descrLabel.x = this.descrInner.x + this.margin;
         this.descrLabel.y = this.descrInner.y + this.margin;
         this.descrLabel.width = this.windowSize.x - this.windowMargin * 2 - this.margin * 2;
         this.windowInner.y = this.descrInner.y + this.descrInner.height + this.margin;
         this.windowInner.width = this.windowSize.x - this.windowMargin * 2;
         this.windowInner.height = this.windowSize.y - this.bottomMargin - this.margin - this.windowInner.y;
         this.introInner.width = this.windowSize.x - this.windowMargin * 2;
         this.introInner.height = this.windowSize.y - this.windowMargin - this.bottomMargin - this.margin;
         this.introHeader.x = this.introInner.x + int((this.introInner.width - this.introHeader.width) * 0.5);
         this.introHeader.y = this.introInner.y + this.margin * 2;
         this.introPic.x = this.introInner.x + int((this.introInner.width - this.introPic.width) * 0.5);
         this.introPic.y = this.introInner.y + int(this.introInner.height * (1 - 0.618) - this.introPic.height * 0.5);
         this.infoLabel.x = this.introInner.x + this.margin;
         this.infoLabel.width = this.windowSize.x - this.windowMargin * 2 - this.margin * 2;
         this.infoLabel.y = this.introInner.y + this.introInner.height - this.infoLabel.height - this.margin * 2;
         this.countLabelHeader.x = this.windowMargin;
         this.countInner.width = 100;
         this.countInner.height = 26;
         this.countInner.x = this.countLabelHeader.x + this.countLabelHeader.width + this.margin;
         this.countInner.y = this.windowMargin;
         this.countLabel.x = this.countInner.x + this.countInner.width - this.margin - this.countLabel.width;
         this.countLabelHeader.y = this.windowMargin + int((this.countInner.height - this.countLabelHeader.height) * 0.5);
         this.countLabel.y = this.countLabelHeader.y;
         this.crystalsInner.width = 100;
         this.crystalsInner.height = 26;
         this.crystalsInner.x = this.windowSize.x - this.windowMargin - this.crystalsInner.width;
         this.crystalsInner.y = this.windowMargin;
         this.crystalLabelHeader.x = this.crystalsInner.x - this.margin - this.crystalLabelHeader.width;
         this.crystalIcon.x = this.windowSize.x - this.windowMargin - this.margin - this.crystalIcon.width;
         this.crystalLabel.x = this.crystalIcon.x - 2 - this.crystalLabel.width;
         this.crystalLabelHeader.y = this.windowMargin + int((this.crystalsInner.height - this.crystalLabelHeader.height) * 0.5);
         this.crystalLabel.y = this.crystalLabelHeader.y;
         this.crystalIcon.y = this.windowMargin + int((this.crystalsInner.height - this.crystalIcon.height) * 0.5);
         this.statInner.x = this.windowMargin;
         this.statInner.y = this.windowMargin + this.margin + this.crystalsInner.height - 3;
         this.statInner.width = this.windowSize.x - this.windowMargin * 2;
         this.statInner.height = this.windowSize.y - this.statInner.y - this.bottomMargin - this.margin + 1;
         this.referalList.x = this.windowMargin + this.listmargin;
         this.referalList.y = this.statInner.y + this.listmargin;
         this.linkURL.width = this.windowSize.x - this.windowMargin * 2 - this.margin * 2;
         this.linkURL.x = this.windowInner.x + this.margin;
         this.linkURL.y = this.windowInner.y + this.margin;
         this.copyLinkButton.x = this.windowSize.x - this.copyLinkButton.width >> 1;
         this.copyLinkButton.y = this.windowInner.y + this.margin * 2 + this.buttonSize.y;
         this.sendButton.x = this.windowSize.x - this.windowMargin - this.margin - this.buttonSize.x + 8;
         this.sendButton.y = this.windowInner.y + this.windowInner.height - this.margin - this.buttonSize.y;
         this.nameInputLabel.x = this.windowInner.x + this.margin;
         this.nameInput.y = this.windowInner.y + this.margin;
         this.nameInputLabel.width = 100;
         this.nameInput.x = this.nameInputLabel.x + 100;
         this.nameInputLabel.y = this.nameInput.y;
         this.nameInput.width = this.windowSize.x - this.windowMargin - this.margin - this.nameInput.x;
         this.addressInput.x = this.nameInput.x;
         this.addressInput.y = Math.round(this.nameInput.y + this.nameInput.height + this.margin);
         this.addressInput.width = this.windowSize.x - this.windowMargin - this.margin - this.nameInput.x;
         this.mailText.x = this.nameInput.x;
         this.mailText.y = Math.round(this.addressInput.y + this.addressInput.height + this.margin);
         this.mailText.width = this.windowSize.x - this.windowMargin - this.margin - this.nameInput.x;
         this.mailText.height = Math.round(this.windowInner.y + this.windowInner.height - this.mailText.y - this.margin * 2 - this.buttonSize.y);
         this.mailTextLabel.x = this.windowInner.x + this.margin;
         this.mailTextLabel.y = this.mailText.y;
         this.mailTextLabel.width = 100;
         this.enterMailLabel.x = this.windowInner.x + this.margin;
         this.enterMailLabel.y = this.addressInput.y;
         this.enterMailLabel.width = 100;
         this.mailText.tf.type = TextFieldType.DYNAMIC;
         this.getLinkButton.x = (this.windowSize.x - this.getLinkButton.width >> 1) + 3;
         this.getLinkButton.y = this.windowSize.y - this.bottomMargin;
         this.inviteByMailButton.x = this.windowMargin;
         this.inviteByMailButton.y = this.windowSize.y - this.bottomMargin;
         this.getBannerButton.x = this.getLinkButton.x + this.getLinkButton.width - 4;
         this.getBannerButton.y = this.windowSize.y - this.bottomMargin;
         this.closeButton.x = this.windowSize.x - this.windowMargin - this.buttonSize.x + 8;
         this.closeButton.y = this.windowSize.y - this.windowMargin - this.buttonSize.y;
         this.statButton.x = this.windowMargin;
         this.statButton.y = this.closeButton.y;
         this.statButton.width = 240;
         this.bannerFormLayout();
         this.hideAll();
         this.state = this.STATE_INTRO;
         this.introContainer.visible = true;
      }
      
      public function addReferals(data:Array) : void
      {
         var sum:int = 0;
         this.countLabel.text = data.length.toString();
         for(var i:int = 0; i < data.length; i++)
         {
            sum += RefererIncomeData(data[i]).income;
         }
         this.crystalLabel.text = sum.toString();
         this.statButton.label = this.localeService.getText(TextConst.REFERAL_WINDOW_BUTTON_STATISTICS_TEXT) + " " + sum.toString();
         this.referalList.addReferrals(data);
         this.referalList.width = this.windowSize.x - this.windowMargin * 2 - this.listmargin * 2 + 2;
         this.referalList.height = this.windowSize.y - this.statInner.y - this.bottomMargin - this.margin - this.listmargin * 2;
      }
      
      private function onUsernameChange(e:Event) : void
      {
         if(this.nameInput.textField.text.length)
         {
            this.mailText.tf.text = this.messageTemplate.replace("%1",this.nameInput.textField.text);
         }
         else
         {
            this.mailText.tf.text = this.messageTemplate.replace("%1",this.panelModel.userName);
         }
      }
      
      private function addbanner(e:Event) : void
      {
         this.bannerLoadEffect.gotoAndStop(RegisterForm.CALLSIGN_STATE_OFF);
         this.bannerContainer.removeChild(this.bannerLoadEffect);
         this.bannerContainer.removeChild(this.banner);
         this.banner = this.loader as DisplayObject;
         this.bannerContainer.addChildAt(this.banner,0);
         this.bannerFormLayout();
      }
      
      private function bannerFormLayout() : void
      {
         this.banner.x = this.windowInner.x + 2;
         this.banner.y = this.windowInner.y + 2;
         this.copyBannerButton.x = this.windowSize.x - this.copyBannerButton.width >> 1;
         this.copyBannerButton.y = this.windowInner.y + this.windowInner.height - this.margin - this.buttonSize.y;
         this.bannerCode.x = this.windowMargin + this.margin;
         this.bannerCode.y = this.banner.y + this.banner.height + this.margin;
         this.bannerCode.width = this.windowSize.x - this.windowMargin * 2 - this.margin * 2;
         this.bannerCode.height = this.copyBannerButton.y - this.margin - this.bannerCode.y;
         if(this.bannerContainer.contains(this.bannerLoadEffect))
         {
            this.bannerLoadEffect.x = this.banner.x + int((this.bannerSize.x - this.bannerLoadEffect.width) * 0.5);
            this.bannerLoadEffect.y = this.banner.y + int((this.bannerSize.y - this.bannerLoadEffect.height) * 0.5);
         }
      }
      
      private function hideAll() : void
      {
         this.introContainer.visible = false;
         this.linkContainer.visible = false;
         this.bannerContainer.visible = false;
         this.mailContainer.visible = false;
         this.statContainer.visible = false;
      }
      
      private function onStatClick(e:MouseEvent) : void
      {
         this.getLinkButton.enable = true;
         this.getBannerButton.enable = true;
         this.inviteByMailButton.enable = true;
         this.statButton.enable = false;
         this.hideAll();
         this.state = this.STATE_STAT;
         this.statContainer.visible = true;
         this.descrInner.visible = false;
         this.windowInner.visible = false;
         this.descrLabel.visible = false;
      }
      
      private function onLinkClick(e:MouseEvent) : void
      {
         this.getLinkButton.enable = false;
         this.getBannerButton.enable = true;
         this.inviteByMailButton.enable = true;
         this.statButton.enable = true;
         this.hideAll();
         this.state = this.STATE_LINK;
         this.linkContainer.visible = true;
         this.descrInner.visible = true;
         this.windowInner.visible = true;
         this.descrLabel.visible = true;
         this.descrLabel.text = this.localeService.getText(TextConst.REFERAL_WINDOW_LINK_DESCRIPTION);
      }
      
      private function onBannerClick(e:MouseEvent) : void
      {
         this.getLinkButton.enable = true;
         this.getBannerButton.enable = false;
         this.inviteByMailButton.enable = true;
         this.statButton.enable = true;
         this.hideAll();
         this.state = this.STATE_BANNER;
         this.bannerContainer.visible = true;
         this.descrInner.visible = true;
         this.windowInner.visible = true;
         this.descrLabel.visible = true;
         this.descrLabel.text = this.localeService.getText(TextConst.REFERAL_WINDOW_BANNER_DESCRIPTION);
      }
      
      private function onMailClick(e:MouseEvent) : void
      {
         this.getLinkButton.enable = true;
         this.getBannerButton.enable = true;
         this.inviteByMailButton.enable = false;
         this.statButton.enable = true;
         this.hideAll();
         this.state = this.STATE_MAIL;
         this.mailContainer.visible = true;
         this.descrInner.visible = true;
         this.windowInner.visible = true;
         this.descrLabel.visible = true;
         this.descrLabel.text = this.localeService.getText(TextConst.REFERAL_WINDOW_MAIL_DESCRIPTION);
      }
      
      private function copyLink(e:MouseEvent) : void
      {
         System.setClipboard(this.linkURL.textField.text);
      }
      
      private function copyBanner(e:MouseEvent) : void
      {
         System.setClipboard(this.bannerCode.tf.text);
      }
      
      private function sendLetter(e:MouseEvent) : void
      {
         dispatchEvent(new ReferalWindowEvent(ReferalWindowEvent.SEND_MAIL,this.addressInput.value,this.mailText.text));
      }
      
      public function clearRecipientInputField() : void
      {
         if(this.addressInput != null)
         {
            this.addressInput.value = "";
         }
      }
   }
}
