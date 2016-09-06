package
{
	import flash.geom.Point;
	
	public class Pipboy_DataObj
	{
		
		public static const NUM_PAGES:uint = 5;
		
		public static const NUM_SPECIAL:uint = 7;
		 
		
		private var _CurrentPage:uint;
		
		private var _StoredTabs:Vector.<uint>;
		
		private var _PlayerName:String;
		
		private var _ActiveEffects:Array;
		
		private var _StimpakCount:uint;
		
		private var _RadawayCount:uint;
		
		private var _CurrHP:Number;
		
		private var _MaxHP:Number;
		
		private var _CurrAP:Number;
		
		private var _MaxAP:Number;
		
		private var _CurrWeight:Number;
		
		private var _MaxWeight:Number;
		
		private var _CurrentHPGain:Number;
		
		private var _SelectedItemHPGain:Number;
		
		private var _DamageTypes:Array;
		
		private var _ResistTypes:Array;
		
		private var _SlotResists:Array;
		
		private var _UnderwearType:uint;
		
		private var _Caps:uint;
		
		private var _DateMonth:uint;
		
		private var _DateDay:uint;
		
		private var _DateYear:uint;
		
		private var _TimeHour:Number;
		
		private var _CurrLocationName:String;
		
		private var _XPLevel:uint;
		
		private var _XPProgressPct:Number;
		
		private var _InvItems:Array;
		
		private var _InvComponents:Array;
		
		private var _InvFilter:int;
		
		private var _InvSelectedItems:Array;
		
		private var _HolotapePlaying:Boolean;
		
		private var _SortMode:uint;
		
		private var _FavoritesList:Array;
		
		private var _HeadCondition:Number;
		
		private var _TorsoCondition:Number;
		
		private var _LArmCondition:Number;
		
		private var _RArmCondition:Number;
		
		private var _LLegCondition:Number;
		
		private var _RLegCondition:Number;
		
		private var _BodyFlags:uint;
		
		private var _HeadFlags:uint;
		
		private var _SPECIALList:Array;
		
		private var _PerksList:Array;
		
		private var _PerkPoints:uint;
		
		private var _QuestsList:Array;
		
		private var _GeneralStatsList:Array;
		
		private var _WorkshopsList:Array;
		
		private var _WorldMapMarkers:Array;
		
		private var _LocalMapMarkers:Array;
		
		private var _WorldMapTextureName:String;
		
		private var _WorldMapNWCorner:Point;
		
		private var _WorldMapNECorner:Point;
		
		private var _WorldMapSWCorner:Point;
		
		private var _LocalMapNWCorner:Point;
		
		private var _LocalMapNECorner:Point;
		
		private var _LocalMapSWCorner:Point;
		
		private var _RadioList:Array;
		
		private var _ReadOnlyMode:int;
		
		private var _RemovedMapMarkerIds:Array;
		
		private var _RemoveAllMapMarkers:Boolean;
		
		public function Pipboy_DataObj()
		{
			super();
			this._CurrentPage = 0;
			this._StoredTabs = new Vector.<uint>(NUM_PAGES,true);
			var _loc1_:uint = 0;
			while(_loc1_ < this._StoredTabs.length)
			{
				this._StoredTabs[_loc1_] = 0;
				_loc1_++;
			}
			this._ActiveEffects = new Array();
			this._StimpakCount = 0;
			this._RadawayCount = 0;
			this._CurrHP = 0;
			this._MaxHP = 0;
			this._CurrAP = 0;
			this._MaxAP = 0;
			this._CurrWeight = 0;
			this._MaxWeight = 0;
			this._CurrentHPGain = 0;
			this._SelectedItemHPGain = 0;
			this._DamageTypes = new Array();
			this._ResistTypes = new Array();
			this._SlotResists = new Array();
			this._UnderwearType = 0;
			this._Caps = 0;
			this._DateMonth = 0;
			this._DateDay = 0;
			this._DateYear = 0;
			this._TimeHour = 0;
			this._XPLevel = 1;
			this._XPProgressPct = 0;
			this._InvItems = new Array();
			this._InvComponents = new Array();
			this._InvFilter = 0;
			this._InvSelectedItems = new Array();
			this._HolotapePlaying = false;
			this._SortMode = 0;
			this._FavoritesList = new Array();
			this._HeadCondition = 0;
			this._TorsoCondition = 0;
			this._LArmCondition = 0;
			this._RArmCondition = 0;
			this._LLegCondition = 0;
			this._RLegCondition = 0;
			this._BodyFlags = 0;
			this._HeadFlags = 0;
			this._SPECIALList = new Array();
			var _loc2_:uint = 0;
			while(_loc2_ < NUM_SPECIAL)
			{
				this._SPECIALList.push(new Object());
				_loc2_++;
			}
			this._PerksList = new Array();
			this._PerkPoints = 0;
			this._QuestsList = new Array();
			this._GeneralStatsList = new Array();
			this._WorkshopsList = new Array();
			this._WorldMapMarkers = new Array();
			this._LocalMapMarkers = new Array();
			this._WorldMapNWCorner = new Point();
			this._WorldMapNECorner = new Point();
			this._WorldMapSWCorner = new Point();
			this._LocalMapNWCorner = new Point();
			this._LocalMapNECorner = new Point();
			this._LocalMapSWCorner = new Point();
			this._RadioList = new Array();
			this._ReadOnlyMode = 0;
			this._RemovedMapMarkerIds = new Array();
			this._RemoveAllMapMarkers = false;
		}
		
		public function get CurrentPage() : uint
		{
			return this._CurrentPage;
		}
		
		public function get CurrentTab() : uint
		{
			return this._StoredTabs[this._CurrentPage];
		}
		
		public function get PlayerName() : String
		{
			return this._PlayerName;
		}
		
		public function get ActiveEffects() : Array
		{
			return this._ActiveEffects;
		}
		
		public function get StimpakCount() : uint
		{
			return this._StimpakCount;
		}
		
		public function get RadawayCount() : uint
		{
			return this._RadawayCount;
		}
		
		public function get CurrHP() : Number
		{
			return this._CurrHP;
		}
		
		public function get MaxHP() : Number
		{
			return this._MaxHP;
		}
		
		public function get CurrAP() : Number
		{
			return this._CurrAP;
		}
		
		public function get MaxAP() : Number
		{
			return this._MaxAP;
		}
		
		public function get CurrWeight() : Number
		{
			return this._CurrWeight;
		}
		
		public function get MaxWeight() : Number
		{
			return this._MaxWeight;
		}
		
		public function get CurrentHPGain() : Number
		{
			return this._CurrentHPGain;
		}
		
		public function get SelectedItemHPGain() : Number
		{
			return this._SelectedItemHPGain;
		}
		
		public function get TotalDamages() : Array
		{
			return this._DamageTypes;
		}
		
		public function get TotalResists() : Array
		{
			return this._ResistTypes;
		}
		
		public function get SlotResists() : Array
		{
			return this._SlotResists;
		}
		
		public function get UnderwearType() : uint
		{
			return this._UnderwearType;
		}
		
		public function get Caps() : uint
		{
			return this._Caps;
		}
		
		public function get DateMonth() : uint
		{
			return this._DateMonth;
		}
		
		public function get DateDay() : uint
		{
			return this._DateDay;
		}
		
		public function get DateYear() : uint
		{
			return this._DateYear;
		}
		
		public function get TimeHour() : Number
		{
			return this._TimeHour;
		}
		
		public function get CurrLocationName() : String
		{
			return this._CurrLocationName;
		}
		
		public function get XPLevel() : uint
		{
			return this._XPLevel;
		}
		
		public function get XPProgressPct() : Number
		{
			return this._XPProgressPct;
		}
		
		public function get InvItems() : Array
		{
			return this._InvItems;
		}
		
		public function get InvComponents() : Array
		{
			return this._InvComponents;
		}
		
		public function get InvFilter() : int
		{
			return this._InvFilter;
		}
		
		public function get InvSelectedItems() : Array
		{
			return this._InvSelectedItems;
		}
		
		public function get HolotapePlaying() : Boolean
		{
			return this._HolotapePlaying;
		}
		
		public function get SortMode() : uint
		{
			return this._SortMode;
		}
		
		public function get FavoritesList() : Array
		{
			return this._FavoritesList;
		}
		
		public function get HeadCondition() : Number
		{
			return this._HeadCondition;
		}
		
		public function get TorsoCondition() : Number
		{
			return this._TorsoCondition;
		}
		
		public function get LArmCondition() : Number
		{
			return this._LArmCondition;
		}
		
		public function get RArmCondition() : Number
		{
			return this._RArmCondition;
		}
		
		public function get LLegCondition() : Number
		{
			return this._LLegCondition;
		}
		
		public function get RLegCondition() : Number
		{
			return this._RLegCondition;
		}
		
		public function get BodyFlags() : uint
		{
			return this._BodyFlags;
		}
		
		public function get HeadFlags() : uint
		{
			return this._HeadFlags;
		}
		
		public function get SPECIALList() : Array
		{
			return this._SPECIALList;
		}
		
		public function get PerksList() : Array
		{
			return this._PerksList;
		}
		
		public function get PerkPoints() : uint
		{
			return this._PerkPoints;
		}
		
		public function get QuestsList() : Array
		{
			return this._QuestsList;
		}
		
		public function get GeneralStatsList() : Array
		{
			return this._GeneralStatsList;
		}
		
		public function get WorkshopsList() : Array
		{
			return this._WorkshopsList;
		}
		
		public function get WorldMapMarkers() : Array
		{
			return this._WorldMapMarkers;
		}
		
		public function get LocalMapMarkers() : Array
		{
			return this._LocalMapMarkers;
		}
		
		public function get WorldMapTextureName() : String
		{
			return this._WorldMapTextureName;
		}
		
		public function get WorldMapNWCorner() : Point
		{
			return this._WorldMapNWCorner;
		}
		
		public function get WorldMapNECorner() : Point
		{
			return this._WorldMapNECorner;
		}
		
		public function get WorldMapSWCorner() : Point
		{
			return this._WorldMapSWCorner;
		}
		
		public function get LocalMapNWCorner() : Point
		{
			return this._LocalMapNWCorner;
		}
		
		public function get LocalMapNECorner() : Point
		{
			return this._LocalMapNECorner;
		}
		
		public function get LocalMapSWCorner() : Point
		{
			return this._LocalMapSWCorner;
		}
		
		public function get RadioList() : Array
		{
			return this._RadioList;
		}
		
		public function get ReadOnlyMode() : int
		{
			return this._ReadOnlyMode;
		}
		
		public function get RemovedMapMarkerIds() : Array
		{
			return this._RemovedMapMarkerIds;
		}
		
		public function get RemoveAllMapMarkers() : Boolean
		{
			return this._RemoveAllMapMarkers;
		}
		
		public function set CurrentPage(param1:uint) : *
		{
			if(param1 < NUM_PAGES && param1 != this._CurrentPage)
			{
				this._CurrentPage = param1;
			}
		}
		
		public function set CurrentTab(param1:uint) : *
		{
			if(param1 != this._StoredTabs[this._CurrentPage])
			{
				this._StoredTabs[this._CurrentPage] = param1;
			}
		}
		
		public function set PlayerName(param1:String) : *
		{
			this._PlayerName = param1;
		}
		
		public function set StimpakCount(param1:uint) : *
		{
			this._StimpakCount = param1;
		}
		
		public function set RadawayCount(param1:uint) : *
		{
			this._RadawayCount = param1;
		}
		
		public function set CurrHP(param1:Number) : *
		{
			this._CurrHP = param1;
		}
		
		public function set MaxHP(param1:Number) : *
		{
			this._MaxHP = param1;
		}
		
		public function set CurrAP(param1:Number) : *
		{
			this._CurrAP = param1;
		}
		
		public function set MaxAP(param1:Number) : *
		{
			this._MaxAP = param1;
		}
		
		public function set CurrWeight(param1:Number) : *
		{
			this._CurrWeight = param1;
		}
		
		public function set MaxWeight(param1:Number) : *
		{
			this._MaxWeight = param1;
		}
		
		public function set CurrentHPGain(param1:Number) : *
		{
			this._CurrentHPGain = param1;
		}
		
		public function set SelectedItemHPGain(param1:Number) : *
		{
			this._SelectedItemHPGain = param1;
		}
		
		public function set DateMonth(param1:uint) : *
		{
			this._DateMonth = param1;
		}
		
		public function set DateDay(param1:uint) : *
		{
			this._DateDay = param1;
		}
		
		public function set DateYear(param1:uint) : *
		{
			this._DateYear = param1;
		}
		
		public function set TimeHour(param1:Number) : *
		{
			this._TimeHour = param1;
		}
		
		public function set CurrLocationName(param1:String) : *
		{
			this._CurrLocationName = param1;
		}
		
		public function set UnderwearType(param1:uint) : *
		{
			this._UnderwearType = param1;
		}
		
		public function set Caps(param1:uint) : *
		{
			this._Caps = param1;
		}
		
		public function set XPLevel(param1:uint) : *
		{
			this._XPLevel = param1;
		}
		
		public function set XPProgressPct(param1:Number) : *
		{
			this._XPProgressPct = param1;
		}
		
		public function set InvItems(param1:Array) : *
		{
			this._InvItems = param1;
		}
		
		public function set InvFilter(param1:int) : *
		{
			this._InvFilter = param1;
		}
		
		public function set HolotapePlaying(param1:Boolean) : *
		{
			this._HolotapePlaying = param1;
		}
		
		public function set SortMode(param1:uint) : *
		{
			this._SortMode = param1;
		}
		
		public function set HeadCondition(param1:Number) : *
		{
			this._HeadCondition = param1;
		}
		
		public function set TorsoCondition(param1:Number) : *
		{
			this._TorsoCondition = param1;
		}
		
		public function set LArmCondition(param1:Number) : *
		{
			this._LArmCondition = param1;
		}
		
		public function set RArmCondition(param1:Number) : *
		{
			this._RArmCondition = param1;
		}
		
		public function set LLegCondition(param1:Number) : *
		{
			this._LLegCondition = param1;
		}
		
		public function set RLegCondition(param1:Number) : *
		{
			this._RLegCondition = param1;
		}
		
		public function set BodyFlags(param1:uint) : *
		{
			this._BodyFlags = param1;
		}
		
		public function set HeadFlags(param1:uint) : *
		{
			this._HeadFlags = param1;
		}
		
		public function set PerkPoints(param1:uint) : *
		{
			this._PerkPoints = param1;
		}
		
		public function set WorldMapTextureName(param1:String) : *
		{
			this._WorldMapTextureName = param1;
		}
		
		public function set ReadOnlyMode(param1:int) : *
		{
			this._ReadOnlyMode = param1;
		}
		
		public function set RemoveAllMapMarkers(param1:Boolean) : *
		{
			this._RemoveAllMapMarkers = param1;
		}
	}
}
