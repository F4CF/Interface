package Workshop_fla
{
	import flash.display.MovieClip;
	import flash.text.TextField;
	import Shared.AS3.BSScrollingList;
	
	public dynamic class RequirementsBase_35 extends MovieClip
	{
		 
		
		public var TopListText_tf:TextField;
		
		public var RequirementsList_mc:BSScrollingList;
		
		public var RequirementsListBackground_mc:MovieClip;
		
		public function RequirementsBase_35()
		{
			super();
			this.__setProp_RequirementsList_mc_RequirementsBase_Layer1_0();
		}
		
		function __setProp_RequirementsList_mc_RequirementsBase_Layer1_0() : *
		{
			try
			{
				this.RequirementsList_mc["componentInspectorSetting"] = true;
			}
			catch(e:Error)
			{
			}
			this.RequirementsList_mc.listEntryClass = "RequirementsListEntry";
			this.RequirementsList_mc.numListItems = 8;
			this.RequirementsList_mc.restoreListIndex = false;
			this.RequirementsList_mc.textOption = "Shrink To Fit";
			this.RequirementsList_mc.verticalSpacing = -5;
			try
			{
				this.RequirementsList_mc["componentInspectorSetting"] = false;
				return;
			}
			catch(e:Error)
			{
				return;
			}
		}
	}
}
