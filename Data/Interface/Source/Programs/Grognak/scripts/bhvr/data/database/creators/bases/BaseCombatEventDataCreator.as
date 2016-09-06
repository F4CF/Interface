package bhvr.data.database.creators.bases
{
	import bhvr.data.database.CombatEvent;
	import bhvr.data.database.GameDatabase;
	import bhvr.constants.GameConfig;
	import bhvr.data.database.Enemy;
	import bhvr.data.database.RewardEvent;
	import flash.utils.Dictionary;
	
	public class BaseCombatEventDataCreator extends BaseDataCreator
	{
		 
		
		public function BaseCombatEventDataCreator(sharedData:Dictionary)
		{
			super(sharedData);
		}
		
		public function createCombatEvent(id:String) : CombatEvent
		{
			var obj:CombatEvent = new CombatEvent(GameDatabase.combatEvents.length,id);
			addObjectToSharedData(id,obj);
			GameDatabase.combatEvents.push(obj);
			if(id == GameConfig.DEFAULT_COMBAT_EVENT)
			{
				GameDatabase.initDefaultCombatEvent(obj);
			}
			return obj;
		}
		
		public function addEnemiesToCombatEvent(combatEvent:CombatEvent, ... rest) : void
		{
			for(var i:uint = 0; i < rest.length; i++)
			{
				combatEvent.enemies.push(getObjectFromSharedData(rest[i],Enemy));
			}
		}
		
		public function getRewardEvent(id:String) : RewardEvent
		{
			return getObjectFromSharedData(id,RewardEvent) as RewardEvent;
		}
	}
}
