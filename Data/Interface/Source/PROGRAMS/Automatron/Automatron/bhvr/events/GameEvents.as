package bhvr.events
{
	public class GameEvents
	{
		
		public static const GAME_STARTED:String = "GameStarted";
		
		public static const GAME_LEVEL_UP:String = "GameLevelUp";
		
		public static const GAME_OVER:String = "GameOver";
		
		public static const HERO_MISSILE_EXPLODED:String = "HeroMissileExploded";
		
		public static const ENEMY_MISSILE_EXPLODED:String = "EnemyMissileExploded";
		
		public static const ENEMY_KILLED:String = "EnemyKilled";
		
		public static const ALL_ENEMIES_KILLED:String = "AllEnemiesKilled";
		
		public static const HERO_DAMAGED:String = "HeroDamaged";
		
		public static const HERO_DAMAGED_END:String = "HeroDamagedEnd";
		
		public static const HERO_DEAD:String = "HeroDead";
		
		public static const HERO_DEAD_END:String = "HeroDeadEnd";
		
		public static const ENEMY_SPAWN_REQUEST:String = "EnemySpawnRequest";
		
		public static const HUMAN_KILLED:String = "HumanKilled";
		
		public static const HUMAN_SAVED:String = "HumanSaved";
		
		public static const ENEMY_BULLET_DESTROYED:String = "EnemyBulletDestroyed";
		
		public static const ENEMY_SPAWN_FINISHED:String = "EnemySpawnFinished";
		
		public static const ALL_ENEMIES_SPAWN_FINISHED:String = "AllEnemiesSpawnFinished";
		
		public static const HERO_SPAWN_FINISHED:String = "HeroSpawnFinished";
		 
		
		public function GameEvents()
		{
			super();
		}
	}
}
