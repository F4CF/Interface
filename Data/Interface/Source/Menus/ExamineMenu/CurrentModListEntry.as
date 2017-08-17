package
{
	import Shared.AS3.BSScrollingListEntry;
	import scaleform.gfx.Extensions;
	import scaleform.gfx.TextFieldEx;
	
	public class CurrentModListEntry extends BSScrollingListEntry
	{
		 
		
		public function CurrentModListEntry()
		{
			super();
			Extensions.enabled = true;
			TextFieldEx.setTextAutoSize(textField,"shrink");
		}
	}
}
