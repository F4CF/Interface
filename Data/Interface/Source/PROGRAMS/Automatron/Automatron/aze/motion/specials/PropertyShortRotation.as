package aze.motion.specials
{
	import aze.motion.EazeTween;
	
	public class PropertyShortRotation extends EazeSpecial
	{
		 
		
		private var fvalue:Number;
		
		private var radius:Number;
		
		private var start:Number;
		
		private var delta:Number;
		
		public function PropertyShortRotation(param1:Object, param2:*, param3:*, param4:EazeSpecial)
		{
			super(param1,param2,param3,param4);
			this.fvalue = param3[0];
			this.radius = !!param3[1]?Number(Math.PI):Number(180);
		}
		
		public static function register() : void
		{
			EazeTween.specialProperties["__short"] = PropertyShortRotation;
		}
		
		override public function init(param1:Boolean) : void
		{
			var _loc2_:Number = NaN;
			this.start = target[property];
			if(param1)
			{
				_loc2_ = this.start;
				target[property] = this.start = this.fvalue;
			}
			else
			{
				_loc2_ = this.fvalue;
			}
			while(_loc2_ - this.start > this.radius)
			{
				this.start = this.start + this.radius * 2;
			}
			while(_loc2_ - this.start < -this.radius)
			{
				this.start = this.start - this.radius * 2;
			}
			this.delta = _loc2_ - this.start;
		}
		
		override public function update(param1:Number, param2:Boolean) : void
		{
			target[property] = this.start + param1 * this.delta;
		}
	}
}
