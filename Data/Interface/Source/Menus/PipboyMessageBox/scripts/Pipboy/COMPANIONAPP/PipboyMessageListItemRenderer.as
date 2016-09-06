package Pipboy.COMPANIONAPP
{
	import Shared.AS3.BSScrollingListEntry;
	import Shared.GlobalFunc;
	
	public class PipboyMessageListItemRenderer extends PipboyListItemRenderer
	{
		 
		
		public function PipboyMessageListItemRenderer()
		{
			super();
		}
		
		override protected function createScrollingListEntry() : BSScrollingListEntry
		{
			return new MessageBoxButtonEntry();
		}
		
		override public function pressItem() : void
		{
			border.alpha = GlobalFunc.SELECTED_RECT_ALPHA;
			textField.textColor = 0;
		}
		
		override public function selectItem() : void
		{
			_scrollingListEntry.selected = false;
			if(data != null)
			{
				setVisual();
			}
		}
		
		override public function unselectItem() : void
		{
			_scrollingListEntry.selected = false;
			if(data != null)
			{
				setVisual();
			}
		}
	}
}
