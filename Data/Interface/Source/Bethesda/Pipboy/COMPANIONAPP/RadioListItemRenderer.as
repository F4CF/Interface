package Pipboy.COMPANIONAPP
{
	import Shared.AS3.BSScrollingListEntry;
	import flash.display.MovieClip;
	
	public class RadioListItemRenderer extends PipboyListItemRenderer
	{
		 
		
		public var EquipIcon_mc:MovieClip;
		
		public function RadioListItemRenderer()
		{
			super();
		}
		
		override protected function createScrollingListEntry() : BSScrollingListEntry
		{
			return new RadioListEntry();
		}
		
		override protected function setupScrollinglistEntry() : *
		{
			super.setupScrollinglistEntry();
			var _loc1_:RadioListEntry = _scrollingListEntry as RadioListEntry;
			_loc1_.EquipIcon_mc = this.EquipIcon_mc;
		}
		
		override protected function setVisual() : void
		{
			super.setVisual();
			this.transform.colorTransform = _scrollingListEntry.transform.colorTransform;
		}
	}
}
