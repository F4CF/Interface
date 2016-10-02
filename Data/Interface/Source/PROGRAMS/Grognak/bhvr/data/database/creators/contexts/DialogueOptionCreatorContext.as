package bhvr.data.database.creators.contexts
{
	import bhvr.data.database.creators.bases.BaseDialogueDataCreator;
	import bhvr.data.database.DialogueOption;
	import bhvr.data.database.CombatEvent;
	import bhvr.data.database.DialogueTree;
	
	public class DialogueOptionCreatorContext
	{
		 
		
		protected var _dialogueCreator:BaseDialogueDataCreator;
		
		protected var _dialogueTreeCreatorContext:bhvr.data.database.creators.contexts.DialogueTreeCreatorContext;
		
		private var _option:DialogueOption;
		
		public function DialogueOptionCreatorContext(dialogueCreator:BaseDialogueDataCreator, option:DialogueOption)
		{
			super();
			this._dialogueCreator = dialogueCreator;
			this._option = option;
		}
		
		public function withPrice(value:uint) : DialogueOptionCreatorContext
		{
			this._option.price = value;
			return this;
		}
		
		public function thatTriggersStoryCondition(storyCondition:uint) : DialogueOptionCreatorContext
		{
			this._option.storyConditionTriggered = storyCondition;
			return this;
		}
		
		public function thatTriggersCombat(combatEventId:String) : DialogueOptionCreatorContext
		{
			this._option.combatEvent = this._dialogueCreator.getObjectFromSharedData(combatEventId,CombatEvent) as CombatEvent;
			return this;
		}
		
		public function thatTriggersShipTravel() : DialogueOptionCreatorContext
		{
			this._option.needShipTravel = true;
			return this;
		}
		
		public function thatTriggersSound(soundEvent:String) : DialogueOptionCreatorContext
		{
			this._option.soundEvent = soundEvent;
			return this;
		}
		
		public function dialogue(text:String, ... rest) : DialogueCreatorContext
		{
			var combinedRest:Array = this.prepareDialogue(text,rest);
			return this._dialogueTreeCreatorContext.dialogue.apply(this._dialogueTreeCreatorContext,combinedRest);
		}
		
		public function inventoryDialogue(text:String, ... rest) : InventoryDialogueCreatorContext
		{
			var combinedRest:Array = this.prepareDialogue(text,rest);
			return this._dialogueTreeCreatorContext.inventoryDialogue.apply(this._dialogueTreeCreatorContext,combinedRest);
		}
		
		private function prepareDialogue(text:String, conditions:Array) : Array
		{
			var combinedRest:Array = conditions.concat();
			if(!this._option.nextDialogueTree)
			{
				this._option.nextDialogueTree = new DialogueTree();
				this._dialogueTreeCreatorContext = new bhvr.data.database.creators.contexts.DialogueTreeCreatorContext(this._dialogueCreator,this._option.nextDialogueTree);
			}
			combinedRest.unshift(text);
			return combinedRest;
		}
	}
}
