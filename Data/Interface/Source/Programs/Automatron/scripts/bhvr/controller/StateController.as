package bhvr.controller
{
	import flash.events.EventDispatcher;
	import flash.display.MovieClip;
	import bhvr.views.CustomCursor;
	import bhvr.states.GameState;
	import bhvr.states.PauseState;
	import bhvr.states.ConfirmQuitState;
	import bhvr.states.GameStateFactory;
	import bhvr.events.EventWithParams;
	import bhvr.debug.Log;
	import bhvr.data.GamePersistantData;
	import bhvr.constants.GameConfig;
	import bhvr.states.GameFlow;
	
	public class StateController extends EventDispatcher
	{
		
		public static const CONFIRM_QUIT:int = -3;
		
		public static const PAUSE:int = -2;
		
		public static const NOT_STARTED:int = -1;
		
		public static const INVALID_STATE:int = -1;
		 
		
		public var BGSCodeObj:Object;
		
		private var _assets:Vector.<MovieClip>;
		
		private var _cursor:CustomCursor;
		
		private var _states:Vector.<GameState>;
		
		private var _pauseState:PauseState;
		
		private var _confirmQuitState:ConfirmQuitState;
		
		private var _statesReadyNum:int;
		
		private var _currentState:int;
		
		private var _isTutorialShown:Boolean = false;
		
		public function StateController(param1:Vector.<MovieClip>, param2:CustomCursor)
		{
			super();
			this._assets = param1;
			this._cursor = param2;
			this._states = new Vector.<GameState>();
			this._currentState = NOT_STARTED;
		}
		
		public function initialize() : void
		{
			this._statesReadyNum = 0;
			var _loc1_:uint = 0;
			while(_loc1_ < GameStateFactory.NUMBER_OF_STATES)
			{
				this._states.push(GameStateFactory.createState(this._assets,_loc1_,this._cursor));
				this._states[_loc1_].BGSCodeObj = this.BGSCodeObj;
				this._states[_loc1_].addEventListener(GameState.STATE_CREATED,this.onStateCreated,false,0,true);
				this._states[_loc1_].addEventListener(GameState.NAV_CONTINUE,this.onContinue,false,0,true);
				this._states[_loc1_].addEventListener(GameState.NAV_BACK,this.onBack,false,0,true);
				this._states[_loc1_].addEventListener(GameState.TUTORIAL_REQUESTED,this.onTutorialRequested,false,0,true);
				this._states[_loc1_].initialize();
				_loc1_++;
			}
			this._pauseState = GameStateFactory.createState(this._assets,PAUSE,this._cursor) as PauseState;
			this._pauseState.addEventListener(GameState.STATE_CREATED,this.onStateCreated,false,0,true);
			this._pauseState.addEventListener(PauseState.READY_TO_RESUME,this.onResume,false,0,true);
			this._pauseState.initialize();
			this._confirmQuitState = GameStateFactory.createState(this._assets,CONFIRM_QUIT,this._cursor) as ConfirmQuitState;
			this._confirmQuitState.addEventListener(GameState.STATE_CREATED,this.onStateCreated,false,0,true);
			this._confirmQuitState.addEventListener(ConfirmQuitState.QUIT,this.onQuitConfirmed,false,0,true);
			this._confirmQuitState.addEventListener(ConfirmQuitState.CANCEL,this.onQuitCancelled,false,0,true);
			this._confirmQuitState.initialize();
		}
		
		private function enterState(param1:int, param2:Object = null) : void
		{
			if(this._currentState != NOT_STARTED)
			{
				this.exitState(this._currentState);
			}
			this._states[param1].enter(param2);
			this._currentState = param1;
		}
		
		private function exitState(param1:int) : void
		{
			this._states[param1].exit();
		}
		
		private function onStateCreated(param1:EventWithParams) : void
		{
			Log.info("StateController: state " + param1.params.target.id + " is ready.");
			this._statesReadyNum++;
			if(this._statesReadyNum == GameStateFactory.NUMBER_OF_STATES + 2)
			{
				GamePersistantData.reset();
				this.enterState(GameConfig.STARTING_STATE);
			}
		}
		
		private function onContinue(param1:EventWithParams) : void
		{
			var _loc2_:GameState = param1.params.target;
			var _loc3_:int = GameFlow.getNextState(_loc2_.id,param1.params);
			var _loc4_:Object = param1.params.data;
			if(_loc3_ < 0 || _loc3_ >= GameStateFactory.NUMBER_OF_STATES)
			{
				throw new Error("StateController: Flow error. Can\'t go to state " + _loc3_ + " because it doesn\'t exist!");
			}
			this.enterState(_loc3_,_loc4_);
		}
		
		private function onBack(param1:EventWithParams) : void
		{
		}
		
		private function onTutorialRequested(param1:EventWithParams) : void
		{
			dispatchEvent(param1);
		}
		
		private function onResume(param1:EventWithParams) : void
		{
			if(this._states != null && this._currentState != NOT_STARTED)
			{
				this._states[this._currentState].Pause(false);
				dispatchEvent(param1);
			}
		}
		
		private function onQuitConfirmed(param1:EventWithParams) : void
		{
			dispatchEvent(param1);
		}
		
		private function onQuitCancelled(param1:EventWithParams) : void
		{
			if(this._confirmQuitState != null)
			{
				this._confirmQuitState.exit();
			}
			dispatchEvent(param1);
			if(this._pauseState != null)
			{
				this._pauseState.enter();
				if(GameConfig.isStateUsingResumeCounter(this._currentState))
				{
					this._pauseState.startExit();
				}
				else
				{
					this._pauseState.exit();
				}
			}
		}
		
		public function dispose() : void
		{
			var _loc1_:GameState = null;
			if(this._currentState != NOT_STARTED)
			{
				this._states[this._currentState].exit();
			}
			var _loc2_:uint = 0;
			while(_loc2_ < this._states.length)
			{
				_loc1_ = this._states[_loc2_];
				_loc1_.removeEventListener(GameState.STATE_CREATED,this.onStateCreated);
				_loc1_.removeEventListener(GameState.NAV_CONTINUE,this.onContinue);
				_loc1_.removeEventListener(GameState.NAV_BACK,this.onBack);
				_loc1_.removeEventListener(GameState.TUTORIAL_REQUESTED,this.onTutorialRequested);
				_loc1_.dispose();
				_loc2_++;
			}
			if(this._pauseState != null)
			{
				this._pauseState.removeEventListener(GameState.STATE_CREATED,this.onStateCreated);
				this._pauseState.removeEventListener(PauseState.READY_TO_RESUME,this.onResume);
				this._pauseState.dispose();
			}
			if(this._confirmQuitState)
			{
				this._confirmQuitState.removeEventListener(GameState.STATE_CREATED,this.onStateCreated);
				this._confirmQuitState.removeEventListener(ConfirmQuitState.QUIT,this.onQuitConfirmed);
				this._confirmQuitState.removeEventListener(ConfirmQuitState.CANCEL,this.onQuitCancelled);
				this._confirmQuitState.dispose();
			}
			this.BGSCodeObj = null;
		}
		
		public function Pause(param1:Boolean) : void
		{
			if(this._pauseState != null && (this._confirmQuitState == null || !this._confirmQuitState.isActive))
			{
				if(param1)
				{
					if(this._states != null && this._currentState != NOT_STARTED)
					{
						this._states[this._currentState].Pause(param1);
					}
					this._pauseState.enter();
				}
				else if(GameConfig.isStateUsingResumeCounter(this._currentState) && !this._isTutorialShown)
				{
					this._pauseState.startExit();
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
