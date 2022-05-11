package scpacker.gui
{
   import alternativa.init.Main;
   import alternativa.osgi.service.locale.ILocaleService;
   import alternativa.tanks.locale.constants.TextConst;
   import controls.BlueButton;
   import controls.RedButton;
   import controls.TankInput;
   import controls.TankWindow;
   import controls.TankWindowHeader;
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.FocusEvent;
   import flash.events.MouseEvent;
   import flash.filters.BitmapFilter;
   import flash.filters.BitmapFilterQuality;
   import flash.filters.BlurFilter;
   
   public class RecoveryWindow extends Sprite
   {
       
      
      private var window:TankWindow;
      
      private var passInput:TankInput;
      
      private var pass2Input:TankInput;
      
      private var emailInput:TankInput;
      
      private var saveBtn:BlueButton;
      
      private var cancelBtn:RedButton;
      
      private var bg:Sprite;
      
      private var bmp:Bitmap;
      
      private var callback:Function;
      
      private var email:String;
      
      private var localeService:ILocaleService;
      
      public function RecoveryWindow(callback:Function, email:String)
      {
         this.window = new TankWindow();
         this.passInput = new TankInput();
         this.pass2Input = new TankInput();
         this.emailInput = new TankInput();
         this.saveBtn = new BlueButton();
         this.cancelBtn = new RedButton();
         this.bg = new Sprite();
         this.bmp = new Bitmap();
         super();
         this.callback = callback;
         this.email = email;
         this.localeService = Main.osgi.getService(ILocaleService) as ILocaleService;
         this.window.headerLang = this.localeService.getText(TextConst.GUI_LANG);
         this.window.header = TankWindowHeader.CHANGEPASSWORD;
         addEventListener(Event.ADDED_TO_STAGE,this.onAddedToStage);
      }
      
      private function draw() : void
      {
         addChild(this.bg);
         this.drawBg();
         addChild(this.window);
         this.window.width = 435;
         this.window.height = 169 - 11;
         this.window.addChild(this.passInput);
         this.passInput.x = 35 + 77;
         this.passInput.y = 20;
         this.passInput.width = 120;
         this.passInput.label = this.localeService.getText(TextConst.ACCOUNT_RECOVERY_FORM_NEW_PASSWORD);
         this.window.addChild(this.pass2Input);
         this.pass2Input.x = this.passInput.x + this.passInput.width - 30;
         this.pass2Input.y = 20;
         this.pass2Input.width = 120;
         this.pass2Input.label = this.localeService.getText(TextConst.REGISTER_FORM_REPEAT_PASSWORD_INPUT_LABEL_TEXT);
         this.window.addChild(this.emailInput);
         this.emailInput.x = 63;
         this.emailInput.y = this.pass2Input.y + this.emailInput.height + 11;
         this.emailInput.width = 352;
         this.emailInput.label = this.localeService.getText(TextConst.REGISTER_FORM_EMAIL_LABEL_TEXT);
         this.emailInput.value = this.email;
         this.window.addChild(this.saveBtn);
         this.saveBtn.x = this.window.width - this.saveBtn.width - 20;
         this.saveBtn.y = this.window.height - this.saveBtn.height - 24;
         this.saveBtn.label = this.localeService.getText(TextConst.ACCOUNT_RECOVERY_FORM_SAVE);
         this.window.addChild(this.cancelBtn);
         this.cancelBtn.x = this.window.width - this.cancelBtn.width * 2 - 34;
         this.cancelBtn.y = this.window.height - this.cancelBtn.height - 24;
         this.cancelBtn.label = this.localeService.getText(TextConst.ACCOUNT_RECOVERY_FORM_CANCEL);
         this.cancelBtn.addEventListener(MouseEvent.CLICK,this.close);
         this.saveBtn.addEventListener(MouseEvent.CLICK,this.onSave);
         this.pass2Input.addEventListener(FocusEvent.FOCUS_OUT,this.checkPass);
      }
      
      private function onSave(e:Event) : void
      {
         this.callback.call(null,this.pass2Input.value,this.emailInput.value);
         this.close(null);
      }
      
      private function checkPass(e:FocusEvent) : void
      {
         if(this.pass2Input.value == null || this.pass2Input.value == "")
         {
            return;
         }
         if(this.pass2Input.value != this.passInput.value)
         {
            this.pass2Input.validValue = false;
         }
         else
         {
            this.pass2Input.validValue = true;
         }
      }
      
      private function close(e:Event) : void
      {
         this.cancelBtn.removeEventListener(MouseEvent.CLICK,this.close);
         this.pass2Input.removeEventListener(FocusEvent.FOCUS_OUT,this.checkPass);
         stage.removeEventListener(Event.RESIZE,this.resize);
         removeChildren(0,numChildren - 1);
      }
      
      private function drawBg() : void
      {
         var data:BitmapData = null;
         var filter:BitmapFilter = new BlurFilter(5,5,BitmapFilterQuality.HIGH);
         var myFilters:Array = new Array();
         myFilters.push(filter);
         data = new BitmapData(stage.stageWidth,stage.stageHeight,true,0);
         this.bmp.visible = false;
         data.draw(stage);
         this.bmp.visible = true;
         this.bmp.filters = myFilters;
         this.bmp.bitmapData = data;
         this.bg.addChild(this.bmp);
      }
      
      private function onAddedToStage(event:Event) : void
      {
         this.draw();
         stage.addEventListener(Event.RESIZE,this.resize);
         this.resize(null);
         removeEventListener(Event.ADDED_TO_STAGE,this.onAddedToStage);
      }
      
      private function resize(event:Event) : void
      {
         this.window.x = stage.stageWidth / 2 - this.window.width / 2;
         this.window.y = stage.stageHeight / 2 - this.window.height / 2;
         this.drawBg();
      }
   }
}
