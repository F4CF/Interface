package bhvr.states
{
	import bhvr.data.database.InteractionEvent;
	import bhvr.controller.InteractionEventController;
	import bhvr.data.database.Dialogue;
	import bhvr.controller.BaseEventController;
	import bhvr.events.InteractionControllerEvents;
	import bhvr.data.assets.PortraitSymbols;
	import bhvr.manager.SoundManager;
	import bhvr.events.EventWithParams;
	import bhvr.module.event.operations.SentenceOperation;
	import bhvr.data.database.NPC;
	import bhvr.data.LocalizationStrings;
	import bhvr.data.database.DialogueSentence;
	import bhvr.data.database.DialogueOption;
	import bhvr.module.interaction.InteractionEventActions;
	import bhvr.data.database.Item;
	import mx.utils.StringUtil;
	import bhvr.utils.ItemUtil;
	import bhvr.data.GamePersistantData;
	import bhvr.module.combat.HeroStats;
	import bhvr.data.SoundList;
	import bhvr.controller.StateController;
	import bhvr.module.map.MapActions;
	import flash.display.MovieClip;
	
	public class InteractionState extends BaseEventState
	{
		 
		
		private var _locationName:String;
		
		private var _locationDescription:String;
		
		private var _interactionEvent:InteractionEvent;
		
		private var _interactionEventController:InteractionEventController;
		
		private var _currentDialogue:Dialogue;
		
		public function InteractionState(id:int, assets:MovieClip)
		{
			super(id,assets);
		}
		
		override public function get eventController() : BaseEventController
		{
			return this._interactionEventController;
		}
		
		override public function enter(obj:Object = null) : void
		{
			super.enter();
			if(!obj)
			{
				throw new Error("Can\'t enter the interaction state without any data.");
			}
			if(!obj.interactionEvent)
			{
				throw new Error("Can\'t enter the interaction state without an interaction event.");
			}
			this._locationName = Boolean(obj.locationName)?obj.locationName:"";
			this._locationDescription = obj.locationDescription;
			this._interactionEvent = obj.interactionEvent;
			this._interactionEventController = new InteractionEventController(this._interactionEvent);
			addEventControllerListener(InteractionControllerEvents.NO_INTERACTION,this.onNoInteraction);
			addEventControllerListener(InteractionControllerEvents.INTERACTION_START,this.onInteractionStart,false);
			addEventControllerListener(InteractionControllerEvents.NO_DIALOGUE,this.onNoDialogue,false);
			addEventControllerListener(InteractionControllerEvents.NEW_DIALOGUE,this.onNewDialogue,false);
			addEventControllerListener(InteractionControllerEvents.NOT_ENOUGH_GOLD,this.onNotEnoughGold,false);
			addEventControllerListener(InteractionControllerEvents.ITEM_WONT_AFFECT_PARTY,this.onItemWontAffectParty,false);
			addEventControllerListener(InteractionControllerEvents.ANSWER_ACCEPTED,this.onAnswerAccepted);
			addEventControllerListener(InteractionControllerEvents.ITEM_RECEIVED,this.onItemReceived);
			addEventControllerListener(InteractionControllerEvents.ITEM_NEEDS_ASSIGNEMENT,this.onItemNeedsAssignement,false);
			addEventControllerListener(InteractionControllerEvents.ITEM_ASSIGNED,this.onItemAssigned);
			addEventControllerListener(InteractionControllerEvents.HERO_REVIVED,this.onHeroRevived);
			addEventControllerListener(InteractionControllerEvents.COMBAT_TRIGGERED,this.onCombatTriggered,false);
			addEventControllerListener(InteractionControllerEvents.SHIP_TRIGGERED,this.onShipTriggered,false);
			addEventControllerListener(InteractionControllerEvents.INTERACTION_END,this.onInteractionEnd,false);
			_uiWindow.setLocationName(this._locationName);
			_uiWindow.setPortrait(Boolean(obj.locationPortrait)?obj.locationPortrait:PortraitSymbols.NO_IMAGE);
			this._interactionEventController.startEvent();
			SoundManager.instance.startSound(this._interactionEvent.music);
		}
		
		private function onNoInteraction(e:EventWithParams) : void
		{
			if(this._locationDescription)
			{
				pendSentence(this._locationDescription,SentenceOperation.DELAY_NONE);
			}
		}
		
		private function onInteractionStart(e:EventWithParams) : void
		{
			var npc:NPC = e.params.npc as NPC;
			if(npc.portrait)
			{
				_uiWindow.setPortrait(npc.portrait);
			}
			if(npc.name)
			{
				_uiWindow.setPortraitName(npc.name);
			}
			if(npc.description)
			{
				pendSentence(npc.description,SentenceOperation.DELAY_NONE);
				pendActionEnabling(LocalizationStrings.TALK_ACTION_LABEL,this.onStartTalking);
			}
			else
			{
				pendEventContinuation();
			}
		}
		
		private function onStartTalking(e:EventWithParams) : void
		{
			pendEventContinuation();
			processPendingOperations();
		}
		
		private function onNoDialogue(e:EventWithParams) : void
		{
			pendActionEnabling(LocalizationStrings.LEAVE_ACTION_LABEL,this.onOptionSelected,false);
		}
		
		private function onNewDialogue(e:EventWithParams) : void
		{
			var dialogueSentence:DialogueSentence = null;
			var dialogueOption:DialogueOption = null;
			var optionStrs:Vector.<String> = new Vector.<String>();
			this._currentDialogue = e.params.dialogue as Dialogue;
			for(var i:int = 0; i < this._currentDialogue.options.length; i++)
			{
				dialogueOption = this._currentDialogue.options[i];
				optionStrs.push(dialogueOption.text);
			}
			for(var j:int = 0; j < this._currentDialogue.sentences.length; j++)
			{
				dialogueSentence = this._currentDialogue.sentences[j];
				pendSentence(dialogueSentence.sentence,dialogueSentence.delayType);
			}
			pendActionsEnabling(optionStrs,this.onOptionSelected,false);
		}
		
		private function onOptionSelected(e:EventWithParams) : void
		{
			var optionIdx:int = e.params.actionId;
			var maxOptionIdx:int = Boolean(this._currentDialogue)?int(this._currentDialogue.options.length - 1):int(-1);
			if(optionIdx > maxOptionIdx)
			{
				this.leave();
				return;
			}
			pendEventContinuation(InteractionEventActions.ANSWER_DIALOGUE,{"option":optionIdx});
			processPendingOperations();
		}
		
		private function onNotEnoughGold(e:EventWithParams) : void
		{
			pendSentence(LocalizationStrings.INTERACTION_NOT_ENOUGH_GOLD);
		}
		
		private function onItemWontAffectParty(e:EventWithParams) : void
		{
			var item:Item = e.params.item as Item;
			if(item.focusBoost > 0)
			{
				pendSentence(LocalizationStrings.INTERACTION_PARTY_AT_FULL_FOCUS);
			}
			else if(item.hpBoost > 0)
			{
				pendSentence(LocalizationStrings.INTERACTION_PARTY_AT_FULL_HP);
			}
		}
		
		private function onAnswerAccepted(e:EventWithParams) : void
		{
			var goldSpent:uint = e.params.goldSpent;
			pendGoldUpdate();
			if(goldSpent > 0)
			{
				pendSentence(StringUtil.substitute(LocalizationStrings.INTERACTION_GOLD_SPENT,goldSpent,this._interactionEvent.npc.sentenceMiddleName));
			}
			this._currentDialogue = null;
			disableActions();
		}
		
		private function onItemReceived(e:EventWithParams) : void
		{
			var item:Item = e.params.item as Item;
			pendPartyStatsUpdate();
			pendSentence(Boolean(item.receivedText)?ItemUtil.substituteTextWithItemInfo(item.receivedText,item):StringUtil.substitute(LocalizationStrings.ITEM_BOUGHT_DESCRIPTION,ItemUtil.getItemReceivedDescriptionPart(item)));
		}
		
		private function onItemNeedsAssignement(e:EventWithParams) : void
		{
			var item:Item = e.params.item as Item;
			var heroChoicesStrs:Vector.<String> = new Vector.<String>();
			var partyMembers:Vector.<HeroStats> = GamePersistantData.getPartyMembers();
			for(var i:int = 0; i < partyMembers.length; i++)
			{
				heroChoicesStrs.push(partyMembers[i].hero.mainName);
			}
			pendSentence(StringUtil.substitute(LocalizationStrings.ITEM_GIVE,item.giveName),SentenceOperation.DELAY_NONE);
			pendActionsEnabling(heroChoicesStrs,this.onHeroSelectedForItemAssignement);
		}
		
		private function onHeroSelectedForItemAssignement(e:EventWithParams) : void
		{
			logInfo("onHeroSelectedForItemAssignement : " + e.params.actionId);
			var selectedHero:HeroStats = GamePersistantData.getPartyMembers()[e.params.actionId];
			pendEventContinuation(InteractionEventActions.ASSIGN_ITEM,{"hero":selectedHero});
			processPendingOperations();
		}
		
		private function onItemAssigned(e:EventWithParams) : void
		{
			var heroStats:HeroStats = e.params.hero as HeroStats;
			var item:Item = e.params.item as Item;
			pendPartyStatsUpdate();
			pendSentence(StringUtil.substitute(LocalizationStrings.ITEM_GIVEN,heroStats.hero.mainName,item.giveName),SentenceOperation.DELAY_MEDIUM);
		}
		
		private function onHeroRevived(e:EventWithParams) : void
		{
			var heroStats:HeroStats = e.params.hero as HeroStats;
			pendPartyStatsUpdate();
			pendSentence(StringUtil.substitute(LocalizationStrings.HERO_REVIVAL,heroStats.hero.mainName),SentenceOperation.DELAY_MEDIUM);
			SoundManager.instance.playSound(SoundList.SOUND_INTERACTION_CHAPEL_REVIVE);
		}
		
		private function onCombatTriggered(e:EventWithParams) : void
		{
			goToState(StateController.COMBAT_EVENT,SoundList.SOUND_INTERACTION_TO_COMBAT_TRANSITION,{
				"combatEvent":e.params.combatEvent,
				"locationName":this._locationName
			});
		}
		
		private function onShipTriggered(e:EventWithParams) : void
		{
			goToState(StateController.WORLD_MAP,SoundList.SOUND_INTERACTION_TO_MAP_TRANSITION,{"actionRequested":MapActions.SHIP_TRAVEL});
		}
		
		private function onInteractionEnd(e:EventWithParams) : void
		{
			this.leave();
		}
		
		private function leave() : void
		{
			disableActions();
			goToState(StateController.WORLD_MAP,SoundList.SOUND_INTERACTION_TO_MAP_TRANSITION);
		}
		
		override public function exit() : void
		{
			SoundManager.instance.stopSound(this._interactionEvent.music);
			super.exit();
			this._interactionEvent = null;
			this._interactionEventController.dispose();
			this._interactionEventController = null;
			this._currentDialogue = null;
		}
		
		override public function dispose() : void
		{
			this._interactionEvent = null;
			if(this._interactionEventController)
			{
				this._interactionEventController.dispose();
				this._interactionEventController = null;
			}
			this._currentDialogue = null;
			super.dispose();
		}
	}
}
