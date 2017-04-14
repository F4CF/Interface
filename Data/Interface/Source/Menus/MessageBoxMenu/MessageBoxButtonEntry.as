package
{
	import Shared.AS3.BSScrollingList;
	import Shared.AS3.BSScrollingListEntry;
	
	public class MessageBoxButtonEntry extends BSScrollingListEntry
	{
		 
		
		public function MessageBoxButtonEntry()
		{
			super();
		}
		
		public function CalculateBorderWidth() : Number
		{
			return textField.getLineMetrics(0).width + 30;
		}
		
		public function SetBorderWidth(param1:Number) : *
		{
			border.width = param1;
			border.x = textField.getLineMetrics(0).x - (border.width - textField.getLineMetrics(0).width) / 2 + 2.5;
		}
		
		override public function SetEntryText(param1:Object, param2:String) : *
		{
			super.SetEntryText(param1,BSScrollingList.TEXT_OPTION_MULTILINE);
		}
	}
}
