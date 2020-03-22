package Pipboy.COMPANIONAPP
{
	import Mobile.ScrollList.MobileListItemRenderer;
	import Shared.AS3.BSScrollingListEntry;
	import flash.display.MovieClip;
	
	public class PipboyListItemRenderer extends MobileListItemRenderer
	{
		 
		
		public var border:MovieClip;
		
		protected var ORIG_BORDER_HEIGHT:Number;
		
		protected var _scrollingListEntry:BSScrollingListEntry;
		
		public function PipboyListItemRenderer()
		{
			super();
			this.ORIG_BORDER_HEIGHT = this.border != null?Number(this.border.height):Number(0);
			this._scrollingListEntry = this.createScrollingListEntry();
			this.setupScrollinglistEntry();
		}
		
		protected function createScrollingListEntry() : BSScrollingListEntry
		{
			return new BSScrollingListEntry();
		}
		
		protected function setupScrollinglistEntry() : *
		{
			this._scrollingListEntry.textField = textField;
			this._scrollingListEntry.border = this.border;
			this._scrollingListEntry.ORIG_BORDER_HEIGHT = this.ORIG_BORDER_HEIGHT;
		}
		
		override public function reset() : void
		{
			super.reset();
			this._scrollingListEntry.selected = false;
		}
		
		override protected function setVisual() : void
		{
			this._scrollingListEntry.SetEntryText(_data,_data.textOption);
			if(this._scrollingListEntry.border.height == 0)
			{
				this._scrollingListEntry.border.height = this.ORIG_BORDER_HEIGHT;
			}
		}
		
		override public function selectItem() : void
		{
			this._scrollingListEntry.selected = true;
			if(data != null)
			{
				this.setVisual();
			}
		}
		
		override public function unselectItem() : void
		{
			this._scrollingListEntry.selected = false;
			if(data != null)
			{
				this.setVisual();
			}
		}
		
		override public function pressItem() : void
		{
		}
	}
}
