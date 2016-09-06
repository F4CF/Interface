package bhvr.constatnts
{
	import bhvr.controller.StateController;
	
	public class GameConfig
	{
		
		public static const GAME_NAME:String = "Zeta Invaders";
		
		public static const GAME_HIGH_SCORE_KEY:String = "HSZetaInvaders";
		
		public static const GAME_ASSETS_PATH:String = "ZetaInvadersAssets.swf";
		
		public static const GAME_XML_PATH:String = "xml/ZetaInvadersConfig.xml";
		
		public static const STARTING_STATE:int = StateController.TITLE;
		 
		
		public function GameConfig()
		{
			super();
		}
	}
}
