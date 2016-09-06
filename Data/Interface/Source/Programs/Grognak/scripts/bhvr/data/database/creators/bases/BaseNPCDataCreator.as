package bhvr.data.database.creators.bases
{
	import bhvr.data.database.NPC;
	import flash.utils.Dictionary;
	
	public class BaseNPCDataCreator extends BaseDataCreator
	{
		 
		
		public function BaseNPCDataCreator(sharedData:Dictionary)
		{
			super(sharedData);
		}
		
		public function createNPC(id:String) : NPC
		{
			var obj:NPC = new NPC();
			addObjectToSharedData(id,obj);
			return obj;
		}
	}
}
