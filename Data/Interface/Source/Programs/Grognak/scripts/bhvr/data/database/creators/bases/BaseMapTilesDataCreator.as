package bhvr.data.database.creators.bases
{
	import bhvr.data.database.MapTilesData;
	import bhvr.data.database.GameDatabase;
	import bhvr.data.database.TileData;
	import flash.utils.Dictionary;
	
	public class BaseMapTilesDataCreator extends BaseDataCreator
	{
		 
		
		public function BaseMapTilesDataCreator(sharedData:Dictionary)
		{
			super(sharedData);
		}
		
		public function createMapTiles() : MapTilesData
		{
			var obj:MapTilesData = new MapTilesData();
			GameDatabase.initMap(obj);
			return obj;
		}
		
		public function createTileProperty() : TileData
		{
			return new TileData();
		}
	}
}
