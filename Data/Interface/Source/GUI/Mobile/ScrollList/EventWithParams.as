package Mobile.ScrollList
{
	import flash.events.Event;
	import flash.utils.getQualifiedClassName;
	
	public class EventWithParams extends Event
	{
		 
		
		public var params:Object;
		
		public function EventWithParams(_type:String, _params:Object = null, _bubbles:Boolean = false, _cancelable:Boolean = false)
		{
			super(_type,_bubbles,_cancelable);
			this.params = _params;
		}
		
		override public function clone() : Event
		{
			return new EventWithParams(type,this.params,bubbles,cancelable);
		}
		
		override public function toString() : String
		{
			return formatToString(getQualifiedClassName(this),"type","bubbles","cancelable","eventPhase","params");
		}
	}
}
