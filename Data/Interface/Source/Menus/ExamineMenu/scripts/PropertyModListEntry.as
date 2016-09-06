package
{
	import Shared.AS3.BSScrollingListEntry;
	
	public class PropertyModListEntry extends BSScrollingListEntry
	{
		 
		
		public function PropertyModListEntry()
		{
			super();
		}
		
		override public function SetEntryText(param1:Object, param2:String) : *
		{
			param1.text = param1.name;
			super.SetEntryText(param1,param2);
		}
	}
}
