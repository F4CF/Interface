package bhvr.views
{
	import flash.display.MovieClip;
	import bhvr.data.GamePersistantData;
	import bhvr.utils.FlashUtil;
	import bhvr.constants.GameConstants;
	import aze.motion.eaze;
	import bhvr.utils.AnimationUtil;
	import bhvr.data.LocalizationStrings;
	
	public class Hud
	{
		 
		
		private var _assets:MovieClip;
		
		private var _timer:MovieClip;
		
		private const WARNING_TIMER_THRESHOLD:uint = GameConstants.BonusTimerLostPerSecond * 5;
		
		private const BONUS_TRANSFER_DURATION:Number = 1.2;
		
		public function Hud(assets:MovieClip)
		{
			super();
			this._assets = assets;
			this._timer = this._assets.bonusTimerMc;
			this._assets.timerLabelTxt.text = LocalizationStrings.BONUS_TIMER.toUpperCase();
			this._assets.highScoreLabelTxt.text = LocalizationStrings.HIGH_SCORE.toUpperCase();
		}
		
		private function get timerWarningAnimationOn() : Boolean
		{
			return GamePersistantData.bonusTimer <= this.WARNING_TIMER_THRESHOLD && GamePersistantData.bonusTimer > 0;
		}
		
		public function show() : void
		{
			this._assets.visible = true;
		}
		
		public function hide() : void
		{
			this._assets.visible = false;
		}
		
		public function displayBombBonus(posX:Number, posY:Number) : void
		{
			var bonus:MovieClip = FlashUtil.getLibraryItem(this._assets,"BombBonusMc") as MovieClip;
			this._assets.addChild(bonus);
			bonus.x = posX;
			bonus.y = posY;
			bonus.bonusMc.bonusTxt.text = GameConstants.scoreBomb.toString();
			eaze(bonus).play("bonusStart>bonusEnd").onComplete(this.onBonusAnimationFinished,bonus);
		}
		
		public function displayMiniBossBonus(posX:Number, posY:Number) : void
		{
			var bonus:MovieClip = FlashUtil.getLibraryItem(this._assets,"MiniBossBonusMc") as MovieClip;
			this._assets.addChild(bonus);
			bonus.x = posX;
			bonus.y = posY;
			bonus.bonusMc.bonusTxt.text = GameConstants.scoreMiniBoss.toString();
			eaze(bonus).play("bonusStart>bonusEnd").onComplete(this.onBonusAnimationFinished,bonus);
		}
		
		private function onBonusAnimationFinished(target:MovieClip) : void
		{
			this._assets.removeChild(target);
		}
		
		public function setLives(num:uint) : void
		{
			var mc:MovieClip = null;
			var frameToPlay:String = null;
			for(var i:uint = 0; i < GameConstants.livesInitNum; i++)
			{
				mc = this._assets["life" + i];
				frameToPlay = i < num?"on":"off";
				mc.gotoAndPlay(frameToPlay);
			}
		}
		
		public function setBonusTimer(value:int) : void
		{
			var currentTime:uint = int(this._timer.bonusTimerAnimMc.bonusTimerTxt.text);
			this._timer.bonusTimerAnimMc.bonusTimerTxt.text = value.toString();
			if(value > this.WARNING_TIMER_THRESHOLD || value <= 0)
			{
				this.stopBonusTimerAnimation();
			}
			else if(currentTime > this.WARNING_TIMER_THRESHOLD && value <= this.WARNING_TIMER_THRESHOLD)
			{
				this.startBonusTimerAnimation();
			}
		}
		
		private function startBonusTimerAnimation() : void
		{
			this._timer.gotoAndPlay("warning");
		}
		
		public function stopBonusTimerAnimation() : void
		{
			this._timer.gotoAndPlay("normal");
		}
		
		public function setHighScore(score:int) : void
		{
			this._assets.highScoreTxt.text = score.toString();
		}
		
		public function setScore(score:int) : void
		{
			this._assets.scoreTxt.text = score.toString();
		}
		
		public function transferBonusToScore() : void
		{
			AnimationUtil.transferTextfieldValue(this.BONUS_TRANSFER_DURATION,this._timer.bonusTimerAnimMc.bonusTimerTxt,this._assets.scoreTxt);
		}
		
		public function pause() : void
		{
			this._assets.player1Mc.stop();
			if(this.timerWarningAnimationOn)
			{
				this._timer.stop();
			}
		}
		
		public function resume() : void
		{
			this._assets.player1Mc.play();
			if(this.timerWarningAnimationOn)
			{
				this._timer.play();
			}
		}
	}
}
