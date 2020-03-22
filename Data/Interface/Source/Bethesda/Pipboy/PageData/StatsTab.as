package
{
	import Shared.AS3.BSScrollingList;
	import Shared.AS3.COMPANIONAPP.CompanionAppMode;
	
	public class StatsTab extends PipboyTab
	{
		 
		
		public var CategoryList_mc:BSScrollingList;
		
		public var ValueList_mc:BSScrollingList;
		
		public function StatsTab()
		{
			super();
			this.CategoryList_mc.addEventListener(BSScrollingList.SELECTION_CHANGE,this.onListSelectionChange);
			this.ValueList_mc.disableSelection = true;
			this.ValueList_mc.disableInput = false;
			this.ValueList_mc.allowWheelScrollNoSelectionChange = true;
			this.__setProp_CategoryList_mc_StatsTab_Categories_0();
			this.__setProp_ValueList_mc_StatsTab_Values_0();
		}
		
		override protected function GetUpdateMask() : PipboyUpdateMask
		{
			return PipboyUpdateMask.Log;
		}
		
		override protected function onPipboyChangeEvent(param1:PipboyChangeEvent) : void
		{
			var _loc2_:* = this.visible == true;
			super.onPipboyChangeEvent(param1);
			var _loc3_:* = this.visible == true;
			if(CompanionAppMode.isOn)
			{
				if(!_loc2_ && _loc3_)
				{
					this.CategoryList_mc.scrollList.needFullRefresh = true;
					this.ValueList_mc.scrollList.needFullRefresh = true;
				}
			}
			this.CategoryList_mc.entryList = param1.DataObj.GeneralStatsList;
			this.CategoryList_mc.InvalidateData();
			if(_loc3_)
			{
				stage.focus = this.CategoryList_mc;
				if(this.CategoryList_mc.selectedIndex == -1)
				{
					this.CategoryList_mc.selectedClipIndex = 0;
				}
			}
			else
			{
				this.CategoryList_mc.selectedIndex = -1;
			}
			this.UpdateValueList();
			SetIsDirty();
		}
		
		override public function redrawUIComponent() : void
		{
			super.redrawUIComponent();
			this.ValueList_mc.InvalidateData();
		}
		
		public function onListSelectionChange() : *
		{
			if(CompanionAppMode.isOn)
			{
				this.ValueList_mc.scrollList.needFullRefresh = true;
			}
			this.UpdateValueList();
			SetIsDirty();
		}
		
		private function UpdateValueList() : *
		{
			this.ValueList_mc.entryList = this.CategoryList_mc.selectedEntry != null?this.CategoryList_mc.selectedEntry.statArray:null;
		}
		
		override public function GetIsUsingRightStick() : Boolean
		{
			return true;
		}
		
		override public function onRightThumbstickInput(param1:uint) : *
		{
			switch(param1)
			{
				case 1:
					this.ValueList_mc.scrollPosition = this.ValueList_mc.scrollPosition - 1;
					break;
				case 3:
					this.ValueList_mc.scrollPosition = this.ValueList_mc.scrollPosition + 1;
			}
		}
		
		function __setProp_CategoryList_mc_StatsTab_Categories_0() : *
		{
			try
			{
				this.CategoryList_mc["componentInspectorSetting"] = true;
			}
			catch(e:Error)
			{
			}
			this.CategoryList_mc.listEntryClass = "Stats_CategoriesListEntry";
			this.CategoryList_mc.numListItems = 10;
			this.CategoryList_mc.restoreListIndex = false;
			this.CategoryList_mc.textOption = "Shrink To Fit";
			this.CategoryList_mc.verticalSpacing = 2.25;
			try
			{
				this.CategoryList_mc["componentInspectorSetting"] = false;
				return;
			}
			catch(e:Error)
			{
				return;
			}
		}
		
		function __setProp_ValueList_mc_StatsTab_Values_0() : *
		{
			try
			{
				this.ValueList_mc["componentInspectorSetting"] = true;
			}
			catch(e:Error)
			{
			}
			this.ValueList_mc.listEntryClass = "Stats_ValuesListEntry";
			this.ValueList_mc.numListItems = 10;
			this.ValueList_mc.restoreListIndex = false;
			this.ValueList_mc.textOption = "Shrink To Fit";
			this.ValueList_mc.verticalSpacing = 2.75;
			try
			{
				this.ValueList_mc["componentInspectorSetting"] = false;
				return;
			}
			catch(e:Error)
			{
				return;
			}
		}
	}
}
