package
{
	import Shared.AS3.BSUIComponent;
	import flash.display.MovieClip;
	import flash.text.TextField;
	import flash.events.KeyboardEvent;
	import flash.events.Event;
	import Shared.PlatformChangeEvent;
	import Shared.GlobalFunc;
	import flash.display.BlendMode;
	import flash.events.MouseEvent;
	import flash.ui.Keyboard;
	import Shared.AS3.BSScrollingList;
	
	public class ModLibraryPage extends BSUIComponent
	{
		
		public static const REORDER_COMPLETE:String = "ModLibraryPage::reorderComplete";
		 
		
		public var List_mc:ModLibrary_List;
		
		public var ReorderIcon_mc:MovieClip;
		
		public var Background_mc:MovieClip;
		
		public var EmptyWarning_tf:TextField;
		
		public var TotalModSpace_tf:TextField;
		
		public var FreeSpace_tf:TextField;
		
		public var Description_tf:TextField;
		
		public var DescriptionLabel_tf:TextField;
		
		public var FileSizeBackground_mc:MovieClip;
		
		public var TextScrollUp:MovieClip;
		
		public var TextScrollDown:MovieClip;
		
		private var TextScrollDeltaAccum:Number;
		
		private const RIGHT_INPUT_SCROLL_THRESHOLD:Number = 3;
		
		private var _ReorderingMode:Boolean;
		
		private var _TotalModSpace:Number;
		
		private var _FreeSpace:Number;
		
		public function ModLibraryPage()
		{
			super();
			this._ReorderingMode = false;
			this._TotalModSpace = 0;
			this._FreeSpace = 0;
			this.EmptyWarning_tf.visible = false;
			this.Description_tf.visible = false;
			this.DescriptionLabel_tf.visible = false;
			this.TextScrollDeltaAccum = 0;
			addEventListener(MouseEvent.MOUSE_WHEEL,this.onMouseWheel);
			this.List_mc.addEventListener(BSScrollingList.SELECTION_CHANGE,this.onSelectionChange);
			this.Description_tf.addEventListener(Event.SCROLL,this.UpdateTextScrollIndicators);
			this.TextScrollUp.addEventListener(MouseEvent.CLICK,this.onTextScrollUpClicked);
			this.TextScrollDown.addEventListener(MouseEvent.CLICK,this.onTextScrollDownClicked);
			this.__setProp_List_mc_ModLibraryPage_List_0();
		}
		
		public function get dataArray() : Array
		{
			return this.List_mc.entryList;
		}
		
		public function get reorderMode() : Boolean
		{
			return this._ReorderingMode;
		}
		
		public function set reorderMode(param1:Boolean) : *
		{
			if(this.List_mc.selectedEntry != null && this.List_mc.selectedEntry.disabled != true)
			{
				this._ReorderingMode = param1;
				this.List_mc.disableInput = this._ReorderingMode;
				if(this._ReorderingMode)
				{
					addEventListener(KeyboardEvent.KEY_DOWN,this.onKeyDown_Reorder);
				}
				else
				{
					removeEventListener(KeyboardEvent.KEY_DOWN,this.onKeyDown_Reorder);
					dispatchEvent(new Event(REORDER_COMPLETE,true,true));
				}
				this.UpdateReorderIconPosition();
			}
		}
		
		public function GetModSpaceRemaining() : Number
		{
			return this._FreeSpace - this._TotalModSpace;
		}
		
		private function UpdateReorderIconPosition() : *
		{
			if(!this._ReorderingMode || this.List_mc.selectedIndex == -1)
			{
				this.ReorderIcon_mc.visible = false;
			}
			else
			{
				this.ReorderIcon_mc.y = this.List_mc.y + this.List_mc.GetClipByIndex(this.List_mc.selectedClipIndex).y + this.List_mc.GetClipByIndex(this.List_mc.selectedClipIndex).height / 2;
				this.ReorderIcon_mc.visible = true;
			}
		}
		
		public function set freeSpace(param1:Number) : *
		{
			this._FreeSpace = param1;
		}
		
		public function InvalidateData() : *
		{
			var _loc1_:* = undefined;
			this.List_mc.InvalidateData();
			this._TotalModSpace = 0;
			for each(_loc1_ in this.List_mc.entryList)
			{
				this._TotalModSpace = this._TotalModSpace + _loc1_.fileSizeDisplay;
			}
			this.EmptyWarning_tf.visible = this.List_mc.entryList.length == 0;
			if(this.iPlatform == PlatformChangeEvent.PLATFORM_PC_KB_MOUSE || this.iPlatform == PlatformChangeEvent.PLATFORM_PC_GAMEPAD)
			{
				this.FreeSpace_tf.visible = false;
			}
			else
			{
				this.FreeSpace_tf.visible = true;
			}
			GlobalFunc.SetText(this.TotalModSpace_tf,"$$ModSpace: " + Main_ModManager.GetFileSizeString(this._TotalModSpace),false);
			GlobalFunc.SetText(this.FreeSpace_tf,"$$FreeSpace: " + Main_ModManager.GetFileSizeString(this._FreeSpace - this._TotalModSpace),false);
			if(this.iPlatform == PlatformChangeEvent.PLATFORM_PS4)
			{
				this.Background_mc.blendMode = BlendMode.NORMAL;
				this.FileSizeBackground_mc.blendMode = BlendMode.NORMAL;
			}
			this.UpdateTextScrollIndicators();
		}
		
		private function onSelectionChange() : *
		{
			if(this.List_mc.selectedEntry != null && this.List_mc.selectedEntry.dataObj is Object)
			{
				GlobalFunc.SetText(this.Description_tf,this.List_mc.selectedEntry.dataObj.description,false);
				this.Description_tf.scrollV = 0;
				this.Description_tf.visible = true;
				this.DescriptionLabel_tf.visible = true;
			}
			else
			{
				this.Description_tf.visible = false;
				this.DescriptionLabel_tf.visible = false;
			}
			this.UpdateTextScrollIndicators();
		}
		
		public function UpdateTextScrollIndicators() : *
		{
			this.TextScrollUp.visible = this.Description_tf.visible && this.Description_tf.scrollV > 1;
			this.TextScrollDown.visible = this.Description_tf.visible && this.Description_tf.bottomScrollV < this.Description_tf.numLines;
		}
		
		public function OnRightStickInput(param1:Number, param2:Number) : *
		{
			this.TextScrollDeltaAccum = this.TextScrollDeltaAccum + Math.abs(param2);
			if(this.TextScrollDeltaAccum >= this.RIGHT_INPUT_SCROLL_THRESHOLD)
			{
				this.TextScrollDeltaAccum = 0;
				if(param2 > 0.1)
				{
					this.Description_tf.scrollV--;
				}
				if(param2 < -0.1)
				{
					this.Description_tf.scrollV++;
				}
			}
		}
		
		private function onTextScrollUpClicked() : *
		{
			this.Description_tf.scrollV--;
		}
		
		private function onTextScrollDownClicked() : *
		{
			this.Description_tf.scrollV++;
		}
		
		private function onMouseWheel(param1:MouseEvent) : *
		{
			if(hitTestPoint(stage.mouseX,stage.mouseY))
			{
				if(param1.delta < 0)
				{
					this.Description_tf.scrollV++;
				}
				else if(param1.delta > 0)
				{
					this.Description_tf.scrollV--;
				}
			}
		}
		
		public function onKeyDown_Reorder(param1:KeyboardEvent) : *
		{
			var _loc3_:Object = null;
			var _loc2_:int = this.List_mc.selectedIndex;
			if(param1.keyCode == Keyboard.UP && this.List_mc.selectedIndex > 0)
			{
				this.List_mc.MoveReorderUp();
				param1.stopPropagation();
			}
			else if(param1.keyCode == Keyboard.DOWN && this.List_mc.selectedIndex < this.List_mc.entryList.length - 1)
			{
				this.List_mc.MoveReorderDown();
				param1.stopPropagation();
			}
			if(_loc2_ != this.List_mc.selectedIndex)
			{
				this.UpdateReorderIconPosition();
			}
		}
		
		public function onDataObjectChange(param1:Object) : *
		{
			var _loc2_:uint = 0;
			while(_loc2_ < this.List_mc.entryList.length)
			{
				if(this.List_mc.entryList[_loc2_].dataObj == param1)
				{
					this.List_mc.UpdateEntry(this.List_mc.entryList[_loc2_]);
				}
				_loc2_++;
			}
		}
		
		public function ClearArray() : *
		{
			var _loc1_:uint = 0;
			while(_loc1_ < this.List_mc.entryList.length)
			{
				this.List_mc.entryList[_loc1_].dataObj = null;
				_loc1_++;
			}
			this.List_mc.ClearList();
		}
		
		public function CheckThumbnailsLoaded() : Boolean
		{
			var _loc3_:ModLibrary_ListEntry = null;
			var _loc1_:Boolean = true;
			var _loc2_:uint = 0;
			while(_loc1_ && _loc2_ < this.List_mc.entryList.length)
			{
				_loc3_ = this.List_mc.GetClipByIndex(_loc2_) as ModLibrary_ListEntry;
				if(_loc3_ == null || !_loc3_.CheckThumbnailLoaded())
				{
					_loc1_ = false;
				}
				_loc2_++;
			}
			return _loc1_;
		}
		
		function __setProp_List_mc_ModLibraryPage_List_0() : *
		{
			try
			{
				this.List_mc["componentInspectorSetting"] = true;
			}
			catch(e:Error)
			{
			}
			this.List_mc.disableSelection = false;
			this.List_mc.listEntryClass = "ModLibrary_ListEntry";
			this.List_mc.numListItems = 6;
			this.List_mc.restoreListIndex = true;
			this.List_mc.textOption = "Shrink To Fit";
			this.List_mc.verticalSpacing = 0;
			try
			{
				this.List_mc["componentInspectorSetting"] = false;
				return;
			}
			catch(e:Error)
			{
				return;
			}
		}
	}
}
