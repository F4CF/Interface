package ExamineMenu_fla
{
	import flash.display.MovieClip;
	import flash.text.TextField;
	
	public dynamic class ModSlotBase_21 extends MovieClip
	{
		 
		
		public var ModSlotList_mc:RightHandList;
		
		public var SlotsLabel_tf:TextField;
		
		public function ModSlotBase_21()
		{
			super();
			this.__setProp_ModSlotList_mc_ModSlotBase_ModSlotList_mc_0();
		}
		
		function __setProp_ModSlotList_mc_ModSlotBase_ModSlotList_mc_0() : *
		{
			try
			{
				this.ModSlotList_mc["componentInspectorSetting"] = true;
			}
			catch(e:Error)
			{
			}
			this.ModSlotList_mc.listEntryClass = "ModListEntry";
			this.ModSlotList_mc.numListItems = 5;
			this.ModSlotList_mc.restoreListIndex = false;
			this.ModSlotList_mc.textOption = "Shrink To Fit";
			this.ModSlotList_mc.verticalSpacing = 0;
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
