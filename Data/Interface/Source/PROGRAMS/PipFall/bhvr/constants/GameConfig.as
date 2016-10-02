package bhvr.constants
{
	import bhvr.controller.StateController;
	
	public class GameConfig
	{
		
		public static const GAME_NAME:String = "PipFall";
		
		public static const GAME_HIGH_SCORE_KEY:String = "HSPipfall";
		
		public static const GAME_ASSETS_PATH:String = "PipFallAssets.swf";
		
		public static const GAME_XML_PATH:String = "xml/PipFallConfig.xml";
		
		public static const STARTING_STATE:int = StateController.TITLE;
		 
		
		public function GameConfig()
		{
			super();
		}
	}
}
