package bhvr.views
{
	import flash.display.MovieClip;
	import flash.geom.Point;
	import bhvr.utils.FlashUtil;
	import aze.motion.eaze;
	import bhvr.events.EventWithParams;
	import bhvr.events.GameEvents;
	
	public class Bomb extends InteractiveObject
	{
		
		public static const FLYING_TYPE:uint = 0;
		
		public static const ROLLING_TYPE:uint = 1;
		 
		
		protected var _type:uint;
		
		protected var _speed:Number;
		
		public function Bomb(assets:MovieClip, type:uint)
		{
			super(assets);
			this._type = type;
			_collider = _assets;
			this.setVisual();
		}
		
		public function get assets() : MovieClip
		{
			return _assets;
		}
		
		public function get type() : uint
		{
			return this._type;
		}
		
		public function get colliderPoint() : Point
		{
			return FlashUtil.localToGlobalPosition(_assets.colliderPointMc);
		}
		
		public function set x(value:Number) : void
		{
			_assets.x = value;
		}
		
		public function get x() : Number
		{
			return _assets.x;
		}
		
		public function set y(value:Number) : void
		{
			_assets.y = value;
		}
		
		public function get y() : Number
		{
			return _assets.y;
		}
		
		public function get speed() : Number
		{
			return this._speed;
		}
		
		public function set speed(value:Number) : void
		{
			this._speed = value;
		}
		
		protected function setVisual() : void
		{
			var frameToPlay:String = this._type == FLYING_TYPE?"flyingBomb":"rollingBomb";
			_assets.gotoAndPlay(frameToPlay);
		}
		
		public function explode() : void
		{
			_collider = null;
			eaze(_assets.bombViewMc).play("explosionStart>explosionEnd").onComplete(this.onBombExploded);
		}
		
		protected function onBombExploded() : void
		{
			dispatchEvent(new EventWithParams(GameEvents.BOMB_EXPLODED,{"target":this}));
		}
	}
}
