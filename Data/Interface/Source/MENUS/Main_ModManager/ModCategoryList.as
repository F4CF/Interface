package
{
	import Shared.AS3.BSUIComponent;
	import flash.display.MovieClip;
	import flash.text.TextField;
	import flash.display.DisplayObject;
	import flash.events.Event;
	import scaleform.gfx.Extensions;
	import Shared.GlobalFunc;
	import flash.events.MouseEvent;
	import flash.events.KeyboardEvent;
	import flash.ui.Keyboard;
	import scaleform.gfx.TextFieldEx;
	
	public class ModCategoryList extends BSUIComponent
	{
		
		public static const ITEM_PRESS:String = "ModCategoryList::itemPress";
		 
		
		public var EntryHolder_mc:MovieClip;
		
		public var Selection_mc:MovieClip;
		
		public var ScrollLeft:MovieClip;
		
		public var ScrollRight:MovieClip;
		
		public var EmptyClip_mc:MovieClip;
		
		public var CategoryName_tf:TextField;
		
		private var _DataObj:Object;
		
		private var _EntryClipsA:Array;
		
		private var _CurrScrollPage:uint;
		
		private var _MaxScrollPage:uint;
		
		private var _SelectedIndex:uint;
		
		private var _MaxSelectedIndex:uint;
		
		private var _UsingMouseNav:Boolean;
		
		private var _IsDirtyCustomFlag:int;
		
		private const SELECTION_RECT_DIRTY:int = 1 << 0;
		
		private const NAME_DIRTY:int = 1 << 1;
		
		private const SCROLL_DIRTY:int = 1 << 2;
		
		private const ALL_DIRTY:int = -1;
		
		private const MAX_ENTRIES:uint = 7;
		
		private const ENTRY_SPACING:Number = 7.5;
		
		public function ModCategoryList()
		{
			super();
			this._CurrScrollPage = 0;
			this._MaxScrollPage = 0;
			this._EntryClipsA = new Array();
			this._SelectedIndex = uint.MAX_VALUE;
			this._MaxSelectedIndex = uint.MAX_VALUE;
			this._IsDirtyCustomFlag = 0;
			this._UsingMouseNav = true;
			addEventListener(KeyboardEvent.KEY_DOWN,this.onKeyDown);
			addEventListener(KeyboardEvent.KEY_UP,this.onKeyUp);
			addEventListener(MouseEvent.MOUSE_OVER,this.onEntryRollover);
			addEventListener(MouseEvent.MOUSE_MOVE,this.onMouseMovement);
			addEventListener(MouseEvent.CLICK,this.onEntryPress);
			this.ScrollLeft.addEventListener(MouseEvent.CLICK,this.onScrollLeftClick);
			this.ScrollRight.addEventListener(MouseEvent.CLICK,this.onScrollRightClick);
			Extensions.enabled = true;
			TextFieldEx.setTextAutoSize(this.CategoryName_tf,TextFieldEx.TEXTAUTOSZ_SHRINK);
			this.PopulateEntryClips();
		}
		
		private function SetIsDirty_Custom(param1:int) : *
		{
			this._IsDirtyCustomFlag = this._IsDirtyCustomFlag | param1;
			SetIsDirty();
		}
		
		public function get selectedIndex() : uint
		{
			return this._SelectedIndex;
		}
		
		public function set selectedIndex(param1:uint) : *
		{
			this._SelectedIndex = param1;
			if(this._SelectedIndex != uint.MAX_VALUE)
			{
				this._SelectedIndex = Math.min(this._SelectedIndex,this._MaxSelectedIndex);
			}
			this.SetIsDirty_Custom(this.SELECTION_RECT_DIRTY);
		}
		
		public function get selectedEntry() : Object
		{
			return this._SelectedIndex != uint.MAX_VALUE?this._DataObj.entries[this._CurrScrollPage + this._SelectedIndex]:null;
		}
		
		public function set usingMouseNav(param1:Boolean) : *
		{
			this._UsingMouseNav = param1;
		}
		
		public function get currScrollPage() : uint
		{
			return this._CurrScrollPage;
		}
		
		public function set currScrollPage(param1:uint) : *
		{
			var _loc2_:Number = NaN;
			var _loc3_:uint = 0;
			var _loc4_:Number = NaN;
			var _loc5_:uint = 0;
			if(param1 == this._CurrScrollPage - 1 && this._CurrScrollPage > 0)
			{
				this._CurrScrollPage--;
				this._EntryClipsA[this.MAX_ENTRIES - 1].UnloadThumbnail();
				_loc2_ = this._EntryClipsA[0].x;
				_loc3_ = 0;
				while(_loc3_ < this.MAX_ENTRIES - 1)
				{
					this._EntryClipsA[_loc3_].x = this._EntryClipsA[_loc3_ + 1].x;
					this._EntryClipsA[_loc3_].itemIndex++;
					_loc3_++;
				}
				this._EntryClipsA.splice(0,0,this._EntryClipsA.pop());
				this._EntryClipsA[0].x = _loc2_;
				this._EntryClipsA[0].dataObj = this._DataObj.entries[this._CurrScrollPage];
				this._EntryClipsA[0].itemIndex = 0;
			}
			else if(param1 == this._CurrScrollPage + 1 && this._CurrScrollPage < this._MaxScrollPage)
			{
				this._CurrScrollPage++;
				this._EntryClipsA[0].UnloadThumbnail();
				_loc4_ = this._EntryClipsA[this.MAX_ENTRIES - 1].x;
				_loc5_ = this.MAX_ENTRIES - 1;
				while(_loc5_ >= 1)
				{
					this._EntryClipsA[_loc5_].x = this._EntryClipsA[_loc5_ - 1].x;
					this._EntryClipsA[_loc5_].itemIndex--;
					_loc5_--;
				}
				this._EntryClipsA.push(this._EntryClipsA.shift());
				this._EntryClipsA[this.MAX_ENTRIES - 1].x = _loc4_;
				this._EntryClipsA[this.MAX_ENTRIES - 1].dataObj = this._DataObj.entries[this._CurrScrollPage + this.MAX_ENTRIES - 1];
				this._EntryClipsA[this.MAX_ENTRIES - 1].itemIndex = this.MAX_ENTRIES - 1;
			}
			else if(param1 >= 0 && param1 <= this._MaxScrollPage)
			{
				this._CurrScrollPage = param1;
				this.RefreshScrollVars();
				this.RefreshEntryData();
			}
			this.SetIsDirty_Custom(this.SCROLL_DIRTY);
			if(this._DataObj != null)
			{
				this._DataObj.savedScrollPage = this._CurrScrollPage;
			}
		}
		
		public function get dataObj() : Object
		{
			return this._DataObj;
		}
		
		public function set dataObj(param1:Object) : *
		{
			var _loc2_:uint = this._SelectedIndex;
			var _loc3_:* = int(this.NAME_DIRTY);
			this._DataObj = param1;
			if(this._DataObj.savedScrollPage is uint)
			{
				this._CurrScrollPage = this._DataObj.savedScrollPage;
			}
			else
			{
				this._CurrScrollPage = 0;
				this._DataObj.savedScrollPage = 0;
			}
			this.RefreshScrollVars();
			this.RefreshEntryData();
			if(this._SelectedIndex != _loc2_)
			{
				_loc3_ = _loc3_ | this.SELECTION_RECT_DIRTY;
			}
			this.SetIsDirty_Custom(_loc3_);
		}
		
		public function CopyDataAndClips(param1:ModCategoryList) : *
		{
			var _loc3_:ModListEntry = null;
			var _loc4_:DisplayObject = null;
			this._DataObj = param1._DataObj;
			this._CurrScrollPage = param1._CurrScrollPage;
			this._MaxScrollPage = param1._MaxScrollPage;
			this._MaxSelectedIndex = param1._MaxSelectedIndex;
			this.selectedIndex = param1.selectedIndex;
			var _loc2_:uint = 0;
			while(_loc2_ < this.MAX_ENTRIES)
			{
				_loc3_ = this._EntryClipsA.shift() as ModListEntry;
				_loc4_ = param1._EntryClipsA[_loc2_];
				this._EntryClipsA.push(_loc4_);
				_loc3_.UnloadThumbnail();
				this.EntryHolder_mc.removeChild(_loc3_);
				this.EntryHolder_mc.addChild(_loc4_);
				_loc2_++;
			}
			param1._EntryClipsA.splice(0);
			param1.PopulateEntryClips();
			this.EmptyClip_mc.visible = param1.EmptyClip_mc.visible;
			this.SetIsDirty_Custom(this.SELECTION_RECT_DIRTY | this.NAME_DIRTY);
		}
		
		public function onDataObjectChange(param1:Object) : *
		{
			var _loc2_:uint = 0;
			while(this._DataObj != null && _loc2_ < this.MAX_ENTRIES)
			{
				if(this._DataObj.entries[this._CurrScrollPage + _loc2_] == param1)
				{
					this._EntryClipsA[_loc2_].dataObj = param1;
				}
				_loc2_++;
			}
		}
		
		private function PopulateEntryClips() : *
		{
			var _loc2_:* = undefined;
			var _loc3_:ModListEntry = null;
			if(this._EntryClipsA.length > 0)
			{
				for each(_loc2_ in this._EntryClipsA)
				{
					this.EntryHolder_mc.removeChild(_loc2_);
				}
			}
			this._EntryClipsA.splice(0);
			var _loc1_:uint = 0;
			while(_loc1_ < this.MAX_ENTRIES)
			{
				_loc3_ = new ModListEntry();
				this._EntryClipsA.push(_loc3_);
				_loc3_.x = (_loc3_.width + this.ENTRY_SPACING) * _loc1_;
				_loc3_.visible = false;
				_loc3_.itemIndex = _loc1_;
				this.EntryHolder_mc.addChild(_loc3_);
				_loc1_++;
			}
		}
		
		private function RefreshEntryData() : *
		{
			this._MaxSelectedIndex = uint.MAX_VALUE;
			var _loc1_:uint = 0;
			while(_loc1_ < this._EntryClipsA.length)
			{
				if(this._DataObj != null && this._DataObj.entries != null && this._CurrScrollPage + _loc1_ < this._DataObj.entries.length)
				{
					this._EntryClipsA[_loc1_].dataObj = this._DataObj.entries[this._CurrScrollPage + _loc1_];
					this._MaxSelectedIndex = _loc1_;
				}
				else
				{
					this._EntryClipsA[_loc1_].dataObj = null;
				}
				_loc1_++;
			}
			if(this._DataObj == null || this._DataObj.entries.length == 0)
			{
				this.EmptyClip_mc.visible = true;
				this._MaxSelectedIndex = 0;
			}
			else
			{
				this.EmptyClip_mc.visible = false;
			}
			if(this._MaxSelectedIndex == uint.MAX_VALUE)
			{
				this._SelectedIndex = uint.MAX_VALUE;
			}
			else if(this._SelectedIndex != uint.MAX_VALUE)
			{
				this._SelectedIndex = Math.min(this._SelectedIndex,this._MaxSelectedIndex);
			}
		}
		
		private function GetParentEntry(param1:DisplayObject) : ModListEntry
		{
			var _loc2_:DisplayObject = param1;
			while(_loc2_ != null && !(_loc2_ is ModListEntry))
			{
				_loc2_ = _loc2_.parent;
			}
			return _loc2_ as ModListEntry;
		}
		
		private function onEntryRollover(param1:Event) : *
		{
			this.AttemptNewSelection(param1.target as DisplayObject);
		}
		
		private function onMouseMovement() : *
		{
			this._UsingMouseNav = true;
			this.AttemptNewSelection(Extensions.getMouseTopMostEntity());
		}
		
		private function AttemptNewSelection(param1:DisplayObject) : *
		{
			var _loc3_:* = undefined;
			var _loc2_:ModListEntry = this.GetParentEntry(param1);
			if(this._UsingMouseNav && _loc2_ != null)
			{
				_loc3_ = this._SelectedIndex;
				this.selectedIndex = _loc2_.itemIndex;
				if(_loc3_ != this._SelectedIndex)
				{
					dispatchEvent(new Event(GlobalFunc.PLAY_FOCUS_SOUND,true,true));
				}
			}
		}
		
		private function onEntryPress(param1:MouseEvent) : *
		{
			if(this.GetParentEntry(param1.target as DisplayObject) != null)
			{
				param1.stopPropagation();
				dispatchEvent(new Event(ITEM_PRESS,true,true));
			}
		}
		
		private function RefreshScrollVars() : *
		{
			if(this._DataObj == null || this._DataObj.entries == null || this._DataObj.entries.length <= this.MAX_ENTRIES)
			{
				this._MaxScrollPage = 0;
			}
			else
			{
				this._MaxScrollPage = this._DataObj.entries.length - this.MAX_ENTRIES;
			}
			this._CurrScrollPage = Math.min(this._CurrScrollPage,this._MaxScrollPage);
		}
		
		override public function redrawUIComponent() : void
		{
			if((this._IsDirtyCustomFlag & this.NAME_DIRTY) != 0)
			{
				GlobalFunc.SetText(this.CategoryName_tf,this._DataObj != null?this._DataObj.text:"",false);
			}
			if((this._IsDirtyCustomFlag & this.SELECTION_RECT_DIRTY) != 0)
			{
				if(stage == null || stage.focus != this || this._SelectedIndex >= this._EntryClipsA.length)
				{
					this.Selection_mc.visible = false;
				}
				else
				{
					this.Selection_mc.x = this._EntryClipsA[this._SelectedIndex].x + 0;
					this.Selection_mc.y = this._EntryClipsA[this._SelectedIndex].y + 0;
					this.Selection_mc.visible = true;
				}
			}
			if(this.ScrollLeft != null)
			{
				this.ScrollLeft.visible = this._CurrScrollPage > 0;
			}
			if(this.ScrollRight != null)
			{
				this.ScrollRight.visible = this._MaxScrollPage > 0 && this._CurrScrollPage < this._MaxScrollPage;
			}
			this._IsDirtyCustomFlag = 0;
		}
		
		private function onKeyDown(param1:KeyboardEvent) : *
		{
			if(param1.keyCode == Keyboard.LEFT)
			{
				this.moveSelectionLeft();
				param1.stopPropagation();
				this._UsingMouseNav = false;
			}
			else if(param1.keyCode == Keyboard.RIGHT)
			{
				this.moveSelectionRight();
				param1.stopPropagation();
				this._UsingMouseNav = false;
			}
		}
		
		private function onKeyUp(param1:KeyboardEvent) : *
		{
			if(param1.keyCode == Keyboard.ENTER)
			{
				dispatchEvent(new Event(ITEM_PRESS,true,true));
				param1.stopPropagation();
			}
		}
		
		private function moveSelectionLeft() : *
		{
			if(this.selectedIndex > 0)
			{
				this.selectedIndex = this.selectedIndex - 1;
				dispatchEvent(new Event(GlobalFunc.PLAY_FOCUS_SOUND,true,true));
			}
			else if(this._CurrScrollPage > 0)
			{
				this.currScrollPage = this.currScrollPage - 1;
				dispatchEvent(new Event(GlobalFunc.PLAY_FOCUS_SOUND,true,true));
			}
		}
		
		private function moveSelectionRight() : *
		{
			if(this.selectedIndex < this.MAX_ENTRIES - 1)
			{
				this.selectedIndex = this.selectedIndex + 1;
				dispatchEvent(new Event(GlobalFunc.PLAY_FOCUS_SOUND,true,true));
			}
			else if(this._CurrScrollPage < this._MaxScrollPage)
			{
				this.currScrollPage = this.currScrollPage + 1;
				dispatchEvent(new Event(GlobalFunc.PLAY_FOCUS_SOUND,true,true));
			}
		}
		
		private function onScrollLeftClick(param1:MouseEvent) : *
		{
			if(this._CurrScrollPage > 0)
			{
				this.currScrollPage = this.currScrollPage - 1;
				dispatchEvent(new Event(GlobalFunc.PLAY_FOCUS_SOUND,true,true));
			}
			param1.stopPropagation();
		}
		
		private function onScrollRightClick(param1:MouseEvent) : *
		{
			if(this._CurrScrollPage < this._MaxScrollPage)
			{
				this.currScrollPage = this.currScrollPage + 1;
				dispatchEvent(new Event(GlobalFunc.PLAY_FOCUS_SOUND,true,true));
			}
			param1.stopPropagation();
		}
		
		public function JumpLeft() : *
		{
			var _loc1_:uint = 0;
			if(this._CurrScrollPage > 0)
			{
				_loc1_ = 0;
				while(_loc1_ < this.MAX_ENTRIES)
				{
					this._EntryClipsA[_loc1_].UnloadThumbnail();
					_loc1_++;
				}
				this.currScrollPage = this.currScrollPage - Math.min(this.currScrollPage,this.MAX_ENTRIES);
				dispatchEvent(new Event(GlobalFunc.PLAY_FOCUS_SOUND,true,true));
				this._UsingMouseNav = false;
			}
		}
		
		public function JumpRight() : *
		{
			var _loc1_:uint = 0;
			if(this._CurrScrollPage < this._MaxScrollPage)
			{
				_loc1_ = 0;
				while(_loc1_ < this.MAX_ENTRIES)
				{
					this._EntryClipsA[_loc1_].UnloadThumbnail();
					_loc1_++;
				}
				this.currScrollPage = this.currScrollPage + Math.min(this._MaxScrollPage - this.currScrollPage,this.MAX_ENTRIES);
				dispatchEvent(new Event(GlobalFunc.PLAY_FOCUS_SOUND,true,true));
				this._UsingMouseNav = false;
			}
		}
		
		public function CheckScreenshotsLoaded() : Boolean
		{
			var _loc1_:Boolean = true;
			var _loc2_:uint = 0;
			while(_loc1_ && _loc2_ < this.MAX_ENTRIES)
			{
				if(!this._EntryClipsA[_loc2_].CheckScreenshotLoaded())
				{
					_loc1_ = false;
				}
				_loc2_++;
			}
			return _loc1_;
		}
	}
}
