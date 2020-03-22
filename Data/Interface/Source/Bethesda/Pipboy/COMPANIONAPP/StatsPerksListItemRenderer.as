package Pipboy.COMPANIONAPP
{
	import Shared.AS3.BSScrollingListEntry;
	
	public class StatsPerksListItemRenderer extends PipboyListItemRenderer
	{
		 
		
		public function StatsPerksListItemRenderer()
		{
			super();
		}
		
		override protected function createScrollingListEntry() : BSScrollingListEntry
		{
			return new PerksListEntry();
		}
	}
}
