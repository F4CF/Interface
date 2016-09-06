package bhvr.module.event.operations
{
	import bhvr.constants.GameConstants;
	
	public class SentenceOperation
	{
		
		public static const DELAY_NONE:int = 0;
		
		public static const DELAY_SHORT:int = 1;
		
		public static const DELAY_MEDIUM:int = 2;
		
		public static const DELAY_LONG:int = 3;
		 
		
		private const NO_DELAY_DURATION:Number = 0.1;
		
		private var _sentence:String;
		
		private var _delayType:int;
		
		public function SentenceOperation(sentence:String, delayType:int = 1)
		{
			super();
			this._sentence = sentence;
			this._delayType = delayType;
		}
		
		public function get sentence() : String
		{
			return this._sentence;
		}
		
		public function get delayType() : int
		{
			return this._delayType;
		}
		
		public function get delay() : Number
		{
			switch(this._delayType)
			{
				case DELAY_SHORT:
					return GameConstants.pauseShort;
				case DELAY_MEDIUM:
					return GameConstants.pauseMedium;
				case DELAY_LONG:
					return GameConstants.pauseLong;
				default:
					return this.NO_DELAY_DURATION;
			}
		}
	}
}
