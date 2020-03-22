package
{
	import Shared.AS3.BSScrollingList;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	
	public dynamic class ListInfoObject extends EventDispatcher
	{
		 
		
		private var _filterer:Object;
		
		private var _entryList:Array;
		
		private var _selectedIndex:int = 0;
		
		private var strName:String = "";
		
		private var strSortOn:String = "";
		
		private var _list:BSScrollingList = null;
		
		private var _active:Boolean = false;
		
		public function ListInfoObject()
		{
			this._filterer = new Object();
			this._entryList = new Array();
			super();
		}
		
		public function set filterer(param1:Object) : *
		{
			this._filterer = param1;
		}
		
		public function get filterer() : *
		{
			return this._filterer;
		}
		
		public function set entryList(param1:Array) : *
		{
			this._entryList = param1.slice();
			if(this.strSortOn.length > 0)
			{
				this._entryList.sortOn(this.strSortOn);
			}
			this.RefreshList();
		}
		
		public function get entryList() : *
		{
			return this._entryList;
		}
		
		public function set selectedIndex(param1:int) : *
		{
			this._selectedIndex = param1;
		}
		
		public function get selectedIndex() : *
		{
			return this._selectedIndex;
		}
		
		public function get selectedEntry() : *
		{
			return this._active && this._list != null?this._list.selectedEntry:null;
		}
		
		public function SetActive(param1:BSScrollingList, param2:String) : *
		{
			this.strName = param2;
			if(this._list != null)
			{
				this._list.removeEventListener(BSScrollingList.SELECTION_CHANGE,this.updateObjectSelectedIndex);
			}
			this._list = param1;
			this._list.selectedIndex = this.selectedIndex;
			this._list.addEventListener(BSScrollingList.SELECTION_CHANGE,this.updateObjectSelectedIndex);
			this._active = true;
			this.RefreshList();
		}
		
		public function SetInactive() : *
		{
			this._active = false;
			this._list.removeEventListener(BSScrollingList.SELECTION_CHANGE,this.updateObjectSelectedIndex);
		}
		
		public function RefreshList() : *
		{
			if(this._active && this._list != null)
			{
				this._list.filterer.itemFilter = this._filterer.itemFilter;
				this._list.entryList = this._entryList.slice();
				this._list.InvalidateData();
				this._list.selectedIndex = this._list.filterer.ClampIndex(this.selectedIndex);
			}
		}
		
		private function updateObjectSelectedIndex(param1:Event) : *
		{
			this._selectedIndex = this._list.selectedIndex;
			dispatchEvent(new Event(BSScrollingList.SELECTION_CHANGE,true,true));
		}
		
		public function set sort(param1:String) : *
		{
			this.strSortOn = param1;
		}
	}
}
