package bhvr.data.database.creators.contexts
{
	import bhvr.data.database.DialogueOption;
	import bhvr.data.database.creators.bases.BaseDialogueDataCreator;
	import bhvr.data.database.DialogueItemOption;
	
	public class DialogueItemOptionCreatorContext extends DialogueOptionCreatorContext
	{
		 
		
		private var _itemOption:DialogueOption;
		
		public function DialogueItemOptionCreatorContext(dialogueCreator:BaseDialogueDataCreator, option:DialogueItemOption)
		{
			super(dialogueCreator,option);
			this._itemOption = option;
		}
	}
}
