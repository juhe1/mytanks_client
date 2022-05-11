package alternativa.tanks.model.shop.items.crystallitem
{
   import flash.display.BitmapData;
   
   public class CrystalPackageItemIcons
   {
      
[Embed(source="1169.png")]
      private static const crystalBlueClass:Class;
      
      public static const crystalBlue:BitmapData = new crystalBlueClass().bitmapData;
      
[Embed(source="931.png")]
      private static const crystalWhiteClass:Class;
      
      public static const crystalWhite:BitmapData = new crystalWhiteClass().bitmapData;
      
[Embed(source="755.png")]
      private static const crystalsPackage1Class:Class;
      
[Embed(source="860.png")]
      private static const crystalsPackage2Class:Class;
      
[Embed(source="1129.png")]
      private static const crystalsPackage3Class:Class;
      
[Embed(source="1006.png")]
      private static const crystalsPackage4Class:Class;
      
[Embed(source="901.png")]
      private static const crystalsPackage5Class:Class;
      
      public static const crystalsPackages:Array = [null,new crystalsPackage1Class().bitmapData,new crystalsPackage2Class().bitmapData,new crystalsPackage3Class().bitmapData,new crystalsPackage4Class().bitmapData,new crystalsPackage5Class().bitmapData];
       
      
      public function CrystalPackageItemIcons()
      {
         super();
      }
   }
}
