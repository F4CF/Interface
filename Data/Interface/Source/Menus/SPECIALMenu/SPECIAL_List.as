package
{
	import Shared.AS3.BSScrollingList;
	import Shared.AS3.BSScrollingListEntry;
	
	public class SPECIAL_List extends BSScrollingList
	{
		 
		
		public function SPECIAL_List()
		{
			super();
		}
		
		override protected function GetNewListEntry(param1:uint) : BSScrollingListEntry
		{
			if(param1 == 0)
			{
				return new Name_ListEntry() as BSScrollingListEntry;
			}
			return new SPECIAL_ListEntry() as BSScrollingListEntry;
		}
	}
}
