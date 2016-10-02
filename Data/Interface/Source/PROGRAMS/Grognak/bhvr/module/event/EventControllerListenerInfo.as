package bhvr.module.event
{
	public class EventControllerListenerInfo
	{
		 
		
		private var _eventType:String;
		
		private var _listener:Function;
		
		private var _continueEvent:Boolean;
		
		public function EventControllerListenerInfo(eventType:String, listener:Function, continueEvent:Boolean = true)
		{
			super();
			this._eventType = eventType;
			this._listener = listener;
			this._continueEvent = continueEvent;
		}
		
		public function get eventType() : String
		{
			return this._eventType;
		}
		
		public function get listener() : Function
		{
			return this._listener;
		}
		
		public function get continueEvent() : Boolean
		{
			return this._continueEvent;
		}
	}
}
