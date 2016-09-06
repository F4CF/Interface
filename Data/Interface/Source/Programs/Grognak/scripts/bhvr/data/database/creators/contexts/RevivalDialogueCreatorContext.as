package bhvr.data.database.creators.contexts
{
	import bhvr.data.database.RevivalDialogue;
	import bhvr.data.database.creators.bases.BaseDialogueDataCreator;
	
	public class RevivalDialogueCreatorContext extends DialogueCreatorContext
	{
		 
		
		private var _dialogue:RevivalDialogue;
		
		public function RevivalDialogueCreatorContext(dialogueCreator:BaseDialogueDataCreator, dialogue:RevivalDialogue)
		{
			super(dialogueCreator,dialogue);
			this._dialogue = dialogue;
		}
		
		public function withReshownText(value:String) : RevivalDialogueCreatorContext
		{
			this._dialogue.reshownText = value;
			return this;
		}
		
		public function withRevivalPrice(value:int) : RevivalDialogueCreatorContext
		{
			this._dialogue.price = value;
			return this;
		}
	}
}
