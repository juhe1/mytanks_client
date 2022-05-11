package alternativa.tanks.help.achievements
{
   import alternativa.init.Main;
   import alternativa.osgi.service.locale.ILocaleService;
   import alternativa.tanks.help.BubbleHelper;
   import alternativa.tanks.help.HelperAlign;
   import alternativa.tanks.locale.constants.TextConst;
   
   public class UpRankHelper extends BubbleHelper
   {
       
      
      public function UpRankHelper()
      {
         super();
         var localeService:ILocaleService = ILocaleService(Main.osgi.getService(ILocaleService));
         text = localeService.getText(TextConst.HELP_UP_RANK_HELPER_TEXT);
         arrowLehgth = int(localeService.getText(TextConst.HELP_UP_RANK_HELPER_ARROW_LENGTH));
         arrowAlign = HelperAlign.TOP_LEFT;
         _showLimit = 100;
      }
   }
}
