package bhvr.data.database.creators.bases
{
	import bhvr.data.database.MapLocationData;
	import bhvr.data.database.GameDatabase;
	import bhvr.data.database.CombatEvent;
	import bhvr.data.database.InteractionEvent;
	import flash.utils.Dictionary;
	
	public class BaseMapLocationDataCreator extends BaseDataCreator
	{
		 
		
		public function BaseMapLocationDataCreator(sharedData:Dictionary)
		{
			super(sharedData);
		}
		
		public function createPartySelectMapLocation() : MapLocationData
		{
			var obj:MapLocationData = new MapLocationData();
			GameDatabase.initPartySelectMapLocation(obj);
			GameDatabase.mapObjects.push(obj);
			return obj;
		}
		
		public function createMapLocation() : MapLocationData
		{
			var obj:MapLocationData = new MapLocationData();
			GameDatabase.mapObjects.push(obj);
			return obj;
		}
		
		public function getCombatEvent(id:String) : CombatEvent
		{
			return getObjectFromSharedData(id,CombatEvent) as CombatEvent;
		}
		
		public function getInteractionEvent(id:String) : InteractionEvent
		{
			return getObjectFromSharedData(id,InteractionEvent) as InteractionEvent;
		}
	}
}
