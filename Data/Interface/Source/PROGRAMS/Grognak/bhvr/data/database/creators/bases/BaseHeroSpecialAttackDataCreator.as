package bhvr.data.database.creators.bases
{
	import bhvr.data.database.HeroSpecialAttack;
	import flash.utils.Dictionary;
	
	public class BaseHeroSpecialAttackDataCreator extends BaseDataCreator
	{
		 
		
		public function BaseHeroSpecialAttackDataCreator(sharedData:Dictionary)
		{
			super(sharedData);
		}
		
		public function createHeroSpecialAttack(id:String) : HeroSpecialAttack
		{
			var obj:HeroSpecialAttack = new HeroSpecialAttack(id);
			addObjectToSharedData(id,obj);
			return obj;
		}
	}
}
