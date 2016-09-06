package bhvr.data.database
{
	public class NPC
	{
		 
		
		public var name:String;
		
		public var inTextName:String;
		
		public var portrait:String;
		
		public var description:String;
		
		public function NPC()
		{
			super();
		}
		
		public function get sentenceBeginningName() : String
		{
			return this.inTextName.substr(0,1).toUpperCase() + this.inTextName.substr(1,this.inTextName.length);
		}
		
		public function get sentenceMiddleName() : String
		{
			return this.inTextName.substr(0,1).toLowerCase() + this.inTextName.substr(1,this.inTextName.length);
		}
	}
}
