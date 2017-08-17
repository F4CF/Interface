package ExamineMenu_fla
{
	import flash.display.MovieClip;
	import flash.text.TextField;
	
	public dynamic class ModsBase_5 extends MovieClip
	{
		 
		
		public var ModSlotList_mc:CurrentModList;
		
		public var SlotsLabel_tf:TextField;
		
		public function ModsBase_5()
		{
			super();
			this.__setProp_ModSlotList_mc_ModsBase_ModSlotList_mc_0();
		}
		
		function __setProp_ModSlotList_mc_ModsBase_ModSlotList_mc_0() : *
		{
			try
			{
				this.ModSlotList_mc["componentInspectorSetting"] = true;
			}
			catch(e:Error)
			{
			}
			this.ModSlotList_mc.listEntryClass = "CurrentModListEntry";
			this.ModSlotList_mc.numListItems = 8;
			this.ModSlotList_mc.restoreListIndex = false;
			this.ModSlotList_mc.textOption = "None";
			this.ModSlotList_mc.verticalSpacing = -8;
			try
			{
				this.ModSlotList_mc["componentInspectorSetting"] = false;
				return;
			}
			catch(e:Error)
			{
				return;
			}
		}
	}
}
