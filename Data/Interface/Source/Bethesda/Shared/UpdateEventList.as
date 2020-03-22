package Shared
{
	import flash.events.Event;
	import Shared.AS3.BSScrollingList;

	public class UpdateEventList extends BSScrollingList
	{

		// UpdateEventList
		//---------------------------------------------

		public function UpdateEventList()
		{
			super();
		}


		// Functions
		//---------------------------------------------

		public function RequestUpdate(index:uint):*
		{
			if(stage.focus == this)
			{
				if(selectedIndex == index)
				{
					dispatchEvent(new Event("ListUpdated", true, true));
				}
				else
				{
					selectedIndex = index;
				}
				InvalidateData();
			}
		}


		override protected function doSetSelectedIndex(index:int):*
		{
			var condition:* = index != selectedIndex;
			super.doSetSelectedIndex(index);
			if(condition)
			{
				dispatchEvent(new Event("ListUpdated", true, true));
			}
		}


	}
}
