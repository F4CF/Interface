package Shared.AS3
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	
	public class ListFilterer extends EventDispatcher
	{
		
		public static const FILTER_CHANGE:String = "ListFilterer::filter_change";
		 
		
		private var iItemFilter:int;
		
		private var _filterArray:Array;
		
		public function ListFilterer()
		{
			super();
			this.iItemFilter = 4294967295;
		}
		
		public function get itemFilter() : int
		{
			return this.iItemFilter;
		}
		
		public function set itemFilter(param1:int) : *
		{
			var _loc2_:* = this.iItemFilter != param1;
			this.iItemFilter = param1;
			if(_loc2_ == true)
			{
				dispatchEvent(new Event(FILTER_CHANGE,true,true));
			}
		}
		
		public function get filterArray() : Array
		{
			return this._filterArray;
		}
		
		public function set filterArray(param1:Array) : *
		{
			this._filterArray = param1;
		}
		
		public function EntryMatchesFilter(param1:Object) : Boolean
		{
			return param1 != null && (!param1.hasOwnProperty("filterFlag") || (param1.filterFlag & this.iItemFilter) != 0);
		}
		
		public function GetPrevFilterMatch(param1:int) : int
		{
			var _loc3_:int = 0;
			var _loc2_:int = int.MAX_VALUE;
			if(param1 != int.MAX_VALUE && this._filterArray != null)
			{
				_loc3_ = param1 - 1;
				while(_loc3_ >= 0 && _loc2_ == int.MAX_VALUE)
				{
					if(this.EntryMatchesFilter(this._filterArray[_loc3_]))
					{
						_loc2_ = _loc3_;
					}
					_loc3_--;
				}
			}
			return _loc2_;
		}
		
		public function GetNextFilterMatch(param1:int) : int
		{
			var _loc3_:int = 0;
			var _loc2_:int = int.MAX_VALUE;
			if(param1 != int.MAX_VALUE && this._filterArray != null)
			{
				_loc3_ = param1 + 1;
				while(_loc3_ < this._filterArray.length && _loc2_ == int.MAX_VALUE)
				{
					if(this.EntryMatchesFilter(this._filterArray[_loc3_]))
					{
						_loc2_ = _loc3_;
					}
					_loc3_++;
				}
			}
			return _loc2_;
		}
		
		public function ClampIndex(param1:int) : int
		{
			var _loc3_:int = 0;
			var _loc4_:int = 0;
			var _loc2_:* = param1;
			if(param1 != int.MAX_VALUE && this._filterArray != null && !this.EntryMatchesFilter(this._filterArray[_loc2_]))
			{
				_loc3_ = this.GetNextFilterMatch(_loc2_);
				_loc4_ = this.GetPrevFilterMatch(_loc2_);
				if(_loc3_ != int.MAX_VALUE)
				{
					_loc2_ = _loc3_;
				}
				else if(_loc4_ != int.MAX_VALUE)
				{
					_loc2_ = _loc4_;
				}
				else
				{
					_loc2_ = int.MAX_VALUE;
				}
				if(_loc3_ != int.MAX_VALUE && _loc4_ != int.MAX_VALUE && _loc4_ != _loc3_ && _loc2_ == _loc3_ && this._filterArray[_loc4_].text == this._filterArray[param1].text)
				{
					_loc2_ = _loc4_;
				}
			}
			return _loc2_;
		}
		
		public function IsFilterEmpty(param1:int) : Boolean
		{
			var _loc3_:* = false;
			var _loc2_:int = this.iItemFilter;
			this.iItemFilter = param1;
			_loc3_ = this.ClampIndex(0) == int.MAX_VALUE;
			this.iItemFilter = _loc2_;
			return _loc3_;
		}
	}
}
