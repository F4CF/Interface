package bhvr.data.database.creators.bases
{
	import bhvr.data.database.RewardEvent;
	import bhvr.data.database.BaseItem;
	import flash.utils.Dictionary;
	
	public class BaseRewardEventDataCreator extends BaseDataCreator
	{
		 
		
		public function BaseRewardEventDataCreator(sharedData:Dictionary)
		{
			super(sharedData);
		}
		
		public function createRewardEvent(id:String) : RewardEvent
		{
			var obj:RewardEvent = new RewardEvent();
			addObjectToSharedData(id,obj);
			return obj;
		}
		
		public function getItem(id:String) : BaseItem
		{
			return getObjectFromSharedData(id,BaseItem) as BaseItem;
		}
	}
}
