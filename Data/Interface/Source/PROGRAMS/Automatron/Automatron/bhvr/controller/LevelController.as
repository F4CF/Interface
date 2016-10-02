package bhvr.controller
{
	import flash.events.EventDispatcher;
	import flash.geom.Point;
	import bhvr.constants.GameConstants;
	import flash.display.MovieClip;
	import bhvr.views.CustomCursor;
	import bhvr.views.Hero;
	import bhvr.manager.SoundManager;
	import bhvr.data.SoundList;
	import aze.motion.eaze;
	import flash.events.Event;
	import bhvr.events.GameEvents;
	import bhvr.events.EventWithParams;
	import bhvr.views.Human;
	import bhvr.views.Enemy;
	import bhvr.views.EnemyHulk;
	import bhvr.views.HeroBullet;
	import bhvr.views.EnemyElectrode;
	import bhvr.views.EnemyBullet;
	import bhvr.utils.MathUtil;
	import bhvr.views.EnemyBrain;
	import bhvr.utils.FlashUtil;
	import bhvr.views.Character;
	import bhvr.data.LevelData;
	import flash.utils.Dictionary;
	import bhvr.data.GamePersistantData;
	
	public class LevelController extends EventDispatcher
	{
		
		public static var active:Boolean = false;
		 
		
		private var _assets:MovieClip;
		
		private var _gameContainer:MovieClip;
		
		private var _stageObject:MovieClip;
		
		private var _cursor:CustomCursor;
		
		private var _hero:Hero;
		
		private var _enemyController:bhvr.controller.EnemyController;
		
		private var _humanController:bhvr.controller.HumanController;
		
		public function LevelController(param1:MovieClip, param2:Vector.<LevelData>, param3:Dictionary, param4:CustomCursor)
		{
			super();
			this._assets = param1;
			this._gameContainer = this._assets.gameContainerMc;
			this._cursor = param4;
			this._stageObject = new MovieClip();
			var _loc5_:uint = (GamePersistantData.level - 1) % param2.length;
			var _loc6_:LevelData = param2.length > 0?param2[_loc5_]:new LevelData();
			this._hero = new Hero(this._gameContainer);
			this._hero.addEventListener(GameEvents.HERO_DEAD,dispatchEvent,false,0,true);
			this._hero.addEventListener(GameEvents.HERO_DEAD_END,dispatchEvent,false,0,true);
			this._hero.addEventListener(GameEvents.HERO_DAMAGED,dispatchEvent,false,0,true);
			this._hero.addEventListener(GameEvents.HERO_DAMAGED_END,dispatchEvent,false,0,true);
			this._enemyController = new bhvr.controller.EnemyController(this._gameContainer,_loc6_.enemiesNum,param3);
			this._enemyController.addEventListener(GameEvents.ALL_ENEMIES_KILLED,this.onAllEnemiesKilled,false,0,true);
			this._humanController = new bhvr.controller.HumanController(this._gameContainer,_loc6_.humansNum);
		}
		
		public static function isInsideGameZoneArea(param1:Point) : Boolean
		{
			if(param1.x > GameConstants.gameZoneArea.x && param1.x < GameConstants.gameZoneArea.x + GameConstants.gameZoneArea.width && param1.y > GameConstants.gameZoneArea.y && param1.y < GameConstants.gameZoneArea.y + GameConstants.gameZoneArea.height)
			{
				return true;
			}
			return false;
		}
		
		public function startTransitionAnimation() : void
		{
			SoundManager.instance.playSound(SoundList.LEVEL_TRANSITION_SOUND);
			eaze(this._assets.transitionWaveMc).play("start>end").onComplete(this.spawnAllExceptHero,true);
		}
		
		private function spawnAllExceptHero(param1:Boolean = false) : void
		{
			if(!param1)
			{
				this._hero.reset();
				this._enemyController.reset();
			}
			this._stageObject.addEventListener(Event.ENTER_FRAME,this.onUpdate,false,0,true);
			this._enemyController.addEventListener(GameEvents.ALL_ENEMIES_SPAWN_FINISHED,this.onEnemiesSpawned,false,0,true);
			this._enemyController.spawnEnemies();
			this._humanController.start();
		}
		
		private function onEnemiesSpawned(param1:EventWithParams) : void
		{
			this._enemyController.removeEventListener(GameEvents.ALL_ENEMIES_SPAWN_FINISHED,this.onEnemiesSpawned);
			this.spawnHero();
		}
		
		private function spawnHero() : void
		{
			this._hero.addEventListener(GameEvents.HERO_SPAWN_FINISHED,this.onHeroSpawned,false,0,true);
			this._hero.spawn();
		}
		
		private function onHeroSpawned(param1:EventWithParams) : void
		{
			this._hero.removeEventListener(GameEvents.HERO_SPAWN_FINISHED,this.onHeroSpawned);
			this.start();
		}
		
		public function start() : void
		{
			LevelController.active = true;
			SoundManager.instance.startSound(SoundList.LEVEL_MUSIC_LOOP_SOUND_ID);
			this._hero.start();
			this._enemyController.start();
		}
		
		public function stop() : void
		{
			this._stageObject.removeEventListener(Event.ENTER_FRAME,this.onUpdate);
			this._hero.stop();
			this._enemyController.stop();
			this._humanController.stop();
			SoundManager.instance.stopSound(SoundList.LEVEL_MUSIC_LOOP_SOUND_ID);
			LevelController.active = false;
		}
		
		public function freeze() : void
		{
			this.stop();
		}
		
		public function unfreeze() : void
		{
			this.spawnAllExceptHero();
		}
		
		private function onUpdate() : void
		{
			var _loc1_:Vector.<Human> = null;
			if(this._hero != null && this._hero._collider != null && this._hero.started)
			{
				this._hero.update(this._cursor == null?null:this._cursor.getPosition());
			}
			if(this._humanController != null && this._hero != null && this._humanController.started)
			{
				this._humanController.update(this._hero.position);
			}
			if(this._enemyController != null && this._hero != null && this._enemyController.started)
			{
				_loc1_ = this._humanController.humans;
				if(_loc1_ != null)
				{
					this._enemyController.sendHumanList(_loc1_);
				}
				this._enemyController.update(this._hero.position);
			}
			if(this._hero != null && this._hero.started)
			{
				this.checkCollisionsHeroVsEnemies();
				this.checkCollisionsHeroVsHumans();
			}
		}
		
		private function checkCollisionsHeroVsEnemies() : void
		{
			var _loc4_:Enemy = null;
			if(this._hero == null || this._hero._collider == null || this._hero.bullets == null || this._enemyController.enemies == null)
			{
				return;
			}
			var _loc1_:Vector.<Enemy> = this._enemyController.enemies.concat();
			var _loc2_:Vector.<Enemy> = this._enemyController.humanCollidingEnemies;
			var _loc3_:Vector.<EnemyHulk> = this._enemyController.hulkEnemies;
			var _loc5_:Vector.<HeroBullet> = this._hero.bullets;
			var _loc6_:Vector.<Human> = this._humanController.humans;
			if(_loc6_ != null)
			{
				_loc6_ = _loc6_.concat();
				for each(_loc4_ in _loc1_)
				{
					this.checkCollisionHeroVsEnemy(_loc4_);
					this.checkCollisionWithEnemyBullets(_loc4_,_loc3_);
					this.checkCollisionHeroBulletsVsEnemy(_loc4_,_loc5_);
				}
				for each(_loc4_ in _loc2_)
				{
					this.checkCollisionEnemyVsHumans(_loc4_,_loc6_);
				}
			}
		}
		
		private function checkCollisionHeroVsEnemy(param1:Enemy) : void
		{
			if(this._hero == null || this._hero._collider == null || param1._collider == null)
			{
				return;
			}
			if(this._hero._collider.hitTestObject(param1._collider))
			{
				if(param1 is EnemyElectrode)
				{
					this.checkCollisionElectrodeVsAll(param1);
					this.killEnemy(param1);
				}
				else
				{
					this._hero.damage();
				}
			}
		}
		
		private function checkCollisionElectrodeVsAll(param1:Enemy) : void
		{
			var _loc3_:Enemy = null;
			var _loc5_:Vector.<EnemyBullet> = null;
			var _loc6_:EnemyBullet = null;
			var _loc7_:uint = 0;
			if(this._enemyController.enemies == null)
			{
				return;
			}
			var _loc2_:Vector.<Enemy> = this._enemyController.enemies.concat();
			var _loc4_:uint = 0;
			while(_loc4_ < _loc2_.length)
			{
				_loc3_ = _loc2_[_loc4_];
				if(_loc3_ != null && _loc3_._collider != null && param1 != _loc3_)
				{
					if(MathUtil.getDistance(param1.position,_loc3_.position) <= GameConstants.electrodeExplosionRadius)
					{
						this.killEnemy(_loc3_);
					}
					if(_loc3_.bullets != null)
					{
						_loc5_ = _loc3_._bullets;
						_loc7_ = 0;
						while(_loc7_ < _loc5_.length)
						{
							_loc6_ = _loc5_[_loc7_];
							if(_loc6_ != null && _loc6_._collider != null)
							{
								if(MathUtil.getDistance(param1.position,new Point(_loc6_.x,_loc6_.y)) <= GameConstants.electrodeExplosionRadius)
								{
									_loc6_.explode();
								}
							}
							_loc7_++;
						}
					}
				}
				_loc4_++;
			}
			if(MathUtil.getDistance(param1.position,this._hero.position) <= GameConstants.electrodeExplosionRadius)
			{
				this._hero.damage();
			}
		}
		
		private function checkCollisionEnemyVsHumans(param1:Enemy, param2:Vector.<Human>) : void
		{
			var _loc3_:Human = null;
			for each(_loc3_ in param2)
			{
				if(_loc3_._collider != null && _loc3_._collider.hitTestObject(param1._collider))
				{
					if(param1 is EnemyHulk)
					{
						dispatchEvent(new EventWithParams(GameEvents.HUMAN_KILLED,{"target":_loc3_}));
						this._humanController.killHuman(_loc3_);
					}
					else if(param1 is EnemyBrain && !EnemyBrain(param1).inTransformationState)
					{
						this._enemyController.createEnemyFromHuman(_loc3_);
						this._humanController.transformHuman(_loc3_);
						EnemyBrain(param1).programHumanToEnemy();
					}
				}
			}
		}
		
		private function checkCollisionWithEnemyBullets(param1:Enemy, param2:Vector.<EnemyHulk>) : void
		{
			var _loc4_:EnemyBullet = null;
			var _loc3_:Vector.<EnemyBullet> = param1._bullets;
			for each(_loc4_ in _loc3_)
			{
				if(_loc4_._collider != null)
				{
					this.checkCollisionHeroVsEnemyBullet(_loc4_);
					this.checkCollisionHulksVsEnemyBullet(_loc4_,param2);
				}
			}
		}
		
		private function checkCollisionHeroVsEnemyBullet(param1:EnemyBullet) : void
		{
			if(this._hero == null || this._hero._collider == null)
			{
				return;
			}
			if(this._hero._collider.hitTestPoint(param1.x,param1.y,true))
			{
				param1.explode();
				this._hero.damage();
			}
		}
		
		private function checkCollisionHulksVsEnemyBullet(param1:EnemyBullet, param2:Vector.<EnemyHulk>) : void
		{
			var _loc3_:EnemyHulk = null;
			for each(_loc3_ in param2)
			{
				if(_loc3_._collider != null && _loc3_._collider.hitTestPoint(param1.x,param1.y,true))
				{
					param1.explode();
				}
			}
		}
		
		private function checkCollisionHeroBulletsVsEnemy(param1:Enemy, param2:Vector.<HeroBullet>) : void
		{
			var _loc3_:HeroBullet = null;
			var _loc4_:EnemyBullet = null;
			for each(_loc3_ in param2)
			{
				if(_loc3_._collider != null)
				{
					for each(_loc4_ in param1._bullets)
					{
						if(_loc4_ != null && _loc4_._collider != null && _loc4_._collider.hitTestPoint(_loc3_.x,_loc3_.y,false))
						{
							dispatchEvent(new EventWithParams(GameEvents.ENEMY_BULLET_DESTROYED,{"target":param1}));
							_loc4_.explode();
							_loc3_.explode();
							break;
						}
					}
					if(_loc3_._collider != null && param1._collider != null && param1._collider.hitTestPoint(_loc3_.x,_loc3_.y,true))
					{
						_loc3_.explode();
						if(param1 is EnemyHulk)
						{
							EnemyHulk(param1).fightOff(this.getIntersectionSide(param1,_loc3_));
						}
						else
						{
							if(param1 is EnemyElectrode)
							{
								this.checkCollisionElectrodeVsAll(param1);
							}
							this.killEnemy(param1);
						}
					}
				}
			}
		}
		
		private function checkCollisionsHeroVsHumans() : void
		{
			var _loc2_:Human = null;
			if(this._hero == null || this._hero._collider == null || this._humanController.humans == null)
			{
				return;
			}
			var _loc1_:Vector.<Human> = this._humanController.humans.concat();
			var _loc3_:uint = 0;
			while(_loc3_ < _loc1_.length)
			{
				_loc2_ = _loc1_[_loc3_];
				if(_loc2_ != null && _loc2_._collider != null && this._hero._collider.hitTestObject(_loc2_._collider))
				{
					dispatchEvent(new EventWithParams(GameEvents.HUMAN_SAVED,{"target":_loc2_}));
					this._humanController.saveHuman(_loc2_);
				}
				_loc3_++;
			}
		}
		
		private function getIntersectionSide(param1:Enemy, param2:HeroBullet) : int
		{
			var _loc3_:Point = FlashUtil.localToGlobalPosition(param2);
			var _loc4_:Number = param2.deltaY / param2.deltaX;
			var _loc5_:Number = _loc3_.y - _loc4_ * _loc3_.x;
			var _loc6_:Number = param1.position.y - param1.dimension.y / 2;
			var _loc7_:Number = param1.position.y + param1.dimension.y / 2;
			var _loc8_:Number = param1.position.x - param1.dimension.x / 2;
			var _loc9_:Number = param1.position.x + param1.dimension.x / 2;
			var _loc10_:Number = param2.deltaY > 0?Number((_loc6_ - _loc5_) / _loc4_):Number((_loc7_ - _loc5_) / _loc4_);
			if(_loc10_ > _loc8_ && _loc10_ < _loc9_)
			{
				return param2.deltaY > 0?int(Character.UP_DIRECTION):int(Character.DOWN_DIRECTION);
			}
			if(param2.deltaX < 0)
			{
				return Character.RIGHT_DIRECTION;
			}
			return Character.LEFT_DIRECTION;
		}
		
		private function killEnemy(param1:Enemy) : void
		{
			dispatchEvent(new EventWithParams(GameEvents.ENEMY_KILLED,{"target":param1}));
			this._enemyController.killEnemy(param1);
			if(this._enemyController.remainingEnemies == 0)
			{
				this.stop();
			}
		}
		
		private function onAllEnemiesKilled(param1:EventWithParams) : void
		{
			if(this._hero._collider != null)
			{
				dispatchEvent(param1);
			}
		}
		
		public function pause() : void
		{
			this._stageObject.removeEventListener(Event.ENTER_FRAME,this.onUpdate);
			if(this._hero != null)
			{
				this._hero.pause();
			}
			if(this._enemyController != null)
			{
				this._enemyController.pause();
			}
			if(this._humanController != null)
			{
				this._humanController.pause();
			}
		}
		
		public function resume() : void
		{
			this._stageObject.addEventListener(Event.ENTER_FRAME,this.onUpdate,false,0,true);
			if(this._hero != null)
			{
				this._hero.resume();
			}
			if(this._enemyController != null)
			{
				this._enemyController.resume();
			}
			if(this._humanController != null)
			{
				this._humanController.resume();
			}
		}
		
		public function dispose() : void
		{
			this.stop();
			if(this._hero != null)
			{
				this._hero.removeEventListener(GameEvents.HERO_DEAD,dispatchEvent);
				this._hero.removeEventListener(GameEvents.HERO_DEAD_END,dispatchEvent);
				this._hero.removeEventListener(GameEvents.HERO_DAMAGED,dispatchEvent);
				this._hero.removeEventListener(GameEvents.HERO_DAMAGED_END,dispatchEvent);
				this._hero.dispose();
				this._hero = null;
			}
			if(this._enemyController != null)
			{
				this._enemyController.removeEventListener(GameEvents.ALL_ENEMIES_KILLED,this.onAllEnemiesKilled);
				this._enemyController.dispose();
				this._enemyController = null;
			}
			if(this._humanController != null)
			{
				this._humanController.dispose();
				this._humanController = null;
			}
			this._stageObject = null;
		}
	}
}
