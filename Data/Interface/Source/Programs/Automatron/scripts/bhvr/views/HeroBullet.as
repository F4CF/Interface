package bhvr.views
{
	import bhvr.manager.SoundManager;
	import bhvr.data.SoundList;
	import aze.motion.eaze;
	import bhvr.events.EventWithParams;
	import bhvr.events.GameEvents;
	import flash.display.MovieClip;
	
	public class HeroBullet extends Bullet
	{
		 
		
		private const HERO_BULLET_LINKAGE_ID:String = "HeroBulletMc";
		
		public function HeroBullet(param1:MovieClip)
		{
			super(param1,this.HERO_BULLET_LINKAGE_ID);
			_collider = _mainObject.colliderMc;
		}
		
		override public function setDirectionValues(param1:Number, param2:Number) : void
		{
			_deltaX = param1;
			_deltaY = param2;
		}
		
		override public function explode() : void
		{
			_collider = null;
			SoundManager.instance.playSound(SoundList.HERO_BULLET_EXPLOSION_SOUND);
			eaze(_mainObject).play("explosionStart>explosionEnd").onComplete(this.onExplosionFinished);
		}
		
		private function onExplosionFinished() : void
		{
			dispatchEvent(new EventWithParams(GameEvents.HERO_MISSILE_EXPLODED,{"target":this}));
		}
	}
}
