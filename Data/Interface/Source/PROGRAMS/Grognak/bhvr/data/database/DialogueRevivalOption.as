package bhvr.data.database
{
	import bhvr.module.combat.HeroStats;
	
	public class DialogueRevivalOption extends DialogueOption
	{
		 
		
		private var _hero:HeroStats;
		
		public function DialogueRevivalOption(heroStats:HeroStats)
		{
			super(heroStats.hero.mainName);
			this._hero = heroStats;
		}
		
		public function get hero() : HeroStats
		{
			return this._hero;
		}
	}
}
