package bhvr.views
{
	import flash.display.MovieClip;
	import bhvr.data.LocalizationStrings;
	import aze.motion.eaze;
	import bhvr.constatnts.GameConstants;
	import flash.geom.Point;
	import bhvr.utils.FlashUtil;
	
	public class Hud
	{
		
		public static const BONUS_MOTHERSHIP:String = "MothershipBonusMc";
		
		public static const BONUS_COW:String = "CowBonusMc";
		 
		
		private var _assets:MovieClip;
		
		public function Hud(assets:MovieClip)
		{
			super();
			this._assets = assets;
		}
		
		public function show() : void
		{
			this._assets.livesMc.livesTxt.text = LocalizationStrings.LIVES_LABEL;
			this._assets.visible = true;
		}
		
		public function hide() : void
		{
			this._assets.visible = false;
		}
		
		public function setScore(score:int) : void
		{
			this._assets.scoreTxt.text = LocalizationStrings.SCORE_LABEL + "  " + score;
		}
		
		public function setLives(num:uint, withAnimation:Boolean = false) : void
		{
			var mc:MovieClip = null;
			for(var i:uint = 0; i < GameConstants.MAX_NUMBER_OF_LIVES; i++)
			{
				mc = this._assets.livesMc["life" + i];
				if(i < num)
				{
					mc.laserViewMc.gotoAndStop(0);
					mc.visible = true;
				}
				else if(withAnimation)
				{
					eaze(mc.laserViewMc).play("removeLifeStart>removeLifeEnd").onComplete(this.hideLife,mc);
				}
				else
				{
					this.hideLife(mc);
				}
			}
		}
		
		private function hideLife(target:MovieClip) : void
		{
			target.visible = false;
		}
		
		public function displayBonusPoints(score:int, bonusType:String, spawnPos:Point) : void
		{
			var bonus:MovieClip = FlashUtil.getLibraryItem(this._assets,bonusType) as MovieClip;
			this._assets.addChild(bonus);
			bonus.x = spawnPos.x;
			bonus.y = spawnPos.y;
			bonus.bonusAnimMc.bonusTxt.text = score.toString();
			eaze(bonus).play("bonusStart>bonusEnd").onComplete(this.onBonusAnimationFinished,bonus);
		}
		
		private function onBonusAnimationFinished(target:MovieClip) : void
		{
			this._assets.removeChild(target);
		}
	}
}
