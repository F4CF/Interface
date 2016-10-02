package bhvr.views
{
	import aze.motion.eaze;
	import bhvr.data.EnemySpawnData;
	import bhvr.data.LevelUpVariables;
	import bhvr.utils.MathUtil;
	import bhvr.events.EventWithParams;
	import bhvr.events.GameEvents;
	import flash.display.MovieClip;
	import bhvr.data.EnemyData;
	
	public class EnemySpheroid extends Enemy
	{
		 
		
		public function EnemySpheroid(param1:MovieClip, param2:EnemyData, param3:Boolean = false)
		{
			super(param1,param2,param3);
		}
		
		override public function start() : void
		{
			super.start();
			this.startDelayBeforeSpawning();
		}
		
		override public function stop() : void
		{
			super.stop();
			eaze(this).killTweens();
		}
		
		private function startDelayBeforeSpawning() : void
		{
			var _loc1_:EnemySpawnData = _enemyData.spawnData;
			var _loc2_:Number = LevelUpVariables.getEnemySpawnIntervallOffset(_loc1_);
			var _loc3_:Number = MathUtil.random(_loc1_.spawnMinDelay - _loc2_,_loc1_.spawnMaxDelay - _loc2_);
			eaze(this).delay(_loc3_).onComplete(this.spawn);
		}
		
		private function spawn() : void
		{
			dispatchEvent(new EventWithParams(GameEvents.ENEMY_SPAWN_REQUEST,{
				"target":this,
				"data":enemyData.spawnData
			}));
			this.startDelayBeforeSpawning();
		}
	}
}
