package bhvr.controller
{
	import bhvr.data.database.RewardEvent;
	import bhvr.utils.ItemUtil;
	import bhvr.module.combat.HeroStats;
	import bhvr.module.reward.RewardEventActions;
	import bhvr.events.EventWithParams;
	import bhvr.events.RewardControllerEvents;
	import bhvr.data.database.StoryItem;
	import bhvr.data.database.Item;
	import bhvr.data.GamePersistantData;
	import bhvr.data.StoryConditionType;
	
	public class RewardEventController extends BaseEventController
	{
		 
		
		private var _rewardEvent:RewardEvent;
		
		private var _awaitingAction:Boolean = false;
		
		private var _rewardItemAssigned:Boolean = false;
		
		public function RewardEventController(rewardEvent:RewardEvent)
		{
			super();
			this._rewardEvent = rewardEvent;
		}
		
		override public function startEvent() : void
		{
			super.startEvent();
			if(this._rewardEvent)
			{
				this.onRewardFound();
			}
			else
			{
				this.onNoRewardFound();
			}
		}
		
		override public function continueEvent(withAction:int = 0, data:Object = null) : void
		{
			super.continueEvent(withAction,data);
			if(this._awaitingAction)
			{
				this.executeAction(withAction,data);
				return;
			}
			if(this._rewardEvent && ItemUtil.doesItemNeedAssignment(this._rewardEvent.item) && !this._rewardItemAssigned)
			{
				this.onRewardItemNeedsAssignement();
				return;
			}
			this.onRewardEventEnd();
		}
		
		private function executeAction(action:int, data:Object) : void
		{
			var hero:HeroStats = null;
			switch(action)
			{
				case RewardEventActions.ASSIGN_ITEM:
					hero = data && data.hero?data.hero as HeroStats:null;
					if(hero)
					{
						this.executeItemAssignement(hero);
					}
					else
					{
						logWarning("Hero data needed to perform ASSIGN_ITEM action. No action performed.");
					}
					break;
				case RewardEventActions.NONE:
					logWarning("The controller is waiting for an action. No action performed.");
					break;
				default:
					logWarning("Unknown action. No action performed.");
			}
		}
		
		private function onNoRewardFound() : void
		{
			_eventEnded = true;
			dispatchEvent(new EventWithParams(RewardControllerEvents.NO_REWARD_FOUND));
		}
		
		private function onRewardFound() : void
		{
			var storyItem:StoryItem = Boolean(this._rewardEvent.item)?this._rewardEvent.item as StoryItem:null;
			var item:Item = Boolean(this._rewardEvent.item)?this._rewardEvent.item as Item:null;
			if(this._rewardEvent.gold > 0)
			{
				GamePersistantData.addGold(this._rewardEvent.gold);
			}
			if(storyItem && storyItem.storyConditionTriggered != StoryConditionType.NONE)
			{
				GamePersistantData.setStoryCondition(storyItem.storyConditionTriggered,true);
			}
			if(item && item.boostsApplyToWholeParty)
			{
				ItemUtil.assignItemToAll(item);
			}
			dispatchEvent(new EventWithParams(RewardControllerEvents.REWARD_FOUND,{"rewardEvent":this._rewardEvent}));
		}
		
		private function onRewardItemNeedsAssignement() : void
		{
			this._awaitingAction = true;
			dispatchEvent(new EventWithParams(RewardControllerEvents.ITEM_NEEDS_ASSIGNEMENT,{"item":this._rewardEvent.item}));
		}
		
		private function executeItemAssignement(hero:HeroStats) : void
		{
			var item:Item = this._rewardEvent.item as Item;
			this._awaitingAction = false;
			this._rewardItemAssigned = true;
			ItemUtil.assignItemToHero(hero,item);
			dispatchEvent(new EventWithParams(RewardControllerEvents.ITEM_ASSIGNED,{
				"hero":hero,
				"item":this._rewardEvent.item
			}));
		}
		
		private function onRewardEventEnd() : void
		{
			_eventEnded = true;
			dispatchEvent(new EventWithParams(RewardControllerEvents.REWARD_EVENT_END,{"rewardEvent":this._rewardEvent}));
		}
	}
}
