package
{
	import Shared.AS3.BSScrollingListEntry;
	import Shared.GlobalFunc;
	
	public class CaravanListEntry extends BSScrollingListEntry
	{
		 
		
		public function CaravanListEntry()
		{
			super();
		}
		
		override public function SetEntryText(param1:Object, param2:String) : *
		{
			super.SetEntryText(param1,param2);
			if(!param1.selected)
			{
				textField.alpha = !!param1.disabled?Number(GlobalFunc.DIMMED_ALPHA * 0.5):Number(1);
			}
			else
			{
				textField.alpha = 1;
			}
		}
	}
}
