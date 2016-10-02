package bhvr.data
{
	import bhvr.views.Character;
	
	public class EnemySpawnData
	{
		 
		
		public var id:String;
		
		public var spawnMinDelay:Number;
		
		public var spawnMaxDelay:Number;
		
		public var spawnDelayOffsetMax:Number;
		
		public var spawnDelayOffsetMod:Number;
		
		public function EnemySpawnData()
		{
			super();
			this.id = Character.ENEMY_GRUNT_ID;
			this.spawnMinDelay = 10000;
			this.spawnMaxDelay = this.spawnMinDelay;
			this.spawnDelayOffsetMax = 0;
			this.spawnDelayOffsetMod = 0;
		}
	}
}
