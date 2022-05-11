package alternativa.model.general.dispatcher
{
   import alternativa.init.Main;
   import alternativa.model.IModel;
   import alternativa.model.IObjectLoadListener;
   import alternativa.object.ClientObject;
   import alternativa.osgi.service.alert.IAlertService;
   import alternativa.osgi.service.log.ILogService;
   import alternativa.osgi.service.log.LogLevel;
   import alternativa.protocol.codec.ICodec;
   import alternativa.protocol.codec.NullMap;
   import alternativa.protocol.codec.primitive.LongCodec;
   import alternativa.protocol.factory.ICodecFactory;
   import alternativa.register.ClientClass;
   import alternativa.register.ObjectRegister;
   import alternativa.register.SpaceInfo;
   import alternativa.service.IClassService;
   import alternativa.service.IModelService;
   import alternativa.service.ISpaceService;
   import alternativa.types.Long;
   import flash.utils.IDataInput;
   
   public class DispatcherModel implements IModel
   {
      
      private static const CHANNEL:String = "DISPATCHER";
       
      
      private var _objectRegister:ObjectRegister;
      
      private var classRegister:IClassService;
      
      public function DispatcherModel()
      {
         super();
         this.classRegister = IClassService(Main.osgi.getService(IClassService));
      }
      
      public function get interfaces() : Vector.<Class>
      {
         return Vector.<Class>([IModel]);
      }
      
      public function _initObject(clientObject:ClientObject, params:Object) : void
      {
      }
      
      public function invoke(clientObject:ClientObject, methodId:String, codecFactory:ICodecFactory, dataInput:IDataInput, nullMap:NullMap) : void
      {
         var spaceId:Long = null;
         var space:SpaceInfo = null;
         var spaces:Array = null;
         var i:int = 0;
         switch(methodId)
         {
            case "a":
               spaceId = Long(codecFactory.getCodec(Long).decode(dataInput,nullMap,true));
               Main.writeVarsToConsoleChannel(CHANNEL,"DispatcherModel connected space id=%1",spaceId);
               spaces = ISpaceService(Main.osgi.getService(ISpaceService)).spaceList;
               for(i = 0; i < spaces.length; i++)
               {
                  if(SpaceInfo(spaces[i]).objectRegister == this._objectRegister)
                  {
                     space = SpaceInfo(spaces[i]);
                  }
               }
               if(space != null)
               {
                  ISpaceService(Main.osgi.getService(ISpaceService)).setIdForSpace(space,spaceId);
                  break;
               }
               throw new Error("DispatcherModel connected space не найден в реестре");
               break;
            case "s":
               Main.writeVarsToConsoleChannel(CHANNEL,"[DispatcherModel.invoke] LOAD command recieved");
               this.loadEntities(codecFactory,dataInput,nullMap);
               break;
            case "":
               Main.writeVarsToConsoleChannel(CHANNEL,"[DispatcherModel.invoke] UNLOAD command recieved");
               this.unloadEntities(codecFactory,dataInput,nullMap);
         }
      }
      
      private function loadEntities(codecFactory:ICodecFactory, dataInput:IDataInput, nullMap:NullMap) : void
      {
		 // EDITED
         //var idx:int = 0;
         //var modelRegister:IModelService = null;
         //var model:IModel = null;
         //var params:Object = null;
         //var parentModelParams:Object = null;
         //Main.writeVarsToConsoleChannel(CHANNEL,"");
         //Main.writeVarsToConsoleChannel(CHANNEL,"Load object. Null map size=%1",nullMap.getSize());
         //var idCodec:ICodec = Main.codecFactory.getCodec(Long);
         //Main.writeVarsToConsoleChannel(CHANNEL,"Load object id=%1, class id=%2",null,null);
         //var object:ClientObject = this._objectRegister.createObject(null,this.classRegister.getClass(null),"object " + null.toString());
         //var parentClass:ClientClass = IClassService(Main.osgi.getService(IClassService)).getClass(null);
         //var modelId:Vector.<String> = parentClass.models;
         //var modelsCount:int = modelId.length;
         //for(idx = 0; idx < modelsCount; idx++)
         //{
         //   modelRegister = IModelService(Main.osgi.getService(IModelService));
         //   model = modelRegister.getModel(modelId[idx]);
         //   if(model == null)
         //   {
         //      Main.writeVarsToConsoleChannel(CHANNEL,"Model with id [%1] not found in registry",modelId[idx]);
         //      (Main.osgi.getService(ILogService) as ILogService).log(LogLevel.LOG_ERROR,"LOAD OBJECT ERROR: Model with id " + modelId[idx] + " not found in registry!");
         //      (Main.osgi.getService(IAlertService) as IAlertService).showAlert("A fatal error has occurred");
         //   }
         //   else
         //   {
         //      Main.writeVarsToConsoleChannel(CHANNEL,"Init object model id=%4, model=%1, data length=%2, null map size=%3",model,dataInput.bytesAvailable,nullMap.getSize(),model.id);
         //      parentModelParams = parentClass.modelsParams[modelId[idx]];
         //      params = parentModelParams;
         //      Main.writeVarsToConsoleChannel(CHANNEL,"Parent model params=%1",params);
         //      if(params != null)
         //      {
         //         object.putInitParams(model,params);
         //         model._initObject(object,params);
         //      }
         //   }
         //}
         //var listeners:Vector.<IModel> = IModelService(Main.osgi.getService(IModelService)).getModelsForObject(object,IObjectLoadListener);
         //for(var l:int = 0; l < listeners.length; IObjectLoadListener(listeners[l]).objectLoaded(object),l++)
         //{
         //}
		 return
      }
      
      private function unloadEntities(codecFactory:ICodecFactory, dataInput:IDataInput, nullMap:NullMap) : void
      {
         var longCodec:LongCodec = LongCodec(codecFactory.getCodec(Long));
         Main.writeToConsole("[DispatcherModel.invoke] unload " + null);
         this._objectRegister.destroyObject(null);
      }
      
      public function set objectRegister(register:ObjectRegister) : void
      {
         this._objectRegister = register;
      }
      
      public function get id() : String
      {
         return "";
      }
   }
}
