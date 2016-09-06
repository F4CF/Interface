package Holotapes.Common.touch
{
	import flash.geom.Point;
	
	public class Touch
	{
		 
		
		private var _fingerId:int;
		
		private var _screenPosition:Point;
		
		private var _stagePosition:Point;
		
		public function Touch(param1:int, param2:Point, param3:Point)
		{
			super();
			this._fingerId = param1;
			this._screenPosition = param2;
			this._stagePosition = param3;
		}
		
		public function get fingerId() : int
		{
			return this._fingerId;
		}
		
		public function get screenPosition() : Point
		{
			return this._screenPosition;
		}
		
		public function get stagePosition() : Point
		{
			return this._stagePosition;
		}
	}
}
