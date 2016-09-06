package bhvr.data.database
{
	public class Hero extends Character
	{
		 
		
		public var fullName:String;
		
		public var isMale:Boolean;
		
		public var isMandatoryPartyMember:Boolean;
		
		public var initialMaxFocus:int;
		
		public var specialAttack:bhvr.data.database.HeroSpecialAttack;
		
		public var attackVFX:String;
		
		public var attackSFX:String;
		
		public var specialAttackSFX:String;
		
		public var strangerSentence:String;
		
		public var acceptedInPartySentence:String;
		
		public var refusedInPartySentence:String;
		
		private var _uid:uint;
		
		public function Hero(uid:uint)
		{
			super();
			this._uid = uid;
		}
		
		public function get uid() : uint
		{
			return this._uid;
		}
	}
}
