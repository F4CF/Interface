package bhvr.utils
{
	import flash.geom.Point;
	
	public class MathUtil
	{
		
		private static const DIGIT_NUMBERS:uint = 3;
		
		private static const DIGIT_SEPARATOR:String = ",";
		
		public static const NO_DIRECTION:int = 0;
		
		public static const LEFT_DIRECTION:int = 1;
		
		public static const RIGHT_DIRECTION:int = 2;
		
		public static const UP_DIRECTION:int = 3;
		
		public static const DOWN_DIRECTION:int = 4;
		
		public static const UP_LEFT_DIRECTION:int = 5;
		
		public static const UP_RIGHT_DIRECTION:int = 6;
		
		public static const DOWN_LEFT_DIRECTION:int = 7;
		
		public static const DOWN_RIGHT_DIRECTION:int = 8;
		 
		
		public function MathUtil()
		{
			super();
		}
		
		public static function random(param1:int = 0, param2:int = 1) : int
		{
			return Math.floor(Math.random() * (1 + param2 - param1)) + param1;
		}
		
		public static function formatWithCommas(param1:Number, param2:String = ",") : String
		{
			var _loc5_:uint = 0;
			var _loc3_:Array = String(param1).split("").reverse();
			var _loc4_:Array = String(param1).split("").reverse();
			var _loc6_:uint = 0;
			var _loc7_:uint = 0;
			_loc5_ = 0;
			while(_loc5_ < _loc3_.length)
			{
				_loc6_++;
				if(_loc6_ >= DIGIT_NUMBERS)
				{
					_loc7_++;
					_loc6_ = 0;
					_loc4_.splice(_loc7_ * DIGIT_NUMBERS + (_loc7_ - 1),0,param2);
				}
				_loc5_++;
			}
			_loc4_.reverse();
			if(_loc4_[0] == param2)
			{
				_loc4_.shift();
			}
			_loc3_ = null;
			return _loc4_.join("");
		}
		
		public static function getDistance(param1:Point, param2:Point) : Number
		{
			var _loc3_:Number = param2.x - param1.x;
			var _loc4_:Number = param2.y - param1.y;
			return Math.sqrt(_loc3_ * _loc3_ + _loc4_ * _loc4_);
		}
		
		public static function getVerticalDegAngle(param1:Point, param2:Point) : Number
		{
			var _loc3_:Number = param2.x - param1.x;
			var _loc4_:Number = param2.y - param1.y;
			var _loc5_:Number = _loc3_ == 0?Number(Math.abs(_loc4_)):Number(Math.abs(_loc4_) / _loc3_);
			var _loc6_:Number = getVerticalRadAngle(param1,param2);
			var _loc7_:Number = _loc5_ > 0?Number(180 - _loc6_ * 180 / Math.PI):Number(180 + _loc6_ * 180 / Math.PI);
			return _loc7_;
		}
		
		public static function getVerticalRadAngle(param1:Point, param2:Point) : Number
		{
			var _loc3_:Number = param2.y - param1.y;
			var _loc4_:Number = Math.acos(_loc3_ / getDistance(param1,param2));
			return _loc4_;
		}
		
		public static function clamp(param1:Number, param2:Number, param3:Number) : Number
		{
			return Math.max(param2,Math.min(param1,param3));
		}
		
		public static function getDirectionFromStick(param1:Number, param2:Number) : int
		{
			var _loc4_:int = 0;
			var _loc3_:Number = MathUtil.getVerticalRadAngle(new Point(0,0),new Point(param1,param2));
			if(param1 == 0 && param2 == 0)
			{
				return NO_DIRECTION;
			}
			if(_loc3_ > 0 && _loc3_ <= Math.PI / 8)
			{
				_loc4_ = UP_DIRECTION;
			}
			else if(_loc3_ > Math.PI / 8 && _loc3_ <= 3 * Math.PI / 8)
			{
				_loc4_ = param1 > 0?int(UP_RIGHT_DIRECTION):int(UP_LEFT_DIRECTION);
			}
			else if(_loc3_ > 3 * Math.PI / 8 && _loc3_ <= 5 * Math.PI / 8)
			{
				_loc4_ = param1 > 0?int(RIGHT_DIRECTION):int(LEFT_DIRECTION);
			}
			else if(_loc3_ > 5 * Math.PI / 8 && _loc3_ <= 7 * Math.PI / 8)
			{
				_loc4_ = param1 > 0?int(DOWN_RIGHT_DIRECTION):int(DOWN_LEFT_DIRECTION);
			}
			else
			{
				_loc4_ = DOWN_DIRECTION;
			}
			return _loc4_;
		}
		
		public static function getRandomPointAroundPoint(param1:Point, param2:int, param3:int) : Point
		{
			var _loc4_:Number = MathUtil.random(param2,param3);
			var _loc5_:Number = Math.random() * 2 * Math.PI;
			return new Point(param1.x + _loc4_ * Math.cos(_loc5_),param1.y + _loc4_ * Math.sin(_loc5_));
		}
	}
}
