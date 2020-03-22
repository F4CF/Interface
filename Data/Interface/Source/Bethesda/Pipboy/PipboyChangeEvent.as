package
{
	import flash.display.Stage;
	import flash.events.Event;
	
	public class PipboyChangeEvent extends Event
	{
		
		public static const PIPBOY_CHANGE_EVENT:String = "PipboyChangeEvent";
		 
		
		private var _UpdateMask:PipboyUpdateMask;
		
		private var _DataObj:Pipboy_DataObj;
		
		private var _TabNames:Array;
		
		public function PipboyChangeEvent()
		{
			super(PIPBOY_CHANGE_EVENT);
		}
		
		public static function DispatchEvent(param1:PipboyUpdateMask, param2:Stage, param3:Pipboy_DataObj, param4:Array) : *
		{
			var _loc5_:PipboyChangeEvent = new PipboyChangeEvent();
			_loc5_._UpdateMask = param1;
			_loc5_._DataObj = param3;
			_loc5_._TabNames = param4;
			param2.dispatchEvent(_loc5_);
			_loc5_._DataObj = null;
			_loc5_._TabNames = null;
		}
		
		public static function Register(param1:Stage, param2:Function) : *
		{
			param1.addEventListener(PIPBOY_CHANGE_EVENT,param2);
		}
		
		public static function Unregister(param1:Stage, param2:Function) : *
		{
			param1.removeEventListener(PIPBOY_CHANGE_EVENT,param2);
		}
		
		public function get UpdateMask() : PipboyUpdateMask
		{
			return this._UpdateMask;
		}
		
		public function get DataObj() : Pipboy_DataObj
		{
			return this._DataObj;
		}
		
		public function get TabNames() : Array
		{
			return this._TabNames;
		}
	}
}
