package bhvr.states
{
	import flash.display.InteractiveObject;
	import bhvr.manager.SoundManager;
	import bhvr.data.SoundList;
	import aze.motion.eaze;
	import bhvr.manager.InputManager;
	import bhvr.constants.GameInputs;
	import bhvr.manager.SaveManager;
	import Shared.AS3.COMPANIONAPP.CompanionAppMode;
	import scaleform.clik.managers.FocusHandler;
	import scaleform.clik.events.ButtonEvent;
	import bhvr.events.EventWithParams;
	import bhvr.controller.StateController;
	import flash.events.Event;
	import bhvr.data.GamePersistantData;
	import bhvr.data.database.Hero;
	import bhvr.constants.GameConfig;
	import bhvr.debug.Log;
	import bhvr.data.database.GameDatabase;
	import bhvr.constants.GameConstants;
	import flash.display.MovieClip;
	import bhvr.data.LocalizationStrings;
	
	public class TitleState extends GameState
	{
		 
		
		private var _focusedObjAtPause:InteractiveObject = null;
		
		public function TitleState(id:int, assets:MovieClip)
		{
			super(id,assets);
			_assets.titleMc.promptMc.promptAnimMc.promptTxt.text = LocalizationStrings.START_PROMPT;
			_assets.continuePopupMc.btn0.label = LocalizationStrings.NEW_GAME;
			_assets.continuePopupMc.btn1.label = LocalizationStrings.CONTINUE_GAME;
		}
		
		override public function enter(obj:Object = null) : void
		{
			super.enter();
			_assets.titleMc.promptMc.visible = false;
			_assets.continuePopupMc.visible = false;
			SoundManager.instance.startSound(SoundList.MUSIC_TITLE_SCREEN);
			eaze(_assets).play("introStart>introEnd").onComplete(this.init);
		}
		
		private function init() : void
		{
			_assets.titleMc.promptMc.visible = true;
			InputManager.instance.addEventListener(GameInputs.ACCEPT,this.onStart,false,0,true);
		}
		
		override public function exit() : void
		{
			super.exit();
			SoundManager.instance.stopSound(SoundList.MUSIC_TITLE_SCREEN);
		}
		
		protected function onStart() : void
		{
			InputManager.instance.removeEventListener(GameInputs.ACCEPT,this.onStart);
			SoundManager.instance.playSound(SoundList.SOUND_TITLE_START);
			if(SaveManager.instance.hasSave())
			{
				_assets.continuePopupMc.visible = true;
				_assets.titleMc.promptMc.visible = false;
				if(!CompanionAppMode.isOn)
				{
					FocusHandler.instance.setFocus(_assets.continuePopupMc.btn1);
					_assets.continuePopupMc.btn1.addEventListener(ButtonEvent.CLICK,this.skipHack,false,0,true);
				}
				else
				{
					_assets.continuePopupMc.btn0.addEventListener(ButtonEvent.CLICK,this.onNewGame,false,0,true);
					_assets.continuePopupMc.btn1.addEventListener(ButtonEvent.CLICK,this.onContinueGame,false,0,true);
				}
			}
			else
			{
				dispatchEvent(new EventWithParams(GameState.NAV_CONTINUE,{
					"target":this,
					"destination":(!!this.forcePartyMembers()?StateController.WORLD_MAP:StateController.PARTY_SELECT_EVENT)
				}));
			}
		}
		
		protected function skipHack(e:Event) : void
		{
			_assets.continuePopupMc.btn1.removeEventListener(ButtonEvent.CLICK,this.skipHack);
			_assets.continuePopupMc.btn0.addEventListener(ButtonEvent.CLICK,this.onNewGame,false,0,true);
			_assets.continuePopupMc.btn1.addEventListener(ButtonEvent.CLICK,this.onContinueGame,false,0,true);
		}
		
		protected function onContinueGame(e:Event) : void
		{
			_assets.continuePopupMc.btn0.removeEventListener(ButtonEvent.CLICK,this.onNewGame);
			_assets.continuePopupMc.btn1.removeEventListener(ButtonEvent.CLICK,this.onContinueGame);
			SaveManager.instance.restoreSave();
			dispatchEvent(new EventWithParams(GameState.NAV_CONTINUE,{
				"target":this,
				"destination":(GamePersistantData.isPartySelectionCompleted || this.forcePartyMembers()?StateController.WORLD_MAP:StateController.PARTY_SELECT_EVENT)
			}));
		}
		
		protected function onNewGame(e:Event) : void
		{
			_assets.continuePopupMc.btn0.removeEventListener(ButtonEvent.CLICK,this.onNewGame);
			_assets.continuePopupMc.btn1.removeEventListener(ButtonEvent.CLICK,this.onContinueGame);
			SaveManager.instance.clearSave();
			dispatchEvent(new EventWithParams(GameState.NAV_CONTINUE,{
				"target":this,
				"destination":(!!this.forcePartyMembers()?StateController.WORLD_MAP:StateController.PARTY_SELECT_EVENT)
			}));
		}
		
		private function forcePartyMembers() : Boolean
		{
			var hero:Hero = null;
			if(GameConfig.FORCE_PARTY_MEMBERS == null)
			{
				return false;
			}
			Log.info("Forcing party members...");
			var i:int = 0;
			while(i < GameConfig.FORCE_PARTY_MEMBERS.length && i < GameConstants.MAX_PARTY_MEMBERS)
			{
				hero = GameDatabase.heroes[GameConfig.FORCE_PARTY_MEMBERS[i]];
				Log.info("Forcing party member : " + hero.mainName);
				GamePersistantData.addPartyMember(hero);
				i++;
			}
			return true;
		}
		
		override public function Pause(paused:Boolean) : void
		{
			super.Pause(paused);
			if(paused)
			{
				_assets.titleMc.promptMc.stop();
				this._focusedObjAtPause = FocusHandler.instance.getFocus(0);
				_assets.continuePopupMc.btn0.enabled = false;
				_assets.continuePopupMc.btn1.enabled = false;
			}
			else
			{
				_assets.titleMc.promptMc.play();
				_assets.continuePopupMc.btn0.enabled = true;
				_assets.continuePopupMc.btn1.enabled = true;
				FocusHandler.instance.setFocus(this._focusedObjAtPause);
			}
		}
	}
}
