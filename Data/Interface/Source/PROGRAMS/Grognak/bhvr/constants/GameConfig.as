package bhvr.constants
{
	import bhvr.controller.StateController;
	
	public class GameConfig
	{
		
		public static const GAME_NAME:String = "Grognak";
		
		public static const GAME_HIGH_SCORE_KEY:String = "HSGrognak";
		
		public static const GAME_SAVE_DATA_KEY:String = "SaveDataGrognak";
		
		public static const GAME_TITLE_ASSETS_PATH:String = "GrognakTitleAssets.swf";
		
		public static const GAME_MAP_ASSETS_PATH:String = "GrognakMapAssets.swf";
		
		public static const GAME_WINDOW_ASSETS_PATH:String = "GrognakWindowAssets.swf";
		
		public static const GAME_GAME_OVER_ASSETS_PATH:String = "GrognakGameOverAssets.swf";
		
		public static const GAME_PAUSE_ASSETS_PATH:String = "GenericPauseAssets.swf";
		
		public static const GAME_CONFIRM_QUIT_ASSETS_PATH:String = "GenericConfirmQuitAssets.swf";
		
		public static const INVALID_ASSET_ID:int = -1;
		
		public static const GAME_ASSETS_PATH:Vector.<String> = new <String>[GAME_XML_PATH,GAME_TITLE_ASSETS_PATH,GAME_MAP_ASSETS_PATH,GAME_WINDOW_ASSETS_PATH,GAME_GAME_OVER_ASSETS_PATH,GAME_PAUSE_ASSETS_PATH,GAME_CONFIRM_QUIT_ASSETS_PATH];
		
		public static const GAME_XML_PATH:String = "xml/GrognakConfig.xml";
		
		public static const STARTING_STATE:int = StateController.TITLE;
		
		public static const DEFAULT_COMBAT_EVENT:String = "BandOfGoblinoidsBattle";
		
		public static const FORCE_PARTY_MEMBERS:Vector.<int> = null;
		 
		
		public function GameConfig()
		{
			super();
		}
		
		public static function getAssetIdFromUrl(url:String) : int
		{
			var i:uint = 0;
			for(i = 0; i < GameConfig.GAME_ASSETS_PATH.length; i++)
			{
				if(url == GameConfig.GAME_ASSETS_PATH[i])
				{
					return i;
				}
			}
			return INVALID_ASSET_ID;
		}
	}
}
