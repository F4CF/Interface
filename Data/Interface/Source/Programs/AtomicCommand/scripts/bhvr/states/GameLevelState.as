package bhvr.states
{
	import bhvr.utils.XMLLoader;
	import bhvr.views.Hud;
	import bhvr.utils.Collision;
	import bhvr.modules.BunkerSystem;
	import bhvr.modules.EnemyNukeSystem;
	import bhvr.modules.LandmarkSystem;
	import bhvr.views.CustomCursor;
	import Shared.AS3.COMPANIONAPP.CompanionAppMode;
	import bhvr.manager.InputManager;
	import Shared.PlatformChangeEvent;
	import flash.geom.Point;
	import bhvr.constatnts.GameConstants;
	import bhvr.views.Target;
	import bhvr.data.GamePersistantData;
	import bhvr.constatnts.GameConfig;
	import flash.events.Event;
	import bhvr.debug.Log;
	import bhvr.events.GameEvents;
	import bhvr.events.EventWithParams;
	import aze.motion.eaze;
	import bhvr.views.Landmark;
	import bhvr.views.Projectile;
	import bhvr.views.Missile;
	import bhvr.views.Nuke;
	import bhvr.views.Bomber;
	import bhvr.data.LevelUpVariables;
	import aze.motion.EazeTween;
	import flash.display.MovieClip;
	
	public class GameLevelState extends GameState
	{
		 
		
		protected var _xmlLoader:XMLLoader;
		
		protected var _config:XML;
		
		protected var _hud:Hud;
		
		protected var _collisionSystem:Collision;
		
		protected var _bunkerSystem:BunkerSystem;
		
		protected var _enemySystem:EnemyNukeSystem;
		
		protected var _landmarkSystem:LandmarkSystem;
		
		protected var _cursor:CustomCursor;
		
		protected const ALPHA_THRESHOLD_COLLISION:uint = 10;
		
		protected const TERMINATE_GAME_DELAY:Number = 0.5;
		
		protected const END_OF_GAME_DELAY:Number = 1.5;
		
		protected const TUTORIAL_OVERLAY_ID:String = "AtomicCommand";
		
		public function GameLevelState(id:int, assets:MovieClip, cursor:CustomCursor)
		{
			this._cursor = cursor;
			super(id,assets);
		}
		
		override public function initialize() : void
		{
			this.loadXMLConfig();
		}
		
		override public function enter() : void
		{
			super.enter();
			if(!CompanionAppMode.isOn)
			{
				this._cursor.show();
			}
			if(InputManager.instance.currentPlatform != PlatformChangeEvent.PLATFORM_INVALID && InputManager.instance.currentPlatform != PlatformChangeEvent.PLATFORM_PC_KB_MOUSE)
			{
				if(!CompanionAppMode.isOn)
				{
					this._cursor.setPosition(new Point(GameConstants.STAGE_WIDTH / 2,GameConstants.STAGE_HEIGHT / 2));
				}
			}
			this.initHud();
			this._bunkerSystem.start();
			this._landmarkSystem.start();
			var enemyTargets:Vector.<Target> = this._landmarkSystem.landmarks.concat();
			enemyTargets.push(this._bunkerSystem.canon);
			this._enemySystem.setTargets(enemyTargets);
			this._enemySystem.start();
			if(CompanionAppMode.isOn && !GamePersistantData.tutorialShown)
			{
				requestTutorialOverlay(this.TUTORIAL_OVERLAY_ID);
			}
			else
			{
				this._enemySystem.playInitialSoundAttack();
			}
		}
		
		override public function exit() : void
		{
			if(!CompanionAppMode.isOn)
			{
				this._cursor.hide();
			}
			super.exit();
		}
		
		protected function loadXMLConfig() : void
		{
			this._xmlLoader = new XMLLoader();
			this._xmlLoader.addEventListener(XMLLoader.XML_LOADED,this.onConfigLoaded,false,0,true);
			this._xmlLoader.load(GameConfig.GAME_XML_PATH);
		}
		
		private function onConfigLoaded(e:Event) : void
		{
			var variableName:String = null;
			this._config = this._xmlLoader.xml as XML;
			var variables:XMLList = this._config.children();
			var varNum:int = variables.length();
			for(var i:int = 0; i < varNum; i++)
			{
				variableName = variables[i].@name;
				if(variableName != "")
				{
					if(GameConstants[variableName] != null)
					{
						GameConstants[variableName] = variables[i];
					}
					else
					{
						Log.error("XML config parsing: ignored variable \'" + variableName + "\' : doesn\'t exist.");
					}
				}
				else
				{
					Log.error("XML config parsing: ignored variable #" + i + " : name empty.");
				}
			}
			this._xmlLoader.dispose();
			this._xmlLoader = null;
			this.initGame();
			onStateCreated();
		}
		
		protected function initGame() : void
		{
			InputManager.instance.setLeftStickSpeed();
			this._hud = new Hud(_assets.hudMc);
			this._collisionSystem = new Collision(_assets.bunkerSystemMc.missilesContainerMc,this.ALPHA_THRESHOLD_COLLISION);
			this._bunkerSystem = new BunkerSystem(_assets.bunkerSystemMc,this._cursor);
			this._bunkerSystem.addEventListener(GameEvents.MISSILE_FIRED,this.onMissileFired,false,0,true);
			this._bunkerSystem.addEventListener(GameEvents.CANON_DESTROYED,this.onCanonDestroyed,false,0,true);
			this._bunkerSystem.addEventListener(GameEvents.MISSILE_EXPLODING,this.onCollisionDetection,false,0,true);
			this._bunkerSystem.addEventListener(GameEvents.END_OF_DEFENSE,this.onDefenseEnd,false,0,true);
			this._landmarkSystem = new LandmarkSystem(_assets.landmarkSystemMc);
			this._landmarkSystem.addEventListener(GameEvents.LANDMARK_DESTROYED,this.onLandmarkDestroyed,false,0,true);
			this._enemySystem = new EnemyNukeSystem(_assets.enemySystemMc);
			this._enemySystem.addEventListener(GameEvents.NUKE_FIRED,this.onNukeFired,false,0,true);
			this._enemySystem.addEventListener(GameEvents.END_OF_ATTACK,this.onAttackEnd,false,0,true);
		}
		
		private function onMissileFired(e:EventWithParams) : void
		{
			this._hud.setMissileCounter(this._bunkerSystem.missileNumberRemaining);
		}
		
		private function onNukeFired(e:EventWithParams) : void
		{
			this._hud.setNukeCounter(this._enemySystem.nukeNumberRemaining);
		}
		
		private function onAttackEnd(e:EventWithParams) : void
		{
			var remainingMissiles:int = 0;
			var remainingLandmarks:int = 0;
			if(this._landmarkSystem.landmarkNumberRemaining > 0)
			{
				Log.info("-------------------------------------------");
				Log.info("--- End of Level: Proceed to Next Level ---");
				Log.info("-------------------------------------------");
				Log.info("Game Level: " + GamePersistantData.level);
				Log.info("Total score: " + GamePersistantData.totalScore);
				remainingMissiles = this._bunkerSystem.missileNumberRemaining;
				remainingLandmarks = this._landmarkSystem.landmarkNumberRemaining;
				Log.info("Number of missile remaining: " + this._bunkerSystem.missileNumberRemaining);
				Log.info("Number of landmarks remaining: " + this._landmarkSystem.landmarkNumberRemaining);
				this.setBonusScores(remainingMissiles,remainingLandmarks);
				this.terminateGame(GameEvents.GAME_LEVEL_UP);
			}
		}
		
		private function onDefenseEnd(e:EventWithParams) : void
		{
			eaze(this._enemySystem).delay(this.TERMINATE_GAME_DELAY).onComplete(this._enemySystem.terminate);
		}
		
		private function onCanonDestroyed(e:EventWithParams) : void
		{
			this._hud.setMissileCounter(this._bunkerSystem.missileNumberRemaining);
		}
		
		private function onLandmarkDestroyed(e:EventWithParams) : void
		{
			var landmark:Landmark = e.params.target as Landmark;
			GamePersistantData.removeLandmark(landmark.id);
			if(this._landmarkSystem.landmarkNumberRemaining == 0)
			{
				Log.info("-------------------------------------------");
				Log.info("---------------- GAME OVER ----------------");
				Log.info("-------------------------------------------");
				this.terminateGame(GameEvents.GAME_OVER);
			}
		}
		
		private function onCollisionDetection(e:EventWithParams) : void
		{
			var projectile:Projectile = null;
			var pt:Point = null;
			var i:uint = 0;
			var collisionPoints:Vector.<Point> = null;
			var j:int = 0;
			var missile:Missile = e.params.target;
			var projectiles:Vector.<Projectile> = this._enemySystem.activeProjectiles;
			if(projectiles != null && projectiles.length > 0)
			{
				for(i = 0; i < projectiles.length; i++)
				{
					projectile = projectiles[i];
					if(projectile != null && projectile.collider != null)
					{
						collisionPoints = projectile is Nuke?Nuke(projectile).collisionPoints:Bomber(projectile).collisionPoints;
						for(j = 0; j < collisionPoints.length; j++)
						{
							pt = collisionPoints[j];
							pt = projectile.collider.localToGlobal(pt);
							if(this._collisionSystem.simpleHitTestPoint(pt,missile.collider))
							{
								if(projectile is Nuke)
								{
									this._enemySystem.destroyNuke(Nuke(projectile));
									missile.victims++;
									GamePersistantData.gameScore.addNukePoints(missile.victims);
									this._hud.setScore(GamePersistantData.totalScore);
								}
								else
								{
									this._enemySystem.destroyBomber();
									GamePersistantData.gameScore.addBomberPoints();
									this._hud.setScore(GamePersistantData.totalScore);
								}
								break;
							}
						}
					}
				}
			}
		}
		
		private function setBonusScores(missileNum:int, landmarksNum:int) : void
		{
			GamePersistantData.gameScore.addMissilesBonusPoints(missileNum);
			GamePersistantData.gameScore.addLandmarksBonusPoints(landmarksNum);
			Log.info("Missile remaining score: " + GamePersistantData.gameScore.missilesBonus);
			Log.info("Landmarks remaining score: " + GamePersistantData.gameScore.landmarksBonus);
		}
		
		private function initHud() : void
		{
			if(this._hud)
			{
				this._hud.setLevel(GamePersistantData.level);
				this._hud.setMissileCounter(GameConstants.maxMissileNumber);
				this._hud.setNukeCounter(LevelUpVariables.getStartingNukesNumber());
				this._hud.setScore(GamePersistantData.totalScore);
			}
		}
		
		private function terminateGame(status:String) : void
		{
			this._bunkerSystem.stop();
			this._landmarkSystem.stop();
			this._enemySystem.stop();
			eaze(this).delay(this.END_OF_GAME_DELAY).onComplete(this.dispatchEndOfGameStatus,status);
		}
		
		private function dispatchEndOfGameStatus(status:String) : void
		{
			dispatchEvent(new EventWithParams(GameState.NAV_CONTINUE,{
				"target":this,
				"status":status
			}));
		}
		
		override public function Pause(paused:Boolean) : void
		{
			if(paused)
			{
				EazeTween.pauseAllTweens();
				this._bunkerSystem.pause();
				this._landmarkSystem.pause();
			}
			else
			{
				EazeTween.resumeAllTweens();
				this._bunkerSystem.resume();
				this._landmarkSystem.resume();
			}
		}
		
		override public function dispose() : void
		{
			this._hud = null;
			this._collisionSystem.dispose();
			this._collisionSystem = null;
			this._bunkerSystem.dispose();
			this._bunkerSystem = null;
			this._enemySystem.dispose();
			this._enemySystem = null;
			this._landmarkSystem.dispose();
			this._landmarkSystem = null;
			super.dispose();
		}
	}
}
