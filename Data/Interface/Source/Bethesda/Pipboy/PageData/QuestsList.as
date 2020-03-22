package
{
	import Shared.AS3.BSScrollingList;
	import Shared.AS3.BSScrollingListEntry;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	public class QuestsList extends BSScrollingList
	{
		 
		
		public function QuestsList()
		{
			super();
		}
		
		override public function onEntryRollover(param1:Event) : *
		{
			var _loc2_:* = undefined;
			bMouseDrivenNav = true;
			if(!bDisableInput && EntriesA[(param1.currentTarget as BSScrollingListEntry).itemIndex].isDivider != true)
			{
				_loc2_ = iSelectedIndex;
				doSetSelectedIndex((param1.currentTarget as BSScrollingListEntry).itemIndex);
				if(_loc2_ != iSelectedIndex)
				{
					dispatchEvent(new Event(PLAY_FOCUS_SOUND,true,true));
				}
			}
		}
		
		override public function onEntryPress(param1:MouseEvent) : *
		{
			param1.stopPropagation();
			bMouseDrivenNav = true;
			if(this.selectedEntry.isDivider != true)
			{
				onItemPress();
			}
		}
		
		override public function moveSelectionUp() : *
		{
			var _loc1_:Number = NaN;
			if(!bDisableSelection)
			{
				if(selectedIndex > 0)
				{
					_loc1_ = _filterer.GetPrevFilterMatch(selectedIndex);
					if(EntriesA[_loc1_].isDivider == true)
					{
						_loc1_ = _filterer.GetPrevFilterMatch(_loc1_);
					}
					if(_loc1_ != int.MAX_VALUE)
					{
						selectedIndex = _loc1_;
						bMouseDrivenNav = false;
						dispatchEvent(new Event(PLAY_FOCUS_SOUND,true,true));
					}
				}
			}
			else
			{
				scrollPosition = scrollPosition - 1;
			}
		}
		
		override public function moveSelectionDown() : *
		{
			var _loc1_:Number = NaN;
			if(!bDisableSelection)
			{
				if(selectedIndex < EntriesA.length - 1)
				{
					_loc1_ = _filterer.GetNextFilterMatch(selectedIndex);
					if(EntriesA[_loc1_].isDivider == true)
					{
						_loc1_ = _filterer.GetNextFilterMatch(_loc1_);
					}
					if(_loc1_ != int.MAX_VALUE)
					{
						selectedIndex = _loc1_;
						bMouseDrivenNav = false;
						dispatchEvent(new Event(PLAY_FOCUS_SOUND,true,true));
					}
				}
			}
			else
			{
				scrollPosition = scrollPosition + 1;
			}
		}
	}
}
