package bhvr.data
{
	import bhvr.constants.GameConstants;
	
	public class GamePersistantData
	{
		
		public static const STAGE_1:uint = 0;
		
		public static const STAGE_2:uint = 1;
		
		public static const STAGE_3:uint = 2;
		
		private static var _lifeNum:uint;
		
		private static var _stage:uint;
		
		private static var _level:uint;
		
		private static var _highScore:int = 0;
		
		private static var _score:int;
		
		private static var _bonusTimer:int;
		
		private static var _tutorialShown:Boolean = false;
		 
		
		public function GamePersistantData()
		{
			super();
		}
		
		public static function get lifeNum() : uint
		{
			return _lifeNum;
		}
		
		public static function get stage() : uint
		{
			return _stage;
		}
		
		public static function get level() : uint
		{
			return _level;
		}
		
		public static function get highScore() : int
		{
			return _highScore;
		}
		
		public static function set highScore(value:int) : void
		{
			_highScore = value;
		}
		
		public static function get score() : int
		{
			return _score;
		}
		
		public static function get bonusTimer() : int
		{
			return _bonusTimer;
		}
		
		public static function get tutorialShown() : Boolean
		{
			return _tutorialShown;
		}
		
		public static function set tutorialShown(value:Boolean) : void
		{
			_tutorialShown = value;
		}
		
		public static function reset() : void
		{
			_level = 1;
			_stage = GamePersistantData.STAGE_1;
			_lifeNum = GameConstants.livesInitNum;
			_score = 0;
			resetBonusTimerPoints();
		}
		
		public static function removeLife() : void
		{
			if(_lifeNum > 0)
			{
				_lifeNum--;
			}
		}
		
		public static function addBombPoints() : void
		{
			_score = _score + GameConstants.scoreBomb;
		}
		
		public static function addMiniBossPoints() : void
		{
			_score = _score + GameConstants.scoreMiniBoss;
		}
		
		public static function removeBonusTimerPoints() : void
		{
			_bonusTimer = _bonusTimer - GameConstants.BonusTimerLostPerSecond;
		}
		
		public static function resetBonusTimerPoints() : void
		{
			_bonusTimer = GameConstants.BonusTimer;
		}
		
		public static function addBonusTimerPoints() : void
		{
			_score = _score + bonusTimer;
		}
		
		public static function proceedNextStage() : void
		{
			if(_stage < STAGE_3)
			{
				_stage++;
			}
			else
			{
				proceedNextLevel();
				_stage = STAGE_1;
			}
		}
		
		private static function proceedNextLevel() : void
		{
			_level++;
		}
	}
}
