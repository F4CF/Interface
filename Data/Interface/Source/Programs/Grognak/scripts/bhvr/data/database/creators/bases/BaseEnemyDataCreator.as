package bhvr.data.database.creators.bases
{
	import bhvr.data.database.Enemy;
	import flash.utils.Dictionary;
	
	public class BaseEnemyDataCreator extends BaseDataCreator
	{
		 
		
		public function BaseEnemyDataCreator(sharedData:Dictionary)
		{
			super(sharedData);
		}
		
		public function createEnemy(id:String) : Enemy
		{
			var obj:Enemy = new Enemy();
			addObjectToSharedData(id,obj);
			return obj;
		}
	}
}
