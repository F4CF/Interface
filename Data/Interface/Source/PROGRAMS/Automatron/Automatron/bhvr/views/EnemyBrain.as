package bhvr.views
{
	import bhvr.data.LevelUpVariables;
	import aze.motion.eaze;
	import flash.geom.Point;
	import bhvr.utils.MathUtil;
	import bhvr.manager.SoundManager;
	import bhvr.data.SoundList;
	import bhvr.constants.GameConstants;
	import flash.display.MovieClip;
	import bhvr.data.EnemyData;
	
	public class EnemyBrain extends Enemy
	{
		
		public static const TRANSFORM_STATE:uint = DEATH_STATE + 1;
		
		public static const PROGRAM_STATE:uint = DEATH_STATE + 2;
		 
		
		private var _frameCounter:uint;
		
		private var _bulletSpeed:Number;
		
		public function EnemyBrain(param1:MovieClip, param2:EnemyData, param3:Boolean = false)
		{
			super(param1,param2,param3);
		}
		
		public function get inTransformationState() : Boolean
		{
			return _state == TRANSFORM_STATE || _state == PROGRAM_STATE;
		}
		
		override protected function initialize() : void
		{
			this._bulletSpeed = LevelUpVariables.getEnemyBulletSpeed(_enemyData.bulletData);
			super.initialize();
		}
		
		override public function start() : void
		{
			super.start();
			this.startDelayBeforeFiring();
			this._frameCounter = 0;
		}
		
		override public function stop() : void
		{
			super.stop();
			eaze(this).killTweens();
			eaze(_mainObject.viewMc).killTweens();
		}
		
		override public function update(param1:Point) : void
		{
			if(!this.inTransformationState)
			{
				super.update(param1);
			}
			if(_bullets != null)
			{
				_heroPosition = param1;
				this.updateBulletsPosition();
			}
		}
		
		override protected function move() : void
		{
			var _loc1_:Point = _path.getNextPosition(_closestHumanPos,_enemyData.pathData.aggroRadius);
			setPosition(_loc1_.x,_loc1_.y);
		}
		
		override protected function setState(param1:uint) : void
		{
			if(_state != param1)
			{
				if(param1 == TRANSFORM_STATE)
				{
					eaze(_mainObject.viewMc).play("humanTransformStart>humanTransformEnd").onComplete(this.onTransformed);
				}
				else if(param1 == PROGRAM_STATE)
				{
					eaze(_mainObject.viewMc).play("programHumanStart>programHumanEnd").onComplete(this.onProgramed);
				}
			}
			super.setState(param1);
		}
		
		private function onTransformed() : void
		{
			this.start();
			this.setState(STANDING_STATE);
			_path.start();
		}
		
		private function onProgramed() : void
		{
			this.setState(STANDING_STATE);
			_path.start();
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
			this.setBulletDirection(_loc1_);
			_bullets.push(_loc1_);
			this.startDelayBeforeFiring();
		}
		
		private function setBulletDirection(param1:EnemyBullet) : void
		{
			var _loc2_:Number = _heroPosition.x - param1.x > 0?Number(1):Number(-1);
			var _loc3_:Number = _loc2_ * this._bulletSpeed * Math.sin(MathUtil.getVerticalRadAngle(new Point(param1.x,param1.y),_heroPosition));
			var _loc4_:Number = this._bulletSpeed * Math.cos(MathUtil.getVerticalRadAngle(new Point(param1.x,param1.y),_heroPosition));
			param1.rotation = MathUtil.getVerticalDegAngle(param1.position,_heroPosition);
			param1.setDirectionValues(_loc3_,_loc4_);
		}
		
		protected function updateBulletsPosition() : void
		{
			var _loc1_:EnemyBullet = null;
			var _loc2_:Number = _enemyData.bulletData.reactionDelay;
			this._frameCounter = _loc2_ == 0?uint(0):uint(this._frameCounter % _loc2_ + 1);
			var _loc3_:uint = 0;
			while(_loc3_ < _bullets.length)
			{
				_loc1_ = _bullets[_loc3_];
				if(this._frameCounter == _loc2_)
				{
					this.setBulletDirection(_loc1_);
				}
				_loc1_.update();
				_loc3_++;
			}
		}
		
		public function transformHumanToEnemy() : void
		{
			this.setState(TRANSFORM_STATE);
			_enemyData.points = GameConstants.humanReprogrammedPoints;
		}
		
		public function programHumanToEnemy() : void
		{
			this.setState(PROGRAM_STATE);
		}
	}
}
