package bhvr.data.database
{
	public class DialogueBranch
	{
		 
		
		private var _dialogue:bhvr.data.database.Dialogue;
		
		private var _conditions:Vector.<int>;
		
		public function DialogueBranch(dialogue:bhvr.data.database.Dialogue)
		{
			this._conditions = new Vector.<int>();
			super();
			this._dialogue = dialogue;
		}
		
		public function get dialogue() : bhvr.data.database.Dialogue
		{
			return this._dialogue;
		}
		
		public function get conditions() : Vector.<int>
		{
			return this._conditions;
		}
	}
}
