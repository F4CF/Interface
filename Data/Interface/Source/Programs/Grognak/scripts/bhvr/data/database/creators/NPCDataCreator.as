package bhvr.data.database.creators
{
	import bhvr.data.database.creators.bases.BaseNPCDataCreator;
	import bhvr.data.database.NPC;
	import bhvr.data.assets.PortraitSymbols;
	import flash.utils.Dictionary;
	
	public class NPCDataCreator extends BaseNPCDataCreator
	{
		 
		
		public function NPCDataCreator(sharedData:Dictionary)
		{
			super(sharedData);
		}
		
		override public function createData() : void
		{
			var npcKingsmanGuard:NPC = createNPC("npcKingsmanGuard");
			npcKingsmanGuard.name = "Kingsman Guard";
			npcKingsmanGuard.inTextName = "the Kingsman Guard";
			npcKingsmanGuard.portrait = PortraitSymbols.NPC_KINGSMAN_GUARD;
			npcKingsmanGuard.description = "The King\'s Arch outpost is surrounded by an extensive vegetable garden. A heavily armored Dwarven woman, proudly wearing a military tabard, comes out to greet you.";
			var npcConjurer:NPC = createNPC("npcConjurer");
			npcConjurer.name = "Conjurer";
			npcConjurer.inTextName = "the Conjurer";
			npcConjurer.portrait = PortraitSymbols.NPC_CONJURER;
			npcConjurer.description = "The aroma of incense is unmistakable as you step into the tower. An elderly Elven man in kaleidoscopic robes meets you with a friendly and knowing smile.";
			var npcCorsairQueen:NPC = createNPC("npcCorsairQueen");
			npcCorsairQueen.name = "Corsair Queen";
			npcCorsairQueen.inTextName = "the Corsair Queen";
			npcCorsairQueen.portrait = PortraitSymbols.NPC_CORSAIR_QUEEN;
			npcCorsairQueen.description = "A sleek pirate frigate with a crazed mermaid figurehead is moored to the docks. A fiery young woman stands on deck barking orders at the scurrying crew.";
			var npcZil:NPC = createNPC("npcZil");
			npcZil.name = "Zil the Pit Fighter";
			npcZil.inTextName = "Zil";
			npcZil.portrait = PortraitSymbols.NPC_ZIL_THE_PIT_FIGHTER;
			npcZil.description = "A grand coliseum dug into the ground, the Pit offers fame or failure to all comers. With a Guardian Hound at her side and an Asmadorian longbow in her grip, a battle-hardened Pit veteran approaches you.";
			var npcMingyel:NPC = createNPC("npcMingyel");
			npcMingyel.name = "Warlord Mingyel";
			npcMingyel.inTextName = "Mingyel";
			npcMingyel.portrait = PortraitSymbols.NPC_WARLORD_MINGYEL;
			npcMingyel.description = "A crowd of mercenaries grows around you as you head to the central pavilion. As if on cue, a biting wind picks up as a towering warrior in custom bleaksteel armor steps out to meet you.";
			var npcShopkeeper:NPC = createNPC("npcShopkeeper");
			npcShopkeeper.name = "Shopkeeper";
			npcShopkeeper.inTextName = "the Shopkeeper";
			npcShopkeeper.portrait = PortraitSymbols.NPC_SHOP_KEEPER;
			npcShopkeeper.description = "The shop is well-stocked, with weapons, armor and all sorts of goods on display. A teenaged shopkeeper stands behind the front counter, eyeing you with a shrewd gaze.";
			var npcCleric:NPC = createNPC("npcCleric");
			npcCleric.name = "Cleric";
			npcCleric.inTextName = "the Cleric";
			npcCleric.portrait = PortraitSymbols.NPC_CLERIC;
			npcCleric.description = "Bathed in shadows, the chapel is humble and nondescript except for faintly glowing runes on the walls. As you walk in, a giant bear of a man silently comes up behind you.";
		}
	}
}
