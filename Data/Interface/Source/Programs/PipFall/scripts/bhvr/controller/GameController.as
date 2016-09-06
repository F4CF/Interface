package bhvr.controller
{
	import flash.display.Stage;
	import flash.display.MovieClip;
	import scaleform.clik.controls.UILoader;
	import Holotapes.Common.views.PauseButton;
	import bhvr.manager.InputManager;
	import bhvr.constants.GameInputs;
	import Shared.AS3.COMPANIONAPP.CompanionAppMode;
	import bhvr.states.PauseState;
	import bhvr.states.ConfirmQuitState;
	import bhvr.states.GameState;
	import bhvr.manager.SoundManager;
	import bhvr.data.SoundList;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import bhvr.constants.GameConfig;
	import bhvr.debug.Log;
	import bhvr.events.EventWithParams;
	import Shared.BGSExternalInterface;
	import scaleform.gfx.Extensions;
	import scaleform.clik.core.CLIK;
	
	public class GameController
	{
		 
		
		public var BGSCodeObj:Object;
		
		private var _platformInfo:Object;
		
		private var _stage:Stage;
		
		private var _visualContent:MovieClip;
		
		private var _assets:MovieClip;
		
		private var _assetLoader:UILoader;
		
		private var _pauseButton:PauseButton;
		
		private var _inputMgr:InputManager;
		
		private var _stateController:bhvr.controller.StateController;
		
		private var _isPaused:Boolean = false;
		
		private var _isConfirmingQuit:Boolean = false;
		
		private var _isTutorialShown:Boolean = false;
		
		public function GameController(mainStage:Stage)
		{
			super();
			this._platformInfo = new Object();
			this._stage = mainStage;
			Extensions.enabled = true;
			Extensions.noInvisibleAdvance = true;
			CLIK.disableNullFocusMoves = true;
			CLIK.disableDynamicTextFieldFocus = true;
			if(CompanionAppMode.isOn)
			{
				this.loadGameAssets();
			}
			else
			{
				this._stage.addEventListener(Event.ENTER_FRAME,this.onDelayedAssetLoading);
			}
		}
		
		public function get inputMgr() : InputManager
		{
			return this._inputMgr;
		}
		
		public function get stateController() : bhvr.controller.StateController
		{
			return this._stateController;
		}
		
		private function initialize() : void
		{
			this._inputMgr = new InputManager(this._stage);
			this._inputMgr.addEventListener(GameInputs.PAUSE,this.onPause,false,0,true);
			if(this._platformInfo.platform != null)
			{
				this._inputMgr.SetPlatform(this._platformInfo.platform,this._platformInfo.psnButtonSwap);
			}
			if(CompanionAppMode.isOn)
			{
				this._pauseButton = new PauseButton(this._assets.pauseBtnMc);
				this._pauseButton.addEventListener(PauseButton.CLICKED,this.onPauseBtnClicked,false,0,true);
			}
			else
			{
				this._assets.pauseBtnMc.visible = false;
			}
			this._stateController = new bhvr.controller.StateController(this._assets);
			this._stateController.addEventListener(PauseState.READY_TO_RESUME,this.onResume,false,0,true);
			this._stateController.addEventListener(ConfirmQuitState.CANCEL,this.onQuitCancelled,false,0,true);
			this._stateController.addEventListener(ConfirmQuitState.QUIT,this.onQuitConfirmed,false,0,true);
			this._stateController.addEventListener(GameState.TUTORIAL_REQUESTED,this.onTutorialRequested,false,0,true);
			this._stateController.BGSCodeObj = this.BGSCodeObj;
			this._stateController.initialize();
			SoundManager.instance.BGSCodeObj = this.BGSCodeObj;
			SoundManager.instance.registerSound(SoundList.INTRO_MUSIC_LOOP_SOUND);
			SoundManager.instance.registerSound(SoundList.RADIOACTIVE_POOL_LOOP_SOUND);
			SoundManager.instance.registerSound(SoundList.TALLY_POINTS_LOOP_SOUND);
			SoundManager.instance.registerSound(SoundList.TALLY_TIME_LOOP_SOUND);
			SoundManager.instance.registerSound(SoundList.PLAYER_DEATH_SOUND);
			SoundManager.instance.registerSound(SoundList.PLAYER_TIME_OVER_SOUND);
			SoundManager.instance.registerSound(SoundList.TRANSITION_SOUND);
			SoundManager.instance.registerSound(SoundList.MONSTER_ENTRANCE_SOUND);
			SoundManager.instance.registerSound(SoundList.PLAYER_COLLECT_LAST_BOBBLEHEAD_SOUND);
		}
		
		private function onDelayedAssetLoading(e:Event) : void
		{
			this._stage.removeEventListener(Event.ENTER_FRAME,this.onDelayedAssetLoading);
			this.loadGameAssets();
		}
		
		private function loadGameAssets() : void
		{
			this._assetLoader = new UILoader();
			this._assetLoader.addEventListener(Event.COMPLETE,this.onAssetsLoaded,false,0,true);
			this._assetLoader.addEventListener(IOErrorEvent.IO_ERROR,this.onLoadingError,false,0,true);
			this._assetLoader.source = GameConfig.GAME_ASSETS_PATH;
		}
		
		private function onAssetsLoaded(e:Event) : void
		{
			this._visualContent = this._assetLoader.content as MovieClip;
			this._assets = this._visualContent.getChildByName("mainMc") as MovieClip;
			this._stage.addChild(this._visualContent);
			this.initialize();
		}
		
		private function onLoadingError(e:IOErrorEvent) : void
		{
			Log.error("Can\'t load Game assets because " + this._assetLoader.source + " doesn\'t exist!");
		}
		
		private function onPauseBtnClicked(e:Event) : void
		{
			this.ConfirmQuit();
		}
		
		private function onPause(e:EventWithParams) : void
		{
			this.Pause(!this._isPaused);
		}
		
		private function onResume(e:EventWithParams) : void
		{
			this._inputMgr.Pause(false);
			SoundManager.instance.Pause(false);
		}
		
		private function onQuitCancelled(e:EventWithParams) : void
		{
			this._isConfirmingQuit = false;
		}
		
		private function onQuitConfirmed(e:EventWithParams) : void
		{
			BGSExternalInterface.call(this.BGSCodeObj,"closeHolotape");
		}
		
		private function onTutorialRequested(e:EventWithParams) : void
		{
			BGSExternalInterface.call(null,"showTutorialOverlay",e.params.id);
		}
		
		public function dispose() : void
		{
			this._platformInfo = null;
			this._visualContent = null;
			this._assetLoader = null;
			this._stateController.dispose();
			this._stateController = null;
			this._inputMgr.dispose();
			this._inputMgr = null;
			SoundManager.instance.dispose();
			this.BGSCodeObj = null;
		}
		
		public function SetPlatform(auiPlatform:uint, abPSNButtonSwap:Boolean) : void
		{
			this._platformInfo.platform = auiPlatform;
			this._platformInfo.psnButtonSwap = abPSNButtonSwap;
			if(this._inputMgr)
			{
				this._inputMgr.SetPlatform(auiPlatform,abPSNButtonSwap);
			}
		}
		
		public function Pause(paused:Boolean) : void
		{
			if(!this._isTutorialShown && !this._isConfirmingQuit && this._isPaused != paused)
			{
				this._stateController.Pause(paused);
				if(paused)
				{
					this._inputMgr.Pause(paused);
					SoundManager.instance.Pause(paused);
				}
				this._isPaused = paused;
			}
		}
		
		public function ConfirmQuit() : void
		{
			if(!this._isTutorialShown && !this._isConfirmingQuit)
			{
				this._stateController.ConfirmQuit();
				this._inputMgr.Pause(true);
				SoundManager.instance.Pause(true);
				this._isConfirmingQuit = true;
			}
		}
	}
}
