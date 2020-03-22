package
{
	import Shared.AS3.BSScrollingListEntry;
	import Shared.GlobalFunc;
	import flash.text.TextField;
	
	public class Stats_ValuesListEntry extends BSScrollingListEntry
	{
		 
		
		public var Value_tf:TextField;
		
		public function Stats_ValuesListEntry()
		{
			super();
		}
		
		override public function SetEntryText(param1:Object, param2:String) : *
		{
			super.SetEntryText(param1,param2);
			GlobalFunc.SetText(this.Value_tf,param1.value,false);
			border.alpha = 1;
		}
	}
}
