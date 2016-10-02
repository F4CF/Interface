package bhvr.controller
{
	import flash.utils.Dictionary;
	import bhvr.views.EnemyHulk;
	import bhvr.views.Enemy;
	import bhvr.views.Character;
	import bhvr.views.Human;
	import bhvr.manager.SoundManager;
	import bhvr.data.SoundList;
	import bhvr.data.EnemyData;
	import bhvr.events.GameEvents;
	import bhvr.views.EnemyGrunt;
	import bhvr.views.EnemyElectrode;
	import bhvr.views.EnemySpheroid;
	import bhvr.views.EnemyEnforcer;
	import bhvr.views.EnemyBrain;
	import flash.geom.Point;
	import bhvr.events.EventWithParams;
	import bhvr.utils.MathUtil;
	import bhvr.constants.GameConstants;
	import flash.display.MovieClip;
	
	public class EnemyController extends CharacterController
	{
		 
		
		private var _levelEnemiesData:Dictionary;
		
		private var _enemiesData:Dictionary;
		
		private var _remainingEnemies:uint;
		
		private var _hulkEnemies:Vector.<EnemyHulk>;
		
		private var _enemiesSpawnCounter:uint;
		
		private var _humanHuntingEnemies:Vector.<Enemy>;
		
		private var _humanCollidingEnemies:Vector.<Enemy>;
		
		private var _nextHumanHuntingEnemyToUpdate:int;
		
		public function EnemyController(param1:MovieClip, param2:Dictionary, param3:Dictionary)
		{
			super(param1);
			this._levelEnemiesData = param2;
			this._enemiesData = param3;
			this._enemiesSpawnCounter = 0;
			this._hulkEnemies = new Vector.<EnemyHulk>();
			this._humanHuntingEnemies = new Vector.<Enemy>();
			this._humanCollidingEnemies = new Vector.<Enemy>();
			this._nextHumanHuntingEnemyToUpdate = 0;
		}
		
		public function get enemies() : Vector.<Enemy>
		{
			return Vector.<Enemy>(_characters);
		}
		
		public function get remainingEnemies() : uint
		{
			return this._remainingEnemies;
		}
		
		public function get hulkEnemies() : Vector.<EnemyHulk>
		{
			return this._hulkEnemies;
		}
		
		public function get humanCollidingEnemies() : Vector.<Enemy>
		{
			return this._humanCollidingEnemies;
		}
		
		public function reset() : void
		{
			var _loc1_:Enemy = null;
			var _loc2_:uint = 0;
			if(this.enemies != null)
			{
				_loc2_ = 0;
				while(_loc2_ < this.enemies.length)
				{
					_loc1_ = this.enemies[_loc2_];
					_loc1_.reset();
					_loc2_++;
				}
			}
		}
		
		override public function start() : void
		{
			var _loc1_:Character = null;
			var _loc2_:uint = 0;
			if(_characters != null)
			{
				_loc2_ = 0;
				while(_loc2_ < _characters.length)
				{
					_loc1_ = _characters[_loc2_];
					_loc1_.start();
					_loc2_++;
				}
			}
			_started = true;
		}
		
		public function sendHumanList(param1:Vector.<Human>) : void
		{
			if(_started && this.enemies != null && this._humanHuntingEnemies.length > 0)
			{
				this._humanHuntingEnemies[this._nextHumanHuntingEnemyToUpdate].sendHumanList(param1);
				this._nextHumanHuntingEnemyToUpdate++;
				this._nextHumanHuntingEnemyToUpdate = this._nextHumanHuntingEnemyToUpdate % this._humanHuntingEnemies.length;
			}
		}
		
		public function spawnEnemies() : void
		{
			SoundManager.instance.playSound(SoundList.ENEMIES_INIT_SPAWN_SOUND);
			if(_characters == null)
			{
				this.createCharacters();
			}
			else
			{
				this.spawnCharacters();
			}
		}
		
		override protected function createCharacters() : void
		{
			var _loc1_:EnemyData = null;
			var _loc2_:Enemy = null;
			var _loc3_:uint = 0;
			var _loc4_:uint = 0;
			super.createCharacters();
			for each(_loc1_ in this._enemiesData)
			{
				if(_loc1_.linkageId != Character.NONE)
				{
					_loc3_ = this._levelEnemiesData[_loc1_.id] == null?uint(0):uint(this._levelEnemiesData[_loc1_.id]);
					_loc4_ = 0;
					while(_loc4_ < _loc3_)
					{
						_loc2_ = this.createEnemy(_loc1_);
						_loc2_.addEventListener(GameEvents.ENEMY_KILLED,this.onEnemyKilled,false,0,true);
						if(_loc2_.enemyData.spawnData != null)
						{
							_loc2_.addEventListener(GameEvents.ENEMY_SPAWN_REQUEST,this.onSpawnRequested,false,0,true);
						}
						_characters.push(_loc2_);
						this.spawnCharacter(_loc2_);
						_loc4_++;
					}
					continue;
				}
			}
			if(_characters.length == 0)
			{
				this.dispatchSpawnEvent();
			}
		}
		
		private function createEnemy(param1:EnemyData, param2:Boolean = false) : Enemy
		{
			var _loc4_:EnemyHulk = null;
			if(param1.mustBeKilled)
			{
				this._remainingEnemies++;
			}
			var _loc3_:Enemy = null;
			switch(param1.id)
			{
				case Character.ENEMY_GRUNT_ID:
					_loc3_ = new EnemyGrunt(_charactersContainer,param1,param2);
					break;
				case Character.ENEMY_ELECTRODE_ID:
					_loc3_ = new EnemyElectrode(_charactersContainer,param1,param2);
					break;
				case Character.ENEMY_SPHEROID_ID:
					_loc3_ = new EnemySpheroid(_charactersContainer,param1,param2);
					break;
				case Character.ENEMY_ENFORCER_ID:
					_loc3_ = new EnemyEnforcer(_charactersContainer,param1,param2);
					break;
				case Character.ENEMY_HULK_ID:
					_loc4_ = new EnemyHulk(_charactersContainer,param1,param2);
					this._hulkEnemies.push(_loc4_);
					_loc3_ = _loc4_;
					this._humanCollidingEnemies.push(_loc3_);
					break;
				case Character.ENEMY_BRAIN_ID:
					_loc3_ = new EnemyBrain(_charactersContainer,param1,param2);
					this._humanCollidingEnemies.push(_loc3_);
					break;
				default:
					_loc3_ = new Enemy(_charactersContainer,param1,param2);
			}
			if(_loc3_.enemyData.pathData.canHuntHumans)
			{
				this._humanHuntingEnemies.push(_loc3_);
			}
			return _loc3_;
		}
		
		override protected function spawnCharacters() : void
		{
			var _loc1_:Enemy = null;
			var _loc2_:int = _characters.length - 1;
			while(_loc2_ >= 0)
			{
				_loc1_ = _characters[_loc2_] as Enemy;
				if(_loc1_.collider == null)
				{
					this.deleteReference(_loc1_);
				}
				else
				{
					this.spawnCharacter(_loc1_);
				}
				_loc2_--;
			}
		}
		
		override protected function spawnCharacter(param1:Character) : void
		{
			var _loc2_:Point = getRandomPosition(param1);
			while(this.isInsideHeroArea(_loc2_))
			{
				_loc2_ = getRandomPosition(param1);
			}
			param1.setPosition(_loc2_.x,_loc2_.y);
			param1.addEventListener(GameEvents.ENEMY_SPAWN_FINISHED,this.onSpawnFinished,false,0,true);
			param1.playSpawnAnimation();
		}
		
		private function onSpawnFinished(param1:EventWithParams) : void
		{
			var _loc2_:Character = param1.params.target as Character;
			_loc2_.removeEventListener(GameEvents.ENEMY_SPAWN_FINISHED,this.onSpawnFinished);
			this._enemiesSpawnCounter++;
			if(this._enemiesSpawnCounter == _characters.length)
			{
				this.dispatchSpawnEvent();
			}
		}
		
		private function dispatchSpawnEvent() : void
		{
			this._enemiesSpawnCounter = 0;
			dispatchEvent(new EventWithParams(GameEvents.ALL_ENEMIES_SPAWN_FINISHED));
		}
		
		private function isInsideHeroArea(param1:Point) : Boolean
		{
			return MathUtil.getDistance(param1,GameConstants.heroSpawnPosition) < GameConstants.heroSpawnSafeDistance;
		}
		
		public function killEnemy(param1:Enemy) : void
		{
			param1.destroy();
			if(param1.enemyData.mustBeKilled)
			{
				this._remainingEnemies--;
			}
			if(param1.enemyData.pathData.canHuntHumans)
			{
				this._humanHuntingEnemies.splice(this._humanHuntingEnemies.indexOf(param1),1);
				this._nextHumanHuntingEnemyToUpdate = this._nextHumanHuntingEnemyToUpdate % this._humanHuntingEnemies.length;
			}
			if(param1 is EnemyHulk || param1 is EnemyBrain)
			{
				this._humanCollidingEnemies.splice(this._humanCollidingEnemies.indexOf(param1),1);
				if(param1 is EnemyHulk)
				{
					this._hulkEnemies.splice(this._hulkEnemies.indexOf(param1),1);
				}
			}
			if(this._remainingEnemies == 0)
			{
				param1.removeBullets();
			}
		}
		
		public function createEnemyFromHuman(param1:Human) : void
		{
			var _loc2_:EnemyBrain = this.createEnemy(this._enemiesData[Character.ENEMY_BRAIN_ID]) as EnemyBrain;
			_loc2_.addEventListener(GameEvents.ENEMY_KILLED,this.onEnemyKilled,false,0,true);
			_loc2_.setPosition(param1.position.x,param1.position.y);
			_loc2_.transformHumanToEnemy();
			_characters.push(_loc2_);
		}
		
		private function onSpawnRequested(param1:EventWithParams) : void
		{
			var _loc2_:Enemy = param1.params.target as Enemy;
			var _loc3_:String = param1.params.data.id;
			var _loc4_:Enemy = this.createEnemy(this._enemiesData[_loc3_],true);
			_loc4_.addEventListener(GameEvents.ENEMY_KILLED,this.onEnemyKilled,false,0,true);
			_characters.push(_loc4_);
			var _loc5_:Point = _loc2_ == null?getRandomPosition(_loc4_):_loc2_.position;
			_loc4_.setPosition(_loc5_.x,_loc5_.y);
			_loc4_.start();
			SoundManager.instance.playSound(SoundList.ENEMY_SPAWN_SOUND);
		}
		
		private function onEnemyKilled(param1:EventWithParams) : void
		{
			var _loc2_:Enemy = param1.params.target as Enemy;
			this.deleteReference(_loc2_);
			if(this._remainingEnemies == 0)
			{
				dispatchEvent(new EventWithParams(GameEvents.ALL_ENEMIES_KILLED));
			}
		}
		
		override protected function deleteReference(param1:Character) : void
		{
			var _loc2_:Enemy = param1 as Enemy;
			if(_loc2_ != null)
			{
				_loc2_.removeEventListener(GameEvents.ENEMY_KILLED,this.onEnemyKilled);
				if(_loc2_.enemyData.spawnData != null)
				{
					_loc2_.removeEventListener(GameEvents.ENEMY_SPAWN_REQUEST,this.onSpawnRequested);
				}
				_loc2_.dispose();
				removeFromList(_loc2_);
			}
		}
		
		override public function dispose() : void
		{
			super.dispose();
			this._enemiesData = null;
			this._levelEnemiesData = null;
		}
	}
}
