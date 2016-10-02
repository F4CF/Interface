package bhvr.views
{
	import flash.display.MovieClip;
	import flash.geom.Point;
	import bhvr.constants.GameConstants;
	import bhvr.manager.InputManager;
	import bhvr.constants.GameInputs;
	import Shared.AS3.COMPANIONAPP.CompanionAppMode;
	import flash.events.MouseEvent;
	import bhvr.manager.SoundManager;
	import bhvr.data.SoundList;
	import aze.motion.eaze;
	import bhvr.events.EventWithParams;
	import bhvr.events.GameEvents;
	import flash.ui.Keyboard;
	import bhvr.utils.MathUtil;
	import flash.events.Event;
	import bhvr.utils.FlashUtil;
	import bhvr.data.GamePersistantData;
	
	public class Hero extends Character
	{
		 
		
		private var _gun:MovieClip;
		
		private var _bullets:Vector.<bhvr.views.HeroBullet>;
		
		private var _bulletsContainer:MovieClip;
		
		private var _fireRequested:Boolean;
		
		private var _canFire:Boolean;
		
		private var _rightStickPosition:Point;
		
		private var _invincible:Boolean;
		
		private var _started:Boolean;
		
		private var _hasRegisteredEvents:Boolean;
		
		private const SPAWN_INITIAL_SCALE_X:Number = 0.1;
		
		private const SPAWN_INITIAL_SCALE_Y:Number = 5;
		
		private const SPAWN_INITIAL_ALPHA:Number = 0.1;
		
		public function Hero(param1:MovieClip)
		{
			super(param1,Character.HERO_ID,Character.HERO);
			dimension.x = _mainObject.heroViewMc.bodyMc.width;
			dimension.y = _mainObject.heroViewMc.bodyMc.height;
		}
		
		public function get bullets() : Vector.<bhvr.views.HeroBullet>
		{
			return this._bullets;
		}
		
		public function get started() : Boolean
		{
			return this._started;
		}
		
		public function get invincible() : Boolean
		{
			return this._invincible;
		}
		
		override protected function initialize() : void
		{
			this._hasRegisteredEvents = false;
			this._started = false;
			_collider = _mainObject.heroViewMc.colliderMc;
			this._gun = _mainObject.heroViewMc.gunMc;
			this.setState(STANDING_STATE);
			_speed = GameConstants.heroSpeed;
			this._bulletsContainer = new MovieClip();
			_container.addChild(this._bulletsContainer);
			this._bullets = new Vector.<bhvr.views.HeroBullet>();
			this._fireRequested = false;
			this._canFire = true;
			this._invincible = true;
			this._rightStickPosition = new Point(0,0);
			_mainObject.visible = false;
			this.registerEvents();
		}
		
		public function reset() : void
		{
			this.removeBullets();
			_mainObject.visible = false;
		}
		
		private function registerEvents() : void
		{
			if(!this._hasRegisteredEvents)
			{
				InputManager.instance.addEventListener(GameInputs.MOVE_LEFT,this.onPlayerMoveLeft,false,0,true);
				InputManager.instance.addEventListener(GameInputs.MOVE_RIGHT,this.onPlayerMoveRight,false,0,true);
				InputManager.instance.addEventListener(GameInputs.MOVE_UP,this.onPlayerMoveUp,false,0,true);
				InputManager.instance.addEventListener(GameInputs.MOVE_DOWN,this.onPlayerMoveDown,false,0,true);
				InputManager.instance.addEventListener(GameInputs.STOP_MOVE,this.onPlayerStop,false,0,true);
				if(!CompanionAppMode.isOn)
				{
					_container.stage.addEventListener(MouseEvent.MOUSE_DOWN,this.onFireTurnedOn,false,0,true);
					_container.stage.addEventListener(MouseEvent.MOUSE_UP,this.onFireTurnedOff,false,0,true);
				}
				if(InputManager.instance.isKeyboardMouseVersion)
				{
					InputManager.instance.addEventListener(GameInputs.FIRE,this.onFireTurnedOn,false,0,true);
					InputManager.instance.addEventListener(GameInputs.STOP_FIRE,this.onFireTurnedOff,false,0,true);
				}
				else
				{
					InputManager.instance.addEventListener(GameInputs.LEFT_STICK_POS_UPDATE,this.onLeftStickMove,false,0,true);
					InputManager.instance.addEventListener(GameInputs.RIGHT_STICK_POS_UPDATE,this.onRightStickMove,false,0,true);
				}
				this._hasRegisteredEvents = true;
			}
		}
		
		private function unregisterEvents() : void
		{
			if(this._hasRegisteredEvents)
			{
				InputManager.instance.removeEventListener(GameInputs.MOVE_LEFT,this.onPlayerMoveLeft);
				InputManager.instance.removeEventListener(GameInputs.MOVE_RIGHT,this.onPlayerMoveRight);
				InputManager.instance.removeEventListener(GameInputs.MOVE_UP,this.onPlayerMoveUp);
				InputManager.instance.removeEventListener(GameInputs.MOVE_DOWN,this.onPlayerMoveDown);
				InputManager.instance.removeEventListener(GameInputs.STOP_MOVE,this.onPlayerStop);
				_container.stage.removeEventListener(MouseEvent.MOUSE_DOWN,this.onFireTurnedOn);
				_container.stage.removeEventListener(MouseEvent.MOUSE_UP,this.onFireTurnedOff);
				if(InputManager.instance.isKeyboardMouseVersion)
				{
					InputManager.instance.removeEventListener(GameInputs.FIRE,this.onFireTurnedOn);
					InputManager.instance.removeEventListener(GameInputs.STOP_FIRE,this.onFireTurnedOff);
				}
				else
				{
					InputManager.instance.removeEventListener(GameInputs.LEFT_STICK_POS_UPDATE,this.onLeftStickMove);
					InputManager.instance.removeEventListener(GameInputs.RIGHT_STICK_POS_UPDATE,this.onRightStickMove);
				}
				this._hasRegisteredEvents = false;
			}
		}
		
		override public function start() : void
		{
			this._started = true;
			this._invincible = false;
		}
		
		override public function stop() : void
		{
			this._started = false;
			this.onFireTurnedOff();
			stopMoving();
		}
		
		public function spawn() : void
		{
			SoundManager.instance.playSound(SoundList.HERO_INIT_SPAWN_SOUND);
			setPosition(GameConstants.heroSpawnPosition.x,GameConstants.heroSpawnPosition.y);
			this.playSpawnAnimation();
			_mainObject.visible = true;
		}
		
		override public function playSpawnAnimation() : void
		{
			_mainObject.scaleX = this.SPAWN_INITIAL_SCALE_X;
			_mainObject.scaleY = this.SPAWN_INITIAL_SCALE_Y;
			_mainObject.alpha = this.SPAWN_INITIAL_ALPHA;
			eaze(_mainObject).to(GameConstants.heroSpawnAnimationDuration,{
				"scaleX":1,
				"scaleY":1,
				"alpha":1
			}).onComplete(dispatchEvent,new EventWithParams(GameEvents.HERO_SPAWN_FINISHED));
		}
		
		private function onPlayerStop(param1:EventWithParams) : void
		{
			var _loc2_:int = param1.params.keyCode;
			if(_loc2_ == Keyboard.LEFT || _loc2_ == Keyboard.A || _loc2_ == InputManager.MOVE_LEFT_CODE)
			{
				if(_direction == LEFT_DIRECTION)
				{
					stopMoving();
				}
				else if(_direction == UP_LEFT_DIRECTION)
				{
					_direction = UP_DIRECTION;
				}
				else if(_direction == DOWN_LEFT_DIRECTION)
				{
					_direction = DOWN_DIRECTION;
				}
			}
			else if(_loc2_ == Keyboard.RIGHT || _loc2_ == Keyboard.D || _loc2_ == InputManager.MOVE_RIGHT_CODE)
			{
				if(_direction == RIGHT_DIRECTION)
				{
					stopMoving();
				}
				else if(_direction == UP_RIGHT_DIRECTION)
				{
					_direction = UP_DIRECTION;
				}
				else if(_direction == DOWN_RIGHT_DIRECTION)
				{
					_direction = DOWN_DIRECTION;
				}
			}
			else if(_loc2_ == Keyboard.UP || _loc2_ == Keyboard.W || _loc2_ == InputManager.MOVE_UP_CODE)
			{
				if(_direction == UP_DIRECTION)
				{
					stopMoving();
				}
				else if(_direction == UP_RIGHT_DIRECTION)
				{
					_direction = RIGHT_DIRECTION;
				}
				else if(_direction == UP_LEFT_DIRECTION)
				{
					_direction = LEFT_DIRECTION;
				}
			}
			else if(_loc2_ == Keyboard.DOWN || _loc2_ == Keyboard.S || _loc2_ == InputManager.MOVE_DOWN_CODE)
			{
				if(_direction == DOWN_DIRECTION)
				{
					stopMoving();
				}
				else if(_direction == DOWN_RIGHT_DIRECTION)
				{
					_direction = RIGHT_DIRECTION;
				}
				else if(_direction == DOWN_LEFT_DIRECTION)
				{
					_direction = LEFT_DIRECTION;
				}
			}
		}
		
		private function onPlayerMoveLeft(param1:EventWithParams) : void
		{
			var _loc2_:int = param1.params.keyCode as int;
			if(InputManager.instance.isKeyboardMouseVersion || !InputManager.instance.isKeyboardMouseVersion && _loc2_ == InputManager.MOVE_LEFT_CODE)
			{
				switch(_direction)
				{
					case NO_DIRECTION:
					case RIGHT_DIRECTION:
						_direction = LEFT_DIRECTION;
						break;
					case UP_DIRECTION:
						_direction = UP_LEFT_DIRECTION;
						break;
					case DOWN_DIRECTION:
						_direction = DOWN_LEFT_DIRECTION;
				}
			}
		}
		
		private function onPlayerMoveRight(param1:EventWithParams) : void
		{
			var _loc2_:int = param1.params.keyCode as int;
			if(InputManager.instance.isKeyboardMouseVersion || !InputManager.instance.isKeyboardMouseVersion && _loc2_ == InputManager.MOVE_RIGHT_CODE)
			{
				switch(_direction)
				{
					case NO_DIRECTION:
					case LEFT_DIRECTION:
						_direction = RIGHT_DIRECTION;
						break;
					case UP_DIRECTION:
						_direction = UP_RIGHT_DIRECTION;
						break;
					case DOWN_DIRECTION:
						_direction = DOWN_RIGHT_DIRECTION;
				}
			}
		}
		
		private function onPlayerMoveUp(param1:EventWithParams) : void
		{
			var _loc2_:int = param1.params.keyCode as int;
			if(InputManager.instance.isKeyboardMouseVersion || !InputManager.instance.isKeyboardMouseVersion && _loc2_ == InputManager.MOVE_UP_CODE)
			{
				switch(_direction)
				{
					case NO_DIRECTION:
					case DOWN_DIRECTION:
						_direction = UP_DIRECTION;
						break;
					case LEFT_DIRECTION:
						_direction = UP_LEFT_DIRECTION;
						break;
					case RIGHT_DIRECTION:
						_direction = UP_RIGHT_DIRECTION;
				}
			}
		}
		
		private function onPlayerMoveDown(param1:EventWithParams) : void
		{
			var _loc2_:int = param1.params.keyCode as int;
			if(InputManager.instance.isKeyboardMouseVersion || !InputManager.instance.isKeyboardMouseVersion && _loc2_ == InputManager.MOVE_DOWN_CODE)
			{
				switch(_direction)
				{
					case NO_DIRECTION:
					case UP_DIRECTION:
						_direction = DOWN_DIRECTION;
						break;
					case LEFT_DIRECTION:
						_direction = DOWN_LEFT_DIRECTION;
						break;
					case RIGHT_DIRECTION:
						_direction = DOWN_RIGHT_DIRECTION;
				}
			}
		}
		
		private function onLeftStickMove(param1:EventWithParams) : void
		{
			var _loc2_:Number = param1.params.deltaX;
			var _loc3_:Number = param1.params.deltaY;
			var _loc4_:int = MathUtil.getDirectionFromStick(_loc2_,-_loc3_);
			if(_loc4_ == NO_DIRECTION)
			{
				stopMoving();
			}
			else
			{
				_direction = _loc4_;
			}
		}
		
		private function onRightStickMove(param1:EventWithParams) : void
		{
			var _loc2_:Number = param1.params.deltaX;
			var _loc3_:Number = param1.params.deltaY;
			this._rightStickPosition = new Point(_loc2_ * 1000,_loc3_ * 1000);
			if(_loc2_ == 0 && _loc3_ == 0)
			{
				this.onFireTurnedOff();
			}
			else
			{
				this.onFireTurnedOn();
			}
		}
		
		private function onFireTurnedOn(param1:Event = null) : void
		{
			this._fireRequested = true;
		}
		
		private function onFireTurnedOff(param1:Event = null) : void
		{
			this._fireRequested = false;
			eaze(this).killTweens();
			this._canFire = true;
		}
		
		override public function update(param1:Point) : void
		{
			var _loc2_:Point = !!InputManager.instance.isKeyboardMouseVersion?position:new Point(0,0);
			var _loc3_:Point = !!InputManager.instance.isKeyboardMouseVersion?param1:this._rightStickPosition;
			if(_direction != NO_DIRECTION)
			{
				this.move(_direction);
			}
			this.setGunDirection(MathUtil.getVerticalDegAngle(_loc2_,_loc3_));
			this.updateBulletsPosition();
			if(this._fireRequested && this._canFire)
			{
				this.fire(_loc3_);
			}
		}
		
		private function updateBulletsPosition() : void
		{
			var _loc1_:uint = 0;
			while(_loc1_ < this._bullets.length)
			{
				this._bullets[_loc1_].update();
				_loc1_++;
			}
		}
		
		override protected function setState(param1:uint) : void
		{
			var _loc2_:MovieClip = null;
			if(_state != param1)
			{
				_loc2_ = _mainObject.heroViewMc;
				switch(param1)
				{
					case STANDING_STATE:
						_loc2_.gotoAndStop("stand");
						break;
					case MOVING_UP_STATE:
						_loc2_.gotoAndPlay("moveUp");
						break;
					case MOVING_UP_LEFT_STATE:
						_loc2_.gotoAndPlay("moveUpLeft");
						break;
					case MOVING_LEFT_STATE:
						_loc2_.gotoAndPlay("moveLeft");
						break;
					case MOVING_DOWN_LEFT_STATE:
						_loc2_.gotoAndPlay("moveDownLeft");
						break;
					case MOVING_DOWN_STATE:
						_loc2_.gotoAndPlay("moveDown");
						break;
					case STOP_STATE:
						switch(_direction)
						{
							case NO_DIRECTION:
								_loc2_.gotoAndStop("stand");
								break;
							case UP_DIRECTION:
								_loc2_.gotoAndStop("upStand");
								break;
							case UP_LEFT_DIRECTION:
							case UP_RIGHT_DIRECTION:
								_loc2_.gotoAndStop("upLeftStand");
								break;
							case LEFT_DIRECTION:
							case RIGHT_DIRECTION:
								_loc2_.gotoAndStop("leftStand");
								break;
							case DOWN_LEFT_DIRECTION:
							case DOWN_RIGHT_DIRECTION:
								_loc2_.gotoAndStop("downLeftStand");
								break;
							case DOWN_DIRECTION:
								_loc2_.gotoAndStop("downStand");
						}
						break;
					case DEATH_STATE:
						eaze(_mainObject).play("deathStart>deathEnd").onComplete(this.onHeroDead);
				}
			}
			super.setState(param1);
		}
		
		override protected function setDirection(param1:int) : void
		{
			super.setDirection(param1);
			var _loc2_:Boolean = param1 == RIGHT_DIRECTION || param1 == UP_RIGHT_DIRECTION || param1 == DOWN_RIGHT_DIRECTION;
			_mainObject.scaleX = !!_loc2_?Number(-1):Number(1);
		}
		
		public function move(param1:int) : void
		{
			var _loc2_:Number = NaN;
			var _loc3_:Number = NaN;
			this.setDirection(param1);
			switch(_direction)
			{
				case UP_DIRECTION:
					this.setState(MOVING_UP_STATE);
					_loc2_ = _mainObject.x;
					_loc3_ = _mainObject.y - _speed;
					break;
				case UP_LEFT_DIRECTION:
				case UP_RIGHT_DIRECTION:
					this.setState(MOVING_UP_LEFT_STATE);
					_loc2_ = _direction == UP_LEFT_DIRECTION?Number(_mainObject.x - _speed * Math.SQRT1_2):Number(_mainObject.x + _speed * Math.SQRT1_2);
					_loc3_ = _mainObject.y - _speed * Math.SQRT1_2;
					break;
				case LEFT_DIRECTION:
				case RIGHT_DIRECTION:
					this.setState(MOVING_LEFT_STATE);
					_loc2_ = _direction == LEFT_DIRECTION?Number(_mainObject.x - _speed):Number(_mainObject.x + _speed);
					_loc3_ = _mainObject.y;
					break;
				case DOWN_LEFT_DIRECTION:
				case DOWN_RIGHT_DIRECTION:
					this.setState(MOVING_DOWN_LEFT_STATE);
					_loc2_ = _direction == DOWN_LEFT_DIRECTION?Number(_mainObject.x - _speed * Math.SQRT1_2):Number(_mainObject.x + _speed * Math.SQRT1_2);
					_loc3_ = _mainObject.y + _speed * Math.SQRT1_2;
					break;
				case DOWN_DIRECTION:
					this.setState(MOVING_DOWN_STATE);
					_loc2_ = _mainObject.x;
					_loc3_ = _mainObject.y + _speed;
			}
			setPosition(_loc2_,_loc3_);
		}
		
		public function setGunDirection(param1:Number) : void
		{
			this._gun.rotation = param1 * _mainObject.scaleX;
		}
		
		public function fire(param1:Point) : void
		{
			this._canFire = false;
			SoundManager.instance.playSound(SoundList.HERO_BULLET_FIRE_SOUND);
			eaze(this).delay(GameConstants.delayBetweenHeroBullets).onComplete(this.onReadyToFire);
			var _loc2_:bhvr.views.HeroBullet = this.addBullet(param1);
			this._bullets.push(_loc2_);
		}
		
		private function addBullet(param1:Point) : bhvr.views.HeroBullet
		{
			var _loc2_:Point = !!InputManager.instance.isKeyboardMouseVersion?position:new Point(0,0);
			var _loc3_:bhvr.views.HeroBullet = new bhvr.views.HeroBullet(_mainObject);
			_loc3_.addEventListener(GameEvents.HERO_MISSILE_EXPLODED,this.onMissileExploded,false,0,true);
			this._bulletsContainer.addChild(_loc3_);
			_loc3_.x = FlashUtil.localToGlobalPosition(this._gun.canonHeadMc).x;
			_loc3_.y = FlashUtil.localToGlobalPosition(this._gun.canonHeadMc).y;
			_loc3_.rotation = MathUtil.getVerticalDegAngle(_loc2_,param1);
			var _loc4_:Number = param1.x - _loc2_.x > 0?Number(1):Number(-1);
			var _loc5_:Number = _loc4_ * GameConstants.heroBulletSpeed * Math.sin(MathUtil.getVerticalRadAngle(_loc2_,param1));
			var _loc6_:Number = GameConstants.heroBulletSpeed * Math.cos(MathUtil.getVerticalRadAngle(_loc2_,param1));
			_loc3_.setDirectionValues(_loc5_,_loc6_);
			return _loc3_;
		}
		
		private function removeBullet(param1:bhvr.views.HeroBullet) : void
		{
			var _loc2_:int = 0;
			if(param1 != null)
			{
				param1.removeEventListener(GameEvents.HERO_MISSILE_EXPLODED,this.onMissileExploded);
				_loc2_ = this._bulletsContainer.getChildIndex(param1);
				this._bulletsContainer.removeChild(param1);
				param1.dispose();
				this._bullets.splice(_loc2_,1);
			}
		}
		
		private function removeBullets() : void
		{
			if(this._bullets != null)
			{
				while(this._bullets.length > 0)
				{
					this.removeBullet(this._bullets[0]);
				}
			}
		}
		
		private function onMissileExploded(param1:EventWithParams) : void
		{
			var _loc2_:bhvr.views.HeroBullet = param1.params.target as bhvr.views.HeroBullet;
			this.removeBullet(_loc2_);
		}
		
		private function onReadyToFire() : void
		{
			this._canFire = true;
		}
		
		public function damage() : void
		{
			if(!this.invincible)
			{
				this._invincible = true;
				GamePersistantData.removeLife();
				if(GamePersistantData.lifeNum > 0)
				{
					SoundManager.instance.playSound(SoundList.HERO_DAMAGE_SOUND);
					dispatchEvent(new EventWithParams(GameEvents.HERO_DAMAGED));
					_mainObject.gotoAndPlay("damage");
					eaze(_mainObject).delay(GameConstants.heroDamageAnimDuration).onComplete(this.onHeroDamaged);
					GamePersistantData.gameScore.checkLifeBonus();
				}
				else
				{
					SoundManager.instance.playSound(SoundList.HERO_DEATH_SOUND);
					_collider = null;
					dispatchEvent(new EventWithParams(GameEvents.HERO_DEAD));
					this.setState(DEATH_STATE);
				}
			}
		}
		
		private function onHeroDamaged() : void
		{
			dispatchEvent(new EventWithParams(GameEvents.HERO_DAMAGED_END));
			this._invincible = false;
			_mainObject.gotoAndPlay("normal");
		}
		
		private function onHeroDead() : void
		{
			dispatchEvent(new EventWithParams(GameEvents.HERO_DEAD_END));
		}
		
		override public function pause() : void
		{
			super.pause();
			this.unregisterEvents();
			if(this._invincible)
			{
				_mainObject.stop();
			}
			else
			{
				this.stop();
			}
		}
		
		override public function resume() : void
		{
			super.resume();
			this.registerEvents();
			if(this._invincible)
			{
				_mainObject.play();
			}
			else
			{
				this.start();
			}
		}
		
		override public function dispose() : void
		{
			this.unregisterEvents();
			eaze(_mainObject).killTweens();
			this.removeBullets();
			this._bullets = null;
			_container.removeChild(this._bulletsContainer);
			this._bulletsContainer = null;
			super.dispose();
		}
	}
}
