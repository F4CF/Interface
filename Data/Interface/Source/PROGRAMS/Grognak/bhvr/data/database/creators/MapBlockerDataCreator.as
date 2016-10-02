package bhvr.data.database.creators
{
	import bhvr.data.database.creators.bases.BaseMapBlockerDataCreator;
	import bhvr.data.database.MapBlockerData;
	import flash.geom.Point;
	import bhvr.data.StoryConditionType;
	import bhvr.data.assets.TileSymbols;
	import flash.utils.Dictionary;
	
	public class MapBlockerDataCreator extends BaseMapBlockerDataCreator
	{
		 
		
		public function MapBlockerDataCreator(sharedData:Dictionary)
		{
			super(sharedData);
		}
		
		override public function createData() : void
		{
			var blockerLighthouse:MapBlockerData = null;
			blockerLighthouse = createMapBlocker();
			blockerLighthouse.locationName = "Lighthouse";
			blockerLighthouse.image = "";
			blockerLighthouse.unblockedImage = "";
			blockerLighthouse.initialPosition = new Point(52,40);
			blockerLighthouse.explanation = "The reinforced door to the Lighthouse is locked tight. Not even Grognak could break it down.";
			blockerLighthouse.unblockedStoryCondition = StoryConditionType.LIGHTHOUSE_KEY;
			var blockerDreadWraith:MapBlockerData = createMapBlocker();
			blockerDreadWraith.locationName = "Foulwind Pass";
			blockerDreadWraith.image = "";
			blockerDreadWraith.unblockedImage = "";
			blockerDreadWraith.initialPosition = new Point(50,7);
			blockerDreadWraith.explanation = "You push forward through Foulwind Pass, but quickly find yourself returning the way you came, with no memory of turning around.";
			blockerDreadWraith.unblockedStoryCondition = StoryConditionType.CONJURER_REVELATION;
			var blockerBridge:MapBlockerData = createMapBlocker();
			blockerBridge.locationName = "Manticore\'s Bridge";
			blockerBridge.image = TileSymbols.LOC_BRIDGE_OPENED;
			blockerBridge.unblockedImage = TileSymbols.LOC_BRIDGE_CLOSED;
			blockerBridge.initialPosition = new Point(21,22);
			blockerBridge.explanation = "Manticore\'s Bridge is up. It can only be lowered from the northern shore.";
			blockerBridge.unblockedStoryCondition = StoryConditionType.BRIDGE_LOWERED;
		}
	}
}
