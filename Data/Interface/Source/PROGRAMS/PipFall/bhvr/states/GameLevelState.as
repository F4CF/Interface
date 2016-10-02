package bhvr.states
{
	import bhvr.utils.XMLLoader;
	import bhvr.views.Hud;
	import bhvr.modules.LevelGenerator;
	import bhvr.controller.LevelController;
	import bhvr.events.GameEvents;
	import bhvr.constants.GameConstants;
	import bhvr.constants.GameConfig;
	import flash.events.Event;
	import bhvr.debug.Log;
	import bhvr.manager.InputManager;
	import bhvr.constants.GameInputs;
	import bhvr.events.EventWithParams;
	import Shared.AS3.COMPANIONAPP.CompanionAppMode;
	import bhvr.data.GamePersistantData;
	import aze.motion.eaze;
	import aze.motion.EazeTween;
	import flash.display.MovieClip;
	
	public class GameLevelState extends GameState
	{
		 
		
		protected var _xmlLoader:XMLLoader;
		
		protected var _config:XML;
		
		protected var _hud:Hud;
		
		protected var _levelGenerator:LevelGenerator;
		
		protected var _levelController:LevelController;
		
		protected var _currentTime:uint;
		
		protected const TUTORIAL_OVERLAY_ID:String = "PipFall";
		
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
			this._levelGenerator.randomizeData();
			this._levelController = new LevelController(_assets,this._levelGenerator.screensData);
			this._levelController.addEventListener(GameEvents.PLAYER_DAMAGED,this.onPlayerDamaged,false,0,true);
			this._levelController.addEventListener(GameEvents.PLAYER_DEAD,this.onPlayerGameOver,false,0,true);
			this._levelController.addEventListener(GameEvents.PLAYER_LOOSE,this.onPlayerGameOver,false,0,true);
			this._levelController.addEventListener(GameEvents.PLAYER_WIN,this.onPlayerGameOver,false,0,true);
			this._levelController.addEventListener(GameEvents.PLAYER_WIN_LIFE,this.onPlayerWinLife,false,0,true);
			this._levelController.addEventListener(GameEvents.BOBBLE_HEAD_COLLECTED,this.onBobbleHeadCollected,false,0,true);
			this._levelController.setInitialScreen();
			this._currentTime = GameConstants.maxTime;
			this.initHud();
			_assets.gotoAndStop(0);
		}
		
		override public function exit() : void
		{
			this._levelController.removeEventListener(GameEvents.PLAYER_DAMAGED,this.onPlayerDamaged);
			this._levelController.removeEventListener(GameEvents.PLAYER_DEAD,this.onPlayerGameOver);
			this._levelController.removeEventListener(GameEvents.PLAYER_LOOSE,this.onPlayerGameOver);
			this._levelController.removeEventListener(GameEvents.PLAYER_WIN,this.onPlayerGameOver);
			this._levelController.removeEventListener(GameEvents.PLAYER_WIN_LIFE,this.onPlayerWinLife);
			this._levelController.removeEventListener(GameEvents.BOBBLE_HEAD_COLLECTED,this.onBobbleHeadCollected);
			this._levelController.dispose();
			this._levelController = null;
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
			this._levelGenerator = new LevelGenerator(_assets);
		}
		
		private function initHud() : void
		{
			for(var i:uint = 0; i < GameConstants.livesMaxNum; i++)
			{
				if(i < GameConstants.livesInitNum)
				{
					this._hud.setLife(i,true);
				}
				else
				{
					this._hud.setLife(i,false);
				}
			}
			this._hud.setTimer(this._currentTime);
			this._hud.setBobbleHead();
			this._hud.setInstructionsVisibility(true,true);
			this._hud.addEventListener(Hud.INSTRUCTIONS_ON,this.onInstructionsStarted,false,0,true);
			this._hud.addEventListener(Hud.INSTRUCTIONS_OFF,this.startGameplay,false,0,true);
		}
		
		private function onInstructionsStarted(e:Event) : void
		{
			InputManager.instance.addEventListener(GameInputs.ACCEPT,this.onInstructionsFinished,false,0,true);
		}
		
		private function onInstructionsFinished(e:EventWithParams) : void
		{
			this._hud.setInstructionsVisibility(false,false);
			this.startGameplay();
		}
		
		private function startGameplay(e:Event = null) : void
		{
			InputManager.instance.removeEventListener(GameInputs.ACCEPT,this.onInstructionsFinished);
			this._currentTime = GameConstants.maxTime;
			this.startTimer();
			this._levelController.start();
			if(CompanionAppMode.isOn && !GamePersistantData.tutorialShown)
			{
				requestTutorialOverlay(this.TUTORIAL_OVERLAY_ID);
			}
		}
		
		private function startTimer() : void
		{
			eaze(this._hud).delay(1).onComplete(this.onUpdateTimer);
		}
		
		private function stopTimer() : void
		{
			eaze(this._hud).killTweens();
		}
		
		private function onUpdateTimer() : void
		{
			if(this._currentTime > 0)
			{
				this._currentTime--;
				eaze(this._hud).delay(1).onComplete(this.onUpdateTimer);
			}
			else
			{
				this.stopGame();
				this._levelController.setTimerOver();
			}
			this._hud.setTimer(this._currentTime);
		}
		
		private function onPlayerDamaged(e:EventWithParams) : void
		{
			this._hud.removeLife(GamePersistantData.lifeNum);
			if(GamePersistantData.lifeNum == 0)
			{
				this.stopGame();
			}
		}
		
		private function onPlayerGameOver(e:EventWithParams) : void
		{
			eaze(_assets).play("fadeOutStart>fadeOutEnd").onComplete(this.onExitComplete);
		}
		
		private function onExitComplete() : void
		{
			dispatchEvent(new EventWithParams(GameState.NAV_CONTINUE,{"target":this}));
		}
		
		private function onPlayerWinLife(e:EventWithParams) : void
		{
			this._hud.addLife(GamePersistantData.lifeNum - 1);
		}
		
		private function onBobbleHeadCollected(e:EventWithParams) : void
		{
			this._hud.setBobbleHead();
			if(GamePersistantData.bobbleHeadNum == GameConstants.numBobbleHead)
			{
				this.stopGame();
				this._levelController.setVictory();
			}
		}
		
		private function stopGame() : void
		{
			this.stopTimer();
			GamePersistantData.timeRemaining = this._currentTime;
			Log.info("-------------------------------------------");
			Log.info("---------------- GAME OVER ----------------");
			Log.info("-------------------------------------------");
			Log.info("Life remaining: " + GamePersistantData.lifeNum);
			Log.info("BobbleHead collected: " + GamePersistantData.bobbleHeadNum);
			Log.info("Time remaining: " + this._currentTime);
		}
		
		override public function Pause(paused:Boolean) : void
		{
			if(paused)
			{
				EazeTween.pauseAllTweens();
				if(this._levelController)
				{
					this._levelController.removeEventListener(GameEvents.PLAYER_DAMAGED,this.onPlayerDamaged);
					this._levelController.removeEventListener(GameEvents.PLAYER_DEAD,this.onPlayerGameOver);
					this._levelController.removeEventListener(GameEvents.PLAYER_LOOSE,this.onPlayerGameOver);
					this._levelController.removeEventListener(GameEvents.PLAYER_WIN,this.onPlayerGameOver);
					this._levelController.removeEventListener(GameEvents.PLAYER_WIN_LIFE,this.onPlayerWinLife);
					this._levelController.removeEventListener(GameEvents.BOBBLE_HEAD_COLLECTED,this.onBobbleHeadCollected);
					this._levelController.pause();
				}
			}
			else
			{
				EazeTween.resumeAllTweens();
				if(this._levelController)
				{
					this._levelController.addEventListener(GameEvents.PLAYER_DAMAGED,this.onPlayerDamaged,false,0,true);
					this._levelController.addEventListener(GameEvents.PLAYER_DEAD,this.onPlayerGameOver,false,0,true);
					this._levelController.addEventListener(GameEvents.PLAYER_LOOSE,this.onPlayerGameOver,false,0,true);
					this._levelController.addEventListener(GameEvents.PLAYER_WIN,this.onPlayerGameOver,false,0,true);
					this._levelController.addEventListener(GameEvents.PLAYER_WIN_LIFE,this.onPlayerWinLife,false,0,true);
					this._levelController.addEventListener(GameEvents.BOBBLE_HEAD_COLLECTED,this.onBobbleHeadCollected,false,0,true);
					this._levelController.resume();
				}
			}
		}
		
		override public function dispose() : void
		{
			super.dispose();
		}
	}
}
