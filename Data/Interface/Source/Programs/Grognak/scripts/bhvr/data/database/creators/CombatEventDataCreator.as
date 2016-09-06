package bhvr.data.database.creators
{
	import bhvr.data.database.creators.bases.BaseCombatEventDataCreator;
	import bhvr.data.database.CombatEvent;
	import bhvr.data.StoryConditionType;
	import bhvr.data.SoundList;
	import flash.utils.Dictionary;
	
	public class CombatEventDataCreator extends BaseCombatEventDataCreator
	{
		 
		
		public function CombatEventDataCreator(sharedData:Dictionary)
		{
			super(sharedData);
		}
		
		override public function createData() : void
		{
			var GoblinCaveBattle:CombatEvent = createCombatEvent("GoblinCaveBattle");
			GoblinCaveBattle.rewardEvent = getRewardEvent("GoblinCaveReward");
			addEnemiesToCombatEvent(GoblinCaveBattle,"Goblin","Goblin","Goblin");
			var ForgottenCloisterBattle:CombatEvent = createCombatEvent("ForgottenCloisterBattle");
			ForgottenCloisterBattle.rewardEvent = getRewardEvent("ForgottenCloisterReward");
			addEnemiesToCombatEvent(ForgottenCloisterBattle,"Sasquatch");
			var GarrisonOfSavagesBattle:CombatEvent = createCombatEvent("GarrisonOfSavagesBattle");
			GarrisonOfSavagesBattle.rewardEvent = getRewardEvent("GarrisonOfSavagesReward");
			addEnemiesToCombatEvent(GarrisonOfSavagesBattle,"Goblin","Goblin","Orc","GoblinShaman");
			var ValkyrianTombBattle:CombatEvent = createCombatEvent("ValkyrianTombBattle");
			ValkyrianTombBattle.rewardEvent = getRewardEvent("ValkyrianTombReward");
			addEnemiesToCombatEvent(ValkyrianTombBattle,"Ghost","Ghost","OrcDiabolist");
			var GoblinVillageBattle:CombatEvent = createCombatEvent("GoblinVillageBattle");
			GoblinVillageBattle.rewardEvent = getRewardEvent("GoblinVillageReward");
			addEnemiesToCombatEvent(GoblinVillageBattle,"Goblin","GoblinShaman","Goblin","GoblinShaman","GoblinWarchief");
			var MuddyCrabDenBattle:CombatEvent = createCombatEvent("MuddyCrabDenBattle");
			MuddyCrabDenBattle.rewardEvent = getRewardEvent("MuddyCrabDenReward");
			addEnemiesToCombatEvent(MuddyCrabDenBattle,"DireCrab","DireCrab","DireCrab");
			var BandOfGoblinoidsBattle:CombatEvent = createCombatEvent("BandOfGoblinoidsBattle");
			BandOfGoblinoidsBattle.rewardEvent = getRewardEvent("BandOfGoblinoidsReward");
			addEnemiesToCombatEvent(BandOfGoblinoidsBattle,"Goblin","GoblinShaman","Orc","GoblinWarchief");
			var OutcastsRefugeBattle:CombatEvent = createCombatEvent("OutcastsRefugeBattle");
			OutcastsRefugeBattle.rewardEvent = getRewardEvent("OutcastsRefugeReward");
			addEnemiesToCombatEvent(OutcastsRefugeBattle,"Orc","GoblinShaman","Sasquatch");
			var CoatlsShrineBattle:CombatEvent = createCombatEvent("CoatlsShrineBattle");
			CoatlsShrineBattle.rewardEvent = getRewardEvent("CoatlsShrineReward");
			addEnemiesToCombatEvent(CoatlsShrineBattle,"JewelSnake","JewelSnake");
			var AbandonedFortressBattle:CombatEvent = createCombatEvent("AbandonedFortressBattle");
			AbandonedFortressBattle.rewardEvent = getRewardEvent("AbandonedFortressReward");
			addEnemiesToCombatEvent(AbandonedFortressBattle,"DireCrab","Sasquatch","DireCrab","Sasquatch");
			var OrcVillageBattle:CombatEvent = createCombatEvent("OrcVillageBattle");
			OrcVillageBattle.rewardEvent = getRewardEvent("OrcVillageReward");
			addEnemiesToCombatEvent(OrcVillageBattle,"Orc","OrcDiabolist","OrcWarlord");
			var LighthouseBattle:CombatEvent = createCombatEvent("LighthouseBattle");
			LighthouseBattle.rewardEvent = getRewardEvent("LighthouseReward");
			LighthouseBattle.storyConditionTriggered = StoryConditionType.LIGHTHOUSE_ON;
			addEnemiesToCombatEvent(LighthouseBattle,"Wraith");
			var AssassinsStrongholdBattle:CombatEvent = createCombatEvent("AssassinsStrongholdBattle");
			AssassinsStrongholdBattle.rewardEvent = getRewardEvent("AssassinsStrongholdReward");
			addEnemiesToCombatEvent(AssassinsStrongholdBattle,"DarkElf","DarkElf");
			var FrostcapCavernBattle:CombatEvent = createCombatEvent("FrostcapCavernBattle");
			FrostcapCavernBattle.rewardEvent = getRewardEvent("FrostcapCavernReward");
			addEnemiesToCombatEvent(FrostcapCavernBattle,"Yeti");
			var UnholySanctuaryBattle:CombatEvent = createCombatEvent("UnholySanctuaryBattle");
			UnholySanctuaryBattle.rewardEvent = getRewardEvent("UnholySanctuaryReward");
			addEnemiesToCombatEvent(UnholySanctuaryBattle,"GoblinShaman","GoblinWarchief","Naga");
			var RavagedAntColonyBattle:CombatEvent = createCombatEvent("RavagedAntColonyBattle");
			RavagedAntColonyBattle.rewardEvent = getRewardEvent("RavagedAntColonyReward");
			addEnemiesToCombatEvent(RavagedAntColonyBattle,"Drider");
			var SearingGrottoBattle:CombatEvent = createCombatEvent("SearingGrottoBattle");
			SearingGrottoBattle.rewardEvent = getRewardEvent("SearingGrottoReward");
			addEnemiesToCombatEvent(SearingGrottoBattle,"FlameclawCrab","DireCrab","FlameclawCrab");
			var SlitheringAcropolisBattle:CombatEvent = createCombatEvent("SlitheringAcropolisBattle");
			SlitheringAcropolisBattle.rewardEvent = getRewardEvent("SlitheringAcropolisReward");
			addEnemiesToCombatEvent(SlitheringAcropolisBattle,"JewelSnake","JewelSnake","Naga");
			var BandOfDarkElvesBattle:CombatEvent = createCombatEvent("BandOfDarkElvesBattle");
			BandOfDarkElvesBattle.rewardEvent = getRewardEvent("BandOfDarkElvesReward");
			addEnemiesToCombatEvent(BandOfDarkElvesBattle,"DarkElf","DarkElf","Drider");
			var MausoleumOfTheDamnedBattle:CombatEvent = createCombatEvent("MausoleumOfTheDamnedBattle");
			MausoleumOfTheDamnedBattle.rewardEvent = getRewardEvent("MausoleumOfTheDamnedReward");
			addEnemiesToCombatEvent(MausoleumOfTheDamnedBattle,"Ghost","Wraith","Ghost","Wraith");
			var FrozenTempleBattle:CombatEvent = createCombatEvent("FrozenTempleBattle");
			FrozenTempleBattle.rewardEvent = getRewardEvent("FrozenTempleReward");
			addEnemiesToCombatEvent(FrozenTempleBattle,"Sasquatch","Yeti","Yeti");
			var ZilBattle:CombatEvent = createCombatEvent("ZilBattle");
			ZilBattle.rewardEvent = getRewardEvent("ZilReward");
			ZilBattle.storyConditionTriggered = StoryConditionType.DAWNSTAR_LOCKET;
			addEnemiesToCombatEvent(ZilBattle,"Bramble","Zil");
			var MingyelBattle:CombatEvent = createCombatEvent("MingyelBattle");
			MingyelBattle.rewardEvent = getRewardEvent("MingyelReward");
			MingyelBattle.storyConditionTriggered = StoryConditionType.TOME_DUSKBORN;
			addEnemiesToCombatEvent(MingyelBattle,"Mingyel");
			var SpiderCryptBattle:CombatEvent = createCombatEvent("SpiderCryptBattle");
			SpiderCryptBattle.rewardEvent = getRewardEvent("SpiderCryptReward");
			addEnemiesToCombatEvent(SpiderCryptBattle,"Drider","DarkElf","Drider");
			var GreatWoodSerpentBattle:CombatEvent = createCombatEvent("GreatWoodSerpentBattle");
			GreatWoodSerpentBattle.rewardEvent = getRewardEvent("GreatWoodSerpentReward");
			addEnemiesToCombatEvent(GreatWoodSerpentBattle,"GreatWoodSerpent");
			var TempleOfAsmodeusBattle:CombatEvent = createCombatEvent("TempleOfAsmodeusBattle");
			TempleOfAsmodeusBattle.rewardEvent = getRewardEvent("TempleOfAsmodeusReward");
			addEnemiesToCombatEvent(TempleOfAsmodeusBattle,"OrcWarlord","FlameclawCrab","OrcDiabolist","DemonCrab");
			var StormlordBattle:CombatEvent = createCombatEvent("StormlordBattle");
			StormlordBattle.rewardEvent = getRewardEvent("StormlordReward");
			addEnemiesToCombatEvent(StormlordBattle,"Stormlord");
			var TombOfTheNecroElfBattle:CombatEvent = createCombatEvent("TombOfTheNecroElfBattle");
			TombOfTheNecroElfBattle.rewardEvent = getRewardEvent("TombOfTheNecroElfReward");
			addEnemiesToCombatEvent(TombOfTheNecroElfBattle,"DarkElf","Drider","NecroElf");
			var DreadWraithBattle:CombatEvent = createCombatEvent("DreadWraithBattle");
			DreadWraithBattle.rewardEvent = getRewardEvent("DreadWraithReward");
			DreadWraithBattle.storyConditionTriggered = StoryConditionType.DEFEAT_DREAD_WRAITH;
			addEnemiesToCombatEvent(DreadWraithBattle,"DreadWraith");
			var SkullpocalypseBattle:CombatEvent = createCombatEvent("SkullpocalypseBattle");
			SkullpocalypseBattle.storyConditionTriggered = StoryConditionType.DEFEAT_SKULLPOCALYPSE;
			SkullpocalypseBattle.music = SoundList.MUSIC_LAST_BOSS_COMBAT_EVENT_SCREEN;
			addEnemiesToCombatEvent(SkullpocalypseBattle,"Skullpocalypse");
		}
	}
}
