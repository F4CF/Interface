package bhvr.data.database
{
	public class HeroSpecialAttack
	{
		 
		
		public var name:String;
		
		public var focusCost:int;
		
		private var _id:String;
		
		public function HeroSpecialAttack(id:String)
		{
			super();
			this._id = id;
		}
		
		public function get id() : String
		{
			return this._id;
		}
	}
}
