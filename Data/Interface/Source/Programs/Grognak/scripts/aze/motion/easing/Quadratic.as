package aze.motion.easing
{
	public final class Quadratic
	{
		 
		
		public function Quadratic()
		{
			super();
		}
		
		public static function easeIn(k:Number) : Number
		{
			return k * k;
		}
		
		public static function easeOut(k:Number) : Number
		{
			return -k * (k - 2);
		}
		
		public static function easeInOut(k:Number) : Number
		{
			if((k = k * 2) < 1)
			{
				return 0.5 * k * k;
			}
			return -0.5 * (--k * (k - 2) - 1);
		}
	}
}
