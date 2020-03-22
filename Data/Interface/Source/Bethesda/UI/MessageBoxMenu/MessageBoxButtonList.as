package
{
	import Shared.AS3.BSScrollingList;
	
	public class MessageBoxButtonList extends BSScrollingList
	{
		 
		
		public function MessageBoxButtonList()
		{
			super();
		}
		
		override public function InvalidateData() : *
		{
			super.InvalidateData();
			this.SetEntryBorderWidths();
		}
		
		private function SetEntryBorderWidths() : *
		{
			var _loc4_:MessageBoxButtonEntry = null;
			var _loc5_:Number = NaN;
			var _loc6_:MessageBoxButtonEntry = null;
			var _loc1_:Number = 0;
			var _loc2_:uint = 0;
			while(_loc2_ < uiNumListItems)
			{
				_loc4_ = GetClipByIndex(_loc2_) as MessageBoxButtonEntry;
				if(_loc4_ && _loc4_.textField)
				{
					_loc5_ = _loc4_.CalculateBorderWidth();
					if(_loc5_ > _loc1_)
					{
						_loc1_ = _loc5_;
					}
				}
				_loc2_++;
			}
			var _loc3_:uint = 0;
			while(_loc3_ < uiNumListItems)
			{
				_loc6_ = GetClipByIndex(_loc3_) as MessageBoxButtonEntry;
				if(_loc6_)
				{
					_loc6_.SetBorderWidth(_loc1_);
				}
				_loc3_++;
			}
		}
		
		override protected function updateScrollPosition(param1:uint) : *
		{
			super.updateScrollPosition(param1);
			this.SetEntryBorderWidths();
		}
	}
}
