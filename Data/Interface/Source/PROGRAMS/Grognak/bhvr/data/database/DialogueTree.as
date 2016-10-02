package bhvr.data.database
{
	public class DialogueTree
	{
		 
		
		private var _dialogueBranches:Vector.<bhvr.data.database.DialogueBranch>;
		
		public function DialogueTree()
		{
			this._dialogueBranches = new Vector.<DialogueBranch>();
			super();
		}
		
		public function get dialogueBranches() : Vector.<bhvr.data.database.DialogueBranch>
		{
			return this._dialogueBranches;
		}
	}
}
