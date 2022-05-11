package controls.chat
{
   import assets.cellrenderer.battlelist.cell_normal_SELECTED_LEFT;
   import assets.cellrenderer.battlelist.cell_normal_SELECTED_RIGHT;
   import assets.cellrenderer.battlelist.cell_normal_UP_LEFT;
   import assets.cellrenderer.battlelist.cell_normal_UP_RIGHT;
   import assets.icons.ChatArrow;
   import controls.Label;
   import controls.TankWindowInner;
   import controls.rangicons.RangIconSmall;
   import controls.statassets.StatLineBase;
   import controls.statassets.StatLineHeader;
   import controls.statassets.StatLineNormal;
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.Graphics;
   import flash.display.Shape;
   import flash.display.Sprite;
   import flash.geom.Matrix;
   import flash.text.TextFormat;
   
   public class ChatOutputLine extends Sprite
   {
       
      
      public var output:Label;
      
      public var _nameFrom:Label;
      
      public var _nameTo:Label;
      
      public var _userName:String;
      
      public var _userNameTo:String;
      
      public var _rang:int;
      
      public var rangIcon:RangIconSmall;
      
      public var rangIconTo:RangIconSmall;
      
      public var chatLevel:Bitmap;
      
      public var chatLevelTo:Bitmap;
      
      private var _light:Boolean = false;
      
      private var _self:Boolean = false;
      
      private var _namesWidth:int = 0;
      
      private var format:TextFormat;
      
      private var arrow:ChatArrow;
      
      private var system:Boolean = false;
      
      private var html:Boolean = false;
      
      private var systemColor:uint = 8454016;
      
      private const lt:Shape = new Shape();
      
      private const rt:Shape = new Shape();
      
      private const lb:Shape = new Shape();
      
      private const rb:Shape = new Shape();
      
      private const c:Shape = new Shape();
      
      private var bmpLeft:BitmapData;
      
      private var bmpRight:BitmapData;
      
      private var bmpLeftS:BitmapData;
      
      private var bmpRightS:BitmapData;
      
      private var bg:Bitmap;
      
      private var defFormat:TextFormat;
      
      private var _width:int;
      
      public function ChatOutputLine(w:int, rang:int, chatPermissions:int, name:String, text:String, rangTo:int = 0, chatPermissionsTo:int = 0, nameTo:String = "", _system:Boolean = false, _html:Boolean = false, _systemColor:uint = 8454016)
      {
         this.output = new Label();
         this._nameFrom = new Label();
         this._nameTo = new Label();
         this.bmpLeft = new cell_normal_UP_LEFT(1,1);
         this.bmpRight = new cell_normal_UP_RIGHT(1,1);
         this.bmpLeftS = new cell_normal_SELECTED_LEFT(1,1);
         this.bmpRightS = new cell_normal_SELECTED_RIGHT(1,1);
         this.bg = new Bitmap();
         super();
         mouseEnabled = false;
         addChild(this.bg);
         this.format = new TextFormat("MyriadPro",13);
         this.rangIcon = new RangIconSmall(rang);
         this.rangIcon.mouseEnabled = false;
         this.rangIcon.y = 3;
         this._userName = name;
         this._rang = rang;
         this._width = w;
         this.systemColor = _systemColor;
         this.system = _system;
         this.html = _html;
         this.defFormat = this.output.getTextFormat();
         this.output.color = !!this.system ? uint(this.systemColor) : uint(16777215);
         this.output.multiline = true;
         this.output.wordWrap = true;
         this.output.selectable = true;
         this._nameFrom.color = !!this.system ? uint(this.systemColor) : uint(1244928);
         this._nameFrom.text = !!this.system ? "" : "    " + name;
         addChild(this.rangIcon);
         this.rangIcon.visible = !this.system;
         addChild(this._nameFrom);
         addChild(this.output);
         this._nameFrom.text += rangTo > 0 ? "      " : (!!this.system ? "" : ":  ");
         this._namesWidth = this._nameFrom.textWidth;
         addChild(this._nameTo);
         this._nameTo.visible = rangTo > 0;
         if(chatPermissions > 0 && this.chatLevel == null)
         {
            this.chatLevel = new Bitmap(ChatPermissionsLevel.getBD(chatPermissions));
            this.chatLevel.y = 3;
            this.chatLevel.x = 3;
            addChild(this.chatLevel);
            this.rangIcon.x = this.chatLevel.x + this.chatLevel.width;
            this._nameFrom.x = this.chatLevel.x + this.chatLevel.width;
            this._namesWidth += this.chatLevel.x + this.chatLevel.width;
         }
         if(rangTo > 0)
         {
            this.rangIconTo = new RangIconSmall(rangTo);
            this.rangIconTo.mouseEnabled = false;
            this.rangIconTo.y = 3;
            this.rangIconTo.x = this._namesWidth;
            if(chatPermissionsTo > 0 && this.chatLevelTo == null)
            {
               this.chatLevelTo = new Bitmap(ChatPermissionsLevel.getBD(chatPermissionsTo));
               this.chatLevelTo.y = 3;
               this.chatLevelTo.x = 3 + this._namesWidth;
               addChild(this.chatLevelTo);
               this.rangIconTo.x = this.chatLevelTo.x + this.chatLevelTo.width;
               this._namesWidth += this.chatLevelTo.width + 3;
            }
            this.arrow = new ChatArrow();
            this.arrow.y = 8;
            this.arrow.x = this._namesWidth - (this.chatLevelTo != null ? 26 : 10);
            this._nameTo.color = 1244928;
            addChild(this.arrow);
            addChild(this.rangIconTo);
            this._nameTo.text = "    " + nameTo + ":  ";
            this._userNameTo = nameTo;
            this._nameTo.x = this.chatLevelTo != null ? Number(this.chatLevelTo.x + this.chatLevelTo.width) : Number(this.rangIconTo.x);
            this._namesWidth += this._nameTo.textWidth;
         }
         if(this._namesWidth > this._width / 2)
         {
            this.output.y = 15;
            this.output.x = 0;
            this.output.width = this._width - 5;
         }
         else
         {
            this.output.x = this._namesWidth + 3;
            this.output.y = 0;
            this.output.width = this._width - this._namesWidth - 8;
         }
         if(!this.html)
         {
            this.output.text = text;
         }
         else
         {
            this.output.htmlText = text;
         }
      }
      
      public function setData(w:int, rang:int, name:String, text:String, rangTo:int = 0, nameTo:String = "", _system:Boolean = false, _html:Boolean = false, _systemColor:uint = 8454016) : void
      {
         this.rangIcon.rang = rang;
         this._userName = name;
         this._rang = rang;
         this._width = w;
         this.system = _system;
         this.html = _html;
         this.systemColor = _systemColor;
         this.light = false;
         this.self = false;
         this.bg.bitmapData = new BitmapData(1,1,true,0);
         this.output.defaultTextFormat = this.defFormat;
         this.output.color = !!this.system ? uint(this.systemColor) : uint(16777215);
         this._nameFrom.color = !!this.system ? uint(this.systemColor) : uint(1244928);
         this._nameFrom.text = !!this.system ? "" : "    " + name;
         this.rangIcon.visible = !this.system;
         this._nameFrom.text += rangTo > 0 ? "      " : (!!this.system ? "" : ":  ");
         this._namesWidth = this._nameFrom.textWidth;
         if(this.rangIconTo == null)
         {
            this.rangIconTo = new RangIconSmall();
            addChild(this.rangIconTo);
         }
         this.rangIconTo.visible = rangTo > 0;
         if(this.arrow == null)
         {
            this.arrow = new ChatArrow();
            addChild(this.arrow);
         }
         this.arrow.visible = rangTo > 0;
         this._nameTo.visible = rangTo > 0;
         this._userNameTo = nameTo;
         if(rangTo > 0)
         {
            this.rangIconTo.rang = rangTo;
            this.rangIconTo.y = 3;
            this.rangIconTo.x = this._namesWidth;
            this.arrow.y = 8;
            this.arrow.x = this._namesWidth - 10;
            this._nameTo.color = 1244928;
            this._nameTo.text = "    " + nameTo + ":  ";
            this._nameTo.x = this._nameFrom.textWidth;
            this._namesWidth += this._nameTo.textWidth;
         }
         if(this._namesWidth > this._width / 2)
         {
            this.output.y = 15;
            this.output.x = 0;
            this.output.width = this._width - 5;
         }
         else
         {
            this.output.x = this._namesWidth + 3;
            this.output.y = 0;
            this.output.width = this._width - this._namesWidth - 8;
         }
         if(!this.html)
         {
            this.output.text = text;
         }
         else
         {
            this.output.htmlText = text;
         }
      }
      
      public function get username() : String
      {
         return this._userName;
      }
      
      override public function set width(value:Number) : void
      {
         var baseColor:uint = 0;
         var dr:StatLineBase = null;
         var bmp:BitmapData = null;
         var matr:Matrix = new Matrix();
         var cr:int = 0;
         this._width = int(value);
         if(this._namesWidth > this._width / 2 && this.output.text.length * 8 > this._width - this._namesWidth)
         {
            this.output.y = 19;
            this.output.x = 0;
            this.output.width = this._width - 5;
            cr = 21;
         }
         else
         {
            this.output.x = this._namesWidth;
            this.output.y = 0;
            this.output.width = this._width - this._namesWidth - 5;
            this.output.height = 20;
         }
         baseColor = !!this._self ? uint(5898034) : uint(543488);
         this.bg.bitmapData = new BitmapData(1,Math.max(int(this.output.textHeight + 7.5 + cr),19),true,0);
         dr = !!this._self ? new StatLineHeader() : new StatLineNormal();
         if(this._light || this._self)
         {
            dr.width = this._width;
            dr.height = Math.max(int(this.output.textHeight + 5.5 + cr),19);
            dr.y = 2;
            dr.graphics.beginFill(0,0);
            dr.graphics.drawRect(0,0,2,2);
            dr.graphics.endFill();
            bmp = new BitmapData(dr.width,dr.height + 2,true,0);
            bmp.draw(dr);
            this.bg.bitmapData = bmp;
         }
      }
      
      public function set light(value:Boolean) : void
      {
         this._light = value;
         if(this._light)
         {
            this._nameFrom.color = this._nameTo.color = !!this.system ? uint(this.systemColor) : uint(5898034);
         }
         else
         {
            this._nameFrom.color = this._nameTo.color = !!this.system ? uint(this.systemColor) : uint(1244928);
         }
         this.width = this._width;
      }
      
      public function set self(value:Boolean) : void
      {
         this._self = value;
         if(this._self)
         {
            this._nameFrom.color = this._nameTo.color = this.output.color = !!this.system ? uint(this.systemColor) : uint(TankWindowInner.GREEN);
         }
         else
         {
            this._nameFrom.color = this._nameTo.color = !!this.system ? uint(this.systemColor) : uint(1244928);
            this.output.color = !!this.system ? uint(this.systemColor) : uint(16777215);
         }
         this.width = this._width;
      }
   }
}
