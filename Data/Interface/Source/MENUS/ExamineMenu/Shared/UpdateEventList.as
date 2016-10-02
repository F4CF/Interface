package Shared
{
	import Shared.AS3.BSScrollingList;
	import flash.events.Event;
	
	public class UpdateEventList extends BSScrollingList
	{
		 
		
		public function UpdateEventList()
		{
			super();
		}
		
		public function RequestUpdate(param1:uint) : *
		{
			if(stage.focus == this)
			{
				if(selectedIndex == param1)
				{
					dispatchEvent(new Event("ListUpdated",true,true));
				}
				else
				{
					selectedIndex = param1;
				}
				InvalidateData();
			}
		}
		
		override protected function doSetSelectedIndex(param1:int) : *
		{
			var _loc2_:* = param1 != selectedIndex;
			super.doSetSelectedIndex(param1);
			if(_loc2_)
			{
				dispatchEvent(new Event("ListUpdated",true,true));
			}
		}
	}
}
