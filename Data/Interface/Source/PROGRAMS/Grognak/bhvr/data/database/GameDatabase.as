package bhvr.data.database
{
	import flash.utils.Dictionary;
	import bhvr.data.database.creators.bases.BaseDataCreator;
	import bhvr.data.database.creators.HeroSpecialAttackDataCreator;
	import bhvr.data.database.creators.HeroDataCreator;
	import bhvr.data.database.creators.EnemyDataCreator;
	import bhvr.data.database.creators.NPCDataCreator;
	import bhvr.data.database.creators.ItemDataCreator;
	import bhvr.data.database.creators.RewardEventDataCreator;
	import bhvr.data.database.creators.CombatEventDataCreator;
	import bhvr.data.database.creators.DialogueDataCreator;
	import bhvr.data.database.creators.InteractionEventDataCreator;
	import bhvr.data.database.creators.MapPathDataCreator;
	import bhvr.data.database.creators.MapTilesDataCreator;
	import bhvr.data.database.creators.MapHeroDataCreator;
	import bhvr.data.database.creators.MapEnemyDataCreator;
	import bhvr.data.database.creators.MapLocationDataCreator;
	import bhvr.data.database.creators.MapBlockerDataCreator;
	import bhvr.data.database.creators.MapShipDataCreator;
	
	public class GameDatabase
	{
		
		private static var _defaultCombatEvent:bhvr.data.database.CombatEvent;
		
		private static var _partySelectMapLocation:bhvr.data.database.MapLocationData;
		
		private static var _heroes:Vector.<bhvr.data.database.Hero>;
		
		private static var _shopItems:Vector.<bhvr.data.database.ShopItem>;
		
		private static var _combatEvents:Vector.<bhvr.data.database.CombatEvent>;
		
		private static var _mapTiles:bhvr.data.database.MapTilesData;
		
		private static var _mapHero:bhvr.data.database.MapHeroData;
		
		private static var _mapObjects:Vector.<bhvr.data.database.MapObjectData>;
		 
		
		public function GameDatabase()
		{
			super();
		}
		
		public static function get defaultCombatEvent() : bhvr.data.database.CombatEvent
		{
			return _defaultCombatEvent;
		}
		
		public static function get partySelectMapLocation() : bhvr.data.database.MapLocationData
		{
			return _partySelectMapLocation;
		}
		
		public static function get heroes() : Vector.<bhvr.data.database.Hero>
		{
			return _heroes;
		}
		
		public static function get shopItems() : Vector.<bhvr.data.database.ShopItem>
		{
			return _shopItems;
		}
		
		public static function get combatEvents() : Vector.<bhvr.data.database.CombatEvent>
		{
			return _combatEvents;
		}
		
		public static function get mapTiles() : bhvr.data.database.MapTilesData
		{
			return _mapTiles;
		}
		
		public static function get mapHero() : bhvr.data.database.MapHeroData
		{
			return _mapHero;
		}
		
		public static function get mapObjects() : Vector.<bhvr.data.database.MapObjectData>
		{
			return _mapObjects;
		}
		
		public static function init() : void
		{
			var sharedTempData:Dictionary = new Dictionary();
			var dataCreators:Vector.<BaseDataCreator> = getDataCreators(sharedTempData);
			_heroes = new Vector.<Hero>();
			_shopItems = new Vector.<ShopItem>();
			_combatEvents = new Vector.<CombatEvent>();
			_mapObjects = new Vector.<MapObjectData>();
			for(var i:uint = 0; i < dataCreators.length; i++)
			{
				dataCreators[i].createData();
			}
		}
		
		public static function initMap(data:bhvr.data.database.MapTilesData) : void
		{
			if(_mapTiles == null)
			{
				_mapTiles = data;
			}
		}
		
		public static function initMapHero(data:bhvr.data.database.MapHeroData) : void
		{
			if(_mapHero == null)
			{
				_mapHero = data;
			}
		}
		
		public static function initDefaultCombatEvent(data:bhvr.data.database.CombatEvent) : void
		{
			if(_defaultCombatEvent == null)
			{
				_defaultCombatEvent = data;
			}
		}
		
		public static function initPartySelectMapLocation(data:bhvr.data.database.MapLocationData) : void
		{
			if(_partySelectMapLocation == null)
			{
				_partySelectMapLocation = data;
			}
		}
		
		private static function getDataCreators(sharedTempData:Dictionary) : Vector.<BaseDataCreator>
		{
			var dataCreators:Vector.<BaseDataCreator> = new Vector.<BaseDataCreator>();
			dataCreators.push(new HeroSpecialAttackDataCreator(sharedTempData));
			dataCreators.push(new HeroDataCreator(sharedTempData));
			dataCreators.push(new EnemyDataCreator(sharedTempData));
			dataCreators.push(new NPCDataCreator(sharedTempData));
			dataCreators.push(new ItemDataCreator(sharedTempData));
			dataCreators.push(new RewardEventDataCreator(sharedTempData));
			dataCreators.push(new CombatEventDataCreator(sharedTempData));
			dataCreators.push(new DialogueDataCreator(sharedTempData));
			dataCreators.push(new InteractionEventDataCreator(sharedTempData));
			dataCreators.push(new MapPathDataCreator(sharedTempData));
			dataCreators.push(new MapTilesDataCreator(sharedTempData));
			dataCreators.push(new MapHeroDataCreator(sharedTempData));
			dataCreators.push(new MapEnemyDataCreator(sharedTempData));
			dataCreators.push(new MapLocationDataCreator(sharedTempData));
			dataCreators.push(new MapBlockerDataCreator(sharedTempData));
			dataCreators.push(new MapShipDataCreator(sharedTempData));
			return dataCreators;
		}
		
		public static function reset() : void
		{
			_defaultCombatEvent = null;
			_heroes = null;
			_shopItems = null;
			_combatEvents = null;
			_mapTiles = null;
			_mapHero = null;
			_mapObjects = null;
		}
	}
}
