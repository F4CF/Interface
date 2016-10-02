package bhvr.data
{
	import bhvr.constatnts.GameConstants;
	
	public class LevelUpVariables
	{
		 
		
		public function LevelUpVariables()
		{
			super();
		}
		
		public static function getStartingNukesNumber() : int
		{
			return Math.min(GameConstants.startingNukes + (GamePersistantData.level - 1) * GameConstants.nukeMod,GameConstants.maxStartingNukes);
		}
		
		public static function getNukeTimerInterval() : Number
		{
			return Math.max(GameConstants.minNukeInterval,GameConstants.maxNukeInterval * Math.pow(1 - GameConstants.nukeIntervalMod,GamePersistantData.level - 1));
		}
		
		public static function getNukeSpeed() : Number
		{
			return Math.min(GameConstants.minNukeSpeed * Math.pow(1 + GameConstants.nukeSpeedMod,GamePersistantData.level - 1),GameConstants.maxNukeSpeed);
		}
	}
}
