package bhvr.data
{
	public class LevelUpVariables
	{
		 
		
		public function LevelUpVariables()
		{
			super();
		}
		
		public static function getEnemySpeed(param1:EnemyPathData) : Number
		{
			return Math.min(param1.speedMin * Math.pow(1 + param1.speedMod,GamePersistantData.round - 1),param1.speedMax);
		}
		
		public static function getEnemyBulletSpeed(param1:EnemyBulletData) : Number
		{
			return Math.min(param1.speedMin * Math.pow(1 + param1.speedMod,GamePersistantData.round - 1),param1.speedMax);
		}
		
		public static function getEnemyBulletIntervallOffset(param1:EnemyBulletData) : Number
		{
			return Math.min(Math.pow(1 + param1.fireDelayOffsetMod,GamePersistantData.round - 1) - 1,param1.fireDelayOffsetMax);
		}
		
		public static function getEnemySpawnIntervallOffset(param1:EnemySpawnData) : Number
		{
			return Math.min(Math.pow(1 + param1.spawnDelayOffsetMod,GamePersistantData.round - 1) - 1,param1.spawnDelayOffsetMax);
		}
	}
}
