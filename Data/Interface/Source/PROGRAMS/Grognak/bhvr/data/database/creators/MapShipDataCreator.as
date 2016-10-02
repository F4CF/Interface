package bhvr.data.database.creators
{
	import bhvr.data.database.creators.bases.BaseMapShipDataCreator;
	import bhvr.data.database.MapShipData;
	import bhvr.data.assets.TileSymbols;
	import flash.geom.Point;
	import bhvr.data.StoryConditionType;
	import flash.utils.Dictionary;
	
	public class MapShipDataCreator extends BaseMapShipDataCreator
	{
		 
		
		public function MapShipDataCreator(sharedData:Dictionary)
		{
			super(sharedData);
		}
		
		override public function createData() : void
		{
			var ship:MapShipData = null;
			ship = createMapShip();
			ship.image = TileSymbols.SHIP;
			ship.initialPosition = new Point(34,53);
			ship.presenceStoryCondition = StoryConditionType.CONJURER_MET;
			ship.path = getPath("ShipPath");
		}
	}
}
