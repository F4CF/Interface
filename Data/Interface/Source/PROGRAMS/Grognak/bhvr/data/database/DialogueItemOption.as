package bhvr.data.database
{
	public class DialogueItemOption extends DialogueOption
	{
		 
		
		private var _item:bhvr.data.database.ShopItem;
		
		public function DialogueItemOption(item:bhvr.data.database.ShopItem)
		{
			super(item.shopName);
			this._item = item;
		}
		
		public function get item() : bhvr.data.database.ShopItem
		{
			return this._item;
		}
		
		public function copy() : DialogueItemOption
		{
			var dialogueItemOption:DialogueItemOption = null;
			dialogueItemOption = new DialogueItemOption(this._item);
			dialogueItemOption.price = price;
			dialogueItemOption.storyConditionTriggered = storyConditionTriggered;
			dialogueItemOption.combatEvent = combatEvent;
			dialogueItemOption.nextDialogueTree = nextDialogueTree;
			dialogueItemOption.soundEvent = soundEvent;
			return dialogueItemOption;
		}
	}
}
