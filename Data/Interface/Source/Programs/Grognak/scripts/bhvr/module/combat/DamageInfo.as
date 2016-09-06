package bhvr.module.combat
{
	public class DamageInfo
	{
		
		public static const ALTERATION_NONE:int = 0;
		
		public static const ALTERATION_SALVE:int = 1;
		
		public static const ALTERATION_SLEEP:int = 2;
		
		public static const ALTERATION_DAZE:int = 3;
		
		public static const ALTERATION_DARE:int = 4;
		
		public static const ALTERATION_MEDITATE:int = 5;
		 
		
		private var _damageDealt:int;
		
		private var _alteredDamage:int;
		
		private var _alterationType:int;
		
		public function DamageInfo(damageDealt:int)
		{
			super();
			this._damageDealt = damageDealt;
			this._alteredDamage = damageDealt;
			this._alterationType = ALTERATION_NONE;
		}
		
		public function get damageDealt() : int
		{
			return this._damageDealt;
		}
		
		public function get alteredDamage() : int
		{
			return this._alteredDamage;
		}
		
		public function get alterationType() : int
		{
			return this._alterationType;
		}
		
		public function setAlteration(alterationType:int, alteredDamage:int) : void
		{
			this._alterationType = alterationType;
			this._alteredDamage = alteredDamage;
		}
	}
}
