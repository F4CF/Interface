package bhvr.views
{
	import bhvr.manager.SoundManager;
	import bhvr.data.SoundList;
	import aze.motion.eaze;
	import bhvr.events.EventWithParams;
	import bhvr.events.GameEvents;
	import flash.display.MovieClip;
	
	public class EnemyBullet extends Bullet
	{
		 
		
		public function EnemyBullet(param1:MovieClip, param2:String)
		{
			super(param1,param2);
			_mainObject.viewMc.play();
		}
		
		override public function explode() : void
		{
			_collider = null;
			SoundManager.instance.playSound(SoundList.ENEMY_BULLET_EXPLOSION_SOUND);
			eaze(_mainObject).play("explosionStart>explosionEnd").onComplete(this.onExplosionFinished);
		}
		
		private function onExplosionFinished() : void
		{
			dispatchEvent(new EventWithParams(GameEvents.ENEMY_MISSILE_EXPLODED,{"target":this}));
		}
		
		public function pause() : void
		{
			if(_mainObject.viewMc != null)
			{
				_mainObject.viewMc.stop();
			}
		}
		
		public function resume() : void
		{
			if(_mainObject.viewMc != null)
			{
				_mainObject.viewMc.play();
			}
		}
	}
}
