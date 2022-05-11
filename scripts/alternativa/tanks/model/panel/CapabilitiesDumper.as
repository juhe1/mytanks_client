package alternativa.tanks.model.panel
{
   import alternativa.osgi.service.dump.dumper.IDumper;
   import flash.system.Capabilities;
   
   public class CapabilitiesDumper implements IDumper
   {
       
      
      public function CapabilitiesDumper()
      {
         super();
      }
      
      public function dump(params:Vector.<String>) : String
      {
         var s:String = "\n\nCapabilities\n";
         s += "\n   os: " + Capabilities.os;
         s += "\n   version: " + Capabilities.version;
         s += "\n   playerType: " + Capabilities.playerType;
         s += "\n   isDebugger: " + Capabilities.isDebugger;
         s += "\n   language: " + Capabilities.language;
         return s + ("\n   screenResolution: " + Capabilities.screenResolutionX + " x " + Capabilities.screenResolutionY);
      }
      
      public function get dumperName() : String
      {
         return "capabilities";
      }
   }
}
