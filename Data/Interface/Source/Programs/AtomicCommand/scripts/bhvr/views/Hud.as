package bhvr.views
{
	import flash.display.MovieClip;
	import bhvr.data.GamePersistantData;
	import bhvr.data.LocalizationStrings;
	import bhvr.constatnts.GameConstants;
	
	public class Hud
	{
		 
		
		private var _assets:MovieClip;
		
		public function Hud(assets:MovieClip)
		{
			super();
			this._assets = assets;
		}
		
		public function show() : void
		{
			this._assets.visible = true;
		}
		
		public function hide() : void
		{
			this._assets.visible = false;
		}
		
		public function setScore(score:int) : void
		{
			var multiplierString:String = GamePersistantData.gameScore.multiplier > 1?"(x" + GamePersistantData.gameScore.multiplier + ")":"";
			this._assets.scoreTxt.text = LocalizationStrings.SCORE_LABEL + multiplierString + ": " + score;
		}
		
		public function setNukeCounter(num:int) : void
		{
			this._assets.nukeTxt.text = LocalizationStrings.NUKE_LABEL + ": " + num.toString();
		}
		
		public function setLevel(lvl:int) : void
		{
			this._assets.lvlTxt.text = LocalizationStrings.LVL_LABEL + ": " + lvl.toString();
		}
		
		public function setMissileCounter(num:int) : void
		{
			var mc:MovieClip = null;
			var missileNum:int = Math.min(num,GameConstants.maxMissileNumber);
			for(var i:uint = 0; i < GameConstants.maxMissileNumber; i++)
			{
				mc = this._assets.missileCounterMc["missile" + i];
				if(mc != null)
				{
					mc.visible = i < missileNum;
				}
			}
		}
	}
}
