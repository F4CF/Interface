package bhvr.debug
{
	import bhvr.constants.GameConfig;
	
	public class Log
	{
		
		public static const TYPE_NORMAL:uint = 0;
		
		public static const TYPE_WARNING:uint = 1;
		
		public static const TYPE_ERROR:uint = 2;
		
		private static var GAME_LABEL:String = "[" + GameConfig.GAME_NAME + "]";
		
		private static var PRE_LABEL:String = "[Flash trace]";
		
		private static var NONE_LABEL:String = "[Info]:";
		
		private static var WARNING_LABEL:String = "[Warning]:";
		
		private static var ERROR_LABEL:String = "[Error]:";
		 
		
		public function Log()
		{
			super();
		}
		
		public static function info(param1:String) : void
		{
		}
		
		public static function warn(param1:String) : void
		{
		}
		
		public static function error(param1:String) : void
		{
		}
	}
}
