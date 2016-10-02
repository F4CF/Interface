package bhvr.views
{
	import flash.display.MovieClip;
	
	public class Ladder extends InteractiveObject
	{
		
		public static const LADDER_DELTA_DETECTION:Number = 1.5;
		 
		
		public function Ladder(container:MovieClip)
		{
			_type = InteractiveObject.LADDER;
			super(container,_type);
			_collider = _mainObject.ladderViewMc;
		}
		
		public function get thickness() : Number
		{
			return _mainObject.ladderViewMc.width;
		}
		
		public function get topPosition() : Number
		{
			return _mainObject.ladderViewMc.y - _mainObject.ladderViewMc.height / 2;
		}
		
		public function get bottomPosition() : Number
		{
			return _mainObject.ladderViewMc.y + _mainObject.ladderViewMc.height / 2;
		}
		
		public function get snapPosition() : Number
		{
			return _mainObject.ladderViewMc.x;
		}
	}
}
