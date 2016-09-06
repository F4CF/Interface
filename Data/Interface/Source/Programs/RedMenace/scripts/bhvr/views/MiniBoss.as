package bhvr.views
{
	import flash.display.MovieClip;
	import flash.geom.Point;
	import bhvr.utils.FlashUtil;
	import bhvr.utils.MathUtil;
	import bhvr.constants.GameConstants;
	import aze.motion.eaze;
	import bhvr.events.EventWithParams;
	import bhvr.events.GameEvents;
	
	public class MiniBoss extends Character
	{
		 
		
		private const NO_ACTION:uint = 0;
		
		private const RUN_LEFT_ACTION:uint = 1;
		
		private const RUN_RIGHT_ACTION:uint = 2;
		
		private const CLIMB_UP_ACTION:uint = 3;
		
		private const CLIMB_DOWN_ACTION:uint = 4;
		
		private const GIRDER_TOP_DELTA:Number = 2;
		
		private const GIRDER_EXTREMITY_DELTA:Number = 5;
		
		private const MIN_DIST_RUN_TO_CHANGE_DIRECTION:Number = 20;
		
		private const MIN_DIST_CLIMB_TO_CHANGE_DIRECTION:Number = 20;
		
		private const MAX_CLIMB_ACTIONS:uint = 2;
		
		private var _climbActionsCount:uint;
		
		private var _possibleActions:Vector.<uint>;
		
		private var _changeDirectionTimer:MovieClip;
		
		private var _canRunLeft:Boolean;
		
		private var _canRunRight:Boolean;
		
		private var _currentLadder:bhvr.views.Ladder;
		
		private var _currentGirder:bhvr.views.Girder;
		
		public function MiniBoss(assets:MovieClip)
		{
			super(assets);
			this._changeDirectionTimer = new MovieClip();
		}
		
		public function get assets() : MovieClip
		{
			return _assets;
		}
		
		override public function get canClimb() : Boolean
		{
			return _canClimbUp && _canClimbDown && this._climbActionsCount < this.MAX_CLIMB_ACTIONS;
		}
		
		override public function get canClimbUp() : Boolean
		{
			return _canClimbUp && this._climbActionsCount < this.MAX_CLIMB_ACTIONS;
		}
		
		override public function get canClimbDown() : Boolean
		{
			return _canClimbDown && this._climbActionsCount < this.MAX_CLIMB_ACTIONS;
		}
		
		override public function get canRun() : Boolean
		{
			return this._canRunLeft && this._canRunRight;
		}
		
		override public function set canRun(value:Boolean) : void
		{
			this._canRunLeft = value;
			this._canRunRight = value;
		}
		
		public function get canRunLeft() : Boolean
		{
			return this._canRunLeft;
		}
		
		public function set canRunLeft(value:Boolean) : void
		{
			this._canRunLeft = value;
		}
		
		public function get canRunRight() : Boolean
		{
			return this._canRunRight;
		}
		
		public function set canRunRight(value:Boolean) : void
		{
			this._canRunRight = value;
		}
		
		public function get isOnLadder() : Boolean
		{
			return _direction == DOWN_DIRECTION || _direction == UP_DIRECTION;
		}
		
		public function get colliderPoint() : Point
		{
			return FlashUtil.localToGlobalPosition(_assets.colliderPointMc);
		}
		
		public function get isUsingLadder() : Boolean
		{
			var randomPercent:int = MathUtil.random(0,100);
			return randomPercent <= GameConstants.miniBossUseLadderChance * 100;
		}
		
		private function get _isAnimated() : Boolean
		{
			return _state == STANDING_STATE || _state == RUNNING_STATE || _state == CLIMBING_STATE;
		}
		
		override public function reset() : void
		{
			super.reset();
			_collider = _assets;
			this.canRun = true;
			_canJump = false;
			canClimb = false;
			this.setState(STANDING_STATE);
			this.setDirection(NO_DIRECTION);
			this._climbActionsCount = 0;
		}
		
		override public function start() : void
		{
			this.reset();
			this.startChangeDirectionTimer();
			this.changeDirection();
		}
		
		override public function stop() : void
		{
			eaze(this._changeDirectionTimer).killTweens();
			_assets.stop();
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
					this.setState(STANDING_STATE);
			}
		}
		
		override protected function setDirection(dir:int) : void
		{
			if(dir == UP_DIRECTION || dir == DOWN_DIRECTION)
			{
				this._climbActionsCount++;
			}
			else
			{
				this._climbActionsCount = 0;
			}
			_direction = dir;
		}
		
		override protected function setState(state:uint) : void
		{
			if(_state != state)
			{
				switch(state)
				{
					case STANDING_STATE:
					case RUNNING_STATE:
						_assets.gotoAndPlay("idle");
						break;
					case CLIMBING_STATE:
						_assets.gotoAndPlay("climb");
						break;
					case DEATH_STATE:
						eaze(_assets).play("deathStart>deathEnd").onComplete(this.onMiniBossDead);
				}
				_state = state;
			}
		}
		
		private function startChangeDirectionTimer() : void
		{
			eaze(this._changeDirectionTimer).delay(GameConstants.miniBossNewDecisionInterval).onComplete(this.changeDirection,true);
		}
		
		private function changeDirection(basedOnTimer:Boolean = false) : void
		{
			var randomAction:int = 0;
			var randomPercent:int = MathUtil.random(0,100);
			if(!basedOnTimer || randomPercent <= GameConstants.miniBossNewDecisionChance * 100)
			{
				this._possibleActions = new Vector.<uint>();
				if(this.canClimb)
				{
					if(this.worthClimb(UP_DIRECTION))
					{
						this._possibleActions.push(this.CLIMB_UP_ACTION);
					}
					if(this.worthClimb(DOWN_DIRECTION))
					{
						this._possibleActions.push(this.CLIMB_DOWN_ACTION);
					}
				}
				else
				{
					if(this.canRunLeft && this.worthRun(LEFT_DIRECTION))
					{
						this._possibleActions.push(this.RUN_LEFT_ACTION);
					}
					if(this.canRunRight && this.worthRun(RIGHT_DIRECTION))
					{
						this._possibleActions.push(this.RUN_RIGHT_ACTION);
					}
					if(this.canClimbDown && this.worthClimb(DOWN_DIRECTION))
					{
						this._possibleActions.push(this.CLIMB_DOWN_ACTION);
					}
					else if(this.canClimbUp && this.worthClimb(UP_DIRECTION))
					{
						this._possibleActions.push(this.CLIMB_UP_ACTION);
					}
				}
				if(this._possibleActions.length > 0)
				{
					randomAction = MathUtil.random(0,this._possibleActions.length - 1);
					this.setDirection(this.getDirection(this._possibleActions[randomAction]));
				}
			}
			if(basedOnTimer)
			{
				this.startChangeDirectionTimer();
			}
		}
		
		private function useLadder() : void
		{
			if(this.canClimbDown)
			{
				this.setDirection(DOWN_DIRECTION);
			}
			else if(this.canClimbUp)
			{
				this.setDirection(UP_DIRECTION);
			}
		}
		
		private function getDirection(action:uint) : uint
		{
			var dir:uint = this.NO_ACTION;
			switch(action)
			{
				case this.RUN_LEFT_ACTION:
					dir = LEFT_DIRECTION;
					break;
				case this.RUN_RIGHT_ACTION:
					dir = RIGHT_DIRECTION;
					break;
				case this.CLIMB_DOWN_ACTION:
					dir = DOWN_DIRECTION;
					break;
				case this.CLIMB_UP_ACTION:
					dir = UP_DIRECTION;
			}
			return dir;
		}
		
		override public function run(dir:int) : void
		{
			if(this.canRunLeft && dir == LEFT_DIRECTION || this.canRunRight && dir == RIGHT_DIRECTION)
			{
				this.setState(RUNNING_STATE);
				this.setDirection(dir);
				if(dir == LEFT_DIRECTION)
				{
					setPositionX(_assets.x - GameConstants.miniBossRunSpeed);
				}
				else
				{
					setPositionX(_assets.x + GameConstants.miniBossRunSpeed);
				}
			}
		}
		
		override public function climb(dir:int) : void
		{
			if(_canClimbDown && dir == DOWN_DIRECTION || _canClimbUp && dir == UP_DIRECTION)
			{
				this.setState(CLIMBING_STATE);
				if(dir == UP_DIRECTION)
				{
					_assets.y = _assets.y - GameConstants.miniBossClimbSpeed;
				}
				else
				{
					_assets.y = _assets.y + GameConstants.miniBossClimbSpeed;
				}
			}
		}
		
		public function explode() : void
		{
			canClimb = false;
			this.canRun = false;
			_collider = null;
			eaze(this._changeDirectionTimer).killTweens();
			this.setState(DEATH_STATE);
		}
		
		protected function onMiniBossDead() : void
		{
			dispatchEvent(new EventWithParams(GameEvents.MINI_BOSS_DEAD,{"target":this}));
		}
		
		public function checkCollisionWithSupportingBlocks(blocks:Vector.<SupportingBlock>) : void
		{
			var block:SupportingBlock = null;
			var i:uint = 0;
			if(blocks != null && blocks.length > 0)
			{
				for(i = 0; i < blocks.length; i++)
				{
					block = blocks[i];
					if(block.collider == null && block.enemyCollider.hitTestPoint(this.colliderPoint.x,this.colliderPoint.y,true))
					{
						if(_direction == LEFT_DIRECTION)
						{
							this.canRunLeft = false;
							this.canRunRight = true;
							this.changeDirection();
						}
						else if(_direction == RIGHT_DIRECTION)
						{
							this.canRunRight = false;
							this.canRunLeft = true;
							this.changeDirection();
						}
					}
				}
			}
		}
		
		public function checkCollisionWithGirders(girders:Vector.<bhvr.views.Girder>) : void
		{
			var girder:bhvr.views.Girder = null;
			var i:uint = 0;
			if(this._currentGirder != null)
			{
				if(this._currentGirder.collider.hitTestPoint(this.colliderPoint.x,this.colliderPoint.y,true))
				{
					if(!this.isOnLadder)
					{
						this.handleRun();
					}
				}
				else
				{
					this._currentGirder = null;
				}
				return;
			}
			if(girders != null && girders.length > 0)
			{
				for(i = 0; i < girders.length; i++)
				{
					girder = girders[i];
					if(girder.collider.hitTestPoint(this.colliderPoint.x,this.colliderPoint.y,true))
					{
						this._currentGirder = girder;
						if(!this.isOnLadder)
						{
							this.handleRun();
						}
						return;
					}
				}
			}
		}
		
		private function handleRun() : void
		{
			if(position.x <= Math.max(this._currentGirder.leftExtremity,thickness / 2) + this.GIRDER_EXTREMITY_DELTA)
			{
				this.canRunLeft = false;
				this.canRunRight = true;
				this.changeDirection();
			}
			else if(position.x >= Math.min(this._currentGirder.rightExtremity,GameConstants.STAGE_WIDTH - thickness / 2) - this.GIRDER_EXTREMITY_DELTA)
			{
				this.canRunRight = false;
				this.canRunLeft = true;
				this.changeDirection();
			}
			else
			{
				this.canRunRight = true;
				this.canRunLeft = true;
				setPosition(position.x,this._currentGirder.getYFromX(position.x) + this.GIRDER_TOP_DELTA);
			}
		}
		
		public function checkCollisionWithLadders(ladders:Vector.<bhvr.views.Ladder>) : void
		{
			var ladder:bhvr.views.Ladder = null;
			if(this._currentLadder != null)
			{
				if(this._currentLadder.collider.hitTestPoint(this.colliderPoint.x,this.colliderPoint.y))
				{
					this.handleClimb();
				}
				else
				{
					canClimb = false;
					this.canRun = true;
					this._currentLadder = null;
				}
				return;
			}
			for(var i:uint = 0; i < ladders.length; i++)
			{
				ladder = ladders[i];
				if(ladder.collider.hitTestPoint(this.colliderPoint.x,this.colliderPoint.y,true))
				{
					this._currentLadder = ladder;
					this.handleClimb();
					if(this.isUsingLadder)
					{
						this.useLadder();
					}
				}
			}
		}
		
		private function handleClimb() : void
		{
			if(position.y <= this._currentLadder.topPosition)
			{
				canClimbUp = false;
				canClimbDown = true;
				this.canRun = true;
				if(this.isOnLadder)
				{
					this.changeDirection();
				}
			}
			else if(position.y >= this._currentLadder.bottomPosition)
			{
				canClimbDown = false;
				canClimbUp = true;
				this.canRun = true;
				if(this.isOnLadder)
				{
					this.changeDirection();
				}
			}
			else
			{
				canClimbDown = true;
				canClimbUp = true;
				if(this.isOnLadder)
				{
					this.canRun = false;
					setPositionX(this._currentLadder.snapPosition);
				}
			}
		}
		
		private function worthClimb(dir:uint) : Boolean
		{
			if(this._currentLadder == null)
			{
				return true;
			}
			if(dir == UP_DIRECTION)
			{
				if(position.y > this._currentLadder.topPosition + this.MIN_DIST_CLIMB_TO_CHANGE_DIRECTION)
				{
					return true;
				}
			}
			else if(dir == DOWN_DIRECTION)
			{
				if(position.y < this._currentLadder.bottomPosition - this.MIN_DIST_CLIMB_TO_CHANGE_DIRECTION)
				{
					return true;
				}
			}
			return false;
		}
		
		private function worthRun(dir:uint) : Boolean
		{
			if(this._currentGirder == null)
			{
				return true;
			}
			if(dir == LEFT_DIRECTION)
			{
				if(position.x > this._currentGirder.leftExtremity + this.MIN_DIST_RUN_TO_CHANGE_DIRECTION)
				{
					return true;
				}
			}
			else if(dir == RIGHT_DIRECTION)
			{
				if(position.x < this._currentGirder.rightExtremity - this.MIN_DIST_RUN_TO_CHANGE_DIRECTION)
				{
					return true;
				}
			}
			return false;
		}
		
		override public function dispose() : void
		{
			this.stop();
			this.reset();
		}
		
		override public function pause() : void
		{
			super.pause();
			if(this._isAnimated)
			{
				_assets.stop();
			}
		}
		
		override public function resume() : void
		{
			super.resume();
			if(this._isAnimated)
			{
				_assets.play();
			}
		}
	}
}
