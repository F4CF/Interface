package
{
	import Shared.AS3.BSScrollingList;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	public class ItemList extends BSScrollingList
	{
		
		public static const MOUSE_OVER:String = "ItemList::mouse_over";
		 
		
		public var TransferArrow_mc:MovieClip;
		
		public var ScrollUp_mc:MovieClip;
		
		public var ScrollDown_mc:MovieClip;
		
		public function ItemList()
		{
			super();
			if(this.TransferArrow_mc != null)
			{
				this.TransferArrow_mc.visible = false;
			}
			addEventListener(MouseEvent.MOUSE_OVER,this.onMouseOver);
			addEventListener(BSScrollingList.SELECTION_CHANGE,this.onSelectionChange);
		}
		
		private function onSelectionChange(param1:Event) : *
		{
			if(this.TransferArrow_mc != null)
			{
				if(this.selectedIndex == -1)
				{
					this.TransferArrow_mc.visible = false;
				}
				else
				{
					this.TransferArrow_mc.y = GetClipByIndex(this.selectedEntry.clipIndex).y;
					this.TransferArrow_mc.visible = true;
				}
			}
		}
		
		private function onMouseOver(param1:MouseEvent) : *
		{
			dispatchEvent(new Event(MOUSE_OVER,true,true));
		}
	}
}
