package bhvr.controller
{
	import bhvr.data.database.InteractionEvent;
	import bhvr.data.database.Dialogue;
	import bhvr.data.database.DialogueOption;
	import bhvr.data.database.InventoryDialogue;
	import bhvr.data.database.ShopItem;
	import bhvr.data.database.Item;
	import bhvr.data.database.RevivalDialogue;
	import bhvr.module.interaction.InteractionEventActions;
	import bhvr.utils.ItemUtil;
	import bhvr.events.EventWithParams;
	import bhvr.events.InteractionControllerEvents;
	import bhvr.data.database.DialogueItemOption;
	import bhvr.module.combat.HeroStats;
	import bhvr.data.GamePersistantData;
	import bhvr.manager.SoundManager;
	import bhvr.data.StoryConditionType;
	import bhvr.data.database.DialogueRevivalOption;
	import bhvr.data.database.CombatEvent;
	import bhvr.data.database.DialogueTree;
	import bhvr.data.database.DialogueBranch;
	import mx.utils.StringUtil;
	import bhvr.data.LocalizationStrings;
	import bhvr.data.database.DialogueSentence;
	import bhvr.module.event.operations.SentenceOperation;
	
	public class InteractionEventController extends BaseEventController
	{
		 
		
		private var _interactionEvent:InteractionEvent;
		
		private var _currentDialogue:Dialogue;
		
		private var _optionToExecute:DialogueOption;
		
		private var _optionExecutionStarted:Boolean;
		
		private var _shouldInteract:Boolean;
		
		private var _previousInventoryDialogue:InventoryDialogue;
		
		private var _itemReceived:ShopItem;
		
		private var _itemToAssign:Item;
		
		private var _previousRevivalDialogue:RevivalDialogue;
		
		public function InteractionEventController(interactionEvent:InteractionEvent)
		{
			super();
			this._interactionEvent = interactionEvent;
		}
		
		override public function startEvent() : void
		{
			super.startEvent();
			if(!this.isNpcActive())
			{
				this.onNoInteraction();
				return;
			}
			this.onInteractionStart();
		}
		
		override public function continueEvent(withAction:int = 0, data:Object = null) : void
		{
			var dialogue:Dialogue = null;
			super.continueEvent(withAction,data);
			if(this._itemToAssign)
			{
				if(withAction != InteractionEventActions.ASSIGN_ITEM)
				{
					logWarning("InteractionEventController is waiting for action " + InteractionEventActions.ASSIGN_ITEM + " but received " + withAction + ". No action performed.");
					return;
				}
				if(!data || !data.hasOwnProperty("hero"))
				{
					logWarning("Action ASSIGN_ITEM needs an hero as data. No action performed.");
					return;
				}
				this.executeItemAssignement(data.hero);
				return;
			}
			if(this._itemReceived)
			{
				if(ItemUtil.doesItemNeedAssignment(this._itemReceived))
				{
					this.onItemNeedsAssignement();
					return;
				}
				this._itemReceived = null;
			}
			if(this._optionToExecute)
			{
				if(this._optionExecutionStarted)
				{
					this.endOptionExecution();
					return;
				}
				this.executeOption();
				return;
			}
			if(this._currentDialogue)
			{
				if(withAction != InteractionEventActions.ANSWER_DIALOGUE)
				{
					logWarning("InteractionEventController is waiting for action " + InteractionEventActions.ANSWER_DIALOGUE + " but received " + withAction + ". No action performed.");
					return;
				}
				if(!data || !data.hasOwnProperty("option"))
				{
					logWarning("Action ANSWER_DIALOGUE needs an option id. No action performed.");
					return;
				}
				this.validateOption(this._currentDialogue.options[data.option]);
				return;
			}
			if(this._shouldInteract)
			{
				dialogue = this.getActiveDialogueFromTree(this._interactionEvent.dialogueTree);
				if(dialogue)
				{
					this.onNewDialogue(dialogue);
					return;
				}
			}
			this.onNoDialogue();
		}
		
		private function onNoInteraction() : void
		{
			logInfo("onNoInteraction");
			this._shouldInteract = false;
			dispatchEvent(new EventWithParams(InteractionControllerEvents.NO_INTERACTION));
		}
		
		private function onInteractionStart() : void
		{
			logInfo("onInteractionStart");
			this._shouldInteract = true;
			dispatchEvent(new EventWithParams(InteractionControllerEvents.INTERACTION_START,{"npc":this._interactionEvent.npc}));
		}
		
		private function onNoDialogue() : void
		{
			logInfo("onNoDialogue");
			_eventEnded = true;
			dispatchEvent(new EventWithParams(InteractionControllerEvents.NO_DIALOGUE));
		}
		
		private function onNewDialogue(dialogue:Dialogue) : void
		{
			logInfo("onNewDialogue");
			this._currentDialogue = dialogue;
			this._optionToExecute = null;
			dispatchEvent(new EventWithParams(InteractionControllerEvents.NEW_DIALOGUE,{"dialogue":this._currentDialogue}));
		}
		
		private function validateOption(option:DialogueOption) : void
		{
			var itemOption:DialogueItemOption = null;
			var partyWillGetHP:Boolean = false;
			var partyWillGetFocus:Boolean = false;
			var atLeastOneHeroIsMissingHP:Boolean = false;
			var atLeastOneHeroIsMissingFocus:Boolean = false;
			var partyMember:HeroStats = null;
			var partyMembers:Vector.<HeroStats> = null;
			var i:int = 0;
			logInfo("validateOption");
			if(option.price > 0)
			{
				if(!GamePersistantData.hasEnoughGold(option.price))
				{
					this.onNotEnoughGold();
					return;
				}
			}
			if(option is DialogueItemOption)
			{
				itemOption = option as DialogueItemOption;
				if(itemOption.item && itemOption.item.hasBoostToLimitedStat && !itemOption.item.hasBoostToUnlimitedStat)
				{
					atLeastOneHeroIsMissingHP = false;
					atLeastOneHeroIsMissingFocus = false;
					partyMembers = GamePersistantData.getPartyMembers();
					for(i = 0; i < partyMembers.length; i++)
					{
						partyMember = partyMembers[i];
						if(partyMember.currentFocus < partyMember.currentMaxFocus)
						{
							atLeastOneHeroIsMissingFocus = true;
						}
						if(partyMember.currentHP < partyMember.currentMaxHP)
						{
							atLeastOneHeroIsMissingHP = true;
						}
					}
					partyWillGetFocus = itemOption.item.focusBoost > 0 && atLeastOneHeroIsMissingFocus;
					partyWillGetHP = itemOption.item.hpBoost > 0 && atLeastOneHeroIsMissingHP;
					if(!partyWillGetFocus && !partyWillGetHP)
					{
						this.onItemWontAffectParty(itemOption.item);
						return;
					}
				}
			}
			GamePersistantData.useGold(option.price);
			SoundManager.instance.playSound(option.soundEvent);
			this._optionToExecute = option;
			dispatchEvent(new EventWithParams(InteractionControllerEvents.ANSWER_ACCEPTED,{"goldSpent":option.price}));
		}
		
		private function onNotEnoughGold() : void
		{
			logInfo("onNotEnoughGold");
			dispatchEvent(new EventWithParams(InteractionControllerEvents.NOT_ENOUGH_GOLD));
		}
		
		private function onItemWontAffectParty(item:Item) : void
		{
			logInfo("onItemWontAffectParty");
			dispatchEvent(new EventWithParams(InteractionControllerEvents.ITEM_WONT_AFFECT_PARTY,{"item":item}));
		}
		
		private function executeOption() : void
		{
			logInfo("executeOption");
			this._optionExecutionStarted = true;
			if(this._optionToExecute.storyConditionTriggered != StoryConditionType.NONE)
			{
				GamePersistantData.setStoryCondition(this._optionToExecute.storyConditionTriggered,true);
			}
			if(this._optionToExecute is DialogueItemOption)
			{
				this.executeItemOption(this._optionToExecute as DialogueItemOption);
				return;
			}
			if(this._optionToExecute is DialogueRevivalOption)
			{
				this.executeRevivalOption(this._optionToExecute as DialogueRevivalOption);
				return;
			}
			this.endOptionExecution();
		}
		
		private function executeItemOption(itemOption:DialogueItemOption) : void
		{
			logInfo("executeItemOption");
			this._itemReceived = itemOption.item;
			GamePersistantData.setShopItemAsBought(this._itemReceived);
			if(this._itemReceived.boostsApplyToWholeParty)
			{
				ItemUtil.assignItemToAll(this._itemReceived);
			}
			dispatchEvent(new EventWithParams(InteractionControllerEvents.ITEM_RECEIVED,{"item":this._itemReceived}));
		}
		
		private function onItemNeedsAssignement() : void
		{
			this._itemToAssign = this._itemReceived;
			dispatchEvent(new EventWithParams(InteractionControllerEvents.ITEM_NEEDS_ASSIGNEMENT,{"item":this._itemToAssign}));
		}
		
		private function executeItemAssignement(hero:HeroStats) : void
		{
			var assignedItem:Item = this._itemToAssign;
			ItemUtil.assignItemToHero(hero,this._itemToAssign);
			this._itemReceived = null;
			this._itemToAssign = null;
			dispatchEvent(new EventWithParams(InteractionControllerEvents.ITEM_ASSIGNED,{
				"hero":hero,
				"item":assignedItem
			}));
		}
		
		private function executeRevivalOption(revivalOption:DialogueRevivalOption) : void
		{
			logInfo("executeRevivalOption");
			revivalOption.hero.fullHeal();
			dispatchEvent(new EventWithParams(InteractionControllerEvents.HERO_REVIVED,{"hero":revivalOption.hero}));
		}
		
		private function endOptionExecution() : void
		{
			var nextDialogue:Dialogue = null;
			logInfo("endOptionExecution");
			this._optionExecutionStarted = false;
			if(this._optionToExecute.combatEvent)
			{
				this.onCombatTriggered(this._optionToExecute.combatEvent);
				return;
			}
			nextDialogue = Boolean(this._optionToExecute.nextDialogueTree)?this.getActiveDialogueFromTree(this._optionToExecute.nextDialogueTree):null;
			if(nextDialogue)
			{
				this.onNewDialogue(nextDialogue);
				return;
			}
			if(this._optionToExecute.needShipTravel)
			{
				this.onShipTriggered();
				return;
			}
			this.onInteractionEnd();
		}
		
		private function onCombatTriggered(combatEvent:CombatEvent) : void
		{
			logInfo("onCombatTriggered");
			_eventEnded = true;
			dispatchEvent(new EventWithParams(InteractionControllerEvents.COMBAT_TRIGGERED,{"combatEvent":combatEvent}));
		}
		
		private function onShipTriggered() : void
		{
			logInfo("onShipTriggered");
			_eventEnded = true;
			dispatchEvent(new EventWithParams(InteractionControllerEvents.SHIP_TRIGGERED));
		}
		
		private function onInteractionEnd() : void
		{
			logInfo("onInteractionEnd");
			_eventEnded = true;
			dispatchEvent(new EventWithParams(InteractionControllerEvents.INTERACTION_END));
		}
		
		private function getActiveDialogueFromTree(tree:DialogueTree) : Dialogue
		{
			var branch:DialogueBranch = null;
			if(!tree)
			{
				return null;
			}
			for(var i:int = tree.dialogueBranches.length - 1; i >= 0; i--)
			{
				branch = tree.dialogueBranches[i];
				if(GamePersistantData.areStoryConditionsMet(branch.conditions))
				{
					return this.prepareDialogue(branch.dialogue);
				}
			}
			return null;
		}
		
		private function prepareDialogue(dialogue:Dialogue) : Dialogue
		{
			if(dialogue is InventoryDialogue)
			{
				return this.prepareInventoryDialogue(dialogue as InventoryDialogue);
			}
			if(dialogue is RevivalDialogue)
			{
				return this.prepareRevivalDialogue(dialogue as RevivalDialogue);
			}
			return dialogue;
		}
		
		private function prepareInventoryDialogue(inventoryDialogue:InventoryDialogue) : Dialogue
		{
			var i:int = 0;
			var dialogueOption:DialogueOption = null;
			var dialogueItemOption:DialogueItemOption = null;
			var itemOptionsCount:int = 0;
			var preparedDialogue:Dialogue = new Dialogue();
			var nextTree:DialogueTree = new DialogueTree();
			var inventorySentences:Vector.<String> = new Vector.<String>();
			var reshowingInventory:Boolean = this._previousInventoryDialogue == inventoryDialogue;
			nextTree.dialogueBranches.push(new DialogueBranch(inventoryDialogue));
			for(i = 0; i < inventoryDialogue.options.length; i++)
			{
				dialogueOption = inventoryDialogue.options[i];
				if(dialogueOption is DialogueItemOption)
				{
					dialogueItemOption = dialogueOption as DialogueItemOption;
					if(!dialogueItemOption.item.canOnlyBeBoughtOnce || !GamePersistantData.isShopItemBought(dialogueItemOption.item))
					{
						dialogueItemOption = dialogueItemOption.copy();
						dialogueItemOption.nextDialogueTree = nextTree;
						inventorySentences.push(StringUtil.substitute(LocalizationStrings.SHOP_ITEM_DESCRIPTION,ItemUtil.getItemDescription(dialogueItemOption.item),dialogueOption.price));
						preparedDialogue.options.push(dialogueItemOption);
						itemOptionsCount++;
					}
				}
				else
				{
					preparedDialogue.options.push(dialogueOption);
				}
			}
			if(!reshowingInventory)
			{
				for(i = 0; i < inventoryDialogue.sentences.length; i++)
				{
					preparedDialogue.sentences.push(inventoryDialogue.sentences[i].copy());
				}
			}
			else if(itemOptionsCount > 0 && inventoryDialogue.reshownText)
			{
				preparedDialogue.sentences.push(new DialogueSentence(inventoryDialogue.reshownText));
			}
			if(inventorySentences.length > 0)
			{
				if(!reshowingInventory && preparedDialogue.sentences.length > 0)
				{
					preparedDialogue.sentences[preparedDialogue.sentences.length - 1].delayType = SentenceOperation.DELAY_SHORT;
				}
				preparedDialogue.sentences.push(new DialogueSentence(inventorySentences.join("\n> ")));
			}
			this._previousInventoryDialogue = inventoryDialogue;
			return preparedDialogue;
		}
		
		private function prepareRevivalDialogue(revivalDialogue:RevivalDialogue) : Dialogue
		{
			var i:int = 0;
			var partyMember:HeroStats = null;
			var revivalOption:DialogueRevivalOption = null;
			var preparedDialogue:Dialogue = new Dialogue();
			var nextTree:DialogueTree = new DialogueTree();
			var reshowingRevival:Boolean = this._previousRevivalDialogue == revivalDialogue;
			var partyMembers:Vector.<HeroStats> = GamePersistantData.getPartyMembers();
			nextTree.dialogueBranches.push(new DialogueBranch(revivalDialogue));
			for(i = 0; i < partyMembers.length; i++)
			{
				partyMember = partyMembers[i];
				if(partyMember.isDead)
				{
					revivalOption = new DialogueRevivalOption(partyMember);
					revivalOption.nextDialogueTree = nextTree;
					revivalOption.price = revivalDialogue.price;
					preparedDialogue.options.push(revivalOption);
				}
			}
			if(!reshowingRevival)
			{
				for(i = 0; i < revivalDialogue.sentences.length; i++)
				{
					preparedDialogue.sentences.push(revivalDialogue.sentences[i].copy());
				}
			}
			else if(revivalDialogue.reshownText)
			{
				preparedDialogue.sentences.push(new DialogueSentence(revivalDialogue.reshownText));
			}
			for(i = 0; i < revivalDialogue.options.length; i++)
			{
				preparedDialogue.options.push(revivalDialogue.options[i]);
			}
			this._previousRevivalDialogue = revivalDialogue;
			return preparedDialogue;
		}
		
		private function isNpcActive() : Boolean
		{
			var storyCondition:int = 0;
			if(!this._interactionEvent.npc)
			{
				return false;
			}
			for(var i:uint = 0; i < this._interactionEvent.npcPresenceStoryConditions.length; i++)
			{
				storyCondition = this._interactionEvent.npcPresenceStoryConditions[i];
				if(!GamePersistantData.isStoryConditionMet(storyCondition))
				{
					return false;
				}
			}
			return true;
		}
		
		override public function dispose() : void
		{
			this._currentDialogue = null;
			this._optionToExecute = null;
			this._itemReceived = null;
			this._itemToAssign = null;
			this._previousInventoryDialogue = null;
			this._previousRevivalDialogue = null;
			super.dispose();
		}
	}
}
