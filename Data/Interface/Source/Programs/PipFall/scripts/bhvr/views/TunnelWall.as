package bhvr.views
{
	import flash.display.MovieClip;
	
	public class TunnelWall extends InteractiveObject
	{
		
		public static const WALL_DELTA_DETECTION:Number = 6;
		 
		
		public function TunnelWall(container:MovieClip, type:int)
		{
			super(container,type);
			_collider = _mainObject.colliderMc;
		}
		
		public function get thickness() : Number
		{
			return _collider.width;
		}
		
		public function get position() : Number
		{
			return _mainObject.wallViewMc.x;
		}
	}
}
