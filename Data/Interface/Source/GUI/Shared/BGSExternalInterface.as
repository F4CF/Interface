package Shared
{
	public class BGSExternalInterface
	{
		 
		
		public function BGSExternalInterface()
		{
			super();
		}
		
		public static function call(BGSCodeObj:Object, ... args) : void
		{
			var funcName:String = null;
			var func:Function = null;
			if(BGSCodeObj != null)
			{
				funcName = args.shift();
				func = BGSCodeObj[funcName];
				if(func != null)
				{
					func.apply(null,args);
				}
				else
				{
					trace("BGSExternalInterface::call -- Can\'t call function \'" + funcName + "\' on BGSCodeObj. This function doesn\'t exist!");
				}
			}
			else
			{
				trace("BGSExternalInterface::call -- Can\'t call function \'" + funcName + "\' on BGSCodeObj. BGSCodeObj is null!");
			}
		}
	}
}
