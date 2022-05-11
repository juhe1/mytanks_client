package com.reygazu.anticheat.variables
{
   import com.reygazu.anticheat.managers.CheatManager;
   
   public class SecureBoolean
   {
       
      
      private var secureData:SecureObject;
      
      private var fake:Boolean;
      
      public function SecureBoolean(name:String = "Unnamed SecureBoolean")
      {
         super();
         this.secureData = new SecureObject();
      }
      
      public function set value(data:Boolean) : void
      {
         if(this.fake != this.secureData.objectValue)
         {
            CheatManager.getInstance().detectCheat(this.secureData.name,this.fake,this.secureData.objectValue);
         }
         this.secureData.objectValue = data;
         this.fake = data;
      }
      
      public function get value() : Boolean
      {
         return this.secureData.objectValue as Boolean;
      }
   }
}
