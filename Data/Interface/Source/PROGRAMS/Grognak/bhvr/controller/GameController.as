package bhvr.controller
{
	import flash.display.Stage;
	import flash.display.MovieClip;
	import scaleform.clik.controls.UILoader;
	import bhvr.utils.XMLLoader;
	import Holotapes.Common.views.PauseButton;
	import bhvr.manager.InputManager;
	import flash.geom.Point;
	import bhvr.data.database.GameDatabase;
	import bhvr.data.GamePersistantData;
	import bhvr.manager.SaveManager;
	import bhvr.manager.SoundManager;
	import bhvr.data.SoundList;
	import bhvr.constants.GameConfig;
	import Shared.AS3.COMPANIONAPP.CompanionAppMode;
	import bhvr.constants.GameInputs;
	import bhvr.states.PauseState;
	import bhvr.states.ConfirmQuitState;
	import bhvr.states.GameState;
	import flash.events.Event;
	import bhvr.debug.Log;
	import flash.events.IOErrorEvent;
	import bhvr.constants.GameConstants;
	import bhvr.events.EventWithParams;
	import aze.motion.EazeTween;
	import Shared.BGSExternalInterface;
	import scaleform.gfx.Extensions;
	import scaleform.clik.core.CLIK;
	
	public class GameController
	{
		 
		
		public var BGSCodeObj:Object;
		
		private var _platformInfo:Object;
		
		private var _stage:Stage;
		
		private var _xmls:Vector.<String>;
		
		private var _swfs:Vector.<String>;
		
		private var _assets:Vector.<MovieClip>;
		
		private var _assetLoaders:Vector.<UILoader>;
		
		private var _xmlLoaders:Vector.<XMLLoader>;
		
		private var _assetsLoadedNum:uint;
		
		private const INVALID_ASSETS_ID:int = -1;
		
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
			var pauseBtnMc:MovieClip = null;
			var pauseStagePosition:Point = null;
			GameDatabase.init();
			GamePersistantData.reset();
			SaveManager.instance.BGSCodeObj = this.BGSCodeObj;
			SaveManager.instance.init();
			SoundManager.instance.BGSCodeObj = this.BGSCodeObj;
			SoundManager.instance.registerSound(SoundList.MUSIC_TITLE_SCREEN);
			SoundManager.instance.registerSound(SoundList.MUSIC_WORLD_MAP_SCREEN);
			SoundManager.instance.registerSound(SoundList.MUSIC_MAP_SHIP_TRAVEL);
			SoundManager.instance.registerSound(SoundList.MUSIC_TEXT_PRINT);
			SoundManager.instance.registerSound(SoundList.SOUND_COMBAT_FLEE_SUCCESS);
			SoundManager.instance.registerSound(SoundList.SOUND_GAME_OVER);
			SoundManager.instance.registerSound(SoundList.SOUND_GAME_VICTORY);
			pauseBtnMc = this._assets[GameConfig.getAssetIdFromUrl(GameConfig.GAME_WINDOW_ASSETS_PATH)].pauseBtnMc;
			if(CompanionAppMode.isOn)
			{
				pauseStagePosition = pauseBtnMc.localToGlobal(new Point());
				this._pauseButton = new PauseButton(pauseBtnMc);
				this._pauseButton.addEventListener(PauseButton.CLICKED,this.onPauseBtnClicked,false,0,true);
				this._stage.addChild(pauseBtnMc);
				pauseBtnMc.x = pauseStagePosition.x;
				pauseBtnMc.y = pauseStagePosition.y;
			}
			else
			{
				pauseBtnMc.visible = false;
			}
			this._inputMgr = new InputManager(this._stage);
			this._inputMgr.addEventListener(GameInputs.PAUSE,this.onPause,false,0,true);
			if(this._platformInfo.platform != null)
			{
				this._inputMgr.SetPlatform(this._platformInfo.platform,this._platformInfo.psnButtonSwap);
			}
			this._stateController = new bhvr.controller.StateController(this._assets);
			this._stateController.addEventListener(PauseState.READY_TO_RESUME,this.onResume,false,0,true);
			this._stateController.addEventListener(ConfirmQuitState.CANCEL,this.onQuitCancelled,false,0,true);
			this._stateController.addEventListener(ConfirmQuitState.QUIT,this.onQuitConfirmed,false,0,true);
			this._stateController.addEventListener(GameState.TUTORIAL_REQUESTED,this.onTutorialRequested,false,0,true);
			this._stateController.BGSCodeObj = this.BGSCodeObj;
			this._stateController.initialize();
		}
		
		private function onDelayedAssetLoading(e:Event) : void
		{
			this._stage.removeEventListener(Event.ENTER_FRAME,this.onDelayedAssetLoading);
			this.loadGameAssets();
		}
		
		private function loadGameAssets() : void
		{
			var i:uint = 0;
			var asset:String = null;
			var filename:Array = null;
			var fileExtension:String = null;
			this._xmls = new Vector.<String>();
			this._swfs = new Vector.<String>();
			this._assetsLoadedNum = 0;
			for(i = 0; i < GameConfig.GAME_ASSETS_PATH.length; i++)
			{
				asset = GameConfig.GAME_ASSETS_PATH[i];
				filename = asset.split(".");
				fileExtension = filename[filename.length - 1];
				if(fileExtension == "xml")
				{
					this._xmls.push(asset);
				}
				else if(fileExtension == "swf")
				{
					this._swfs.push(asset);
				}
				else
				{
					Log.error("File type: " + fileExtension + " is not supported.");
				}
			}
			if(this._swfs.length > 0)
			{
				this.loadSwfs();
			}
			if(this._xmls.length > 0)
			{
				this.loadXmls();
			}
		}
		
		private function loadSwfs() : void
		{
			this._assets = new Vector.<MovieClip>(this._swfs.length - 1);
			this._assetLoaders = new Vector.<UILoader>(this._swfs.length - 1);
			for(var i:uint = 0; i < this._swfs.length; i++)
			{
				this._assetLoaders[i] = new UILoader();
				this._assetLoaders[i].addEventListener(Event.COMPLETE,this.onAssetsLoaded,false,0,true);
				this._assetLoaders[i].addEventListener(IOErrorEvent.IO_ERROR,this.onLoadingError,false,0,true);
				this._assetLoaders[i].source = this._swfs[i];
			}
		}
		
		private function loadXmls() : void
		{
			this._xmlLoaders = new Vector.<XMLLoader>(this._xmls.length - 1);
			for(var i:uint = 0; i < this._xmls.length; i++)
			{
				this._xmlLoaders[i] = new XMLLoader();
				this._xmlLoaders[i].addEventListener(XMLLoader.XML_LOADED,this.onXmlLoaded,false,0,true);
				this._xmlLoaders[i].load(this._xmls[i]);
			}
		}
		
		private function onAssetsLoaded(e:Event) : void
		{
			this._assetsLoadedNum++;
			var visualContent:MovieClip = e.target.content as MovieClip;
			var assetsId:uint = GameConfig.getAssetIdFromUrl(e.target.source);
			if(assetsId != this.INVALID_ASSETS_ID)
			{
				this._assets[assetsId] = visualContent.getChildByName("mainMc") as MovieClip;
			}
			else
			{
				Log.error("Assets loaded \'" + e.target.source + "\' is not expected!");
			}
			this._stage.addChild(visualContent);
			this.checkEndOfLoading();
		}
		
		private function onXmlLoaded(e:Event) : void
		{
			var variableName:String = null;
			this._assetsLoadedNum++;
			var xml:XML = e.target.xml as XML;
			var variables:XMLList = xml.children();
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
			e.target.dispose();
			this.checkEndOfLoading();
		}
		
		private function checkEndOfLoading() : void
		{
			if(this._assetsLoadedNum == GameConfig.GAME_ASSETS_PATH.length)
			{
				this._xmls = null;
				this._swfs = null;
				this._xmlLoaders = null;
				this._assetLoaders = null;
				this.initialize();
			}
		}
		
		private function onLoadingError(e:IOErrorEvent) : void
		{
			Log.error("Can\'t load Game assets because " + e.target.source + " doesn\'t exist!");
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
			EazeTween.resumeAllTweens();
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
			this._assetLoaders = null;
			this._stateController.dispose();
			this._stateController = null;
			this._inputMgr.dispose();
			this._inputMgr = null;
			SaveManager.instance.dispose();
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
					EazeTween.pauseAllTweens();
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
				EazeTween.pauseAllTweens();
				this._isConfirmingQuit = true;
			}
		}
	}
}
