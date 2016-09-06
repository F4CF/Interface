package bhvr.controller
{
	import flash.display.Stage;
	import bhvr.loader.AssetsLoader;
	import flash.display.MovieClip;
	import Holotapes.Common.views.PauseButton;
	import bhvr.manager.InputManager;
	import bhvr.views.CustomCursor;
	import bhvr.external.BGSExternalAnimation;
	import flash.geom.Point;
	import bhvr.constants.GameConfig;
	import Shared.AS3.COMPANIONAPP.CompanionAppMode;
	import bhvr.data.CursorType;
	import bhvr.constants.GameInputs;
	import bhvr.states.PauseState;
	import bhvr.states.ConfirmQuitState;
	import bhvr.states.GameState;
	import bhvr.manager.SoundManager;
	import bhvr.data.SoundList;
	import flash.events.Event;
	import bhvr.events.EventWithParams;
	import Shared.BGSExternalInterface;
	import scaleform.gfx.Extensions;
	import scaleform.clik.core.CLIK;
	
	public class GameController
	{
		 
		
		public var BGSCodeObj:Object;
		
		private var _platformInfo:Object;
		
		private var _stage:Stage;
		
		private var _assetsLoader:AssetsLoader;
		
		private var _assets:Vector.<MovieClip>;
		
		private var _pauseButton:PauseButton;
		
		private var _inputMgr:InputManager;
		
		private var _cursor:CustomCursor;
		
		private var _stateController:bhvr.controller.StateController;
		
		private var _externalAnimation:BGSExternalAnimation;
		
		private var _isPaused:Boolean = false;
		
		private var _isConfirmingQuit:Boolean = false;
		
		private var _isTutorialShown:Boolean = false;
		
		public function GameController(param1:Stage)
		{
			super();
			this._platformInfo = new Object();
			this._stage = param1;
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
		
		protected function initialize() : void
		{
			var _loc2_:MovieClip = null;
			var _loc3_:Point = null;
			if(GameConfig.USING_CURSOR && !CompanionAppMode.isOn)
			{
				_loc2_ = this._assets[GameConfig.getAssetIdFromUrl(GameConfig.CURSOR_SWF_CONTAINER)];
				this._cursor = new CustomCursor(this._stage,_loc2_,CursorType.CURSOR_BRACKETS);
				this._stage.addChild(this._cursor);
			}
			this._inputMgr = new InputManager(this._stage);
			this._inputMgr.addEventListener(GameInputs.PAUSE,this.onPause,false,0,true);
			if(this._platformInfo.platform != null)
			{
				this._inputMgr.SetPlatform(this._platformInfo.platform,this._platformInfo.psnButtonSwap);
			}
			var _loc1_:MovieClip = this._assets[GameConfig.getAssetIdFromUrl(GameConfig.PAUSE_BUTTON_SWF_CONTAINER)][GameConfig.PAUSE_BUTTON_MC_NAME];
			if(CompanionAppMode.isOn)
			{
				_loc3_ = _loc1_.localToGlobal(new Point());
				this._pauseButton = new PauseButton(_loc1_);
				this._pauseButton.addEventListener(PauseButton.CLICKED,this.onPauseBtnClicked,false,0,true);
				this._stage.addChild(_loc1_);
				_loc1_.x = _loc3_.x;
				_loc1_.y = _loc3_.y;
			}
			else
			{
				_loc1_.visible = false;
			}
			this._stateController = new bhvr.controller.StateController(this._assets,this._cursor);
			this._stateController.addEventListener(PauseState.READY_TO_RESUME,this.onResume,false,0,true);
			this._stateController.addEventListener(ConfirmQuitState.CANCEL,this.onQuitCancelled,false,0,true);
			this._stateController.addEventListener(ConfirmQuitState.QUIT,this.onQuitConfirmed,false,0,true);
			this._stateController.addEventListener(GameState.TUTORIAL_REQUESTED,this.onTutorialRequested,false,0,true);
			this._stateController.BGSCodeObj = this.BGSCodeObj;
			this._stateController.initialize();
			SoundManager.instance.BGSCodeObj = this.BGSCodeObj;
			SoundManager.instance.registerSounds(SoundList.soundsToRegister);
			if(!CompanionAppMode.isOn && this.BGSCodeObj && this.BGSCodeObj.playActionAnim)
			{
				this._externalAnimation = new BGSExternalAnimation(this.BGSCodeObj);
			}
		}
		
		private function onDelayedAssetLoading(param1:Event) : void
		{
			this._stage.removeEventListener(Event.ENTER_FRAME,this.onDelayedAssetLoading);
			this.loadGameAssets();
		}
		
		private function loadGameAssets() : void
		{
			this._assets = new Vector.<MovieClip>(GameConfig.GAME_ASSETS_PATH.length);
			this._assetsLoader = new AssetsLoader();
			this._assetsLoader.addEventListener(AssetsLoader.SWF_LOADED,this.onSwfLoaded,false,0,true);
			this._assetsLoader.addEventListener(AssetsLoader.ALL_ASSETS_LOADED,this.onAllAssetsLoaded,false,0,true);
			this._assetsLoader.load(GameConfig.GAME_ASSETS_PATH);
		}
		
		private function onSwfLoaded(param1:EventWithParams) : void
		{
			var _loc2_:MovieClip = param1.params.content as MovieClip;
			var _loc3_:uint = param1.params.assetId as uint;
			var _loc4_:MovieClip = param1.params.asset as MovieClip;
			this._assets[_loc3_] = _loc4_;
			this._stage.addChild(_loc2_);
		}
		
		private function onAllAssetsLoaded(param1:EventWithParams) : void
		{
			this._assetsLoader.removeEventListener(AssetsLoader.SWF_LOADED,this.onSwfLoaded);
			this._assetsLoader.removeEventListener(AssetsLoader.ALL_ASSETS_LOADED,this.onAllAssetsLoaded);
			this._assetsLoader.dispose();
			this._assetsLoader = null;
			this.initialize();
		}
		
		private function onPauseBtnClicked(param1:Event) : void
		{
			this.ConfirmQuit();
		}
		
		private function onPause(param1:EventWithParams) : void
		{
			this.Pause(!this._isPaused);
		}
		
		private function onResume(param1:EventWithParams) : void
		{
			this._inputMgr.Pause(false);
			SoundManager.instance.Pause(false);
		}
		
		private function onQuitCancelled(param1:EventWithParams) : void
		{
			this._isConfirmingQuit = false;
		}
		
		private function onQuitConfirmed(param1:EventWithParams) : void
		{
			BGSExternalInterface.call(this.BGSCodeObj,"closeHolotape");
		}
		
		private function onTutorialRequested(param1:EventWithParams) : void
		{
			BGSExternalInterface.call(null,"showTutorialOverlay",param1.params.id);
		}
		
		public function dispose() : void
		{
			this._platformInfo = null;
			if(!CompanionAppMode.isOn && this.BGSCodeObj && this.BGSCodeObj.playActionAnim)
			{
				this._externalAnimation.dispose();
				this._externalAnimation = null;
			}
			this._stateController.dispose();
			this._stateController = null;
			if(GameConfig.USING_CURSOR)
			{
				this._stage.removeChild(this._cursor);
				this._cursor.dispose();
				this._cursor = null;
			}
			this._inputMgr.dispose();
			this._inputMgr = null;
			SoundManager.instance.dispose();
			this.BGSCodeObj = null;
		}
		
		public function SetPlatform(param1:uint, param2:Boolean) : void
		{
			this._platformInfo.platform = param1;
			this._platformInfo.psnButtonSwap = param2;
			if(this._inputMgr)
			{
				this._inputMgr.SetPlatform(param1,param2);
			}
		}
		
		public function Pause(param1:Boolean) : void
		{
			if(!this._isTutorialShown && !this._isConfirmingQuit && this._isPaused != param1)
			{
				this._stateController.Pause(param1);
				if(param1)
				{
					this._inputMgr.Pause(param1);
					SoundManager.instance.Pause(param1);
				}
				this._isPaused = param1;
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
