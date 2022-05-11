package alternativa.tanks.engine3d
{
   import alternativa.engine3d.materials.TextureMaterial;
   import alternativa.init.Main;
   import alternativa.tanks.models.battlefield.BattlefieldModel;
   import alternativa.tanks.models.battlefield.IBattleField;
   import flash.display.BitmapData;
   
   public class TanksTextureMaterial extends TextureMaterial
   {
       
      
      public function TanksTextureMaterial(param1:BitmapData = null, param2:Boolean = false, param3:Boolean = true, param4:int = 0, param5:Number = 1)
      {
         var bfModel:BattlefieldModel = BattlefieldModel(Main.osgi.getService(IBattleField));
         if(bfModel.toDestroy.indexOf(this) == -1)
         {
            bfModel.toDestroy.push(this);
         }
         super(param1,param2,param3,param4,param5);
      }
      
      public function destroy(b:Boolean) : *
      {
         dispose();
      }
   }
}
