package alternativa.tanks.model.profile.server
{
   public class UserGiftServerItem
   {
       
      
      public var userid:String;
      
      public var giftid:String;
      
      public var image:String;
      
      public var name:String;
      
      public var status:String;
      
      public var message:String;
      
      public var date:String;
      
      public function UserGiftServerItem(userid:String, giftid:String, image:String, name:String, status:String, message:String, date:String)
      {
         super();
         this.userid = userid;
         this.giftid = giftid;
         this.image = image;
         this.name = name;
         this.status = status;
         this.message = message;
         this.date = date;
      }
   }
}
