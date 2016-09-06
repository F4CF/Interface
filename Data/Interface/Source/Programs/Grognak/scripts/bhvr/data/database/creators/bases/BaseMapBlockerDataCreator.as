package bhvr.data.database.creators.bases
{
	import bhvr.data.database.MapBlockerData;
	import bhvr.data.database.GameDatabase;
	import flash.utils.Dictionary;
	
	public class BaseMapBlockerDataCreator extends BaseDataCreator
	{
		 
		
		public function BaseMapBlockerDataCreator(sharedData:Dictionary)
		{
			super(sharedData);
		}
		
		public function createMapBlocker() : MapBlockerData
		{
			var obj:MapBlockerData = new MapBlockerData();
			GameDatabase.mapObjects.push(obj);
			return obj;
		}
	}
}
