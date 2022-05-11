package alternativa.tanks.model.news
{
   public class NewsItemServer
   {
       
      
      public var date:String;
      
      public var text:String;
      
      public var iconId:String;
      
      public function NewsItemServer(date:String, text:String, iconId:String = "update")
      {
         super();
         this.date = date;
         this.text = text;
         this.iconId = iconId;
      }
   }
}
