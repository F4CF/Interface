package bhvr.states
{
	import flash.display.MovieClip;
	import bhvr.views.CustomCursor;
	import bhvr.constants.GameConfig;
	import bhvr.debug.Log;
	import bhvr.controller.StateController;
	
	public class GameStateFactory
	{
		
		public static const TITLE:int = 0;
		
		public static const INSTRUCTIONS:int = 1;
		
		public static const LEVEL:int = 2;
		
		public static const GAME_OVER:int = 3;
		
		public static const NUMBER_OF_STATES:int = 4;
		 
		
		public function GameStateFactory()
		{
			super();
		}
		
		public static function createState(param1:Vector.<MovieClip>, param2:int, param3:CustomCursor) : GameState
		{
			var _loc4_:MovieClip = null;
			var _loc5_:PauseState = null;
			var _loc6_:ConfirmQuitState = null;
			var _loc7_:InstructionsState = null;
			var _loc8_:TitleState = null;
			var _loc9_:GameLevelState = null;
			var _loc10_:GameOverState = null;
			_loc4_ = param1[GameConfig.getAssetIdFromUrl(GameConfig.GAME_SWF_PATH)];
			switch(param2)
			{
				case StateController.PAUSE:
					_loc5_ = new PauseState(param2,_loc4_.pauseStateMc);
					return _loc5_;
				case StateController.CONFIRM_QUIT:
					_loc6_ = new ConfirmQuitState(param2,_loc4_.genericPopupMc);
					return _loc6_;
				case INSTRUCTIONS:
					_loc7_ = new InstructionsState(param2,_loc4_.instructionsStateMc);
					return _loc7_;
				case TITLE:
					_loc8_ = new TitleState(param2,_loc4_.titleStateMc);
					return _loc8_;
				case LEVEL:
					_loc9_ = new GameLevelState(param2,_loc4_.gameLevelStateMc,param3);
					return _loc9_;
				case GAME_OVER:
					_loc10_ = new GameOverState(param2,_loc4_.gameOverStateMc);
					return _loc10_;
				default:
					Log.error("GameStateFactory: state " + param2 + " can\'t be created cause it doesn\'t exist");
					return new GameState(param2,null);
			}
		}
	}
}
