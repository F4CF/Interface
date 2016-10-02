package bhvr.states
{
	import bhvr.views.CustomCursor;
	import bhvr.controller.LevelController;
	import bhvr.views.Hud;
	import bhvr.utils.XMLLoader;
	import flash.utils.Dictionary;
	import bhvr.data.LevelData;
	import bhvr.constants.GameConstants;
	import flash.geom.Rectangle;
	import flash.geom.Point;
	import bhvr.debug.Log;
	import flash.events.Event;
	import bhvr.constants.GameConfig;
	import bhvr.data.EnemiesParser;
	import bhvr.data.LevelsParser;
	import bhvr.data.GamePersistantData;
	import Shared.AS3.COMPANIONAPP.CompanionAppMode;
	import bhvr.manager.InputManager;
	import bhvr.data.GameScore;
	import bhvr.events.GameEvents;
	import bhvr.events.EventWithParams;
	import bhvr.views.Enemy;
	import bhvr.views.Human;
	import flash.display.MovieClip;
	
	public class GameLevelState extends GameState
	{
		 
		
		private var _cursor:CustomCursor;
		
		private var _levelController:LevelController;
		
		private var _hud:Hud;
		
		private var _xmlLoaders:Vector.<XMLLoader>;
		
		private var _enemiesData:Dictionary;
		
		private var _levelsData:Vector.<LevelData>;
		
		private var _externalXmls:Vector.<String>;
		
		private var _externalDataNumLoaded:uint;
		
		public function GameLevelState(param1:int, param2:MovieClip, param3:CustomCursor)
		{
			this._externalXmls = new <String>[GameConfig.ENEMIES_XML_PATH,GameConfig.LEVELS_XML_PATH];
			super(param1,param2);
			this._cursor = param3;
		}
		
		override public function initialize() : void
		{
			this._hud = new Hud(_assets.hudMc);
			GameConstants.gameZoneArea = new Rectangle(_assets.stageMc.x,_assets.stageMc.y,_assets.stageMc.width,_assets.stageMc.height);
			GameConstants.heroSpawnPosition = new Point(_assets.stageMc.x + _assets.stageMc.width / 2,_assets.stageMc.y + _assets.stageMc.height / 2);
			this._xmlLoaders = new Vector.<XMLLoader>();
			this._externalDataNumLoaded = 0;
			this.loadExternalXml();
		}
		
		private function loadExternalXml() : void
		{
			var _loc1_:XMLLoader = null;
			var _loc2_:uint = 0;
			while(_loc2_ < this._externalXmls.length)
			{
				_loc1_ = new XMLLoader();
				_loc1_.addEventListener(XMLLoader.XML_LOADED,this.onXmlLoaded,false,0,true);
				_loc1_.load(this._externalXmls[_loc2_]);
				this._xmlLoaders.push(_loc1_);
				_loc2_++;
			}
			Log.info(this._externalXmls.length + " xml files to load: " + this._externalXmls);
		}
		
		private function onXmlLoaded(param1:Event) : void
		{
			var _loc2_:XMLLoader = param1.target as XMLLoader;
			var _loc3_:XML = _loc2_.xml as XML;
			var _loc4_:String = _loc2_.url;
			_loc2_.removeEventListener(XMLLoader.XML_LOADED,this.onXmlLoaded);
			_loc2_.dispose();
			_loc2_ = null;
			if(_loc4_ == GameConfig.ENEMIES_XML_PATH)
			{
				this.parseEnemiesData(_loc3_);
			}
			else if(_loc4_ == GameConfig.LEVELS_XML_PATH)
			{
				this.parseLevelsData(_loc3_);
			}
			this._externalDataNumLoaded++;
			Log.info("Xml file " + _loc4_ + " has been loaded. (" + this._externalDataNumLoaded + "/" + this._externalXmls.length + ")");
			if(this._externalDataNumLoaded >= this._externalXmls.length)
			{
				this._xmlLoaders = null;
				super.initialize();
			}
		}
		
		private function parseEnemiesData(param1:XML) : void
		{
			var _loc2_:EnemiesParser = new EnemiesParser(param1);
			this._enemiesData = _loc2_.parse();
			_loc2_.dispose();
			_loc2_ = null;
		}
		
		private function parseLevelsData(param1:XML) : void
		{
			var _loc2_:LevelsParser = new LevelsParser(param1);
			this._levelsData = _loc2_.parse();
			GamePersistantData.maxLevel = this._levelsData.length;
			_loc2_.dispose();
			_loc2_ = null;
		}
		
		override public function enter(param1:Object = null) : void
		{
			super.enter(param1);
			if(!CompanionAppMode.isOn && InputManager.instance.isKeyboardMouseVersion)
			{
				this._cursor.show();
			}
			this._hud.reset();
			GamePersistantData.gameScore.addEventListener(GameScore.LIFE_BONUS_APPLIED,this.onLifeBonus,false,0,true);
			this._levelController = new LevelController(_assets,this._levelsData,this._enemiesData,this._cursor);
			this._levelController.addEventListener(GameEvents.ENEMY_KILLED,this.onEnemyKilled,false,0,true);
			this._levelController.addEventListener(GameEvents.ALL_ENEMIES_KILLED,this.onAllEnemiesKilled,false,0,true);
			this._levelController.addEventListener(GameEvents.HERO_DEAD,this.onHeroDead,false,0,true);
			this._levelController.addEventListener(GameEvents.HERO_DEAD_END,this.onHeroDeadEnd,false,0,true);
			this._levelController.addEventListener(GameEvents.HERO_DAMAGED,this.onHeroDamaged,false,0,true);
			this._levelController.addEventListener(GameEvents.HERO_DAMAGED_END,this.onHeroDamagedEnd,false,0,true);
			this._levelController.addEventListener(GameEvents.HUMAN_KILLED,this.onHumanKilled,false,0,true);
			this._levelController.addEventListener(GameEvents.HUMAN_SAVED,this.onHumanSaved,false,0,true);
			this._levelController.addEventListener(GameEvents.ENEMY_BULLET_DESTROYED,this.onEnemyBulletDestroyed,false,0,true);
			if(CompanionAppMode.isOn && !GamePersistantData.tutorialShown)
			{
				requestTutorialOverlay(GameConfig.GAME_NAME);
			}
			else
			{
				this._levelController.startTransitionAnimation();
			}
		}
		
		override public function exit() : void
		{
			if(!CompanionAppMode.isOn && InputManager.instance.isKeyboardMouseVersion)
			{
				this._cursor.hide();
			}
			GamePersistantData.gameScore.removeEventListener(GameScore.LIFE_BONUS_APPLIED,this.onLifeBonus);
			this._levelController.removeEventListener(GameEvents.ENEMY_KILLED,this.onEnemyKilled);
			this._levelController.removeEventListener(GameEvents.ALL_ENEMIES_KILLED,this.onAllEnemiesKilled);
			this._levelController.removeEventListener(GameEvents.HERO_DEAD,this.onHeroDead);
			this._levelController.removeEventListener(GameEvents.HERO_DEAD_END,this.onHeroDeadEnd);
			this._levelController.removeEventListener(GameEvents.HERO_DAMAGED,this.onHeroDamaged);
			this._levelController.removeEventListener(GameEvents.HERO_DAMAGED_END,this.onHeroDamagedEnd);
			this._levelController.removeEventListener(GameEvents.HUMAN_KILLED,this.onHumanKilled);
			this._levelController.removeEventListener(GameEvents.HUMAN_SAVED,this.onHumanSaved);
			this._levelController.removeEventListener(GameEvents.ENEMY_BULLET_DESTROYED,this.onEnemyBulletDestroyed);
			this._levelController.dispose();
			this._levelController = null;
			super.exit();
		}
		
		private function onEnemyKilled(param1:EventWithParams) : void
		{
			var _loc2_:Enemy = param1.params.target as Enemy;
			var _loc3_:int = _loc2_.enemyData.points;
			if(_loc3_ > 0)
			{
				GamePersistantData.gameScore.addPoints(_loc3_);
				this._hud.setScore(GamePersistantData.totalScore);
				if(_loc2_.enemyData.displayPointsOnScreen)
				{
					this._hud.displayEnemyScore(_loc3_,_loc2_.position);
				}
			}
		}
		
		private function onAllEnemiesKilled(param1:EventWithParams) : void
		{
			Log.info("-------------------------------------------");
			Log.info("---------------- LEVEL UP -----------------");
			Log.info("-------------------------------------------");
			Log.info("-- Level: " + (GamePersistantData.level + 1));
			Log.info("-- Score: " + GamePersistantData.totalScore);
			Log.info("-- LifeNum: " + GamePersistantData.lifeNum);
			Log.info("-------------------------------------------");
			this.terminateGame(GameEvents.GAME_LEVEL_UP);
		}
		
		private function onHumanKilled(param1:EventWithParams) : void
		{
			var _loc2_:Human = param1.params.target as Human;
			this._hud.displayHumanDeath(_loc2_.position);
		}
		
		private function onHumanSaved(param1:EventWithParams) : void
		{
			var _loc2_:Human = param1.params.target as Human;
			var _loc3_:int = GamePersistantData.gameScore.addComboPoints();
			this._hud.setScore(GamePersistantData.totalScore);
			this._hud.displayHumanScore(_loc3_,_loc2_.position);
		}
		
		private function onEnemyBulletDestroyed(param1:EventWithParams) : void
		{
			var _loc2_:Enemy = param1.params.target as Enemy;
			var _loc3_:int = _loc2_.enemyData.bulletData.points;
			if(_loc3_ > 0)
			{
				GamePersistantData.gameScore.addPoints(_loc3_);
				this._hud.setScore(GamePersistantData.totalScore);
			}
		}
		
		private function onHeroDamaged(param1:EventWithParams) : void
		{
			this._levelController.freeze();
			this._hud.removeLife();
			GamePersistantData.gameScore.resetCombo();
		}
		
		private function onHeroDamagedEnd(param1:EventWithParams) : void
		{
			this._levelController.unfreeze();
		}
		
		private function onHeroDead(param1:EventWithParams) : void
		{
			this._levelController.freeze();
		}
		
		private function onHeroDeadEnd(param1:EventWithParams) : void
		{
			Log.info("-------------------------------------------");
			Log.info("---------------- GAME OVER ----------------");
			Log.info("-------------------------------------------");
			this.terminateGame(GameEvents.GAME_OVER);
		}
		
		private function onLifeBonus(param1:EventWithParams) : void
		{
			this._hud.addLife();
		}
		
		private function terminateGame(param1:String) : void
		{
			dispatchEvent(new EventWithParams(GameState.NAV_CONTINUE,{
				"target":this,
				"status":param1
			}));
		}
		
		override public function Pause(param1:Boolean) : void
		{
			super.Pause(param1);
			if(param1)
			{
				if(this._levelController != null)
				{
					this._levelController.pause();
				}
			}
			else if(this._levelController != null)
			{
				this._levelController.resume();
			}
		}
		
		override public function dispose() : void
		{
			this._hud.dispose();
			this._enemiesData = null;
			this._levelsData = null;
			super.dispose();
		}
	}
}
