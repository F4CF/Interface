package ExamineMenu_fla
{
	import flash.display.MovieClip;
	
	public dynamic class InventoryListBase_24 extends MovieClip
	{
		 
		
		public var Brackets_mc:MovieClip;
		
		public var InventoryList_mc:ExamineMenuList;
		
		public function InventoryListBase_24()
		{
			super();
			this.__setProp_InventoryList_mc_InventoryListBase_InventoryList_mc_0();
		}
		
		function __setProp_InventoryList_mc_InventoryListBase_InventoryList_mc_0() : *
		{
			try
			{
				this.InventoryList_mc["componentInspectorSetting"] = true;
			}
			catch(e:Error)
			{
			}
			this.InventoryList_mc.listEntryClass = "InvListEntry";
			this.InventoryList_mc.numListItems = 6;
			this.InventoryList_mc.restoreListIndex = false;
			this.InventoryList_mc.textOption = "Shrink To Fit";
			this.InventoryList_mc.verticalSpacing = 0;
			try
			{
				this.InventoryList_mc["componentInspectorSetting"] = false;
				return;
			}
			catch(e:Error)
			{
				return;
			}
		}
	}
}
