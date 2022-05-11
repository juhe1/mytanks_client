package alternativa.tanks.models.dom.sfx
{
   import alternativa.console.ConsoleVarFloat;
   import alternativa.engine3d.materials.TextureMaterial;
   import alternativa.tanks.engine3d.debug.TextureMaterialRegistry;
   import flash.display.BitmapData;
   import projects.tanks.client.battleservice.model.team.BattleTeamType;
   
   public class AllBeamProperties
   {
      
      private static const conBeamWidth:ConsoleVarFloat = new ConsoleVarFloat("beam_width",100,0,1000);
      
      private static const conUnitLength:ConsoleVarFloat = new ConsoleVarFloat("beam_ulength",500,0,10000);
      
      private static const conAnimationSpeed:ConsoleVarFloat = new ConsoleVarFloat("beam_anim_speed",-0.6,-1000,1000);
      
      private static const conURange:ConsoleVarFloat = new ConsoleVarFloat("beam_urange",0.6,0.1,1);
      
      private static const conAlpha:ConsoleVarFloat = new ConsoleVarFloat("beam_alpha",1,0,1);
      
[Embed(source="885.png")]
      private static const blueRay:Class;
      
[Embed(source="1176.png")]
      private static const blueRayTip:Class;
      
[Embed(source="1019.png")]
      private static const redRay:Class;
      
[Embed(source="1138.png")]
      private static const redRayTip:Class;
       
      
      private var blueBeamProperties:BeamProperties;
      
      private var redBeamProperties:BeamProperties;
      
      public function AllBeamProperties(param1:TextureMaterialRegistry)
      {
         super();
         this.blueBeamProperties = createBeamProperties(param1,new blueRay().bitmapData,new blueRayTip().bitmapData,50,100,1,1,1);
         this.redBeamProperties = createBeamProperties(param1,new redRay().bitmapData,new redRayTip().bitmapData,50,100,1,1,1);
      }
      
      private static function createBeamProperties(param1:TextureMaterialRegistry, param2:BitmapData, param3:BitmapData, param4:Number, param5:Number, param6:Number, param7:Number, param8:Number) : BeamProperties
      {
         var _loc9_:TextureMaterial = new TextureMaterial(param2);
         _loc9_.repeat = true;
         var _loc10_:TextureMaterial = new TextureMaterial(param3);
         return new BeamProperties(_loc9_,_loc10_,param4,param5,param6,param7,param8);
      }
      
      private static function createProperties(param1:BeamProperties) : BeamProperties
      {
         return new BeamProperties(param1.beamMaterial,param1.beamTipMaterial,conBeamWidth.value,conUnitLength.value,conAnimationSpeed.value,conURange.value,conAlpha.value);
      }
      
      private function getBlueBeamProperties() : BeamProperties
      {
         return createProperties(this.blueBeamProperties);
      }
      
      private function getRedBeamProperties() : BeamProperties
      {
         return createProperties(this.redBeamProperties);
      }
      
      public function getBeamProperties(param1:BattleTeamType) : BeamProperties
      {
         return param1 == BattleTeamType.BLUE ? this.getBlueBeamProperties() : this.getRedBeamProperties();
      }
   }
}
