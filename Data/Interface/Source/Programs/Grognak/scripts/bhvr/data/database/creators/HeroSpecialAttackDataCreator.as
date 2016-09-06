package bhvr.data.database.creators
{
	import bhvr.data.database.creators.bases.BaseHeroSpecialAttackDataCreator;
	import bhvr.module.combat.HeroSpecialAttacks;
	import bhvr.data.database.HeroSpecialAttack;
	import flash.utils.Dictionary;
	
	public class HeroSpecialAttackDataCreator extends BaseHeroSpecialAttackDataCreator
	{
		 
		
		public function HeroSpecialAttackDataCreator(sharedData:Dictionary)
		{
			super(sharedData);
		}
		
		override public function createData() : void
		{
			var rage:HeroSpecialAttack = createHeroSpecialAttack(HeroSpecialAttacks.RAGE);
			rage.name = "Furious Rage";
			rage.focusCost = 6;
			var daze:HeroSpecialAttack = createHeroSpecialAttack(HeroSpecialAttacks.DAZE);
			daze.name = "Dazing Strike";
			daze.focusCost = 10;
			var dare:HeroSpecialAttack = createHeroSpecialAttack(HeroSpecialAttacks.DARE);
			dare.name = "Aegis Stance";
			dare.focusCost = 10;
			var protect:HeroSpecialAttack = createHeroSpecialAttack(HeroSpecialAttacks.SALVE);
			protect.name = "Ironskin Salve";
			protect.focusCost = 10;
			var sleep:HeroSpecialAttack = createHeroSpecialAttack(HeroSpecialAttacks.SLEEP);
			sleep.name = "Sleep Spell";
			sleep.focusCost = 10;
		}
	}
}
