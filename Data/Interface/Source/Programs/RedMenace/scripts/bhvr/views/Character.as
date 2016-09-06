package bhvr.views
{
	import flash.geom.Point;
	import bhvr.utils.MathUtil;
	import bhvr.constants.GameConstants;
	import flash.display.MovieClip;
	
	public class Character extends InteractiveObject
	{
		
		public static const NO_STATE:uint = 0;
		
		public static const STANDING_STATE:uint = 1;
		
		public static const RUNNING_STATE:uint = 2;
		
		public static const STOP_STATE:uint = 3;
		
		public static const JUMPING_STATE:uint = 4;
		
		public static const CLIMBING_STATE:uint = 5;
		
		public static const STOP_CLIMBING_STATE:uint = 6;
		
		public static const FALLING_STATE:uint = 7;
		
		public static const DEATH_STATE:uint = 8;
		
		public static const NO_DIRECTION:int = 0;
		
		public static const LEFT_DIRECTION:int = 1;
		
		public static const RIGHT_DIRECTION:int = 2;
		
		public static const UP_DIRECTION:int = 3;
		
		public static const DOWN_DIRECTION:int = 4;
		 
		
		protected var _canJump:Boolean;
		
		protected var _canRun:Boolean;
		
		protected var _canClimbUp:Boolean;
		
		protected var _canClimbDown:Boolean;
		
		protected var _state:uint;
		
		protected var _direction:int;
		
		public function Character(assets:MovieClip)
		{
			super(assets);
			this._state = NO_STATE;
			this.reset();
		}
		
		public function get canJump() : Boolean
		{
			return this._canJump;
		}
		
		public function set canJump(value:Boolean) : void
		{
			this._canJump = value;
		}
		
		public function get canRun() : Boolean
		{
			return this._canRun;
		}
		
		public function set canRun(value:Boolean) : void
		{
			this._canRun = value;
		}
		
		public function get canClimb() : Boolean
		{
			return this._canClimbUp && this._canClimbDown;
		}
		
		public function set canClimb(value:Boolean) : void
		{
			this._canClimbUp = value;
			this._canClimbDown = value;
		}
		
		public function get canClimbUp() : Boolean
		{
			return this._canClimbUp;
		}
		
		public function set canClimbUp(value:Boolean) : void
		{
			this._canClimbUp = value;
		}
		
		public function get canClimbDown() : Boolean
		{
			return this._canClimbDown;
		}
		
		public function set canClimbDown(value:Boolean) : void
		{
			this._canClimbDown = value;
		}
		
		public function get state() : uint
		{
			return this._state;
		}
		
		public function get direction() : int
		{
			return this._direction;
		}
		
		public function get position() : Point
		{
			return new Point(_assets.x,_assets.y);
		}
		
		public function get thickness() : Number
		{
			return _collider.width;
		}
		
		public function reset() : void
		{
			this.setVisibility(true);
			this.setState(STANDING_STATE);
		}
		
		public function start() : void
		{
		}
		
		public function stop() : void
		{
		}
		
		public function setVisibility(isVisible:Boolean) : void
		{
			_assets.visible = isVisible;
		}
		
		public function setPosition(posX:Number, posY:Number) : void
		{
			this.setPositionX(posX);
			_assets.y = posY;
		}
		
		protected function setPositionX(posX:Number) : void
		{
			_assets.x = MathUtil.clamp(posX,this.thickness / 2,GameConstants.STAGE_WIDTH - this.thickness / 2);
		}
		
		protected function setDirection(dir:int) : void
		{
			this._direction = dir;
			_assets.scaleX = dir == LEFT_DIRECTION?Number(1):Number(-1);
		}
		
		protected function setState(state:uint) : void
		{
			this._state = state;
		}
		
		public function jump() : void
		{
			this.setState(JUMPING_STATE);
		}
		
		public function run(dir:int) : void
		{
			this.setState(RUNNING_STATE);
		}
		
		public function stopMoving() : void
		{
			this.setState(STOP_STATE);
		}
		
		public function climb(dir:int) : void
		{
			this.setState(CLIMBING_STATE);
		}
		
		public function fall() : void
		{
			this.setState(FALLING_STATE);
		}
		
		public function kill() : void
		{
			this.canClimb = false;
			this._canJump = false;
			this._canRun = false;
			this.setState(DEATH_STATE);
		}
		
		override public function dispose() : void
		{
			this.stop();
			super.dispose();
		}
	}
}
