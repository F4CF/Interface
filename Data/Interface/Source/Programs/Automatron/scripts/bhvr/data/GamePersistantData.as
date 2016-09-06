package bhvr.data
{
	import bhvr.constants.GameConstants;
	
	public class GamePersistantData
	{
		
		private static var _highScore:int = 0;
		
		private static var _level:uint;
		
		public static var maxLevel:uint;
		
		private static var _lifeNum:uint;
		
		private static var _gameScore:bhvr.data.GameScore;
		
		private static var _tutorialShown:Boolean = false;
		 
		
		public function GamePersistantData()
		{
			super();
		}
		
		public static function get highScore() : int
		{
			return _highScore;
		}
		
		public static function set highScore(param1:int) : void
		{
			_highScore = param1;
		}
		
		public static function get level() : uint
		{
			return _level;
		}
		
		public static function get round() : uint
		{
			if(maxLevel == 0)
			{
				throw new Error("GamePersistantData::MaxLevel can\'t be 0");
			}
			return Math.ceil(_level / maxLevel);
		}
		
		public static function get lifeNum() : uint
		{
			return _lifeNum;
		}
		
		public static function get gameScore() : bhvr.data.GameScore
		{
			return _gameScore;
		}
		
		public static function get totalScore() : int
		{
			return _gameScore.score;
		}
		
		public static function get tutorialShown() : Boolean
		{
			return _tutorialShown;
		}
		
		public static function set tutorialShown(param1:Boolean) : void
		{
			_tutorialShown = param1;
		}
		
		public static function reset() : void
		{
			_level = 1;
			_lifeNum = GameConstants.heroStartLifeNum;
			_gameScore = new bhvr.data.GameScore();
		}
		
		public static function proceedNextLevel() : void
		{
			_gameScore.resetCombo();
			_level++;
		}
		
		public static function removeLife() : void
		{
			if(_lifeNum > 0)
			{
				_lifeNum--;
			}
		}
		
		public static function addLife() : void
		{
			_lifeNum++;
		}
	}
}
