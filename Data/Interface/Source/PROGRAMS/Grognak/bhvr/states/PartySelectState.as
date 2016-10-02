package bhvr.states
{
	import bhvr.controller.PartySelectEventController;
	import bhvr.data.database.Hero;
	import bhvr.controller.BaseEventController;
	import bhvr.events.PartySelectControllerEvents;
	import bhvr.data.GamePersistantData;
	import bhvr.events.EventWithParams;
	import bhvr.data.LocalizationStrings;
	import bhvr.module.event.operations.SentenceOperation;
	import Holotapes.Grognak.src.bhvr.module.partyselect.PartySelectEventActions;
	import mx.utils.StringUtil;
	import aze.motion.eaze;
	import bhvr.data.database.GameDatabase;
	import Shared.AS3.COMPANIONAPP.CompanionAppMode;
	import flash.display.MovieClip;
	
	public class PartySelectState extends BaseEventState
	{
		 
		
		private const WINDOW_TUTORIAL_OVERLAY_ID:String = "GrognakWindow";
		
		private var _partySelectController:PartySelectEventController;
		
		private var _remainingHeroes:Vector.<Hero>;
		
		private var _firstHeroSelectShown:Boolean = false;
		
		private var _tutorialShown:Boolean = false;
		
		public function PartySelectState(id:int, assets:MovieClip)
		{
			super(id,assets);
		}
		
		override public function get eventController() : BaseEventController
		{
			return this._partySelectController;
		}
		
		override public function enter(obj:Object = null) : void
		{
			super.enter();
			this._partySelectController = new PartySelectEventController();
			addEventControllerListener(PartySelectControllerEvents.INTRODUCTION,this.onIntroduction);
			addEventControllerListener(PartySelectControllerEvents.HERO_TO_SPEAK_SELECTION,this.onHeroToSpeakSelection,false);
			addEventControllerListener(PartySelectControllerEvents.SPEAK_TO_STRANGER,this.onSpeakToStranger,false);
			addEventControllerListener(PartySelectControllerEvents.STRANGER_REFUSED_IN_PARTY,this.onStrangerRefusedInParty,false);
			addEventControllerListener(PartySelectControllerEvents.STRANGER_ACCEPTED_IN_PARTY,this.onStrangerAcceptedInParty,false);
			addEventControllerListener(PartySelectControllerEvents.PARTY_INCOMPLETE,this.onPartyIncomplete,false);
			addEventControllerListener(PartySelectControllerEvents.PARTY_FULL,this.onPartyFull,false);
			this.resetUIToLocation();
			this._partySelectController.startEvent();
			GamePersistantData.shouldShowMapTutorial = true;
		}
		
		private function onIntroduction(e:EventWithParams) : void
		{
			pendSentence(LocalizationStrings.INTRODUCTION);
		}
		
		private function onHeroToSpeakSelection(e:EventWithParams) : void
		{
			var actionStrs:Vector.<String> = new Vector.<String>();
			this._remainingHeroes = e.params.remainingHeroes as Vector.<Hero>;
			for(var i:int = 0; i < this._remainingHeroes.length; i++)
			{
				actionStrs.push(this._remainingHeroes[i].fullName);
			}
			actionStrs.push(LocalizationStrings.NO_HERO_SELECTION);
			if(this._firstHeroSelectShown)
			{
				this.resetUIToLocation();
			}
			else
			{
				this._firstHeroSelectShown = true;
			}
			pendSentence(LocalizationStrings.SELECT_HERO_TO_SPEAK,SentenceOperation.DELAY_NONE);
			pendActionsEnabling(actionStrs,this.onHeroSelected);
		}
		
		private function onHeroSelected(e:EventWithParams) : void
		{
			var heroIdx:int = e.params.actionId;
			var hero:Hero = null;
			if(heroIdx < this._remainingHeroes.length)
			{
				hero = this._remainingHeroes[heroIdx];
			}
			pendEventContinuation(PartySelectEventActions.SPEAK_TO_HERO,{"hero":hero});
			processPendingOperations();
		}
		
		private function onSpeakToStranger(e:EventWithParams) : void
		{
			var hero:Hero = e.params.hero as Hero;
			_uiWindow.clearDialogBox();
			_uiWindow.setPortrait(hero.portrait);
			_uiWindow.setPortraitName(hero.mainName);
			pendSentence(hero.strangerSentence);
			pendSentence(StringUtil.substitute(LocalizationStrings.INVITE_STRANGER_TO_PARTY,hero.mainName),SentenceOperation.DELAY_NONE);
			pendActionsEnabling(new <String>[LocalizationStrings.NO_ACTION_LABEL,LocalizationStrings.YES_ACTION_LABEL],this.onAnswerToStranger);
		}
		
		private function onAnswerToStranger(e:EventWithParams) : void
		{
			var isPositiveAnswer:Boolean = e.params.actionId > 0;
			pendEventContinuation(PartySelectEventActions.ANSWER_TO_HERO,{"answer":isPositiveAnswer});
			processPendingOperations();
		}
		
		private function onStrangerRefusedInParty(e:EventWithParams) : void
		{
			var hero:Hero = e.params.hero as Hero;
			pendSentence(hero.refusedInPartySentence,SentenceOperation.DELAY_NONE);
			pendActionEnabling(LocalizationStrings.END_OF_STRANGER_INTERACTION_ACTION_LABEL,this.onContinueAfterStrangerInteraction);
		}
		
		private function onStrangerAcceptedInParty(e:EventWithParams) : void
		{
			var hero:Hero = e.params.hero as Hero;
			pendSentence(hero.acceptedInPartySentence,SentenceOperation.DELAY_NONE);
			pendActionEnabling(LocalizationStrings.END_OF_STRANGER_INTERACTION_ACTION_LABEL,this.onContinueAfterStrangerInteraction);
		}
		
		private function onContinueAfterStrangerInteraction(e:EventWithParams) : void
		{
			pendEventContinuation();
			processPendingOperations();
		}
		
		private function onPartyIncomplete(e:EventWithParams) : void
		{
			pendSentence(LocalizationStrings.INCOMPLETE_PARTY,SentenceOperation.DELAY_NONE);
			pendActionsEnabling(new <String>[LocalizationStrings.NO_ACTION_LABEL,LocalizationStrings.YES_ACTION_LABEL],this.onReadyAnswer);
		}
		
		private function onReadyAnswer(e:EventWithParams) : void
		{
			var isPositiveAnswer:Boolean = e.params.actionId == 1;
			if(isPositiveAnswer)
			{
				this.onEndPartySelect(null);
				return;
			}
			pendEventContinuation();
			processPendingOperations();
		}
		
		private function onPartyFull(e:EventWithParams) : void
		{
			this.resetUIToLocation();
			pendSentence(LocalizationStrings.FULL_PARTY,SentenceOperation.DELAY_NONE);
			pendActionEnabling(LocalizationStrings.BEGIN_ACTION_LABEL,this.onEndPartySelect);
		}
		
		private function onEndPartySelect(e:EventWithParams) : void
		{
			disableActions();
			eaze(this).delay(0.1).onComplete(dispatchEvent,new EventWithParams(GameState.NAV_CONTINUE,{"target":this}));
		}
		
		private function resetUIToLocation() : void
		{
			_uiWindow.clearDialogBox();
			_uiWindow.setLocationName(GameDatabase.partySelectMapLocation.locationName);
			_uiWindow.setPortrait(GameDatabase.partySelectMapLocation.portrait);
			_uiWindow.setPortraitName("");
			updatePartyStats();
		}
		
		override protected function enableActions(actionsStrs:Vector.<String>, callback:Function, disableActionsOnCallback:Boolean = true) : void
		{
			super.enableActions(actionsStrs,callback,disableActionsOnCallback);
			if(CompanionAppMode.isOn && !this._tutorialShown)
			{
				this._tutorialShown = true;
				requestTutorialOverlay(this.WINDOW_TUTORIAL_OVERLAY_ID);
			}
		}
		
		override public function exit() : void
		{
			GamePersistantData.setPartySelectionAsCompleted();
			super.exit();
			this._remainingHeroes = null;
			this._partySelectController.dispose();
			this._partySelectController = null;
		}
		
		override public function dispose() : void
		{
			this._remainingHeroes = null;
			if(this._partySelectController)
			{
				this._partySelectController.dispose();
				this._partySelectController = null;
			}
			super.dispose();
		}
	}
}
