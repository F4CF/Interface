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
		
		public function set itemFilter(aiNewFilter:int) : *
		{
			var bdifferent:* = this.iItemFilter != aiNewFilter;
			this.iItemFilter = aiNewFilter;
			if(bdifferent == true)
			{
				dispatchEvent(new Event(FILTER_CHANGE,true,true));
			}
		}
		
		public function get filterArray() : Array
		{
			return this._filterArray;
		}
		
		public function set filterArray(aNewArray:Array) : *
		{
			this._filterArray = aNewArray;
		}
		
		public function EntryMatchesFilter(aEntry:Object) : Boolean
		{
			return aEntry != null && (!aEntry.hasOwnProperty("filterFlag") || (aEntry.filterFlag & this.iItemFilter) != 0);
		}
		
		public function GetPrevFilterMatch(aiStartIndex:int) : int
		{
			var ientry:int = 0;
			var imatchIndex:int = int.MAX_VALUE;
			if(aiStartIndex != int.MAX_VALUE && this._filterArray != null)
			{
				ientry = aiStartIndex - 1;
				while(ientry >= 0 && imatchIndex == int.MAX_VALUE)
				{
					if(this.EntryMatchesFilter(this._filterArray[ientry]))
					{
						imatchIndex = ientry;
					}
					ientry--;
				}
			}
			return imatchIndex;
		}
		
		public function GetNextFilterMatch(aiStartIndex:int) : int
		{
			var ientry:int = 0;
			var imatchIndex:int = int.MAX_VALUE;
			if(aiStartIndex != int.MAX_VALUE && this._filterArray != null)
			{
				ientry = aiStartIndex + 1;
				while(ientry < this._filterArray.length && imatchIndex == int.MAX_VALUE)
				{
					if(this.EntryMatchesFilter(this._filterArray[ientry]))
					{
						imatchIndex = ientry;
					}
					ientry++;
				}
			}
			return imatchIndex;
		}
		
		public function ClampIndex(aiStartIndex:int) : int
		{
			var inextIndex:int = 0;
			var iprevIndex:int = 0;
			var ireturnVal:* = aiStartIndex;
			if(aiStartIndex != int.MAX_VALUE && this._filterArray != null && !this.EntryMatchesFilter(this._filterArray[ireturnVal]))
			{
				inextIndex = this.GetNextFilterMatch(ireturnVal);
				iprevIndex = this.GetPrevFilterMatch(ireturnVal);
				if(inextIndex != int.MAX_VALUE)
				{
					ireturnVal = inextIndex;
				}
				else if(iprevIndex != int.MAX_VALUE)
				{
					ireturnVal = iprevIndex;
				}
				else
				{
					ireturnVal = int.MAX_VALUE;
				}
				if(inextIndex != int.MAX_VALUE && iprevIndex != int.MAX_VALUE && iprevIndex != inextIndex && ireturnVal == inextIndex && this._filterArray[iprevIndex].text == this._filterArray[aiStartIndex].text)
				{
					ireturnVal = iprevIndex;
				}
			}
			return ireturnVal;
		}
		
		public function IsFilterEmpty(aiFilter:int) : Boolean
		{
			var bresult:* = false;
			var iprevFilter:int = this.iItemFilter;
			this.iItemFilter = aiFilter;
			bresult = this.ClampIndex(0) == int.MAX_VALUE;
			this.iItemFilter = iprevFilter;
			return bresult;
		}
	}
}
