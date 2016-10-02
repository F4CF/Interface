package Holotapes.Common.touch
{
	import flash.geom.Point;
	
	public class Touch
	{
		 
		
		private var _fingerId:int;
		
		private var _screenPosition:Point;
		
		private var _stagePosition:Point;
		
		public function Touch(fingerId:int, screenPosition:Point, stagePosition:Point)
		{
			super();
			this._fingerId = fingerId;
			this._screenPosition = screenPosition;
			this._stagePosition = stagePosition;
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
