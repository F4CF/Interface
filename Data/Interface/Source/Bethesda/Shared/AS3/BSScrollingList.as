package Shared.AS3
{
	import Mobile.ScrollList.EventWithParams;
	import Mobile.ScrollList.MobileListItemRenderer;
	import Mobile.ScrollList.MobileScrollList;
	import Shared.AS3.COMPANIONAPP.BSScrollingListInterface;
	import Shared.AS3.COMPANIONAPP.CompanionAppMode;
	import Shared.PlatformChangeEvent;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.geom.Point;
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
		
		public static const LIST_ITEMS_CREATED:String = "BSScrollingList::listItemsCreated";
		
		public static const PLAY_FOCUS_SOUND:String = "BSScrollingList::playFocusSound";
		
		public static const MOBILE_ITEM_PRESS:String = "BSScrollingList::mobileItemPress";
		 
		
		public var scrollList:MobileScrollList;
		
		private var _itemRendererClassName:String;
		
		public var border:MovieClip;
		
		public var ScrollUp:MovieClip;
		
		public var ScrollDown:MovieClip;
		
		protected var EntriesA:Array;
		
		protected var EntryHolder_mc:MovieClip;
		
		protected var _filterer:ListFilterer;
		
		protected var iSelectedIndex:int;
		
		protected var iSelectedClipIndex:int;
		
		protected var bRestoreListIndex:Boolean;
		
		protected var iListItemsShown:uint;
		
		protected var uiNumListItems:uint;
		
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
			this._filterer = new ListFilterer();
			addEventListener(ListFilterer.FILTER_CHANGE,this.onFilterChange);
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
			if(loaderInfo != null)
			{
				loaderInfo.addEventListener(Event.INIT,this.onComponentInit);
			}
			addEventListener(Event.ADDED_TO_STAGE,this.onStageInit);
			addEventListener(Event.REMOVED_FROM_STAGE,this.onStageDestruct);
			addEventListener(KeyboardEvent.KEY_DOWN,this.onKeyDown);
			addEventListener(KeyboardEvent.KEY_UP,this.onKeyUp);
			if(!this.needMobileScrollList)
			{
				addEventListener(MouseEvent.MOUSE_WHEEL,this.onMouseWheel);
			}
			if(this.border == null)
			{
				throw new Error("No \'border\' clip found.  BSScrollingList requires a border rect to define its extents.");
			}
			this.EntryHolder_mc = new MovieClip();
			this.addChildAt(this.EntryHolder_mc,this.getChildIndex(this.border) + 1);
			this.iSelectedIndex = -1;
			this.iSelectedClipIndex = -1;
			this.iScrollPosition = 0;
			this.iMaxScrollPosition = 0;
			this.iListItemsShown = 0;
			this.fListHeight = 0;
			this.iPlatform = 1;
		}
		
		private function get needMobileScrollList() : Boolean
		{
			return CompanionAppMode.isOn && this._itemRendererClassName != "MessageBoxButtonEntry";
		}
		
		public function onComponentInit(param1:Event) : *
		{
			if(this.needMobileScrollList)
			{
				this.createMobileScrollingList();
				if(this.border != null)
				{
					this.border.alpha = 0;
				}
			}
			if(loaderInfo != null)
			{
				loaderInfo.removeEventListener(Event.INIT,this.onComponentInit);
			}
			if(!this.bInitialized)
			{
				this.SetNumListItems(this.uiNumListItems);
			}
		}
		
		protected function onStageInit(param1:Event) : *
		{
			stage.addEventListener(PlatformChangeEvent.PLATFORM_CHANGE,this.onSetPlatform);
			if(!this.bInitialized)
			{
				this.SetNumListItems(this.uiNumListItems);
			}
			if(this.ScrollUp != null && !CompanionAppMode.isOn)
			{
				this.ScrollUp.addEventListener(MouseEvent.CLICK,this.onScrollArrowClick);
			}
			if(this.ScrollDown != null && !CompanionAppMode.isOn)
			{
				this.ScrollDown.addEventListener(MouseEvent.CLICK,this.onScrollArrowClick);
			}
		}
		
		protected function onStageDestruct(param1:Event) : *
		{
			stage.removeEventListener(PlatformChangeEvent.PLATFORM_CHANGE,this.onSetPlatform);
			if(this.needMobileScrollList)
			{
				this.destroyMobileScrollingList();
			}
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
			var _loc2_:* = undefined;
			this.bMouseDrivenNav = true;
			if(!this.bDisableInput)
			{
				_loc2_ = this.iSelectedIndex;
				this.doSetSelectedIndex((param1.currentTarget as BSScrollingListEntry).itemIndex);
				if(_loc2_ != this.iSelectedIndex)
				{
					dispatchEvent(new Event(PLAY_FOCUS_SOUND,true,true));
				}
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
			return param1 < this.EntryHolder_mc.numChildren?this.EntryHolder_mc.getChildAt(param1) as BSScrollingListEntry:null;
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
			var _loc2_:* = undefined;
			if(!this.bDisableInput && this.iMaxScrollPosition > 0)
			{
				_loc2_ = this.scrollPosition;
				if(param1.delta < 0)
				{
					this.scrollPosition = this.scrollPosition + 1;
				}
				else if(param1.delta > 0)
				{
					this.scrollPosition = this.scrollPosition - 1;
				}
				this.SetFocusUnderMouse();
				param1.stopPropagation();
				if(_loc2_ != this.scrollPosition)
				{
					dispatchEvent(new Event(PLAY_FOCUS_SOUND,true,true));
				}
			}
		}
		
		private function SetFocusUnderMouse() : *
		{
			var _loc2_:BSScrollingListEntry = null;
			var _loc3_:MovieClip = null;
			var _loc4_:Point = null;
			var _loc1_:int = 0;
			while(_loc1_ < this.iListItemsShown)
			{
				_loc2_ = this.GetClipByIndex(_loc1_);
				_loc3_ = _loc2_.border;
				_loc4_ = localToGlobal(new Point(mouseX,mouseY));
				if(_loc2_.hitTestPoint(_loc4_.x,_loc4_.y,false))
				{
					this.selectedIndex = _loc2_.itemIndex;
				}
				_loc1_++;
			}
		}
		
		public function get filterer() : ListFilterer
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
		
		public function set filterer(param1:ListFilterer) : *
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
			var _loc3_:Boolean = false;
			var _loc4_:int = 0;
			var _loc5_:BSScrollingListEntry = null;
			var _loc6_:int = 0;
			var _loc7_:int = 0;
			var _loc8_:int = 0;
			var _loc9_:int = 0;
			var _loc10_:int = 0;
			var _loc11_:uint = 0;
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
						_loc3_ = false;
						if(this.textOption == TEXT_OPTION_MULTILINE)
						{
							_loc4_ = this.GetEntryFromClipIndex(this.uiNumListItems - 1);
							if(_loc4_ != -1 && _loc4_ == this.iSelectedIndex && this.EntriesA[_loc4_].clipIndex != int.MAX_VALUE)
							{
								_loc5_ = this.GetClipByIndex(this.EntriesA[_loc4_].clipIndex);
								if(_loc5_ != null && _loc5_.y + _loc5_.height > this.fListHeight)
								{
									_loc3_ = true;
								}
							}
						}
						if(this.EntriesA[this.iSelectedIndex].clipIndex != int.MAX_VALUE && !_loc3_)
						{
							this.SetEntry(this.GetClipByIndex(this.EntriesA[this.iSelectedIndex].clipIndex),this.EntriesA[this.iSelectedIndex]);
						}
						else
						{
							_loc6_ = this.GetEntryFromClipIndex(0);
							_loc7_ = this.GetEntryFromClipIndex(this.uiNumListItems - 1);
							_loc9_ = 0;
							if(this.iSelectedIndex < _loc6_)
							{
								_loc8_ = _loc6_;
								do
								{
									_loc8_ = this._filterer.GetPrevFilterMatch(_loc8_);
									_loc9_--;
								}
								while(_loc8_ != this.iSelectedIndex);
								
							}
							else if(this.iSelectedIndex > _loc7_)
							{
								_loc8_ = _loc7_;
								do
								{
									_loc8_ = this._filterer.GetNextFilterMatch(_loc8_);
									_loc9_++;
								}
								while(_loc8_ != this.iSelectedIndex);
								
							}
							else if(_loc3_)
							{
								_loc9_++;
							}
							this.scrollPosition = this.scrollPosition + _loc9_;
						}
					}
					if(this.needMobileScrollList)
					{
						if(this.scrollList != null)
						{
							if(this.iSelectedIndex != -1)
							{
								_loc10_ = this.EntriesA[this.iSelectedIndex].clipIndex;
								_loc11_ = 0;
								while(_loc11_ < this.scrollList.data.length)
								{
									if(this.EntriesA[this.iSelectedIndex] == this.scrollList.data[_loc11_])
									{
										_loc10_ = _loc11_;
										break;
									}
									_loc11_++;
								}
								this.scrollList.selectedIndex = _loc10_;
							}
							else
							{
								this.scrollList.selectedIndex = -1;
							}
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
			this._itemRendererClassName = param1;
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
			var _loc2_:uint = 0;
			var _loc3_:MovieClip = null;
			if(this.ListEntryClass != null && param1 > 0)
			{
				_loc2_ = 0;
				while(_loc2_ < param1)
				{
					_loc3_ = this.GetNewListEntry(_loc2_);
					if(_loc3_ != null)
					{
						_loc3_.clipIndex = _loc2_;
						_loc3_.addEventListener(MouseEvent.MOUSE_OVER,this.onEntryRollover);
						_loc3_.addEventListener(MouseEvent.CLICK,this.onEntryPress);
						this.EntryHolder_mc.addChild(_loc3_);
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
		}
		
		protected function GetNewListEntry(param1:uint) : BSScrollingListEntry
		{
			return new this.ListEntryClass() as BSScrollingListEntry;
		}
		
		public function UpdateList() : *
		{
			var _loc7_:BSScrollingListEntry = null;
			var _loc8_:BSScrollingListEntry = null;
			if(!this.bInitialized || this.numListItems == 0)
			{
				trace("BSScrollingList::UpdateList -- Can\'t update list before list has been created.");
			}
			var _loc1_:Number = 0;
			var _loc2_:Number = this._filterer.ClampIndex(0);
			var _loc3_:Number = _loc2_;
			var _loc4_:uint = 0;
			while(_loc4_ < this.EntriesA.length)
			{
				this.EntriesA[_loc4_].clipIndex = int.MAX_VALUE;
				if(_loc4_ < this.iScrollPosition)
				{
					_loc2_ = this._filterer.GetNextFilterMatch(_loc2_);
				}
				_loc4_++;
			}
			var _loc5_:uint = 0;
			while(_loc5_ < this.uiNumListItems)
			{
				_loc7_ = this.GetClipByIndex(_loc5_);
				if(_loc7_)
				{
					_loc7_.visible = false;
					_loc7_.itemIndex = int.MAX_VALUE;
				}
				_loc5_++;
			}
			var _loc6_:Vector.<Object> = new Vector.<Object>();
			this.iListItemsShown = 0;
			if(this.needMobileScrollList)
			{
				while(_loc3_ != int.MAX_VALUE && _loc3_ != -1 && _loc3_ < this.EntriesA.length && _loc1_ <= this.fListHeight)
				{
					_loc6_.push(this.EntriesA[_loc3_]);
					_loc3_ = this._filterer.GetNextFilterMatch(_loc3_);
				}
			}
			while(_loc2_ != int.MAX_VALUE && _loc2_ != -1 && _loc2_ < this.EntriesA.length && this.iListItemsShown < this.uiNumListItems && _loc1_ <= this.fListHeight)
			{
				_loc8_ = this.GetClipByIndex(this.iListItemsShown);
				if(_loc8_)
				{
					this.SetEntry(_loc8_,this.EntriesA[_loc2_]);
					this.EntriesA[_loc2_].clipIndex = this.iListItemsShown;
					_loc8_.itemIndex = _loc2_;
					_loc8_.visible = !this.needMobileScrollList;
					_loc1_ = _loc1_ + _loc8_.height;
					if(_loc1_ <= this.fListHeight && this.iListItemsShown < this.uiNumListItems)
					{
						_loc1_ = _loc1_ + this.fVerticalSpacing;
						this.iListItemsShown++;
					}
					else if(this.textOption != TEXT_OPTION_MULTILINE)
					{
						this.EntriesA[_loc2_].clipIndex = int.MAX_VALUE;
						_loc8_.visible = false;
					}
					else
					{
						this.iListItemsShown++;
					}
				}
				_loc2_ = this._filterer.GetNextFilterMatch(_loc2_);
			}
			if(this.needMobileScrollList)
			{
				this.setMobileScrollingListData(_loc6_);
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
			if(this.restoreListIndex && !this.needMobileScrollList)
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
			var _loc7_:int = 0;
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
					_loc5_ = _loc3_;
					_loc3_ = this._filterer.GetPrevFilterMatch(_loc3_);
					if(_loc3_ != int.MAX_VALUE)
					{
						_loc2_ = _loc2_ + (this.GetEntryHeight(_loc3_) + this.fVerticalSpacing);
						if(_loc2_ < this.fListHeight)
						{
							_loc4_++;
						}
						else
						{
							_loc3_ = _loc5_;
						}
					}
				}
				if(_loc3_ == int.MAX_VALUE)
				{
					this.iMaxScrollPosition = 0;
				}
				else
				{
					_loc6_ = 0;
					_loc7_ = this._filterer.GetPrevFilterMatch(_loc3_);
					while(_loc7_ != int.MAX_VALUE)
					{
						_loc6_++;
						_loc7_ = this._filterer.GetPrevFilterMatch(_loc7_);
					}
					this.iMaxScrollPosition = _loc6_;
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
						dispatchEvent(new Event(PLAY_FOCUS_SOUND,true,true));
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
						dispatchEvent(new Event(PLAY_FOCUS_SOUND,true,true));
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
		
		protected function createMobileScrollingList() : void
		{
			var _loc1_:Number = NaN;
			var _loc2_:Number = NaN;
			var _loc3_:Number = NaN;
			var _loc4_:String = null;
			var _loc5_:Boolean = false;
			var _loc6_:Boolean = false;
			if(this._itemRendererClassName != null)
			{
				_loc1_ = BSScrollingListInterface.GetMobileScrollListProperties(this._itemRendererClassName).maskDimension;
				_loc2_ = BSScrollingListInterface.GetMobileScrollListProperties(this._itemRendererClassName).spaceBetweenButtons;
				_loc3_ = BSScrollingListInterface.GetMobileScrollListProperties(this._itemRendererClassName).scrollDirection;
				_loc4_ = BSScrollingListInterface.GetMobileScrollListProperties(this._itemRendererClassName).linkageId;
				_loc5_ = BSScrollingListInterface.GetMobileScrollListProperties(this._itemRendererClassName).clickable;
				_loc6_ = BSScrollingListInterface.GetMobileScrollListProperties(this._itemRendererClassName).reversed;
				this.scrollList = new MobileScrollList(_loc1_,_loc2_,_loc3_);
				this.scrollList.itemRendererLinkageId = _loc4_;
				this.scrollList.noScrollShortList = true;
				this.scrollList.clickable = _loc5_;
				this.scrollList.endListAlign = _loc6_;
				this.scrollList.textOption = this.strTextOption;
				this.scrollList.setScrollIndicators(this.ScrollUp,this.ScrollDown);
				this.scrollList.x = 0;
				this.scrollList.y = 0;
				addChild(this.scrollList);
				this.scrollList.addEventListener(MobileScrollList.ITEM_SELECT,this.onMobileScrollListItemSelected,false,0,true);
			}
		}
		
		protected function destroyMobileScrollingList() : void
		{
			if(this.scrollList != null)
			{
				this.scrollList.removeEventListener(MobileScrollList.ITEM_SELECT,this.onMobileScrollListItemSelected);
				removeChild(this.scrollList);
				this.scrollList.destroy();
			}
		}
		
		protected function onMobileScrollListItemSelected(param1:EventWithParams) : void
		{
			var _loc2_:MobileListItemRenderer = param1.params.renderer as MobileListItemRenderer;
			var _loc3_:int = _loc2_.data.id;
			var _loc4_:* = this.iSelectedIndex;
			this.iSelectedIndex = this.GetEntryFromClipIndex(_loc3_);
			var _loc5_:uint = 0;
			while(_loc5_ < this.EntriesA.length)
			{
				if(this.EntriesA[_loc5_] == _loc2_.data)
				{
					this.iSelectedIndex = _loc5_;
					break;
				}
				_loc5_++;
			}
			if(!this.EntriesA[this.iSelectedIndex].isDivider)
			{
				if(_loc4_ != this.iSelectedIndex)
				{
					this.iSelectedClipIndex = this.iSelectedIndex != -1?int(this.EntriesA[this.iSelectedIndex].clipIndex):-1;
					dispatchEvent(new Event(SELECTION_CHANGE,true,true));
					dispatchEvent(new Event(MOBILE_ITEM_PRESS,true,true));
				}
				else if(this.scrollList.itemRendererLinkageId == BSScrollingListInterface.RADIO_RENDERER_LINKAGE_ID || this.scrollList.itemRendererLinkageId == BSScrollingListInterface.QUEST_RENDERER_LINKAGE_ID || this.scrollList.itemRendererLinkageId == BSScrollingListInterface.QUEST_OBJECTIVES_RENDERER_LINKAGE_ID || this.scrollList.itemRendererLinkageId == BSScrollingListInterface.INVENTORY_RENDERER_LINKAGE_ID)
				{
					this.onItemPress();
				}
			}
		}
		
		protected function setMobileScrollingListData(param1:Vector.<Object>) : void
		{
			if(param1 != null)
			{
				if(param1.length > 0)
				{
					this.scrollList.setData(param1);
				}
				else
				{
					this.scrollList.invalidateData();
				}
			}
			else
			{
				trace("setMobileScrollingListData::Error: No data received to display List Items!");
			}
		}
	}
}
