package bhvr.views
{
	import flash.display.MovieClip;
	import bhvr.constants.GameConstants;
	import bhvr.events.EventWithParams;
	import bhvr.events.GameEvents;
	import bhvr.data.GamePersistantData;
	import bhvr.utils.MathUtil;
	import bhvr.data.LevelUpVariables;
	
	public class RollingBomb extends Bomb
	{
		
		public static const LEFT_DIRECTION:uint = 0;
		
		public static const RIGHT_DIRECTION:uint = 1;
		 
		
		private var _currentDirection:uint = 1;
		
		private const FALL_SPEED_X:Number = 20;
		
		private var _currentGirder:bhvr.views.Girder = null;
		
		private var _currentLadder:bhvr.views.Ladder = null;
		
		private var _isFalling:Boolean = false;
		
		private var _isOnLadder:Boolean = false;
		
		private var _laddersIgnored:Vector.<bhvr.views.Ladder>;
		
		private var _jumpOverCollider:MovieClip;
		
		private var _hasJumper:Boolean;
		
		public function RollingBomb(assets:MovieClip, speed:Number)
		{
			super(assets,Bomb.ROLLING_TYPE);
			_speed = speed;
			this._laddersIgnored = new Vector.<Ladder>();
			_collider = _assets.bombViewMc.colliderMc;
			this._jumpOverCollider = _assets.bombViewMc.jumpOverColliderMc;
			this._hasJumper = false;
		}
		
		public function get jumpOverCollider() : MovieClip
		{
			return this._jumpOverCollider;
		}
		
		private function get isOutOfScreen() : Boolean
		{
			return x + _assets.width / 2 < 0 || x - _assets.width / 2 > GameConstants.STAGE_WIDTH;
		}
		
		public function get hasJumper() : Boolean
		{
			return this._hasJumper;
		}
		
		public function set hasJumper(value:Boolean) : void
		{
			this._hasJumper = value;
		}
		
		private function get isRolling() : Boolean
		{
			return _assets.bombViewMc.currentLabel != "idle";
		}
		
		public function setDirection(direction:uint) : void
		{
			this._currentDirection = direction;
		}
		
		private function roll(direction:uint) : Boolean
		{
			this._currentDirection = direction;
			if(this._currentDirection == LEFT_DIRECTION)
			{
				x = x - _speed;
			}
			else
			{
				x = x + _speed;
			}
			if(this.isOutOfScreen)
			{
				dispatchEvent(new EventWithParams(GameEvents.ROLLING_BOMB_OUT_OF_SCREEN,{"target":this}));
				return true;
			}
			this._isFalling = false;
			return false;
		}
		
		public function stop() : void
		{
			_assets.bombViewMc.gotoAndPlay("idle");
		}
		
		private function fall(fromGirder:Boolean = false) : void
		{
			if(!this._isFalling)
			{
				this._currentDirection = this._currentDirection == RIGHT_DIRECTION?uint(LEFT_DIRECTION):uint(RIGHT_DIRECTION);
				_assets.scaleX = -_assets.scaleX;
				if(!fromGirder)
				{
					if(this._currentDirection == LEFT_DIRECTION)
					{
						x = x + this.FALL_SPEED_X;
					}
					else
					{
						x = x - this.FALL_SPEED_X;
					}
				}
				else
				{
					x = this._currentLadder.snapPosition;
				}
			}
			y = y + _speed;
			this._isFalling = true;
		}
		
		public function checkCollisionWithGirder(girders:Vector.<bhvr.views.Girder>) : void
		{
			var girder:bhvr.views.Girder = null;
			var i:uint = 0;
			if(!this._isOnLadder)
			{
				if(this._currentGirder != null)
				{
					if(this._currentGirder.collider.hitTestPoint(colliderPoint.x,colliderPoint.y,true))
					{
						this.handleRolling();
						return;
					}
					this._currentGirder = null;
				}
				for(i = 0; i < girders.length; i++)
				{
					girder = girders[i];
					if(girder.collider.hitTestPoint(colliderPoint.x,colliderPoint.y,true))
					{
						this._currentGirder = girder;
						if(GamePersistantData.stage == GamePersistantData.STAGE_1)
						{
							_assets.bombViewMc.gotoAndPlay("rollStart");
						}
						this.handleRolling();
						return;
					}
				}
				this.fall();
			}
		}
		
		private function handleRolling() : void
		{
			var direction:uint = 0;
			if(!this.roll(this._currentDirection))
			{
				y = this._currentGirder.getYFromX(x);
				if(this._currentGirder is ConveyorBelt)
				{
					direction = ConveyorBelt(this._currentGirder).direction == ConveyorBelt.DIRECTION_LEFT?uint(LEFT_DIRECTION):uint(RIGHT_DIRECTION);
					this._currentDirection = direction;
				}
			}
		}
		
		public function checkCollisionWithLadder(ladders:Vector.<bhvr.views.Ladder>) : void
		{
			var ladder:bhvr.views.Ladder = null;
			if(this._currentLadder != null)
			{
				if(y >= this._currentLadder.bottomPosition)
				{
					this._currentLadder = null;
					this._isOnLadder = false;
				}
				else
				{
					this.fall(true);
				}
				return;
			}
			for(var i:uint = 0; i < ladders.length; i++)
			{
				ladder = ladders[i];
				if(this.isLadderIgnored(ladder))
				{
					return;
				}
				if(ladder.collider.hitTestPoint(colliderPoint.x,colliderPoint.y,true))
				{
					if(this.isRollingDownLadder(ladder))
					{
						this._currentLadder = ladder;
						this._isOnLadder = true;
						this.fall(true);
						return;
					}
					this._laddersIgnored.push(ladder);
				}
			}
		}
		
		private function isRollingDownLadder(ladder:bhvr.views.Ladder) : Boolean
		{
			var randomNum:int = 0;
			if(this.isOnTopOfLadder(ladder))
			{
				randomNum = MathUtil.random(0,100);
				if(randomNum <= LevelUpVariables.getStage1RollingBombLadderChance())
				{
					return true;
				}
			}
			return false;
		}
		
		private function isLadderIgnored(ladder:bhvr.views.Ladder) : Boolean
		{
			for(var i:uint = 0; i < this._laddersIgnored.length; i++)
			{
				if(ladder == this._laddersIgnored[i])
				{
					return true;
				}
			}
			return false;
		}
		
		private function isOnTopOfLadder(ladder:bhvr.views.Ladder) : Boolean
		{
			return Math.abs(y - ladder.topPosition) < Math.abs(y - ladder.bottomPosition);
		}
		
		override public function explode() : void
		{
			super.explode();
			this._jumpOverCollider = null;
			this._hasJumper = false;
		}
		
		override public function dispose() : void
		{
			this._currentGirder = null;
			this._currentLadder = null;
			this._laddersIgnored = null;
			super.dispose();
		}
		
		override public function pause() : void
		{
			super.pause();
			if(this.isRolling)
			{
				_assets.bombViewMc.stop();
			}
		}
		
		override public function resume() : void
		{
			super.resume();
			if(this.isRolling)
			{
				_assets.bombViewMc.play();
			}
		}
	}
}
