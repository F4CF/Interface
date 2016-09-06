package bhvr.data.database.creators.bases
{
	import bhvr.data.database.creators.contexts.DialogueTreeCreatorContext;
	import bhvr.data.database.DialogueTree;
	import flash.utils.Dictionary;
	
	public class BaseDialogueDataCreator extends BaseDataCreator
	{
		 
		
		public function BaseDialogueDataCreator(sharedData:Dictionary)
		{
			super(sharedData);
		}
		
		public function tree(id:String) : DialogueTreeCreatorContext
		{
			var obj:DialogueTree = new DialogueTree();
			addObjectToSharedData(id,obj);
			return new DialogueTreeCreatorContext(this,obj);
		}
	}
}
