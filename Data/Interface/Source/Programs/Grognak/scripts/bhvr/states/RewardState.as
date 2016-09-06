package bhvr.states
{
	import bhvr.data.database.RewardEvent;
	import bhvr.controller.RewardEventController;
	import bhvr.controller.BaseEventController;
	import bhvr.events.RewardControllerEvents;
	import bhvr.manager.SoundManager;
	import bhvr.events.EventWithParams;
	import bhvr.data.LocalizationStrings;
	import bhvr.module.event.operations.SentenceOperation;
	import bhvr.data.assets.PortraitSymbols;
	import bhvr.data.database.Item;
	import bhvr.data.GamePersistantData;
	import bhvr.module.combat.HeroStats;
	import mx.utils.StringUtil;
	import bhvr.module.reward.RewardEventActions;
	import bhvr.data.SoundList;
	import aze.motion.eaze;
	import bhvr.utils.ItemUtil;
	import flash.display.MovieClip;
	
	public class RewardState extends BaseEventState
	{
		 
		
		private var _rewardEvent:RewardEvent;
		
		private var _rewardEventController:RewardEventController;
		
		public function RewardState(id:int, assets:MovieClip)
		{
			super(id,assets);
		}
		
		override public function get eventController() : BaseEventController
		{
			return this._rewardEventController;
		}
		
		override public function enter(obj:Object = null) : void
		{
			super.enter();
			this._rewardEvent = Boolean(obj)?obj.rewardEvent:null;
			this._rewardEventController = new RewardEventController(this._rewardEvent);
			addEventControllerListener(RewardControllerEvents.NO_REWARD_FOUND,this.onNoRewardFound,false);
			addEventControllerListener(RewardControllerEvents.REWARD_FOUND,this.onRewardFound);
			addEventControllerListener(RewardControllerEvents.ITEM_NEEDS_ASSIGNEMENT,this.onItemNeedsAssignement,false);
			addEventControllerListener(RewardControllerEvents.ITEM_ASSIGNED,this.onItemAssigned);
			addEventControllerListener(RewardControllerEvents.REWARD_EVENT_END,this.onRewardEventEnd,false);
			_uiWindow.setLocationName(obj && obj.locationName?obj.locationName:"");
			this._rewardEventController.startEvent();
			SoundManager.instance.startSound(this._rewardEvent.music);
		}
		
		private function onNoRewardFound(e:EventWithParams) : void
		{
			pendSentence(LocalizationStrings.NO_REWARD_FOUND,SentenceOperation.DELAY_NONE);
			pendActionEnabling(LocalizationStrings.LEAVE_ACTION_LABEL,this.onLeave);
		}
		
		private function onRewardFound(e:EventWithParams) : void
		{
			var rewardEvent:RewardEvent = e.params.rewardEvent as RewardEvent;
			_uiWindow.setPortrait(rewardEvent.item && rewardEvent.item.portrait?rewardEvent.item.portrait:PortraitSymbols.REWARD_DEFAULT);
			_uiWindow.setPortraitName(this._rewardEvent.item && this._rewardEvent.item.name?this._rewardEvent.item.name:LocalizationStrings.DEFAULT_REWARD_NAME);
			pendGoldUpdate();
			pendPartyStatsUpdate();
			pendSentence(this.getRewardDescription());
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
			logInfo("onItemAssigned : " + e.params.actionId);
			var selectedHero:HeroStats = GamePersistantData.getPartyMembers()[e.params.actionId];
			pendEventContinuation(RewardEventActions.ASSIGN_ITEM,{"hero":selectedHero});
			processPendingOperations();
		}
		
		private function onItemAssigned(e:EventWithParams) : void
		{
			var heroStats:HeroStats = e.params.hero as HeroStats;
			var item:Item = e.params.item as Item;
			pendPartyStatsUpdate();
			pendSentence(StringUtil.substitute(LocalizationStrings.ITEM_GIVEN,heroStats.hero.mainName,item.giveName));
			SoundManager.instance.playSound(SoundList.SOUND_REWARD_ASSIGN);
		}
		
		private function onRewardEventEnd(e:EventWithParams) : void
		{
			var rewardEvent:RewardEvent = e.params.rewardEvent as RewardEvent;
			if(rewardEvent.endMessage)
			{
				pendSentence(rewardEvent.endMessage,SentenceOperation.DELAY_NONE);
			}
			pendActionEnabling(LocalizationStrings.LEAVE_ACTION_LABEL,this.onLeave);
		}
		
		private function onLeave(e:EventWithParams) : void
		{
			SoundManager.instance.playSound(SoundList.SOUND_REWARD_TO_MAP_TRANSITION);
			disableActions();
			eaze(this).delay(0.1).onComplete(dispatchEvent,new EventWithParams(GameState.NAV_CONTINUE,{"target":this}));
		}
		
		private function getRewardDescription() : String
		{
			var singleStr:String = null;
			var goldStr:String = null;
			var itemStr:String = null;
			if(this._rewardEvent.gold > 0)
			{
				singleStr = goldStr = StringUtil.substitute(LocalizationStrings.REWARD_GOLD,this._rewardEvent.gold);
			}
			if(this._rewardEvent.item)
			{
				singleStr = itemStr = Boolean(this._rewardEvent.item.receivedText)?ItemUtil.substituteTextWithItemInfo(this._rewardEvent.item.receivedText,this._rewardEvent.item):ItemUtil.getItemReceivedDescriptionPart(this._rewardEvent.item);
			}
			return goldStr && itemStr?StringUtil.substitute(LocalizationStrings.REWARD_FOUND_MULTIPLE_DESCRIPTION,goldStr,itemStr):StringUtil.substitute(LocalizationStrings.REWARD_FOUND_SINGLE_DESCRIPTION,singleStr);
		}
		
		override public function exit() : void
		{
			SoundManager.instance.stopSound(this._rewardEvent.music);
			super.exit();
			this._rewardEvent = null;
			this._rewardEventController.dispose();
			this._rewardEventController = null;
		}
		
		override public function dispose() : void
		{
			this._rewardEvent = null;
			if(this._rewardEventController)
			{
				this._rewardEventController.dispose();
				this._rewardEventController = null;
			}
			super.dispose();
		}
	}
}
