package Pipboy.COMPANIONAPP
{
	import Shared.AS3.BSScrollingListEntry;
	import flash.display.MovieClip;
	
	public class QuestsListItemRenderer extends PipboyListItemRenderer
	{
		 
		
		public var EquipIcon_mc:MovieClip;
		
		public function QuestsListItemRenderer()
		{
			super();
		}
		
		override protected function createScrollingListEntry() : BSScrollingListEntry
		{
			return new QuestsListEntry();
		}
		
		override protected function setupScrollinglistEntry() : *
		{
			super.setupScrollinglistEntry();
			var _loc1_:QuestsListEntry = _scrollingListEntry as QuestsListEntry;
			_loc1_.Container_mc = this;
			_loc1_.EquipIcon_mc = this.EquipIcon_mc;
		}
		
		override protected function setVisual() : void
		{
			super.setVisual();
			_data.clickable = !_data.isDivider;
		}
	}
}
