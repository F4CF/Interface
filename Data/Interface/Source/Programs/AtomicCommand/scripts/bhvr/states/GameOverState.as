package bhvr.states
{
	import aze.motion.eaze;
	import bhvr.manager.SoundManager;
	import bhvr.data.SoundList;
	import bhvr.data.GamePersistantData;
	import bhvr.data.LocalizationStrings;
	import Shared.BGSExternalInterface;
	import bhvr.constatnts.GameConfig;
	import bhvr.manager.InputManager;
	import bhvr.constatnts.GameInputs;
	import flash.events.Event;
	import aze.motion.EazeTween;
	import flash.display.MovieClip;
	
	public class GameOverState extends GameState
	{
		 
		
		public function GameOverState(id:int, assets:MovieClip)
		{
			super(id,assets);
			_assets.gameOverAnimationMc.titleMc.titleTxt.text = LocalizationStrings.GAME_OVER_SCREEN_TITLE;
			_assets.gameOverAnimationMc.scoreMc.scoreLabelTxt.text = LocalizationStrings.SCORE_LABEL;
			_assets.instructionsMc.instructionsAnimMc.instructionsTxt.text = LocalizationStrings.PRESS_CONTINUE_DESCRIPTION;
		}
		
		override public function enter() : void
		{
			super.enter();
			_assets.instructionsMc.instructionsAnimMc.visible = false;
			eaze(_assets.gameOverAnimationMc).play("startLoop>endExplosion").onComplete(this.onInputsReady);
			SoundManager.instance.startLongSound(SoundList.GAME_OVER_SOUND_ID);
			_assets.gameOverAnimationMc.scoreMc.scoreTxt.text = GamePersistantData.totalScore;
			_assets.gameOverAnimationMc.highScoreMc.highScoreLabelTxt.text = LocalizationStrings.HIGH_SCORE_LABEL;
			if(GamePersistantData.totalScore > GamePersistantData.highScore)
			{
				GamePersistantData.highScore = GamePersistantData.totalScore;
				BGSExternalInterface.call(BGSCodeObj,"setHighscore",GameConfig.GAME_HIGH_SCORE_KEY,GamePersistantData.highScore);
				_assets.gameOverAnimationMc.highScoreMc.highScoreLabelTxt.text = LocalizationStrings.NEW_HIGH_SCORE_LABEL;
			}
			_assets.gameOverAnimationMc.highScoreMc.highScoreTxt.text = GamePersistantData.highScore;
		}
		
		override public function exit() : void
		{
			super.exit();
			InputManager.instance.removeEventListener(GameInputs.ACCEPT,this.onEndGame);
		}
		
		private function onInputsReady() : void
		{
			_assets.instructionsMc.instructionsAnimMc.visible = true;
			InputManager.instance.addEventListener(GameInputs.ACCEPT,this.onEndGame,false,0,true);
		}
		
		private function onEndGame(e:Event) : void
		{
			eaze(_assets.gameOverAnimationMc).killTweens();
			onNavContinue();
		}
		
		override public function Pause(paused:Boolean) : void
		{
			if(paused)
			{
				EazeTween.pauseAllTweens();
				_assets.instructionsMc.stop();
			}
			else
			{
				EazeTween.resumeAllTweens();
				_assets.instructionsMc.play();
			}
		}
	}
}
