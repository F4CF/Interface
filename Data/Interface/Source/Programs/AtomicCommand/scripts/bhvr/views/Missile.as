package bhvr.views
{
	import flash.display.MovieClip;
	import bhvr.manager.SoundManager;
	import bhvr.data.SoundList;
	import aze.motion.eaze;
	import bhvr.constatnts.GameConstants;
	import aze.motion.easing.Linear;
	import bhvr.events.EventWithParams;
	import bhvr.events.GameEvents;
	import flash.geom.Point;
	
	public class Missile extends Projectile
	{
		 
		
		private var _projectileView:MovieClip;
		
		private var _targetView:MovieClip;
		
		private var _victims:int;
		
		public function Missile(flashAssets:MovieClip, type:int)
		{
			super(flashAssets,type);
			this._projectileView = _projectile.missileViewMc;
			this._targetView = _projectile.targetViewMc;
			this._targetView.visible = false;
			_collider = _projectile.missileColliderMc as MovieClip;
			_collider.visible = false;
			_collider.width = GameConstants.MISSILE_MIN_RADIUS * 2;
			_collider.height = GameConstants.MISSILE_MIN_RADIUS * 2;
			this._victims = 0;
		}
		
		public function get projectileView() : MovieClip
		{
			return this._projectileView;
		}
		
		public function get targetView() : MovieClip
		{
			return this._targetView;
		}
		
		public function get victims() : int
		{
			return this._victims;
		}
		
		public function set victims(value:int) : void
		{
			this._victims = value;
		}
		
		override public function explode() : void
		{
			this._projectileView.visible = false;
			this._targetView.visible = false;
			_smokeView.visible = false;
			if(_collider)
			{
				_collider.x = this._projectileView.x;
				_collider.y = this._projectileView.y;
				_collider.visible = true;
				SoundManager.instance.playSound(SoundList.MISSILE_EXPLOSION_SOUND);
				eaze(_collider).to(GameConstants.missileExplosionSpeed / 2,{
					"width":GameConstants.missileMaxRadius * 2,
					"height":GameConstants.missileMaxRadius * 2
				}).easing(Linear.easeNone).onUpdate(this.onProjectileExploding).to(GameConstants.missileExplosionSpeed / 2,{
					"width":GameConstants.MISSILE_MIN_RADIUS * 2,
					"height":GameConstants.MISSILE_MIN_RADIUS * 2
				}).easing(Linear.easeNone).onUpdate(this.onProjectileExploding).onComplete(this.onProjectileExploded);
			}
			else
			{
				this.onProjectileExploded();
			}
		}
		
		private function onProjectileExploding() : void
		{
			dispatchEvent(new EventWithParams(GameEvents.MISSILE_EXPLODING,{"target":this}));
		}
		
		private function onProjectileExploded() : void
		{
			if(_collider)
			{
				_collider.visible = false;
			}
			dispatchEvent(new EventWithParams(GameEvents.MISSILE_EXPLODED,{"target":this}));
		}
		
		public function setInitialProperties(position:Point, rotation:Number) : void
		{
			this._projectileView.x = position.x;
			this._projectileView.y = position.y;
			this._projectileView.rotation = rotation;
			_smokeView.graphics.clear();
			_smokeView.graphics.lineStyle(1,14540253);
			_smokeView.graphics.moveTo(position.x,position.y);
		}
		
		public function setTargetPosition(pos:Point) : void
		{
			this._targetView.x = pos.x;
			this._targetView.y = pos.y;
			this._targetView.visible = true;
		}
		
		override public function dispose() : void
		{
			this._projectileView = null;
			this._targetView = null;
			super.dispose();
		}
	}
}
