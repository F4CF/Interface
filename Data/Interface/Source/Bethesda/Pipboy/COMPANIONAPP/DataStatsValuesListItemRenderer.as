package Pipboy.COMPANIONAPP
{
	import Shared.AS3.BSScrollingListEntry;
	import flash.text.TextField;
	
	public class DataStatsValuesListItemRenderer extends PipboyListItemRenderer
	{
		 
		
		public var Value_tf:TextField;
		
		public function DataStatsValuesListItemRenderer()
		{
			super();
		}
		
		override protected function createScrollingListEntry() : BSScrollingListEntry
		{
			return new Stats_ValuesListEntry();
		}
		
		override protected function setupScrollinglistEntry() : *
		{
			super.setupScrollinglistEntry();
			var _loc1_:Stats_ValuesListEntry = _scrollingListEntry as Stats_ValuesListEntry;
			_loc1_.Value_tf = this.Value_tf;
		}
	}
}
