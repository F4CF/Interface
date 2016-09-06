package bhvr.controller
{
	import flash.events.EventDispatcher;
	import flash.display.MovieClip;
	import bhvr.states.GameState;
	import bhvr.states.PauseState;
	import bhvr.states.ConfirmQuitState;
	import bhvr.constants.GameConfig;
	import bhvr.states.TitleState;
	import bhvr.states.PartySelectState;
	import bhvr.states.MapState;
	import bhvr.states.CombatState;
	import bhvr.states.RewardState;
	import bhvr.states.InteractionState;
	import bhvr.states.GameOverState;
	import bhvr.debug.Log;
	import bhvr.manager.SaveManager;
	import bhvr.events.EventWithParams;
	
	public class StateController extends EventDispatcher
	{
		
		public static const CONFIRM_QUIT:int = -3;
		
		public static const PAUSE:int = -2;
		
		public static const NOT_STARTED:int = -1;
		
		public static const TITLE:int = 0;
		
		public static const PARTY_SELECT_EVENT:int = 1;
		
		public static const WORLD_MAP:int = 2;
		
		public static const INTERACTION_EVENT:int = 3;
		
		public static const REWARD_EVENT:int = 4;
		
		public static const COMBAT_EVENT:int = 5;
		
		public static const GAME_OVER:int = 6;
		
		public static const NUMBER_OF_STATES:int = 7;
		 
		
		public var BGSCodeObj:Object;
		
		private var _assets:Vector.<MovieClip>;
		
		private var _states:Vector.<GameState>;
		
		private var _pauseState:PauseState;
		
		private var _confirmQuitState:ConfirmQuitState;
		
		private var _statesReadyNum:int;
		
		private var _currentState:int;
		
		public function StateController(assets:Vector.<MovieClip>)
		{
			super();
			this._assets = assets;
			this._states = new Vector.<GameState>();
			this._currentState = NOT_STARTED;
		}
		
		public function initialize() : void
		{
			this._statesReadyNum = 0;
			for(var i:uint = 0; i < NUMBER_OF_STATES; i++)
			{
				this._states.push(this.createState(i));
				this._states[i].BGSCodeObj = this.BGSCodeObj;
				this._states[i].addEventListener(GameState.STATE_CREATED,this.onStateCreated,false,0,true);
				this._states[i].addEventListener(GameState.NAV_CONTINUE,this.onContinue,false,0,true);
				this._states[i].addEventListener(GameState.NAV_BACK,this.onBack,false,0,true);
				this._states[i].addEventListener(GameState.TUTORIAL_REQUESTED,this.onTutorialRequested,false,0,true);
				this._states[i].initialize();
			}
			this._pauseState = this.createState(PAUSE) as PauseState;
			this._pauseState.addEventListener(GameState.STATE_CREATED,this.onStateCreated,false,0,true);
			this._pauseState.addEventListener(PauseState.READY_TO_RESUME,this.onResume,false,0,true);
			this._pauseState.initialize();
			this._confirmQuitState = this.createState(CONFIRM_QUIT) as ConfirmQuitState;
			this._confirmQuitState.addEventListener(GameState.STATE_CREATED,this.onStateCreated,false,0,true);
			this._confirmQuitState.addEventListener(ConfirmQuitState.QUIT,this.onQuitConfirmed,false,0,true);
			this._confirmQuitState.addEventListener(ConfirmQuitState.CANCEL,this.onQuitCancelled,false,0,true);
			this._confirmQuitState.initialize();
		}
		
		private function createState(state:int) : GameState
		{
			switch(state)
			{
				case PAUSE:
					return new PauseState(state,this._assets[GameConfig.getAssetIdFromUrl(GameConfig.GAME_PAUSE_ASSETS_PATH)]);
				case CONFIRM_QUIT:
					return new ConfirmQuitState(state,this._assets[GameConfig.getAssetIdFromUrl(GameConfig.GAME_CONFIRM_QUIT_ASSETS_PATH)]);
				case TITLE:
					return new TitleState(state,this._assets[GameConfig.getAssetIdFromUrl(GameConfig.GAME_TITLE_ASSETS_PATH)]);
				case PARTY_SELECT_EVENT:
					return new PartySelectState(state,this._assets[GameConfig.getAssetIdFromUrl(GameConfig.GAME_WINDOW_ASSETS_PATH)]);
				case WORLD_MAP:
					return new MapState(state,this._assets[GameConfig.getAssetIdFromUrl(GameConfig.GAME_MAP_ASSETS_PATH)]);
				case COMBAT_EVENT:
					return new CombatState(state,this._assets[GameConfig.getAssetIdFromUrl(GameConfig.GAME_WINDOW_ASSETS_PATH)]);
				case REWARD_EVENT:
					return new RewardState(state,this._assets[GameConfig.getAssetIdFromUrl(GameConfig.GAME_WINDOW_ASSETS_PATH)]);
				case INTERACTION_EVENT:
					return new InteractionState(state,this._assets[GameConfig.getAssetIdFromUrl(GameConfig.GAME_WINDOW_ASSETS_PATH)]);
				case GAME_OVER:
					return new GameOverState(state,this._assets[GameConfig.getAssetIdFromUrl(GameConfig.GAME_GAME_OVER_ASSETS_PATH)]);
				default:
					Log.error("StateController: state " + state + " can\'t be created cause it doesn\'t exist");
					return new GameState(state,null);
			}
		}
		
		private function enterState(state:int, obj:Object = null) : void
		{
			Log.info("StateController: entering state " + state + ".");
			if(this._currentState != NOT_STARTED)
			{
				this.exitState(this._currentState);
				if(state == WORLD_MAP)
				{
					SaveManager.instance.save();
				}
			}
			this._states[state].enter(obj);
			this._currentState = state;
		}
		
		private function exitState(state:int) : void
		{
			this._states[state].exit();
		}
		
		private function onStateCreated(e:EventWithParams) : void
		{
			Log.info("StateController: state " + e.params.target.id + " is ready.");
			this._statesReadyNum++;
			if(this._statesReadyNum == NUMBER_OF_STATES + 2)
			{
				this.enterState(GameConfig.STARTING_STATE);
			}
		}
		
		private function onContinue(e:EventWithParams) : void
		{
			var target:GameState = e.params.target;
			switch(target.id)
			{
				case TITLE:
					this.enterState(e.params.destination);
					break;
				case PARTY_SELECT_EVENT:
					this.enterState(WORLD_MAP);
					break;
				case WORLD_MAP:
					this.enterState(e.params.destination,e.params.data);
					break;
				case COMBAT_EVENT:
					this.enterState(e.params.destination,e.params.data);
					break;
				case REWARD_EVENT:
					this.enterState(WORLD_MAP);
					break;
				case INTERACTION_EVENT:
					this.enterState(e.params.destination,e.params.data);
					break;
				case GAME_OVER:
					this.enterState(TITLE);
			}
		}
		
		private function onBack(e:EventWithParams) : void
		{
		}
		
		private function onTutorialRequested(e:EventWithParams) : void
		{
			dispatchEvent(e);
		}
		
		private function onResume(e:EventWithParams) : void
		{
			if(this._states != null && this._currentState != NOT_STARTED)
			{
				this._states[this._currentState].Pause(false);
				dispatchEvent(e);
			}
		}
		
		private function onQuitConfirmed(e:EventWithParams) : void
		{
			dispatchEvent(e);
		}
		
		private function onQuitCancelled(e:EventWithParams) : void
		{
			if(this._confirmQuitState != null)
			{
				this._confirmQuitState.exit();
			}
			dispatchEvent(e);
			if(this._pauseState != null)
			{
				this._pauseState.enter();
				this._pauseState.exit();
			}
		}
		
		public function dispose() : void
		{
			var gameState:GameState = null;
			for(var i:uint = 0; i < this._states.length; i++)
			{
				gameState = this._states[i];
				gameState.removeEventListener(GameState.STATE_CREATED,this.onStateCreated);
				gameState.removeEventListener(GameState.NAV_CONTINUE,this.onContinue);
				gameState.removeEventListener(GameState.NAV_BACK,this.onBack);
				gameState.removeEventListener(GameState.TUTORIAL_REQUESTED,this.onTutorialRequested);
				gameState.dispose();
			}
			this.BGSCodeObj = null;
		}
		
		public function Pause(paused:Boolean) : void
		{
			if(this._pauseState != null && (this._confirmQuitState == null || !this._confirmQuitState.isActive))
			{
				if(paused)
				{
					if(this._states != null && this._currentState != NOT_STARTED)
					{
						this._states[this._currentState].Pause(paused);
					}
					this._pauseState.enter();
				}
				else
				{
					this._pauseState.exit();
				}
			}
		}
		
		public function ConfirmQuit() : void
		{
			if(this._confirmQuitState != null)
			{
				if(this._states != null)
				{
					if(this._pauseState != null && this._pauseState.isActive)
					{
						this._pauseState.cancel();
					}
					else if(this._currentState != NOT_STARTED)
					{
						this._states[this._currentState].Pause(true);
					}
				}
				this._confirmQuitState.enter();
			}
		}
	}
}
