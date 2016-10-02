package bhvr.data.database
{
	public class Item extends BaseItem
	{
		 
		
		public var hpBoost:uint;
		
		public var maxHpBoost:uint;
		
		public var focusBoost:uint;
		
		public var maxFocusBoost:uint;
		
		public var baseInitiativeBoost:uint;
		
		public var attackPowerBoost:uint;
		
		public var boostsApplyToWholeParty:Boolean;
		
		public function Item()
		{
			super();
			this.boostsApplyToWholeParty = false;
		}
		
		public function get hasBoost() : Boolean
		{
			return this.hasBoostToUnlimitedStat || this.hasBoostToLimitedStat;
		}
		
		public function get hasBoostToUnlimitedStat() : Boolean
		{
			return this.attackPowerBoost > 0 || this.baseInitiativeBoost > 0 || this.maxFocusBoost > 0 || this.maxHpBoost > 0;
		}
		
		public function get hasBoostToLimitedStat() : Boolean
		{
			return this.focusBoost > 0 || this.hpBoost > 0;
		}
	}
}
