package bhvr.states
{
	import bhvr.manager.InputManager;
	import bhvr.constants.GameInputs;
	import bhvr.data.GamePersistantData;
	import Shared.BGSExternalInterface;
	import bhvr.constants.GameConfig;
	import flash.display.MovieClip;
	import bhvr.data.LocalizationStrings;
	
	public class GameOverState extends GameState
	{
		 
		
		public function GameOverState(id:int, assets:MovieClip)
		{
			super(id,assets);
			_assets.newHighScoreMc.newHighScoreAnimMc.newHighScoreLabelTxt.text = LocalizationStrings.HIGH_SCORE;
			_assets.instructionsMc.instructionsAnimMc.instructionsTxt.text = LocalizationStrings.CONTINUE_PROMPT;
		}
		
		override public function enter() : void
		{
			super.enter();
			this.displayHighScore();
			InputManager.instance.addEventListener(GameInputs.ACCEPT,onNavContinue,false,0,true);
		}
		
		override public function exit() : void
		{
			InputManager.instance.removeEventListener(GameInputs.ACCEPT,onNavContinue);
			super.exit();
		}
		
		private function displayHighScore() : void
		{
			_assets.newHighScoreMc.visible = false;
			if(GamePersistantData.score > GamePersistantData.highScore)
			{
				GamePersistantData.highScore = GamePersistantData.score;
				BGSExternalInterface.call(BGSCodeObj,"setHighscore",GameConfig.GAME_HIGH_SCORE_KEY,GamePersistantData.highScore);
				_assets.newHighScoreMc.visible = true;
			}
			_assets.highScoreTxt.text = GamePersistantData.highScore;
		}
		
		override public function Pause(paused:Boolean) : void
		{
			super.Pause(paused);
			if(paused)
			{
				InputManager.instance.removeEventListener(GameInputs.ACCEPT,onNavContinue);
				_assets.bossMc.stop();
				_assets.miniBossMc.stop();
				_assets.instructionsMc.stop();
			}
			else
			{
				InputManager.instance.addEventListener(GameInputs.ACCEPT,onNavContinue,false,0,true);
				_assets.bossMc.play();
				_assets.miniBossMc.play();
				_assets.instructionsMc.play();
			}
		}
	}
}
