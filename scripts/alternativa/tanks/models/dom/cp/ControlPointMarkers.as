package alternativa.tanks.models.dom.cp
{
   import alternativa.math.Vector3;
   import alternativa.tanks.models.battlefield.BattlefieldModel;
   import alternativa.tanks.models.dom.Point;
   
   public class ControlPointMarkers
   {
       
      
      public var sprite:ControlPointSprite;
      
      private var point:Point;
      
      public function ControlPointMarkers(battlefieldModel:BattlefieldModel, pos:Vector3, keypoint:Point)
      {
         super();
         this.point = keypoint;
         this.sprite = new ControlPointSprite(keypoint.id);
         ControlPointSprite.init();
         this.sprite.redraw();
         this.sprite.x = pos.x;
         this.sprite.y = pos.y;
         this.sprite.z = pos.z;
         battlefieldModel.getBattlefieldData().viewport.getMapContainer().addChild(this.sprite);
      }
      
      public function tick() : void
      {
         this.sprite.progress = this.point.clientProgress;
         this.sprite.redraw();
      }
      
      public function destroy() : void
      {
         this.sprite.destroy();
         this.sprite = null;
      }
   }
}
