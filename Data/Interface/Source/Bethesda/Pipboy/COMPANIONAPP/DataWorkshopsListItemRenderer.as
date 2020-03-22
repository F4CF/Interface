package Pipboy.COMPANIONAPP
{
	import Shared.AS3.BSScrollingListEntry;
	import flash.display.MovieClip;
	
	public class DataWorkshopsListItemRenderer extends PipboyListItemRenderer
	{
		 
		
		public var AlertIcon_mc:MovieClip;
		
		public function DataWorkshopsListItemRenderer()
		{
			super();
		}
		
		override protected function createScrollingListEntry() : BSScrollingListEntry
		{
			return new WorkshopsListEntry();
		}
		
		override protected function setupScrollinglistEntry() : *
		{
			super.setupScrollinglistEntry();
			var _loc1_:WorkshopsListEntry = _scrollingListEntry as WorkshopsListEntry;
			_loc1_.AlertIcon_mc = this.AlertIcon_mc;
		}
	}
}
