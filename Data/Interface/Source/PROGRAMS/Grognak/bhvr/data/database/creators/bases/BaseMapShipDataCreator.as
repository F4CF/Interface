package bhvr.data.database.creators.bases
{
	import bhvr.data.database.MapShipData;
	import bhvr.data.database.GameDatabase;
	import bhvr.data.database.MapPath;
	import flash.utils.Dictionary;
	
	public class BaseMapShipDataCreator extends BaseDataCreator
	{
		 
		
		public function BaseMapShipDataCreator(sharedData:Dictionary)
		{
			super(sharedData);
		}
		
		public function createMapShip() : MapShipData
		{
			var obj:MapShipData = new MapShipData();
			GameDatabase.mapObjects.push(obj);
			return obj;
		}
		
		public function getPath(id:String) : MapPath
		{
			return getObjectFromSharedData(id,MapPath) as MapPath;
		}
	}
}
