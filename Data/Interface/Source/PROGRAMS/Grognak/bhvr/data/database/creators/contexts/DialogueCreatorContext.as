package bhvr.data.database.creators.contexts
{
	import bhvr.data.database.creators.bases.BaseDialogueDataCreator;
	import bhvr.data.database.Dialogue;
	import bhvr.data.database.DialogueSentence;
	import bhvr.data.database.DialogueOption;
	
	public class DialogueCreatorContext
	{
		 
		
		protected var _dialogueCreator:BaseDialogueDataCreator;
		
		private var _dialogue:Dialogue;
		
		public function DialogueCreatorContext(dialogueCreator:BaseDialogueDataCreator, dialogue:Dialogue)
		{
			super();
			this._dialogueCreator = dialogueCreator;
			this._dialogue = dialogue;
		}
		
		public function additionalText(delayType:int, text:String) : void
		{
			var dialogSentence:DialogueSentence = new DialogueSentence(text);
			this._dialogue.sentences[this._dialogue.sentences.length - 1].delayType = delayType;
			this._dialogue.sentences.push(dialogSentence);
		}
		
		public function option(text:String) : DialogueOptionCreatorContext
		{
			var dialogueOption:DialogueOption = new DialogueOption(text);
			this._dialogue.options.push(dialogueOption);
			return new DialogueOptionCreatorContext(this._dialogueCreator,dialogueOption);
		}
	}
}
