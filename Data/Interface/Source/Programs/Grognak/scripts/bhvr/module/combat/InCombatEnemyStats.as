package bhvr.module.combat
{
	import bhvr.interfaces.IFighterStats;
	import bhvr.data.database.Enemy;
	
	public class InCombatEnemyStats implements IFighterStats
	{
		 
		
		private var _enemy:Enemy;
		
		private var _currentHP:int;
		
		private var _currentInitiative:Number;
		
		private var _remainingSleep:int;
		
		private var _remainingDaze:int;
		
		public function InCombatEnemyStats(enemy:Enemy)
		{
			super();
			this._enemy = enemy;
			this._currentHP = this._enemy.initialMaxHP;
			this._remainingSleep = -1;
			this._remainingDaze = -1;
		}
		
		public function get fighterName() : String
		{
			return this._enemy.mainName;
		}
		
		public function get enemy() : Enemy
		{
			return this._enemy;
		}
		
		public function get currentHP() : int
		{
			return this._currentHP;
		}
		
		public function get currentBaseInitiative() : int
		{
			return this._enemy.initialBaseInitiative;
		}
		
		public function get currentInitiative() : Number
		{
			return this._currentInitiative;
		}
		
		public function set currentInitiative(value:Number) : void
		{
			this._currentInitiative = value;
		}
		
		public function get isSleeping() : Boolean
		{
			return this._remainingSleep >= 0;
		}
		
		public function get remainingSleep() : int
		{
			return this._remainingSleep;
		}
		
		public function get isDazed() : Boolean
		{
			return this._remainingDaze >= 0;
		}
		
		public function get remainingDaze() : int
		{
			return this._remainingDaze;
		}
		
		public function sleep(value:int) : void
		{
			this._remainingSleep = value;
		}
		
		public function decrementSleep() : void
		{
			if(this._remainingSleep > 0)
			{
				this._remainingSleep--;
			}
		}
		
		public function clearSleep() : void
		{
			if(this._remainingSleep > 0)
			{
				this._remainingSleep = 0;
			}
		}
		
		public function wakeup() : void
		{
			this._remainingSleep = -1;
		}
		
		public function daze(value:int) : void
		{
			this._remainingDaze = value;
		}
		
		public function decrementDaze() : void
		{
			if(this._remainingDaze > 0)
			{
				this._remainingDaze--;
			}
		}
		
		public function undaze() : void
		{
			this._remainingDaze = -1;
		}
		
		public function damage(value:int) : int
		{
			var realValue:int = Math.min(this.currentHP,value);
			this._currentHP = this._currentHP - realValue;
			return realValue;
		}
	}
}
