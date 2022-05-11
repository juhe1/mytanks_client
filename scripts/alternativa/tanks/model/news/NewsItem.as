package alternativa.tanks.model.news
{
   import controls.Label;
   import flash.display.Bitmap;
   import flash.display.Sprite;
   import flash.text.TextFormatAlign;
   
   public class NewsItem extends Sprite
   {
       
      
      private var date:Label;
      
      private var text:Label;
      
      private var image:Bitmap;
      
      public function NewsItem()
      {
         this.date = new Label();
         this.text = new Label();
         super();
         this.date.color = 65280;
         this.date.x = 10;
         this.text.color = 8454016;
         this.text.x = 100;
         this.text.y = 20;
         this.text.multiline = true;
         this.text.wordWrap = true;
         this.text.align = TextFormatAlign.LEFT;
         this.text.width = 365;
         addChild(this.date);
         addChild(this.text);
      }
      
      public function set dataText(value:String) : void
      {
         this.date.text = value;
      }
      
      public function set newText(value:String) : void
      {
         this.text.htmlText = value;
      }
      
      public function set iconId(value:String) : void
      {
         this.image = new Bitmap(NewsIcons.getIcon(value));
         this.image.x = 15;
         this.image.y = 20;
         addChild(this.image);
      }
      
      public function get heigth() : int
      {
         return this.height;
      }
   }
}
