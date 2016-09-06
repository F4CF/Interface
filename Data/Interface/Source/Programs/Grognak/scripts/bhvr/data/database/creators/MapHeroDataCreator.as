package bhvr.data.database.creators
{
	import bhvr.data.database.creators.bases.BaseMapHeroDataCreator;
	import bhvr.data.database.MapHeroData;
	import bhvr.data.assets.TileSymbols;
	import flash.geom.Point;
	import flash.utils.Dictionary;
	
	public class MapHeroDataCreator extends BaseMapHeroDataCreator
	{
		 
		
		public function MapHeroDataCreator(sharedData:Dictionary)
		{
			super(sharedData);
		}
		
		override public function createData() : void
		{
			var mapHero:MapHeroData = createMapHero();
			mapHero.assetLink = TileSymbols.HERO_GROGNAK;
			mapHero.initialPosition = new Point(22,56);
		}
	}
}
