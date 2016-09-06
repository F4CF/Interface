package bhvr.views
{
	import flash.geom.Point;
	import bhvr.data.EnemyData;
	import flash.display.MovieClip;
	import bhvr.ai.Path;
	import bhvr.data.EnemyPathData;
	import bhvr.constants.GameConstants;
	import bhvr.data.LevelUpVariables;
	import bhvr.events.EventWithParams;
	import bhvr.events.GameEvents;
	import aze.motion.eaze;
	import bhvr.utils.MathUtil;
	import bhvr.manager.SoundManager;
	import bhvr.data.SoundList;
	import bhvr.controller.LevelController;
	
	public class Enemy extends Character
	{
		
		private static const NO_HUMAN_POSITION:Point = new Point(Number.MAX_VALUE,Number.MAX_VALUE);
		 
		
		protected var _enemyData:EnemyData;
		
		protected var _heroPosition:Point;
		
		protected var _bulletsContainer:MovieClip;
		
		public var _bullets:Vector.<bhvr.views.EnemyBullet>;
		
		protected var _deleteQueue:Boolean;
		
		protected var _path:Path;
		
		protected var _closestHumanPos:Point;
		
		protected var _spawnedByAnotherEnemy:Boolean;
		
		private const SPAWN_INITIAL_SCALE_X:Number = 0.1;
		
		private const SPAWN_INITIAL_SCALE_Y:Number = 5;
		
		private const SPAWN_INITIAL_ALPHA:Number = 0.1;
		
		public function Enemy(param1:MovieClip, param2:EnemyData, param3:Boolean = false)
		{
			this._enemyData = param2;
			this._spawnedByAnotherEnemy = param3;
			super(param1,this._enemyData.id,this._enemyData.linkageId);
		}
		
		public function get bullets() : Vector.<bhvr.views.EnemyBullet>
		{
			return this._bullets;
		}
		
		public function get enemyData() : EnemyData
		{
			return this._enemyData;
		}
		
		public function get canFire() : Boolean
		{
			return this._enemyData.bulletData != null;
		}
		
		public function get canMove() : Boolean
		{
			return this._enemyData.pathData.speedMin > 0;
		}
		
		override protected function initialize() : void
		{
			var _loc1_:EnemyPathData = null;
			_collider = _mainObject;
			this._deleteQueue = false;
			this._heroPosition = GameConstants.heroSpawnPosition;
			this._bullets = new Vector.<bhvr.views.EnemyBullet>();
			if(this.canFire)
			{
				this._bulletsContainer = new MovieClip();
				_container.addChild(this._bulletsContainer);
			}
			if(this.canMove)
			{
				_speed = LevelUpVariables.getEnemySpeed(this._enemyData.pathData);
				_loc1_ = this._enemyData.pathData;
				this._path = new Path(this,_loc1_.id,_loc1_.allowStop,_loc1_.changeDirMinDelay,_loc1_.changeDirMaxDelay,_loc1_.changeDirAfterStopDelay);
				this._path.addEventListener(Path.STOP_MOVING,this.onStopMoving,false,0,true);
				this._path.addEventListener(Path.MOVING_AFTER_STOP,this.onMovingAfterStop,false,0,true);
				this._path.addEventListener(Path.CHANGING_DIRECTION,this.onChangingDirection,false,0,true);
			}
			this.setState(STANDING_STATE);
		}
		
		public function reset() : void
		{
			this.removeBullets();
		}
		
		override public function start() : void
		{
			super.start();
			if(this._path != null)
			{
				this._path.start();
			}
			this.freezeBullets(false);
		}
		
		override public function stop() : void
		{
			super.stop();
			stopMoving();
			if(this._path != null)
			{
				this._path.stop();
			}
			this.freezeBullets(true);
		}
		
		public function sendHumanList(param1:Vector.<Human>) : void
		{
			var _loc2_:Number = NaN;
			var _loc3_:Number = Number.MAX_VALUE;
			this._closestHumanPos = NO_HUMAN_POSITION;
			var _loc4_:uint = 0;
			while(_loc4_ < param1.length)
			{
				_loc2_ = param1[_loc4_].position.subtract(position).length;
				if(_loc2_ < _loc3_)
				{
					_loc3_ = _loc2_;
					this._closestHumanPos = param1[_loc4_].position;
				}
				_loc4_++;
			}
		}
		
		override public function update(param1:Point) : void
		{
			if(_collider != null)
			{
				if(this.canMove)
				{
					this._heroPosition = param1;
					this.move();
				}
			}
			else if(this._deleteQueue && this._bullets.length == 0)
			{
				dispatchEvent(new EventWithParams(GameEvents.ENEMY_KILLED,{"target":this}));
			}
		}
		
		override public function playSpawnAnimation() : void
		{
			_mainObject.scaleX = this.SPAWN_INITIAL_SCALE_X;
			_mainObject.scaleY = this.SPAWN_INITIAL_SCALE_Y;
			_mainObject.alpha = this.SPAWN_INITIAL_ALPHA;
			eaze(_mainObject).to(GameConstants.enemySpawnAnimationDuration,{
				"scaleX":1,
				"scaleY":1,
				"alpha":1
			}).onComplete(this.onSpawnAnimationFinished);
		}
		
		private function onSpawnAnimationFinished() : void
		{
			dispatchEvent(new EventWithParams(GameEvents.ENEMY_SPAWN_FINISHED,{"target":this}));
		}
		
		override protected function setState(param1:uint) : void
		{
			var _loc2_:MovieClip = null;
			if(_state != param1)
			{
				_loc2_ = _mainObject.viewMc;
				switch(param1)
				{
					case STANDING_STATE:
					case STOP_STATE:
						_loc2_.gotoAndStop("stand");
						break;
					case MOVING_STATE:
						_loc2_.gotoAndPlay("walk");
						break;
					case DEATH_STATE:
						eaze(_mainObject).play("deathStart>deathEnd").onComplete(this.onEnemyDead);
				}
			}
			super.setState(param1);
		}
		
		protected function onStopMoving(param1:EventWithParams) : void
		{
			stopMoving();
		}
		
		protected function onMovingAfterStop(param1:EventWithParams) : void
		{
			this.setState(Character.MOVING_STATE);
		}
		
		protected function onChangingDirection(param1:EventWithParams) : void
		{
		}
		
		private function onEnemyDead() : void
		{
			if(!this.canFire || this._bullets != null && this._bullets.length == 0)
			{
				dispatchEvent(new EventWithParams(GameEvents.ENEMY_KILLED,{"target":this}));
			}
			else
			{
				this._deleteQueue = true;
			}
		}
		
		protected function move() : void
		{
			var _loc1_:Point = this._path.getNextPosition(this._heroPosition,this._enemyData.pathData.aggroRadius);
			setPosition(_loc1_.x,_loc1_.y);
		}
		
		protected function addBullet() : bhvr.views.EnemyBullet
		{
			var _loc1_:bhvr.views.EnemyBullet = new bhvr.views.EnemyBullet(_mainObject,this._enemyData.bulletData.linkageId);
			_loc1_.addEventListener(GameEvents.ENEMY_MISSILE_EXPLODED,this.onMissileExploded,false,0,true);
			this._bulletsContainer.addChild(_loc1_);
			_loc1_.x = position.x;
			_loc1_.y = position.y;
			_loc1_.rotation = MathUtil.getVerticalDegAngle(position,this._heroPosition);
			return _loc1_;
		}
		
		private function removeBullet(param1:bhvr.views.EnemyBullet) : void
		{
			var _loc2_:int = 0;
			if(param1 != null)
			{
				param1.removeEventListener(GameEvents.ENEMY_MISSILE_EXPLODED,this.onMissileExploded);
				_loc2_ = this._bulletsContainer.getChildIndex(param1);
				this._bulletsContainer.removeChild(param1);
				param1.dispose();
				this._bullets.splice(_loc2_,1);
			}
		}
		
		public function removeBullets() : void
		{
			if(this._bullets != null)
			{
				while(this._bullets.length > 0)
				{
					this.removeBullet(this._bullets[0]);
				}
			}
		}
		
		private function onMissileExploded(param1:EventWithParams) : void
		{
			var _loc2_:bhvr.views.EnemyBullet = param1.params.target as bhvr.views.EnemyBullet;
			this.removeBullet(_loc2_);
		}
		
		override public function destroy() : void
		{
			super.destroy();
			this.playExplosionSound();
			this.stop();
			this.setState(DEATH_STATE);
		}
		
		protected function playExplosionSound() : void
		{
			SoundManager.instance.playSound(SoundList.ENEMY_DEATH_SOUND);
		}
		
		private function freezeBullets(param1:Boolean) : void
		{
			var _loc2_:bhvr.views.EnemyBullet = null;
			var _loc3_:uint = 0;
			if(this._bullets != null && LevelController.active && _collider != null)
			{
				_loc3_ = 0;
				while(_loc3_ < this._bullets.length)
				{
					_loc2_ = this._bullets[_loc3_];
					if(param1)
					{
						_loc2_.pause();
					}
					else
					{
						_loc2_.resume();
					}
					_loc3_++;
				}
			}
		}
		
		override public function pause() : void
		{
			super.pause();
			if(_state == Character.MOVING_STATE)
			{
				if(_mainObject.viewMc != null)
				{
					_mainObject.viewMc.stop();
				}
			}
			this.freezeBullets(true);
		}
		
		override public function resume() : void
		{
			super.resume();
			if(_state == Character.MOVING_STATE)
			{
				if(_mainObject.viewMc != null)
				{
					_mainObject.viewMc.play();
				}
			}
			this.freezeBullets(false);
		}
		
		override public function dispose() : void
		{
			this.stop();
			eaze(_mainObject).killTweens();
			this.removeBullets();
			this._bullets = null;
			if(this._bulletsContainer != null)
			{
				_container.removeChild(this._bulletsContainer);
				this._bulletsContainer = null;
			}
			if(this._path != null)
			{
				this._path.removeEventListener(Path.STOP_MOVING,this.onStopMoving);
				this._path.removeEventListener(Path.MOVING_AFTER_STOP,this.onMovingAfterStop);
				this._path.removeEventListener(Path.CHANGING_DIRECTION,this.onChangingDirection);
				this._path = null;
			}
			super.dispose();
		}
	}
}
