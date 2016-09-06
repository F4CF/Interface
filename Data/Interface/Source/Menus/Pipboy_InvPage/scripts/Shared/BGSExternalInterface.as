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
			if(AS3.COMPANIONAPP.CompanionAppMode.isOn)
			{
				if(ExternalInterface.available)
				{
					ExternalInterface.call.apply(null,rest);
				}
				else
				{
					trace("BGSExternalInterface::call -- ExternalInterface is not available!");
				}
				return;
			}
			if(param1 != null)
			{
				_loc3_ = rest.shift();
				_loc4_ = param1[_loc3_];
				if(_loc4_ != null)
				{
					_loc4_.apply(null,rest);
				}
				else
				{
					trace("BGSExternalInterface::call -- Can\'t call function \'" + _loc3_ + "\' on BGSCodeObj. This function doesn\'t exist!");
				}
			}
			else
			{
				trace("BGSExternalInterface::call -- Can\'t call function \'" + _loc3_ + "\' on BGSCodeObj. BGSCodeObj is null!");
			}
		}
	}
}
