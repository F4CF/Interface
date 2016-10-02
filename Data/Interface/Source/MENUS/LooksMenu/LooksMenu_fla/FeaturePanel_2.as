package LooksMenu_fla
{
	import flash.display.MovieClip;
	
	public dynamic class FeaturePanel_2 extends MovieClip
	{
		 
		
		public var Brackets_mc:MovieClip;
		
		public var PlayerBracketBackground_mc:MovieClip;
		
		public var List_mc:FeatureList;
		
		public function FeaturePanel_2()
		{
			super();
			this.__setProp_List_mc_FeaturePanel_List_mc_0();
		}
		
		function __setProp_List_mc_FeaturePanel_List_mc_0() : *
		{
			try
			{
				this.List_mc["componentInspectorSetting"] = true;
			}
			catch(e:Error)
			{
			}
			this.List_mc.listEntryClass = "FeatureListEntry";
			this.List_mc.numListItems = 8;
			this.List_mc.restoreListIndex = false;
			this.List_mc.textOption = "Shrink To Fit";
			this.List_mc.verticalSpacing = -2;
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
