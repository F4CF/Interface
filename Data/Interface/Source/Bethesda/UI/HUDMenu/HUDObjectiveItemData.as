package
{
	import Shared.AS3.BSUIComponent;
	
	public class HUDObjectiveItemData extends BSUIComponent
	{
		 
		
		private var _objectiveMessage:String;
		
		private var _isCompleted:Boolean;
		
		private var _orWithPrevious:Boolean;
		
		public function HUDObjectiveItemData(param1:String, param2:Boolean, param3:Boolean)
		{
			super();
			this._objectiveMessage = param1;
			this._isCompleted = param2;
			this._orWithPrevious = param3;
		}
		
		public function get ObjectiveMessage() : String
		{
			return this._objectiveMessage;
		}
		
		public function get isCompleted() : Boolean
		{
			return this._isCompleted;
		}
		
		public function get orWithPrevious() : Boolean
		{
			return this._orWithPrevious;
		}
	}
}
