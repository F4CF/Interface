package bhvr.data.database
{
	public class Dialogue
	{
		 
		
		private var _sentences:Vector.<bhvr.data.database.DialogueSentence>;
		
		private var _options:Vector.<bhvr.data.database.DialogueOption>;
		
		public function Dialogue()
		{
			this._sentences = new Vector.<DialogueSentence>();
			this._options = new Vector.<DialogueOption>();
			super();
		}
		
		public function get sentences() : Vector.<bhvr.data.database.DialogueSentence>
		{
			return this._sentences;
		}
		
		public function get options() : Vector.<bhvr.data.database.DialogueOption>
		{
			return this._options;
		}
	}
}
