package
{
	import Shared.AS3.BSScrollingList;
	import Shared.AS3.BSScrollingListEntry;
	
	public class PropertyModList extends BSScrollingList
	{
		 
		
		public var comparisonArray:Array;
		
		public function PropertyModList()
		{
			super();
			this.comparisonArray = new Array();
		}
		
		override protected function SetEntry(param1:BSScrollingListEntry, param2:Object) : *
		{
			var _loc3_:uint = 0;
			if(param1 != null)
			{
				param1.selected = param2 == selectedEntry;
				if(this["comparisonArray"] != undefined)
				{
					_loc3_ = 0;
					while(_loc3_ < this["comparisonArray"].length)
					{
						if(this["comparisonArray"][_loc3_].name == param2.name)
						{
							param2.comparisonObj = this["comparisonArray"][_loc3_];
							break;
						}
						_loc3_++;
					}
				}
				param1.SetEntryText(param2,strTextOption);
			}
		}
	}
}
