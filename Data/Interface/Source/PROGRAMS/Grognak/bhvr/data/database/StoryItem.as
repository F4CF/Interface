package bhvr.data.database
{
	import bhvr.data.StoryConditionType;
	
	public class StoryItem extends BaseItem
	{
		 
		
		public var storyConditionTriggered:int;
		
		public function StoryItem()
		{
			super();
			this.storyConditionTriggered = StoryConditionType.NONE;
		}
	}
}
