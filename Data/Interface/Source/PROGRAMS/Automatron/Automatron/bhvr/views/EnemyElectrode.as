package bhvr.views
{
	import bhvr.manager.SoundManager;
	import bhvr.data.SoundList;
	import flash.display.MovieClip;
	import bhvr.data.EnemyData;
	
	public class EnemyElectrode extends Enemy
	{
		 
		
		public function EnemyElectrode(param1:MovieClip, param2:EnemyData, param3:Boolean = false)
		{
			super(param1,param2,param3);
		}
		
		override protected function playExplosionSound() : void
		{
			SoundManager.instance.playSound(SoundList.ENEMY_MINE_EXPLOSION_SOUND);
		}
	}
}
