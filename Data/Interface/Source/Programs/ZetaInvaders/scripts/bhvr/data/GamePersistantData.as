package bhvr.data
{
	import bhvr.constatnts.GameConstants;
	
	public class GamePersistantData
	{
		
		private static var _highScore:int = 0;
		
		private static var _gameScore:bhvr.data.GameScore;
		
		private static var _lifeNum:uint;
		
		private static var _tutorialShown:Boolean = false;
		 
		
		public function GamePersistantData()
		{
			super();
		}
		
		public static function get highScore() : int
		{
			return _highScore;
		}
		
		public static function set highScore(value:int) : void
		{
			_highScore = value;
		}
		
		public static function get gameScore() : bhvr.data.GameScore
		{
			return _gameScore;
		}
		
		public static function get totalScore() : int
		{
			return _gameScore.score;
		}
		
		public static function get lifeNum() : uint
		{
			return _lifeNum;
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
			_gameScore = new bhvr.data.GameScore();
			_lifeNum = GameConstants.MAX_NUMBER_OF_LIVES;
		}
		
		public static function removeLife() : void
		{
			if(_lifeNum > 0)
			{
				_lifeNum--;
			}
		}
	}
}
