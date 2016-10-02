package bhvr.data
{
	import bhvr.constants.GameConstants;
	
	public class GamePersistantData
	{
		
		private static var _highScore:int = 0;
		
		private static var _lifeNum:uint;
		
		private static var _bobbleHeadNum:uint;
		
		private static var _timeRemaining:uint;
		
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
		
		public static function get lifeNum() : uint
		{
			return _lifeNum;
		}
		
		public static function get bobbleHeadNum() : uint
		{
			return _bobbleHeadNum;
		}
		
		public static function set timeRemaining(value:uint) : void
		{
			_timeRemaining = value;
		}
		
		public static function get timeRemaining() : uint
		{
			return _timeRemaining;
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
			_lifeNum = GameConstants.livesInitNum;
			_bobbleHeadNum = 0;
			_timeRemaining = GameConstants.maxTime;
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
			if(_lifeNum < GameConstants.livesMaxNum)
			{
				_lifeNum++;
			}
		}
		
		public static function addBobbleHead() : void
		{
			if(_bobbleHeadNum < GameConstants.numBobbleHead)
			{
				_bobbleHeadNum++;
			}
		}
	}
}
