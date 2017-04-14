package PromptMenu_fla
{
	import flash.display.MovieClip;
	
	public dynamic class PromptMenuPanel_1 extends MovieClip
	{
		 
		
		public var MessageHolder_mc:MessageHolder;
		
		public function PromptMenuPanel_1()
		{
			super();
			this.__setProp_MessageHolder_mc_PromptMenuPanel_MessageHolder_mc_0();
		}
		
		function __setProp_MessageHolder_mc_PromptMenuPanel_MessageHolder_mc_0() : *
		{
			try
			{
				this.MessageHolder_mc["componentInspectorSetting"] = true;
			}
			catch(e:Error)
			{
			}
			this.MessageHolder_mc.bracketCornerLength = 6;
			this.MessageHolder_mc.bracketLineWidth = 2;
			this.MessageHolder_mc.bracketPaddingX = 6;
			this.MessageHolder_mc.bracketPaddingY = 2;
			this.MessageHolder_mc.BracketStyle = "horizontal";
			this.MessageHolder_mc.bShowBrackets = true;
			this.MessageHolder_mc.bUseShadedBackground = true;
			this.MessageHolder_mc.ShadedBackgroundMethod = "Shader";
			this.MessageHolder_mc.ShadedBackgroundType = "normal";
			try
			{
				this.MessageHolder_mc["componentInspectorSetting"] = false;
				return;
			}
			catch(e:Error)
			{
				return;
			}
		}
	}
}
