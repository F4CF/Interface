package bhvr.data
{
	import bhvr.constatnts.GameConstants;
	import bhvr.debug.Log;
	
	public class GamePersistantData
	{
		
		private static var _highScore:int = 0;
		
		private static var _level:uint;
		
		private static var _gameScore:bhvr.data.GameScore;
		
		private static var _extraLandmarkReceived:int;
		
		private static var _aliveLandmarks:Vector.<int>;
		
		private static var _destroyedLandmarks:Vector.<int>;
		
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
		
		public static function get level() : uint
		{
			return _level;
		}
		
		public static function get gameScore() : bhvr.data.GameScore
		{
			return _gameScore;
		}
		
		public static function get totalScore() : int
		{
			return _gameScore.score;
		}
		
		public static function get extraLandmarkReceived() : int
		{
			return _extraLandmarkReceived;
		}
		
		public static function get aliveLandmarks() : Vector.<int>
		{
			return _aliveLandmarks;
		}
		
		public static function get destroyedLandmarks() : Vector.<int>
		{
			return _destroyedLandmarks;
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
			_gameScore = new bhvr.data.GameScore();
			_extraLandmarkReceived = 0;
			_aliveLandmarks = new Vector.<int>();
			for(var i:int = 0; i < GameConstants.NUMBER_OF_LANDMARKS; i++)
			{
				_aliveLandmarks.push(i);
			}
			_destroyedLandmarks = new Vector.<int>();
		}
		
		public static function addLandmark(id:int) : void
		{
			if(id >= 0 && id < _destroyedLandmarks.length)
			{
				_aliveLandmarks.push(_destroyedLandmarks.splice(id,1));
				_aliveLandmarks.sort(Array.NUMERIC);
				_extraLandmarkReceived++;
			}
			else
			{
				Log.warn("GamePersistantData: Landmark id " + id + " is out of range");
			}
		}
		
		public static function removeLandmark(id:int) : void
		{
			var arrayId:int = getLandmark(id);
			if(arrayId != -1)
			{
				_destroyedLandmarks.push(_aliveLandmarks.splice(arrayId,1));
			}
			else
			{
				Log.warn("GamePersistantData: Landmark id=" + id + " seems to have been already destroyed");
			}
		}
		
		public static function proceedNextLevel() : void
		{
			_level++;
		}
		
		private static function getLandmark(id:int) : int
		{
			for(var i:int = 0; i < _aliveLandmarks.length; i++)
			{
				if(_aliveLandmarks[i] == id)
				{
					return i;
				}
			}
			return -1;
		}
	}
}
