package bhvr.states
{
	import bhvr.views.UIWindowEvent;
	import flash.utils.Dictionary;
	import bhvr.controller.BaseEventController;
	import bhvr.module.combat.HeroStats;
	import bhvr.data.GamePersistantData;
	import bhvr.events.EventWithParams;
	import bhvr.module.event.EventControllerListenerInfo;
	import bhvr.module.event.operations.SimpleOperation;
	import bhvr.module.event.operations.SentenceOperation;
	import bhvr.module.event.operations.ActionEnablingOperation;
	import bhvr.module.event.operations.EventContinuationOperation;
	import bhvr.manager.SoundManager;
	import bhvr.controller.StateController;
	import aze.motion.eaze;
	import flash.display.MovieClip;
	
	public class BaseEventState extends GameState
	{
		 
		
		protected var _uiWindow:UIWindowEvent;
		
		private var _eventControllerListenerInfos:Dictionary;
		
		private var _pendingOperationsQueue:Vector.<Object>;
		
		private var _disableActionsOnCallback:Boolean;
		
		private var _currentActionsCallback:Function;
		
		public function BaseEventState(id:int, assets:MovieClip)
		{
			this._eventControllerListenerInfos = new Dictionary();
			this._pendingOperationsQueue = new Vector.<Object>();
			super(id,assets);
		}
		
		public function get eventController() : BaseEventController
		{
			return null;
		}
		
		override public function enter(obj:Object = null) : void
		{
			super.enter();
			_assets.gotoAndPlay("init");
			this._uiWindow = new UIWindowEvent(_assets);
			this._uiWindow.setLocationName("");
			this._uiWindow.setPortrait("");
			this._uiWindow.setPortraitNormalState();
			this._uiWindow.setPortraitName("");
			this._uiWindow.clearDialogBox();
			this.updatePartyStats();
			this.updateGold();
		}
		
		protected function updatePartyStats() : void
		{
			var partyMember:HeroStats = null;
			var partyMembers:Vector.<HeroStats> = GamePersistantData.getPartyMembers();
			for(var i:uint = 0; i < partyMembers.length; i++)
			{
				partyMember = partyMembers[i];
				this._uiWindow.setPartyMemberStats(i,partyMember.hero.mainName,partyMember.currentHP,partyMember.currentMaxHP,partyMember.currentFocus,partyMember.currentMaxFocus);
			}
		}
		
		protected function updateGold() : void
		{
			this._uiWindow.setGoldValue(GamePersistantData.gold);
		}
		
		protected function enableAction(actionsStr:String, callback:Function, disableActionsOnCallback:Boolean = true) : void
		{
			this.enableActions(new <String>[actionsStr],callback,disableActionsOnCallback);
		}
		
		protected function enableActions(actionsStrs:Vector.<String>, callback:Function, disableActionsOnCallback:Boolean = true) : void
		{
			if(this._currentActionsCallback == null)
			{
				this._uiWindow.addEventListener(UIWindowEvent.ACTION_SELECTED_EVENT,this.onActionSelected);
			}
			this._disableActionsOnCallback = disableActionsOnCallback;
			this._currentActionsCallback = callback;
			this._uiWindow.setActions(actionsStrs);
			this._uiWindow.enableActions();
		}
		
		private function onActionSelected(e:EventWithParams) : void
		{
			var callback:Function = this._currentActionsCallback;
			if(this._disableActionsOnCallback)
			{
				this.disableActions();
			}
			if(callback != null)
			{
				callback.call(this,e);
			}
		}
		
		protected function disableActions() : void
		{
			this._uiWindow.removeEventListener(UIWindowEvent.ACTION_SELECTED_EVENT,this.onActionSelected);
			this._uiWindow.disableActions();
			this._currentActionsCallback = null;
		}
		
		protected function addEventControllerListener(eventType:String, listener:Function, continueEvent:Boolean = true) : void
		{
			this._eventControllerListenerInfos[eventType] = new EventControllerListenerInfo(eventType,listener,continueEvent);
			this.eventController.addEventListener(eventType,this.processEventControllerListener);
		}
		
		private function processEventControllerListener(e:EventWithParams) : void
		{
			var listenerInfo:EventControllerListenerInfo = this._eventControllerListenerInfos[e.type];
			this.clearPendingOperations();
			this.onBeforeEventControllerListenerCall();
			listenerInfo.listener.call(this,e);
			this.onAfterEventControllerListenerCall();
			if(listenerInfo.continueEvent)
			{
				this.pendEventContinuation();
			}
			this.processPendingOperations();
		}
		
		protected function onBeforeEventControllerListenerCall() : void
		{
		}
		
		protected function onAfterEventControllerListenerCall() : void
		{
		}
		
		protected function processPendingOperations() : void
		{
			while(this._pendingOperationsQueue.length > 0)
			{
				if(!this.executeOperation(this._pendingOperationsQueue.shift()))
				{
					break;
				}
			}
		}
		
		protected function executeOperation(operation:Object) : Boolean
		{
			var simpleOperation:SimpleOperation = null;
			var sentenceOperation:SentenceOperation = null;
			var actionEnablingOperation:ActionEnablingOperation = null;
			var eventContinuationOperation:EventContinuationOperation = null;
			if(operation is EventContinuationOperation)
			{
				eventContinuationOperation = operation as EventContinuationOperation;
				this.eventController.continueEvent(eventContinuationOperation.withAction,eventContinuationOperation.data);
				return false;
			}
			if(operation is SentenceOperation)
			{
				sentenceOperation = operation as SentenceOperation;
				trace("\n");
				logInfo("                         > " + sentenceOperation.sentence + "\n");
				this._uiWindow.addSentence(sentenceOperation.sentence,sentenceOperation.delay,this.processPendingOperations);
				return false;
			}
			if(operation is ActionEnablingOperation)
			{
				actionEnablingOperation = operation as ActionEnablingOperation;
				this.enableActions(actionEnablingOperation.actions,actionEnablingOperation.callback,actionEnablingOperation.disableActionsOnCallback);
				return true;
			}
			if(operation is SimpleOperation)
			{
				simpleOperation = operation as SimpleOperation;
				switch(simpleOperation.operation)
				{
					case SimpleOperation.OPERATION_UPDATE_PARTY_STATS_UI:
						this.updatePartyStats();
						break;
					case SimpleOperation.OPERATION_UPDATE_GOLD_UI:
						this.updateGold();
						break;
					default:
						logWarning("Unknown simple operation type : " + simpleOperation.operation + ". No operation performed.");
						return false;
				}
				return true;
			}
			logWarning("Unknown operation type. No operation performed.");
			return false;
		}
		
		protected function pendEventContinuation(withAction:int = 0, data:Object = null) : void
		{
			this.pendOperation(new EventContinuationOperation(withAction,data));
		}
		
		protected function pendActionEnabling(action:String, callback:Function, disableActionsOnCallback:Boolean = true) : void
		{
			this.pendActionsEnabling(new <String>[action],callback,disableActionsOnCallback);
		}
		
		protected function pendActionsEnabling(actions:Vector.<String>, callback:Function, disableActionsOnCallback:Boolean = true) : void
		{
			this.pendOperation(new ActionEnablingOperation(actions,callback,disableActionsOnCallback));
		}
		
		protected function pendSentence(sentence:String, delayType:int = 1) : void
		{
			this.pendOperation(new SentenceOperation(sentence,delayType));
		}
		
		protected function pendGoldUpdate() : void
		{
			this.pendOperation(new SimpleOperation(SimpleOperation.OPERATION_UPDATE_GOLD_UI));
		}
		
		protected function pendPartyStatsUpdate() : void
		{
			this.pendOperation(new SimpleOperation(SimpleOperation.OPERATION_UPDATE_PARTY_STATS_UI));
		}
		
		protected function pendOperation(operation:Object) : void
		{
			this._pendingOperationsQueue.push(operation);
		}
		
		protected function clearPendingOperations() : void
		{
			this._pendingOperationsQueue = new Vector.<Object>();
		}
		
		private function onPartyStatsUpdatedByCheat(e:EventWithParams) : void
		{
			this.updatePartyStats();
		}
		
		override public function exit() : void
		{
			var controllerListenerInfo:EventControllerListenerInfo = null;
			this.disableActions();
			for each(controllerListenerInfo in this._eventControllerListenerInfos)
			{
				this.eventController.removeEventListener(controllerListenerInfo.eventType,this.processEventControllerListener);
			}
			this._eventControllerListenerInfos = new Dictionary();
			this._uiWindow.dispose();
			this._uiWindow = null;
			super.exit();
		}
		
		override public function Pause(paused:Boolean) : void
		{
			super.Pause(paused);
			if(paused)
			{
				this._uiWindow.pause();
			}
			else
			{
				this._uiWindow.resume();
			}
		}
		
		protected function goToState(destination:int, soundEvent:String = "", data:Object = null) : void
		{
			var continueEvent:EventWithParams = new EventWithParams(GameState.NAV_CONTINUE,{
				"target":this,
				"destination":destination,
				"data":data
			});
			if(soundEvent != SoundManager.NO_SOUND)
			{
				SoundManager.instance.playSound(soundEvent);
			}
			if(destination == StateController.WORLD_MAP)
			{
				this.disableActions();
				eaze(this).delay(0.1).onComplete(dispatchEvent,continueEvent);
			}
			else
			{
				dispatchEvent(continueEvent);
			}
		}
		
		override public function dispose() : void
		{
			this._pendingOperationsQueue = null;
			this._eventControllerListenerInfos = null;
			this._currentActionsCallback = null;
			super.dispose();
		}
	}
}
