package com.alternativaplatform.projects.tanks.client.models.battlefield
{
   import com.alternativaplatform.projects.tanks.client.commons.types.Vector3d;
   
   public class BattleBonus
   {
       
      
      public var id:String;
      
      public var objectId:String;
      
      public var position:Vector3d;
      
      public var timeFromAppearing:int;
      
      public function BattleBonus()
      {
         super();
      }
   }
}
