package bhvr.views
{
	import flash.display.MovieClip;
	import flash.geom.Point;
	import aze.motion.eaze;
	import bhvr.manager.SoundManager;
	import bhvr.data.SoundList;
	import bhvr.events.EventWithParams;
	import bhvr.events.GameEvents;
	
	public class Nuke extends Projectile
	{
		 
		
		private var _projectileView:MovieClip;
		
		private var _id:int;
		
		private var _target:bhvr.views.Target;
		
		private var _parentRef:bhvr.views.Nuke;
		
		private var _childActiveNum:int;
		
		private var _splitNum:int;
		
		private var _splitHeight:Number;
		
		public function Nuke(flashAssets:MovieClip, type:int)
		{
			super(flashAssets,type);
			this._projectileView = _projectile.nukeViewMc;
			_collider = this._projectileView;
		}
		
		public function get projectileView() : MovieClip
		{
			return this._projectileView;
		}
		
		public function get id() : int
		{
			return this._id;
		}
		
		public function set id(value:int) : void
		{
			this._id = value;
		}
		
		public function get target() : bhvr.views.Target
		{
			return this._target;
		}
		
		public function set target(value:bhvr.views.Target) : void
		{
			this._target = value;
		}
		
		public function get parentRef() : bhvr.views.Nuke
		{
			return this._parentRef;
		}
		
		public function set parentRef(value:bhvr.views.Nuke) : void
		{
			this._parentRef = value;
		}
		
		public function get childActiveNum() : int
		{
			return this._childActiveNum;
		}
		
		public function set childActiveNum(value:int) : void
		{
			this._childActiveNum = value;
			if(this._childActiveNum == 0)
			{
				if(this._projectileView)
				{
					this.explode();
				}
			}
		}
		
		public function get splitNum() : int
		{
			return this._splitNum;
		}
		
		public function set splitNum(value:int) : void
		{
			this._splitNum = value;
		}
		
		public function get splitHeight() : Number
		{
			return this._splitHeight;
		}
		
		public function set splitHeight(value:Number) : void
		{
			this._splitHeight = value;
		}
		
		public function get collisionPoints() : Vector.<Point>
		{
			var child:MovieClip = null;
			var pts:Vector.<Point> = new Vector.<Point>();
			for(var i:uint = 0; i < this._projectileView.numChildren; i++)
			{
				if(this._projectileView.getChildAt(i) is MovieClip)
				{
					child = this._projectileView.getChildAt(i) as MovieClip;
					pts.push(new Point(child.x,child.y));
				}
			}
			return pts;
		}
		
		public function setInitialProperties(position:Point, rotation:Number) : void
		{
			this._projectileView.x = position.x;
			this._projectileView.y = position.y;
			this._projectileView.rotation = rotation;
			_smokeView.graphics.clear();
			_smokeView.graphics.lineStyle(1,16777215);
			_smokeView.graphics.moveTo(position.x,position.y);
		}
		
		override public function explode() : void
		{
			this._projectileView.visible = false;
			_smokeView.visible = false;
			if(_collider)
			{
				_projectile.nukeExplosionMc.x = this._projectileView.x;
				_projectile.nukeExplosionMc.y = this._projectileView.y;
				eaze(_projectile.nukeExplosionMc).play("start>end").onComplete(this.onProjectileExploded);
			}
			else
			{
				this.onProjectileExploded();
			}
		}
		
		public function destroy() : void
		{
			this._projectileView.visible = false;
			_smokeView.visible = false;
			SoundManager.instance.playSound(SoundList.NUKE_DESTROYED_SOUND);
			_collider = null;
			_projectile.nukeExplosionMc.x = this._projectileView.x;
			_projectile.nukeExplosionMc.y = this._projectileView.y;
			eaze(_projectile.nukeExplosionMc).play("start>end").onComplete(this.onProjectileDestroyed);
		}
		
		public function split() : void
		{
			this._projectileView.visible = false;
			_collider = null;
			this._childActiveNum = this._splitNum;
			SoundManager.instance.playSound(SoundList.NUKE_SPLIT_SOUND);
			_projectile.splitExplosionMc.x = this._projectileView.x;
			_projectile.splitExplosionMc.y = this._projectileView.y;
			eaze(_projectile.splitExplosionMc).play("start>end");
		}
		
		private function onProjectileExploded() : void
		{
			dispatchEvent(new EventWithParams(GameEvents.NUKE_EXPLODED,{"target":this}));
		}
		
		private function onProjectileDestroyed() : void
		{
			dispatchEvent(new EventWithParams(GameEvents.NUKE_DESTROYED,{"target":this}));
		}
		
		override public function dispose() : void
		{
			this._projectileView = null;
			super.dispose();
		}
	}
}
