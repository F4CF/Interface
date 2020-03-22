package Pipboy.COMPANIONAPP
{
	import flash.display.Stage;
	import flash.events.Event;
	
	public class MobileBackButtonEvent extends Event
	{
		
		public static const MOBILE_BACK_BUTTON_EVENT:String = "MobileBackButtonEvent";
		 
		
		public function MobileBackButtonEvent()
		{
			super(MOBILE_BACK_BUTTON_EVENT);
		}
		
		public static function DispatchEvent(param1:Stage) : *
		{
			var _loc2_:MobileBackButtonEvent = new MobileBackButtonEvent();
			param1.dispatchEvent(_loc2_);
		}
		
		public static function Register(param1:Stage, param2:Function) : *
		{
			param1.addEventListener(MOBILE_BACK_BUTTON_EVENT,param2);
		}
		
		public static function Unregister(param1:Stage, param2:Function) : *
		{
			param1.removeEventListener(MOBILE_BACK_BUTTON_EVENT,param2);
		}
	}
}
