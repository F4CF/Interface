package bhvr.data.database.creators
{
	import bhvr.data.database.creators.bases.BaseInteractionEventDataCreator;
	import bhvr.data.database.InteractionEvent;
	import bhvr.data.StoryConditionType;
	import flash.utils.Dictionary;
	
	public class InteractionEventDataCreator extends BaseInteractionEventDataCreator
	{
		 
		
		public function InteractionEventDataCreator(sharedData:Dictionary)
		{
			super(sharedData);
		}
		
		override public function createData() : void
		{
			var interactionKingsmanGuard:InteractionEvent = createInteractionEvent("interactionKingsmanGuard");
			interactionKingsmanGuard.npc = getNPC("npcKingsmanGuard");
			interactionKingsmanGuard.dialogueTree = getDialogueTree("dialogueKingsmanGuard");
			var interactionConjurer:InteractionEvent = createInteractionEvent("interactionConjurer");
			interactionConjurer.npc = getNPC("npcConjurer");
			interactionConjurer.dialogueTree = getDialogueTree("dialogueConjurer");
			var interactionSouthDocksCorsairQueen:InteractionEvent = createInteractionEvent("interactionSouthDocksCorsairQueen");
			interactionSouthDocksCorsairQueen.npc = getNPC("npcCorsairQueen");
			interactionSouthDocksCorsairQueen.dialogueTree = getDialogueTree("dialogueCorsairQueen");
			interactionSouthDocksCorsairQueen.addPresenceStoryCondition(StoryConditionType.CONJURER_MET);
			interactionSouthDocksCorsairQueen.addPresenceStoryCondition(StoryConditionType.DYNAMIC_SHIP_SOUTH_DOCKS);
			var interactionNorthDocksCorsairQueen:InteractionEvent = createInteractionEvent("interactionNorthDocksCorsairQueen");
			interactionNorthDocksCorsairQueen.npc = getNPC("npcCorsairQueen");
			interactionNorthDocksCorsairQueen.dialogueTree = getDialogueTree("dialogueCorsairQueen");
			interactionNorthDocksCorsairQueen.addPresenceStoryCondition(StoryConditionType.CONJURER_MET);
			interactionNorthDocksCorsairQueen.addPresenceStoryCondition(StoryConditionType.DYNAMIC_SHIP_NORTH_DOCKS);
			var interactionZil:InteractionEvent = createInteractionEvent("interactionZil");
			interactionZil.npc = getNPC("npcZil");
			interactionZil.dialogueTree = getDialogueTree("dialogueZil");
			var interactionMingyel:InteractionEvent = createInteractionEvent("interactionMingyel");
			interactionMingyel.npc = getNPC("npcMingyel");
			interactionMingyel.dialogueTree = getDialogueTree("dialogueMingyel");
			var interactionTavern:InteractionEvent = createInteractionEvent("interactionTavern");
			var interactionNorthChapel:InteractionEvent = createInteractionEvent("interactionNorthChapel");
			interactionNorthChapel.npc = getNPC("npcCleric");
			interactionNorthChapel.dialogueTree = getDialogueTree("dialogueNorthChapel");
			var interactionSouthChapel:InteractionEvent = createInteractionEvent("interactionSouthChapel");
			interactionSouthChapel.npc = getNPC("npcCleric");
			interactionSouthChapel.dialogueTree = getDialogueTree("dialogueSouthChapel");
			var interactionShop1:InteractionEvent = createInteractionEvent("interactionShop1");
			interactionShop1.npc = getNPC("npcShopkeeper");
			interactionShop1.dialogueTree = getDialogueTree("dialogueShop1");
			var interactionShop2:InteractionEvent = createInteractionEvent("interactionShop2");
			interactionShop2.npc = getNPC("npcShopkeeper");
			interactionShop2.dialogueTree = getDialogueTree("dialogueShop2");
			var interactionShop3:InteractionEvent = createInteractionEvent("interactionShop3");
			interactionShop3.npc = getNPC("npcShopkeeper");
			interactionShop3.dialogueTree = getDialogueTree("dialogueShop3");
		}
	}
}
