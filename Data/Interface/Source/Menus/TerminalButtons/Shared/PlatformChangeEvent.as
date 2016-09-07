package Shared
{
	import flash.events.Event;
	
	public class PlatformChangeEvent extends Event
	{
		
		public static const PLATFORM_PC_KB_MOUSE:uint = 0;
		
		public static const PLATFORM_PC_GAMEPAD:uint = 1;
		
		public static const PLATFORM_XB1:uint = 2;
		
		public static const PLATFORM_PS4:uint = 3;
		
		public static const PLATFORM_MOBILE:uint = 4;
		
		public static const PLATFORM_INVALID:uint = uint.MAX_VALUE;
		
		public static const PLATFORM_CHANGE:String = "SetPlatform";
		 
		
		var _uiPlatform:uint = 4.294967295E9;
		
		var _bPS3Switch:Boolean = false;
		
		public function PlatformChangeEvent(param1:uint, param2:Boolean)
		{
			super(PLATFORM_CHANGE,true,true);
			this.uiPlatform = param1;
			this.bPS3Switch = param2;
		}
		
		public function get uiPlatform() : *
		{
			return this._uiPlatform;
		}
		
		public function set uiPlatform(param1:uint) : *
		{
			this._uiPlatform = param1;
		}
		
		public function get bPS3Switch() : *
		{
			return this._bPS3Switch;
		}
		
		public function set bPS3Switch(param1:Boolean) : *
		{
			this._bPS3Switch = param1;
		}
	}
}
