package bhvr.views
{
	import flash.display.MovieClip;
	import bhvr.data.GamePersistantData;
	import bhvr.data.LocalizationStrings;
	import bhvr.utils.FlashUtil;
	import aze.motion.eaze;
	import flash.geom.Point;
	import bhvr.constants.GameConstants;
	
	public class Hud
	{
		 
		
		private var _assets:MovieClip;
		
		private var _lifeContainer:MovieClip;
		
		private var _enemyFeedbackContainer:MovieClip;
		
		private var _humanFeedbackContainer:MovieClip;
		
		private const GAP_BETWEEN_LIFE_ICONS:uint = 4;
		
		private const LIFE_ICON_LINKAGE_ID:String = "HeroLifeMc";
		
		private const ENEMY_SCORE_LINKAGE_ID:String = "EnemyScoreMc";
		
		private const HUMAN_SCORE_LINKAGE_ID:String = "HumanScoreMc";
		
		private const HUMAN_DEATH_LINKAGE_ID:String = "HumanDeathMc";
		
		public function Hud(param1:MovieClip)
		{
			super();
			this._assets = param1;
			this._lifeContainer = this._assets.lifeContainerMc;
			this._enemyFeedbackContainer = new MovieClip();
			this._assets.addChild(this._enemyFeedbackContainer);
			this._humanFeedbackContainer = new MovieClip();
			this._assets.addChild(this._humanFeedbackContainer);
		}
		
		public function reset() : void
		{
			this.removeEnemyFeedbackObjects();
			this.removeHumanFeedbackObjects();
			this.setLevel(GamePersistantData.level);
			this.setScore(GamePersistantData.totalScore);
			this.setLifeNum(GamePersistantData.lifeNum);
		}
		
		public function setLevel(param1:uint) : void
		{
			this._assets.lvlTxt.text = LocalizationStrings.LVL_LABEL + " " + param1;
		}
		
		public function setScore(param1:int) : void
		{
			this._assets.scoreTxt.text = LocalizationStrings.SCORE_LABEL + " " + param1;
		}
		
		public function setLifeNum(param1:uint) : void
		{
			while(this._lifeContainer.numChildren > 0)
			{
				this._lifeContainer.removeChildAt(0);
			}
			var _loc2_:uint = 0;
			while(_loc2_ < param1 - 1)
			{
				this.addLife(false);
				_loc2_++;
			}
		}
		
		public function addLife(param1:Boolean = true) : void
		{
			var _loc2_:MovieClip = FlashUtil.getLibraryItem(this._assets,this.LIFE_ICON_LINKAGE_ID) as MovieClip;
			_loc2_.x = this._lifeContainer.width == 0?Number(0):Number(this._lifeContainer.width + this.GAP_BETWEEN_LIFE_ICONS);
			_loc2_.y = 0;
			this._lifeContainer.addChild(_loc2_);
			if(param1)
			{
				_loc2_.gotoAndPlay("add");
			}
		}
		
		public function removeLife(param1:Boolean = true) : void
		{
			var _loc2_:MovieClip = null;
			if(this._lifeContainer.numChildren > 0)
			{
				_loc2_ = this._lifeContainer.getChildAt(this._lifeContainer.numChildren - 1) as MovieClip;
				if(param1)
				{
					eaze(_loc2_).play("removeStart>removeEnd").onComplete(this.removeLifeIcon,_loc2_);
				}
				else
				{
					this.removeLifeIcon(_loc2_);
				}
			}
		}
		
		private function removeLifeIcon(param1:MovieClip) : void
		{
			this._lifeContainer.removeChild(param1);
		}
		
		public function displayEnemyScore(param1:int, param2:Point) : void
		{
			var _loc3_:MovieClip = FlashUtil.getLibraryItem(this._assets,this.ENEMY_SCORE_LINKAGE_ID) as MovieClip;
			this._enemyFeedbackContainer.addChild(_loc3_);
			_loc3_.x = param2.x;
			_loc3_.y = param2.y;
			_loc3_.scoreAnimMc.scoreTxt.text = "+" + param1.toString();
			eaze(_loc3_).play("scoreStart>scoreEnd").onComplete(this.onEnemyFeedbackFinished,_loc3_);
		}
		
		public function displayHumanScore(param1:int, param2:Point) : void
		{
			var _loc3_:MovieClip = FlashUtil.getLibraryItem(this._assets,this.HUMAN_SCORE_LINKAGE_ID) as MovieClip;
			this._humanFeedbackContainer.addChild(_loc3_);
			_loc3_.x = param2.x;
			_loc3_.y = param2.y;
			_loc3_.scoreAnimMc.scoreTxt.text = "+" + param1.toString();
			eaze(_loc3_).play("scoreStart>scoreEnd").onComplete(this.onHumanFeedbackFinished,_loc3_);
		}
		
		private function onEnemyFeedbackFinished(param1:MovieClip) : void
		{
			if(this._enemyFeedbackContainer != null && this._enemyFeedbackContainer.numChildren > 0)
			{
				this._enemyFeedbackContainer.removeChild(param1);
			}
		}
		
		public function displayHumanDeath(param1:Point) : void
		{
			var _loc2_:MovieClip = FlashUtil.getLibraryItem(this._assets,this.HUMAN_DEATH_LINKAGE_ID) as MovieClip;
			this._humanFeedbackContainer.addChild(_loc2_);
			_loc2_.x = param1.x;
			_loc2_.y = param1.y;
			eaze(_loc2_).delay(GameConstants.humanDeathSymbolDuration).onComplete(this.onHumanFeedbackFinished,_loc2_);
		}
		
		private function onHumanFeedbackFinished(param1:MovieClip) : void
		{
			if(this._humanFeedbackContainer != null && this._humanFeedbackContainer.numChildren > 0)
			{
				this._humanFeedbackContainer.removeChild(param1);
			}
		}
		
		private function removeEnemyFeedbackObjects() : void
		{
			while(this._enemyFeedbackContainer.numChildren > 0)
			{
				this._enemyFeedbackContainer.removeChildAt(0);
			}
		}
		
		private function removeHumanFeedbackObjects() : void
		{
			while(this._humanFeedbackContainer.numChildren > 0)
			{
				this._humanFeedbackContainer.removeChildAt(0);
			}
		}
		
		public function dispose() : void
		{
			this.removeEnemyFeedbackObjects();
			this.removeHumanFeedbackObjects();
			this._assets.removeChild(this._enemyFeedbackContainer);
			this._enemyFeedbackContainer = null;
			this._assets.removeChild(this._humanFeedbackContainer);
			this._humanFeedbackContainer = null;
		}
	}
}
