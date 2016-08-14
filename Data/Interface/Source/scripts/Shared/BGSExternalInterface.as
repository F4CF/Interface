package Shared
{
   import flash.external.ExternalInterface;
   
   public class BGSExternalInterface
   {
       
      public function BGSExternalInterface()
      {
         super();
      }
      
      public static function call(param1:Object, ... rest) : void
      {
         var _loc3_:String = null;
         var _loc4_:Function = null;
         if(ExternalInterface.available)
         {
            ExternalInterface.call.apply(null,rest);
         }
         else
         {
            trace("BGSExternalInterface::call -- ExternalInterface is not available!");
         }
      }
   }
}
