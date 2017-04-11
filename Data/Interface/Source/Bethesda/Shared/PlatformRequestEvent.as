package Shared
{
	import flash.display.MovieClip;
	import flash.events.Event;
	
	public class PlatformRequestEvent extends Event
	{
		
		public static const PLATFORM_REQUEST:String = "GetPlatform";
		 
		
		var _target:MovieClip;
		
		public function PlatformRequestEvent(param1:MovieClip)
		{
			super(PLATFORM_REQUEST);
			this._target = param1;
		}
		
		public function RespondToRequest(param1:uint, param2:Boolean) : *
		{
			this._target.SetPlatform(param1,param2);
		}
	}
}
