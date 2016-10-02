package bhvr.utils
{
	import flash.geom.Point;
	
	public class MathUtil
	{
		
		private static const DIGIT_NUMBERS:uint = 3;
		
		private static const DIGIT_SEPARATOR:String = ",";
		 
		
		public function MathUtil()
		{
			super();
		}
		
		public static function random(min:int = 0, max:int = 1) : int
		{
			return Math.floor(Math.random() * (1 + max - min)) + min;
		}
		
		public static function formatWithCommas(x:Number, digitSeperator:String = ",") : String
		{
			var i:uint = 0;
			var initString:Array = String(x).split("").reverse();
			var finalString:Array = String(x).split("").reverse();
			var digitCounter:uint = 0;
			var commasCounter:uint = 0;
			for(i = 0; i < initString.length; i++)
			{
				digitCounter++;
				if(digitCounter >= DIGIT_NUMBERS)
				{
					commasCounter++;
					digitCounter = 0;
					finalString.splice(commasCounter * DIGIT_NUMBERS + (commasCounter - 1),0,digitSeperator);
				}
			}
			finalString.reverse();
			if(finalString[0] == digitSeperator)
			{
				finalString.shift();
			}
			initString = null;
			return finalString.join("");
		}
		
		public static function getDistance(startPoint:Point, endPoint:Point) : Number
		{
			var deltaX:Number = endPoint.x - startPoint.x;
			var deltaY:Number = endPoint.y - startPoint.y;
			return Math.sqrt(deltaX * deltaX + deltaY * deltaY);
		}
		
		public static function getVerticalDegAngle(startPoint:Point, endPoint:Point) : Number
		{
			var deltaX:Number = endPoint.x - startPoint.x;
			var deltaY:Number = endPoint.y - startPoint.y;
			var dir:Number = deltaX == 0?Number(Math.abs(deltaY)):Number(Math.abs(deltaY) / deltaX);
			var radAngle:Number = getVerticalRadAngle(startPoint,endPoint);
			var degAngle:Number = dir > 0?Number(180 - radAngle * 180 / Math.PI):Number(180 + radAngle * 180 / Math.PI);
			return degAngle;
		}
		
		public static function getVerticalRadAngle(startPoint:Point, endPoint:Point) : Number
		{
			var deltaY:Number = endPoint.y - startPoint.y;
			var radAngle:Number = Math.acos(deltaY / getDistance(startPoint,endPoint));
			return radAngle;
		}
		
		public static function clamp(value:Number, min:Number = 0.0, max:Number = 1.0) : Number
		{
			return Math.max(min,Math.min(value,max));
		}
	}
}
