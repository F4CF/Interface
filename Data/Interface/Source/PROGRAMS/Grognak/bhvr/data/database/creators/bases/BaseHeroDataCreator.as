package bhvr.data.database.creators.bases
{
	import bhvr.data.database.Hero;
	import bhvr.data.database.GameDatabase;
	import bhvr.data.database.HeroSpecialAttack;
	import flash.utils.Dictionary;
	
	public class BaseHeroDataCreator extends BaseDataCreator
	{
		 
		
		public function BaseHeroDataCreator(sharedData:Dictionary)
		{
			super(sharedData);
		}
		
		public function createHero() : Hero
		{
			var obj:Hero = new Hero(GameDatabase.heroes.length);
			GameDatabase.heroes.push(obj);
			return obj;
		}
		
		public function getHeroSpecialAttack(id:String) : HeroSpecialAttack
		{
			return getObjectFromSharedData(id,HeroSpecialAttack) as HeroSpecialAttack;
		}
	}
}
