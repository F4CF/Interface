package bhvr.controller
{
	import flash.events.EventDispatcher;
	import flash.utils.getQualifiedClassName;
	import bhvr.debug.Log;
	
	public class BaseEventController extends EventDispatcher
	{
		 
		
		protected var _eventStarted:Boolean = false;
		
		protected var _eventEnded:Boolean = false;
		
		public function BaseEventController()
		{
			super();
		}
		
		public function startEvent() : void
		{
			if(this._eventStarted)
			{
				throw new Error("Event is already started.");
			}
			this._eventStarted = true;
		}
		
		public function continueEvent(withAction:int = 0, data:Object = null) : void
		{
			this.logInfo("continueEvent : " + withAction);
			if(!this._eventStarted)
			{
				throw new Error("You cannot call continueEvent before event is started.");
			}
			if(this._eventEnded)
			{
				throw new Error("You cannot call continueEvent after event has ended.");
			}
		}
		
		public function dispose() : void
		{
		}
		
		protected function logInfo(message:String) : void
		{
			var className:String = null;
			className = getQualifiedClassName(this);
			Log.info("[" + className.substr(className.lastIndexOf(":") + 1) + "] " + message);
		}
		
		protected function logWarning(message:String) : void
		{
			var className:String = null;
			className = getQualifiedClassName(this);
			Log.warn("[" + className.substr(className.lastIndexOf(":") + 1) + "] " + message);
		}
	}
}
