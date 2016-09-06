package bhvr.data.database.creators.contexts
{
	import bhvr.data.database.creators.bases.BaseDialogueDataCreator;
	import bhvr.data.database.DialogueTree;
	import bhvr.data.database.Dialogue;
	import bhvr.data.database.InventoryDialogue;
	import bhvr.data.database.RevivalDialogue;
	import bhvr.data.database.DialogueSentence;
	import bhvr.data.database.DialogueBranch;
	
	public class DialogueTreeCreatorContext
	{
		 
		
		private var _dialogueCreator:BaseDialogueDataCreator;
		
		private var _tree:DialogueTree;
		
		public function DialogueTreeCreatorContext(dialogueCreator:BaseDialogueDataCreator, tree:DialogueTree)
		{
			super();
			this._dialogueCreator = dialogueCreator;
			this._tree = tree;
		}
		
		public function dialogue(text:String, ... rest) : DialogueCreatorContext
		{
			var dialogue:Dialogue = new Dialogue();
			this.addDialogue(dialogue,text,rest);
			return new DialogueCreatorContext(this._dialogueCreator,dialogue);
		}
		
		public function inventoryDialogue(text:String, ... rest) : InventoryDialogueCreatorContext
		{
			var dialogue:InventoryDialogue = new InventoryDialogue();
			this.addDialogue(dialogue,text,rest);
			return new InventoryDialogueCreatorContext(this._dialogueCreator,dialogue);
		}
		
		public function revivalDialogue(text:String, ... rest) : RevivalDialogueCreatorContext
		{
			var dialogue:RevivalDialogue = new RevivalDialogue();
			this.addDialogue(dialogue,text,rest);
			return new RevivalDialogueCreatorContext(this._dialogueCreator,dialogue);
		}
		
		private function addDialogue(dialogue:Dialogue, text:String, conditions:Array) : void
		{
			var dialogueSentence:DialogueSentence = new DialogueSentence(text);
			var branch:DialogueBranch = new DialogueBranch(dialogue);
			dialogue.sentences.push(dialogueSentence);
			for(var i:uint = 0; i < conditions.length; i++)
			{
				branch.conditions.push(conditions[i]);
			}
			this._tree.dialogueBranches.push(branch);
		}
	}
}
