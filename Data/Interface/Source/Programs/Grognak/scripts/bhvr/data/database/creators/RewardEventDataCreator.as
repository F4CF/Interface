package bhvr.data.database.creators
{
	import bhvr.data.database.creators.bases.BaseRewardEventDataCreator;
	import bhvr.data.database.RewardEvent;
	import flash.utils.Dictionary;
	
	public class RewardEventDataCreator extends BaseRewardEventDataCreator
	{
		 
		
		public function RewardEventDataCreator(sharedData:Dictionary)
		{
			super(sharedData);
		}
		
		override public function createData() : void
		{
			var GoblinCaveReward:RewardEvent = createRewardEvent("GoblinCaveReward");
			GoblinCaveReward.gold = 15;
			GoblinCaveReward.item = getItem("itemSpikedClub");
			GoblinCaveReward.endMessage = "Goblin bodies litter the floor as you turn and leave the shallow Cave.";
			var ForgottenCloisterReward:RewardEvent = createRewardEvent("ForgottenCloisterReward");
			ForgottenCloisterReward.gold = 10;
			ForgottenCloisterReward.item = getItem("itemHideArmor");
			ForgottenCloisterReward.endMessage = "Rid of its savage tenant, the Cloister can once again welcome monks and become a beacon of wisdom.";
			var GarrisonOfSavagesReward:RewardEvent = createRewardEvent("GarrisonOfSavagesReward");
			GarrisonOfSavagesReward.gold = 20;
			GarrisonOfSavagesReward.item = getItem("itemVoodooIdol");
			GarrisonOfSavagesReward.endMessage = "Before leaving, you set fire to the wooden ramparts, ensuring that no other creatures can use the Garrison.";
			var ValkyrianTombReward:RewardEvent = createRewardEvent("ValkyrianTombReward");
			ValkyrianTombReward.gold = 35;
			ValkyrianTombReward.item = getItem("itemSkyRidersHeaddress");
			ValkyrianTombReward.endMessage = "You seal the Tomb as best you can to make sure the eternal rest of the Valkyries is no longer disturbed.";
			var GoblinVillageReward:RewardEvent = createRewardEvent("GoblinVillageReward");
			GoblinVillageReward.gold = 25;
			GoblinVillageReward.item = getItem("itemChampionsBelt");
			GoblinVillageReward.endMessage = "A hundred years hence, Goblins will still speak the legend of Grognak with terror in their eyes.";
			var MuddyCrabDenReward:RewardEvent = createRewardEvent("MuddyCrabDenReward");
			MuddyCrabDenReward.gold = 15;
			MuddyCrabDenReward.item = getItem("itemCrabshellGreaves");
			MuddyCrabDenReward.endMessage = "Covered in mud and Crab innards, every bog-sucking step out of the Den is a challenge.";
			var BandOfGoblinoidsReward:RewardEvent = createRewardEvent("BandOfGoblinoidsReward");
			BandOfGoblinoidsReward.gold = 35;
			BandOfGoblinoidsReward.endMessage = "That\'s one less Goblinoid raiding party to worry about, but you know there are more out there.";
			var OutcastsRefugeReward:RewardEvent = createRewardEvent("OutcastsRefugeReward");
			OutcastsRefugeReward.gold = 20;
			OutcastsRefugeReward.item = getItem("itemRingOfBrutality");
			OutcastsRefugeReward.endMessage = "Inevitably, all evil creatures fall before Grognak\'s might, even those outcast and exiled.";
			var CoatlsShrineReward:RewardEvent = createRewardEvent("CoatlsShrineReward");
			CoatlsShrineReward.gold = 25;
			CoatlsShrineReward.item = getItem("itemVirginEatersFeather");
			CoatlsShrineReward.endMessage = "The foul deity worshipped by the Snakes will surely not let this blasphemy go unpunished...";
			var AbandonedFortressReward:RewardEvent = createRewardEvent("AbandonedFortressReward");
			AbandonedFortressReward.gold = 25;
			AbandonedFortressReward.item = getItem("itemReinforcedLoincloth");
			AbandonedFortressReward.endMessage = "You search the Fortress, which nature long ago reclaimed, but find nothing else of value.";
			var OrcVillageReward:RewardEvent = createRewardEvent("OrcVillageReward");
			OrcVillageReward.gold = 35;
			OrcVillageReward.item = getItem("itemMastodonaldsWartusk");
			OrcVillageReward.endMessage = "You find an altar dedicated to Mastadoom, one of Grognak\'s old archenemies. Could he still be alive?!";
			var LighthouseReward:RewardEvent = createRewardEvent("LighthouseReward");
			LighthouseReward.gold = 30;
			LighthouseReward.item = getItem("itemSwashingBuckler");
			LighthouseReward.endMessage = "You turn the Lighthouse back on, banishing the veil of darkness from over the sea. The symbolism is lost on Grognak.";
			var AssassinsStrongholdReward:RewardEvent = createRewardEvent("AssassinsStrongholdReward");
			AssassinsStrongholdReward.gold = 35;
			AssassinsStrongholdReward.item = getItem("itemVenomBlade");
			AssassinsStrongholdReward.endMessage = "An eerie quiet settles over the Stronghold. The surviving Dark Elf assassins are long gone.";
			var FrostcapCavernReward:RewardEvent = createRewardEvent("FrostcapCavernReward");
			FrostcapCavernReward.gold = 25;
			FrostcapCavernReward.item = getItem("itemVialOfLustSnow");
			FrostcapCavernReward.endMessage = "You feel a sense of confusing desire seep into your mind. You quickly make your way back out, and the fresh air clears your head.";
			var UnholySanctuaryReward:RewardEvent = createRewardEvent("UnholySanctuaryReward");
			UnholySanctuaryReward.gold = 40;
			UnholySanctuaryReward.item = getItem("itemMadTrickstersCap");
			UnholySanctuaryReward.endMessage = "It seems the Naga was beguiled by the Trickster into building an army of Goblin worshippers, but for what purpose?";
			var RavagedAntColonyReward:RewardEvent = createRewardEvent("RavagedAntColonyReward");
			RavagedAntColonyReward.gold = 20;
			RavagedAntColonyReward.item = getItem("itemAntAgonizersCarapace");
			RavagedAntColonyReward.endMessage = "Corpses of the AntAgonizer\'s giant ants are everywhere, massacred by the Drider before you arrived. But the AntAgonizer is nowhere to be found.";
			var SearingGrottoReward:RewardEvent = createRewardEvent("SearingGrottoReward");
			SearingGrottoReward.gold = 15;
			SearingGrottoReward.item = getItem("itemScorchingOil");
			SearingGrottoReward.endMessage = "Before moving on, you dine on succulent Crab meat, cooked right there on the Grotto floor.";
			var SlitheringAcropolisReward:RewardEvent = createRewardEvent("SlitheringAcropolisReward");
			SlitheringAcropolisReward.gold = 50;
			SlitheringAcropolisReward.item = getItem("itemBootOfHopping");
			SlitheringAcropolisReward.endMessage = "Coming from all around, a laughing hiss accompanies you through the twists and turns of the Acropolis as you make your way out.";
			var BandOfDarkElvesReward:RewardEvent = createRewardEvent("BandOfDarkElvesReward");
			BandOfDarkElvesReward.gold = 70;
			BandOfDarkElvesReward.endMessage = "Dark Elf marauders split into packs to roam the land, so there are surely more to beware of.";
			var MausoleumOfTheDamnedReward:RewardEvent = createRewardEvent("MausoleumOfTheDamnedReward");
			MausoleumOfTheDamnedReward.gold = 45;
			MausoleumOfTheDamnedReward.item = getItem("itemNecromancersHood");
			MausoleumOfTheDamnedReward.endMessage = "Never meant for mortals, the Barrow and its horrors weigh heavily on your mind and sanity as you depart.";
			var FrozenTempleReward:RewardEvent = createRewardEvent("FrozenTempleReward");
			FrozenTempleReward.gold = 30;
			FrozenTempleReward.item = getItem("itemArcticGlaive");
			FrozenTempleReward.endMessage = "Beneath the ice, ancient stonework depicts strange, tentacled beings with gibbous eyes.";
			var SpiderCryptReward:RewardEvent = createRewardEvent("SpiderCryptReward");
			SpiderCryptReward.gold = 60;
			SpiderCryptReward.item = getItem("itemLensOfSpiderPerception");
			SpiderCryptReward.endMessage = "With a flood of spiders pouring out of the walls, you knock over a support beam and flee the Crypt as it collapses on itself.";
			var GreatWoodSerpentReward:RewardEvent = createRewardEvent("GreatWoodSerpentReward");
			GreatWoodSerpentReward.gold = 20;
			GreatWoodSerpentReward.item = getItem("itemUnseelieGauntlets");
			GreatWoodSerpentReward.endMessage = "As you go, you push through a crowd of forest animals, who have come to see their fallen tormentor.";
			var TempleOfAsmodeusReward:RewardEvent = createRewardEvent("TempleOfAsmodeusReward");
			TempleOfAsmodeusReward.gold = 50;
			TempleOfAsmodeusReward.item = getItem("itemDemonClawScythe");
			TempleOfAsmodeusReward.endMessage = "How is it that lowly Orcs could summon and control one of the Demon King\'s prized battle mounts?";
			var StormlordReward:RewardEvent = createRewardEvent("StormlordReward");
			StormlordReward.gold = 25;
			StormlordReward.item = getItem("itemShieldOfStorms");
			StormlordReward.endMessage = "The blizzard intensifies briefly before abating, somehow taking the Stormlord\'s corpse with it.";
			var TombOfTheNecroElfReward:RewardEvent = createRewardEvent("TombOfTheNecroElfReward");
			TombOfTheNecroElfReward.gold = 100;
			TombOfTheNecroElfReward.item = getItem("itemRingOfReaping");
			TombOfTheNecroElfReward.endMessage = "Hidden elsewhere, the Necro-Elf\'s spirit amulet ensures that she will soon return to undeath with revenge on her mind.";
			var DreadWraithReward:RewardEvent = createRewardEvent("DreadWraithReward");
			DreadWraithReward.item = getItem("itemCloakOfTheBlackRose");
			DreadWraithReward.endMessage = "Walking away, you choose not to look as the Dread Wraith is dragged by ghostly hands into a plane of endless agony.";
			var ZilReward:RewardEvent = createRewardEvent("ZilReward");
			ZilReward.item = getItem("storyItemDawnstarLocket");
			ZilReward.endMessage = "As Zil herself raises your hand up in victory, you realize the stands are full of onlookers cheering the name of Grognak.";
			var MingyelReward:RewardEvent = createRewardEvent("MingyelReward");
			MingyelReward.item = getItem("storyItemTomeOfTheDuskborn");
			MingyelReward.endMessage = "Standing despite his wounds, Mingyel grants you a nod of respect before you go, while his mercenaries give you a wide berth.";
		}
	}
}
