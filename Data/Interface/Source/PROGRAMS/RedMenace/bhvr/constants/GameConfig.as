package bhvr.constants
{
	import bhvr.controller.StateController;
	
	public class GameConfig
	{
		
		public static const GAME_NAME:String = "RedMenace";
		
		public static const GAME_HIGH_SCORE_KEY:String = "HSRedMenace";
		
		public static const GAME_ASSETS_PATH:String = "RedMenaceAssets.swf";
		
		public static const GAME_XML_PATH:String = "xml/RedMenaceConfig.xml";
		
		public static const STARTING_STATE:int = StateController.TITLE;
		 
		
		public function GameConfig()
		{
			super();
		}
	}
}
