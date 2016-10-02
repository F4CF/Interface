package bhvr.states
{
	import aze.motion.eaze;
	import bhvr.data.LocalizationStrings;
	import Shared.AS3.COMPANIONAPP.CompanionAppMode;
	import flash.events.MouseEvent;
	import bhvr.manager.InputManager;
	import bhvr.constants.GameInputs;
	import bhvr.data.GamePersistantData;
	import Shared.BGSExternalInterface;
	import bhvr.constants.GameConfig;
	import flash.events.Event;
	import bhvr.manager.SoundManager;
	import bhvr.data.SoundList;
	import flash.display.MovieClip;
	
	public class GameOverState extends GameState
	{
		 
		
		public function GameOverState(param1:int, param2:MovieClip)
		{
			super(param1,param2);
		}
		
		override public function enter(param1:Object = null) : void
		{
			super.enter(param1);
			eaze(_assets.animMc).play("1>Stop").onComplete(this.onIntroComplete);
			_assets.promptsMc.promptsAnimMc.promptsTxt.text = LocalizationStrings.PRESS_CONTINUE_DESCRIPTION;
			this.setWave();
			this.setScore();
			this.setHighScore();
		}
		
		private function onIntroComplete() : void
		{
			if(!CompanionAppMode.isOn)
			{
				_assets.stage.addEventListener(MouseEvent.CLICK,this.onContinue,false,0,true);
			}
			InputManager.instance.addEventListener(GameInputs.ACCEPT,this.onContinue,false,0,true);
		}
		
		override public function exit() : void
		{
			super.exit();
			if(!CompanionAppMode.isOn)
			{
				_assets.stage.removeEventListener(MouseEvent.CLICK,this.onContinue);
			}
			InputManager.instance.removeEventListener(GameInputs.ACCEPT,this.onContinue);
		}
		
		private function setWave() : void
		{
			_assets.waveMc.waveTxt.text = GamePersistantData.level;
		}
		
		private function setScore() : void
		{
			_assets.scoreMc.scoreTxt.text = GamePersistantData.totalScore;
		}
		
		private function setHighScore() : void
		{
			_assets.highScoreMc.highScoreLabelTxt.text = LocalizationStrings.HIGH_SCORE_LABEL;
			if(GamePersistantData.totalScore > GamePersistantData.highScore)
			{
				GamePersistantData.highScore = GamePersistantData.totalScore;
				BGSExternalInterface.call(BGSCodeObj,"setHighscore",GameConfig.GAME_HIGH_SCORE_KEY,GamePersistantData.highScore);
				_assets.highScoreMc.highScoreLabelTxt.text = LocalizationStrings.NEW_HIGH_SCORE_LABEL;
			}
			_assets.highScoreMc.highScoreTxt.text = GamePersistantData.highScore;
		}
		
		private function onContinue(param1:Event) : void
		{
			SoundManager.instance.playSound(SoundList.NAV_CONTINUE_SOUND);
			onNavContinue();
		}
		
		override public function Pause(param1:Boolean) : void
		{
			super.Pause(param1);
			if(param1)
			{
				_assets.promptsMc.stop();
			}
			else
			{
				_assets.promptsMc.play();
			}
		}
	}
}
