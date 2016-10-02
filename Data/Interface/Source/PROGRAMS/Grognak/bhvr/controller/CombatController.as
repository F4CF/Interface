package bhvr.controller
{
	import bhvr.data.database.CombatEvent;
	import bhvr.module.combat.InCombatHeroStats;
	import bhvr.module.combat.InCombatEnemyStats;
	import bhvr.data.database.Enemy;
	import bhvr.interfaces.IFighterStats;
	import bhvr.events.EventWithParams;
	import bhvr.events.CombatControllerEvents;
	import bhvr.module.combat.CombatActions;
	import bhvr.module.combat.DamageInfo;
	import bhvr.module.combat.HeroStats;
	import bhvr.constants.GameConstants;
	import bhvr.module.combat.HeroSpecialAttacks;
	import bhvr.utils.MathUtil;
	import bhvr.data.StoryConditionType;
	import bhvr.data.GamePersistantData;
	
	public class CombatController extends BaseEventController
	{
		 
		
		private var _combatEvent:CombatEvent;
		
		private var _inCombatHeroesStats:Vector.<InCombatHeroStats>;
		
		private var _currentEnemyStats:InCombatEnemyStats = null;
		
		private var _currentEnemyRoundCount:int;
		
		private var _enemiesQueue:Vector.<Enemy>;
		
		private var _roundStartedCount:int;
		
		private var _roundEndedCount:int;
		
		private var _currentRoundFighter:IFighterStats;
		
		private var _roundFightersQueue:Vector.<IFighterStats>;
		
		private var _awaitingActionForHero:Boolean = false;
		
		private var _heroActionToExecute:int = 0;
		
		private var _enemyAreaAttackRemainingHits:Vector.<InCombatHeroStats>;
		
		private var _rageSpecialAttackRemainingHits:int;
		
		private var _rageSpecialAttackCumulatedDamage:int;
		
		private var _dareSpecialAttackRemainingHits:int;
		
		private var _dazeSpecialAttackRemainingHits:int;
		
		public function CombatController(heroes:Vector.<HeroStats>, combatEvent:CombatEvent)
		{
			var hero:HeroStats = null;
			this._inCombatHeroesStats = new Vector.<InCombatHeroStats>();
			this._enemiesQueue = new Vector.<Enemy>();
			this._roundFightersQueue = new Vector.<IFighterStats>();
			this._enemyAreaAttackRemainingHits = new Vector.<InCombatHeroStats>();
			super();
			this._combatEvent = combatEvent;
			for(var i:int = 0; i < heroes.length; i++)
			{
				hero = heroes[i];
				if(hero.currentHP > 0)
				{
					this._inCombatHeroesStats.push(new InCombatHeroStats(hero));
				}
			}
			this._enemiesQueue = this._combatEvent.enemies.concat();
		}
		
		override public function startEvent() : void
		{
			super.startEvent();
			dispatchEvent(new EventWithParams(CombatControllerEvents.COMBAT_START));
		}
		
		override public function continueEvent(withAction:int = 0, data:Object = null) : void
		{
			var i:int = 0;
			var hero:InCombatHeroStats = null;
			super.continueEvent();
			for(i = 0; i < this._inCombatHeroesStats.length; i++)
			{
				hero = this._inCombatHeroesStats[i];
				if(hero.isSalved && hero.remainingSalve <= 0)
				{
					this.onHeroEndOfSalve(hero);
					return;
				}
			}
			if(this._heroActionToExecute != CombatActions.NONE)
			{
				this.executeHeroAction();
				return;
			}
			if(this._awaitingActionForHero)
			{
				this.validateHeroAction(withAction);
				return;
			}
			if(this._currentEnemyStats == null)
			{
				if(this._roundEndedCount < this._roundStartedCount)
				{
					this.endRound();
					return;
				}
				if(!this.hasNextEnemy())
				{
					this.onCombatWon();
					return;
				}
				this.setNextEnemyAsCurrent();
				return;
			}
			if(this._currentEnemyStats.currentHP <= 0)
			{
				this.onCurrentEnemyDeath();
				return;
			}
			if(this._currentEnemyStats.isSleeping && this._currentEnemyStats.remainingSleep == 0)
			{
				this.executeEnemyWakeUp();
				return;
			}
			if(this._rageSpecialAttackRemainingHits > 0)
			{
				this.executeHeroRageSpecialAttackHit();
				return;
			}
			if(this._dareSpecialAttackRemainingHits > 0)
			{
				this.executeHeroDareSpecialAttackHit();
				return;
			}
			if(this._dazeSpecialAttackRemainingHits > 0)
			{
				this.executeHeroDazeSpecialAttackHit();
				return;
			}
			if(this._inCombatHeroesStats.length == 0)
			{
				this.onCombatLost();
				return;
			}
			for(i = 0; i < this._inCombatHeroesStats.length; i++)
			{
				hero = this._inCombatHeroesStats[i];
				if(hero.currentHP <= 0)
				{
					this._inCombatHeroesStats.splice(i,1);
					this.onHeroDeath(hero);
					return;
				}
			}
			if(this._enemyAreaAttackRemainingHits.length > 0)
			{
				hero = this._enemyAreaAttackRemainingHits.shift();
				if(hero.currentHP <= 0)
				{
					this.continueEvent();
					return;
				}
				this.executeEnemyAreaAttackHit(hero);
				return;
			}
			if(this.checkCurrentHeroForEndOfDare())
			{
				this.onHeroEndOfDare(this._currentRoundFighter as InCombatHeroStats);
				return;
			}
			if(this._roundFightersQueue.length == 0)
			{
				this._currentRoundFighter = null;
				if(this._roundEndedCount < this._roundStartedCount)
				{
					this.endRound();
					return;
				}
				this.startNewRound();
				return;
			}
			if(this._roundFightersQueue[0] == this._currentEnemyStats)
			{
				if(this._currentEnemyStats.isSleeping)
				{
					this._currentEnemyStats.decrementSleep();
					if(this._currentEnemyStats.remainingSleep == 0)
					{
						this.executeEnemyWakeUp();
						return;
					}
				}
				if(this._currentEnemyStats.isDazed)
				{
					if(!this._currentEnemyStats.isSleeping)
					{
						this._currentEnemyStats.decrementDaze();
					}
					if(this._currentEnemyStats.remainingDaze == 0)
					{
						this.executeEnemyEndOfDaze();
						return;
					}
				}
			}
			this._currentRoundFighter = this._roundFightersQueue.shift();
			if(this._currentRoundFighter is InCombatEnemyStats)
			{
				this.executeEnemyTurn();
				return;
			}
			if(this._currentRoundFighter is InCombatHeroStats)
			{
				if(this._currentRoundFighter.currentHP <= 0)
				{
					this.continueEvent();
					return;
				}
				this.executeHeroTurn(this._currentRoundFighter as InCombatHeroStats);
				return;
			}
		}
		
		private function executeEnemyTurn() : void
		{
			logInfo("executeEnemyTurn : " + this._currentEnemyStats.fighterName);
			if(this._currentEnemyStats.isSleeping)
			{
				this.executeEnemySleeping();
			}
			else if(this._currentEnemyStats.enemy.areaAttackFrequency > 0 && this._currentEnemyRoundCount % this._currentEnemyStats.enemy.areaAttackFrequency == 0)
			{
				this.executeEnemyAreaAttack();
			}
			else
			{
				this.executeEnemyMainAttack();
			}
		}
		
		private function executeEnemyMainAttack() : void
		{
			logInfo("executeEnemyMainAttack : " + this._currentEnemyStats.fighterName);
			var target:InCombatHeroStats = this.getEnemyMainAttackTarget();
			var damageInfo:DamageInfo = this.damageHero(target,this._currentEnemyStats.enemy.initialMinMainAttackPower,this._currentEnemyStats.enemy.initialMaxMainAttackPower);
			dispatchEvent(new EventWithParams(CombatControllerEvents.ENEMY_MAIN_ATTACK,{
				"enemy":this._currentEnemyStats,
				"target":target,
				"damage":damageInfo
			}));
		}
		
		private function executeEnemyAreaAttack() : void
		{
			logInfo("executeEnemyAreaAttack : " + this._currentEnemyStats.fighterName);
			this._enemyAreaAttackRemainingHits = this._inCombatHeroesStats.concat();
			dispatchEvent(new EventWithParams(CombatControllerEvents.ENEMY_AREA_ATTACK_START,{"enemy":this._currentEnemyStats}));
		}
		
		private function executeEnemyAreaAttackHit(hero:InCombatHeroStats) : void
		{
			logInfo("executeEnemyAreaAttackHit : " + this._currentEnemyStats.fighterName);
			var damageInfo:DamageInfo = this.damageHero(hero,this._currentEnemyStats.enemy.minAreaAttackPower,this._currentEnemyStats.enemy.maxAreaAttackPower);
			dispatchEvent(new EventWithParams(CombatControllerEvents.ENEMY_AREA_ATTACK_HIT,{
				"enemy":this._currentEnemyStats,
				"target":hero,
				"damage":damageInfo
			}));
		}
		
		private function executeEnemySleeping() : void
		{
			logInfo("executeEnemySleeping : " + this._currentEnemyStats.fighterName);
			dispatchEvent(new EventWithParams(CombatControllerEvents.ENEMY_SLEEPING,{"enemy":this._currentEnemyStats}));
		}
		
		private function executeEnemyWakeUp() : void
		{
			logInfo("executeEnemyWakeUp : " + this._currentEnemyStats.fighterName);
			this._currentEnemyStats.wakeup();
			dispatchEvent(new EventWithParams(CombatControllerEvents.ENEMY_WAKING_UP,{"enemy":this._currentEnemyStats}));
		}
		
		private function executeEnemyEndOfDaze() : void
		{
			logInfo("executeEnemyEndOfDaze : " + this._currentEnemyStats.fighterName);
			this._currentEnemyStats.undaze();
			dispatchEvent(new EventWithParams(CombatControllerEvents.ENEMY_END_OF_DAZE,{"enemy":this._currentEnemyStats}));
		}
		
		private function executeHeroTurn(inCombatHeroStats:InCombatHeroStats) : void
		{
			logInfo("executeHeroTurn : " + inCombatHeroStats.fighterName);
			inCombatHeroStats.stopMeditation();
			this._awaitingActionForHero = true;
			dispatchEvent(new EventWithParams(CombatControllerEvents.HERO_TURN,{"hero":inCombatHeroStats}));
		}
		
		private function validateHeroAction(action:int) : void
		{
			logInfo("validateHeroAction");
			var inCombatHeroStats:InCombatHeroStats = this._currentRoundFighter as InCombatHeroStats;
			if(action == CombatActions.RECOVER && inCombatHeroStats.currentHP >= inCombatHeroStats.basicHeroStats.currentMaxHP)
			{
				this.onHeroNotWounded();
				return;
			}
			if(action == CombatActions.SPECIAL_ATTACK && inCombatHeroStats.currentFocus < inCombatHeroStats.basicHeroStats.hero.specialAttack.focusCost)
			{
				this.onNotEnoughFocus(inCombatHeroStats.basicHeroStats.hero.specialAttack.focusCost);
				return;
			}
			this._awaitingActionForHero = false;
			this._heroActionToExecute = action;
			dispatchEvent(new EventWithParams(CombatControllerEvents.HERO_ACTION_ACCEPTED));
		}
		
		private function onNotEnoughFocus(neededFocus:int) : void
		{
			dispatchEvent(new EventWithParams(CombatControllerEvents.NOT_ENOUGH_FOCUS,{"focus":neededFocus}));
		}
		
		private function onHeroNotWounded() : void
		{
			dispatchEvent(new EventWithParams(CombatControllerEvents.HERO_NOT_WOUNDED));
		}
		
		private function executeHeroAction() : void
		{
			var action:int = this._heroActionToExecute;
			this._heroActionToExecute = CombatActions.NONE;
			switch(action)
			{
				case CombatActions.ATTACK:
					this.executeHeroMainAttack();
					break;
				case CombatActions.SPECIAL_ATTACK:
					this.executeHeroSpecialAttack();
					break;
				case CombatActions.FLEE:
					this.executeHeroFlee();
					break;
				case CombatActions.MEDITATE:
					this.executeHeroMeditate();
					break;
				case CombatActions.RECOVER:
					this.executeHeroRecovery();
					break;
				case CombatActions.NONE:
					logWarning("The controller is waiting for an action from the current hero. No action performed.");
					break;
				default:
					logWarning("Unknown action. No action performed.");
			}
		}
		
		private function executeHeroMainAttack() : void
		{
			logInfo("executeHeroMainAttack : " + this._currentRoundFighter.fighterName);
			var inCombatHeroStats:InCombatHeroStats = this._currentRoundFighter as InCombatHeroStats;
			var heroStats:HeroStats = inCombatHeroStats.basicHeroStats;
			var damageInfo:DamageInfo = this.damageEnemy(heroStats.currentMinMainAttackPower,heroStats.currentMaxMainAttackPower);
			inCombatHeroStats.currentAggro = inCombatHeroStats.currentAggro + damageInfo.alteredDamage * GameConstants.factorAggroDmg;
			dispatchEvent(new EventWithParams(CombatControllerEvents.HERO_MAIN_ATTACK,{
				"hero":inCombatHeroStats,
				"target":this._currentEnemyStats,
				"damage":damageInfo
			}));
		}
		
		private function executeHeroSpecialAttack() : void
		{
			logInfo("executeHeroSpecialAttack : " + this._currentRoundFighter.fighterName);
			var inCombatHeroStats:InCombatHeroStats = this._currentRoundFighter as InCombatHeroStats;
			switch(inCombatHeroStats.basicHeroStats.hero.specialAttack.id)
			{
				case HeroSpecialAttacks.RAGE:
					this.executeHeroRageSpecialAttack();
					break;
				case HeroSpecialAttacks.DARE:
					this.executeHeroDareSpecialAttack();
					break;
				case HeroSpecialAttacks.SALVE:
					this.executeHeroSalveSpecialAttack();
					break;
				case HeroSpecialAttacks.SLEEP:
					this.executeHeroSleepSpecialAttack();
					break;
				case HeroSpecialAttacks.DAZE:
					this.executeHeroDazeSpecialAttack();
					break;
				default:
					logWarning("Unknown special attack id. No special attack performed.");
					return;
			}
		}
		
		private function executeHeroRageSpecialAttack() : void
		{
			var inCombatHeroStats:InCombatHeroStats = this._currentRoundFighter as InCombatHeroStats;
			logInfo("executeHeroRageSpecialAttack : " + inCombatHeroStats.fighterName);
			this._rageSpecialAttackRemainingHits = GameConstants.rageStrikes;
			this._rageSpecialAttackCumulatedDamage = 0;
			inCombatHeroStats.basicHeroStats.useFocus(inCombatHeroStats.basicHeroStats.hero.specialAttack.focusCost);
			dispatchEvent(new EventWithParams(CombatControllerEvents.HERO_RAGE_SP_ATTACK_START,{"hero":inCombatHeroStats}));
		}
		
		private function executeHeroRageSpecialAttackHit() : void
		{
			logInfo("executeHeroRageSpecialAttackHit : " + this._currentRoundFighter.fighterName);
			var inCombatHeroStats:InCombatHeroStats = this._currentRoundFighter as InCombatHeroStats;
			var heroStats:HeroStats = inCombatHeroStats.basicHeroStats;
			var damageInfo:DamageInfo = this.damageEnemy(heroStats.currentMinMainAttackPower,heroStats.currentMaxMainAttackPower);
			this._rageSpecialAttackCumulatedDamage = this._rageSpecialAttackCumulatedDamage + damageInfo.alteredDamage;
			this._rageSpecialAttackRemainingHits--;
			if(this._rageSpecialAttackRemainingHits <= 0)
			{
				this.endHeroRageSpecialAttack();
			}
			dispatchEvent(new EventWithParams(CombatControllerEvents.HERO_RAGE_SP_ATTACK_HIT,{
				"hero":inCombatHeroStats,
				"target":this._currentEnemyStats,
				"damage":damageInfo
			}));
		}
		
		private function endHeroRageSpecialAttack() : void
		{
			logInfo("endHeroRageSpecialAttack");
			var inCombatHeroStats:InCombatHeroStats = this._currentRoundFighter as InCombatHeroStats;
			if(this._rageSpecialAttackCumulatedDamage > 0)
			{
				inCombatHeroStats.currentAggro = inCombatHeroStats.currentAggro + this._rageSpecialAttackCumulatedDamage * GameConstants.factorAggroRage;
				this._rageSpecialAttackCumulatedDamage = 0;
			}
		}
		
		private function executeHeroDareSpecialAttack() : void
		{
			var inCombatHeroStats:InCombatHeroStats = this._currentRoundFighter as InCombatHeroStats;
			logInfo("executeHeroDareSpecialAttack : " + inCombatHeroStats.fighterName);
			this._dareSpecialAttackRemainingHits = 1;
			inCombatHeroStats.basicHeroStats.useFocus(inCombatHeroStats.basicHeroStats.hero.specialAttack.focusCost);
			dispatchEvent(new EventWithParams(CombatControllerEvents.HERO_DARE_SP_ATTACK_START,{"hero":inCombatHeroStats}));
		}
		
		private function executeHeroDareSpecialAttackHit() : void
		{
			var otherInCombatHeroStats:InCombatHeroStats = null;
			logInfo("executeHeroRageSpecialAttackHit : " + this._currentRoundFighter.fighterName);
			var inCombatHeroStats:InCombatHeroStats = this._currentRoundFighter as InCombatHeroStats;
			var heroStats:HeroStats = inCombatHeroStats.basicHeroStats;
			var damageInfo:DamageInfo = this.damageEnemy(heroStats.currentMinMainAttackPower,heroStats.currentMaxMainAttackPower);
			this._dareSpecialAttackRemainingHits = 0;
			inCombatHeroStats.dare();
			inCombatHeroStats.currentAggro = GameConstants.aggroDareSelf;
			for(var i:int = 0; i < this._inCombatHeroesStats.length; i++)
			{
				otherInCombatHeroStats = this._inCombatHeroesStats[i];
				if(otherInCombatHeroStats != inCombatHeroStats)
				{
					otherInCombatHeroStats.currentAggro = Math.min(otherInCombatHeroStats.currentAggro,GameConstants.aggroInitial);
				}
			}
			dispatchEvent(new EventWithParams(CombatControllerEvents.HERO_DARE_SP_ATTACK_HIT,{
				"hero":inCombatHeroStats,
				"target":this._currentEnemyStats,
				"damage":damageInfo
			}));
		}
		
		private function executeHeroSalveSpecialAttack() : void
		{
			var otherInCombatHeroStats:InCombatHeroStats = null;
			var inCombatHeroStats:InCombatHeroStats = this._currentRoundFighter as InCombatHeroStats;
			logInfo("executeHeroSalveSpecialAttack : " + inCombatHeroStats.fighterName);
			for(var i:int = 0; i < this._inCombatHeroesStats.length; i++)
			{
				otherInCombatHeroStats = this._inCombatHeroesStats[i];
				if(otherInCombatHeroStats.currentHP > 0)
				{
					otherInCombatHeroStats.salve(GameConstants.atksSalveNum);
				}
			}
			inCombatHeroStats.basicHeroStats.useFocus(inCombatHeroStats.basicHeroStats.hero.specialAttack.focusCost);
			inCombatHeroStats.currentAggro = inCombatHeroStats.currentAggro * GameConstants.factorAggroSalve;
			dispatchEvent(new EventWithParams(CombatControllerEvents.HERO_SALVE_SP_ATTACK,{"hero":inCombatHeroStats}));
		}
		
		private function executeHeroSleepSpecialAttack() : void
		{
			var inCombatHeroStats:InCombatHeroStats = this._currentRoundFighter as InCombatHeroStats;
			logInfo("executeHeroSleepSpecialAttack : " + inCombatHeroStats.fighterName);
			this._currentEnemyStats.sleep(MathUtil.random(GameConstants.turnsSleepMin,GameConstants.turnsSleepMax));
			inCombatHeroStats.basicHeroStats.useFocus(inCombatHeroStats.basicHeroStats.hero.specialAttack.focusCost);
			inCombatHeroStats.currentAggro = inCombatHeroStats.currentAggro * GameConstants.factorAggroSleep;
			dispatchEvent(new EventWithParams(CombatControllerEvents.HERO_SLEEP_SP_ATTACK,{
				"hero":inCombatHeroStats,
				"target":this._currentEnemyStats
			}));
		}
		
		private function executeHeroDazeSpecialAttack() : void
		{
			var inCombatHeroStats:InCombatHeroStats = this._currentRoundFighter as InCombatHeroStats;
			logInfo("executeHeroDazeSpecialAttack : " + inCombatHeroStats.fighterName);
			this._dazeSpecialAttackRemainingHits = 1;
			this._currentEnemyStats.daze(MathUtil.random(GameConstants.turnsDazeMin,GameConstants.turnsDazeMax));
			inCombatHeroStats.basicHeroStats.useFocus(inCombatHeroStats.basicHeroStats.hero.specialAttack.focusCost);
			dispatchEvent(new EventWithParams(CombatControllerEvents.HERO_DAZE_SP_ATTACK_START,{"hero":inCombatHeroStats}));
		}
		
		private function executeHeroDazeSpecialAttackHit() : void
		{
			logInfo("executeHeroDazeSpecialAttackHit : " + this._currentRoundFighter.fighterName);
			var inCombatHeroStats:InCombatHeroStats = this._currentRoundFighter as InCombatHeroStats;
			var heroStats:HeroStats = inCombatHeroStats.basicHeroStats;
			var damageInfo:DamageInfo = this.damageEnemy(heroStats.currentMinMainAttackPower,heroStats.currentMaxMainAttackPower);
			this._dazeSpecialAttackRemainingHits = 0;
			inCombatHeroStats.currentAggro = inCombatHeroStats.currentAggro + damageInfo.alteredDamage * GameConstants.factorAggroDaze;
			dispatchEvent(new EventWithParams(CombatControllerEvents.HERO_DAZE_SP_ATTACK_HIT,{
				"hero":inCombatHeroStats,
				"target":this._currentEnemyStats,
				"damage":damageInfo
			}));
		}
		
		private function executeHeroRecovery() : void
		{
			logInfo("executeHeroRecovery : " + this._currentRoundFighter.fighterName);
			var inCombatHeroStats:InCombatHeroStats = this._currentRoundFighter as InCombatHeroStats;
			var recoveryValue:int = Math.ceil(GameConstants.percRecoverHP / 100 * inCombatHeroStats.basicHeroStats.currentMaxHP);
			recoveryValue = inCombatHeroStats.heal(recoveryValue);
			inCombatHeroStats.currentAggro = inCombatHeroStats.currentAggro * GameConstants.factorAggroRecover;
			this._awaitingActionForHero = false;
			dispatchEvent(new EventWithParams(CombatControllerEvents.HERO_RECOVERY,{
				"hero":inCombatHeroStats,
				"recovery":recoveryValue
			}));
		}
		
		private function executeHeroFlee() : void
		{
			var dispatchedEventName:String = null;
			logInfo("executeHeroFlee : " + this._currentRoundFighter.fighterName);
			var inCombatHeroStats:InCombatHeroStats = this._currentRoundFighter as InCombatHeroStats;
			if(this._currentEnemyStats.isSleeping || this.getRandomInitiativeValue(this._currentRoundFighter) > this.getRandomInitiativeValue(this._currentEnemyStats))
			{
				dispatchedEventName = CombatControllerEvents.HERO_FLEE;
				_eventEnded = true;
			}
			else
			{
				dispatchedEventName = CombatControllerEvents.HERO_FLEE_MISS;
				inCombatHeroStats.currentAggro = inCombatHeroStats.currentAggro * GameConstants.factorAggroFlee;
			}
			dispatchEvent(new EventWithParams(dispatchedEventName,{"hero":inCombatHeroStats}));
		}
		
		private function executeHeroMeditate() : void
		{
			logInfo("executeHeroMeditate : " + this._currentRoundFighter.fighterName);
			var inCombatHeroStats:InCombatHeroStats = this._currentRoundFighter as InCombatHeroStats;
			var focusRegen:int = inCombatHeroStats.basicHeroStats.gainFocus(GameConstants.focusMeditateRegen);
			inCombatHeroStats.meditate();
			inCombatHeroStats.currentAggro = inCombatHeroStats.currentAggro * GameConstants.factorAggroMeditate;
			dispatchEvent(new EventWithParams(CombatControllerEvents.HERO_MEDITATE,{
				"hero":inCombatHeroStats,
				"focusRegen":focusRegen
			}));
		}
		
		private function onCurrentEnemyDeath() : void
		{
			logInfo("onCurrentEnemyDeath : " + this._currentEnemyStats.fighterName);
			var enemyStats:InCombatEnemyStats = this._currentEnemyStats;
			this._currentEnemyStats = null;
			if(this._rageSpecialAttackRemainingHits > 0)
			{
				this._rageSpecialAttackRemainingHits = 0;
				this.endHeroRageSpecialAttack();
			}
			this._roundFightersQueue = new Vector.<IFighterStats>();
			dispatchEvent(new EventWithParams(CombatControllerEvents.ENEMY_DEATH,{"enemy":enemyStats}));
		}
		
		private function onHeroEndOfSalve(inCombatHeroStats:InCombatHeroStats) : void
		{
			logInfo("onHeroEndOfSalve : " + inCombatHeroStats.fighterName);
			inCombatHeroStats.unsalve();
			dispatchEvent(new EventWithParams(CombatControllerEvents.HERO_END_OF_SALVE,{"hero":inCombatHeroStats}));
		}
		
		private function onHeroEndOfDare(inCombatHeroStats:InCombatHeroStats) : void
		{
			logInfo("onHeroEndOfDare : " + inCombatHeroStats.fighterName);
			inCombatHeroStats.stopDaring();
			dispatchEvent(new EventWithParams(CombatControllerEvents.HERO_END_OF_DARE,{"hero":inCombatHeroStats}));
		}
		
		private function onHeroDeath(inCombatHeroStats:InCombatHeroStats) : void
		{
			logInfo("onHeroDeath : " + inCombatHeroStats.fighterName);
			dispatchEvent(new EventWithParams(CombatControllerEvents.HERO_DEATH,{"hero":inCombatHeroStats}));
		}
		
		private function onCombatWon() : void
		{
			logInfo("onCombatWon");
			_eventEnded = true;
			if(this._combatEvent.storyConditionTriggered != StoryConditionType.NONE)
			{
				GamePersistantData.setStoryCondition(this._combatEvent.storyConditionTriggered,true);
			}
			GamePersistantData.incrementCombatEventCounter(this._combatEvent);
			dispatchEvent(new EventWithParams(CombatControllerEvents.COMBAT_WON));
		}
		
		private function onCombatLost() : void
		{
			logInfo("onCombatLost");
			_eventEnded = true;
			dispatchEvent(new EventWithParams(CombatControllerEvents.COMBAT_LOST));
		}
		
		private function startNewRound() : void
		{
			var inCombatHeroStats:InCombatHeroStats = null;
			logInfo("startNewRound");
			this._roundFightersQueue = new Vector.<IFighterStats>();
			this._currentEnemyStats.currentInitiative = this.getRandomInitiativeValue(this._currentEnemyStats);
			this._roundFightersQueue.push(this._currentEnemyStats);
			for(var i:int = 0; i < this._inCombatHeroesStats.length; i++)
			{
				inCombatHeroStats = this._inCombatHeroesStats[i];
				if(inCombatHeroStats.currentHP > 0)
				{
					inCombatHeroStats.currentInitiative = this.getRandomInitiativeValue(inCombatHeroStats);
					this._roundFightersQueue.push(inCombatHeroStats);
				}
			}
			this._roundFightersQueue.sort(this.compareFightersBasedOnInitiative);
			this._roundStartedCount++;
			this._currentEnemyRoundCount++;
			this.logRoundFighters();
			dispatchEvent(new EventWithParams(CombatControllerEvents.ROUND_START,{"round":this._roundStartedCount}));
		}
		
		private function endRound() : void
		{
			var inCombatHeroStats:InCombatHeroStats = null;
			logInfo("endRound");
			for(var i:int = 0; i < this._inCombatHeroesStats.length; i++)
			{
				inCombatHeroStats = this._inCombatHeroesStats[i];
				if(inCombatHeroStats.currentHP > 0)
				{
					inCombatHeroStats.basicHeroStats.gainFocus(GameConstants.focusNaturalRegen);
				}
			}
			this._roundEndedCount++;
			dispatchEvent(new EventWithParams(CombatControllerEvents.ROUND_END));
		}
		
		private function damageHero(inCombatHero:InCombatHeroStats, minDamage:int, maxDamage:int) : DamageInfo
		{
			var meditatingAlteration:int = 0;
			var daringAlteration:int = 0;
			var damageInfo:DamageInfo = new DamageInfo(MathUtil.random(minDamage,maxDamage));
			if(inCombatHero.remainingSalve > 0)
			{
				damageInfo.setAlteration(DamageInfo.ALTERATION_SALVE,Math.max(0,Math.floor((1 - GameConstants.percSalveResist / 100) * damageInfo.damageDealt)));
			}
			if(inCombatHero.isMeditating)
			{
				meditatingAlteration = Math.max(0,Math.floor((1 - GameConstants.percMeditateResist / 100) * damageInfo.damageDealt));
				if(damageInfo.alterationType == DamageInfo.ALTERATION_NONE || damageInfo.alteredDamage >= meditatingAlteration)
				{
					damageInfo.setAlteration(DamageInfo.ALTERATION_MEDITATE,meditatingAlteration);
				}
			}
			if(inCombatHero.isDaring)
			{
				daringAlteration = Math.max(0,Math.floor((1 - GameConstants.percDareResist / 100) * damageInfo.damageDealt));
				if(damageInfo.alterationType == DamageInfo.ALTERATION_NONE || damageInfo.alteredDamage >= daringAlteration)
				{
					damageInfo.setAlteration(DamageInfo.ALTERATION_DARE,daringAlteration);
				}
			}
			if(damageInfo.alterationType == DamageInfo.ALTERATION_SALVE)
			{
				inCombatHero.decrementSalve();
			}
			inCombatHero.damage(damageInfo.alteredDamage);
			return damageInfo;
		}
		
		private function damageEnemy(minDamage:int, maxDamage:int) : DamageInfo
		{
			var damageInfo:DamageInfo = new DamageInfo(MathUtil.random(minDamage,maxDamage));
			var inCombatHeroStats:InCombatHeroStats = this._currentRoundFighter as InCombatHeroStats;
			if(this._currentEnemyStats.isSleeping)
			{
				damageInfo.setAlteration(DamageInfo.ALTERATION_SLEEP,Math.ceil(GameConstants.factorSleepDmg * maxDamage));
				this._currentEnemyStats.clearSleep();
			}
			else if(this._currentEnemyStats.isDazed)
			{
				damageInfo.setAlteration(DamageInfo.ALTERATION_DAZE,damageInfo.damageDealt + MathUtil.random(GameConstants.dmgDazeMin,GameConstants.dmgDazeMax) + inCombatHeroStats.basicHeroStats.additionalMainAttackPower / GameConstants.atkPwrDazeRatio);
			}
			this._currentEnemyStats.damage(damageInfo.alteredDamage);
			return damageInfo;
		}
		
		private function checkCurrentHeroForEndOfDare() : Boolean
		{
			var hero:InCombatHeroStats = null;
			if(this._currentRoundFighter == null)
			{
				return false;
			}
			var currentHero:InCombatHeroStats = this._currentRoundFighter as InCombatHeroStats;
			if(currentHero == null || currentHero.isDead || !currentHero.isDaring)
			{
				return false;
			}
			var totalAggro:Number = 0;
			var dareLimitRatio:Number = GameConstants.percDareLimit / 100;
			for(var i:int = 0; i < this._inCombatHeroesStats.length; i++)
			{
				hero = this._inCombatHeroesStats[i];
				if(!hero.isDead)
				{
					totalAggro = totalAggro + hero.currentAggro;
				}
			}
			return currentHero.currentAggro / totalAggro < dareLimitRatio;
		}
		
		private function getEnemyMainAttackTarget() : InCombatHeroStats
		{
			var target:InCombatHeroStats = null;
			var totalAggro:Number = 0;
			var cumulatedAggro:Number = 0;
			var eligibleTargets:Vector.<InCombatHeroStats> = new Vector.<InCombatHeroStats>();
			for(var i:int = 0; i < this._inCombatHeroesStats.length; i++)
			{
				target = this._inCombatHeroesStats[i];
				if(!target.isDead)
				{
					eligibleTargets.push(target);
					totalAggro = totalAggro + target.currentAggro;
				}
			}
			if(eligibleTargets.length == 0)
			{
				return null;
			}
			if(eligibleTargets.length == 1)
			{
				return eligibleTargets[0];
			}
			var randomCumulatedAggro:Number = Math.random() * totalAggro;
			for(var j:int = 0; j < eligibleTargets.length - 1; j++)
			{
				cumulatedAggro = cumulatedAggro + eligibleTargets[j].currentAggro;
				if(randomCumulatedAggro <= cumulatedAggro)
				{
					return eligibleTargets[j];
				}
			}
			return eligibleTargets[eligibleTargets.length - 1];
		}
		
		private function setNextEnemyAsCurrent() : void
		{
			logInfo("setNextEnemyAsCurrent");
			this._currentEnemyStats = new InCombatEnemyStats(this._enemiesQueue.shift());
			this._currentEnemyRoundCount = 0;
			dispatchEvent(new EventWithParams(CombatControllerEvents.NEW_ENEMY,{"enemy":this._currentEnemyStats}));
		}
		
		private function getRandomInitiativeValue(fighter:IFighterStats) : Number
		{
			var minInitiative:Number = fighter.currentBaseInitiative - GameConstants.initLowerBound;
			var maxInitiative:Number = fighter.currentBaseInitiative + GameConstants.initUpperBound;
			return minInitiative + Math.random() * (maxInitiative - minInitiative);
		}
		
		private function hasNextEnemy() : Boolean
		{
			return this._enemiesQueue.length > 0;
		}
		
		private function compareFightersBasedOnInitiative(f1:IFighterStats, f2:IFighterStats) : int
		{
			return f2.currentInitiative - f1.currentInitiative;
		}
		
		override public function dispose() : void
		{
			this._combatEvent = null;
			this._inCombatHeroesStats = null;
			this._currentEnemyStats = null;
			this._enemiesQueue = null;
			this._roundFightersQueue = null;
			this._currentRoundFighter = null;
		}
		
		public function logFightersInfo() : void
		{
			var inCombatHeroStats:InCombatHeroStats = null;
			var i:int = 0;
			trace("\n");
			logInfo(this.pad("",20) + this.pad("HP",8) + this.pad("XHP",8) + this.pad("INIT",8) + this.pad("AGGRO",8) + this.pad("FOC",8) + this.pad("XFOC",8) + this.pad("SALVE",8) + this.pad("DARE",8) + this.pad("SLEEP",8) + this.pad("DAZE",8));
			if(this._currentEnemyStats != null)
			{
				logInfo(this.pad(this._currentEnemyStats.fighterName,20) + this.pad(this._currentEnemyStats.currentHP.toString(),8) + this.pad(this._currentEnemyStats.enemy.initialMaxHP.toString(),8) + this.pad(this._currentEnemyStats.currentInitiative.toFixed(2),8) + this.pad("-",8) + this.pad("-",8) + this.pad("-",8) + this.pad("-",8) + this.pad("-",8) + this.pad(!!this._currentEnemyStats.isSleeping?"Y/" + this._currentEnemyStats.remainingSleep:"N",8) + this.pad(!!this._currentEnemyStats.isDazed?"Y/" + this._currentEnemyStats.remainingDaze:"N",8));
			}
			for(i = 0; i < this._inCombatHeroesStats.length; i++)
			{
				inCombatHeroStats = this._inCombatHeroesStats[i];
				logInfo(this.pad(inCombatHeroStats.fighterName,20) + this.pad(inCombatHeroStats.currentHP.toString(),8) + this.pad(inCombatHeroStats.basicHeroStats.currentMaxHP.toString(),8) + this.pad(inCombatHeroStats.currentInitiative.toFixed(2),8) + this.pad(inCombatHeroStats.currentAggro.toFixed(2),8) + this.pad(inCombatHeroStats.currentFocus.toString(),8) + this.pad(inCombatHeroStats.basicHeroStats.currentMaxFocus.toString(),8) + this.pad(!!inCombatHeroStats.isSalved?"Y/" + inCombatHeroStats.remainingSalve:"N",8) + this.pad(!!inCombatHeroStats.isDaring?"Y":"N",8) + this.pad("-",8) + this.pad("-",8));
			}
			trace("\n");
		}
		
		private function logRoundFighters() : void
		{
			var fighter:IFighterStats = null;
			var roundFighterStrs:Vector.<String> = null;
			var i:int = 0;
			roundFighterStrs = new Vector.<String>();
			for(i = 0; i < this._roundFightersQueue.length; i++)
			{
				fighter = this._roundFightersQueue[i];
				if(fighter is InCombatHeroStats)
				{
					roundFighterStrs.push(fighter.fighterName + " (" + fighter.currentInitiative.toFixed(2) + " i," + fighter.currentHP + " hp, " + (fighter as InCombatHeroStats).currentAggro.toFixed(2) + " ag)");
				}
				else
				{
					roundFighterStrs.push(fighter.fighterName + " (" + fighter.currentInitiative.toFixed(2) + " i," + fighter.currentHP + " hp)");
				}
			}
			logInfo("Fighter order : " + roundFighterStrs.join(", "));
		}
		
		private function pad(value:String, length:uint) : String
		{
			for(var s:String = value; s.length < length; )
			{
				s = s + " ";
			}
			return s;
		}
	}
}
