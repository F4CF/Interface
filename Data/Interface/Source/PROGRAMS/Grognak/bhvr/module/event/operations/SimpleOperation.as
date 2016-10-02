package bhvr.module.event.operations
{
	public class SimpleOperation
	{
		
		public static const OPERATION_UPDATE_PARTY_STATS_UI:int = 0;
		
		public static const OPERATION_UPDATE_GOLD_UI:int = 1;
		 
		
		private var _operation:int;
		
		public function SimpleOperation(operation:int)
		{
			super();
			this._operation = operation;
		}
		
		public function get operation() : int
		{
			return this._operation;
		}
	}
}
