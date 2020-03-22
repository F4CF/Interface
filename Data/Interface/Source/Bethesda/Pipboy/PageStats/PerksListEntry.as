package
{
	import Shared.AS3.BSScrollingListEntry;
	
	public class PerksListEntry extends BSScrollingListEntry
	{
		 
		
		public function PerksListEntry()
		{
			super();
		}
		
		override public function SetEntryText(param1:Object, param2:String) : *
		{
			super.SetEntryText(param1,param2);
			if(param1.rank > 1)
			{
				textField.appendText(" (" + param1.rank + ")");
			}
		}
	}
}
