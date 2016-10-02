package bhvr.data
{
	import bhvr.constants.GameConstants;
	
	public class LevelUpVariables
	{
		 
		
		public function LevelUpVariables()
		{
			super();
		}
		
		public static function getStage1BombFreq() : Number
		{
			return Math.max(GameConstants.stage1BombFreqLimit,GameConstants.stage1InitBombFreq * Math.pow(1 - GameConstants.stage1PerLevelBombFreq,GamePersistantData.level - 1));
		}
		
		public static function getStage1FlyingBombSpeed() : Number
		{
			return Math.min(GameConstants.stage1InitFlyingBombSpeed * Math.pow(1 + GameConstants.stage1PerLevelFlyingBombSpeed,GamePersistantData.level - 1),GameConstants.stage1FlyingBombSpeedLimit);
		}
		
		public static function getStage1RollingBombSpeed() : Number
		{
			return Math.min(GameConstants.stage1InitRollingBombSpeed * Math.pow(1 + GameConstants.stage1PerLevelRollingBombSpeed,GamePersistantData.level - 1),GameConstants.stage1RollingBombSpeedLimit);
		}
		
		public static function getStage1RollingBombLadderChance() : Number
		{
			return Math.min(GameConstants.stage1InitChanceLadder * Math.pow(1 + GameConstants.stage1PerLevelChanceLadder,GamePersistantData.level - 1),GameConstants.stage1ChanceLadderLimit);
		}
		
		public static function getStage2ConveyorSpeed() : Number
		{
			return Math.min(GameConstants.stage2InitConveyorSpeed * Math.pow(1 + GameConstants.stage2PerLevelConveyorSpeed,GamePersistantData.level - 1),GameConstants.stage2ConveyorSpeedLimit);
		}
		
		public static function getStage2BombFreq() : Number
		{
			return Math.max(GameConstants.stage2BombFreqLimit,GameConstants.stage2InitBombFreq * Math.pow(1 - GameConstants.stage2PerLevelBombFreq,GamePersistantData.level - 1));
		}
		
		public static function getStage3SpawnFreq() : Number
		{
			return GameConstants.miniBossInitSpawnFreq * Math.pow(1 - GameConstants.miniBossPerLevelSpawnFreq,GamePersistantData.level - 1);
		}
	}
}
