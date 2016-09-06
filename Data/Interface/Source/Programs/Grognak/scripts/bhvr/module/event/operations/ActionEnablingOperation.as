package bhvr.module.event.operations
{
	public class ActionEnablingOperation
	{
		 
		
		private var _actions:Vector.<String>;
		
		private var _callback:Function;
		
		private var _disableActionsOnCallback:Boolean;
		
		public function ActionEnablingOperation(actions:Vector.<String>, callback:Function, disableActionsOnCallback:Boolean)
		{
			super();
			this._actions = actions;
			this._callback = callback;
			this._disableActionsOnCallback = disableActionsOnCallback;
		}
		
		public function get actions() : Vector.<String>
		{
			return this._actions;
		}
		
		public function get callback() : Function
		{
			return this._callback;
		}
		
		public function get disableActionsOnCallback() : Boolean
		{
			return this._disableActionsOnCallback;
		}
	}
}
