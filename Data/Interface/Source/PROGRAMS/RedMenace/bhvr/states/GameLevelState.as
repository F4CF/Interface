package bhvr.states
{
	import bhvr.utils.XMLLoader;
	import bhvr.controller.StageController;
	import bhvr.views.Hud;
	import bhvr.events.GameEvents;
	import Shared.AS3.COMPANIONAPP.CompanionAppMode;
	import bhvr.data.GamePersistantData;
	import bhvr.constants.GameConfig;
	import flash.events.Event;
	import bhvr.constants.GameConstants;
	import bhvr.debug.Log;
	import aze.motion.eaze;
	import bhvr.modules.Stage1;
	import bhvr.modules.Stage2;
	import bhvr.modules.Stage3;
	import bhvr.events.EventWithParams;
	import bhvr.views.Bomb;
	import bhvr.manager.SoundManager;
	import bhvr.data.SoundList;
	import bhvr.views.MiniBoss;
	import aze.motion.EazeTween;
	import flash.display.MovieClip;
	
	public class GameLevelState extends GameState
	{
		 
		
		protected var _xmlLoader:XMLLoader;
		
		protected var _config:XML;
		
		private var _stageController:StageController;
		
		protected var _hud:Hud;
		
		protected const TUTORIAL_OVERLAY_ID:String = "RedMenace";
		
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
			this._stageController = this.createStage();
			if(this._stageController != null)
			{
				this._stageController.addEventListener(GameEvents.STAGE_RESET,this.onStageReset,false,0,true);
				this._stageController.addEventListener(GameEvents.HERO_WIN,this.onHeroWon,false,0,true);
				this._stageController.addEventListener(GameEvents.HERO_DAMAGED,this.onHeroDamaged,false,0,true);
				this._stageController.addEventListener(GameEvents.HERO_DEAD,this.onGameOver,false,0,true);
				this._stageController.addEventListener(GameEvents.BOSS_LOST_STAGE,this.onNextStage,false,0,true);
				this._stageController.addEventListener(GameEvents.BOMB_BONUS,this.onBonusBomb,false,0,true);
				this._stageController.addEventListener(GameEvents.MINI_BOSS_BONUS,this.onBonusMiniBoss,false,0,true);
				this._stageController.start();
			}
			this.resetTimer();
			this.initHud();
			if(CompanionAppMode.isOn && !GamePersistantData.tutorialShown)
			{
				requestTutorialOverlay(this.TUTORIAL_OVERLAY_ID);
			}
		}
		
		override public function exit() : void
		{
			if(this._stageController != null)
			{
				this._stageController.removeEventListener(GameEvents.STAGE_RESET,this.onStageReset);
				this._stageController.removeEventListener(GameEvents.HERO_WIN,this.onHeroWon);
				this._stageController.removeEventListener(GameEvents.HERO_DAMAGED,this.onHeroDamaged);
				this._stageController.removeEventListener(GameEvents.HERO_DEAD,this.onGameOver);
				this._stageController.removeEventListener(GameEvents.BOSS_LOST_STAGE,this.onNextStage);
				this._stageController.removeEventListener(GameEvents.BOMB_BONUS,this.onBonusBomb);
				this._stageController.removeEventListener(GameEvents.MINI_BOSS_BONUS,this.onBonusMiniBoss);
				this._stageController.dispose();
				this._stageController = null;
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
			this._hud = new Hud(_assets.hudMc);
		}
		
		private function initHud() : void
		{
			this._hud.setLives(GamePersistantData.lifeNum);
			this._hud.setScore(GamePersistantData.score);
			this._hud.setBonusTimer(GamePersistantData.bonusTimer);
			this._hud.setHighScore(GamePersistantData.highScore);
		}
		
		private function startTimer() : void
		{
			eaze(this._hud).delay(1).onComplete(this.onUpdateTimer);
		}
		
		private function stopTimer() : void
		{
			eaze(this._hud).killTweens();
			this._hud.stopBonusTimerAnimation();
		}
		
		private function resetTimer() : void
		{
			this.stopTimer();
			GamePersistantData.resetBonusTimerPoints();
			this.startTimer();
		}
		
		private function onUpdateTimer() : void
		{
			GamePersistantData.removeBonusTimerPoints();
			if(GamePersistantData.bonusTimer > 0)
			{
				this.startTimer();
			}
			else
			{
				this._stageController.setTimeOver();
			}
			this._hud.setBonusTimer(GamePersistantData.bonusTimer);
		}
		
		private function createStage() : StageController
		{
			_assets.stage1.visible = false;
			_assets.stage2.visible = false;
			_assets.stage3.visible = false;
			switch(GamePersistantData.stage)
			{
				case GamePersistantData.STAGE_1:
					return new Stage1(_assets.stage1);
				case GamePersistantData.STAGE_2:
					return new Stage2(_assets.stage2);
				case GamePersistantData.STAGE_3:
					return new Stage3(_assets.stage3);
				default:
					Log.error("No stage created!");
					return null;
			}
		}
		
		private function onBonusBomb(e:EventWithParams) : void
		{
			var bomb:Bomb = e.params.target as Bomb;
			GamePersistantData.addBombPoints();
			this._hud.displayBombBonus(bomb.x,bomb.y);
			this._hud.setScore(GamePersistantData.score);
			SoundManager.instance.playSound(SoundList.HERO_BONUS_SOUND);
		}
		
		private function onBonusMiniBoss(e:EventWithParams) : void
		{
			var miniBoss:MiniBoss = e.params.target as MiniBoss;
			GamePersistantData.addMiniBossPoints();
			this._hud.displayMiniBossBonus(miniBoss.position.x,miniBoss.position.y);
			this._hud.setScore(GamePersistantData.score);
			SoundManager.instance.playSound(SoundList.HERO_BONUS_SOUND);
		}
		
		private function onHeroDamaged(e:EventWithParams) : void
		{
			GamePersistantData.removeLife();
			this._hud.setLives(GamePersistantData.lifeNum);
			if(GamePersistantData.lifeNum == 0)
			{
				this.stopGame();
				this._stageController.startMusic(SoundList.LOSE_MUSIC_LOOP_SOUND_ID);
			}
			else
			{
				this.stopTimer();
				this._stageController.startMusic(SoundList.LOSE_MUSIC_LOOP_SOUND_ID);
			}
		}
		
		private function onHeroWon(e:EventWithParams) : void
		{
			this.stopGame();
			GamePersistantData.addBonusTimerPoints();
			this._hud.transferBonusToScore();
		}
		
		private function onNextStage(e:EventWithParams) : void
		{
			dispatchEvent(new EventWithParams(GameState.NAV_CONTINUE,{
				"target":this,
				"status":GameEvents.GAME_LEVEL_UP
			}));
		}
		
		private function onGameOver(e:EventWithParams) : void
		{
			dispatchEvent(new EventWithParams(GameState.NAV_CONTINUE,{
				"target":this,
				"status":GameEvents.GAME_OVER
			}));
		}
		
		private function onStageReset(e:EventWithParams) : void
		{
			this.resetTimer();
			this._hud.setBonusTimer(GamePersistantData.bonusTimer);
		}
		
		private function stopGame() : void
		{
			this.stopTimer();
			Log.info("-------------------------------------------");
			Log.info("---------------- GAME OVER ----------------");
			Log.info("-------------------------------------------");
			Log.info("Curretn level: " + GamePersistantData.level);
			Log.info("Curretn stage: " + GamePersistantData.stage);
			Log.info("Life remaining: " + GamePersistantData.lifeNum);
			Log.info("Score: " + GamePersistantData.score);
			Log.info("Bonus Timer remaining: " + GamePersistantData.bonusTimer);
		}
		
		override public function Pause(paused:Boolean) : void
		{
			super.Pause(paused);
			if(paused)
			{
				EazeTween.pauseAllTweens();
				if(this._stageController != null)
				{
					this._stageController.removeEventListener(GameEvents.STAGE_RESET,this.onStageReset);
					this._stageController.removeEventListener(GameEvents.HERO_WIN,this.onHeroWon);
					this._stageController.removeEventListener(GameEvents.HERO_DAMAGED,this.onHeroDamaged);
					this._stageController.removeEventListener(GameEvents.HERO_DEAD,this.onGameOver);
					this._stageController.removeEventListener(GameEvents.BOSS_LOST_STAGE,this.onNextStage);
					this._stageController.removeEventListener(GameEvents.BOMB_BONUS,this.onBonusBomb);
					this._stageController.removeEventListener(GameEvents.MINI_BOSS_BONUS,this.onBonusMiniBoss);
					this._stageController.pause();
				}
				this._hud.pause();
			}
			else
			{
				EazeTween.resumeAllTweens();
				if(this._stageController != null)
				{
					this._stageController.addEventListener(GameEvents.STAGE_RESET,this.onStageReset,false,0,true);
					this._stageController.addEventListener(GameEvents.HERO_WIN,this.onHeroWon,false,0,true);
					this._stageController.addEventListener(GameEvents.HERO_DAMAGED,this.onHeroDamaged,false,0,true);
					this._stageController.addEventListener(GameEvents.HERO_DEAD,this.onGameOver,false,0,true);
					this._stageController.addEventListener(GameEvents.BOSS_LOST_STAGE,this.onNextStage,false,0,true);
					this._stageController.addEventListener(GameEvents.BOMB_BONUS,this.onBonusBomb,false,0,true);
					this._stageController.addEventListener(GameEvents.MINI_BOSS_BONUS,this.onBonusMiniBoss,false,0,true);
					this._stageController.resume();
				}
				this._hud.resume();
			}
		}
		
		override public function dispose() : void
		{
			super.dispose();
		}
	}
}
