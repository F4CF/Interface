package bhvr.views
{
	import flash.geom.Point;
	import bhvr.data.LevelUpVariables;
	import aze.motion.eaze;
	import bhvr.utils.MathUtil;
	import bhvr.manager.SoundManager;
	import bhvr.data.SoundList;
	import bhvr.controller.LevelController;
	import bhvr.constants.GameConstants;
	import flash.display.MovieClip;
	import bhvr.data.EnemyData;
	
	public class EnemyEnforcer extends Enemy
	{
		
		public static const SPAWN_STATE:uint = DEATH_STATE + 1;
		 
		
		private var _spawned:Boolean;
		
		private var _heroVelocity:Point;
		
		private var _bulletSpeed:Number;
		
		public function EnemyEnforcer(param1:MovieClip, param2:EnemyData, param3:Boolean = false)
		{
			super(param1,param2,param3);
		}
		
		override protected function initialize() : void
		{
			this._spawned = false;
			this._heroVelocity = new Point(0,0);
			this._bulletSpeed = LevelUpVariables.getEnemyBulletSpeed(_enemyData.bulletData);
			super.initialize();
		}
		
		override public function start() : void
		{
			if(_spawnedByAnotherEnemy && !this._spawned)
			{
				this.setState(SPAWN_STATE);
			}
			else
			{
				this.onSpawned();
			}
		}
		
		override public function stop() : void
		{
			super.stop();
			eaze(this).killTweens();
		}
		
		override public function update(param1:Point) : void
		{
			if(this._spawned)
			{
				this._heroVelocity = new Point(param1.x - _heroPosition.x,param1.y - _heroPosition.y);
				super.update(param1);
				if(_bullets != null)
				{
					this.updateBulletsPosition();
				}
			}
		}
		
		override protected function setState(param1:uint) : void
		{
			if(_state != param1)
			{
				if(param1 == SPAWN_STATE)
				{
					eaze(_mainObject.viewMc).play("spawnStart>spawnEnd").onComplete(this.onSpawned);
				}
			}
			super.setState(param1);
		}
		
		private function onSpawned() : void
		{
			super.start();
			this._spawned = true;
			this.startDelayBeforeFiring();
		}
		
		private function startDelayBeforeFiring() : void
		{
			var _loc1_:Number = LevelUpVariables.getEnemyBulletIntervallOffset(_enemyData.bulletData);
			var _loc2_:Number = MathUtil.random(_enemyData.bulletData.fireMinDelay - _loc1_,_enemyData.bulletData.fireMaxDelay - _loc1_);
			eaze(this).delay(_loc2_).onComplete(this.fire);
		}
		
		private function fire() : void
		{
			SoundManager.instance.playSound(SoundList.ENEMY_BULLET_FIRE_SOUND);
			var _loc1_:EnemyBullet = addBullet();
			if(MathUtil.random(0,100) < _enemyData.bulletData.anticipationChances)
			{
				this.anticipateTarget(_loc1_);
			}
			else
			{
				this.aimTarget(_loc1_,_heroPosition);
			}
			_bullets.push(_loc1_);
			this.startDelayBeforeFiring();
		}
		
		private function anticipateTarget(param1:EnemyBullet) : void
		{
			var _loc8_:Number = NaN;
			var _loc9_:Point = null;
			var _loc10_:Number = NaN;
			var _loc11_:Number = NaN;
			var _loc12_:Number = NaN;
			var _loc2_:Number = _heroPosition.x - position.x;
			var _loc3_:Number = _heroPosition.y - position.y;
			var _loc4_:Number = this._heroVelocity.x * this._heroVelocity.x + this._heroVelocity.y * this._heroVelocity.y - this._bulletSpeed * this._bulletSpeed;
			var _loc5_:Number = 2 * (this._heroVelocity.x * _loc2_ + this._heroVelocity.y * _loc3_);
			var _loc6_:Number = _loc2_ * _loc2_ + _loc3_ * _loc3_;
			var _loc7_:Number = _loc5_ * _loc5_ - 4 * _loc4_ * _loc6_;
			if(_loc7_ < 0)
			{
				this.aimTarget(param1,_heroPosition);
			}
			else
			{
				_loc8_ = ((_loc4_ < 0?-1:1) * Math.sqrt(_loc7_) - _loc5_) / (2 * _loc4_);
				_loc2_ = _loc2_ + _loc8_ * this._heroVelocity.x;
				_loc3_ = _loc3_ + _loc8_ * this._heroVelocity.y;
				_loc9_ = new Point(_heroPosition.x + _loc8_ * this._heroVelocity.x,_heroPosition.y + _loc8_ * this._heroVelocity.y);
				if(LevelController.isInsideGameZoneArea(_loc9_))
				{
					_loc10_ = Math.atan2(_loc3_,_loc2_);
					param1.rotation = _loc10_ * 180 / Math.PI + 90;
					param1.setDirectionValues(this._bulletSpeed * Math.cos(_loc10_),this._bulletSpeed * Math.sin(_loc10_));
				}
				else
				{
					if(this._heroVelocity.y == 0)
					{
						_loc9_.x = this._heroVelocity.x < 0?Number(GameConstants.gameZoneArea.x):Number(GameConstants.gameZoneArea.x + GameConstants.gameZoneArea.width);
						_loc9_.y = _heroPosition.y;
					}
					else if(this._heroVelocity.x == 0)
					{
						_loc9_.x = _heroPosition.x;
						_loc9_.y = this._heroVelocity.y < 0?Number(GameConstants.gameZoneArea.y):Number(GameConstants.gameZoneArea.y + GameConstants.gameZoneArea.height);
					}
					else
					{
						_loc11_ = this._heroVelocity.y / this._heroVelocity.x;
						_loc12_ = _heroPosition.y - _loc11_ * _heroPosition.x;
						_loc9_.y = this._heroVelocity.y < 0?Number(GameConstants.gameZoneArea.y):Number(GameConstants.gameZoneArea.y + GameConstants.gameZoneArea.height);
						_loc9_.x = (_loc9_.y - _loc12_) / _loc11_;
						if(_loc9_.x < GameConstants.gameZoneArea.x || _loc9_.x > GameConstants.gameZoneArea.x + GameConstants.gameZoneArea.width)
						{
							_loc9_.x = this._heroVelocity.x < 0?Number(GameConstants.gameZoneArea.x):Number(GameConstants.gameZoneArea.x + GameConstants.gameZoneArea.width);
							_loc9_.y = _loc11_ * _loc9_.x + _loc12_;
						}
					}
					this.aimTarget(param1,_loc9_,false);
				}
			}
		}
		
		private function aimTarget(param1:EnemyBullet, param2:Point, param3:Boolean = true) : void
		{
			var _loc4_:Point = !!param3?MathUtil.getRandomPointAroundPoint(param2,0,GameConstants.enemyBulletToHeroMaxOffset):param2;
			var _loc5_:Number = _loc4_.x - position.x > 0?Number(1):Number(-1);
			var _loc6_:Number = MathUtil.getVerticalRadAngle(position,_loc4_);
			var _loc7_:Number = MathUtil.getVerticalDegAngle(position,_loc4_);
			var _loc8_:Number = _loc5_ * this._bulletSpeed * Math.sin(_loc6_);
			var _loc9_:Number = this._bulletSpeed * Math.cos(_loc6_);
			param1.rotation = _loc7_;
			param1.setDirectionValues(_loc8_,_loc9_);
		}
		
		protected function updateBulletsPosition() : void
		{
			var _loc1_:uint = 0;
			while(_loc1_ < _bullets.length)
			{
				_bullets[_loc1_].update();
				_loc1_++;
			}
		}
		
		override public function dispose() : void
		{
			eaze(_mainObject.viewMc).killTweens();
			super.dispose();
		}
	}
}
