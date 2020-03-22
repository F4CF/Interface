package
{
	import Shared.AS3.ListFilterer;
	
	public class BarterListFilterer extends ListFilterer
	{
		 
		
		public function BarterListFilterer()
		{
			super();
		}
		
		override public function EntryMatchesFilter(param1:Object) : Boolean
		{
			var _loc2_:Boolean = false;
			var _loc3_:int = 0;
			var _loc4_:int = 0;
			var _loc5_:int = 0;
			if(param1 == null)
			{
				_loc2_ = false;
			}
			else
			{
				_loc3_ = param1.count;
				_loc4_ = param1.barterCount;
				_loc5_ = _loc3_ - _loc4_;
				_loc2_ = (!param1.hasOwnProperty("filterFlag") || (param1.filterFlag & itemFilter) != 0) && _loc5_ != 0;
			}
			return _loc2_;
		}
	}
}
