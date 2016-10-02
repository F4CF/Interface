package Shared
{
	import flash.events.Event;
	
	public class CustomEvent extends Event
	{
		 
		
		public var params:Object;
		
		public function CustomEvent(astrType:String, aParams:Object, abBubbles:Boolean = false, abCancelable:Boolean = false)
		{
			super(astrType,abBubbles,abCancelable);
			this.params = aParams;
		}
		
		override public function clone() : Event
		{
			return new CustomEvent(type,this.params,bubbles,cancelable);
		}
	}
}
