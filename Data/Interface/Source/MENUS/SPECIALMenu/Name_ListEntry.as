package
{
	import Shared.AS3.BSScrollingListEntry;
	import flash.text.TextField;
	
	public class Name_ListEntry extends BSScrollingListEntry
	{
		 
		
		public var Name_tf:TextField;
		
		public function Name_ListEntry()
		{
			super();
		}
		
		override public function SetEntryText(param1:Object, param2:String) : *
		{
			super.SetEntryText(param1,param2);
			this.Name_tf.textColor = !!this.selected?uint(0):uint(16777215);
		}
	}
}
