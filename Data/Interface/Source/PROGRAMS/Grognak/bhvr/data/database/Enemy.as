package bhvr.data.database
{
	public class Enemy extends Character
	{
		 
		
		public var pluralMainName:String;
		
		public var inTextName:String;
		
		public var description:String;
		
		public var areaAttackName:String;
		
		public var areaAttackFrequency:int;
		
		public var minAreaAttackPower:int;
		
		public var maxAreaAttackPower:int;
		
		public var cantDie:Boolean;
		
		public function Enemy()
		{
			super();
			this.cantDie = false;
		}
		
		public function get sentenceBeginningName() : String
		{
			return this.inTextName.substr(0,1).toUpperCase() + this.inTextName.substr(1,this.inTextName.length);
		}
		
		public function get sentenceMiddleName() : String
		{
			return this.inTextName;
		}
	}
}
