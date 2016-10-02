package bhvr.constants
{
	import bhvr.states.GameStateFactory;
	
	public class GameConfig
	{
		
		public static const GAME_NAME:String = "Automatron";
		
		public static const GAME_HIGH_SCORE_KEY:String = "HSAutomatron";
		
		public static const GAME_SWF_PATH:String = "AutomatronAssets.swf";
		
		public static const GAME_XML_PATH:String = "xml/AutomatronConfig.xml";
		
		public static const ENEMIES_XML_PATH:String = "xml/AutomatronEnemies.xml";
		
		public static const LEVELS_XML_PATH:String = "xml/AutomatronLevels.xml";
		
		public static const USING_CURSOR:Boolean = true;
		
		public static const CURSOR_SWF_CONTAINER:String = GAME_SWF_PATH;
		
		public static const PAUSE_BUTTON_SWF_CONTAINER:String = GAME_SWF_PATH;
		
		public static const PAUSE_BUTTON_MC_NAME:String = "pauseBtnMc";
		
		public static const GAME_ASSETS_PATH:Vector.<String> = new <String>[GAME_SWF_PATH,GAME_XML_PATH];
		
		public static const INVALID_ASSET_ID:int = -1;
		
		public static const STATES_USING_RESUME_COUNTER:Vector.<int> = new <int>[GameStateFactory.LEVEL];
		
		public static const STARTING_STATE:int = GameStateFactory.TITLE;
		
		public static const INPUT_MAIN_ACTION_START:String = GameInputs.FIRE;
		
		public static const INPUT_MAIN_ACTION_STOP:String = GameInputs.STOP_FIRE;
		 
		
		public function GameConfig()
		{
			super();
		}
		
		public static function getAssetIdFromUrl(param1:String) : int
		{
			var _loc2_:uint = 0;
			_loc2_ = 0;
			while(_loc2_ < GameConfig.GAME_ASSETS_PATH.length)
			{
				if(param1 == GameConfig.GAME_ASSETS_PATH[_loc2_])
				{
					return _loc2_;
				}
				_loc2_++;
			}
			return INVALID_ASSET_ID;
		}
		
		public static function isStateUsingResumeCounter(param1:int) : Boolean
		{
			var _loc2_:uint = 0;
			while(_loc2_ < STATES_USING_RESUME_COUNTER.length)
			{
				if(param1 == STATES_USING_RESUME_COUNTER[_loc2_])
				{
					return true;
				}
				_loc2_++;
			}
			return false;
		}
	}
}
