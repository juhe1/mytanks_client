package controls.chat
{
   import fl.containers.ScrollPane;
   import fl.controls.ScrollPolicy;
   import flash.display.Sprite;
   import flash.events.Event;
   import forms.events.LoginFormEvent;
   
   public class ChatOutput extends ScrollPane
   {
       
      
      private const numMessages:int = 80;
      
      private var _cont:Sprite;
      
      private var __width:Number;
      
      public var firstFill:Boolean = true;
      
      public var deltaWidth:int = 9;
      
      public var selfName:String;
      
      private var oldLine:ChatOutputLine;
      
      public function ChatOutput()
      {
         this._cont = new Sprite();
         super();
         this.source = this._cont;
         this.horizontalScrollPolicy = ScrollPolicy.OFF;
         this.focusEnabled = false;
         addEventListener(LoginFormEvent.SHOW_RULES,this.showRules);
      }
      
      private function showRules(e:Event) : void
      {
      }
      
      public function addLine(rang:int, chatPermissions:int, name:String, text:String, rangTo:int = 0, chatPermissionsTo:int = 0, nameTo:String = "", system:Boolean = false, html:Boolean = false, _systemColor:uint = 8454016) : void
      {
         var line:ChatOutputLine = null;
         var maxScroll:Boolean = this.verticalScrollPosition + 5 > this.maxVerticalScrollPosition || this.firstFill;
         if(this._cont.numChildren > this.numMessages)
         {
            this.shiftMessages();
            this.oldLine = null;
            line = new ChatOutputLine(this.__width,rang,chatPermissions,name,text,rangTo,chatPermissionsTo,nameTo,system,html,_systemColor);
         }
         else
         {
            line = new ChatOutputLine(this.__width,rang,chatPermissions,name,text,rangTo,chatPermissionsTo,nameTo,system,html,_systemColor);
         }
         var curY:int = int(this._cont.height + 0.5);
         line.self = line._userNameTo == this.selfName;
         line.y = curY;
         this._cont.addChild(line);
         this.update();
         if(maxScroll)
         {
            this.verticalScrollPosition = this.maxVerticalScrollPosition;
         }
      }
      
      public function scrollDown() : void
      {
         this.verticalScrollPosition = this.maxVerticalScrollPosition;
      }
      
      public function selectUser(name:String) : void
      {
         var element:ChatOutputLine = null;
         for(var i:int = 0; i < this._cont.numChildren; i++)
         {
            element = this._cont.getChildAt(i) as ChatOutputLine;
            element.light = element.username == name && name != "";
            element.self = element._userNameTo == this.selfName && name != "";
         }
      }
      
      private function shiftMessages() : void
      {
         this.oldLine = this._cont.getChildAt(0) as ChatOutputLine;
         var shift:Number = this.oldLine.height + this.oldLine.y;
         this._cont.removeChild(this.oldLine);
         for(var i:int = 0; i < this._cont.numChildren; i++)
         {
            this._cont.getChildAt(i).y = this._cont.getChildAt(i).y - shift;
         }
      }
      
      override public function setSize(width:Number, height:Number) : void
      {
         super.setSize(width,height);
         this.__width = width - this.deltaWidth;
         this.resizeLines();
      }
      
      private function resizeLines() : void
      {
         var element:ChatOutputLine = null;
         var i:int = 0;
         var cash:Array = new Array();
         var curY:int = 0;
         var nofirstTime:Boolean = this._cont.numChildren > 0;
         while(this._cont.numChildren > 0)
         {
            element = this._cont.getChildAt(i) as ChatOutputLine;
            element.width = this.__width;
            cash.push(element);
            this._cont.removeChildAt(0);
         }
         for(i = 0; i < cash.length; i++)
         {
            element = cash[i];
            curY = int(this._cont.height + 0.5);
            element.y = curY;
            this._cont.addChild(element);
         }
         if(nofirstTime)
         {
            this.update();
         }
      }
      
      public function cleanOutUsersMessages(uid:String) : void
      {
         var line:ChatOutputLine = null;
         var linesToDelete:Array = new Array();
         for(var i:int = 0; i < this._cont.numChildren; i++)
         {
            line = this._cont.getChildAt(i) as ChatOutputLine;
            if(line._userName == uid || uid == "")
            {
               linesToDelete.push(line);
            }
         }
         for(i = 0; i < linesToDelete.length; i++)
         {
            this._cont.removeChild(linesToDelete[i]);
         }
         this.resizeLines();
         this.update();
      }
      
      public function cleanOutMessages(msg:String) : void
      {
         var line:ChatOutputLine = null;
         var linesToDelete:Array = new Array();
         for(var i:int = 0; i < this._cont.numChildren; i++)
         {
            line = this._cont.getChildAt(i) as ChatOutputLine;
            if(line.output.text == msg)
            {
               linesToDelete.push(line);
            }
         }
         for(i = 0; i < linesToDelete.length; i++)
         {
            this._cont.removeChild(linesToDelete[i]);
         }
         this.resizeLines();
         this.update();
      }
   }
}
