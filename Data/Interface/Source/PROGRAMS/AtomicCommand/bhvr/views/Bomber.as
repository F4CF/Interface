package bhvr.views
{
	import flash.display.MovieClip;
	import flash.geom.Point;
	import aze.motion.eaze;
	import bhvr.events.EventWithParams;
	import bhvr.events.GameEvents;
	
	public class Bomber extends Projectile
	{
		 
		
		private var _projectileView:MovieClip;
		
		private var _dropPosX:Number;
		
		private var _targetPosition:Point;
		
		private var _hasDroppedBomb:Boolean;
		
		private var _hasPassed:Boolean;
		
		public function Bomber(flashAssets:MovieClip)
		{
			super(flashAssets,Projectile.BOMBER_TYPE);
			this._projectileView = _projectile.bomberViewMc;
			_collider = this._projectileView;
			this._hasDroppedBomb = false;
			this._hasPassed = false;
		}
		
		public function get projectileView() : MovieClip
		{
			return this._projectileView;
		}
		
		public function get dropPosX() : Number
		{
			return this._dropPosX;
		}
		
		public function set dropPosX(value:Number) : void
		{
			this._dropPosX = value;
		}
		
		public function get targetPosition() : Point
		{
			return this._targetPosition;
		}
		
		public function set targetPosition(value:Point) : void
		{
			this._targetPosition = value;
		}
		
		public function get hasDroppedBomb() : Boolean
		{
			return this._hasDroppedBomb;
		}
		
		public function set hasDroppedBomb(value:Boolean) : void
		{
			this._hasDroppedBomb = value;
		}
		
		public function get hasPassed() : Boolean
		{
			return this._hasPassed;
		}
		
		public function set hasPassed(value:Boolean) : void
		{
			this._hasPassed = value;
		}
		
		public function get widthValue() : Number
		{
			return this._projectileView.width;
		}
		
		public function get collisionPoints() : Vector.<Point>
		{
			var child:MovieClip = null;
			var pts:Vector.<Point> = new Vector.<Point>();
			for(var i:uint = 0; i < this._projectileView.numChildren; i++)
			{
				if(this._projectileView.getChildAt(i) is MovieClip)
				{
					child = this._projectileView.getChildAt(i) as MovieClip;
					pts.push(new Point(child.x,child.y));
				}
			}
			return pts;
		}
		
		public function setInitialProperties(position:Point) : void
		{
			this._projectileView.scaleX = position.x > 0?Number(1):Number(-1);
			this._projectileView.x = position.x;
			this._projectileView.y = position.y;
		}
		
		public function destroy() : void
		{
			this._projectileView.visible = false;
			_collider = null;
			_projectile.bomberExplosionMc.x = this._projectileView.x;
			_projectile.bomberExplosionMc.y = this._projectileView.y;
			eaze(_projectile.bomberExplosionMc).play("start>end").onComplete(this.onBomberDestroyed);
		}
		
		private function onBomberDestroyed() : void
		{
			dispatchEvent(new EventWithParams(GameEvents.BOMBER_DESTROYED,{"target":this}));
		}
		
		override public function dispose() : void
		{
			this._projectileView = null;
			_collider = null;
			super.dispose();
		}
	}
}
