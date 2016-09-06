package bhvr.states
{
	import bhvr.utils.XMLLoader;
	import bhvr.views.Hud;
	import bhvr.utils.Collision;
	import bhvr.modules.DefenseSystem;
	import bhvr.modules.AttackSystem;
	import bhvr.events.GameEvents;
	import bhvr.manager.SoundManager;
	import bhvr.data.SoundList;
	import Shared.AS3.COMPANIONAPP.CompanionAppMode;
	import bhvr.data.GamePersistantData;
	import bhvr.constatnts.GameConfig;
	import flash.events.Event;
	import bhvr.constatnts.GameConstants;
	import bhvr.debug.Log;
	import bhvr.events.EventWithParams;
	import bhvr.views.Alien;
	import bhvr.views.LaserProjectile;
	import bhvr.views.Cow;
	import bhvr.views.MotherShip;
	import bhvr.views.AlienProjectile;
	import bhvr.views.Laser;
	import bhvr.views.Barn;
	import flash.display.MovieClip;
	import flash.geom.Point;
	import bhvr.utils.FlashUtil;
	import bhvr.data.LocalizationStrings;
	import Shared.BGSExternalInterface;
	import bhvr.manager.InputManager;
	import bhvr.constatnts.GameInputs;
	import aze.motion.EazeTween;
	
	public class GameLevelState extends GameState
	{
		 
		
		protected var _xmlLoader:XMLLoader;
		
		protected var _config:XML;
		
		protected var _hud:Hud;
		
		protected var _collisionSystem:Collision;
		
		protected var _defenseSystem:DefenseSystem;
		
		protected var _attackSystem:AttackSystem;
		
		protected const TUTORIAL_OVERLAY_ID:String = "Zeta";
		
		protected const GAME_OVER_LINKAGE_ID:String = "GameOverMc";
		
		protected const ALPHA_THRESHOLD_COLLISION:uint = 10;
		
		public function GameLevelState(id:int, assets:MovieClip)
		{
			super(id,assets);
		}
		
		override public function initialize() : void
		{
			this.loadXMLConfig();
		}
		
		override public function enter() : void
		{
			super.enter();
			this.initHud();
			this._defenseSystem.addEventListener(GameEvents.LASER_SHOOTING_ALIENS,this.onShootingAliens,false,0,true);
			this._defenseSystem.addEventListener(GameEvents.LASER_RESPAWNED,this.onLaserRespawned,false,0,true);
			this._defenseSystem.addEventListener(GameEvents.GAME_OVER,this.onGameOver,false,0,true);
			this._attackSystem.addEventListener(GameEvents.ALIEN_SHOOTING_LASER,this.onShootingLaser,false,0,true);
			this._attackSystem.addEventListener(GameEvents.ALIEN_WAVE_HIT_BARNS,this.onBarnsHitByAliens,false,0,true);
			this._attackSystem.addEventListener(GameEvents.GAME_OVER,this.onGameOver,false,0,true);
			this._attackSystem.addEventListener(GameEvents.COW_ABDUCT,this.onCowAbduct,false,0,true);
			this._attackSystem.addEventListener(GameEvents.COW_ABDUCTED,this.onCowAbducted,false,0,true);
			this._defenseSystem.start();
			this._attackSystem.start();
			SoundManager.instance.startSound(SoundList.GAME_MUSIC_LOOP_SOUND_ID);
			if(CompanionAppMode.isOn && !GamePersistantData.tutorialShown)
			{
				requestTutorialOverlay(this.TUTORIAL_OVERLAY_ID);
			}
		}
		
		override public function exit() : void
		{
			super.exit();
			this.removeGameOverPanel();
		}
		
		private function freeze() : void
		{
			this._hud.setLives(GamePersistantData.lifeNum,true);
			this._defenseSystem.freeze();
			this._attackSystem.freeze();
		}
		
		private function unfreeze() : void
		{
			this._defenseSystem.unfreeze();
			this._attackSystem.unfreeze();
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
			this._hud = new Hud(_assets.hudMc);
			this._collisionSystem = new Collision(_assets.attackSystemMc,this.ALPHA_THRESHOLD_COLLISION);
			this._defenseSystem = new DefenseSystem(_assets.defenseSystemMc);
			this._attackSystem = new AttackSystem(_assets.attackSystemMc,this._defenseSystem.barnController);
		}
		
		private function onLaserRespawned(e:EventWithParams) : void
		{
			this.unfreeze();
		}
		
		private function onShootingAliens(e:EventWithParams) : void
		{
			var alien:Alien = null;
			var alienType:String = null;
			var hasTractorBeam:Boolean = false;
			var projectile:LaserProjectile = e.params.target as LaserProjectile;
			var cow:Cow = this._attackSystem.cow;
			if(cow != null && cow.collider != null)
			{
				if(this._collisionSystem.simpleHitTestObject(projectile,cow.collider))
				{
					this.destroyCow(cow);
				}
			}
			var activeAlienNum:int = this._attackSystem.alienWave.activeAlienNum;
			var motherShip:MotherShip = this._attackSystem.motherShip;
			for(var i:uint = 0; i < activeAlienNum; i++)
			{
				alien = this._attackSystem.alienWave.container.getChildAt(i) as Alien;
				alienType = alien.type;
				hasTractorBeam = alien.hasTractorBeam;
				if(alien != null && alien.collider != null)
				{
					if(this._collisionSystem.simpleHitTestObject(projectile,alien.collider))
					{
						this.destroyAlien(alien);
						break;
					}
				}
			}
			if(motherShip != null)
			{
				if(this._collisionSystem.simpleHitTestObject(projectile,motherShip.collider))
				{
					this.destroyMotherShip(motherShip);
				}
			}
		}
		
		private function destroyCow(cow:Cow) : void
		{
			cow.destroy();
			this._attackSystem.alienWave.alienUfoTractor.closeTractorBeam();
			this._attackSystem.alienWave.endUfoTractor();
			this._defenseSystem.laser.terminateShoot();
			GamePersistantData.gameScore.removeCowPoints();
			this._hud.displayBonusPoints(-GameConstants.scoreCow,Hud.BONUS_COW,cow.position);
			this._hud.setScore(GamePersistantData.totalScore);
		}
		
		private function destroyAlien(alien:Alien) : void
		{
			this._attackSystem.destroyAlien(alien);
			this._defenseSystem.laser.terminateShoot();
			if(alien.hasTractorBeam)
			{
				this._attackSystem.releaseCow();
				GamePersistantData.gameScore.addTractorBeamPoints();
				this._hud.displayBonusPoints(GameConstants.scoreAlienUFOTractor,Hud.BONUS_COW,this._attackSystem.cow.position);
			}
			else
			{
				GamePersistantData.gameScore.addAlienPoints(alien.type);
			}
			this._hud.setScore(GamePersistantData.totalScore);
		}
		
		private function destroyMotherShip(target:MotherShip) : void
		{
			this._attackSystem.destroyMotherShip();
			this._defenseSystem.laser.terminateShoot();
			GamePersistantData.gameScore.addMotherShipPoints();
			this._hud.displayBonusPoints(GameConstants.scoreMothership,Hud.BONUS_MOTHERSHIP,target.position);
			this._hud.setScore(GamePersistantData.totalScore);
		}
		
		private function onShootingLaser(e:EventWithParams) : void
		{
			var alien:Alien = e.params.alien as Alien;
			var projectile:AlienProjectile = alien.projectile;
			var laser:Laser = this._defenseSystem.laser;
			if(laser != null && laser.collider != null)
			{
				if(this._collisionSystem.simpleHitTestObject(projectile,laser.collider))
				{
					alien.terminateShoot();
					this.destroyLaser();
				}
			}
		}
		
		private function onBarnsHitByAliens(e:EventWithParams) : void
		{
			var alien:Alien = null;
			var barn:Barn = null;
			var barnPieceNum:int = 0;
			var barnPieces:Vector.<MovieClip> = null;
			var barnPiece:MovieClip = null;
			var alienPos:Point = null;
			var j:uint = 0;
			var k:uint = 0;
			var activeAlienNum:int = this._attackSystem.alienWave.activeAlienNum;
			var barnNum:int = this._defenseSystem.barnController.barns.length;
			for(var i:uint = 0; i < activeAlienNum; i++)
			{
				alien = this._attackSystem.alienWave.container.getChildAt(i) as Alien;
				alienPos = FlashUtil.localToGlobalPosition(alien);
				if(alienPos.y > GameConstants.barnsInitialYPosition)
				{
					for(j = 0; j < barnNum; j++)
					{
						barn = this._defenseSystem.barnController.barns[j];
						barnPieces = barn.alivePieces;
						barnPieceNum = barnPieces.length;
						for(k = 0; k < barnPieceNum; k++)
						{
							barnPiece = barnPieces[k];
							if(alien != null && alien.collider != null && barnPiece != null)
							{
								if(this._collisionSystem.simpleHitTestObject(alien.collider,barnPiece))
								{
									barn.destroyPiece(barnPiece);
								}
							}
						}
					}
				}
			}
		}
		
		private function onCowAbduct(e:EventWithParams) : void
		{
			var cow:Cow = e.params.target as Cow;
			this._hud.displayBonusPoints(-GameConstants.scoreCow,Hud.BONUS_COW,cow.position);
			this._attackSystem.alienWave.endUfoTractor();
		}
		
		private function onCowAbducted(e:EventWithParams) : void
		{
			GamePersistantData.gameScore.removeCowPoints();
			this._hud.setScore(GamePersistantData.totalScore);
		}
		
		private function onGameOver(e:EventWithParams) : void
		{
			Log.info("-------------------------------------------");
			Log.info("---------------- GAME OVER ----------------");
			Log.info("-------------------------------------------");
			Log.info("Life remaining: " + GamePersistantData.lifeNum);
			Log.info("Score: " + GamePersistantData.totalScore);
			this.terminateGame();
			this.addGameOverPanel();
		}
		
		private function destroyLaser() : void
		{
			this._defenseSystem.destroyLaser();
			this.freeze();
		}
		
		private function initHud() : void
		{
			if(this._hud)
			{
				this._hud.setScore(0);
				this._hud.setLives(GameConstants.MAX_NUMBER_OF_LIVES);
			}
		}
		
		private function addGameOverPanel() : void
		{
			var gameOver:MovieClip = FlashUtil.getLibraryItem(_assets,this.GAME_OVER_LINKAGE_ID) as MovieClip;
			this.setGameOverContent(gameOver);
			_assets.gameOverContainerMc.addChild(gameOver);
		}
		
		private function setGameOverContent(mc:MovieClip) : void
		{
			mc.titleMc.titleTxt.text = LocalizationStrings.GAME_OVER_LABEL;
			mc.instructionsMc.instructionsAnimMc.instructionsTxt.text = LocalizationStrings.PRESS_REPLAY;
			SoundManager.instance.startLongSound(SoundList.GAME_OVER_SOUND_ID);
			if(GamePersistantData.totalScore > GamePersistantData.highScore)
			{
				GamePersistantData.highScore = GamePersistantData.totalScore;
				BGSExternalInterface.call(BGSCodeObj,"setHighscore",GameConfig.GAME_HIGH_SCORE_KEY,GamePersistantData.highScore);
				mc.highScoreMc.highScoreTxt.text = LocalizationStrings.NEW_HIGH_SCORE_LABEL + ": " + GamePersistantData.totalScore;
			}
			else
			{
				mc.highScoreMc.highScoreTxt.text = LocalizationStrings.HIGH_SCORE_LABEL + ": " + GamePersistantData.highScore;
			}
		}
		
		private function removeGameOverPanel() : void
		{
			if(_assets.gameOverContainerMc.numChildren > 0)
			{
				_assets.gameOverContainerMc.removeChildAt(0);
			}
		}
		
		private function terminateGame() : void
		{
			this._defenseSystem.removeEventListener(GameEvents.LASER_SHOOTING_ALIENS,this.onShootingAliens);
			this._defenseSystem.removeEventListener(GameEvents.LASER_RESPAWNED,this.onLaserRespawned);
			this._defenseSystem.removeEventListener(GameEvents.GAME_OVER,this.onGameOver);
			this._attackSystem.removeEventListener(GameEvents.ALIEN_SHOOTING_LASER,this.onShootingLaser);
			this._attackSystem.removeEventListener(GameEvents.ALIEN_WAVE_HIT_BARNS,this.onBarnsHitByAliens);
			this._attackSystem.removeEventListener(GameEvents.GAME_OVER,this.onGameOver);
			this._attackSystem.removeEventListener(GameEvents.COW_ABDUCT,this.onCowAbduct);
			this._attackSystem.removeEventListener(GameEvents.COW_ABDUCTED,this.onCowAbducted);
			this._defenseSystem.stop();
			this._attackSystem.stop();
			SoundManager.instance.stopSound(SoundList.GAME_MUSIC_LOOP_SOUND_ID);
			InputManager.instance.addEventListener(GameInputs.ACCEPT,this.onEndGame,false,0,true);
		}
		
		private function onEndGame(e:Event) : void
		{
			SoundManager.instance.playSound(SoundList.PRESS_START_SOUND);
			InputManager.instance.removeEventListener(GameInputs.ACCEPT,this.onEndGame);
			onNavContinue();
		}
		
		override public function Pause(paused:Boolean) : void
		{
			var gameOverPanel:MovieClip = null;
			super.Pause(paused);
			if(_assets.gameOverContainerMc.numChildren == 0)
			{
				this._defenseSystem.pause(paused);
				this._attackSystem.pause(paused);
			}
			if(paused)
			{
				EazeTween.pauseAllTweens();
				if(_assets.gameOverContainerMc.numChildren > 0)
				{
					InputManager.instance.removeEventListener(GameInputs.ACCEPT,this.onEndGame);
					gameOverPanel = _assets.gameOverContainerMc.getChildAt(0) as MovieClip;
					gameOverPanel.stop();
					gameOverPanel.alienFrameMc.stop();
					gameOverPanel.instructionsMc.stop();
				}
			}
			else
			{
				EazeTween.resumeAllTweens();
				if(_assets.gameOverContainerMc.numChildren > 0)
				{
					InputManager.instance.addEventListener(GameInputs.ACCEPT,this.onEndGame,false,0,true);
					gameOverPanel = _assets.gameOverContainerMc.getChildAt(0) as MovieClip;
					gameOverPanel.instructionsMc.play();
					gameOverPanel.alienFrameMc.play();
					if(gameOverPanel.instructionsMc.alpha == 0)
					{
						gameOverPanel.play();
					}
				}
			}
		}
		
		override public function dispose() : void
		{
			this._collisionSystem.dispose();
			this._collisionSystem = null;
			this._defenseSystem.dispose();
			this._defenseSystem = null;
			this._attackSystem.dispose();
			this._attackSystem = null;
			super.dispose();
		}
	}
}
