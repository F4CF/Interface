package Shared.AS3
{
	public class BSReversedScrollingList extends BSScrollingList
	{
		 
		
		private var fTopY:Number;
		
		public function BSReversedScrollingList()
		{
			super();
			this.fTopY = 0;
		}
		
		public function get topmostY() : Number
		{
			return this.fTopY;
		}
		
		override protected function PositionEntries() : *
		{
			var _loc4_:BSScrollingListEntry = null;
			var _loc1_:Number = 0;
			var _loc2_:Number = border.y + border.height;
			this.fTopY = _loc2_;
			var _loc3_:int = iListItemsShown - 1;
			while(_loc3_ >= 0)
			{
				_loc4_ = GetClipByIndex(_loc3_);
				_loc4_.y = _loc2_ - _loc1_ - _loc4_.height;
				_loc1_ = _loc1_ + (_loc4_.height + fVerticalSpacing);
				if(_loc4_.itemIndex != int.MAX_VALUE)
				{
					this.fTopY = _loc4_.y;
				}
				_loc3_--;
			}
		}
	}
}
