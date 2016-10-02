package bhvr.views
{
	import flash.events.EventDispatcher;
	import bhvr.interfaces.ICharacter;
	import flash.geom.Point;
	import flash.display.MovieClip;
	import bhvr.utils.FlashUtil;
	import bhvr.constants.GameConstants;
	
	public class Character extends EventDispatcher implements ICharacter
	{
		
		public static const NONE:String = "None";
		
		public static const HERO:String = "Hero";
		
		public static const HUMAN:String = "Human";
		
		public static const HERO_ID:String = "Hero";
		
		public static const ENEMY_GRUNT_ID:String = "Grunt";
		
		public static const ENEMY_ELECTRODE_ID:String = "Mine";
		
		public static const ENEMY_SPHEROID_ID:String = "Spawner";
		
		public static const ENEMY_ENFORCER_ID:String = "Spawned";
		
		public static const ENEMY_HULK_ID:String = "Indestructible";
		
		public static const ENEMY_BRAIN_ID:String = "Brain";
		
		public static const HUMAN_ID:String = "Human";
		
		public static const NO_STATE:uint = 0;
		
		public static const STANDING_STATE:uint = 1;
		
		public static const MOVING_STATE:uint = 2;
		
		public static const MOVING_UP_STATE:uint = 3;
		
		public static const MOVING_UP_LEFT_STATE:uint = 4;
		
		public static const MOVING_LEFT_STATE:uint = 5;
		
		public static const MOVING_DOWN_LEFT_STATE:uint = 6;
		
		public static const MOVING_DOWN_STATE:uint = 7;
		
		public static const STOP_STATE:uint = 8;
		
		public static const DEATH_STATE:uint = 9;
		
		public static const NO_DIRECTION:int = 0;
		
		public static const LEFT_DIRECTION:int = 1;
		
		public static const RIGHT_DIRECTION:int = 2;
		
		public static const UP_DIRECTION:int = 3;
		
		public static const DOWN_DIRECTION:int = 4;
		
		public static const UP_LEFT_DIRECTION:int = 5;
		
		public static const UP_RIGHT_DIRECTION:int = 6;
		
		public static const DOWN_LEFT_DIRECTION:int = 7;
		
		public static const DOWN_RIGHT_DIRECTION:int = 8;
		
		public static const DIRECTION_VECTORS:Vector.<Point> = Vector.<Point>([new Point(0,0),new Point(-1,0),new Point(1,0),new Point(0,-1),new Point(0,1),new Point(-Math.SQRT1_2,-Math.SQRT1_2),new Point(Math.SQRT1_2,-Math.SQRT1_2),new Point(-Math.SQRT1_2,Math.SQRT1_2),new Point(Math.SQRT1_2,Math.SQRT1_2)]);
		 
		
		protected var _container:MovieClip;
		
		protected var _mainObject:MovieClip;
		
		private var _minX:Number;
		
		private var _maxX:Number;
		
		private var _minY:Number;
		
		private var _maxY:Number;
		
		protected var _id:String;
		
		protected var _state:uint;
		
		protected var _direction:int;
		
		protected var _speed:Number;
		
		public var position:Point;
		
		public var dimension:Point;
		
		public var _collider:MovieClip;
		
		public function Character(param1:MovieClip, param2:String, param3:String)
		{
			super();
			this._id = param2;
			this._container = param1;
			this._mainObject = param3 != NONE?FlashUtil.getLibraryItem(this._container,param3) as MovieClip:new MovieClip();
			this._container.addChild(this._mainObject);
			this.position = new Point(this._mainObject.x,this._mainObject.y);
			this.dimension = new Point(this._mainObject.width,this._mainObject.width);
			this._minX = GameConstants.gameZoneArea.x + this.dimension.x / 2;
			this._maxX = GameConstants.gameZoneArea.x + GameConstants.gameZoneArea.width - this.dimension.x / 2;
			this._minY = GameConstants.gameZoneArea.y + this.dimension.y / 2;
			this._maxY = GameConstants.gameZoneArea.y + GameConstants.gameZoneArea.height - this.dimension.y / 2;
			this.initialize();
		}
		
		public function get id() : String
		{
			return this._id;
		}
		
		public function get state() : uint
		{
			return this._state;
		}
		
		public function get direction() : int
		{
			return this._direction;
		}
		
		public function get speed() : Number
		{
			return this._speed;
		}
		
		public function get collider() : MovieClip
		{
			return this._collider;
		}
		
		protected function initialize() : void
		{
			this._collider = this._mainObject;
			this._direction = NO_DIRECTION;
			this._state = NO_STATE;
			this._speed = 0;
		}
		
		public function start() : void
		{
		}
		
		public function stop() : void
		{
		}
		
		public function update(param1:Point) : void
		{
		}
		
		public function playSpawnAnimation() : void
		{
		}
		
		public function setPosition(param1:Number, param2:Number) : void
		{
			var _loc3_:Number = Math.max(this._minX,Math.min(param1,this._maxX));
			var _loc4_:Number = Math.max(this._minY,Math.min(param2,this._maxY));
			this._mainObject.x = _loc3_;
			this._mainObject.y = _loc4_;
			this.position.x = _loc3_;
			this.position.y = _loc4_;
		}
		
		protected function setDirection(param1:int) : void
		{
			this._direction = param1;
		}
		
		protected function setState(param1:uint) : void
		{
			if(this._state != param1)
			{
				this._state = param1;
			}
		}
		
		public function stopMoving() : void
		{
			this.setState(STOP_STATE);
			this._direction = NO_DIRECTION;
		}
		
		public function destroy() : void
		{
			this._collider = null;
		}
		
		public function pause() : void
		{
		}
		
		public function resume() : void
		{
		}
		
		public function dispose() : void
		{
			this._container.removeChild(this._mainObject);
			this._collider = null;
			this._mainObject = null;
		}
	}
}
