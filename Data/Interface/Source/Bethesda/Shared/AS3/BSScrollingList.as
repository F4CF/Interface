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
		
		protected var bAllowWheelScrollNoSelectionChange:Boolean;
		
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
			this.bAllowWheelScrollNoSelectionChange = false;
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
			return CompanionAppMode.isOn;
		}
		
		public function onComponentInit(event:Event) : *
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
		
		protected function onStageInit(event:Event) : *
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
		
		protected function onStageDestruct(event:Event) : *
		{
			stage.removeEventListener(PlatformChangeEvent.PLATFORM_CHANGE,this.onSetPlatform);
			if(this.needMobileScrollList)
			{
				this.destroyMobileScrollingList();
			}
		}
		
		public function onScrollArrowClick(event:Event) : *
		{
			if(!this.bDisableInput && !this.bDisableSelection)
			{
				this.doSetSelectedIndex(-1);
				if(event.target == this.ScrollUp || event.target.parent == this.ScrollUp)
				{
					this.scrollPosition = this.scrollPosition - 1;
				}
				else if(event.target == this.ScrollDown || event.target.parent == this.ScrollDown)
				{
					this.scrollPosition = this.scrollPosition + 1;
				}
				event.stopPropagation();
			}
		}
		
		public function onEntryRollover(event:Event) : *
		{
			var prevSelection:* = undefined;
			this.bMouseDrivenNav = true;
			if(!this.bDisableInput && !this.bDisableSelection)
			{
				prevSelection = this.iSelectedIndex;
				this.doSetSelectedIndex((event.currentTarget as BSScrollingListEntry).itemIndex);
				if(prevSelection != this.iSelectedIndex)
				{
					dispatchEvent(new Event(PLAY_FOCUS_SOUND,true,true));
				}
			}
		}
		
		public function onEntryPress(event:MouseEvent) : *
		{
			event.stopPropagation();
			this.bMouseDrivenNav = true;
			this.onItemPress();
		}
		
		public function ClearList() : *
		{
			this.EntriesA.splice(0,this.EntriesA.length);
		}
		
		public function GetClipByIndex(auiIndex:uint) : BSScrollingListEntry
		{
			return auiIndex < this.EntryHolder_mc.numChildren?this.EntryHolder_mc.getChildAt(auiIndex) as BSScrollingListEntry:null;
		}
		
		public function GetEntryFromClipIndex(aiClipIndex:int) : int
		{
			var ientryIndex:int = -1;
			for(var i:uint = 0; i < this.EntriesA.length; i++)
			{
				if(this.EntriesA[i].clipIndex <= aiClipIndex)
				{
					ientryIndex = i;
				}
			}
			return ientryIndex;
		}
		
		public function onKeyDown(event:KeyboardEvent) : *
		{
			if(!this.bDisableInput)
			{
				if(event.keyCode == Keyboard.UP)
				{
					this.moveSelectionUp();
					event.stopPropagation();
				}
				else if(event.keyCode == Keyboard.DOWN)
				{
					this.moveSelectionDown();
					event.stopPropagation();
				}
			}
		}
		
		public function onKeyUp(event:KeyboardEvent) : *
		{
			if(!this.bDisableInput && !this.bDisableSelection && event.keyCode == Keyboard.ENTER)
			{
				this.onItemPress();
				event.stopPropagation();
			}
		}
		
		public function onMouseWheel(event:MouseEvent) : *
		{
			var prevScrollPos:* = undefined;
			if(!this.bDisableInput && (!this.bDisableSelection || this.bAllowWheelScrollNoSelectionChange) && this.iMaxScrollPosition > 0)
			{
				prevScrollPos = this.scrollPosition;
				if(event.delta < 0)
				{
					this.scrollPosition = this.scrollPosition + 1;
				}
				else if(event.delta > 0)
				{
					this.scrollPosition = this.scrollPosition - 1;
				}
				this.SetFocusUnderMouse();
				event.stopPropagation();
				if(prevScrollPos != this.scrollPosition)
				{
					dispatchEvent(new Event(PLAY_FOCUS_SOUND,true,true));
				}
			}
		}
		
		private function SetFocusUnderMouse() : *
		{
			var objectListEntry:BSScrollingListEntry = null;
			var borderObject:MovieClip = null;
			var testPoint:Point = null;
			for(var ientryCt:int = 0; ientryCt < this.iListItemsShown; ientryCt++)
			{
				objectListEntry = this.GetClipByIndex(ientryCt);
				borderObject = objectListEntry.border;
				testPoint = localToGlobal(new Point(mouseX,mouseY));
				if(objectListEntry.hitTestPoint(testPoint.x,testPoint.y,false))
				{
					this.selectedIndex = objectListEntry.itemIndex;
				}
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
		
		public function set selectedIndex(aiNewIndex:int) : *
		{
			this.doSetSelectedIndex(aiNewIndex);
		}
		
		public function get selectedClipIndex() : int
		{
			return this.iSelectedClipIndex;
		}
		
		public function set selectedClipIndex(aiNewIndex:int) : *
		{
			this.doSetSelectedIndex(this.GetEntryFromClipIndex(aiNewIndex));
		}
		
		public function set filterer(newFilter:ListFilterer) : *
		{
			this._filterer = newFilter;
		}
		
		public function get shownItemsHeight() : Number
		{
			return this.fShownItemsHeight;
		}
		
		protected function doSetSelectedIndex(aiNewIndex:int) : *
		{
			var ioldSelection:int = 0;
			var selectedBottomEntryCutOff:Boolean = false;
			var bottomClipIndex:int = 0;
			var bottomSelectClip:BSScrollingListEntry = null;
			var currTopIndex:int = 0;
			var currBottomIndex:int = 0;
			var currIndex:int = 0;
			var ioffset:int = 0;
			var index:int = 0;
			var i:uint = 0;
			if(!this.bInitialized || this.numListItems == 0)
			{
				trace("BSScrollingList::doSetSelectedIndex -- Can\'t set selection before list has been created.");
			}
			if(!this.bDisableSelection && aiNewIndex != this.iSelectedIndex)
			{
				ioldSelection = this.iSelectedIndex;
				this.iSelectedIndex = aiNewIndex;
				if(this.EntriesA.length == 0)
				{
					this.iSelectedIndex = -1;
				}
				if(ioldSelection != -1 && ioldSelection < this.EntriesA.length && this.EntriesA[ioldSelection].clipIndex != int.MAX_VALUE)
				{
					this.SetEntry(this.GetClipByIndex(this.EntriesA[ioldSelection].clipIndex),this.EntriesA[ioldSelection]);
				}
				if(this.iSelectedIndex != -1)
				{
					this.iSelectedIndex = this._filterer.ClampIndex(this.iSelectedIndex);
					if(this.iSelectedIndex == int.MAX_VALUE)
					{
						this.iSelectedIndex = -1;
					}
					if(this.iSelectedIndex != -1 && ioldSelection != this.iSelectedIndex)
					{
						selectedBottomEntryCutOff = false;
						if(this.textOption == TEXT_OPTION_MULTILINE)
						{
							bottomClipIndex = this.GetEntryFromClipIndex(this.uiNumListItems - 1);
							if(bottomClipIndex != -1 && bottomClipIndex == this.iSelectedIndex && this.EntriesA[bottomClipIndex].clipIndex != int.MAX_VALUE)
							{
								bottomSelectClip = this.GetClipByIndex(this.EntriesA[bottomClipIndex].clipIndex);
								if(bottomSelectClip != null && bottomSelectClip.y + bottomSelectClip.height > this.fListHeight)
								{
									selectedBottomEntryCutOff = true;
								}
							}
						}
						if(this.EntriesA[this.iSelectedIndex].clipIndex != int.MAX_VALUE && !selectedBottomEntryCutOff)
						{
							this.SetEntry(this.GetClipByIndex(this.EntriesA[this.iSelectedIndex].clipIndex),this.EntriesA[this.iSelectedIndex]);
						}
						else
						{
							currTopIndex = this.GetEntryFromClipIndex(0);
							currBottomIndex = this.GetEntryFromClipIndex(this.uiNumListItems - 1);
							ioffset = 0;
							if(this.iSelectedIndex < currTopIndex)
							{
								currIndex = currTopIndex;
								do
								{
									currIndex = this._filterer.GetPrevFilterMatch(currIndex);
									ioffset--;
								}
								while(currIndex != this.iSelectedIndex);
								
							}
							else if(this.iSelectedIndex > currBottomIndex)
							{
								currIndex = currBottomIndex;
								do
								{
									currIndex = this._filterer.GetNextFilterMatch(currIndex);
									ioffset++;
								}
								while(currIndex != this.iSelectedIndex);
								
							}
							else if(selectedBottomEntryCutOff)
							{
								ioffset++;
							}
							this.scrollPosition = this.scrollPosition + ioffset;
						}
					}
					if(this.needMobileScrollList)
					{
						if(this.scrollList != null)
						{
							if(this.iSelectedIndex != -1)
							{
								index = this.EntriesA[this.iSelectedIndex].clipIndex;
								for(i = 0; i < this.scrollList.data.length; i++)
								{
									if(this.EntriesA[this.iSelectedIndex] == this.scrollList.data[i])
									{
										index = i;
										break;
									}
								}
								this.scrollList.selectedIndex = index;
							}
							else
							{
								this.scrollList.selectedIndex = -1;
							}
						}
					}
				}
				if(ioldSelection != this.iSelectedIndex)
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
		
		public function set scrollPosition(aiNewPosition:uint) : *
		{
			if(aiNewPosition != this.iScrollPosition && aiNewPosition >= 0 && aiNewPosition <= this.iMaxScrollPosition)
			{
				this.updateScrollPosition(aiNewPosition);
			}
		}
		
		protected function updateScrollPosition(aiPosition:uint) : *
		{
			this.iScrollPosition = aiPosition;
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
		
		public function set entryList(anewArray:Array) : *
		{
			this.EntriesA = anewArray;
			if(this.EntriesA == null)
			{
				this.EntriesA = new Array();
			}
		}
		
		public function get disableInput() : Boolean
		{
			return this.bDisableInput;
		}
		
		public function set disableInput(abFlag:Boolean) : *
		{
			this.bDisableInput = abFlag;
		}
		
		public function get textOption() : String
		{
			return this.strTextOption;
		}
		
		public function set textOption(strNewOption:String) : *
		{
			this.strTextOption = strNewOption;
		}
		
		public function get verticalSpacing() : *
		{
			return this.fVerticalSpacing;
		}
		
		public function set verticalSpacing(afSpacing:Number) : *
		{
			this.fVerticalSpacing = afSpacing;
		}
		
		public function get numListItems() : uint
		{
			return this.uiNumListItems;
		}
		
		public function set numListItems(auiNumItems:uint) : *
		{
			this.uiNumListItems = auiNumItems;
		}
		
		public function set listEntryClass(strClass:String) : *
		{
			this.ListEntryClass = getDefinitionByName(strClass) as Class;
			this._itemRendererClassName = strClass;
		}
		
		public function get restoreListIndex() : Boolean
		{
			return this.bRestoreListIndex;
		}
		
		public function set restoreListIndex(abFlag:Boolean) : *
		{
			this.bRestoreListIndex = abFlag;
		}
		
		public function get disableSelection() : Boolean
		{
			return this.bDisableSelection;
		}
		
		public function set disableSelection(abFlag:Boolean) : *
		{
			this.bDisableSelection = abFlag;
		}
		
		public function set allowWheelScrollNoSelectionChange(abFlag:Boolean) : *
		{
			this.bAllowWheelScrollNoSelectionChange = abFlag;
		}
		
		protected function SetNumListItems(auiNumItems:uint) : *
		{
			var i:uint = 0;
			var newClip:MovieClip = null;
			if(this.ListEntryClass != null && auiNumItems > 0)
			{
				for(i = 0; i < auiNumItems; i++)
				{
					newClip = this.GetNewListEntry(i);
					if(newClip != null)
					{
						newClip.clipIndex = i;
						newClip.addEventListener(MouseEvent.MOUSE_OVER,this.onEntryRollover);
						newClip.addEventListener(MouseEvent.CLICK,this.onEntryPress);
						this.EntryHolder_mc.addChild(newClip);
					}
					else
					{
						trace("BSScrollingList::SetNumListItems -- List Entry Class is invalid or does not derive from BSScrollingListEntry.");
					}
				}
				this.bInitialized = true;
				dispatchEvent(new Event(LIST_ITEMS_CREATED,true,true));
			}
		}
		
		protected function GetNewListEntry(auiClipIndex:uint) : BSScrollingListEntry
		{
			return new this.ListEntryClass() as BSScrollingListEntry;
		}
		
		public function UpdateList() : *
		{
			var curClip:BSScrollingListEntry = null;
			var currEntry:BSScrollingListEntry = null;
			if(!this.bInitialized || this.numListItems == 0)
			{
				trace("BSScrollingList::UpdateList -- Can\'t update list before list has been created.");
			}
			var faccumHeight:Number = 0;
			var iupdateIndex:Number = this._filterer.ClampIndex(0);
			var iupdateMobileIndex:Number = iupdateIndex;
			for(var uiclearEntry:uint = 0; uiclearEntry < this.EntriesA.length; uiclearEntry++)
			{
				this.EntriesA[uiclearEntry].clipIndex = int.MAX_VALUE;
				if(uiclearEntry < this.iScrollPosition)
				{
					iupdateIndex = this._filterer.GetNextFilterMatch(iupdateIndex);
				}
			}
			for(var uiclip:uint = 0; uiclip < this.uiNumListItems; uiclip++)
			{
				curClip = this.GetClipByIndex(uiclip);
				if(curClip)
				{
					curClip.visible = false;
					curClip.itemIndex = int.MAX_VALUE;
				}
			}
			var fileteredData:Vector.<Object> = new Vector.<Object>();
			this.iListItemsShown = 0;
			if(this.needMobileScrollList)
			{
				while(iupdateMobileIndex != int.MAX_VALUE && iupdateMobileIndex != -1 && iupdateMobileIndex < this.EntriesA.length && faccumHeight <= this.fListHeight)
				{
					fileteredData.push(this.EntriesA[iupdateMobileIndex]);
					iupdateMobileIndex = this._filterer.GetNextFilterMatch(iupdateMobileIndex);
				}
			}
			while(iupdateIndex != int.MAX_VALUE && iupdateIndex != -1 && iupdateIndex < this.EntriesA.length && this.iListItemsShown < this.uiNumListItems && faccumHeight <= this.fListHeight)
			{
				currEntry = this.GetClipByIndex(this.iListItemsShown);
				if(currEntry)
				{
					this.SetEntry(currEntry,this.EntriesA[iupdateIndex]);
					this.EntriesA[iupdateIndex].clipIndex = this.iListItemsShown;
					currEntry.itemIndex = iupdateIndex;
					currEntry.visible = !this.needMobileScrollList;
					faccumHeight = faccumHeight + currEntry.height;
					if(faccumHeight <= this.fListHeight && this.iListItemsShown < this.uiNumListItems)
					{
						faccumHeight = faccumHeight + this.fVerticalSpacing;
						this.iListItemsShown++;
					}
					else if(this.textOption != TEXT_OPTION_MULTILINE)
					{
						this.EntriesA[iupdateIndex].clipIndex = int.MAX_VALUE;
						currEntry.visible = false;
					}
					else
					{
						this.iListItemsShown++;
					}
				}
				iupdateIndex = this._filterer.GetNextFilterMatch(iupdateIndex);
			}
			if(this.needMobileScrollList)
			{
				this.setMobileScrollingListData(fileteredData);
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
			var faccumHeight:Number = 0;
			var forigY:Number = this.border.y;
			for(var ientryCt:int = 0; ientryCt < this.iListItemsShown; ientryCt++)
			{
				this.GetClipByIndex(ientryCt).y = forigY + faccumHeight;
				faccumHeight = faccumHeight + (this.GetClipByIndex(ientryCt).height + this.fVerticalSpacing);
			}
			this.fShownItemsHeight = faccumHeight;
		}
		
		public function InvalidateData() : *
		{
			var btriggerSelectionChangeEvent:Boolean = false;
			this._filterer.filterArray = this.EntriesA;
			this.fListHeight = this.border.height;
			this.CalculateMaxScrollPosition();
			if(!this.restoreListIndex)
			{
				if(this.iSelectedIndex >= this.EntriesA.length)
				{
					this.iSelectedIndex = this.EntriesA.length - 1;
					btriggerSelectionChangeEvent = true;
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
			else if(btriggerSelectionChangeEvent)
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
		
		public function UpdateEntry(aEntry:Object) : *
		{
			this.SetEntry(this.GetClipByIndex(aEntry.clipIndex),aEntry);
		}
		
		public function onFilterChange() : *
		{
			this.iSelectedIndex = this._filterer.ClampIndex(this.iSelectedIndex);
			this.CalculateMaxScrollPosition();
		}
		
		protected function CalculateMaxScrollPosition() : *
		{
			var faccumHeight:Number = NaN;
			var iLastPageTopIndex:int = 0;
			var inumItemsShown:int = 0;
			var prevTopIndex:int = 0;
			var ioffset:int = 0;
			var iprevInFilterIndex:int = 0;
			var imaxIndex:int = !!this._filterer.EntryMatchesFilter(this.EntriesA[this.EntriesA.length - 1])?int(this.EntriesA.length - 1):int(this._filterer.GetPrevFilterMatch(this.EntriesA.length - 1));
			if(imaxIndex == int.MAX_VALUE)
			{
				this.iMaxScrollPosition = 0;
			}
			else
			{
				faccumHeight = this.GetEntryHeight(imaxIndex);
				iLastPageTopIndex = imaxIndex;
				inumItemsShown = 1;
				while(iLastPageTopIndex != int.MAX_VALUE && faccumHeight < this.fListHeight && inumItemsShown < this.uiNumListItems)
				{
					prevTopIndex = iLastPageTopIndex;
					iLastPageTopIndex = this._filterer.GetPrevFilterMatch(iLastPageTopIndex);
					if(iLastPageTopIndex != int.MAX_VALUE)
					{
						faccumHeight = faccumHeight + (this.GetEntryHeight(iLastPageTopIndex) + this.fVerticalSpacing);
						if(faccumHeight < this.fListHeight)
						{
							inumItemsShown++;
						}
						else
						{
							iLastPageTopIndex = prevTopIndex;
						}
					}
				}
				if(iLastPageTopIndex == int.MAX_VALUE)
				{
					this.iMaxScrollPosition = 0;
				}
				else
				{
					ioffset = 0;
					iprevInFilterIndex = this._filterer.GetPrevFilterMatch(iLastPageTopIndex);
					while(iprevInFilterIndex != int.MAX_VALUE)
					{
						ioffset++;
						iprevInFilterIndex = this._filterer.GetPrevFilterMatch(iprevInFilterIndex);
					}
					this.iMaxScrollPosition = ioffset;
				}
			}
		}
		
		protected function GetEntryHeight(aiEntryIndex:Number) : Number
		{
			var tempClip:BSScrollingListEntry = this.GetClipByIndex(0);
			this.SetEntry(tempClip,this.EntriesA[aiEntryIndex]);
			return tempClip != null?Number(tempClip.height):Number(0);
		}
		
		public function moveSelectionUp() : *
		{
			var iprevFilterMatch:Number = NaN;
			if(!this.bDisableSelection)
			{
				if(this.selectedIndex > 0)
				{
					iprevFilterMatch = this._filterer.GetPrevFilterMatch(this.selectedIndex);
					if(iprevFilterMatch != int.MAX_VALUE)
					{
						this.selectedIndex = iprevFilterMatch;
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
			var inextFilterMatch:Number = NaN;
			if(!this.bDisableSelection)
			{
				if(this.selectedIndex < this.EntriesA.length - 1)
				{
					inextFilterMatch = this._filterer.GetNextFilterMatch(this.selectedIndex);
					if(inextFilterMatch != int.MAX_VALUE)
					{
						this.selectedIndex = inextFilterMatch;
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
		
		protected function SetEntry(aEntryClip:BSScrollingListEntry, aEntryObject:Object) : *
		{
			if(aEntryClip != null)
			{
				aEntryClip.selected = aEntryObject == this.selectedEntry;
				aEntryClip.SetEntryText(aEntryObject,this.strTextOption);
			}
		}
		
		protected function onSetPlatform(event:Event) : *
		{
			var e:PlatformChangeEvent = event as PlatformChangeEvent;
			this.SetPlatform(e.uiPlatform,e.bPS3Switch);
		}
		
		public function SetPlatform(aiPlatform:Number, abPS3Switch:Boolean) : *
		{
			this.iPlatform = aiPlatform;
			this.bMouseDrivenNav = this.iPlatform == 0?true:false;
		}
		
		protected function createMobileScrollingList() : void
		{
			var maskDimension:Number = NaN;
			var spaceBetweenButtons:Number = NaN;
			var scrollDirection:Number = NaN;
			var linkageId:String = null;
			var clickable:Boolean = false;
			var reversed:Boolean = false;
			if(this._itemRendererClassName != null)
			{
				maskDimension = BSScrollingListInterface.GetMobileScrollListProperties(this._itemRendererClassName).maskDimension;
				spaceBetweenButtons = BSScrollingListInterface.GetMobileScrollListProperties(this._itemRendererClassName).spaceBetweenButtons;
				scrollDirection = BSScrollingListInterface.GetMobileScrollListProperties(this._itemRendererClassName).scrollDirection;
				linkageId = BSScrollingListInterface.GetMobileScrollListProperties(this._itemRendererClassName).linkageId;
				clickable = BSScrollingListInterface.GetMobileScrollListProperties(this._itemRendererClassName).clickable;
				reversed = BSScrollingListInterface.GetMobileScrollListProperties(this._itemRendererClassName).reversed;
				this.scrollList = new MobileScrollList(maskDimension,spaceBetweenButtons,scrollDirection);
				this.scrollList.itemRendererLinkageId = linkageId;
				this.scrollList.noScrollShortList = true;
				this.scrollList.clickable = clickable;
				this.scrollList.endListAlign = reversed;
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
		
		protected function onMobileScrollListItemSelected(e:EventWithParams) : void
		{
			var renderer:MobileListItemRenderer = e.params.renderer as MobileListItemRenderer;
			if(renderer.data == null)
			{
				return;
			}
			var rendererId:int = renderer.data.id;
			var ioldSelection:* = this.iSelectedIndex;
			this.iSelectedIndex = this.GetEntryFromClipIndex(rendererId);
			for(var i:uint = 0; i < this.EntriesA.length; i++)
			{
				if(this.EntriesA[i] == renderer.data)
				{
					this.iSelectedIndex = i;
					break;
				}
			}
			if(!this.EntriesA[this.iSelectedIndex].isDivider)
			{
				if(ioldSelection != this.iSelectedIndex)
				{
					this.iSelectedClipIndex = this.iSelectedIndex != -1?int(this.EntriesA[this.iSelectedIndex].clipIndex):-1;
					dispatchEvent(new Event(SELECTION_CHANGE,true,true));
					if(this.scrollList.itemRendererLinkageId == BSScrollingListInterface.PIPBOY_MESSAGE_RENDERER_LINKAGE_ID)
					{
						this.onItemPress();
					}
					dispatchEvent(new Event(MOBILE_ITEM_PRESS,true,true));
				}
				else if(this.scrollList.itemRendererLinkageId == BSScrollingListInterface.RADIO_RENDERER_LINKAGE_ID || this.scrollList.itemRendererLinkageId == BSScrollingListInterface.QUEST_RENDERER_LINKAGE_ID || this.scrollList.itemRendererLinkageId == BSScrollingListInterface.QUEST_OBJECTIVES_RENDERER_LINKAGE_ID || this.scrollList.itemRendererLinkageId == BSScrollingListInterface.INVENTORY_RENDERER_LINKAGE_ID || this.scrollList.itemRendererLinkageId == BSScrollingListInterface.PIPBOY_MESSAGE_RENDERER_LINKAGE_ID)
				{
					this.onItemPress();
				}
			}
		}
		
		protected function setMobileScrollingListData(data:Vector.<Object>) : void
		{
			if(data != null)
			{
				if(data.length > 0)
				{
					this.scrollList.setData(data);
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
