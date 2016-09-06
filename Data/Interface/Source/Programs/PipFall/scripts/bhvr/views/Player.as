package bhvr.views
{
	import flash.geom.Point;
	import bhvr.manager.InputManager;
	import bhvr.constants.GameInputs;
	import flash.events.Event;
	import bhvr.events.EventWithParams;
	import flash.ui.Keyboard;
	import Shared.AS3.COMPANIONAPP.CompanionAppMode;
	import aze.motion.eaze;
	import bhvr.manager.SoundManager;
	import bhvr.data.SoundList;
	import bhvr.constants.GameConstants;
	import bhvr.data.GamePersistantData;
	import bhvr.events.GameEvents;
	import flash.display.MovieClip;
	
	public class Player extends InteractiveObject
	{
		
		public static const STANDING_STATE:uint = 0;
		
		public static const RUNNING_STATE:uint = 1;
		
		public static const STOP_STATE:uint = 2;
		
		public static const JUMPING_STATE:uint = 3;
		
		public static const CLIMBING_STATE:uint = 4;
		
		public static const SWINGING_STATE:uint = 5;
		
		public static const FALLING_STATE:uint = 6;
		
		public static const DEATH_STATE:uint = 7;
		
		public static const LOOSE_STATE:uint = 8;
		
		public static const WIN_STATE:uint = 9;
		
		public static const OUTSIDE_LOCATION:uint = 0;
		
		public static const LADDER_LOCATION:uint = 1;
		
		public static const TUNNEL_LOCATION:uint = 2;
		
		public static const NO_DIRECTION:int = 0;
		
		public static const LEFT_DIRECTION:int = 1;
		
		public static const RIGHT_DIRECTION:int = 2;
		
		public static const UP_DIRECTION:int = 3;
		
		public static const DOWN_DIRECTION:int = 4;
		
		public static const CLIMB_LEFT_LEG:String = "ClimbLeftLeg";
		
		public static const CLIMB_RIGHT_LEG:String = "ClimbRightLeg";
		
		public static const RUN_LEFT_LEG:String = "RunLeftLeg";
		
		public static const RUN_RIGHT_LEG:String = "RunRightLeg";
		 
		
		private const SLOW_MOTION_SPEED:Number = 0.1;
		
		private var _slowMotion:Boolean;
		
		private var _jumpInputRequest:Boolean;
		
		private var _fallInputRequest:Boolean;
		
		private var _canJump:Boolean;
		
		private var _canRun:Boolean;
		
		private var _canClimbUp:Boolean;
		
		private var _canClimbDown:Boolean;
		
		private var _invincible:Boolean;
		
		private var _state:uint;
		
		private var _location:uint;
		
		private var _direction:int;
		
		private const JUMP_START_SPEED_OUTSIDE:Number = 23;
		
		private const JUMP_START_SPEED_TUNNEL:Number = 16;
		
		private const JUMP_PHASE_1_DURATION:Number = 0.2;
		
		private const JUMP_PHASE_2_DURATION:Number = 0.375;
		
		private const JUMP_EASE_COEFF:Number = 2;
		
		private var _jumpSpeed:Number;
		
		private var _rope:bhvr.views.Rope;
		
		private var _currentClimbLegIsLeft:Boolean;
		
		public function Player(container:MovieClip)
		{
			_type = InteractiveObject.PLAYER;
			super(container,_type);
			_collider = _mainObject.colliderMc;
			this.setDirection(RIGHT_DIRECTION);
			this.setState(STANDING_STATE);
			this.setLocation(OUTSIDE_LOCATION);
			this._canRun = true;
			this._canJump = true;
			this.canClimb = false;
			this._currentClimbLegIsLeft = true;
			this._invincible = false;
			this._slowMotion = false;
			this._direction = NO_DIRECTION;
		}
		
		public function get slowMotion() : Boolean
		{
			return this._slowMotion;
		}
		
		public function set slowMotion(value:Boolean) : void
		{
			this._slowMotion = value;
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
		
		public function get invincible() : Boolean
		{
			return this._invincible;
		}
		
		public function get state() : uint
		{
			return this._state;
		}
		
		public function get location() : uint
		{
			return this._location;
		}
		
		public function get direction() : int
		{
			return this._direction;
		}
		
		public function get position() : Point
		{
			return new Point(_mainObject.x,_mainObject.y);
		}
		
		public function get thickness() : Number
		{
			return _collider.width;
		}
		
		private function get _isAnimated() : Boolean
		{
			return this._state == RUNNING_STATE || this._state == JUMPING_STATE || this._state == CLIMBING_STATE || this._state == DEATH_STATE || this._state == WIN_STATE || this._state == LOOSE_STATE;
		}
		
		public function start() : void
		{
			InputManager.instance.addEventListener(GameInputs.MOVE_LEFT,this.onPlayerMoveLeft,false,0,true);
			InputManager.instance.addEventListener(GameInputs.MOVE_RIGHT,this.onPlayerMoveRight,false,0,true);
			InputManager.instance.addEventListener(GameInputs.MOVE_UP,this.onPlayerMoveUp,false,0,true);
			InputManager.instance.addEventListener(GameInputs.MOVE_DOWN,this.onPlayerMoveDown,false,0,true);
			InputManager.instance.addEventListener(GameInputs.JUMP,this.onPlayerJump,false,0,true);
			InputManager.instance.addEventListener(GameInputs.STOP_JUMP,this.onPlayerStopJump,false,0,true);
			InputManager.instance.addEventListener(GameInputs.STOP_MOVE,this.onPlayerStop,false,0,true);
			_container.addEventListener(Event.ENTER_FRAME,this.onUpdate,false,0,true);
			_mainObject.addEventListener(Player.CLIMB_LEFT_LEG,this.onClimbLeftLeg,false,0,true);
			_mainObject.addEventListener(Player.CLIMB_RIGHT_LEG,this.onClimbRightLeg,false,0,true);
			_mainObject.addEventListener(Player.RUN_LEFT_LEG,this.onRunLeg,false,0,true);
			_mainObject.addEventListener(Player.RUN_RIGHT_LEG,this.onRunLeg,false,0,true);
		}
		
		public function stop() : void
		{
			InputManager.instance.removeEventListener(GameInputs.MOVE_LEFT,this.onPlayerMoveLeft);
			InputManager.instance.removeEventListener(GameInputs.MOVE_RIGHT,this.onPlayerMoveRight);
			InputManager.instance.removeEventListener(GameInputs.MOVE_UP,this.onPlayerMoveUp);
			InputManager.instance.removeEventListener(GameInputs.MOVE_DOWN,this.onPlayerMoveDown);
			InputManager.instance.removeEventListener(GameInputs.JUMP,this.onPlayerJump);
			InputManager.instance.removeEventListener(GameInputs.STOP_JUMP,this.onPlayerStopJump);
			InputManager.instance.removeEventListener(GameInputs.STOP_MOVE,this.onPlayerStop);
			_container.removeEventListener(Event.ENTER_FRAME,this.onUpdate);
			_mainObject.removeEventListener(Player.CLIMB_LEFT_LEG,this.onClimbLeftLeg);
			_mainObject.removeEventListener(Player.CLIMB_RIGHT_LEG,this.onClimbRightLeg);
			_mainObject.removeEventListener(Player.RUN_LEFT_LEG,this.onRunLeg);
			_mainObject.removeEventListener(Player.RUN_RIGHT_LEG,this.onRunLeg);
			this.stopMoving();
		}
		
		public function setVisibility(isVisible:Boolean) : void
		{
			_container.visible = isVisible;
		}
		
		private function onPlayerStop(e:EventWithParams) : void
		{
			var keyCode:int = e.params.keyCode;
			if((keyCode == Keyboard.LEFT || keyCode == Keyboard.A || keyCode == InputManager.MOVE_LEFT_CODE) && this._direction == LEFT_DIRECTION || (keyCode == Keyboard.RIGHT || keyCode == Keyboard.D || keyCode == InputManager.MOVE_RIGHT_CODE) && this._direction == RIGHT_DIRECTION || (keyCode == Keyboard.UP || keyCode == Keyboard.W || keyCode == InputManager.MOVE_UP_CODE) && this._direction == UP_DIRECTION || (keyCode == Keyboard.DOWN || keyCode == Keyboard.S || keyCode == InputManager.MOVE_DOWN_CODE) && this._direction == DOWN_DIRECTION)
			{
				this._direction = NO_DIRECTION;
			}
		}
		
		private function onPlayerJump(e:EventWithParams) : void
		{
			if(this._canJump)
			{
				this._jumpInputRequest = true;
			}
			else if(this._state == SWINGING_STATE)
			{
				if(!this._jumpInputRequest)
				{
					this.setState(FALLING_STATE);
				}
			}
		}
		
		private function onPlayerStopJump(e:EventWithParams) : void
		{
			this._jumpInputRequest = false;
		}
		
		private function onPlayerMoveLeft(e:EventWithParams) : void
		{
			if(CompanionAppMode.isOn && this._direction != NO_DIRECTION)
			{
				return;
			}
			if(this._canRun)
			{
				this._direction = LEFT_DIRECTION;
			}
			else if(this._state == SWINGING_STATE)
			{
				if(this._direction != LEFT_DIRECTION)
				{
					this.setState(FALLING_STATE);
					this._direction = LEFT_DIRECTION;
				}
			}
			else
			{
				this._direction = NO_DIRECTION;
			}
		}
		
		private function onPlayerMoveRight(e:EventWithParams) : void
		{
			if(CompanionAppMode.isOn && this._direction != NO_DIRECTION)
			{
				return;
			}
			if(this._canRun)
			{
				this._direction = RIGHT_DIRECTION;
			}
			else if(this._state == SWINGING_STATE)
			{
				if(this._direction != RIGHT_DIRECTION)
				{
					this.setState(FALLING_STATE);
					this._direction = RIGHT_DIRECTION;
				}
			}
			else
			{
				this._direction = NO_DIRECTION;
			}
		}
		
		private function onPlayerMoveUp(e:EventWithParams) : void
		{
			if(CompanionAppMode.isOn && this._direction != NO_DIRECTION)
			{
				return;
			}
			if(this._canClimbUp)
			{
				this._direction = UP_DIRECTION;
			}
			else
			{
				this._direction = NO_DIRECTION;
			}
		}
		
		private function onPlayerMoveDown(e:EventWithParams) : void
		{
			if(CompanionAppMode.isOn && this._direction != NO_DIRECTION)
			{
				return;
			}
			if(this._canClimbDown)
			{
				this._direction = DOWN_DIRECTION;
			}
			else if(this._state == SWINGING_STATE)
			{
				this.setState(FALLING_STATE);
			}
			else
			{
				this._direction = NO_DIRECTION;
			}
		}
		
		private function onUpdate(e:Event) : void
		{
			switch(this._direction)
			{
				case LEFT_DIRECTION:
					this.run(this._direction);
					break;
				case RIGHT_DIRECTION:
					this.run(this._direction);
					break;
				case UP_DIRECTION:
					this.climb(this._direction);
					break;
				case DOWN_DIRECTION:
					this.climb(this._direction);
					break;
				case NO_DIRECTION:
					this.stopMoving();
			}
			if(this._jumpInputRequest && this._state != FALLING_STATE || this._state == JUMPING_STATE)
			{
				this.jump();
			}
			if(this._state == FALLING_STATE)
			{
				this.fall();
			}
		}
		
		public function setPosition(posX:Number, posY:Number) : void
		{
			_mainObject.x = posX;
			_mainObject.y = posY;
		}
		
		private function setDirection(dir:int) : void
		{
			this._direction = dir;
			_mainObject.scaleX = dir == LEFT_DIRECTION?Number(1):Number(-1);
		}
		
		private function setState(state:uint) : void
		{
			if(this._state != state)
			{
				switch(state)
				{
					case STANDING_STATE:
						_mainObject.pipFallViewMc.gotoAndPlay("stand");
						break;
					case RUNNING_STATE:
						_mainObject.pipFallViewMc.gotoAndPlay("run");
						break;
					case STOP_STATE:
						if(this._state == RUNNING_STATE)
						{
							_mainObject.pipFallViewMc.gotoAndPlay("stop");
						}
						else if(this._state == CLIMBING_STATE)
						{
							_mainObject.pipFallViewMc.gotoAndStop(!!this._currentClimbLegIsLeft?"climbLeftLeg":"climbRightLeg");
						}
						break;
					case JUMPING_STATE:
						_mainObject.pipFallViewMc.gotoAndPlay("jumpStart");
						break;
					case CLIMBING_STATE:
						_mainObject.pipFallViewMc.gotoAndPlay(!!this._currentClimbLegIsLeft?"climbRightLeg":"climbLeftLeg");
						break;
					case SWINGING_STATE:
						_mainObject.pipFallViewMc.gotoAndPlay("swing");
						break;
					case FALLING_STATE:
						_mainObject.pipFallViewMc.gotoAndPlay("fall");
						break;
					case DEATH_STATE:
						eaze(_mainObject.pipFallViewMc).play("deathStart>deathEnd").onComplete(this.onPlayerDead);
						break;
					case LOOSE_STATE:
						eaze(_mainObject.pipFallViewMc).play("looseStart>looseEnd").onComplete(this.onPlayerLoose);
						break;
					case WIN_STATE:
						eaze(_mainObject.pipFallViewMc).play("winStart>winEnd").onComplete(this.onPlayerWin);
				}
				this._state = state;
			}
		}
		
		public function setLocation(location:uint) : void
		{
			this._location = location;
		}
		
		public function jump() : void
		{
			var startSpeed:Number = NaN;
			var floorPos:Number = NaN;
			if(this._canJump)
			{
				startSpeed = this._location == OUTSIDE_LOCATION?Number(this.JUMP_START_SPEED_OUTSIDE):Number(this.JUMP_START_SPEED_TUNNEL);
				if(this._state != JUMPING_STATE)
				{
					this.setState(JUMPING_STATE);
					this._jumpSpeed = -startSpeed;
					_mainObject.y = _mainObject.y + this._jumpSpeed;
					SoundManager.instance.playSound(SoundList.PLAYER_JUMP_SOUND);
				}
				else
				{
					if(this._jumpSpeed < 0)
					{
						this._jumpSpeed = this._jumpSpeed * (1 - this.JUMP_PHASE_1_DURATION);
						if(this._jumpSpeed > -this.JUMP_EASE_COEFF)
						{
							this._jumpSpeed = this._jumpSpeed * -1;
						}
					}
					else if(this._jumpSpeed > 0 && this._jumpSpeed <= startSpeed)
					{
						this._jumpSpeed = this._jumpSpeed * (1 + this.JUMP_PHASE_2_DURATION);
					}
					_mainObject.y = _mainObject.y + (!!this.slowMotion?this.SLOW_MOTION_SPEED:this._jumpSpeed);
					floorPos = this._location == OUTSIDE_LOCATION?Number(GameConstants.OUTSIDE_FLOOR_POSITION):Number(GameConstants.TUNNEL_FLOOR_POSITION);
					if(_mainObject.y >= floorPos)
					{
						this.setState(STANDING_STATE);
						_mainObject.y = floorPos;
					}
				}
				if(this._direction == LEFT_DIRECTION)
				{
					this.setDirection(this._direction);
					_mainObject.x = _mainObject.x - (!!this.slowMotion?this.SLOW_MOTION_SPEED:GameConstants.playerJumpSpeed);
				}
				else if(this._direction == RIGHT_DIRECTION)
				{
					this.setDirection(this._direction);
					_mainObject.x = _mainObject.x + (!!this.slowMotion?this.SLOW_MOTION_SPEED:GameConstants.playerJumpSpeed);
				}
			}
		}
		
		public function run(dir:int) : void
		{
			if(this._canRun)
			{
				if(this._state != JUMPING_STATE && this._state != FALLING_STATE)
				{
					this.setState(RUNNING_STATE);
					this.setDirection(dir);
					if(dir == LEFT_DIRECTION)
					{
						_mainObject.x = _mainObject.x - (!!this.slowMotion?this.SLOW_MOTION_SPEED:GameConstants.playerRunSpeed);
					}
					else
					{
						_mainObject.x = _mainObject.x + (!!this.slowMotion?this.SLOW_MOTION_SPEED:GameConstants.playerRunSpeed);
					}
				}
			}
		}
		
		public function stopMoving() : void
		{
			if(this._state == RUNNING_STATE)
			{
				this.setState(STOP_STATE);
				this._state = STANDING_STATE;
			}
			else if(this._state == CLIMBING_STATE)
			{
				this.setState(STOP_STATE);
			}
		}
		
		public function climb(dir:int) : void
		{
			if(this._canClimbDown && dir == DOWN_DIRECTION || this._canClimbUp && dir == UP_DIRECTION)
			{
				this.setState(CLIMBING_STATE);
				this.setLocation(LADDER_LOCATION);
				if(dir == UP_DIRECTION)
				{
					_mainObject.y = _mainObject.y - GameConstants.playerClimbSpeed;
				}
				else
				{
					_mainObject.y = _mainObject.y + GameConstants.playerClimbSpeed;
				}
			}
		}
		
		private function onClimbLeftLeg(e:Event) : void
		{
			this._currentClimbLegIsLeft = true;
			SoundManager.instance.playSound(SoundList.PLAYER_FOOT_SOUND);
		}
		
		private function onClimbRightLeg(e:Event) : void
		{
			this._currentClimbLegIsLeft = false;
			SoundManager.instance.playSound(SoundList.PLAYER_FOOT_SOUND);
		}
		
		private function onRunLeg(e:Event) : void
		{
			SoundManager.instance.playSound(SoundList.PLAYER_FOOT_SOUND);
		}
		
		public function swing(rope:bhvr.views.Rope) : void
		{
			this._rope = rope;
			this._rope.addEventListener(Rope.ROPE_UPDATE_EVENT,this.onRopeUpdate);
			this._canRun = false;
			this._canJump = false;
			this.setState(SWINGING_STATE);
			var pos:Point = _mainObject.scaleX == 1?rope.leftAnchorPoint:rope.rightAnchorPoint;
			this.followRope(pos,rope.rotation);
		}
		
		private function followRope(pos:Point, rotation:Number) : void
		{
			this.setPosition(pos.x,pos.y);
			_mainObject.rotation = rotation;
		}
		
		private function onRopeUpdate(e:EventWithParams) : void
		{
			var pos:Point = _mainObject.scaleX == 1?e.params.leftAnchorPoint:e.params.rightAnchorPoint;
			this.followRope(pos,e.params.rotation);
		}
		
		public function fall() : void
		{
			if(this._rope != null)
			{
				this._rope.removeEventListener(Rope.ROPE_UPDATE_EVENT,this.onRopeUpdate);
			}
			if(GamePersistantData.lifeNum == 0)
			{
				this._canRun = false;
				this._canJump = false;
				this.canClimb = false;
			}
			else
			{
				this._canRun = true;
				this._canJump = true;
			}
			_mainObject.y = _mainObject.y + GameConstants.playerFallSpeedYAxis;
			_mainObject.rotation = 0;
			if(this._direction == LEFT_DIRECTION)
			{
				this.setDirection(this._direction);
				_mainObject.x = _mainObject.x - GameConstants.playerFallSpeedXAxis;
			}
			else if(this._direction == RIGHT_DIRECTION)
			{
				this.setDirection(this._direction);
				_mainObject.x = _mainObject.x + GameConstants.playerFallSpeedXAxis;
			}
			var floorPos:Number = this._location == OUTSIDE_LOCATION?Number(GameConstants.OUTSIDE_FLOOR_POSITION):Number(GameConstants.TUNNEL_FLOOR_POSITION);
			if(_mainObject.y >= floorPos)
			{
				this.setState(STANDING_STATE);
				_mainObject.y = floorPos;
				if(GamePersistantData.lifeNum == 0)
				{
					this.setState(DEATH_STATE);
					SoundManager.instance.startSound(SoundList.PLAYER_DEATH_SOUND_ID);
				}
			}
		}
		
		public function jumpOnObstacle(objPos:Point) : void
		{
			this.setState(STANDING_STATE);
			this.setPosition(_mainObject.x,objPos.y);
			this._canRun = true;
			this._canJump = true;
		}
		
		public function fallOfObstacle() : void
		{
			if(this._state != JUMPING_STATE)
			{
				this._canRun = false;
				this._canJump = false;
				this.setState(FALLING_STATE);
			}
			else
			{
				this._canRun = true;
				this._canJump = true;
			}
		}
		
		public function damage() : void
		{
			if(!this._invincible)
			{
				this._invincible = true;
				eaze(_mainObject).play("damageStart>damageEnd").onComplete(this.onDamageEnd);
				SoundManager.instance.playSound(SoundList.PLAYER_HIT_SOUND);
			}
		}
		
		private function onDamageEnd() : void
		{
			this._invincible = false;
		}
		
		public function kill() : void
		{
			var floorPos:Number = NaN;
			this.canClimb = false;
			this._canJump = false;
			this._canRun = false;
			this._invincible = true;
			if(this._state == SWINGING_STATE)
			{
				this.setState(FALLING_STATE);
			}
			else if(this._location == LADDER_LOCATION)
			{
				this._location = GameConstants.TUNNEL_FLOOR_POSITION;
				this.setState(FALLING_STATE);
			}
			else
			{
				floorPos = this._location == OUTSIDE_LOCATION?Number(GameConstants.OUTSIDE_FLOOR_POSITION):Number(GameConstants.TUNNEL_FLOOR_POSITION);
				_mainObject.y = floorPos;
				this.setState(DEATH_STATE);
				SoundManager.instance.startSound(SoundList.PLAYER_DEATH_SOUND_ID);
			}
		}
		
		public function loose() : void
		{
			this.canClimb = false;
			this._canJump = false;
			this._canRun = false;
			this._invincible = true;
			if(this._state == SWINGING_STATE)
			{
				this.fall();
			}
			var floorPos:Number = this._location == OUTSIDE_LOCATION?Number(GameConstants.OUTSIDE_FLOOR_POSITION):Number(GameConstants.TUNNEL_FLOOR_POSITION);
			_mainObject.y = floorPos;
			this.setState(LOOSE_STATE);
			SoundManager.instance.startLongSound(SoundList.PLAYER_TIME_OVER_SOUND_ID);
		}
		
		public function win() : void
		{
			this.canClimb = false;
			this._canJump = false;
			this._canRun = false;
			this._invincible = true;
			_mainObject.y = GameConstants.OUTSIDE_FLOOR_POSITION;
			this.setState(WIN_STATE);
		}
		
		private function onPlayerDead() : void
		{
			SoundManager.instance.stopSound(SoundList.PLAYER_DEATH_SOUND_ID);
			dispatchEvent(new EventWithParams(GameEvents.PLAYER_DEAD));
		}
		
		private function onPlayerLoose() : void
		{
			dispatchEvent(new EventWithParams(GameEvents.PLAYER_LOOSE));
		}
		
		private function onPlayerWin() : void
		{
			dispatchEvent(new EventWithParams(GameEvents.PLAYER_WIN));
		}
		
		override public function pause() : void
		{
			InputManager.instance.removeEventListener(GameInputs.MOVE_LEFT,this.onPlayerMoveLeft);
			InputManager.instance.removeEventListener(GameInputs.MOVE_RIGHT,this.onPlayerMoveRight);
			InputManager.instance.removeEventListener(GameInputs.MOVE_UP,this.onPlayerMoveUp);
			InputManager.instance.removeEventListener(GameInputs.MOVE_DOWN,this.onPlayerMoveDown);
			InputManager.instance.removeEventListener(GameInputs.JUMP,this.onPlayerJump);
			InputManager.instance.removeEventListener(GameInputs.STOP_JUMP,this.onPlayerStopJump);
			InputManager.instance.removeEventListener(GameInputs.STOP_MOVE,this.onPlayerStop);
			_container.removeEventListener(Event.ENTER_FRAME,this.onUpdate);
			_mainObject.removeEventListener(Player.CLIMB_LEFT_LEG,this.onClimbLeftLeg);
			_mainObject.removeEventListener(Player.CLIMB_RIGHT_LEG,this.onClimbRightLeg);
			_mainObject.removeEventListener(Player.RUN_LEFT_LEG,this.onRunLeg);
			_mainObject.removeEventListener(Player.RUN_RIGHT_LEG,this.onRunLeg);
			if(this._isAnimated)
			{
				_mainObject.pipFallViewMc.stop();
			}
			this._jumpInputRequest = false;
			this._direction = NO_DIRECTION;
		}
		
		override public function resume() : void
		{
			InputManager.instance.addEventListener(GameInputs.MOVE_LEFT,this.onPlayerMoveLeft,false,0,true);
			InputManager.instance.addEventListener(GameInputs.MOVE_RIGHT,this.onPlayerMoveRight,false,0,true);
			InputManager.instance.addEventListener(GameInputs.MOVE_UP,this.onPlayerMoveUp,false,0,true);
			InputManager.instance.addEventListener(GameInputs.MOVE_DOWN,this.onPlayerMoveDown,false,0,true);
			InputManager.instance.addEventListener(GameInputs.JUMP,this.onPlayerJump,false,0,true);
			InputManager.instance.addEventListener(GameInputs.STOP_JUMP,this.onPlayerStopJump,false,0,true);
			InputManager.instance.addEventListener(GameInputs.STOP_MOVE,this.onPlayerStop,false,0,true);
			_container.addEventListener(Event.ENTER_FRAME,this.onUpdate,false,0,true);
			_mainObject.addEventListener(Player.CLIMB_LEFT_LEG,this.onClimbLeftLeg,false,0,true);
			_mainObject.addEventListener(Player.CLIMB_RIGHT_LEG,this.onClimbRightLeg,false,0,true);
			_mainObject.addEventListener(Player.RUN_LEFT_LEG,this.onRunLeg,false,0,true);
			_mainObject.addEventListener(Player.RUN_RIGHT_LEG,this.onRunLeg,false,0,true);
			if(this._isAnimated)
			{
				_mainObject.pipFallViewMc.play();
			}
		}
		
		override public function dispose() : void
		{
			this.stop();
			super.dispose();
		}
	}
}
