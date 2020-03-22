package
{
	import Shared.AS3.BSScrollingListEntry;
	import Shared.UpdateEventList;
	
	public class RightHandList extends UpdateEventList
	{
		 
		
		public function RightHandList()
		{
			super();
		}
		
		override protected function SetEntry(param1:BSScrollingListEntry, param2:Object) : *
		{
			var _loc3_:* = undefined;
			var _loc4_:uint = 0;
			param2.filterIndex = filterer.itemFilter;
			param2.betcText = param2.noScroll == true && param1.clipIndex == 4 && entryList.length > 5;
			if(param2.betcText)
			{
				_loc3_ = false;
				_loc4_ = 4;
				while(!_loc3_ && _loc4_ < entryList.length)
				{
					if(entryList[_loc4_].accountedFor != null && entryList[_loc4_].requiredCount != null)
					{
						_loc3_ = entryList[_loc4_].accountedFor >= entryList[_loc4_].requiredCount;
					}
					else
					{
						_loc3_ = entryList[_loc4_].enabled || entryList[_loc4_].hasRequired;
					}
					_loc4_++;
				}
				param2.validUnshownMod = _loc3_;
			}
			super.SetEntry(param1,param2);
		}
	}
}
