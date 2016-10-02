package bhvr.data.database.creators
{
	import bhvr.data.database.creators.bases.BaseMapEnemyDataCreator;
	import bhvr.data.database.MapEnemyData;
	import bhvr.data.assets.TileSymbols;
	import flash.geom.Point;
	import bhvr.data.StoryConditionType;
	import flash.utils.Dictionary;
	
	public class MapEnemyDataCreator extends BaseMapEnemyDataCreator
	{
		 
		
		public function MapEnemyDataCreator(sharedData:Dictionary)
		{
			super(sharedData);
		}
		
		override public function createData() : void
		{
			var mapBandOfGoblinoids:MapEnemyData = null;
			mapBandOfGoblinoids = createMapEnemy();
			mapBandOfGoblinoids.image = TileSymbols.ENEMY_BAND_OF_GOBLINOIDS;
			mapBandOfGoblinoids.locationName = "";
			mapBandOfGoblinoids.name = "Band of Goblinoids";
			mapBandOfGoblinoids.event = getCombatEvent("BandOfGoblinoidsBattle");
			mapBandOfGoblinoids.addPath(getPath("BandOfGoblinoidsPath1"));
			mapBandOfGoblinoids.addPath(getPath("BandOfGoblinoidsPath2"));
			mapBandOfGoblinoids.addPath(getPath("BandOfGoblinoidsPath3"));
			var mapBandOfDarkElves:MapEnemyData = createMapEnemy();
			mapBandOfDarkElves.image = TileSymbols.ENEMY_BAND_OF_DARK_ELVES;
			mapBandOfDarkElves.locationName = "";
			mapBandOfDarkElves.name = "Band of Dark Elves";
			mapBandOfDarkElves.event = getCombatEvent("BandOfDarkElvesBattle");
			mapBandOfDarkElves.addPath(getPath("BandOfDarkElvesPath1"));
			mapBandOfDarkElves.addPath(getPath("BandOfDarkElvesPath2"));
			mapBandOfDarkElves.addPath(getPath("BandOfDarkElvesPath3"));
			var mapGreatWoodSerpent:MapEnemyData = createMapEnemy();
			mapGreatWoodSerpent.image = TileSymbols.ENEMY_GREAT_WOOD_SERPENT;
			mapGreatWoodSerpent.locationName = "Sylvan Demesne";
			mapGreatWoodSerpent.name = "The Great Serpent";
			mapGreatWoodSerpent.event = getCombatEvent("GreatWoodSerpentBattle");
			mapGreatWoodSerpent.addPath(getPath("GreatWoodSerpentPath"));
			var mapStormlord:MapEnemyData = createMapEnemy();
			mapStormlord.image = TileSymbols.ENEMY_STORMLORD;
			mapStormlord.locationName = "Hyperborean Valley";
			mapStormlord.name = "The Stormlord";
			mapStormlord.event = getCombatEvent("StormlordBattle");
			mapStormlord.addPath(getPath("StormlordPath"));
			var mapDreadWraith:MapEnemyData = createMapEnemy();
			mapDreadWraith.initialPosition = new Point(50,7);
			mapDreadWraith.image = TileSymbols.ENEMY_DREAD_WRAITH;
			mapDreadWraith.locationName = "Foulwind Pass";
			mapDreadWraith.name = "Dread Wraith";
			mapDreadWraith.event = getCombatEvent("DreadWraithBattle");
			mapDreadWraith.activeStoryCondition = StoryConditionType.CONJURER_REVELATION;
		}
	}
}
