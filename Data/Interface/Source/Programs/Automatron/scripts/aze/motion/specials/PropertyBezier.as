package aze.motion.specials
{
	import aze.motion.EazeTween;
	
	public class PropertyBezier extends EazeSpecial
	{
		 
		
		private var fvalue:Array;
		
		private var through:Boolean;
		
		private var length:int;
		
		private var segments:Array;
		
		public function PropertyBezier(param1:Object, param2:*, param3:*, param4:EazeSpecial)
		{
			super(param1,param2,param3,param4);
			this.fvalue = param3;
			if(this.fvalue[0] is Array)
			{
				this.through = true;
				this.fvalue = this.fvalue[0];
			}
		}
		
		public static function register() : void
		{
			EazeTween.specialProperties["__bezier"] = PropertyBezier;
		}
		
		override public function init(param1:Boolean) : void
		{
			var _loc3_:Number = NaN;
			var _loc4_:Number = NaN;
			var _loc2_:Number = target[property];
			this.fvalue = [_loc2_].concat(this.fvalue);
			if(param1)
			{
				this.fvalue.reverse();
			}
			var _loc5_:Number = this.fvalue[0];
			var _loc6_:int = this.fvalue.length - 1;
			var _loc7_:int = 1;
			var _loc8_:Number = NaN;
			this.segments = [];
			this.length = 0;
			while(_loc7_ < _loc6_)
			{
				_loc3_ = _loc5_;
				_loc4_ = this.fvalue[_loc7_];
				_loc5_ = this.fvalue[++_loc7_];
				if(this.through)
				{
					if(!this.length)
					{
						_loc8_ = (_loc5_ - _loc3_) / 4;
						this.segments[this.length++] = new BezierSegment(_loc3_,_loc4_ - _loc8_,_loc4_);
					}
					this.segments[this.length++] = new BezierSegment(_loc4_,_loc4_ + _loc8_,_loc5_);
					_loc8_ = _loc5_ - (_loc4_ + _loc8_);
				}
				else
				{
					if(_loc7_ != _loc6_)
					{
						_loc5_ = (_loc4_ + _loc5_) / 2;
					}
					this.segments[this.length++] = new BezierSegment(_loc3_,_loc4_,_loc5_);
				}
			}
			this.fvalue = null;
			if(param1)
			{
				this.update(0,false);
			}
		}
		
		override public function update(param1:Number, param2:Boolean) : void
		{
			var _loc3_:BezierSegment = null;
			var _loc5_:* = 0;
			var _loc4_:int = this.length - 1;
			if(param2)
			{
				_loc3_ = this.segments[_loc4_];
				target[property] = _loc3_.p0 + _loc3_.d2;
			}
			else if(this.length == 1)
			{
				_loc3_ = this.segments[0];
				target[property] = _loc3_.calculate(param1);
			}
			else
			{
				_loc5_ = param1 * this.length >> 0;
				if(_loc5_ < 0)
				{
					_loc5_ = 0;
				}
				else if(_loc5_ > _loc4_)
				{
					_loc5_ = int(_loc4_);
				}
				_loc3_ = this.segments[_loc5_];
				param1 = this.length * (param1 - _loc5_ / this.length);
				target[property] = _loc3_.calculate(param1);
			}
		}
		
		override public function dispose() : void
		{
			this.fvalue = null;
			this.segments = null;
			super.dispose();
		}
	}
}

class BezierSegment
{
	 
	
	public var p0:Number;
	
	public var d1:Number;
	
	public var d2:Number;
	
	function BezierSegment(param1:Number, param2:Number, param3:Number)
	{
		super();
		this.p0 = param1;
		this.d1 = param2 - param1;
		this.d2 = param3 - param1;
	}
	
	public function calculate(param1:Number) : Number
	{
		return this.p0 + param1 * (2 * (1 - param1) * this.d1 + param1 * this.d2);
	}
}
