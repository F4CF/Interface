package bhvr.data
{
	public class StoryConditionType
	{
		
		public static const NONE:int = -1;
		
		public static const CONJURER_MET:int = 0;
		
		public static const LIGHTHOUSE_KEY:int = 1;
		
		public static const LIGHTHOUSE_ON:int = 2;
		
		public static const PASSAGE_SHIP:int = 3;
		
		public static const DAWNSTAR_LOCKET:int = 4;
		
		public static const TOME_DUSKBORN:int = 5;
		
		public static const BRIDGE_LOWERED:int = 6;
		
		public static const CONJURER_REVELATION:int = 7;
		
		public static const DEFEAT_DREAD_WRAITH:int = 8;
		
		public static const DEFEAT_SKULLPOCALYPSE:int = 9;
		
		public static const MAX_STATIC_CONDITION:int = DEFEAT_SKULLPOCALYPSE;
		
		public static const DYNAMIC_ALL_PARTY_MEMBERS_ALIVE:int = MAX_STATIC_CONDITION + 1;
		
		public static const DYNAMIC_SHIP_SOUTH_DOCKS:int = MAX_STATIC_CONDITION + 2;
		
		public static const DYNAMIC_SHIP_NORTH_DOCKS:int = MAX_STATIC_CONDITION + 3;
		
		public static const NEVER_MET:int = int.MAX_VALUE;
		 
		
		public function StoryConditionType()
		{
			super();
		}
	}
}
