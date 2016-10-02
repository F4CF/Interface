package bhvr.constatnts
{
	import bhvr.controller.StateController;
	
	public class GameConfig
	{
		
		public static const GAME_NAME:String = "Atomic Command";
		
		public static const GAME_HIGH_SCORE_KEY:String = "HSAtomicCommand";
		
		public static const USING_CURSOR:Boolean = true;
		
		public static const GAME_ASSETS_PATH:String = "AtomicCommandAssets.swf";
		
		public static const GAME_XML_PATH:String = "xml/AtomicCommandConfig.xml";
		
		public static const STARTING_STATE:int = StateController.TITLE;
		 
		
		public function GameConfig()
		{
			super();
		}
	}
}
