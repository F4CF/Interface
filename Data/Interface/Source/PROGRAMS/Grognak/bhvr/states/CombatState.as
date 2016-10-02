package bhvr.states
{
	import bhvr.controller.CombatController;
	import flash.utils.Dictionary;
	import bhvr.data.database.CombatEvent;
	import bhvr.module.combat.InCombatHeroStats;
	import bhvr.controller.BaseEventController;
	import bhvr.data.GamePersistantData;
	import bhvr.module.combat.HeroStats;
	import bhvr.constants.GameConfig;
	import bhvr.controller.StateController;
	import bhvr.data.database.GameDatabase;
	import bhvr.events.CombatControllerEvents;
	import bhvr.manager.SoundManager;
	import bhvr.events.EventWithParams;
	import bhvr.data.database.Enemy;
	import mx.utils.StringUtil;
	import bhvr.data.LocalizationStrings;
	import bhvr.module.event.operations.SentenceOperation;
	import bhvr.module.combat.InCombatEnemyStats;
	import bhvr.data.database.Hero;
	import bhvr.module.combat.DamageInfo;
	import bhvr.data.SoundList;
	import bhvr.module.combat.CombatActions;
	import bhvr.module.map.MapActions;
	import bhvr.data.StoryConditionType;
	import flash.display.MovieClip;
	
	public class CombatState extends BaseEventState
	{
		 
		
		private var _combatController:CombatController;
		
		private var _combatEventListenerInfos:Dictionary;
		
		private var _locationName:String;
		
		private var _combatEvent:CombatEvent;
		
		private var _heroToIdMap:Dictionary;
		
		private var _currentHero:InCombatHeroStats;
		
		private var _currentHeroesActions:Vector.<int>;
		
		public function CombatState(id:int, assets:MovieClip)
		{
			super(id,assets);
		}
		
		override public function get eventController() : BaseEventController
		{
			return this._combatController;
		}
		
		override public function enter(obj:Object = null) : void
		{
			super.enter();
			var partyMembers:Vector.<HeroStats> = GamePersistantData.getPartyMembers();
			GamePersistantData.createSavePoint();
			if(GameConfig.STARTING_STATE == StateController.COMBAT_EVENT)
			{
				this._combatEvent = GameDatabase.defaultCombatEvent;
			}
			else
			{
				if(obj == null)
				{
					throw new Error("No data sent to the CombatState. No combat will be performed.");
				}
				this._combatEvent = obj.combatEvent as CombatEvent;
			}
			this._locationName = obj && obj.locationName?obj.locationName:"";
			this._heroToIdMap = new Dictionary();
			this._combatEventListenerInfos = new Dictionary();
			for(var i:uint = 0; i < partyMembers.length; i++)
			{
				this._heroToIdMap[partyMembers[i].hero] = i;
			}
			this._combatController = new CombatController(partyMembers,this._combatEvent);
			addEventControllerListener(CombatControllerEvents.COMBAT_START,this.onCombatStart);
			addEventControllerListener(CombatControllerEvents.ROUND_START,this.onRoundStart);
			addEventControllerListener(CombatControllerEvents.ROUND_END,this.onRoundEnd);
			addEventControllerListener(CombatControllerEvents.NOT_ENOUGH_FOCUS,this.onNotEnoughFocus,false);
			addEventControllerListener(CombatControllerEvents.HERO_NOT_WOUNDED,this.onHeroNotWounded,false);
			addEventControllerListener(CombatControllerEvents.HERO_ACTION_ACCEPTED,this.onHeroActionAccepted);
			addEventControllerListener(CombatControllerEvents.NEW_ENEMY,this.onNewEnemy);
			addEventControllerListener(CombatControllerEvents.ENEMY_MAIN_ATTACK,this.onEnemyMainAttack);
			addEventControllerListener(CombatControllerEvents.ENEMY_AREA_ATTACK_START,this.onEnemyAreaAttackStart);
			addEventControllerListener(CombatControllerEvents.ENEMY_AREA_ATTACK_HIT,this.onEnemyAreaAttackHit);
			addEventControllerListener(CombatControllerEvents.ENEMY_SLEEPING,this.onEnemySleeping);
			addEventControllerListener(CombatControllerEvents.ENEMY_WAKING_UP,this.onEnemyWakingUp);
			addEventControllerListener(CombatControllerEvents.ENEMY_END_OF_DAZE,this.onEnemyEndOfDaze);
			addEventControllerListener(CombatControllerEvents.ENEMY_DEATH,this.onEnemyDeath);
			addEventControllerListener(CombatControllerEvents.HERO_TURN,this.onHeroTurn,false);
			addEventControllerListener(CombatControllerEvents.HERO_MAIN_ATTACK,this.onHeroMainAttack);
			addEventControllerListener(CombatControllerEvents.HERO_RAGE_SP_ATTACK_START,this.onHeroRageSpecialAttackStart);
			addEventControllerListener(CombatControllerEvents.HERO_RAGE_SP_ATTACK_HIT,this.onHeroRageSpecialAttackHit);
			addEventControllerListener(CombatControllerEvents.HERO_DARE_SP_ATTACK_START,this.onHeroDareSpecialAttackStart);
			addEventControllerListener(CombatControllerEvents.HERO_DARE_SP_ATTACK_HIT,this.onHeroDareSpecialAttackHit);
			addEventControllerListener(CombatControllerEvents.HERO_SALVE_SP_ATTACK,this.onHeroSalveSpecialAttack);
			addEventControllerListener(CombatControllerEvents.HERO_SLEEP_SP_ATTACK,this.onHeroSleepSpecialAttack);
			addEventControllerListener(CombatControllerEvents.HERO_DAZE_SP_ATTACK_START,this.onHeroDazeSpecialAttackStart);
			addEventControllerListener(CombatControllerEvents.HERO_DAZE_SP_ATTACK_HIT,this.onHeroDazeSpecialAttackHit);
			addEventControllerListener(CombatControllerEvents.HERO_RECOVERY,this.onHeroRecovery);
			addEventControllerListener(CombatControllerEvents.HERO_MEDITATE,this.onHeroMeditate);
			addEventControllerListener(CombatControllerEvents.HERO_FLEE,this.onHeroFlee,false);
			addEventControllerListener(CombatControllerEvents.HERO_FLEE_MISS,this.onHeroFleeMiss);
			addEventControllerListener(CombatControllerEvents.HERO_END_OF_SALVE,this.onHeroEndOfSalve);
			addEventControllerListener(CombatControllerEvents.HERO_END_OF_DARE,this.onHeroEndOfDare);
			addEventControllerListener(CombatControllerEvents.HERO_DEATH,this.onHeroDeath);
			addEventControllerListener(CombatControllerEvents.COMBAT_WON,this.onCombatWon,false);
			addEventControllerListener(CombatControllerEvents.COMBAT_LOST,this.onCombatLost,false);
			_uiWindow.setLocationName(this._locationName);
			this._combatController.startEvent();
			SoundManager.instance.startSound(this._combatEvent.music);
		}
		
		override protected function onBeforeEventControllerListenerCall() : void
		{
			this._combatController.logFightersInfo();
		}
		
		private function onCombatStart(e:EventWithParams) : void
		{
			var enemy:Enemy = null;
			var enemyCount:int = 0;
			var enemyTypesCounts:Dictionary = null;
			var enemyTypesOrdered:Vector.<Enemy> = null;
			var enemyTypesDescriptions:Vector.<String> = null;
			var i:int = 0;
			var j:int = 0;
			var lastCountDescription:String = null;
			if(this._combatEvent.enemies.length > 0)
			{
				enemyTypesCounts = new Dictionary();
				enemyTypesOrdered = new Vector.<Enemy>();
				enemyTypesDescriptions = new Vector.<String>();
				this.updatePortraitEnemyUI(this._combatEvent.enemies[0]);
				this.updateHpEnemyUI(this._combatEvent.enemies[0].mainName,this._combatEvent.enemies[0].initialMaxHP);
				for(i = 0; i < this._combatEvent.enemies.length; i++)
				{
					enemy = this._combatEvent.enemies[i];
					if(enemyTypesCounts[enemy] == null)
					{
						enemyTypesCounts[enemy] = 0;
						enemyTypesOrdered.push(enemy);
					}
					enemyTypesCounts[enemy]++;
				}
				for(j = 0; j < enemyTypesOrdered.length; j++)
				{
					enemy = enemyTypesOrdered[j];
					enemyCount = enemyTypesCounts[enemy];
					enemyTypesDescriptions.push(StringUtil.substitute(LocalizationStrings.COMBAT_ENEMY_COUNT_DESC,enemyCount,enemyCount > 1?enemy.pluralMainName:enemy.mainName));
				}
				if(enemyTypesDescriptions.length > 1)
				{
					lastCountDescription = enemyTypesDescriptions.pop();
					pendSentence(StringUtil.substitute(LocalizationStrings.COMBAT_DESC_MULTIPLE_ENEMY_TYPES,enemyTypesDescriptions.join(", "),lastCountDescription));
				}
				else
				{
					pendSentence(StringUtil.substitute(LocalizationStrings.COMBAT_DESC_SINGLE_ENEMY_TYPE,enemyTypesDescriptions[0]));
				}
			}
		}
		
		private function onRoundStart(e:EventWithParams) : void
		{
			pendSentence(StringUtil.substitute(LocalizationStrings.COMBAT_ROUND_START,e.params.round),SentenceOperation.DELAY_MEDIUM);
		}
		
		private function onRoundEnd(e:EventWithParams) : void
		{
			updatePartyStats();
		}
		
		private function onNewEnemy(e:EventWithParams) : void
		{
			var enemyStats:InCombatEnemyStats = e.params.enemy as InCombatEnemyStats;
			var enemy:Enemy = enemyStats.enemy;
			this.updatePortraitEnemyUI(enemy);
			this.updateHpEnemyUI(enemy.mainName,enemyStats.currentHP);
			pendSentence(enemy.description);
		}
		
		private function onEnemyMainAttack(e:EventWithParams) : void
		{
			var enemy:Enemy = (e.params.enemy as InCombatEnemyStats).enemy;
			var target:Hero = (e.params.target as InCombatHeroStats).basicHeroStats.hero;
			var damage:DamageInfo = e.params.damage;
			_uiWindow.setPortraitEnemyHitState();
			SoundManager.instance.playSound(SoundList.SOUND_COMBAT_ENEMY_MAIN_ATTACK);
			this.pendDamageSentences(StringUtil.substitute(LocalizationStrings.MAIN_ATTACK,enemy.sentenceBeginningName,target.mainName,damage.damageDealt),target.mainName,damage);
		}
		
		private function onEnemyAreaAttackStart(e:EventWithParams) : void
		{
			var enemy:Enemy = (e.params.enemy as InCombatEnemyStats).enemy;
			SoundManager.instance.playSound(SoundList.SOUND_COMBAT_ENEMY_AREA_ATTACK_START);
			pendSentence(StringUtil.substitute(LocalizationStrings.ENEMY_AREA_ATTACK_START,enemy.sentenceBeginningName,enemy.areaAttackName));
		}
		
		private function onEnemyAreaAttackHit(e:EventWithParams) : void
		{
			var enemy:Enemy = (e.params.enemy as InCombatEnemyStats).enemy;
			var target:Hero = (e.params.target as InCombatHeroStats).basicHeroStats.hero;
			var damage:DamageInfo = e.params.damage;
			_uiWindow.setPortraitEnemyHitState();
			SoundManager.instance.playSound(SoundList.SOUND_COMBAT_ENEMY_AREA_ATTACK_HIT);
			this.pendDamageSentences(StringUtil.substitute(LocalizationStrings.ENEMY_AREA_ATTACK_HIT,target.mainName,damage.damageDealt),target.mainName,damage);
		}
		
		private function onEnemySleeping(e:EventWithParams) : void
		{
			var enemy:Enemy = (e.params.enemy as InCombatEnemyStats).enemy;
			pendSentence(StringUtil.substitute(LocalizationStrings.ENEMY_SLEEPING,enemy.sentenceBeginningName));
		}
		
		private function onEnemyWakingUp(e:EventWithParams) : void
		{
			var enemy:Enemy = (e.params.enemy as InCombatEnemyStats).enemy;
			pendSentence(StringUtil.substitute(LocalizationStrings.ENEMY_WAKING_UP,enemy.sentenceBeginningName));
		}
		
		private function onEnemyEndOfDaze(e:EventWithParams) : void
		{
			var enemy:Enemy = (e.params.enemy as InCombatEnemyStats).enemy;
			pendSentence(StringUtil.substitute(LocalizationStrings.ENEMY_END_OF_DAZE,enemy.sentenceBeginningName));
			SoundManager.instance.playSound(SoundList.SOUND_COMBAT_SPECIAL_ATTACK_EXPIRATION);
		}
		
		private function onEnemyDeath(e:EventWithParams) : void
		{
			var enemy:Enemy = (e.params.enemy as InCombatEnemyStats).enemy;
			_uiWindow.setPortraitEnemyDeathState();
			SoundManager.instance.playSound(SoundList.SOUND_COMBAT_ENEMY_DEATH);
			pendSentence(StringUtil.substitute(!!enemy.cantDie?LocalizationStrings.ENEMY_DOWN:LocalizationStrings.ENEMY_DEATH,enemy.sentenceBeginningName),SentenceOperation.DELAY_LONG);
		}
		
		private function onHeroTurn(e:EventWithParams) : void
		{
			var inCombatHeroStats:InCombatHeroStats = e.params.hero as InCombatHeroStats;
			var hero:Hero = inCombatHeroStats.basicHeroStats.hero;
			logInfo("onHeroTurn : " + hero.mainName);
			this._currentHero = inCombatHeroStats;
			_uiWindow.setPartyMemberTurn(this._heroToIdMap[hero]);
			var actionsStrs:Vector.<String> = new Vector.<String>();
			this._currentHeroesActions = new Vector.<int>();
			actionsStrs.push(LocalizationStrings.ATTACK_ACTION_LABEL);
			this._currentHeroesActions.push(CombatActions.ATTACK);
			if(inCombatHeroStats.basicHeroStats.hero.specialAttack != null)
			{
				actionsStrs.push(Boolean(inCombatHeroStats.basicHeroStats.hero.specialAttack.name)?inCombatHeroStats.basicHeroStats.hero.specialAttack.name:LocalizationStrings.SPECIAL_ATTACK_ACTION_LABEL);
				this._currentHeroesActions.push(CombatActions.SPECIAL_ATTACK);
			}
			actionsStrs.push(LocalizationStrings.MEDITATE_ACTION_LABEL);
			this._currentHeroesActions.push(CombatActions.MEDITATE);
			actionsStrs.push(LocalizationStrings.RECOVER_ACTION_LABEL);
			this._currentHeroesActions.push(CombatActions.RECOVER);
			actionsStrs.push(LocalizationStrings.FLEE_ACTION_LABEL);
			this._currentHeroesActions.push(CombatActions.FLEE);
			pendActionsEnabling(actionsStrs,this.onCombatActionSelected,false);
			this.addCheatListeners();
		}
		
		private function onCombatActionSelected(e:EventWithParams) : void
		{
			logInfo("onCombatActionSelected : " + e.params.actionId);
			pendEventContinuation(this._currentHeroesActions[e.params.actionId]);
			processPendingOperations();
		}
		
		private function onNotEnoughFocus(e:EventWithParams) : void
		{
			var focusNeeded:int = e.params.focus;
			pendSentence(StringUtil.substitute(LocalizationStrings.CANT_USE_SPECIAL_ATTACK,this._currentHero.basicHeroStats.hero.mainName,focusNeeded),SentenceOperation.DELAY_NONE);
		}
		
		private function onHeroNotWounded(e:EventWithParams) : void
		{
			pendSentence(StringUtil.substitute(LocalizationStrings.CANT_RECOVER,this._currentHero.basicHeroStats.hero.mainName),SentenceOperation.DELAY_NONE);
		}
		
		private function onHeroActionAccepted(e:EventWithParams) : void
		{
			this.removeCheatListeners();
			disableActions();
			_uiWindow.resetPartyMemberTurn();
			this._currentHeroesActions = null;
			this._currentHero = null;
		}
		
		private function onHeroMainAttack(e:EventWithParams) : void
		{
			var hero:Hero = (e.params.hero as InCombatHeroStats).basicHeroStats.hero;
			var targetStats:InCombatEnemyStats = e.params.target as InCombatEnemyStats;
			var target:Enemy = targetStats.enemy;
			var damage:DamageInfo = e.params.damage;
			_uiWindow.setPortraitHeroHitState(hero.attackVFX);
			SoundManager.instance.playSound(hero.attackSFX);
			this.updateHpEnemyUI(target.mainName,targetStats.currentHP);
			this.pendDamageSentences(StringUtil.substitute(LocalizationStrings.MAIN_ATTACK,hero.mainName,target.sentenceMiddleName,damage.damageDealt),target.sentenceBeginningName,damage);
		}
		
		private function onHeroRageSpecialAttackStart(e:EventWithParams) : void
		{
			var hero:Hero = (e.params.hero as InCombatHeroStats).basicHeroStats.hero;
			pendPartyStatsUpdate();
			pendSentence(StringUtil.substitute(LocalizationStrings.RAGE_SPECIAL_ATTACK_START,hero.mainName),SentenceOperation.DELAY_MEDIUM);
		}
		
		private function onHeroRageSpecialAttackHit(e:EventWithParams) : void
		{
			var hero:Hero = (e.params.hero as InCombatHeroStats).basicHeroStats.hero;
			var targetStats:InCombatEnemyStats = e.params.target as InCombatEnemyStats;
			var target:Enemy = targetStats.enemy;
			var damage:DamageInfo = e.params.damage;
			_uiWindow.setPortraitHeroHitState(hero.attackVFX);
			SoundManager.instance.playSound(hero.specialAttackSFX);
			this.updateHpEnemyUI(target.mainName,targetStats.currentHP);
			this.pendDamageSentences(StringUtil.substitute(LocalizationStrings.MAIN_ATTACK,hero.mainName,target.sentenceMiddleName,damage.damageDealt),target.sentenceBeginningName,damage);
		}
		
		private function onHeroDareSpecialAttackStart(e:EventWithParams) : void
		{
			var hero:Hero = (e.params.hero as InCombatHeroStats).basicHeroStats.hero;
			pendPartyStatsUpdate();
			pendSentence(StringUtil.substitute(LocalizationStrings.DARE_SPECIAL_ATTACK_START,hero.mainName),SentenceOperation.DELAY_MEDIUM);
		}
		
		private function onHeroDareSpecialAttackHit(e:EventWithParams) : void
		{
			var hero:Hero = (e.params.hero as InCombatHeroStats).basicHeroStats.hero;
			var targetStats:InCombatEnemyStats = e.params.target as InCombatEnemyStats;
			var target:Enemy = targetStats.enemy;
			var damage:DamageInfo = e.params.damage;
			_uiWindow.setPortraitHeroHitState(hero.attackVFX);
			SoundManager.instance.playSound(hero.specialAttackSFX);
			this.updateHpEnemyUI(target.mainName,targetStats.currentHP);
			this.pendDamageSentences(StringUtil.substitute(LocalizationStrings.MAIN_ATTACK,hero.mainName,target.sentenceMiddleName,damage.damageDealt),target.sentenceBeginningName,damage);
		}
		
		private function onHeroSalveSpecialAttack(e:EventWithParams) : void
		{
			var hero:Hero = (e.params.hero as InCombatHeroStats).basicHeroStats.hero;
			SoundManager.instance.playSound(hero.specialAttackSFX);
			pendPartyStatsUpdate();
			pendSentence(StringUtil.substitute(LocalizationStrings.SALVE_SPECIAL_ATTACK_START,hero.mainName));
		}
		
		private function onHeroSleepSpecialAttack(e:EventWithParams) : void
		{
			var hero:Hero = (e.params.hero as InCombatHeroStats).basicHeroStats.hero;
			var targetStats:InCombatEnemyStats = e.params.target as InCombatEnemyStats;
			var target:Enemy = targetStats.enemy;
			SoundManager.instance.playSound(hero.specialAttackSFX);
			_uiWindow.setPortraitHeroHitState(hero.attackVFX);
			this.updateHpEnemyUI(target.mainName,targetStats.currentHP);
			pendSentence(StringUtil.substitute(LocalizationStrings.SLEEP_SPECIAL_ATTACK_START,hero.mainName));
			pendSentence(StringUtil.substitute(LocalizationStrings.ENEMY_NOW_SLEEPING,target.sentenceBeginningName));
		}
		
		private function onHeroDazeSpecialAttackStart(e:EventWithParams) : void
		{
			var hero:Hero = (e.params.hero as InCombatHeroStats).basicHeroStats.hero;
			pendPartyStatsUpdate();
			pendSentence(StringUtil.substitute(LocalizationStrings.DAZE_SPECIAL_ATTACK_START,hero.mainName),SentenceOperation.DELAY_MEDIUM);
		}
		
		private function onHeroDazeSpecialAttackHit(e:EventWithParams) : void
		{
			var hero:Hero = (e.params.hero as InCombatHeroStats).basicHeroStats.hero;
			var targetStats:InCombatEnemyStats = e.params.target as InCombatEnemyStats;
			var target:Enemy = targetStats.enemy;
			var damage:DamageInfo = e.params.damage;
			_uiWindow.setPortraitHeroHitState(hero.attackVFX);
			SoundManager.instance.playSound(hero.specialAttackSFX);
			this.updateHpEnemyUI(target.mainName,targetStats.currentHP);
			this.pendDamageSentences(StringUtil.substitute(LocalizationStrings.MAIN_ATTACK,hero.mainName,target.sentenceMiddleName,damage.damageDealt),target.sentenceBeginningName,damage);
		}
		
		private function onHeroMeditate(e:EventWithParams) : void
		{
			var hero:Hero = (e.params.hero as InCombatHeroStats).basicHeroStats.hero;
			var focusRegen:int = e.params.focusRegen;
			pendPartyStatsUpdate();
			SoundManager.instance.playSound(SoundList.SOUND_COMBAT_MEDITATE);
			if(focusRegen > 0)
			{
				pendSentence(StringUtil.substitute(LocalizationStrings.MEDITATE_WITH_FOCUS_GAIN,hero.mainName,focusRegen));
			}
			else
			{
				pendSentence(StringUtil.substitute(LocalizationStrings.MEDITATE,hero.mainName));
			}
		}
		
		private function onHeroRecovery(e:EventWithParams) : void
		{
			var hero:Hero = (e.params.hero as InCombatHeroStats).basicHeroStats.hero;
			var recovery:int = e.params.recovery;
			SoundManager.instance.playSound(SoundList.SOUND_COMBAT_RECOVER);
			pendPartyStatsUpdate();
			pendSentence(StringUtil.substitute(!!hero.isMale?LocalizationStrings.RECOVERY_MALE:LocalizationStrings.RECOVERY_FEMALE,hero.mainName,recovery));
		}
		
		private function onHeroFlee(e:EventWithParams) : void
		{
			var hero:Hero = (e.params.hero as InCombatHeroStats).basicHeroStats.hero;
			SoundManager.instance.startLongSound(SoundList.SOUND_COMBAT_FLEE_SUCCESS);
			pendSentence(StringUtil.substitute(LocalizationStrings.HERO_FLEE,hero.mainName));
			pendSentence(LocalizationStrings.PARTY_FLEE,SentenceOperation.DELAY_NONE);
			pendActionEnabling(LocalizationStrings.CONTINUE_ACTION_LABEL,this.onContinueAfterFlee);
		}
		
		private function onHeroFleeMiss(e:EventWithParams) : void
		{
			var hero:Hero = (e.params.hero as InCombatHeroStats).basicHeroStats.hero;
			SoundManager.instance.playSound(SoundList.SOUND_COMBAT_FLEE_FAIL);
			pendSentence(StringUtil.substitute(LocalizationStrings.HERO_FLEE_MISS,hero.mainName));
		}
		
		private function onHeroEndOfSalve(e:EventWithParams) : void
		{
			var hero:Hero = (e.params.hero as InCombatHeroStats).basicHeroStats.hero;
			pendSentence(StringUtil.substitute(LocalizationStrings.HERO_END_OF_SALVE,hero.mainName));
			SoundManager.instance.playSound(SoundList.SOUND_COMBAT_SPECIAL_ATTACK_EXPIRATION);
		}
		
		private function onHeroEndOfDare(e:EventWithParams) : void
		{
			var hero:Hero = (e.params.hero as InCombatHeroStats).basicHeroStats.hero;
			pendSentence(StringUtil.substitute(LocalizationStrings.HERO_END_OF_DARE,hero.mainName));
			SoundManager.instance.playSound(SoundList.SOUND_COMBAT_SPECIAL_ATTACK_EXPIRATION);
		}
		
		private function onHeroDeath(e:EventWithParams) : void
		{
			var hero:Hero = (e.params.hero as InCombatHeroStats).basicHeroStats.hero;
			SoundManager.instance.playSound(SoundList.SOUND_COMBAT_HERO_DEATH);
			pendSentence(StringUtil.substitute(LocalizationStrings.HERO_DEATH,hero.mainName));
		}
		
		private function onContinueAfterFlee() : void
		{
			logInfo("onContinueAfterFlee");
			goToState(StateController.WORLD_MAP,SoundList.SOUND_COMBAT_TO_MAP_TRANSITION,{"actionRequested":MapActions.FLEE});
		}
		
		private function onCombatWon(e:EventWithParams) : void
		{
			pendSentence(LocalizationStrings.COMBAT_WON,SentenceOperation.DELAY_NONE);
			if(GamePersistantData.isStoryConditionMet(StoryConditionType.DEFEAT_SKULLPOCALYPSE))
			{
				pendActionEnabling(LocalizationStrings.CONTINUE_ACTION_LABEL,this.onContinueToGameWin);
			}
			else
			{
				pendActionEnabling(LocalizationStrings.SEARCH_ACTION_LABEL,this.onSearch);
			}
		}
		
		private function onCombatLost(e:EventWithParams) : void
		{
			pendSentence(LocalizationStrings.COMBAT_LOST,SentenceOperation.DELAY_MEDIUM);
			pendSentence(LocalizationStrings.COMBAT_RETRY,SentenceOperation.DELAY_NONE);
			pendActionsEnabling(new <String>[LocalizationStrings.YES_ACTION_LABEL,LocalizationStrings.NO_ACTION_LABEL],this.onRetryAnswer);
			_assets.gotoAndPlay("lose");
		}
		
		private function onSearch() : void
		{
			logInfo("onSearch");
			goToState(StateController.REWARD_EVENT,SoundList.SOUND_COMBAT_TO_REWARD_TRANSITION,{
				"rewardEvent":this._combatEvent.rewardEvent,
				"locationName":this._locationName
			});
		}
		
		private function onContinueToGameWin() : void
		{
			logInfo("onContinueToGameWin");
			goToState(StateController.GAME_OVER,SoundManager.NO_SOUND,{"won":true});
		}
		
		private function onRetryAnswer(e:EventWithParams) : void
		{
			logInfo("onRetryAnswer : " + e.params.actionId);
			if(e.params.actionId == 0)
			{
				GamePersistantData.restoreSavePoint();
				goToState(StateController.WORLD_MAP,SoundList.SOUND_COMBAT_TO_MAP_TRANSITION,{"actionRequested":MapActions.FLEE});
				return;
			}
			goToState(StateController.GAME_OVER,SoundManager.NO_SOUND,{"won":false});
		}
		
		private function pendDamageSentences(damageDealtText:String, targetName:String, damage:DamageInfo) : void
		{
			switch(damage.alterationType)
			{
				case DamageInfo.ALTERATION_SALVE:
					pendSentence(damageDealtText);
					pendPartyStatsUpdate();
					pendSentence(StringUtil.substitute(LocalizationStrings.SALVE_ALTERED_HIT,targetName,damage.alteredDamage));
					break;
				case DamageInfo.ALTERATION_DARE:
					pendSentence(damageDealtText);
					pendPartyStatsUpdate();
					pendSentence(StringUtil.substitute(LocalizationStrings.DARE_ALTERED_HIT,targetName,damage.alteredDamage));
					break;
				case DamageInfo.ALTERATION_MEDITATE:
					pendSentence(damageDealtText);
					pendPartyStatsUpdate();
					pendSentence(StringUtil.substitute(LocalizationStrings.MEDITATE_ALTERED_HIT,targetName,damage.alteredDamage));
					break;
				case DamageInfo.ALTERATION_SLEEP:
					pendSentence(damageDealtText);
					pendSentence(StringUtil.substitute(LocalizationStrings.SLEEP_ALTERED_HIT,targetName,damage.alteredDamage - damage.damageDealt));
					break;
				case DamageInfo.ALTERATION_DAZE:
					pendSentence(damageDealtText);
					pendSentence(StringUtil.substitute(LocalizationStrings.DAZE_ALTERED_HIT,targetName,damage.alteredDamage - damage.damageDealt));
					break;
				default:
					pendPartyStatsUpdate();
					pendSentence(damageDealtText);
			}
			if(damage.alterationType == DamageInfo.ALTERATION_SALVE || damage.alterationType == DamageInfo.ALTERATION_DARE || damage.alterationType == DamageInfo.ALTERATION_MEDITATE)
			{
				SoundManager.instance.playSound(SoundList.SOUND_COMBAT_DAMAGE_REDUCTION);
			}
		}
		
		private function updatePortraitEnemyUI(enemy:Enemy) : void
		{
			_uiWindow.setPortraitName(enemy.mainName);
			_uiWindow.setPortrait(enemy.portrait);
			_uiWindow.setPortraitNormalState();
		}
		
		private function updateHpEnemyUI(name:String, hpValue:int) : void
		{
			_uiWindow.setPortraitName(StringUtil.substitute(LocalizationStrings.ENEMY_NAME_HP,name,hpValue.toString()));
		}
		
		private function addCheatListeners() : void
		{
		}
		
		private function removeCheatListeners() : void
		{
		}
		
		override public function exit() : void
		{
			this.removeCheatListeners();
			SoundManager.instance.stopSound(this._combatEvent.music);
			super.exit();
			this._combatController.dispose();
			this._combatController = null;
			this._combatEvent = null;
		}
		
		override public function dispose() : void
		{
			this._heroToIdMap = null;
			this._currentHero = null;
			this._combatEventListenerInfos = null;
			if(this._combatController)
			{
				this._combatController.dispose();
				this._combatController = null;
			}
			this._combatEvent = null;
			super.dispose();
		}
	}
}
