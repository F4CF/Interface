package
{
	import Shared.AS3.BSScrollingList;
	import Shared.AS3.BSScrollingListEntry;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	
	public class ItemSelectList extends BSScrollingList
	{
		 
		
		public var FilterCount:uint = 0;
		
		public var CategoryNameList:Array;
		
		public function ItemSelectList()
		{
			this.CategoryNameList = new Array();
			super();
			addEventListener(KeyboardEvent.KEY_DOWN,onKeyDown);
			addEventListener(BSScrollingList.LIST_ITEMS_CREATED,this.onListCreate);
		}
		
		public function onListCreate(param1:Event) : *
		{
		}
		
		public function InitList(param1:uint, param2:uint) : *
		{
			this.FilterCount = param1;
			filterer.itemFilter = 1 << param2;
			InvalidateData();
		}
		
		public function SetFilter(param1:uint) : *
		{
			filterer.itemFilter = 1 << param1;
			InvalidateData();
		}
		
		public function GrabFocus() : *
		{
			stage.focus = this;
			stage.stageFocusRect = false;
			selectedIndex = 0;
		}
		
		public function RemoveSelection() : *
		{
			selectedIndex = -1;
		}
		
		public function RefreshList() : *
		{
			InvalidateData();
		}
		
		override protected function SetEntry(param1:BSScrollingListEntry, param2:Object) : *
		{
			param2.filterIndex = Math.log(filterer.itemFilter) / Math.log(2);
			super.SetEntry(param1,param2);
		}
		
		override protected function doSetSelectedIndex(param1:int) : *
		{
			if(param1 != selectedIndex)
			{
				MovieClip(root).BaseInstance.BGSCodeObj.PlaySound("UIMenuFocus");
			}
			super.doSetSelectedIndex(param1);
		}
	}
}
