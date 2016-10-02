package Shared.AS3
{
	import flash.display.MovieClip;
	import flash.events.Event;
	import Shared.PlatformChangeEvent;
	import flash.events.MouseEvent;
	import flash.events.KeyboardEvent;
	import flash.ui.Keyboard;
	import flash.utils.getDefinitionByName;
	
	public class BSScrollingList extends MovieClip
	{
		
		public static const TEXT_OPTION_NONE:String = "None";
		
		public static const TEXT_OPTION_SHRINK_TO_FIT:String = "Shrink To Fit";
		
		public static const TEXT_OPTION_MULTILINE:String = "Multi-Line";
		
		public static const SELECTION_CHANGE:String = "BSScrollingList::selectionChange";
		
		public static const ITEM_PRESS:String = "BSScrollingList::itemPress";
		
		public static const LIST_PRESS:String = "BSScrollingList::listPress";
		
		public static const MOVE_UP:String = "BSScrollingList::moveUp";
		
		public static const MOVE_DOWN:String = "BSScrollingList::moveDown";
		
		public static const LIST_ITEMS_CREATED:String = "BSScrollingList::listItemsCreated";
		 
		
		public var border:MovieClip;
		
		public var ScrollUp:MovieClip;
		
		public var ScrollDown:MovieClip;
		
		protected var EntriesA:Array;
		
		protected var _filterer:Shared.AS3.ListFilterer;
		
		protected var iSelectedIndex:int;
		
		protected var iSelectedClipIndex:int;
		
		protected var bRestoreListIndex:Boolean;
		
		protected var iListItemsShown:uint;
		
		protected var uiNumListItems:uint;
		
		protected var uiListEntryOffset:uint;
		
		protected var ListEntryClass:Class;
		
		protected var fListHeight:Number;
		
		protected var fVerticalSpacing:Number;
		
		protected var iScrollPosition:uint;
		
		protected var iMaxScrollPosition:uint;
		
		protected var bMouseDrivenNav:Boolean;
		
		protected var fShownItemsHeight:Number;
		
		protected var iPlatform:Number;
		
		protected var bInitialized:Boolean;
		
		protected var strTextOption:String;
		
		protected var bDisableSelection:Boolean;
		
		protected var bDisableInput:Boolean;
		
		protected var bReverseList:Boolean;
		
		protected var bUpdated:Boolean;
		
		public function BSScrollingList()
		{
			super();
			this.EntriesA = new Array();
			this._filterer = new Shared.AS3.ListFilterer();
			addEventListener(Shared.AS3.ListFilterer.FILTER_CHANGE,this.onFilterChange);
			this.strTextOption = TEXT_OPTION_NONE;
			this.fVerticalSpacing = 0;
			this.uiNumListItems = 0;
			this.bRestoreListIndex = true;
			this.bDisableSelection = false;
			this.bDisableInput = false;
			this.bMouseDrivenNav = false;
			this.bReverseList = false;
			this.bUpdated = false;
			this.bInitialized = false;
			loaderInfo.addEventListener(Event.INIT,this.onComponentInit);
			addEventListener(Event.ADDED_TO_STAGE,this.onStageInit);
			addEventListener(Event.REMOVED_FROM_STAGE,this.onStageDestruct);
			addEventListener(KeyboardEvent.KEY_DOWN,this.onKeyDown);
			addEventListener(KeyboardEvent.KEY_UP,this.onKeyUp);
			addEventListener(MouseEvent.MOUSE_WHEEL,this.onMouseWheel);
			if(this.ScrollUp != null)
			{
				this.ScrollUp.addEventListener(MouseEvent.CLICK,this.onScrollArrowClick);
			}
			if(this.ScrollDown != null)
			{
				this.ScrollDown.addEventListener(MouseEvent.CLICK,this.onScrollArrowClick);
			}
			this.iSelectedIndex = -1;
			this.iSelectedClipIndex = -1;
			this.iScrollPosition = 0;
			this.iMaxScrollPosition = 0;
			this.iListItemsShown = 0;
			this.fListHeight = 0;
			this.iPlatform = 1;
		}
		
		public function onComponentInit(param1:Event) : *
		{
			loaderInfo.removeEventListener(Event.INIT,this.onComponentInit);
			if(this.uiNumListItems != 0)
			{
				this.SetNumListItems(this.uiNumListItems);
			}
		}
		
		protected function onStageInit(param1:Event) : *
		{
			stage.addEventListener(PlatformChangeEvent.PLATFORM_CHANGE,this.onSetPlatform);
		}
		
		protected function onStageDestruct(param1:Event) : *
		{
			stage.removeEventListener(PlatformChangeEvent.PLATFORM_CHANGE,this.onSetPlatform);
		}
		
		public function onScrollArrowClick(param1:Event) : *
		{
			this.doSetSelectedIndex(-1);
			if(param1.target == this.ScrollUp)
			{
				this.scrollPosition = this.scrollPosition - 1;
			}
			else if(param1.target == this.ScrollDown)
			{
				this.scrollPosition = this.scrollPosition + 1;
			}
			param1.stopPropagation();
		}
		
		public function onEntryRollover(param1:Event) : *
		{
			this.bMouseDrivenNav = true;
			if(!this.bDisableInput)
			{
				this.doSetSelectedIndex((param1.currentTarget as BSScrollingListEntry).itemIndex);
			}
		}
		
		public function onEntryPress(param1:MouseEvent) : *
		{
			param1.stopPropagation();
			this.bMouseDrivenNav = true;
			this.onItemPress();
		}
		
		public function ClearList() : *
		{
			this.EntriesA.splice(0,this.EntriesA.length);
		}
		
		public function GetClipByIndex(param1:uint) : BSScrollingListEntry
		{
			return this.uiListEntryOffset + param1 < this.numChildren?this.getChildAt(this.uiListEntryOffset + param1) as BSScrollingListEntry:null;
		}
		
		public function GetEntryFromClipIndex(param1:int) : int
		{
			var _loc2_:int = -1;
			var _loc3_:uint = 0;
			while(_loc3_ < this.EntriesA.length)
			{
				if(this.EntriesA[_loc3_].clipIndex <= param1)
				{
					_loc2_ = _loc3_;
				}
				_loc3_++;
			}
			return _loc2_;
		}
		
		public function onKeyDown(param1:KeyboardEvent) : *
		{
			if(!this.bDisableInput)
			{
				if(param1.keyCode == Keyboard.UP)
				{
					this.moveSelectionUp();
					param1.stopPropagation();
				}
				else if(param1.keyCode == Keyboard.DOWN)
				{
					this.moveSelectionDown();
					param1.stopPropagation();
				}
			}
		}
		
		public function onKeyUp(param1:KeyboardEvent) : *
		{
			if(!this.bDisableInput && !this.bDisableSelection && param1.keyCode == Keyboard.ENTER)
			{
				this.onItemPress();
				param1.stopPropagation();
			}
		}
		
		public function onMouseWheel(param1:MouseEvent) : *
		{
			if(!this.bDisableInput && this.iMaxScrollPosition > 0)
			{
				if(param1.delta < 0)
				{
					this.scrollPosition = this.scrollPosition + 1;
				}
				else if(param1.delta > 0)
				{
					this.scrollPosition = this.scrollPosition - 1;
				}
				param1.stopPropagation();
			}
		}
		
		public function get filterer() : Shared.AS3.ListFilterer
		{
			return this._filterer;
		}
		
		public function get itemsShown() : uint
		{
			return this.iListItemsShown;
		}
		
		public function get initialized() : Boolean
		{
			return this.bInitialized;
		}
		
		public function get selectedIndex() : int
		{
			return this.iSelectedIndex;
		}
		
		public function set selectedIndex(param1:int) : *
		{
			this.doSetSelectedIndex(param1);
		}
		
		public function get selectedClipIndex() : int
		{
			return this.iSelectedClipIndex;
		}
		
		public function set selectedClipIndex(param1:int) : *
		{
			this.doSetSelectedIndex(this.GetEntryFromClipIndex(param1));
		}
		
		public function set filterer(param1:Shared.AS3.ListFilterer) : *
		{
			this._filterer = param1;
		}
		
		public function get shownItemsHeight() : Number
		{
			return this.fShownItemsHeight;
		}
		
		protected function doSetSelectedIndex(param1:int) : *
		{
			var _loc2_:int = 0;
			var _loc3_:int = 0;
			var _loc4_:int = 0;
			var _loc5_:int = 0;
			var _loc6_:int = 0;
			if(!this.bInitialized || this.numListItems == 0)
			{
				trace("BSScrollingList::doSetSelectedIndex -- Can\'t set selection before list has been created.");
			}
			if(!this.bDisableSelection && param1 != this.iSelectedIndex)
			{
				_loc2_ = this.iSelectedIndex;
				this.iSelectedIndex = param1;
				if(this.EntriesA.length == 0)
				{
					this.iSelectedIndex = -1;
				}
				if(_loc2_ != -1 && _loc2_ < this.EntriesA.length && this.EntriesA[_loc2_].clipIndex != int.MAX_VALUE)
				{
					this.SetEntry(this.GetClipByIndex(this.EntriesA[_loc2_].clipIndex),this.EntriesA[_loc2_]);
				}
				if(this.iSelectedIndex != -1)
				{
					this.iSelectedIndex = this._filterer.ClampIndex(this.iSelectedIndex);
					if(this.iSelectedIndex == int.MAX_VALUE)
					{
						this.iSelectedIndex = -1;
					}
					if(this.iSelectedIndex != -1 && _loc2_ != this.iSelectedIndex)
					{
						if(this.EntriesA[this.iSelectedIndex].clipIndex != int.MAX_VALUE)
						{
							this.SetEntry(this.GetClipByIndex(this.EntriesA[this.iSelectedIndex].clipIndex),this.EntriesA[this.iSelectedIndex]);
						}
						else
						{
							_loc3_ = this.GetEntryFromClipIndex(0);
							_loc4_ = this.GetEntryFromClipIndex(this.uiNumListItems - 1);
							_loc6_ = 0;
							if(this.iSelectedIndex < _loc3_)
							{
								_loc5_ = _loc3_;
								do
								{
									_loc5_ = this._filterer.GetPrevFilterMatch(_loc5_);
									_loc6_--;
								}
								while(_loc5_ != this.iSelectedIndex);
								
							}
							else if(this.iSelectedIndex > _loc4_)
							{
								_loc5_ = _loc4_;
								do
								{
									_loc5_ = this._filterer.GetNextFilterMatch(_loc5_);
									_loc6_++;
								}
								while(_loc5_ != this.iSelectedIndex);
								
							}
							this.scrollPosition = this.scrollPosition + _loc6_;
						}
					}
				}
				if(_loc2_ != this.iSelectedIndex)
				{
					this.iSelectedClipIndex = this.iSelectedIndex != -1?int(this.EntriesA[this.iSelectedIndex].clipIndex):-1;
					dispatchEvent(new Event(SELECTION_CHANGE,true,true));
				}
			}
		}
		
		public function get scrollPosition() : uint
		{
			return this.iScrollPosition;
		}
		
		public function get maxScrollPosition() : uint
		{
			return this.iMaxScrollPosition;
		}
		
		public function set scrollPosition(param1:uint) : *
		{
			if(param1 != this.iScrollPosition && param1 >= 0 && param1 <= this.iMaxScrollPosition)
			{
				this.updateScrollPosition(param1);
			}
		}
		
		protected function updateScrollPosition(param1:uint) : *
		{
			this.iScrollPosition = param1;
			this.UpdateList();
		}
		
		public function get selectedEntry() : Object
		{
			return this.EntriesA[this.iSelectedIndex];
		}
		
		public function get entryList() : Array
		{
			return this.EntriesA;
		}
		
		public function set entryList(param1:Array) : *
		{
			this.EntriesA = param1;
			if(this.EntriesA == null)
			{
				this.EntriesA = new Array();
			}
		}
		
		public function get disableInput() : Boolean
		{
			return this.bDisableInput;
		}
		
		public function set disableInput(param1:Boolean) : *
		{
			this.bDisableInput = param1;
		}
		
		public function get textOption() : String
		{
			return this.strTextOption;
		}
		
		public function set textOption(param1:String) : *
		{
			this.strTextOption = param1;
		}
		
		public function get verticalSpacing() : *
		{
			return this.fVerticalSpacing;
		}
		
		public function set verticalSpacing(param1:Number) : *
		{
			this.fVerticalSpacing = param1;
		}
		
		public function get numListItems() : uint
		{
			return this.uiNumListItems;
		}
		
		public function set numListItems(param1:uint) : *
		{
			this.uiNumListItems = param1;
		}
		
		public function set listEntryClass(param1:String) : *
		{
			this.ListEntryClass = getDefinitionByName(param1) as Class;
		}
		
		public function get restoreListIndex() : Boolean
		{
			return this.bRestoreListIndex;
		}
		
		public function set restoreListIndex(param1:Boolean) : *
		{
			this.bRestoreListIndex = param1;
		}
		
		public function get disableSelection() : Boolean
		{
			return this.bDisableSelection;
		}
		
		public function set disableSelection(param1:Boolean) : *
		{
			this.bDisableSelection = param1;
		}
		
		protected function SetNumListItems(param1:uint) : *
		{
			var _loc3_:MovieClip = null;
			this.uiListEntryOffset = this.numChildren;
			var _loc2_:uint = 0;
			while(this.ListEntryClass != null && _loc2_ < param1)
			{
				_loc3_ = this.GetNewListEntry(_loc2_);
				if(_loc3_ != null)
				{
					_loc3_.clipIndex = _loc2_;
					_loc3_.addEventListener(MouseEvent.MOUSE_OVER,this.onEntryRollover);
					_loc3_.addEventListener(MouseEvent.CLICK,this.onEntryPress);
					addChild(_loc3_);
				}
				else
				{
					trace("BSScrollingList::SetNumListItems -- List Entry Class is invalid or does not derive from BSScrollingListEntry.");
				}
				_loc2_++;
			}
			this.bInitialized = true;
			dispatchEvent(new Event(LIST_ITEMS_CREATED,true,true));
		}
		
		protected function GetNewListEntry(param1:uint) : BSScrollingListEntry
		{
			return new this.ListEntryClass() as BSScrollingListEntry;
		}
		
		public function UpdateList() : *
		{
			var _loc5_:BSScrollingListEntry = null;
			var _loc6_:BSScrollingListEntry = null;
			if(!this.bInitialized || this.numListItems == 0)
			{
				trace("BSScrollingList::UpdateList -- Can\'t update list before list has been created.");
			}
			var _loc1_:Number = 0;
			var _loc2_:Number = this._filterer.ClampIndex(0);
			var _loc3_:uint = 0;
			while(_loc3_ < this.EntriesA.length)
			{
				this.EntriesA[_loc3_].clipIndex = int.MAX_VALUE;
				if(_loc3_ < this.iScrollPosition)
				{
					_loc2_ = this._filterer.GetNextFilterMatch(_loc2_);
				}
				_loc3_++;
			}
			var _loc4_:uint = 0;
			while(_loc4_ < this.uiNumListItems)
			{
				_loc5_ = this.GetClipByIndex(_loc4_);
				if(_loc5_)
				{
					_loc5_.visible = false;
					_loc5_.itemIndex = int.MAX_VALUE;
				}
				_loc4_++;
			}
			this.iListItemsShown = 0;
			while(_loc2_ != int.MAX_VALUE && _loc2_ != -1 && _loc2_ < this.EntriesA.length && this.iListItemsShown < this.uiNumListItems && _loc1_ <= this.fListHeight)
			{
				_loc6_ = this.GetClipByIndex(this.iListItemsShown);
				if(_loc6_)
				{
					this.SetEntry(_loc6_,this.EntriesA[_loc2_]);
					this.EntriesA[_loc2_].clipIndex = this.iListItemsShown;
					_loc6_.itemIndex = _loc2_;
					_loc6_.visible = true;
					_loc1_ = _loc1_ + _loc6_.height;
					if(_loc1_ <= this.fListHeight && this.iListItemsShown < this.uiNumListItems)
					{
						_loc1_ = _loc1_ + this.fVerticalSpacing;
						this.iListItemsShown++;
					}
					else if(this.textOption != TEXT_OPTION_MULTILINE)
					{
						this.EntriesA[_loc2_].clipIndex = int.MAX_VALUE;
						_loc6_.visible = false;
					}
					else
					{
						this.iListItemsShown++;
					}
				}
				_loc2_ = this._filterer.GetNextFilterMatch(_loc2_);
			}
			this.PositionEntries();
			if(this.ScrollUp != null)
			{
				this.ScrollUp.visible = this.scrollPosition > 0;
			}
			if(this.ScrollDown != null)
			{
				this.ScrollDown.visible = this.scrollPosition < this.iMaxScrollPosition;
			}
			this.bUpdated = true;
		}
		
		protected function PositionEntries() : *
		{
			var _loc1_:Number = 0;
			var _loc2_:Number = this.border.y;
			var _loc3_:int = 0;
			while(_loc3_ < this.iListItemsShown)
			{
				this.GetClipByIndex(_loc3_).y = _loc2_ + _loc1_;
				_loc1_ = _loc1_ + (this.GetClipByIndex(_loc3_).height + this.fVerticalSpacing);
				_loc3_++;
			}
			this.fShownItemsHeight = _loc1_;
		}
		
		public function InvalidateData() : *
		{
			var _loc1_:Boolean = false;
			this._filterer.filterArray = this.EntriesA;
			this.fListHeight = this.border.height;
			this.CalculateMaxScrollPosition();
			if(!this.restoreListIndex)
			{
				if(this.iSelectedIndex >= this.EntriesA.length)
				{
					this.iSelectedIndex = this.EntriesA.length - 1;
					_loc1_ = true;
				}
			}
			if(this.iScrollPosition > this.iMaxScrollPosition)
			{
				this.iScrollPosition = this.iMaxScrollPosition;
			}
			this.UpdateList();
			if(this.restoreListIndex)
			{
				this.selectedClipIndex = this.iSelectedClipIndex;
			}
			else if(_loc1_)
			{
				dispatchEvent(new Event(SELECTION_CHANGE,true,true));
			}
		}
		
		public function UpdateSelectedEntry() : *
		{
			if(this.iSelectedIndex != -1)
			{
				this.SetEntry(this.GetClipByIndex(this.EntriesA[this.iSelectedIndex].clipIndex),this.EntriesA[this.iSelectedIndex]);
			}
		}
		
		public function UpdateEntry(param1:Object) : *
		{
			this.SetEntry(this.GetClipByIndex(param1.clipIndex),param1);
		}
		
		public function onFilterChange() : *
		{
			this.iSelectedIndex = this._filterer.ClampIndex(this.iSelectedIndex);
			this.CalculateMaxScrollPosition();
		}
		
		protected function CalculateMaxScrollPosition() : *
		{
			var _loc2_:Number = NaN;
			var _loc3_:int = 0;
			var _loc4_:int = 0;
			var _loc5_:int = 0;
			var _loc6_:int = 0;
			var _loc1_:int = !!this._filterer.EntryMatchesFilter(this.EntriesA[this.EntriesA.length - 1])?int(this.EntriesA.length - 1):int(this._filterer.GetPrevFilterMatch(this.EntriesA.length - 1));
			if(_loc1_ == int.MAX_VALUE)
			{
				this.iMaxScrollPosition = 0;
			}
			else
			{
				_loc2_ = this.GetEntryHeight(_loc1_);
				_loc3_ = _loc1_;
				_loc4_ = 1;
				while(_loc3_ != int.MAX_VALUE && _loc2_ < this.fListHeight && _loc4_ < this.uiNumListItems)
				{
					_loc3_ = this._filterer.GetPrevFilterMatch(_loc3_);
					if(_loc3_ != int.MAX_VALUE)
					{
						_loc2_ = _loc2_ + (this.GetEntryHeight(_loc3_) + this.fVerticalSpacing);
						_loc4_++;
					}
				}
				if(_loc3_ == int.MAX_VALUE)
				{
					this.iMaxScrollPosition = 0;
				}
				else
				{
					_loc5_ = 0;
					_loc6_ = this._filterer.GetPrevFilterMatch(_loc3_);
					while(_loc6_ != int.MAX_VALUE)
					{
						_loc5_++;
						_loc6_ = this._filterer.GetPrevFilterMatch(_loc6_);
					}
					this.iMaxScrollPosition = _loc5_;
				}
			}
		}
		
		protected function GetEntryHeight(param1:Number) : Number
		{
			var _loc2_:BSScrollingListEntry = this.GetClipByIndex(0);
			this.SetEntry(_loc2_,this.EntriesA[param1]);
			return _loc2_ != null?Number(_loc2_.height):Number(0);
		}
		
		public function moveSelectionUp() : *
		{
			var _loc1_:Number = NaN;
			if(!this.bDisableSelection)
			{
				if(this.selectedIndex > 0)
				{
					_loc1_ = this._filterer.GetPrevFilterMatch(this.selectedIndex);
					if(_loc1_ != int.MAX_VALUE)
					{
						this.selectedIndex = _loc1_;
						this.bMouseDrivenNav = false;
						dispatchEvent(new Event(MOVE_UP,true,true));
					}
				}
			}
			else
			{
				this.scrollPosition = this.scrollPosition - 1;
			}
		}
		
		public function moveSelectionDown() : *
		{
			var _loc1_:Number = NaN;
			if(!this.bDisableSelection)
			{
				if(this.selectedIndex < this.EntriesA.length - 1)
				{
					_loc1_ = this._filterer.GetNextFilterMatch(this.selectedIndex);
					if(_loc1_ != int.MAX_VALUE)
					{
						this.selectedIndex = _loc1_;
						this.bMouseDrivenNav = false;
						dispatchEvent(new Event(MOVE_DOWN,true,true));
					}
				}
			}
			else
			{
				this.scrollPosition = this.scrollPosition + 1;
			}
		}
		
		protected function onItemPress() : *
		{
			if(!this.bDisableInput && !this.bDisableSelection && this.iSelectedIndex != -1)
			{
				dispatchEvent(new Event(ITEM_PRESS,true,true));
			}
			else
			{
				dispatchEvent(new Event(LIST_PRESS,true,true));
			}
		}
		
		protected function SetEntry(param1:BSScrollingListEntry, param2:Object) : *
		{
			if(param1 != null)
			{
				param1.selected = param2 == this.selectedEntry;
				param1.SetEntryText(param2,this.strTextOption);
			}
		}
		
		protected function onSetPlatform(param1:Event) : *
		{
			var _loc2_:PlatformChangeEvent = param1 as PlatformChangeEvent;
			this.SetPlatform(_loc2_.uiPlatform,_loc2_.bPS3Switch);
		}
		
		public function SetPlatform(param1:Number, param2:Boolean) : *
		{
			this.iPlatform = param1;
			this.bMouseDrivenNav = this.iPlatform == 0?true:false;
		}
	}
}
