package Shared
{
	import flash.events.Event;
	import flash.display.MovieClip;
	
	public class PlatformRequestEvent extends Event
	{
		
		public static const PLATFORM_REQUEST:String = "GetPlatform";
		 
		
		var _target:MovieClip;
		
		public function PlatformRequestEvent(aTarget:MovieClip)
		{
			super(PLATFORM_REQUEST);
			this._target = aTarget;
		}
		
		public function RespondToRequest(auiPlatform:uint, abPS3Switch:Boolean) : *
		{
			this._target.SetPlatform(auiPlatform,abPS3Switch);
		}
	}
}
