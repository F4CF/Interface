package bhvr.data.database.creators.bases
{
	import bhvr.data.database.InteractionEvent;
	import bhvr.data.database.DialogueTree;
	import bhvr.data.database.NPC;
	import flash.utils.Dictionary;
	
	public class BaseInteractionEventDataCreator extends BaseDataCreator
	{
		 
		
		public function BaseInteractionEventDataCreator(sharedData:Dictionary)
		{
			super(sharedData);
		}
		
		public function createInteractionEvent(id:String) : InteractionEvent
		{
			var obj:InteractionEvent = new InteractionEvent();
			addObjectToSharedData(id,obj);
			return obj;
		}
		
		public function getDialogueTree(id:String) : DialogueTree
		{
			return getObjectFromSharedData(id,DialogueTree) as DialogueTree;
		}
		
		public function getNPC(id:String) : NPC
		{
			return getObjectFromSharedData(id,NPC) as NPC;
		}
	}
}
