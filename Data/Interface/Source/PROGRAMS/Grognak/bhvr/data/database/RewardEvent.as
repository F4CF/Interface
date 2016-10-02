package bhvr.data.database
{
	import bhvr.data.SoundList;
	
	public class RewardEvent extends MapEvent
	{
		 
		
		public var gold:int;
		
		public var item:bhvr.data.database.BaseItem;
		
		public var endMessage:String;
		
		public var music:String;
		
		public function RewardEvent()
		{
			super();
			this.music = SoundList.MUSIC_REWARD_EVENT_SCREEN;
		}
	}
}
