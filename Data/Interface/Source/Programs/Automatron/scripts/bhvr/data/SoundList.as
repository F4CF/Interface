package bhvr.data
{
	public class SoundList
	{
		
		public static const NAV_CONTINUE_SOUND:String = "DLC01UIGamePipboyAutomatronContinue";
		
		public static const NAV_START_GAME_SOUND:String = "DLC01UIGamePipboyAutomatronStartGame";
		
		public static const LEVEL_TRANSITION_SOUND:String = "DLC01UIGamePipboyAutomatronNextLevel";
		
		public static const ENEMIES_INIT_SPAWN_SOUND:String = "DLC01UIGamePipboyAutomatronInitSpawnEnemies";
		
		public static const HERO_INIT_SPAWN_SOUND:String = "DLC01UIGamePipboyAutomatronInitSpawnPlayer";
		
		public static const HERO_BULLET_FIRE_SOUND:String = "DLC01UIGamePipboyAutomatronFirePlayer";
		
		public static const HERO_BULLET_EXPLOSION_SOUND:String = "DLC01UIGamePipboyAutomatronFireExplosionPlayer";
		
		public static const HERO_DAMAGE_SOUND:String = "DLC01UIGamePipboyAutomatronDeathPlayer";
		
		public static const HERO_DEATH_SOUND:String = "DLC01UIGamePipboyAutomatronDeathPlayer";
		
		public static const ENEMY_DEATH_SOUND:String = "DLC01UIGamePipboyAutomatronDeathEnemy";
		
		public static const ENEMY_MINE_EXPLOSION_SOUND:String = "DLC01UIGamePipboyAutomatronExplosionMine";
		
		public static const ENEMY_BULLET_FIRE_SOUND:String = "DLC01UIGamePipboyAutomatronFireEnemy";
		
		public static const ENEMY_BULLET_EXPLOSION_SOUND:String = "DLC01UIGamePipboyAutomatronFireExplosionEnemy";
		
		public static const ENEMY_SPAWN_SOUND:String = "DLC01UIGamePipboyAutomatronSpawnEnemy";
		
		public static const HUMAN_DEATH_SOUND:String = "DLC01UIGamePipboyAutomatronDeathHuman";
		
		public static const HUMAN_TRANSFORM_ENEMY_SOUND:String = "DLC01UIGamePipboyAutomatronTransformedHuman";
		
		public static const HUMAN_SAVED_SOUND:String = "DLC01UIGamePipboyAutomatronSavedHuman";
		
		public static const TITLE_MUSIC_LOOP_SOUND:String = "DLC01UIGamePipboyAutomatronTitleLP";
		
		public static const TITLE_MUSIC_LOOP_SOUND_ID:uint = 0;
		
		public static const LEVEL_MUSIC_LOOP_SOUND:String = "DLC01UIGamePipboyAutomatronLevelLP";
		
		public static const LEVEL_MUSIC_LOOP_SOUND_ID:uint = 1;
		
		private static const _soundsToRegister:Vector.<String> = new <String>[TITLE_MUSIC_LOOP_SOUND,LEVEL_MUSIC_LOOP_SOUND];
		 
		
		public function SoundList()
		{
			super();
		}
		
		public static function get soundsToRegister() : Vector.<String>
		{
			return _soundsToRegister;
		}
	}
}
