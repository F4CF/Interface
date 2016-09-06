package bhvr.data.database.creators.bases
{
	import bhvr.data.database.MapEnemyData;
	import bhvr.data.database.GameDatabase;
	import bhvr.data.database.CombatEvent;
	import bhvr.data.database.MapPath;
	import flash.utils.Dictionary;
	
	public class BaseMapEnemyDataCreator extends BaseDataCreator
	{
		 
		
		public function BaseMapEnemyDataCreator(sharedData:Dictionary)
		{
			super(sharedData);
		}
		
		public function createMapEnemy() : MapEnemyData
		{
			var obj:MapEnemyData = new MapEnemyData();
			GameDatabase.mapObjects.push(obj);
			return obj;
		}
		
		public function getCombatEvent(id:String) : CombatEvent
		{
			return getObjectFromSharedData(id,CombatEvent) as CombatEvent;
		}
		
		public function getPath(id:String) : MapPath
		{
			return getObjectFromSharedData(id,MapPath) as MapPath;
		}
	}
}
