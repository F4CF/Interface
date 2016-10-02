package bhvr.module.combat
{
	import bhvr.interfaces.IFighterStats;
	import bhvr.constants.GameConstants;
	
	public class InCombatHeroStats implements IFighterStats
	{
		 
		
		private var _basicHeroStats:bhvr.module.combat.HeroStats;
		
		private var _currentInitiative:Number;
		
		private var _currentAggro:Number;
		
		private var _remainingSalve:int;
		
		private var _isMeditating:Boolean;
		
		private var _isDaring:Boolean;
		
		public function InCombatHeroStats(basicHeroStats:bhvr.module.combat.HeroStats)
		{
			super();
			this._basicHeroStats = basicHeroStats;
			this._currentAggro = GameConstants.aggroInitial;
			this._remainingSalve = -1;
			this._isMeditating = false;
			this._isDaring = false;
		}
		
		public function get fighterName() : String
		{
			return this._basicHeroStats.hero.mainName;
		}
		
		public function get basicHeroStats() : bhvr.module.combat.HeroStats
		{
			return this._basicHeroStats;
		}
		
		public function get currentHP() : int
		{
			return this._basicHeroStats.currentHP;
		}
		
		public function get currentFocus() : int
		{
			return this._basicHeroStats.currentFocus;
		}
		
		public function get isDead() : Boolean
		{
			return this._basicHeroStats.isDead;
		}
		
		public function get currentBaseInitiative() : int
		{
			return this._basicHeroStats.currentBaseInitiative;
		}
		
		public function get currentInitiative() : Number
		{
			return this._currentInitiative;
		}
		
		public function set currentInitiative(value:Number) : void
		{
			this._currentInitiative = value;
		}
		
		public function get currentAggro() : Number
		{
			return this._basicHeroStats.currentHP > 0?Number(this._currentAggro):Number(0);
		}
		
		public function set currentAggro(value:Number) : void
		{
			this._currentAggro = value;
		}
		
		public function get isSalved() : Boolean
		{
			return this._remainingSalve >= 0;
		}
		
		public function get remainingSalve() : int
		{
			return this._remainingSalve;
		}
		
		public function get isMeditating() : Boolean
		{
			return this._isMeditating;
		}
		
		public function get isDaring() : Boolean
		{
			return this._isDaring;
		}
		
		public function salve(value:int) : void
		{
			this._remainingSalve = value;
		}
		
		public function decrementSalve() : void
		{
			if(this._remainingSalve > 0)
			{
				this._remainingSalve--;
			}
		}
		
		public function unsalve() : void
		{
			this._remainingSalve = -1;
		}
		
		public function meditate() : void
		{
			this._isMeditating = true;
		}
		
		public function stopMeditation() : void
		{
			this._isMeditating = false;
		}
		
		public function dare() : void
		{
			this._isDaring = true;
		}
		
		public function stopDaring() : void
		{
			this._isDaring = false;
		}
		
		public function damage(value:int) : int
		{
			return this._basicHeroStats.damage(value);
		}
		
		public function heal(value:int) : int
		{
			return this._basicHeroStats.heal(value);
		}
	}
}
