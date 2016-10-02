package bhvr.states
{
	import bhvr.data.GamePersistantData;
	import bhvr.constants.GameConstants;
	import aze.motion.eaze;
	import bhvr.manager.InputManager;
	import bhvr.constants.GameInputs;
	import bhvr.data.LocalizationStrings;
	import aze.motion.easing.Linear;
	import bhvr.manager.SoundManager;
	import bhvr.data.SoundList;
	import Shared.BGSExternalInterface;
	import bhvr.constants.GameConfig;
	import bhvr.events.EventWithParams;
	import Shared.AS3.COMPANIONAPP.CompanionAppMode;
	import flash.events.Event;
	import aze.motion.EazeTween;
	import flash.display.MovieClip;
	
	public class GameOverState extends GameState
	{
		
		private static const BOBBLEHEADS_ANIMATION_INTERVAL:Number = 0.3;
		
		private static const LIFE_ANIMATION_INTERVAL:Number = 0.3;
		
		private static const TIME_ANIMATION_DURATION:Number = 0.5;
		
		private static const TOTAL_SCORE_ANIMATION_DURATION:Number = 0.5;
		
		private static const DELAY_BETWEEN_ANIMATIONS:Number = 1;
		 
		
		private var _totalScore:int;
		
		private var _updatingTotalScore:Boolean;
		
		private var _updatingTimeScore:Boolean;
		
		public function GameOverState(id:int, assets:MovieClip)
		{
			super(id,assets);
			_assets.totalScoreLabelTxt.text = LocalizationStrings.TOTAL_SCORE;
			_assets.instructionsMc.instructionsAnimMc.instructionsTxt.text = LocalizationStrings.CONTINUE_PROMPT;
		}
		
		public function get isGameOverWin() : Boolean
		{
			return GamePersistantData.bobbleHeadNum == GameConstants.numBobbleHead;
		}
		
		public function get isGameOverLife() : Boolean
		{
			return GamePersistantData.lifeNum == 0;
		}
		
		public function get isGameOverTime() : Boolean
		{
			return GamePersistantData.timeRemaining == 0;
		}
		
		public function get isGameOverLoose() : Boolean
		{
			return this.isGameOverLife || this.isGameOverTime;
		}
		
		override public function enter() : void
		{
			super.enter();
			this.reset();
			this.displayHighScore();
			this.setGameStatus();
			eaze(_assets).play("fadeInStart>fadeInEnd").onComplete(this.onEnterComplete);
		}
		
		private function onEnterComplete() : void
		{
			InputManager.instance.addEventListener(GameInputs.ACCEPT,this.onSkipAnimations,false,0,true);
			this.startBobbleHeadScoreAnimation();
		}
		
		override public function exit() : void
		{
			super.exit();
			InputManager.instance.removeEventListener(GameInputs.ACCEPT,this.onEndGame);
		}
		
		private function reset() : void
		{
			var i:int = 0;
			for(i = 0; i < GameConstants.numBobbleHead; i++)
			{
				_assets["bobbleHead" + i].gotoAndStop("empty");
			}
			for(i = 0; i < GameConstants.livesMaxNum; i++)
			{
				_assets["heart" + i].gotoAndPlay("empty");
			}
			this._totalScore = 0;
			this._updatingTotalScore = false;
			this._updatingTimeScore = false;
			_assets.bobbleHeadScoreTxt.text = 0;
			_assets.lifeScoreTxt.text = 0;
			_assets.timeScoreTxt.text = 0;
			_assets.timeRemainingTxt.text = "";
			_assets.totalScoreTxt.text = this._totalScore;
			_assets.highScoreTxt.text = 0;
			_assets.gameStatusTxt.text = "";
			_assets.instructionsMc.visible = false;
			_assets.playerWinMc.visible = false;
			_assets.playerLoseMc.visible = false;
			_assets.gotoAndStop(0);
		}
		
		private function setGameStatus() : void
		{
			if(this.isGameOverWin)
			{
				_assets.playerWinMc.visible = true;
				_assets.gameStatusTxt.text = LocalizationStrings.WIN_STATUS;
			}
			else
			{
				_assets.playerLoseMc.visible = true;
				_assets.gameStatusTxt.text = LocalizationStrings.LOSE_STATUS;
			}
		}
		
		private function startBobbleHeadScoreAnimation() : void
		{
			if(GamePersistantData.bobbleHeadNum > 0)
			{
				this.onBobbleHeadScoreAnimation(0);
			}
			else
			{
				this.startLifeScoreAnimation();
			}
		}
		
		private function onBobbleHeadScoreAnimation(id:int) : void
		{
			_assets["bobbleHead" + id].gotoAndStop("full");
			_assets.bobbleHeadScoreTxt.text = GameConstants.pointsPerBobbleHead * (id + 1);
			if(id < GamePersistantData.bobbleHeadNum - 1)
			{
				eaze(this).delay(BOBBLEHEADS_ANIMATION_INTERVAL).onComplete(this.onBobbleHeadScoreAnimation,id + 1);
			}
			else
			{
				this.updateTotalScore(int(_assets.bobbleHeadScoreTxt.text));
				eaze(this).delay(DELAY_BETWEEN_ANIMATIONS).onComplete(this.startLifeScoreAnimation);
			}
		}
		
		private function startLifeScoreAnimation() : void
		{
			if(GamePersistantData.lifeNum > 0)
			{
				this.onLifeScoreAnimation(0);
			}
			else
			{
				this.startTimeScoreAnimation();
			}
		}
		
		private function onLifeScoreAnimation(id:int) : void
		{
			_assets["heart" + id].gotoAndPlay("addStart");
			_assets.lifeScoreTxt.text = GameConstants.pointsPerHeart * (id + 1);
			if(id < GamePersistantData.lifeNum - 1)
			{
				eaze(this).delay(LIFE_ANIMATION_INTERVAL).onComplete(this.onLifeScoreAnimation,id + 1);
			}
			else
			{
				this.updateTotalScore(int(_assets.lifeScoreTxt.text));
				eaze(this).delay(DELAY_BETWEEN_ANIMATIONS).onComplete(this.startTimeScoreAnimation);
			}
		}
		
		private function startTimeScoreAnimation() : void
		{
			if(GamePersistantData.timeRemaining > 0)
			{
				eaze(_assets.timeRemainingTxt).to(TIME_ANIMATION_DURATION,{"text":GamePersistantData.timeRemaining}).easing(Linear.easeNone).onUpdate(this.onTimeScoreUpdate).onComplete(this.onTimeScoreFinished);
				this._updatingTimeScore = true;
				SoundManager.instance.startSound(SoundList.TALLY_TIME_LOOP_SOUND_ID);
			}
			else
			{
				_assets.timeRemainingTxt.text = 0;
				this.updateHighScore();
			}
		}
		
		private function onTimeScoreUpdate() : void
		{
			var time:int = Math.ceil(_assets.timeRemainingTxt.text);
			var score:int = time * GameConstants.pointsPerSecond;
			_assets.timeRemainingTxt.text = time;
			_assets.timeScoreTxt.text = score;
		}
		
		private function onTimeScoreFinished() : void
		{
			this._updatingTimeScore = false;
			SoundManager.instance.stopSound(SoundList.TALLY_TIME_LOOP_SOUND_ID);
			this.updateTotalScore(GamePersistantData.timeRemaining * GameConstants.pointsPerSecond);
			eaze(this).delay(TOTAL_SCORE_ANIMATION_DURATION).onComplete(this.updateHighScore);
		}
		
		private function displayHighScore() : void
		{
			_assets.highScoreLabelTxt.text = LocalizationStrings.HIGH_SCORE;
			_assets.highScoreTxt.text = GamePersistantData.highScore;
		}
		
		private function updateHighScore() : void
		{
			InputManager.instance.removeEventListener(GameInputs.ACCEPT,this.onSkipAnimations);
			if(this._totalScore > GamePersistantData.highScore)
			{
				GamePersistantData.highScore = this._totalScore;
				BGSExternalInterface.call(BGSCodeObj,"setHighscore",GameConfig.GAME_HIGH_SCORE_KEY,GamePersistantData.highScore);
				_assets.highScoreLabelTxt.text = LocalizationStrings.NEW_HIGH_SCORE;
			}
			_assets.highScoreTxt.text = GamePersistantData.highScore;
			InputManager.instance.addEventListener(GameInputs.ACCEPT,this.onEndGame,false,0,true);
			_assets.instructionsMc.visible = true;
		}
		
		private function updateTotalScore(scoreToAdd:int) : void
		{
			this._totalScore = this._totalScore + scoreToAdd;
			eaze(_assets.totalScoreTxt).to(TOTAL_SCORE_ANIMATION_DURATION,{"text":this._totalScore}).easing(Linear.easeNone).onUpdate(this.onTotalScoreUpdate).onComplete(this.onTotalScoreFinished);
			this._updatingTotalScore = true;
			SoundManager.instance.startSound(SoundList.TALLY_POINTS_LOOP_SOUND_ID);
		}
		
		private function onTotalScoreUpdate() : void
		{
			var score:int = Math.ceil(_assets.totalScoreTxt.text);
			_assets.totalScoreTxt.text = score;
		}
		
		private function onTotalScoreFinished() : void
		{
			this._updatingTotalScore = false;
			this.stopTallyPointsSound();
		}
		
		private function onSkipAnimations(e:EventWithParams) : void
		{
			var i:uint = 0;
			eaze(this).killTweens();
			eaze(_assets.timeRemainingTxt).killTweens();
			eaze(_assets.totalScoreTxt).killTweens();
			if(this._updatingTotalScore)
			{
				this.stopTallyPointsSound();
			}
			else if(this._updatingTimeScore)
			{
				SoundManager.instance.stopSound(SoundList.TALLY_TIME_LOOP_SOUND_ID);
			}
			var bobbleHeadScore:int = GameConstants.pointsPerBobbleHead * GamePersistantData.bobbleHeadNum;
			_assets.bobbleHeadScoreTxt.text = bobbleHeadScore.toString();
			for(i = 0; i < GamePersistantData.bobbleHeadNum; i++)
			{
				_assets["bobbleHead" + i].gotoAndStop("full");
			}
			var lifeScore:int = GameConstants.pointsPerHeart * GamePersistantData.lifeNum;
			_assets.lifeScoreTxt.text = lifeScore.toString();
			for(i = 0; i < GamePersistantData.lifeNum; i++)
			{
				_assets["heart" + i].gotoAndPlay("addStart");
			}
			_assets.timeRemainingTxt.text = GamePersistantData.timeRemaining;
			var timeScore:int = GamePersistantData.timeRemaining * GameConstants.pointsPerSecond;
			_assets.timeScoreTxt.text = timeScore.toString();
			this._totalScore = bobbleHeadScore + lifeScore + timeScore;
			_assets.totalScoreTxt.text = this._totalScore.toString();
			this.updateHighScore();
		}
		
		private function stopTallyPointsSound() : void
		{
			SoundManager.instance.stopSound(SoundList.TALLY_POINTS_LOOP_SOUND_ID);
			if(CompanionAppMode.isOn)
			{
				SoundManager.instance.playSound(SoundList.TALLY_POINTS_FINAL_SOUND);
			}
		}
		
		private function onEndGame(e:Event) : void
		{
			SoundManager.instance.playSound(SoundList.PRESS_START_SOUND);
			onNavContinue();
		}
		
		override public function Pause(paused:Boolean) : void
		{
			if(paused)
			{
				EazeTween.pauseAllTweens();
				if(_assets.instructionsMc.visible)
				{
					InputManager.instance.removeEventListener(GameInputs.ACCEPT,this.onEndGame);
					_assets.instructionsMc.stop();
				}
				else if(_assets.currentLabel == "fadeInEnd")
				{
					InputManager.instance.removeEventListener(GameInputs.ACCEPT,this.onSkipAnimations);
				}
			}
			else
			{
				EazeTween.resumeAllTweens();
				if(_assets.instructionsMc.visible)
				{
					InputManager.instance.addEventListener(GameInputs.ACCEPT,this.onEndGame,false,0,true);
					_assets.instructionsMc.play();
				}
				else if(_assets.currentLabel == "fadeInEnd")
				{
					InputManager.instance.addEventListener(GameInputs.ACCEPT,this.onSkipAnimations,false,0,true);
				}
			}
		}
	}
}
