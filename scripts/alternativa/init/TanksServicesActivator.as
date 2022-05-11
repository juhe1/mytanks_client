package alternativa.init
{
   import alternativa.osgi.bundle.IBundleActivator;
   import alternativa.tanks.bg.BackgroundService;
   import alternativa.tanks.bg.IBackgroundService;
   import alternativa.tanks.help.HelpService;
   import alternativa.tanks.help.IHelpService;
   import alternativa.tanks.loader.ILoaderWindowService;
   import alternativa.tanks.loader.LoaderWindow;
   import alternativa.tanks.model.achievement.AchievementModel;
   import alternativa.tanks.model.achievement.IAchievementModel;
   
   public class TanksServicesActivator implements IBundleActivator
   {
      
      public static var osgi:OSGi;
       
      
      private var loaderWindow:LoaderWindow;
      
      public function TanksServicesActivator()
      {
         super();
      }
      
      public function start(osgi:OSGi) : void
      {
         TanksServicesActivator.osgi = osgi;
         var bgService:IBackgroundService = new BackgroundService();
         osgi.registerService(IBackgroundService,bgService);
         osgi.registerService(IHelpService,new HelpService());
         osgi.registerService(IAchievementModel,new AchievementModel());
         bgService.showBg();
         this.loaderWindow = new LoaderWindow();
         osgi.registerService(ILoaderWindowService,this.loaderWindow);
      }
      
      public function stop(osgi:OSGi) : void
      {
         osgi.unregisterService(IBackgroundService);
         osgi.unregisterService(IHelpService);
         osgi.unregisterService(ILoaderWindowService);
         osgi.unregisterService(IAchievementModel);
         this.loaderWindow = null;
         TanksServicesActivator.osgi = null;
      }
   }
}
