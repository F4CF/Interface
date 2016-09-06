package bhvr.states
{
	import aze.motion.eaze;
	import flash.display.MovieClip;
	import bhvr.constatnts.GameConstants;
	import bhvr.data.GamePersistantData;
	import bhvr.data.LocalizationStrings;
	import bhvr.manager.SoundManager;
	import bhvr.data.SoundList;
	import bhvr.manager.InputManager;
	import bhvr.constatnts.GameInputs;
	import flash.events.Event;
	import aze.motion.EazeTween;
	import mx.utils.StringUtil;
	
	public class ResultState extends GameState
	{
		 
		
		private const DELAY_BEFORE_STARTING_ANIMATIONS:Number = 0.3;
		
		private const MISSILE_BONUS_ANIMATION_DURATION:Number = 0.1;
		
		private const DELAY_BETWEEN_ANIMATION:Number = 1;
		
		private const LANDMARK_BONUS_ANIMATION_DURATION:Number = 0.1;
		
		private var _introAnimFinished:Boolean = false;
		
		public function ResultState(id:int, assets:MovieClip)
		{
			super(id,assets);
			_assets.titleTxt.text = LocalizationStrings.RESULT_SCREEN_TITLE;
			_assets.instructionsMc.instructionsAnimMc.instructionsTxt.text = LocalizationStrings.PRESS_CONTINUE_DESCRIPTION;
			_assets.bonusInstructionTxt.htmlText = StringUtil.substitute(LocalizationStrings.BONUS_INSTRUCTIONS,"<font size=\'30\' color=\'#ffffff\'>" + GameConstants.LANDMARK_BONUS_POINTS_MILESTONE + "</font>");
		}
		
		override public function enter() : void
		{
			super.enter();
			this.reset();
			this._introAnimFinished = false;
			eaze(this).delay(this.DELAY_BEFORE_STARTING_ANIMATIONS).onComplete(this.startMissileBonusAnimation);
			_assets.instructionsMc.instructionsAnimMc.visible = false;
		}
		
		private function reset() : void
		{
			var i:int = 0;
			var missile:MovieClip = null;
			var landmark:MovieClip = null;
			for(i = 0; i < GameConstants.maxMissileNumber; i++)
			{
				missile = _assets["missile" + i];
				if(missile != null)
				{
					missile.alpha = 0;
				}
			}
			for(i = 0; i < GameConstants.NUMBER_OF_LANDMARKS; i++)
			{
				landmark = _assets["landmark" + i];
				if(landmark != null)
				{
					landmark.alpha = 0;
				}
			}
			var multiplierString:String = GamePersistantData.gameScore.multiplier > 1?"(x" + GamePersistantData.gameScore.multiplier + ")":"";
			_assets.lvlTxt.text = LocalizationStrings.LVL_LABEL + ": " + GamePersistantData.level;
			_assets.scoreTxt.text = LocalizationStrings.SCORE_LABEL + multiplierString + ": " + GamePersistantData.totalScore;
			_assets.missileBonusTxt.text = 0;
			_assets.landmarkBonusTxt.text = 0;
		}
		
		private function startMissileBonusAnimation() : void
		{
			var missileAnimNum:int = GamePersistantData.gameScore.missilesBonus / GameConstants.scoreMissile;
			var missileId:int = 0;
			if(missileAnimNum > 0)
			{
				this.onMissileBonusAnimation(missileId,missileAnimNum);
			}
			else
			{
				this.startLandmarkBonusAnimation();
			}
		}
		
		private function onMissileBonusAnimation(missileId:int, maxMissileNum:int) : void
		{
			_assets["missile" + missileId].alpha = 1;
			this.updateMissileBonusPoints(GameConstants.scoreMissile * (missileId + 1));
			SoundManager.instance.playSound(SoundList.BONUS_POINTS_SOUND);
			if(missileId < maxMissileNum - 1)
			{
				eaze(this).delay(this.MISSILE_BONUS_ANIMATION_DURATION).onComplete(this.onMissileBonusAnimation,missileId + 1,maxMissileNum);
			}
			else
			{
				this.addMissileBonusToScore();
				eaze(this).delay(this.DELAY_BETWEEN_ANIMATION).onComplete(this.startLandmarkBonusAnimation);
			}
		}
		
		private function startLandmarkBonusAnimation() : void
		{
			var landmarkAnimNum:int = GamePersistantData.aliveLandmarks.length;
			var landmarkViewId:int = 0;
			this.onLandmarkBonusAnimation(landmarkViewId,landmarkAnimNum);
		}
		
		private function onLandmarkBonusAnimation(landmarkViewId:int, maxLandmarkNum:int) : void
		{
			var landmarkId:int = GamePersistantData.aliveLandmarks[landmarkViewId];
			for(var i:int = 0; i < GameConstants.NUMBER_OF_LANDMARKS; i++)
			{
				_assets["landmark" + landmarkViewId].landmarkViewAnimMc["landmarkView" + i].visible = i == landmarkId;
			}
			_assets["landmark" + landmarkViewId].alpha = 1;
			this.updateLandmarkBonusPoints(GameConstants.scoreLandmark * (landmarkViewId + 1));
			SoundManager.instance.playSound(SoundList.BONUS_POINTS_SOUND);
			if(landmarkViewId < maxLandmarkNum - 1)
			{
				eaze(this).delay(this.LANDMARK_BONUS_ANIMATION_DURATION).onComplete(this.onLandmarkBonusAnimation,landmarkViewId + 1,maxLandmarkNum);
			}
			else
			{
				this.addLandmarkBonusToScore();
				_assets.instructionsMc.instructionsAnimMc.visible = true;
				this._introAnimFinished = true;
				InputManager.instance.addEventListener(GameInputs.ACCEPT,this.onNextLevel,false,0,true);
			}
		}
		
		private function updateMissileBonusPoints(pts:int) : void
		{
			var finalPoints:int = pts * GamePersistantData.gameScore.multiplier;
			_assets.missileBonusTxt.text = finalPoints.toString();
		}
		
		private function updateLandmarkBonusPoints(pts:int) : void
		{
			var finalPoints:int = pts * GamePersistantData.gameScore.multiplier;
			_assets.landmarkBonusTxt.text = finalPoints.toString();
		}
		
		private function addMissileBonusToScore() : void
		{
			GamePersistantData.gameScore.transferMissilesBonusToScore();
			var multiplierString:String = GamePersistantData.gameScore.multiplier > 1?"(x" + GamePersistantData.gameScore.multiplier + ")":"";
			_assets.scoreTxt.text = LocalizationStrings.SCORE_LABEL + multiplierString + ": " + GamePersistantData.totalScore;
		}
		
		private function addLandmarkBonusToScore() : void
		{
			GamePersistantData.gameScore.transferLandmarksBonusToScore();
			var multiplierString:String = GamePersistantData.gameScore.multiplier > 1?"(x" + GamePersistantData.gameScore.multiplier + ")":"";
			_assets.scoreTxt.text = LocalizationStrings.SCORE_LABEL + multiplierString + ": " + GamePersistantData.totalScore;
		}
		
		override public function exit() : void
		{
			super.exit();
			InputManager.instance.removeEventListener(GameInputs.ACCEPT,this.onNextLevel);
		}
		
		private function onNextLevel(e:Event) : void
		{
			onNavContinue();
		}
		
		override public function Pause(paused:Boolean) : void
		{
			if(paused)
			{
				if(this._introAnimFinished)
				{
					_assets.instructionsMc.stop();
					InputManager.instance.removeEventListener(GameInputs.ACCEPT,this.onNextLevel);
				}
				else
				{
					EazeTween.pauseAllTweens();
				}
			}
			else if(this._introAnimFinished)
			{
				_assets.instructionsMc.play();
				InputManager.instance.addEventListener(GameInputs.ACCEPT,this.onNextLevel,false,0,true);
			}
			else
			{
				EazeTween.resumeAllTweens();
			}
		}
	}
}
