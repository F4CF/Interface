package bhvr.module.event
{
	public class SentenceInfo
	{
		 
		
		private var _text:String;
		
		private var _delay:Number;
		
		private var _callback:Function;
		
		private var _letters:Array;
		
		public function SentenceInfo(text:String, delay:Number, callback:Function)
		{
			super();
			this._text = text;
			this._delay = delay;
			this._callback = callback;
			this._letters = this._text.split("");
		}
		
		public function get text() : String
		{
			return this._text;
		}
		
		public function get delay() : Number
		{
			return this._delay;
		}
		
		public function get callback() : Function
		{
			return this._callback;
		}
		
		public function get letters() : Array
		{
			return this._letters;
		}
	}
}
