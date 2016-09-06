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
		
		public static function info(msg:String) : void
		{
			trace(GAME_LABEL + PRE_LABEL + NONE_LABEL,msg);
		}
		
		public static function warn(msg:String) : void
		{
			trace(GAME_LABEL + PRE_LABEL + WARNING_LABEL,msg);
		}
		
		public static function error(msg:String) : void
		{
			trace(GAME_LABEL + PRE_LABEL + ERROR_LABEL,msg);
		}
	}
}
