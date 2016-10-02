package bhvr.data.database
{
	import bhvr.data.SoundList;
	import bhvr.data.StoryConditionType;
	
	public class InteractionEvent extends MapEvent
	{
		 
		
		public var npc:bhvr.data.database.NPC;
		
		public var npcPresenceStoryConditions:Vector.<int>;
		
		public var dialogueTree:bhvr.data.database.DialogueTree;
		
		public var music:String;
		
		public function InteractionEvent()
		{
			this.npcPresenceStoryConditions = new Vector.<int>();
			super();
			this.music = SoundList.MUSIC_INTERACTION_EVENT_SCREEN;
			this.addPresenceStoryCondition(StoryConditionType.NONE);
		}
		
		public function addPresenceStoryCondition(storyCondition:int) : void
		{
			this.npcPresenceStoryConditions.push(storyCondition);
		}
	}
}
