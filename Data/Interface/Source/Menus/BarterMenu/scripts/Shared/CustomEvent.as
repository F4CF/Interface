package Shared
{
	import flash.events.Event;
	
	public class CustomEvent extends Event
	{
		 
		
		public var params:Object;
		
		public function CustomEvent(param1:String, param2:Object, param3:Boolean = false, param4:Boolean = false)
		{
			super(param1,param3,param4);
			this.params = param2;
		}
		
		override public function clone() : Event
		{
			return new CustomEvent(type,this.params,bubbles,cancelable);
		}
	}
}
