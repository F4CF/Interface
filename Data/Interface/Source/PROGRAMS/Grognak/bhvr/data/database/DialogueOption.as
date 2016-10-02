package bhvr.data.database
{
	import bhvr.data.StoryConditionType;
	import bhvr.manager.SoundManager;
	
	public class DialogueOption
	{
		 
		
		public var price:uint;
		
		public var storyConditionTriggered:int;
		
		public var combatEvent:bhvr.data.database.CombatEvent;
		
		public var nextDialogueTree:bhvr.data.database.DialogueTree;
		
		public var needShipTravel:Boolean;
		
		public var soundEvent:String;
		
		private var _text:String;
		
		public function DialogueOption(text:String)
		{
			super();
			this._text = text;
			this.storyConditionTriggered = StoryConditionType.NONE;
			this.needShipTravel = false;
			this.soundEvent = SoundManager.NO_SOUND;
		}
		
		public function get text() : String
		{
			return this._text;
		}
	}
}
