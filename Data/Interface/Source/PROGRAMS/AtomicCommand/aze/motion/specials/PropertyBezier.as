package aze.motion.specials
{
	import aze.motion.EazeTween;
	
	public class PropertyBezier extends EazeSpecial
	{
		 
		
		private var fvalue:Array;
		
		private var through:Boolean;
		
		private var length:int;
		
		private var segments:Array;
		
		public function PropertyBezier(target:Object, property:*, value:*, next:EazeSpecial)
		{
			super(target,property,value,next);
			this.fvalue = value;
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
		
		override public function init(reverse:Boolean) : void
		{
			var p0:Number = NaN;
			var p1:Number = NaN;
			var current:Number = target[property];
			this.fvalue = [current].concat(this.fvalue);
			if(reverse)
			{
				this.fvalue.reverse();
			}
			var p2:Number = this.fvalue[0];
			var last:int = this.fvalue.length - 1;
			var index:int = 1;
			var auto:Number = NaN;
			this.segments = [];
			this.length = 0;
			while(index < last)
			{
				p0 = p2;
				p1 = this.fvalue[index];
				p2 = this.fvalue[++index];
				if(this.through)
				{
					if(!this.length)
					{
						auto = (p2 - p0) / 4;
						this.segments[this.length++] = new BezierSegment(p0,p1 - auto,p1);
					}
					this.segments[this.length++] = new BezierSegment(p1,p1 + auto,p2);
					auto = p2 - (p1 + auto);
				}
				else
				{
					if(index != last)
					{
						p2 = (p1 + p2) / 2;
					}
					this.segments[this.length++] = new BezierSegment(p0,p1,p2);
				}
			}
			this.fvalue = null;
			if(reverse)
			{
				this.update(0,false);
			}
		}
		
		override public function update(ke:Number, isComplete:Boolean) : void
		{
			var segment:BezierSegment = null;
			var index:int = 0;
			var last:int = this.length - 1;
			if(isComplete)
			{
				segment = this.segments[last];
				target[property] = segment.p0 + segment.d2;
			}
			else if(this.length == 1)
			{
				segment = this.segments[0];
				target[property] = segment.calculate(ke);
			}
			else
			{
				index = ke * this.length >> 0;
				if(index < 0)
				{
					index = 0;
				}
				else if(index > last)
				{
					index = last;
				}
				segment = this.segments[index];
				ke = this.length * (ke - index / this.length);
				target[property] = segment.calculate(ke);
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
	
	function BezierSegment(p0:Number, p1:Number, p2:Number)
	{
		super();
		this.p0 = p0;
		this.d1 = p1 - p0;
		this.d2 = p2 - p0;
	}
	
	public function calculate(t:Number) : Number
	{
		return this.p0 + t * (2 * (1 - t) * this.d1 + t * this.d2);
	}
}
