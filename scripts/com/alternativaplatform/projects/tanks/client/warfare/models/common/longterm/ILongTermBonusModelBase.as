package com.alternativaplatform.projects.tanks.client.warfare.models.common.longterm
{
   import alternativa.object.ClientObject;
   import alternativa.types.Long;
   
   public interface ILongTermBonusModelBase
   {
       
      
      function effectStart(param1:ClientObject, param2:Long, param3:int) : void;
      
      function effectStop(param1:ClientObject, param2:Long) : void;
   }
}
