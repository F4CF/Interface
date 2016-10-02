package bhvr.views
{
	import flash.geom.Point;
	import bhvr.utils.FlashUtil;
	import flash.display.MovieClip;
	import bhvr.manager.InputManager;
	import bhvr.constants.GameInputs;
	import bhvr.events.EventWithParams;
	import flash.ui.Keyboard;
	import Shared.AS3.COMPANIONAPP.CompanionAppMode;
	import aze.motion.eaze;
	import bhvr.manager.SoundManager;
	import bhvr.data.SoundList;
	import bhvr.constants.GameConstants;
	import flash.events.Event;
	import bhvr.data.GamePersistantData;
	import bhvr.events.GameEvents;
	
	public class Hero extends Character
	{
		
		public static const POWER_ARMOR_STATE:uint = DEATH_STATE + 1;
		
		public static const CLIMB_LEFT_LEG:String = "ClimbLeftLeg";
		
		public static const CLIMB_RIGHT_LEG:String = "ClimbRightLeg";
		
		public static const RUN_LEFT_LEG:String = "RunLeftFoot";
		
		public static const RUN_RIGHT_LEG:String = "RunRightFoot";
		 
		
		private var _initialPosition:Point;
		
		private var _jumpInputRequest:Boolean;
		
		private var _invincible:Boolean;
		
		private var _speedModifier:Number;
		
		private const JUMP_START_SPEED:Number = 10;
		
		private const JUMP_PHASE_1_DURATION:Number = 0.2;
		
		private const JUMP_PHASE_2_DURATION:Number = 0.375;
		
		private const JUMP_EASE_COEFF:Number = 1;
		
		private var _jumpSpeed:Number;
		
		private var _currentClimbLegIsLeft:Boolean;
		
		private var _powerArmorTimerObject:MovieClip;
		
		public function Hero(assets:MovieClip)
		{
			this._powerArmorTimerObject = new MovieClip();
			this._initialPosition = new Point(assets.x,assets.y);
			super(assets);
		}
		
		public function get invincible() : Boolean
		{
			return this._invincible;
		}
		
		public function get hasPowerArmor() : Boolean
		{
			return this._invincible;
		}
		
		override public function get canJump() : Boolean
		{
			return _canJump && !this._invincible;
		}
		
		public function get speedModifier() : Number
		{
			return this._speedModifier;
		}
		
		public function set speedModifier(value:Number) : void
		{
			this._speedModifier = value;
		}
		
		public function get isOnLadder() : Boolean
		{
			return _state == CLIMBING_STATE || _state == STOP_CLIMBING_STATE;
		}
		
		public function get colliderPoint() : Point
		{
			return FlashUtil.localToGlobalPosition(_assets.pipboyViewMc.colliderPointMc);
		}
		
		public function get colliderShape() : MovieClip
		{
			return _assets;
		}
		
		private function get _isAnimated() : Boolean
		{
			return _state == RUNNING_STATE || _state == JUMPING_STATE || _state == CLIMBING_STATE;
		}
		
		override public function reset() : void
		{
			_collider = _assets.pipboyViewMc.colliderMc;
			setPosition(this._initialPosition.x,this._initialPosition.y);
			_canRun = true;
			_canJump = true;
			canClimb = false;
			this._currentClimbLegIsLeft = true;
			this._invincible = false;
			super.reset();
		}
		
		override public function start() : void
		{
			this.reset();
			InputManager.instance.addEventListener(GameInputs.MOVE_LEFT,this.onPlayerMoveLeft,false,0,true);
			InputManager.instance.addEventListener(GameInputs.MOVE_RIGHT,this.onPlayerMoveRight,false,0,true);
			InputManager.instance.addEventListener(GameInputs.MOVE_UP,this.onPlayerMoveUp,false,0,true);
			InputManager.instance.addEventListener(GameInputs.MOVE_DOWN,this.onPlayerMoveDown,false,0,true);
			InputManager.instance.addEventListener(GameInputs.JUMP,this.onPlayerJump,false,0,true);
			InputManager.instance.addEventListener(GameInputs.STOP_JUMP,this.onPlayerStopJump,false,0,true);
			InputManager.instance.addEventListener(GameInputs.STOP_MOVE,this.onPlayerStop,false,0,true);
			_assets.addEventListener(Hero.CLIMB_LEFT_LEG,this.onClimbLeftLeg,false,0,true);
			_assets.addEventListener(Hero.CLIMB_RIGHT_LEG,this.onClimbRightLeg,false,0,true);
			_assets.addEventListener(Hero.RUN_LEFT_LEG,this.onRunFootOnFloor,false,0,true);
			_assets.addEventListener(Hero.RUN_RIGHT_LEG,this.onRunFootOnFloor,false,0,true);
		}
		
		override public function stop() : void
		{
			InputManager.instance.removeEventListener(GameInputs.MOVE_LEFT,this.onPlayerMoveLeft);
			InputManager.instance.removeEventListener(GameInputs.MOVE_RIGHT,this.onPlayerMoveRight);
			InputManager.instance.removeEventListener(GameInputs.MOVE_UP,this.onPlayerMoveUp);
			InputManager.instance.removeEventListener(GameInputs.MOVE_DOWN,this.onPlayerMoveDown);
			InputManager.instance.removeEventListener(GameInputs.JUMP,this.onPlayerJump);
			InputManager.instance.removeEventListener(GameInputs.STOP_JUMP,this.onPlayerStopJump);
			InputManager.instance.removeEventListener(GameInputs.STOP_MOVE,this.onPlayerStop);
			_assets.removeEventListener(Hero.CLIMB_LEFT_LEG,this.onClimbLeftLeg);
			_assets.removeEventListener(Hero.CLIMB_RIGHT_LEG,this.onClimbRightLeg);
			_assets.removeEventListener(Hero.RUN_LEFT_LEG,this.onRunFootOnFloor);
			_assets.removeEventListener(Hero.RUN_RIGHT_LEG,this.onRunFootOnFloor);
			this.stopMoving();
		}
		
		private function onPlayerStop(e:EventWithParams) : void
		{
			var keyCode:int = e.params.keyCode;
			if((keyCode == Keyboard.LEFT || keyCode == Keyboard.A || keyCode == InputManager.MOVE_LEFT_CODE) && _direction == LEFT_DIRECTION || (keyCode == Keyboard.RIGHT || keyCode == Keyboard.D || keyCode == InputManager.MOVE_RIGHT_CODE) && _direction == RIGHT_DIRECTION || (keyCode == Keyboard.UP || keyCode == Keyboard.W || keyCode == InputManager.MOVE_UP_CODE) && _direction == UP_DIRECTION || (keyCode == Keyboard.DOWN || keyCode == Keyboard.S || keyCode == InputManager.MOVE_DOWN_CODE) && _direction == DOWN_DIRECTION)
			{
				_direction = NO_DIRECTION;
			}
		}
		
		private function onPlayerJump(e:EventWithParams) : void
		{
			if(this.canJump)
			{
				this._jumpInputRequest = true;
			}
		}
		
		private function onPlayerStopJump(e:EventWithParams) : void
		{
			this._jumpInputRequest = false;
		}
		
		private function onPlayerMoveLeft(e:EventWithParams) : void
		{
			if(CompanionAppMode.isOn && _direction != NO_DIRECTION)
			{
				return;
			}
			_direction = !!_canRun?int(LEFT_DIRECTION):int(NO_DIRECTION);
		}
		
		private function onPlayerMoveRight(e:EventWithParams) : void
		{
			if(CompanionAppMode.isOn && _direction != NO_DIRECTION)
			{
				return;
			}
			_direction = !!_canRun?int(RIGHT_DIRECTION):int(NO_DIRECTION);
		}
		
		private function onPlayerMoveUp(e:EventWithParams) : void
		{
			if(CompanionAppMode.isOn && _direction != NO_DIRECTION)
			{
				return;
			}
			_direction = !!_canClimbUp?int(UP_DIRECTION):int(NO_DIRECTION);
		}
		
		private function onPlayerMoveDown(e:EventWithParams) : void
		{
			if(CompanionAppMode.isOn && _direction != NO_DIRECTION)
			{
				return;
			}
			_direction = !!_canClimbDown?int(DOWN_DIRECTION):int(NO_DIRECTION);
		}
		
		public function update() : void
		{
			switch(_direction)
			{
				case LEFT_DIRECTION:
					this.run(_direction);
					break;
				case RIGHT_DIRECTION:
					this.run(_direction);
					break;
				case UP_DIRECTION:
					this.climb(_direction);
					break;
				case DOWN_DIRECTION:
					this.climb(_direction);
					break;
				case NO_DIRECTION:
					this.stopMoving();
			}
			if(_state == FALLING_STATE)
			{
				this.fall();
			}
			else if(this._jumpInputRequest && _state != FALLING_STATE || _state == JUMPING_STATE)
			{
				this.jump();
			}
			else if(this._speedModifier != 0 && (_state == STANDING_STATE || _state == RUNNING_STATE))
			{
				setPositionX(_assets.x + this._speedModifier);
			}
		}
		
		override protected function setState(state:uint) : void
		{
			var frameToPlay:String = null;
			var pipboy:MovieClip = null;
			if(_state != state)
			{
				pipboy = _assets.pipboyViewMc;
				switch(state)
				{
					case STANDING_STATE:
						frameToPlay = !!this._invincible?"standPA":"stand";
						pipboy.gotoAndPlay(frameToPlay);
						break;
					case RUNNING_STATE:
						if(_state == POWER_ARMOR_STATE)
						{
							eaze(pipboy).killTweens();
						}
						frameToPlay = !!this._invincible?"runPA":"run";
						pipboy.gotoAndPlay(frameToPlay);
						break;
					case STOP_STATE:
						frameToPlay = !!this._invincible?"standPA":"stop";
						pipboy.gotoAndPlay(frameToPlay);
						break;
					case STOP_CLIMBING_STATE:
						pipboy.gotoAndStop(!!this._currentClimbLegIsLeft?"climbLeftLeg":"climbRightLeg");
						break;
					case JUMPING_STATE:
						pipboy.gotoAndPlay("jumpStart");
						break;
					case CLIMBING_STATE:
						pipboy.gotoAndPlay(!!this._currentClimbLegIsLeft?"climbRightLeg":"climbLeftLeg");
						break;
					case FALLING_STATE:
						frameToPlay = !!this._invincible?"fallPA":"fall";
						pipboy.gotoAndPlay(frameToPlay);
						break;
					case DEATH_STATE:
						eaze(pipboy).play("deathStart>deathEnd").onComplete(this.onHeroDamaged);
						break;
					case POWER_ARMOR_STATE:
						eaze(pipboy).play("collectPAStart>collectPAEnd").onComplete(this.onPowerArmorCollected);
				}
				_state = state;
			}
		}
		
		override public function jump() : void
		{
			if(this.canJump)
			{
				canClimb = false;
				if(_state != JUMPING_STATE)
				{
					this.setState(JUMPING_STATE);
					this._jumpSpeed = -this.JUMP_START_SPEED;
					_assets.y = _assets.y + this._jumpSpeed;
					SoundManager.instance.playSound(SoundList.HERO_JUMP_SOUND);
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
					else if(this._jumpSpeed > 0 && this._jumpSpeed <= this.JUMP_START_SPEED)
					{
						this._jumpSpeed = this._jumpSpeed * (1 + this.JUMP_PHASE_2_DURATION);
					}
					_assets.y = _assets.y + this._jumpSpeed;
					if(_assets.y >= GameConstants.STAGE_HEIGHT)
					{
						this.setState(STANDING_STATE);
						_assets.y = GameConstants.STAGE_HEIGHT;
					}
				}
				if(_direction == LEFT_DIRECTION)
				{
					setDirection(_direction);
					setPositionX(_assets.x - GameConstants.playerJumpSpeed);
				}
				else if(_direction == RIGHT_DIRECTION)
				{
					setDirection(_direction);
					setPositionX(_assets.x + GameConstants.playerJumpSpeed);
				}
			}
		}
		
		public function land() : void
		{
			this.setState(STANDING_STATE);
		}
		
		override public function run(dir:int) : void
		{
			if(_canRun)
			{
				if(_state != JUMPING_STATE && _state != FALLING_STATE)
				{
					this.setState(RUNNING_STATE);
					setDirection(dir);
					if(dir == LEFT_DIRECTION)
					{
						setPositionX(_assets.x - GameConstants.playerRunSpeed);
					}
					else
					{
						setPositionX(_assets.x + GameConstants.playerRunSpeed);
					}
				}
			}
		}
		
		override public function stopMoving() : void
		{
			_direction = NO_DIRECTION;
			if(_state == RUNNING_STATE)
			{
				this.setState(STOP_STATE);
				_state = STANDING_STATE;
			}
			else if(_state == CLIMBING_STATE)
			{
				this.setState(STOP_CLIMBING_STATE);
			}
		}
		
		override public function climb(dir:int) : void
		{
			if(!this._invincible)
			{
				if(_canClimbDown && dir == DOWN_DIRECTION || _canClimbUp && dir == UP_DIRECTION)
				{
					this.setState(CLIMBING_STATE);
					if(dir == UP_DIRECTION)
					{
						_assets.y = _assets.y - GameConstants.playerClimbSpeed;
					}
					else
					{
						_assets.y = _assets.y + GameConstants.playerClimbSpeed;
					}
				}
			}
			else
			{
				this.setState(STANDING_STATE);
			}
		}
		
		public function finishClimbing() : void
		{
			this.setState(STANDING_STATE);
		}
		
		private function onClimbLeftLeg(e:Event) : void
		{
			this._currentClimbLegIsLeft = true;
			SoundManager.instance.playSound(SoundList.HERO_CLIMB_FOOT_SOUND);
		}
		
		private function onClimbRightLeg(e:Event) : void
		{
			this._currentClimbLegIsLeft = false;
			SoundManager.instance.playSound(SoundList.HERO_CLIMB_FOOT_SOUND);
		}
		
		private function onRunFootOnFloor(e:Event) : void
		{
			SoundManager.instance.playSound(SoundList.HERO_RUN_FOOT_SOUND);
		}
		
		override public function fall() : void
		{
			this.setState(FALLING_STATE);
			if(GamePersistantData.lifeNum == 0)
			{
				_canRun = false;
				_canJump = false;
				canClimb = false;
			}
			else
			{
				_canRun = true;
				_canJump = true;
			}
			_assets.y = _assets.y + GameConstants.playerFallSpeedYAxis;
			if(_direction == LEFT_DIRECTION)
			{
				setDirection(_direction);
				setPositionX(_assets.x - GameConstants.playerFallSpeedXAxis);
			}
			else if(_direction == RIGHT_DIRECTION)
			{
				setDirection(_direction);
				setPositionX(_assets.x + GameConstants.playerFallSpeedXAxis);
			}
			if(_assets.y >= GameConstants.STAGE_HEIGHT)
			{
				this.setState(STANDING_STATE);
				_assets.y = GameConstants.STAGE_HEIGHT;
			}
		}
		
		private function resetPowerArmor() : void
		{
			if(this.hasPowerArmor)
			{
				eaze(this._powerArmorTimerObject).killTweens();
				_assets.gotoAndPlay("normal");
			}
		}
		
		public function collectPowerArmor() : void
		{
			this._invincible = true;
			this.setState(POWER_ARMOR_STATE);
			dispatchEvent(new EventWithParams(GameEvents.POWER_ARMOR_START));
			eaze(this._powerArmorTimerObject).delay(GameConstants.powerArmorDuration - GameConstants.powerArmorLowWarningTime).onComplete(this.onPowerArmorLowWarning).delay(GameConstants.powerArmorLowWarningTime - GameConstants.powerArmorHighWarningTime).onComplete(this.onPowerArmorHighWarning).delay(GameConstants.powerArmorHighWarningTime).onComplete(this.onPowerArmorEnd);
		}
		
		private function onPowerArmorCollected() : void
		{
			this.setState(STANDING_STATE);
		}
		
		private function onPowerArmorLowWarning() : void
		{
			_assets.gotoAndPlay("slowBlink");
		}
		
		private function onPowerArmorHighWarning() : void
		{
			_assets.gotoAndPlay("fastBlink");
		}
		
		private function onPowerArmorEnd() : void
		{
			_assets.gotoAndPlay("normal");
			this._invincible = false;
			dispatchEvent(new EventWithParams(GameEvents.POWER_ARMOR_END));
			if(_state == RUNNING_STATE)
			{
				this.setState(STANDING_STATE);
				this.setState(RUNNING_STATE);
			}
			else
			{
				this.setState(RUNNING_STATE);
				this.setState(STANDING_STATE);
			}
		}
		
		public function damage() : void
		{
			if(!this.invincible || GamePersistantData.bonusTimer <= 0)
			{
				canClimb = false;
				_canJump = false;
				_canRun = false;
				_collider = null;
				this.resetPowerArmor();
				this.setState(DEATH_STATE);
			}
		}
		
		public function win(girlRef:MovieClip) : void
		{
			canClimb = false;
			_canJump = false;
			_canRun = false;
			setDirection(position.x - girlRef.x > 0?int(LEFT_DIRECTION):int(RIGHT_DIRECTION));
			_collider = null;
			this._jumpInputRequest = false;
			_direction = NO_DIRECTION;
			this.setState(STANDING_STATE);
			this.resetPowerArmor();
			this.stop();
		}
		
		public function modifySpeed(speedX:Number, speedY:Number) : void
		{
			setPositionX(_assets.x + speedX);
			_assets.y = _assets.y + speedY;
		}
		
		private function onHeroDamaged() : void
		{
			this.stop();
			if(GamePersistantData.lifeNum == 0)
			{
				dispatchEvent(new EventWithParams(GameEvents.HERO_DEAD));
			}
			else
			{
				dispatchEvent(new EventWithParams(GameEvents.HERO_DAMAGED));
			}
		}
		
		override public function pause() : void
		{
			super.pause();
			InputManager.instance.removeEventListener(GameInputs.MOVE_LEFT,this.onPlayerMoveLeft);
			InputManager.instance.removeEventListener(GameInputs.MOVE_RIGHT,this.onPlayerMoveRight);
			InputManager.instance.removeEventListener(GameInputs.MOVE_UP,this.onPlayerMoveUp);
			InputManager.instance.removeEventListener(GameInputs.MOVE_DOWN,this.onPlayerMoveDown);
			InputManager.instance.removeEventListener(GameInputs.JUMP,this.onPlayerJump);
			InputManager.instance.removeEventListener(GameInputs.STOP_JUMP,this.onPlayerStopJump);
			InputManager.instance.removeEventListener(GameInputs.STOP_MOVE,this.onPlayerStop);
			_assets.removeEventListener(Hero.CLIMB_LEFT_LEG,this.onClimbLeftLeg);
			_assets.removeEventListener(Hero.CLIMB_RIGHT_LEG,this.onClimbRightLeg);
			_assets.removeEventListener(Hero.RUN_LEFT_LEG,this.onRunFootOnFloor);
			_assets.removeEventListener(Hero.RUN_RIGHT_LEG,this.onRunFootOnFloor);
			if(this._isAnimated)
			{
				_assets.pipboyViewMc.stop();
			}
			if(this._invincible)
			{
				_assets.stop();
			}
			this._jumpInputRequest = false;
			_direction = NO_DIRECTION;
		}
		
		override public function resume() : void
		{
			super.resume();
			InputManager.instance.addEventListener(GameInputs.MOVE_LEFT,this.onPlayerMoveLeft,false,0,true);
			InputManager.instance.addEventListener(GameInputs.MOVE_RIGHT,this.onPlayerMoveRight,false,0,true);
			InputManager.instance.addEventListener(GameInputs.MOVE_UP,this.onPlayerMoveUp,false,0,true);
			InputManager.instance.addEventListener(GameInputs.MOVE_DOWN,this.onPlayerMoveDown,false,0,true);
			InputManager.instance.addEventListener(GameInputs.JUMP,this.onPlayerJump,false,0,true);
			InputManager.instance.addEventListener(GameInputs.STOP_JUMP,this.onPlayerStopJump,false,0,true);
			InputManager.instance.addEventListener(GameInputs.STOP_MOVE,this.onPlayerStop,false,0,true);
			_assets.addEventListener(Hero.CLIMB_LEFT_LEG,this.onClimbLeftLeg,false,0,true);
			_assets.addEventListener(Hero.CLIMB_RIGHT_LEG,this.onClimbRightLeg,false,0,true);
			_assets.addEventListener(Hero.RUN_LEFT_LEG,this.onRunFootOnFloor,false,0,true);
			_assets.addEventListener(Hero.RUN_RIGHT_LEG,this.onRunFootOnFloor,false,0,true);
			if(this._isAnimated)
			{
				_assets.pipboyViewMc.play();
			}
			if(this._invincible)
			{
				_assets.play();
			}
		}
		
		override public function dispose() : void
		{
			this.reset();
			super.dispose();
		}
	}
}
