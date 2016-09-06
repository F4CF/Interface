package bhvr.data.database
{
	import bhvr.data.StoryConditionType;
	import bhvr.data.SoundList;
	
	public class CombatEvent extends MapEvent
	{
		 
		
		public var rewardEvent:bhvr.data.database.RewardEvent;
		
		public var storyConditionTriggered:int;
		
		public var music:String;
		
		private var _enemies:Vector.<bhvr.data.database.Enemy>;
		
		private var _uid:uint;
		
		private var _name:String;
		
		public function CombatEvent(uid:uint, name:String)
		{
			this._enemies = new Vector.<Enemy>();
			super();
			this._uid = uid;
			this._name = name;
			this.storyConditionTriggered = StoryConditionType.NONE;
			this.music = SoundList.MUSIC_COMBAT_EVENT_SCREEN;
		}
		
		public function get enemies() : Vector.<bhvr.data.database.Enemy>
		{
			return this._enemies;
		}
		
		public function get uid() : uint
		{
			return this._uid;
		}
		
		public function get name() : String
		{
			return this._name;
		}
	}
}
