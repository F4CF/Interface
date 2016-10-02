package bhvr.module.event.operations
{
	public class EventContinuationOperation
	{
		 
		
		private var _withAction:int;
		
		private var _data:Object;
		
		public function EventContinuationOperation(withAction:int = 0, actionData:Object = null)
		{
			super();
			this._withAction = withAction;
			this._data = actionData;
		}
		
		public function get withAction() : int
		{
			return this._withAction;
		}
		
		public function get data() : Object
		{
			return this._data;
		}
	}
}
