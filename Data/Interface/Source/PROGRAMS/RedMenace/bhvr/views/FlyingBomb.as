package bhvr.views
{
	import flash.geom.Point;
	import flash.display.MovieClip;
	
	public class FlyingBomb extends Bomb
	{
		
		public static const FLYING_TRAJECTORY_NUM:uint = 3;
		 
		
		private var _collisionPoints:Vector.<Point>;
		
		public function FlyingBomb(assets:MovieClip)
		{
			super(assets,Bomb.FLYING_TYPE);
			this._collisionPoints = this.getCollisionPoints();
		}
		
		public function get collisionPoints() : Vector.<Point>
		{
			return this._collisionPoints;
		}
		
		public function set rotation(value:Number) : void
		{
			_assets.rotation = value - 180;
		}
		
		private function getCollisionPoints() : Vector.<Point>
		{
			var child:MovieClip = null;
			var pts:Vector.<Point> = new Vector.<Point>();
			for(var i:uint = 0; i < _assets.bombViewMc.numChildren; i++)
			{
				if(_assets.bombViewMc.getChildAt(i) is MovieClip)
				{
					child = _assets.bombViewMc.getChildAt(i) as MovieClip;
					pts.push(new Point(child.x,child.y));
				}
			}
			return pts;
		}
	}
}
