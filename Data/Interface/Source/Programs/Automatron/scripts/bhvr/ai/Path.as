package bhvr.ai
{
	import flash.events.EventDispatcher;
	import bhvr.views.Character;
	import flash.geom.Point;
	import bhvr.utils.MathUtil;
	import bhvr.constants.GameConstants;
	import bhvr.events.EventWithParams;
	import aze.motion.eaze;
	import bhvr.utils.DataPool;
	
	public class Path extends EventDispatcher
	{
		
		public static const NO_PATH:uint = 0;
		
		public static const FOLLOWER_PATH:uint = 1;
		
		public static const RANDOM_ALL_DIR_PATH:uint = 2;
		
		public static const RANDOM_ALL_DIR_WITH_AGGRO_PATH:uint = 3;
		
		public static const RANDOM_4_DIR_PATH:uint = 4;
		
		public static const RANDOM_8_DIR_PATH:uint = 5;
		
		public static const NO_WALL:uint = 0;
		
		public static const TOP_WALL:uint = 1;
		
		public static const BOTTOM_WALL:uint = 2;
		
		public static const LEFT_WALL:uint = 3;
		
		public static const RIGHT_WALL:uint = 4;
		
		public static const STOP_MOVING:String = "StopMoving";
		
		public static const MOVING_AFTER_STOP:String = "MovingAfterStop";
		
		public static const CHANGING_DIRECTION:String = "ChangingDirection";
		 
		
		private var _type:uint;
		
		private var _source:Character;
		
		private var _withStops:Boolean;
		
		private var _changeDirMinDelay:Number;
		
		private var _changeDirMaxDelay:Number;
		
		private var _changeDirAfterStopDelay:Number;
		
		private var _offsetTarget:Point;
		
		private var _deltaPos:Point;
		
		private var _direction:uint;
		
		private var _minX:Number;
		
		private var _maxX:Number;
		
		private var _minY:Number;
		
		private var _maxY:Number;
		
		private const STOP_PROBABILITIES:Number = 30;
		
		public function Path(param1:Character, param2:uint, param3:Boolean = false, param4:Number = 3, param5:Number = 5, param6:Number = 0.5)
		{
			super();
			this._source = param1;
			this._type = param2;
			this._withStops = param3;
			this._changeDirMinDelay = param4;
			this._changeDirMaxDelay = param5;
			this._changeDirAfterStopDelay = param6;
			var _loc7_:Point = this._source.dimension;
			this._minX = GameConstants.gameZoneArea.x + _loc7_.x / 2;
			this._maxX = GameConstants.gameZoneArea.x + GameConstants.gameZoneArea.width - _loc7_.x / 2;
			this._minY = GameConstants.gameZoneArea.y + _loc7_.y / 2;
			this._maxY = GameConstants.gameZoneArea.y + GameConstants.gameZoneArea.height - _loc7_.y / 2;
		}
		
		public function get type() : uint
		{
			return this._type;
		}
		
		public function start() : void
		{
			this._deltaPos = new Point(0,0);
			this._direction = Character.NO_DIRECTION;
			switch(this._type)
			{
				case FOLLOWER_PATH:
					this._offsetTarget = MathUtil.getRandomPointAroundPoint(new Point(0,0),0,GameConstants.enemyToHeroMaxOffset);
					dispatchEvent(new EventWithParams(MOVING_AFTER_STOP));
					break;
				case RANDOM_4_DIR_PATH:
					this.chooseDirection(4,true);
					break;
				case RANDOM_8_DIR_PATH:
					this.chooseDirection(8,true);
					break;
				case RANDOM_ALL_DIR_PATH:
					this.choosePosition(true);
					break;
				case RANDOM_ALL_DIR_WITH_AGGRO_PATH:
					this._offsetTarget = MathUtil.getRandomPointAroundPoint(new Point(0,0),0,GameConstants.enemyToHeroMaxOffset);
					this.choosePosition(true);
			}
		}
		
		public function stop() : void
		{
			switch(this._type)
			{
				case RANDOM_4_DIR_PATH:
				case RANDOM_8_DIR_PATH:
				case RANDOM_ALL_DIR_PATH:
				case RANDOM_ALL_DIR_WITH_AGGRO_PATH:
					eaze(this).killTweens();
			}
		}
		
		public function getNextPosition(param1:Point = null, param2:Number = 0.0) : Point
		{
			switch(this._type)
			{
				case FOLLOWER_PATH:
					return this.follow(param1);
				case RANDOM_4_DIR_PATH:
					return this.moveRandomDirection(4);
				case RANDOM_8_DIR_PATH:
					return this.moveRandomDirection(8);
				case RANDOM_ALL_DIR_PATH:
					return this.moveRandomPosition();
				case RANDOM_ALL_DIR_WITH_AGGRO_PATH:
					return param1 == null || MathUtil.getDistance(this._source.position,param1) > param2?this.moveRandomPosition():this.follow(param1);
				case NO_PATH:
				default:
					return this._source.position;
			}
		}
		
		private function follow(param1:Point) : Point
		{
			var _loc2_:Point = this._offsetTarget;
			if(Math.abs(param1.x - this._source.position.x) <= Math.abs(this._offsetTarget.x) || Math.abs(param1.y - this._source.position.y) <= Math.abs(this._offsetTarget.y))
			{
				_loc2_ = new Point(0,0);
			}
			var _loc3_:Point = param1.add(_loc2_);
			this._deltaPos = this.getPositionBetweenSourceAndTarget(this._source,_loc3_);
			return this._source.position.add(this._deltaPos);
		}
		
		private function getPositionBetweenSourceAndTarget(param1:Character, param2:Point) : Point
		{
			var _loc3_:Point = param2.subtract(param1.position);
			_loc3_.normalize(param1.speed);
			return _loc3_;
		}
		
		private function startDelayBeforeChangingDirection(param1:uint) : void
		{
			var _loc2_:Number = MathUtil.random(this._changeDirMinDelay,this._changeDirMaxDelay);
			eaze(this).delay(_loc2_).onComplete(this.chooseDirection,param1);
		}
		
		private function chooseDirection(param1:uint, param2:Boolean = false) : void
		{
			var _loc4_:uint = 0;
			var _loc5_:uint = 0;
			var _loc3_:Number = this._withStops && !param2?Number(MathUtil.random(0,100)):Number(100);
			if(_loc3_ < this.STOP_PROBABILITIES)
			{
				if(this._direction != Character.NO_DIRECTION)
				{
					dispatchEvent(new EventWithParams(STOP_MOVING));
				}
				this._direction = Character.NO_DIRECTION;
				eaze(this).delay(this._changeDirAfterStopDelay).onComplete(this.chooseDirection,param1);
			}
			else
			{
				if(this._direction == Character.NO_DIRECTION)
				{
					dispatchEvent(new EventWithParams(MOVING_AFTER_STOP));
				}
				_loc4_ = this._direction;
				_loc5_ = this.isStuckToWallSide();
				if(_loc5_ != NO_WALL)
				{
					this._direction = this.chooseDirectionAfterHittingWall(param1,_loc5_);
				}
				else
				{
					_loc3_ = MathUtil.random(0,100);
					this._direction = Math.min(param1,Math.floor(_loc3_ / (100 / param1)) + 1);
				}
				if(_loc4_ != this._direction)
				{
					dispatchEvent(new EventWithParams(CHANGING_DIRECTION,{
						"prevDirection":_loc4_,
						"nextDirection":this._direction
					}));
				}
				this.startDelayBeforeChangingDirection(param1);
			}
		}
		
		private function isStuckToWallSide() : uint
		{
			if(this._source.position.x - this._source.speed < this._minX)
			{
				return LEFT_WALL;
			}
			if(this._source.position.x + this._source.speed > this._maxX)
			{
				return RIGHT_WALL;
			}
			if(this._source.position.y - this._source.speed < this._minY)
			{
				return TOP_WALL;
			}
			if(this._source.position.y + this._source.speed > this._maxY)
			{
				return BOTTOM_WALL;
			}
			return NO_WALL;
		}
		
		private function chooseDirectionAfterHittingWall(param1:uint, param2:uint) : uint
		{
			var _loc3_:DataPool = new DataPool();
			var _loc4_:uint = param1 / 2 - 1;
			var _loc5_:uint = param1 / 2;
			var _loc6_:Number = 100 - GameConstants.unstickWallChances;
			switch(param2)
			{
				case LEFT_WALL:
					_loc3_.add(Character.RIGHT_DIRECTION,GameConstants.unstickWallChances / _loc4_);
					_loc3_.add(Character.UP_DIRECTION,_loc6_ / _loc5_);
					_loc3_.add(Character.DOWN_DIRECTION,_loc6_ / _loc5_);
					if(param1 == 8)
					{
						_loc3_.add(Character.UP_RIGHT_DIRECTION,GameConstants.unstickWallChances / _loc4_);
						_loc3_.add(Character.DOWN_RIGHT_DIRECTION,GameConstants.unstickWallChances / _loc4_);
						_loc3_.add(Character.UP_LEFT_DIRECTION,_loc6_ / _loc5_);
						_loc3_.add(Character.DOWN_LEFT_DIRECTION,_loc6_ / _loc5_);
					}
					break;
				case RIGHT_WALL:
					_loc3_.add(Character.LEFT_DIRECTION,GameConstants.unstickWallChances / _loc4_);
					_loc3_.add(Character.UP_DIRECTION,_loc6_ / _loc5_);
					_loc3_.add(Character.DOWN_DIRECTION,_loc6_ / _loc5_);
					if(param1 == 8)
					{
						_loc3_.add(Character.UP_LEFT_DIRECTION,GameConstants.unstickWallChances / _loc4_);
						_loc3_.add(Character.DOWN_LEFT_DIRECTION,GameConstants.unstickWallChances / _loc4_);
						_loc3_.add(Character.UP_RIGHT_DIRECTION,_loc6_ / _loc5_);
						_loc3_.add(Character.DOWN_RIGHT_DIRECTION,_loc6_ / _loc5_);
					}
					break;
				case TOP_WALL:
					_loc3_.add(Character.DOWN_DIRECTION,GameConstants.unstickWallChances / _loc4_);
					_loc3_.add(Character.LEFT_DIRECTION,_loc6_ / _loc5_);
					_loc3_.add(Character.RIGHT_DIRECTION,_loc6_ / _loc5_);
					if(param1 == 8)
					{
						_loc3_.add(Character.DOWN_RIGHT_DIRECTION,GameConstants.unstickWallChances / _loc4_);
						_loc3_.add(Character.DOWN_LEFT_DIRECTION,GameConstants.unstickWallChances / _loc4_);
						_loc3_.add(Character.UP_RIGHT_DIRECTION,_loc6_ / _loc5_);
						_loc3_.add(Character.UP_LEFT_DIRECTION,_loc6_ / _loc5_);
					}
					break;
				case BOTTOM_WALL:
					_loc3_.add(Character.UP_DIRECTION,GameConstants.unstickWallChances / _loc4_);
					_loc3_.add(Character.LEFT_DIRECTION,_loc6_ / _loc5_);
					_loc3_.add(Character.RIGHT_DIRECTION,_loc6_ / _loc5_);
					if(param1 == 8)
					{
						_loc3_.add(Character.UP_RIGHT_DIRECTION,GameConstants.unstickWallChances / _loc4_);
						_loc3_.add(Character.UP_LEFT_DIRECTION,GameConstants.unstickWallChances / _loc4_);
						_loc3_.add(Character.DOWN_RIGHT_DIRECTION,_loc6_ / _loc5_);
						_loc3_.add(Character.DOWN_LEFT_DIRECTION,_loc6_ / _loc5_);
					}
			}
			var _loc7_:uint = _loc3_.getRandomData();
			_loc3_.dispose();
			return _loc7_;
		}
		
		private function moveRandomDirection(param1:uint) : Point
		{
			var _loc2_:Point = null;
			var _loc3_:Point = null;
			var _loc4_:Number = NaN;
			var _loc5_:Number = NaN;
			if(this._direction != Character.NO_DIRECTION)
			{
				_loc2_ = Character.DIRECTION_VECTORS[this._direction];
				_loc2_.normalize(this._source.speed);
				_loc3_ = this._source.position.add(_loc2_);
				_loc4_ = _loc3_.x;
				_loc5_ = _loc3_.y;
				if(_loc4_ < this._minX || _loc4_ > this._maxX || _loc5_ < this._minY || _loc5_ > this._maxY)
				{
					this.chooseDirection(param1);
				}
				else
				{
					return _loc3_;
				}
			}
			return this._source.position;
		}
		
		private function startDelayBeforeChangingPosition() : void
		{
			var _loc1_:Number = MathUtil.random(this._changeDirMinDelay,this._changeDirMaxDelay);
			eaze(this).delay(_loc1_).onComplete(this.choosePosition);
		}
		
		private function choosePosition(param1:Boolean = false) : void
		{
			var _loc3_:Point = null;
			var _loc2_:Number = this._withStops && !param1?Number(MathUtil.random(0,100)):Number(100);
			if(_loc2_ < this.STOP_PROBABILITIES)
			{
				if(this._deltaPos.x != 0 || this._deltaPos.y != 0)
				{
					dispatchEvent(new EventWithParams(STOP_MOVING));
				}
				this._deltaPos = new Point(0,0);
				eaze(this).delay(this._changeDirAfterStopDelay).onComplete(this.choosePosition);
			}
			else
			{
				if(this._deltaPos.x == 0 && this._deltaPos.y == 0)
				{
					dispatchEvent(new EventWithParams(MOVING_AFTER_STOP));
				}
				_loc3_ = MathUtil.getRandomPointAroundPoint(this._source.position,1,1);
				this._deltaPos = this.getPositionBetweenSourceAndTarget(this._source,_loc3_);
				dispatchEvent(new EventWithParams(CHANGING_DIRECTION,{"deltaPos":this._deltaPos}));
				this.startDelayBeforeChangingPosition();
			}
		}
		
		private function moveRandomPosition() : Point
		{
			if(this._source.position.x + this._deltaPos.x < this._minX || this._source.position.x + this._deltaPos.x > this._maxX || this._source.position.y + this._deltaPos.y < this._minY || this._source.position.y + this._deltaPos.y > this._maxY)
			{
				this.choosePosition();
			}
			return this._source.position.add(this._deltaPos);
		}
	}
}
