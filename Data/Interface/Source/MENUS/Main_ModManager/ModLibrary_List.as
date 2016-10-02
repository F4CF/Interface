package
{
	import Shared.AS3.BSScrollingList;
	
	public class ModLibrary_List extends BSScrollingList
	{
		 
		
		public function ModLibrary_List()
		{
			super();
		}
		
		public function MoveReorderUp() : *
		{
			var _loc1_:Object = EntriesA.splice(this.selectedIndex,1)[0];
			EntriesA.splice(this.selectedIndex - 1,0,_loc1_);
			if(this.selectedClipIndex == 0)
			{
				iScrollPosition--;
			}
			else
			{
				iSelectedClipIndex--;
			}
			if(iSelectedIndex > 0)
			{
				iSelectedIndex--;
			}
			InvalidateData();
		}
		
		public function MoveReorderDown() : *
		{
			var _loc1_:Object = EntriesA.splice(this.selectedIndex,1)[0];
			EntriesA.splice(this.selectedIndex + 1,0,_loc1_);
			if(this.selectedClipIndex == uiNumListItems - 1)
			{
				iScrollPosition++;
			}
			else
			{
				iSelectedClipIndex++;
			}
			if(iSelectedIndex < EntriesA.length - 1)
			{
				iSelectedIndex++;
			}
			InvalidateData();
		}
	}
}
