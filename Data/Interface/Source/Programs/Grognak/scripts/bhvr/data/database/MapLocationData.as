package bhvr.data.database
{
	import bhvr.data.StoryConditionType;
	
	public class MapLocationData extends MapObjectData
	{
		 
		
		public var clearedImage:String;
		
		public var locationName:String;
		
		public var portrait:String;
		
		public var description:String;
		
		public var clearedStoryCondition:int;
		
		public var event:bhvr.data.database.MapEvent;
		
		public function MapLocationData()
		{
			super();
			this.clearedImage = "";
			this.clearedStoryCondition = StoryConditionType.NEVER_MET;
		}
	}
}
