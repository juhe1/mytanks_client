package alternativa.tanks.models.effects.common.bonuscommon
{
   import alternativa.math.Matrix3;
   import alternativa.math.Matrix4;
   import alternativa.math.Vector3;
   import alternativa.physics.Body;
   import alternativa.physics.CollisionPrimitiveListItem;
   import alternativa.physics.collision.CollisionPrimitive;
   import alternativa.physics.collision.primitives.CollisionBox;
   import alternativa.tanks.battle.Trigger;
   import alternativa.tanks.models.battlefield.BattlefieldModel;
   import alternativa.tanks.physics.CollisionGroup;
   
   public class BonusTrigger implements Trigger
   {
       
      
      private var bonus:ParaBonus;
      
      private var collisionBox:CollisionBox;
      
      private var battleRunner:BattlefieldModel;
      
      public function BonusTrigger(bonus:ParaBonus)
      {
         super();
         this.bonus = bonus;
         var bonusHalfSize:Number = BonusConst.BONUS_HALF_SIZE;
         this.collisionBox = new CollisionBox(new Vector3(bonusHalfSize,bonusHalfSize,bonusHalfSize),CollisionGroup.BONUS_WITH_TANK);
      }
      
      public function activate(battleRunner:BattlefieldModel) : void
      {
         if(this.battleRunner == null)
         {
            this.battleRunner = battleRunner;
            battleRunner.addTrigger(this);
         }
      }
      
      public function deactivate() : void
      {
         if(this.battleRunner != null)
         {
            this.battleRunner.removeTrigger(this);
            this.battleRunner = null;
         }
      }
      
      public function update(x:Number, y:Number, z:Number, rx:Number, ry:Number, rz:Number) : void
      {
         var transform:Matrix4 = this.collisionBox.transform;
         transform.setMatrix(x,y,z,rx,ry,rz);
         this.collisionBox.calculateAABB();
      }
      
      public function setTransform(position:Vector3, m:Matrix3) : void
      {
         var transform:Matrix4 = this.collisionBox.transform;
         transform.setFromMatrix3(m,position);
         this.collisionBox.calculateAABB();
      }
      
      public function checkTrigger(body:Body) : void
      {
         var primitive:CollisionPrimitive = null;
         var item:CollisionPrimitiveListItem = body.collisionPrimitives.head;
         while(item != null)
         {
            primitive = item.primitive;
            if(this.battleRunner.bfData.collisionDetector.testCollision(primitive,this.collisionBox))
            {
               this.bonus.onTriggerActivated();
               return;
            }
            item = item.next;
         }
      }
   }
}
