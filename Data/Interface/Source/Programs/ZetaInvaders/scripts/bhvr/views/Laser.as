package bhvr.views
{
	import flash.events.EventDispatcher;
	import flash.display.MovieClip;
	import flash.geom.Point;
	import bhvr.constatnts.GameConstants;
	import aze.motion.eaze;
	import bhvr.utils.FlashUtil;
	import aze.motion.easing.Linear;
	import bhvr.manager.SoundManager;
	import bhvr.data.SoundList;
	import bhvr.events.EventWithParams;
	import bhvr.events.GameEvents;
	
	public class Laser extends EventDispatcher
	{
		 
		
		private var _assets:MovieClip;
		
		private var _collider:MovieClip;
		
		private var _projectileContainer:MovieClip;
		
		private var _leftPositionLimit:Number;
		
		private var _rightPositionLimit:Number;
		
		private var _projectile:bhvr.views.LaserProjectile;
		
		public function Laser(assets:MovieClip, projectileContainer:MovieClip)
		{
			super();
			this._assets = assets;
			this._collider = this._assets.laserViewMc;
			this._projectileContainer = projectileContainer;
			this._leftPositionLimit = GameConstants.GAME_ZONE_AREA.x + this._assets.width / 2;
			this._rightPositionLimit = GameConstants.GAME_ZONE_AREA.x + GameConstants.GAME_ZONE_AREA.width - this._assets.width / 2;
			this._projectile = new bhvr.views.LaserProjectile(this._assets);
		}
		
		public function get collider() : MovieClip
		{
			return this._collider;
		}
		
		public function get projectile() : bhvr.views.LaserProjectile
		{
			return this._projectile;
		}
		
		public function get canShoot() : Boolean
		{
			return this._projectileContainer.numChildren == 0;
		}
		
		public function get position() : Point
		{
			return new Point(this._assets.x,this._assets.y);
		}
		
		public function set position(pt:Point) : void
		{
			this._assets.x = pt.x;
			this._assets.y = pt.y;
		}
		
		public function get height() : Number
		{
			return this._assets.height;
		}
		
		public function moveLeft() : void
		{
			var nextPosition:Number = Math.max(this._leftPositionLimit,this._assets.x - GameConstants.playerSpeed);
			this._assets.x = nextPosition;
		}
		
		public function moveRight() : void
		{
			var nextPosition:Number = Math.min(this._rightPositionLimit,this._assets.x + GameConstants.playerSpeed);
			this._assets.x = nextPosition;
		}
		
		public function terminateShoot() : void
		{
			eaze(this._projectile).killTweens();
			this.removeProjectile();
		}
		
		public function shootBarn(barn:Barn, barnPiece:MovieClip) : void
		{
			this.addProjectile();
			var piecePos:Point = FlashUtil.localToGlobalPosition(barnPiece);
			var distance:Number = this._projectile.y - piecePos.y;
			var duration:Number = distance / GameConstants.playerProjectileSpeed;
			eaze(this._projectile).to(duration,{"y":piecePos.y}).easing(Linear.easeNone).onComplete(this.onBarnReached,barn,barnPiece);
			SoundManager.instance.playSound(SoundList.LASER_FIRE_SOUND);
		}
		
		public function shootAliens(continueShooting:Boolean = false) : void
		{
			if(!continueShooting)
			{
				this.addProjectile();
				SoundManager.instance.playSound(SoundList.LASER_FIRE_SOUND);
			}
			var distance:Number = this._projectile.y - GameConstants.GAME_ZONE_AREA.y;
			var duration:Number = distance / GameConstants.playerProjectileSpeed;
			eaze(this._projectile).to(duration,{"y":GameConstants.GAME_ZONE_AREA.y}).easing(Linear.easeNone).onUpdate(this.onShooting,this._projectile).onComplete(this.onShootFail);
		}
		
		private function onBarnReached(barn:Barn, barnPiece:MovieClip) : void
		{
			dispatchEvent(new EventWithParams(GameEvents.LASER_SHOOT_BARN,{
				"barn":barn,
				"piece":barnPiece,
				"posX":this._projectile.x
			}));
		}
		
		private function onShooting(projectile:bhvr.views.LaserProjectile) : void
		{
			dispatchEvent(new EventWithParams(GameEvents.LASER_SHOOTING_ALIENS,{"target":this._projectile}));
		}
		
		private function onShootFail() : void
		{
			this.terminateShoot();
		}
		
		public function kill() : void
		{
			this._collider = null;
			eaze(this._assets.laserViewMc).play("explosionStart>explosionEnd").onComplete(this.onLaserKilled);
			SoundManager.instance.playSound(SoundList.LASER_EXPLOSION_SOUND);
		}
		
		private function onLaserKilled() : void
		{
			dispatchEvent(new EventWithParams(GameEvents.LASER_DESTROYED));
		}
		
		public function respawn() : void
		{
			this.removeProjectile();
			eaze(this._assets.laserViewMc).play("respawnStart>respawnEnd").onComplete(this.onLaserRespawned);
		}
		
		private function onLaserRespawned() : void
		{
			this._collider = this._assets.laserViewMc;
			dispatchEvent(new EventWithParams(GameEvents.LASER_RESPAWNED));
		}
		
		private function addProjectile() : void
		{
			this._projectileContainer.addChild(this._projectile);
			this._projectile.x = this._assets.x;
			this._projectile.y = this._assets.y;
		}
		
		private function removeProjectile() : void
		{
			if(this._projectileContainer.numChildren > 0)
			{
				this._projectileContainer.removeChild(this._projectile);
			}
		}
		
		public function reset() : void
		{
			this._collider = this._assets.laserViewMc;
			this._assets.laserViewMc.gotoAndStop(0);
		}
		
		public function dispose() : void
		{
			this._assets = null;
			this._collider = null;
			this._projectileContainer = null;
		}
	}
}
