package aze.motion.easing
{
	public final class Quadratic
	{
		 
		
		public function Quadratic()
		{
			super();
		}
		
		public static function easeIn(param1:Number) : Number
		{
			return param1 * param1;
		}
		
		public static function easeOut(param1:Number) : Number
		{
			return -param1 * (param1 - 2);
		}
		
		public static function easeInOut(param1:Number) : Number
		{
			if((param1 = param1 * 2) < 1)
			{
				return 0.5 * param1 * param1;
			}
			return -0.5 * (--param1 * (param1 - 2) - 1);
		}
	}
}
