package
{
   import alternativa.init.UserModelActivator;
   import specter.utils.Logger;
   
   public class Authorization
   {
       
      
      public var userModel:UserModelActivator;
      
      public function Authorization()
      {
         super();
         this.userModel = new UserModelActivator();
      }
      
      public function init() : void
      {
         this.userModel.start(Game.getInstance.osgi);
         this.userModel.userModel.initObject(Game.getInstance.classObject,false,false);
         this.userModel.userModel.objectLoaded(Game.getInstance.classObject);
         Logger.log("Authorization::init()");
      }
   }
}
