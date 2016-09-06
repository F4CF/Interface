package bhvr.module.combat
{
	import bhvr.data.database.Hero;
	
	public class HeroStats
	{
		 
		
		private var _hero:Hero;
		
		private var _currentHP:int;
		
		private var _currentFocus:int;
		
		private var _additionalMaxHP:int;
		
		private var _additionalBaseInitiative:int;
		
		private var _additionalMaxFocus:int;
		
		private var _additionalMainAttackPower:int;
		
		public function HeroStats(hero:Hero)
		{
			super();
			this._hero = hero;
			this._currentHP = this._hero.initialMaxHP;
			this._currentFocus = this._hero.initialMaxFocus;
		}
		
		public function get hero() : Hero
		{
			return this._hero;
		}
		
		public function get isDead() : Boolean
		{
			return this._currentHP <= 0;
		}
		
		public function get currentHP() : int
		{
			return this._currentHP;
		}
		
		public function get currentMaxHP() : int
		{
			return this._hero.initialMaxHP + this._additionalMaxHP;
		}
		
		public function get currentBaseInitiative() : int
		{
			return this._hero.initialBaseInitiative + this._additionalBaseInitiative;
		}
		
		public function get currentFocus() : int
		{
			return this._currentFocus;
		}
		
		public function get currentMaxFocus() : int
		{
			return this._hero.initialMaxFocus + this._additionalMaxFocus;
		}
		
		public function get currentMinMainAttackPower() : int
		{
			return this._hero.initialMinMainAttackPower + this._additionalMainAttackPower;
		}
		
		public function get currentMaxMainAttackPower() : int
		{
			return this._hero.initialMaxMainAttackPower + this._additionalMainAttackPower;
		}
		
		public function get additionalMaxHP() : int
		{
			return this._additionalMaxHP;
		}
		
		public function get additionalMaxFocus() : int
		{
			return this._additionalMaxFocus;
		}
		
		public function get additionalBaseInitiative() : int
		{
			return this._additionalBaseInitiative;
		}
		
		public function get additionalMainAttackPower() : int
		{
			return this._additionalMainAttackPower;
		}
		
		public function damage(value:int) : int
		{
			var realValue:int = Math.min(this.currentHP,value);
			this._currentHP = this._currentHP - realValue;
			return realValue;
		}
		
		public function heal(value:int) : int
		{
			var realValue:int = Math.min(this.currentMaxHP - this.currentHP,value);
			this._currentHP = this._currentHP + realValue;
			return realValue;
		}
		
		public function fullHeal() : int
		{
			return this.heal(this.currentMaxHP - this.currentHP);
		}
		
		public function gainFocus(value:int) : int
		{
			var realValue:int = Math.min(this.currentMaxFocus - this.currentFocus,value);
			this._currentFocus = this._currentFocus + realValue;
			return realValue;
		}
		
		public function useFocus(value:int) : Boolean
		{
			if(this.hasEnoughFocus(value))
			{
				this._currentFocus = this._currentFocus - value;
				return true;
			}
			return false;
		}
		
		public function hasEnoughFocus(value:int) : Boolean
		{
			return value <= this._currentFocus;
		}
		
		public function addMaxHP(value:int) : void
		{
			this._additionalMaxHP = this._additionalMaxHP + value;
		}
		
		public function addBaseInitiative(value:int) : void
		{
			this._additionalBaseInitiative = this._additionalBaseInitiative + value;
		}
		
		public function addMaxFocus(value:int) : void
		{
			this._additionalMaxFocus = this._additionalMaxFocus + value;
		}
		
		public function addMainAttackPower(value:int) : void
		{
			this._additionalMainAttackPower = this._additionalMainAttackPower + value;
		}
		
		public function copy() : HeroStats
		{
			var result:HeroStats = new HeroStats(this._hero);
			result._currentHP = this._currentHP;
			result._currentFocus = this._currentFocus;
			result._additionalMaxHP = this._additionalMaxHP;
			result._additionalBaseInitiative = this._additionalBaseInitiative;
			result._additionalMaxFocus = this._additionalMaxFocus;
			result._additionalMainAttackPower = this._additionalMainAttackPower;
			return result;
		}
		
		public function restore(from:HeroStats) : void
		{
			this._currentHP = from._currentHP;
			this._currentFocus = from._currentFocus;
			this._additionalMaxHP = from._additionalMaxHP;
			this._additionalBaseInitiative = from._additionalBaseInitiative;
			this._additionalMaxFocus = from._additionalMaxFocus;
			this._additionalMainAttackPower = from._additionalMainAttackPower;
		}
	}
}
