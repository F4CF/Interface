package bhvr.data.database.creators
{
	import bhvr.data.database.creators.bases.BaseHeroDataCreator;
	import bhvr.data.database.Hero;
	import bhvr.data.assets.CombatVfxSymbols;
	import bhvr.data.SoundList;
	import bhvr.module.combat.HeroSpecialAttacks;
	import bhvr.data.assets.PortraitSymbols;
	import flash.utils.Dictionary;
	
	public class HeroDataCreator extends BaseHeroDataCreator
	{
		 
		
		public function HeroDataCreator(sharedData:Dictionary)
		{
			super(sharedData);
		}
		
		override public function createData() : void
		{
			var hero1:Hero = createHero();
			hero1.fullName = "Grognak";
			hero1.mainName = "Grognak";
			hero1.isMandatoryPartyMember = true;
			hero1.isMale = true;
			hero1.attackVFX = CombatVfxSymbols.GROGNAK;
			hero1.attackSFX = SoundList.SOUND_COMBAT_GROGNAK_ATTACK;
			hero1.specialAttackSFX = SoundList.SOUND_COMBAT_GROGNAK_SPECIAL_ATTACK;
			hero1.initialMaxHP = 60;
			hero1.initialBaseInitiative = 12;
			hero1.initialMaxFocus = 10;
			hero1.initialMinMainAttackPower = 7;
			hero1.initialMaxMainAttackPower = 17;
			hero1.specialAttack = getHeroSpecialAttack(HeroSpecialAttacks.RAGE);
			var hero2:Hero = createHero();
			hero2.fullName = "Maula";
			hero2.mainName = "Maula";
			hero2.portrait = PortraitSymbols.HERO_MAULA;
			hero2.isMale = false;
			hero2.attackVFX = CombatVfxSymbols.MAULA;
			hero2.attackSFX = SoundList.SOUND_COMBAT_MAULA_ATTACK;
			hero2.specialAttackSFX = SoundList.SOUND_COMBAT_MAULA_SPECIAL_ATTACK;
			hero2.initialMaxHP = 48;
			hero2.initialBaseInitiative = 14;
			hero2.initialMaxFocus = 20;
			hero2.initialMinMainAttackPower = 8;
			hero2.initialMaxMainAttackPower = 14;
			hero2.specialAttack = getHeroSpecialAttack(HeroSpecialAttacks.DARE);
			hero2.strangerSentence = "You dare patronize me? You know full well who I am - Maula, War-Maiden of Mars! I\'ll draw enemy attacks and help you against Grelok, but this doesn\'t make us friends.\n\nHP: 48     Damage: 8-14\nFocus: 20  Initiative: 14";
			hero2.acceptedInPartySentence = "Let us talk now of strategy. If you flank left when I go right, we can- Grognak, are you listening?! By the stars, why do I even bother? You\'ll just charge in regardless...";
			hero2.refusedInPartySentence = "As you wish, Grognak, but the loss is truly yours. Perhaps it is time for me to leave this accursed world, and return home to Mars... and a more hospitable clime!";
			var hero3:Hero = createHero();
			hero3.fullName = "Bloppo";
			hero3.mainName = "Bloppo";
			hero3.portrait = PortraitSymbols.HERO_BLOPPO;
			hero3.isMale = true;
			hero3.attackVFX = CombatVfxSymbols.BLOPPO;
			hero3.attackSFX = SoundList.SOUND_COMBAT_BLOPPO_ATTACK;
			hero3.specialAttackSFX = SoundList.SOUND_COMBAT_BLOPPO_SPECIAL_ATTACK;
			hero3.initialMaxHP = 36;
			hero3.initialBaseInitiative = 20;
			hero3.initialMaxFocus = 20;
			hero3.initialMinMainAttackPower = 9;
			hero3.initialMaxMainAttackPower = 11;
			hero3.specialAttack = getHeroSpecialAttack(HeroSpecialAttacks.DAZE);
			hero3.strangerSentence = "A quest, you say? With treasure? I\'m your man as long as the gold keeps flowing. In return, I\'ll make sure enemies are wide open to attacks.\n\nHP: 36     Damage: 9-11\nFocus: 20  Initiative: 20";
			hero3.acceptedInPartySentence = "Good. Now about my share. In case of death, send it to the Lochwall Orphanage. Yes, really. Those little tykes depend on their \"Uncle Poppo.\"";
			hero3.refusedInPartySentence = "Really? Did I come off as too greedy? I\'m sorry, I just like to meet expectations. People don\'t generally want a philanthropic thief.";
			var hero4:Hero = createHero();
			hero4.fullName = "Swift";
			hero4.mainName = "Swift";
			hero4.portrait = PortraitSymbols.HERO_SWIFT;
			hero4.isMale = true;
			hero4.attackVFX = CombatVfxSymbols.SWIFT;
			hero4.attackSFX = SoundList.SOUND_COMBAT_SWIFT_ATTACK;
			hero4.specialAttackSFX = SoundList.SOUND_COMBAT_SWIFT_SPECIAL_ATTACK;
			hero4.initialMaxHP = 40;
			hero4.initialBaseInitiative = 8;
			hero4.initialMaxFocus = 30;
			hero4.initialMinMainAttackPower = 5;
			hero4.initialMaxMainAttackPower = 11;
			hero4.specialAttack = getHeroSpecialAttack(HeroSpecialAttacks.SALVE);
			hero4.strangerSentence = "Like I have a choice. Mother said to get off my behind and quest, so quest I must. At least my Elven salves will protect us from harm.\n\nHP: 40     Damage: 5-11\nFocus: 30  Initiative: 8";
			hero4.acceptedInPartySentence = "Will this quest provide time for leisure? Gambling? Wine? Revelry of any sort? No? Great, just great...";
			hero4.refusedInPartySentence = "Oh, thank the ancestors! No offense, but this Grelok sounds dangerous. Better I stick to killing rats in cellars or something.";
			var hero5:Hero = createHero();
			hero5.fullName = "Zaxtar";
			hero5.mainName = "Zaxtar";
			hero5.portrait = PortraitSymbols.HERO_ZAXTAR;
			hero5.isMale = true;
			hero5.attackVFX = CombatVfxSymbols.ZAXTAR;
			hero5.attackSFX = SoundList.SOUND_COMBAT_ZAXTAR_ATTACK;
			hero5.specialAttackSFX = SoundList.SOUND_COMBAT_ZAXTAR_SPECIAL_ATTACK;
			hero5.initialMaxHP = 34;
			hero5.initialBaseInitiative = 10;
			hero5.initialMaxFocus = 40;
			hero5.initialMinMainAttackPower = 5;
			hero5.initialMaxMainAttackPower = 9;
			hero5.specialAttack = getHeroSpecialAttack(HeroSpecialAttacks.SLEEP);
			hero5.strangerSentence = "The powers of the cosmos are at my command! This Grelok? Complete fraud. Parlor tricks and mirrors. So to keep things challenging I\'ll limit myself to putting enemies to sleep.\n\nHP: 34     Damage: 5-9\nFocus: 40  Initiative: 10";
			hero5.acceptedInPartySentence = "I have one rule, though. Don\'t EVER interrupt me while I am clearly manipulating the fabric of reality... and not just mumbling to myself.";
			hero5.refusedInPartySentence = "As my divinations predicted! Which is why I left my Staff of Instant Victory at home. It weighs a ton - no point lugging it around for nothing.";
		}
	}
}
