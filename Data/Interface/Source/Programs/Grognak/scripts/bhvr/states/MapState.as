package bhvr.states
{
	import bhvr.controller.MapController;
	import bhvr.views.UIMap;
	import bhvr.module.map.MapActions;
	import aze.motion.eaze;
	import bhvr.data.database.GameDatabase;
	import bhvr.events.MapEvents;
	import Shared.AS3.COMPANIONAPP.CompanionAppMode;
	import bhvr.data.GamePersistantData;
	import bhvr.module.combat.HeroStats;
	import bhvr.events.EventWithParams;
	import bhvr.manager.SoundManager;
	import bhvr.data.SoundList;
	import bhvr.constants.GameConstants;
	import bhvr.manager.InputManager;
	import bhvr.constants.GameInputs;
	import bhvr.controller.StateController;
	import flash.display.MovieClip;
	
	public class MapState extends GameState
	{
		 
		
		private var _map:MapController;
		
		private var _uiMap:UIMap;
		
		protected const TUTORIAL_OVERLAY_ID:String = "GrognakMap";
		
		public function MapState(id:int, assets:MovieClip)
		{
			super(id,assets);
		}
		
		private function init(actionRequested:uint) : void
		{
			this._map.init(actionRequested);
		}
		
		override public function enter(obj:Object = null) : void
		{
			super.enter();
			var actionRequested:uint = obj != null && obj.actionRequested != null?uint(obj.actionRequested):uint(MapActions.NONE);
			eaze(_assets).play("introStart>introEnd").onComplete(this.init,actionRequested);
			this._uiMap = new UIMap(_assets.mapMc);
			this._map = new MapController(_assets.mapMc.mapHolderMc,GameDatabase.mapTiles,GameDatabase.mapHero,GameDatabase.mapObjects);
			this._map.addEventListener(MapEvents.TRIGGER_COMBAT_EVENT,this.onTriggerCombatEvent,false,0,true);
			this._map.addEventListener(MapEvents.TRIGGER_INTERACTION_EVENT,this.onTriggerInteractionEvent,false,0,true);
			this._map.addEventListener(MapEvents.TRIGGER_BLOCKER_EVENT,this.onTriggerBlockerEvent,false,0,true);
			this._map.addEventListener(MapEvents.LOCATION_UPDATE,this.onMapLocationUpdate,false,0,true);
			this._map.fill(actionRequested);
			this.regenerateHeroesHP();
			if(CompanionAppMode.isOn && GamePersistantData.shouldShowMapTutorial)
			{
				GamePersistantData.shouldShowMapTutorial = false;
				requestTutorialOverlay(this.TUTORIAL_OVERLAY_ID);
			}
		}
		
		private function regenerateHeroesHP() : void
		{
			var partyMembers:Vector.<HeroStats> = GamePersistantData.getPartyMembers();
			for(var i:uint = 0; i < partyMembers.length; i++)
			{
				if(!partyMembers[i].isDead)
				{
					partyMembers[i].fullHeal();
				}
			}
		}
		
		private function onMapLocationUpdate(e:EventWithParams) : void
		{
			var locationName:String = e.params.locationName;
			this._uiMap.setLocationName(locationName);
		}
		
		private function onTriggerBlockerEvent(e:EventWithParams) : void
		{
			this._map.pause();
			this._uiMap.setPopupData(e.params.explanation);
			this._uiMap.setPopupVisibility(true);
			SoundManager.instance.playSound(SoundList.SOUND_MAP_BLOCKER);
			eaze(this._uiMap).delay(GameConstants.mapPopupManualCancelDelay).onComplete(this.allowUserToClosePopup);
		}
		
		private function allowUserToClosePopup() : void
		{
			InputManager.instance.addEventListener(GameInputs.MOVE_UP,this.closePopup,false,0,true);
			InputManager.instance.addEventListener(GameInputs.MOVE_DOWN,this.closePopup,false,0,true);
			InputManager.instance.addEventListener(GameInputs.MOVE_RIGHT,this.closePopup,false,0,true);
			InputManager.instance.addEventListener(GameInputs.MOVE_LEFT,this.closePopup,false,0,true);
			InputManager.instance.addEventListener(GameInputs.ACCEPT,this.closePopup,false,0,true);
			var autoCloseDelay:Number = GameConstants.mapPopupAutoCancelDelay - GameConstants.mapPopupManualCancelDelay;
			if(autoCloseDelay > 0)
			{
				eaze(this._uiMap).delay(autoCloseDelay).onComplete(this.closePopup);
			}
		}
		
		private function closePopup() : void
		{
			eaze(this._uiMap).killTweens();
			InputManager.instance.removeEventListener(GameInputs.MOVE_UP,this.closePopup);
			InputManager.instance.removeEventListener(GameInputs.MOVE_DOWN,this.closePopup);
			InputManager.instance.removeEventListener(GameInputs.MOVE_RIGHT,this.closePopup);
			InputManager.instance.removeEventListener(GameInputs.MOVE_LEFT,this.closePopup);
			InputManager.instance.removeEventListener(GameInputs.ACCEPT,this.closePopup);
			this._uiMap.setPopupVisibility(false);
			this._map.resume();
		}
		
		private function onTriggerCombatEvent(e:EventWithParams) : void
		{
			eaze(_assets).play("enemyInteractionStart>enemyInteractionEnd").onComplete(this.onCombatAnimationFinished,e.params);
		}
		
		private function onTriggerInteractionEvent(e:EventWithParams) : void
		{
			dispatchEvent(new EventWithParams(GameState.NAV_CONTINUE,{
				"target":this,
				"destination":StateController.INTERACTION_EVENT,
				"data":e.params
			}));
		}
		
		private function onCombatAnimationFinished(data:Object = null) : void
		{
			dispatchEvent(new EventWithParams(GameState.NAV_CONTINUE,{
				"target":this,
				"destination":StateController.COMBAT_EVENT,
				"data":data
			}));
		}
		
		override public function exit() : void
		{
			SoundManager.instance.stopSound(SoundList.MUSIC_WORLD_MAP_SCREEN);
			if(this._map)
			{
				this._map.removeEventListener(MapEvents.TRIGGER_COMBAT_EVENT,this.onTriggerCombatEvent);
				this._map.removeEventListener(MapEvents.TRIGGER_INTERACTION_EVENT,this.onTriggerInteractionEvent);
				this._map.removeEventListener(MapEvents.TRIGGER_BLOCKER_EVENT,this.onTriggerBlockerEvent);
				this._map.removeEventListener(MapEvents.LOCATION_UPDATE,this.onMapLocationUpdate);
				this._map.dispose();
				this._map = null;
			}
			if(this._uiMap)
			{
				this._uiMap.dispose();
				this._uiMap = null;
			}
			super.exit();
		}
		
		override public function Pause(paused:Boolean) : void
		{
			super.Pause(paused);
			if(paused)
			{
				this._map.pause();
			}
			else if(!this._uiMap.getPopupVisibility())
			{
				this._map.resume();
			}
		}
	}
}
