package bhvr.controller
{
	import bhvr.data.database.Hero;
	import Holotapes.Grognak.src.bhvr.module.partyselect.PartySelectEventActions;
	import bhvr.events.EventWithParams;
	import bhvr.events.PartySelectControllerEvents;
	import bhvr.data.database.GameDatabase;
	import bhvr.data.GamePersistantData;
	import bhvr.module.combat.HeroStats;
	import bhvr.constants.GameConstants;
	
	public class PartySelectEventController extends BaseEventController
	{
		 
		
		private var _waitingForAction:int = 0;
		
		private var _currentlySpeakingTo:Hero;
		
		public function PartySelectEventController()
		{
			super();
		}
		
		override public function startEvent() : void
		{
			super.startEvent();
			this.onIntroduction();
		}
		
		override public function continueEvent(withAction:int = 0, data:Object = null) : void
		{
			super.continueEvent(withAction,data);
			if(this._waitingForAction != PartySelectEventActions.NONE)
			{
				if(withAction != this._waitingForAction)
				{
					logWarning("Waiting for action " + this._waitingForAction + ", but received action " + withAction + ". No action performed.");
					return;
				}
				if(withAction == PartySelectEventActions.SPEAK_TO_HERO)
				{
					if(data.hero == null)
					{
						this.onPartyIncomplete();
						return;
					}
					this.onSpeakToHero(data.hero);
					return;
				}
				if(withAction == PartySelectEventActions.ANSWER_TO_HERO)
				{
					this.onAnswerToHero(data.answer);
					return;
				}
			}
			if(this.isPartyFull())
			{
				this.onPartyFull();
				return;
			}
			this.onHeroToSpeakSelection();
		}
		
		private function onIntroduction() : void
		{
			dispatchEvent(new EventWithParams(PartySelectControllerEvents.INTRODUCTION));
		}
		
		private function onHeroToSpeakSelection() : void
		{
			this._waitingForAction = PartySelectEventActions.SPEAK_TO_HERO;
			dispatchEvent(new EventWithParams(PartySelectControllerEvents.HERO_TO_SPEAK_SELECTION,{"remainingHeroes":GameDatabase.heroes.filter(this.filterHeroNotYetAPartyMember,this)}));
		}
		
		private function onSpeakToHero(hero:Hero) : void
		{
			this._waitingForAction = PartySelectEventActions.ANSWER_TO_HERO;
			this._currentlySpeakingTo = hero;
			dispatchEvent(new EventWithParams(!!this.isHeroAPartyMember(hero)?PartySelectControllerEvents.SPEAK_TO_PARTY_MEMBER:PartySelectControllerEvents.SPEAK_TO_STRANGER,{"hero":hero}));
		}
		
		private function onAnswerToHero(positiveAnswer:Boolean) : void
		{
			var hero:Hero = this._currentlySpeakingTo;
			this._currentlySpeakingTo = null;
			this._waitingForAction = PartySelectEventActions.NONE;
			if(!positiveAnswer)
			{
				dispatchEvent(new EventWithParams(PartySelectControllerEvents.STRANGER_REFUSED_IN_PARTY,{"hero":hero}));
				return;
			}
			GamePersistantData.addPartyMember(hero);
			dispatchEvent(new EventWithParams(PartySelectControllerEvents.STRANGER_ACCEPTED_IN_PARTY,{"hero":hero}));
		}
		
		private function onPartyIncomplete() : void
		{
			this._currentlySpeakingTo = null;
			this._waitingForAction = PartySelectEventActions.NONE;
			dispatchEvent(new EventWithParams(PartySelectControllerEvents.PARTY_INCOMPLETE));
		}
		
		private function onPartyFull() : void
		{
			_eventEnded = true;
			this._currentlySpeakingTo = null;
			this._waitingForAction = PartySelectEventActions.NONE;
			dispatchEvent(new EventWithParams(PartySelectControllerEvents.PARTY_FULL));
		}
		
		private function filterHeroNotYetAPartyMember(hero:Hero, index:int, vector:Vector.<Hero>) : Boolean
		{
			return !this.isHeroAPartyMember(hero);
		}
		
		private function isHeroAPartyMember(hero:Hero) : Boolean
		{
			var partyMembers:Vector.<HeroStats> = GamePersistantData.getPartyMembers();
			for(var i:int = 0; i < partyMembers.length; i++)
			{
				if(partyMembers[i].hero == hero)
				{
					return true;
				}
			}
			return false;
		}
		
		private function isPartyFull() : Boolean
		{
			return GamePersistantData.getPartyMembers().length >= GameConstants.MAX_PARTY_MEMBERS;
		}
		
		override public function dispose() : void
		{
			this._currentlySpeakingTo = null;
			super.dispose();
		}
	}
}
