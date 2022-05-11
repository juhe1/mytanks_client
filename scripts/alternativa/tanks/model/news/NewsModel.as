package alternativa.tanks.model.news
{
   import alternativa.init.Main;
   import alternativa.tanks.model.panel.IPanel;
   import flash.display.DisplayObjectContainer;
   import flash.events.Event;
   import flash.events.MouseEvent;
   
   public class NewsModel implements INewsModel
   {
       
      
      private var panelModel:IPanel;
      
      private var dialogsLayer:DisplayObjectContainer;
      
      private var window:NewsWindow;
      
      public function NewsModel()
      {
         super();
         this.dialogsLayer = Main.dialogsLayer;
      }
      
      public function showNews(items:Vector.<NewsItemServer>) : void
      {
         var item:NewsItemServer = null;
         var _item:NewsItem = null;
         this.panelModel = Main.osgi.getService(IPanel) as IPanel;
         this.panelModel.blur();
         this.window = new NewsWindow();
         var news:Array = new Array();
         for each(item in items)
         {
            _item = new NewsItem();
            _item.dataText = item.date;
            _item.newText = item.text;
            _item.iconId = item.iconId;
            news.push(_item);
         }
         this.window.setItems(news);
         this.dialogsLayer.addChild(this.window);
         Main.stage.addEventListener(Event.RESIZE,this.alignWindow);
         this.window.closeBtn.addEventListener(MouseEvent.CLICK,this.closeWindow);
         this.alignWindow(null);
      }
      
      private function alignWindow(e:Event) : void
      {
         this.window.x = Math.round((Main.stage.stageWidth - this.window.width) * 0.5);
         this.window.y = Math.round((Main.stage.stageHeight - this.window.getHeigth()) * 0.5);
      }
      
      private function closeWindow(e:MouseEvent = null) : void
      {
         this.panelModel.unblur();
         this.dialogsLayer.removeChild(this.window);
         Main.stage.removeEventListener(Event.RESIZE,this.alignWindow);
      }
   }
}
