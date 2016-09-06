package bhvr.data.database
{
	public class MapBlockerData extends MapObjectData
	{
		 
		
		public var locationName:String;
		
		public var explanation:String;
		
		public var unblockedImage:String;
		
		public var unblockedStoryCondition:int;
		
		public function MapBlockerData()
		{
			super();
			image = "";
			this.unblockedImage = "";
			this.explanation = "";
		}
	}
}
