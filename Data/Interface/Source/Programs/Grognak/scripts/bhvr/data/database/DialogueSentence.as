package bhvr.data.database
{
	import bhvr.module.event.operations.SentenceOperation;
	
	public class DialogueSentence
	{
		 
		
		public var delayType:int;
		
		private var _sentence:String;
		
		public function DialogueSentence(sentence:String)
		{
			super();
			this._sentence = sentence;
			this.delayType = SentenceOperation.DELAY_NONE;
		}
		
		public function get sentence() : String
		{
			return this._sentence;
		}
		
		public function copy() : DialogueSentence
		{
			var dialogueSentence:DialogueSentence = new DialogueSentence(this._sentence);
			dialogueSentence.delayType = this.delayType;
			return dialogueSentence;
		}
	}
}
