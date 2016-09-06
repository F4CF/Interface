package MainMenu_fla
{
	import flash.display.MovieClip;
	
	public dynamic class ControlsFader_34 extends MovieClip
	{
		 
		
		public var List_mc:InputMappingList;
		
		public function ControlsFader_34()
		{
			super();
			this.__setProp_List_mc_ControlsFader_List_0();
		}
		
		function __setProp_List_mc_ControlsFader_List_0() : *
		{
			try
			{
				this.List_mc["componentInspectorSetting"] = true;
			}
			catch(e:Error)
			{
			}
			this.List_mc.disableSelection = false;
			this.List_mc.listEntryClass = "InputMappingListEntry";
			this.List_mc.numListItems = 8;
			this.List_mc.restoreListIndex = true;
			this.List_mc.textOption = "None";
			this.List_mc.verticalSpacing = 1.2;
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
