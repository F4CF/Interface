package bhvr.data.database.creators.bases
{
	import bhvr.data.database.MapHeroData;
	import bhvr.data.database.GameDatabase;
	import flash.utils.Dictionary;
	
	public class BaseMapHeroDataCreator extends BaseDataCreator
	{
		 
		
		public function BaseMapHeroDataCreator(sharedData:Dictionary)
		{
			super(sharedData);
		}
		
		public function createMapHero() : MapHeroData
		{
			var obj:MapHeroData = new MapHeroData();
			GameDatabase.initMapHero(obj);
			return obj;
		}
	}
}
