package bhvr.data.database.creators.contexts
{
	import bhvr.data.database.InventoryDialogue;
	import bhvr.data.database.DialogueItemOption;
	import bhvr.data.database.ShopItem;
	import bhvr.data.database.creators.bases.BaseDialogueDataCreator;
	
	public class InventoryDialogueCreatorContext extends DialogueCreatorContext
	{
		 
		
		private var _dialogue:InventoryDialogue;
		
		public function InventoryDialogueCreatorContext(dialogueCreator:BaseDialogueDataCreator, dialogue:InventoryDialogue)
		{
			super(dialogueCreator,dialogue);
			this._dialogue = dialogue;
		}
		
		public function withReshownText(value:String) : InventoryDialogueCreatorContext
		{
			this._dialogue.reshownText = value;
			return this;
		}
		
		public function item(id:String) : DialogueOptionCreatorContext
		{
			var dialogueItemOption:DialogueItemOption = new DialogueItemOption(_dialogueCreator.getObjectFromSharedData(id,ShopItem) as ShopItem);
			this._dialogue.options.push(dialogueItemOption);
			return new DialogueItemOptionCreatorContext(_dialogueCreator,dialogueItemOption);
		}
	}
}
