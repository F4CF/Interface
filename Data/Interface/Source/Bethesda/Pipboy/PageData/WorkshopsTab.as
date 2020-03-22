package
{
	import Shared.AS3.BSButtonHintData;
	import Shared.AS3.BSScrollingList;
	import Shared.AS3.COMPANIONAPP.CompanionAppMode;
	import Shared.BGSExternalInterface;
	
	public class WorkshopsTab extends PipboyTab
	{
		 
		
		public var List_mc:BSScrollingList;
		
		public var ItemCard_mc:Workshop_ItemCard;
		
		private var ShowOnMapButton:BSButtonHintData;
		
		public function WorkshopsTab()
		{
			this.ShowOnMapButton = new BSButtonHintData("$Show on Map","R","PSN_X","Xenon_X",1,this.onShowOnMap);
			super();
			this.List_mc.addEventListener(BSScrollingList.SELECTION_CHANGE,this.onListSelectionChange);
			this.__setProp_List_mc_WorkshopsTab_List_0();
		}
		
		override public function PopulateButtonHintData(param1:Vector.<BSButtonHintData>) : *
		{
			param1.push(this.ShowOnMapButton);
			this.ShowOnMapButton.ButtonVisible = false;
		}
		
		override protected function GetUpdateMask() : PipboyUpdateMask
		{
			return PipboyUpdateMask.Workshop;
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
					this.List_mc.scrollList.needFullRefresh = true;
				}
			}
			this.List_mc.entryList = param1.DataObj.WorkshopsList;
			this.List_mc.entryList.sortOn("text");
			this.List_mc.InvalidateData();
			if(_loc3_)
			{
				stage.focus = this.List_mc;
				if(this.List_mc.selectedIndex == -1)
				{
					this.List_mc.selectedClipIndex = 0;
				}
			}
			else
			{
				this.List_mc.selectedIndex = -1;
			}
			this.UpdateItemCard();
			SetIsDirty();
		}
		
		override public function redrawUIComponent() : void
		{
			super.redrawUIComponent();
			this.ShowOnMapButton.ButtonVisible = this.visible && this.List_mc.selectedEntry != null;
		}
		
		public function onListSelectionChange() : *
		{
			this.UpdateItemCard();
		}
		
		private function UpdateItemCard() : void
		{
			if(this.List_mc.selectedEntry != null)
			{
				this.ItemCard_mc.SetData(this.List_mc.selectedEntry.workshopData);
				this.ItemCard_mc.visible = true;
			}
			else
			{
				this.ItemCard_mc.visible = false;
			}
		}
		
		override public function ProcessUserEvent(param1:String, param2:Boolean) : Boolean
		{
			var _loc3_:Boolean = false;
			if(param1 == "XButton" && this.ShowOnMapButton.ButtonVisible && !param2)
			{
				this.onShowOnMap();
				_loc3_ = true;
			}
			return _loc3_;
		}
		
		private function onShowOnMap() : *
		{
			if(this.List_mc.selectedEntry != null)
			{
				BGSExternalInterface.call(this.codeObj,"ShowWorkshopOnMap",this.List_mc.selectedEntry.mapMarkerID);
			}
		}
		
		function __setProp_List_mc_WorkshopsTab_List_0() : *
		{
			try
			{
				this.List_mc["componentInspectorSetting"] = true;
			}
			catch(e:Error)
			{
			}
			this.List_mc.listEntryClass = "WorkshopsListEntry";
			this.List_mc.numListItems = 10;
			this.List_mc.restoreListIndex = false;
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
