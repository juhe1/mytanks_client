package com.alternativaplatform.projects.tanks.client.warfare.models.tankparts.weapon.healing.struct
{
   import com.alternativaplatform.projects.tanks.client.warfare.models.tankparts.weapon.healing.IsisActionType;
   
   public class IsisAction
   {
       
      
      public var shooterId:String;
      
      public var targetId:String;
      
      public var type:IsisActionType;
      
      public function IsisAction()
      {
         super();
      }
   }
}
