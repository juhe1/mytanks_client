package alternativa.tanks.help.achievements
{
   import alternativa.init.Main;
   import alternativa.osgi.service.locale.ILocaleService;
   import alternativa.tanks.help.BubbleHelper;
   import alternativa.tanks.help.HelperAlign;
   import alternativa.tanks.locale.constants.TextConst;
   
   public class SetEmailHelper extends BubbleHelper
   {
       
      
      public function SetEmailHelper()
      {
         super();
         var localeService:ILocaleService = ILocaleService(Main.osgi.getService(ILocaleService));
         text = localeService.getText(TextConst.HELP_SET_EMAIL_HELPER_TEXT);
         arrowLehgth = int(localeService.getText(TextConst.HELP_SET_EMAIL_HELPER_ARROW_LENGTH));
         arrowAlign = HelperAlign.TOP_RIGHT;
         _showLimit = 100;
      }
   }
}
