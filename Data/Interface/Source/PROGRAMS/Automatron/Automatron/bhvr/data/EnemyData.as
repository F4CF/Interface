package bhvr.data
{
	import bhvr.views.Character;
	
	public class EnemyData
	{
		 
		
		public var id:String;
		
		public var name:String;
		
		public var linkageId:String;
		
		public var speed:Number;
		
		public var points:int;
		
		public var displayPointsOnScreen:Boolean;
		
		public var mustBeKilled:Boolean;
		
		public var bulletData:bhvr.data.EnemyBulletData;
		
		public var spawnData:bhvr.data.EnemySpawnData;
		
		public var pathData:bhvr.data.EnemyPathData;
		
		public function EnemyData()
		{
			super();
			this.id = Character.ENEMY_GRUNT_ID;
			this.name = "No Name";
			this.linkageId = "None";
			this.speed = 0;
			this.points = 0;
			this.displayPointsOnScreen = false;
			this.mustBeKilled = false;
			this.bulletData = new bhvr.data.EnemyBulletData();
			this.pathData = new bhvr.data.EnemyPathData();
			this.spawnData = new bhvr.data.EnemySpawnData();
		}
	}
}
