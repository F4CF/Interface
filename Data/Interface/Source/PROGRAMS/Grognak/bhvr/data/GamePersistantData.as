package bhvr.data
{
	import bhvr.module.combat.HeroStats;
	import flash.utils.Dictionary;
	import flash.geom.Point;
	import bhvr.data.database.Hero;
	import bhvr.views.Tile;
	import bhvr.debug.Log;
	import bhvr.data.database.CombatEvent;
	import bhvr.data.database.ShopItem;
	import bhvr.data.database.MapEnemyData;
	import bhvr.data.database.GameDatabase;
	
	public class GamePersistantData
	{
		
		private static var _partyMembers:Vector.<HeroStats> = new Vector.<HeroStats>();
		
		private static var _storyConditions:Dictionary;
		
		private static var _boughtShopItems:Dictionary;
		
		private static var _completedCombatEventCounters:Dictionary;
		
		private static var _recurringEnemyPathId:Dictionary;
		
		private static var _mobileEnemyPositionId:Dictionary;
		
		private static var _savePointPartyMembers:Vector.<HeroStats>;
		
		private static var _shouldShowMapTutorial:Boolean = false;
		
		public static var prevHeroPosition:Point;
		
		private static var _shipInitialPosition:Point;
		
		private static var _initialHeroMapColId:int;
		
		private static var _initialHeroMapRowId:int;
		
		private static var _gold:int;
		
		private static var _partySelectionCompleted:Boolean;
		 
		
		public function GamePersistantData()
		{
			super();
		}
		
		public static function get shipInitialPosition() : Point
		{
			return _shipInitialPosition;
		}
		
		public static function get initialHeroMapColId() : int
		{
			return _initialHeroMapColId;
		}
		
		public static function get initialHeroMapRowId() : int
		{
			return _initialHeroMapRowId;
		}
		
		public static function get gold() : int
		{
			return _gold;
		}
		
		public static function get isPartySelectionCompleted() : Boolean
		{
			return _partySelectionCompleted;
		}
		
		public static function addPartyMember(member:Hero) : HeroStats
		{
			var partyMember:HeroStats = null;
			for(var i:int = 0; i < _partyMembers.length; i++)
			{
				if(_partyMembers[i].hero == member)
				{
					return _partyMembers[i];
				}
			}
			partyMember = new HeroStats(member);
			_partyMembers.push(partyMember);
			return partyMember;
		}
		
		public static function setPartySelectionAsCompleted() : void
		{
			_partySelectionCompleted = true;
		}
		
		public static function addGold(value:uint) : void
		{
			_gold = _gold + value;
		}
		
		public static function useGold(value:uint) : Boolean
		{
			if(!hasEnoughGold(value))
			{
				return false;
			}
			_gold = _gold - value;
			return true;
		}
		
		public static function hasEnoughGold(value:uint) : Boolean
		{
			return _gold >= value;
		}
		
		public static function saveHeroMapPosition(tile:Tile) : void
		{
			_initialHeroMapColId = tile.colId;
			_initialHeroMapRowId = tile.rowId;
		}
		
		public static function saveShipMapPosition(colId:uint, rowId:uint) : void
		{
			_shipInitialPosition.x = colId;
			_shipInitialPosition.y = rowId;
		}
		
		public static function getPartyMembers() : Vector.<HeroStats>
		{
			return _partyMembers;
		}
		
		public static function areStoryConditionsMet(ids:Vector.<int>) : Boolean
		{
			for(var i:int = 0; i < ids.length; i++)
			{
				if(!isStoryConditionMet(ids[i]))
				{
					return false;
				}
			}
			return true;
		}
		
		public static function isStoryConditionMet(id:int) : Boolean
		{
			if(id == StoryConditionType.NONE)
			{
				return true;
			}
			if(id == StoryConditionType.NEVER_MET)
			{
				return false;
			}
			if(id == StoryConditionType.DYNAMIC_ALL_PARTY_MEMBERS_ALIVE)
			{
				return isAllPartyAliveConditionMet();
			}
			return _storyConditions[id];
		}
		
		public static function setStoryCondition(id:int, value:Boolean) : void
		{
			if(!checkStoryCondition(id))
			{
				return;
			}
			_storyConditions[id] = value;
		}
		
		public static function setShipNorthDocksStoryCondition(value:Boolean) : void
		{
			_storyConditions[StoryConditionType.DYNAMIC_SHIP_NORTH_DOCKS] = value;
			_storyConditions[StoryConditionType.DYNAMIC_SHIP_SOUTH_DOCKS] = !value;
		}
		
		private static function isAllPartyAliveConditionMet() : Boolean
		{
			for(var i:int = 0; i < _partyMembers.length; i++)
			{
				if(_partyMembers[i].isDead)
				{
					return false;
				}
			}
			return true;
		}
		
		private static function checkStoryCondition(id:int) : Boolean
		{
			if(id <= StoryConditionType.NONE || id > StoryConditionType.MAX_STATIC_CONDITION)
			{
				Log.warn("storyCondition: id=" + id + " can\'t be set!");
				return false;
			}
			return true;
		}
		
		public static function incrementCombatEventCounter(combatEvent:CombatEvent) : void
		{
			if(isCombatEventCompleted(combatEvent))
			{
				_completedCombatEventCounters[combatEvent] = _completedCombatEventCounters[combatEvent] + 1;
			}
			else
			{
				_completedCombatEventCounters[combatEvent] = 1;
			}
		}
		
		public static function isCombatEventCompleted(combatEvent:CombatEvent) : Boolean
		{
			return _completedCombatEventCounters.hasOwnProperty(combatEvent);
		}
		
		public static function getCompletedCombatEventCounter(combatEvent:CombatEvent) : uint
		{
			if(isCombatEventCompleted(combatEvent))
			{
				return _completedCombatEventCounters[combatEvent];
			}
			return 0;
		}
		
		public static function setShopItemAsBought(item:ShopItem) : void
		{
			_boughtShopItems[item] = true;
		}
		
		public static function isShopItemBought(item:ShopItem) : Boolean
		{
			return _boughtShopItems.hasOwnProperty(item);
		}
		
		public static function setRecurringEnemyPathId(enemnyData:MapEnemyData, pathId:uint) : void
		{
			_recurringEnemyPathId[enemnyData] = pathId;
		}
		
		public static function getRecurringEnemyPathId(enemnyData:MapEnemyData) : uint
		{
			if(hasRecurringEnemyPathId(enemnyData))
			{
				return _recurringEnemyPathId[enemnyData];
			}
			return 0;
		}
		
		public static function hasRecurringEnemyPathId(enemnyData:MapEnemyData) : Boolean
		{
			return _recurringEnemyPathId.hasOwnProperty(enemnyData);
		}
		
		public static function setMobileEnemyPositionId(enemnyData:MapEnemyData, positionId:uint) : void
		{
			_mobileEnemyPositionId[enemnyData] = positionId;
		}
		
		public static function getMobileEnemyPositionId(enemnyData:MapEnemyData) : uint
		{
			if(hasMobileEnemyPositionId(enemnyData))
			{
				return _mobileEnemyPositionId[enemnyData];
			}
			return 0;
		}
		
		public static function hasMobileEnemyPositionId(enemnyData:MapEnemyData) : Boolean
		{
			return _mobileEnemyPositionId.hasOwnProperty(enemnyData);
		}
		
		public static function createSavePoint() : void
		{
			_savePointPartyMembers = new Vector.<HeroStats>();
			for(var i:int = 0; i < _partyMembers.length; i++)
			{
				_savePointPartyMembers.push(_partyMembers[i].copy());
			}
		}
		
		public static function restoreSavePoint() : void
		{
			if(_savePointPartyMembers == null)
			{
				throw new Error("There is no savepoint to restore.");
			}
			for(var i:int = 0; i < _savePointPartyMembers.length; i++)
			{
				_partyMembers[i].restore(_savePointPartyMembers[i]);
			}
		}
		
		public static function get shouldShowMapTutorial() : Boolean
		{
			return _shouldShowMapTutorial;
		}
		
		public static function set shouldShowMapTutorial(value:Boolean) : void
		{
			_shouldShowMapTutorial = value;
		}
		
		public static function reset() : void
		{
			_partyMembers = new Vector.<HeroStats>();
			for(var j:int = 0; j < GameDatabase.heroes.length; j++)
			{
				if(GameDatabase.heroes[j].isMandatoryPartyMember)
				{
					addPartyMember(GameDatabase.heroes[j]);
				}
			}
			_partySelectionCompleted = false;
			prevHeroPosition = new Point(0,0);
			_shipInitialPosition = new Point(-1,-1);
			_initialHeroMapColId = -1;
			_initialHeroMapRowId = -1;
			_gold = 0;
			_boughtShopItems = new Dictionary(true);
			_storyConditions = new Dictionary();
			_completedCombatEventCounters = new Dictionary(true);
			_recurringEnemyPathId = new Dictionary(true);
			_mobileEnemyPositionId = new Dictionary(true);
			_savePointPartyMembers = null;
			setShipNorthDocksStoryCondition(false);
		}
	}
}
