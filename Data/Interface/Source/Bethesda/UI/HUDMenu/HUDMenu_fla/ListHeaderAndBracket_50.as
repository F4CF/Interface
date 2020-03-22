package HUDMenu_fla
{
	import flash.display.MovieClip;
	
	public dynamic class ListHeaderAndBracket_50 extends MovieClip
	{
		 
		
		public var BracketPairHolder_mc:BracketPairFadeHolder;
		
		public var ContainerName_mc:MovieClip;
		
		public function ListHeaderAndBracket_50()
		{
			super();
			this.__setProp_BracketPairHolder_mc_ListHeaderAndBracket_BracketPairHolder_mc_0();
		}
		
		function __setProp_BracketPairHolder_mc_ListHeaderAndBracket_BracketPairHolder_mc_0() : *
		{
			try
			{
				this.BracketPairHolder_mc["componentInspectorSetting"] = true;
			}
			catch(e:Error)
			{
			}
			this.BracketPairHolder_mc.bracketCornerLength = 6;
			this.BracketPairHolder_mc.bracketLineWidth = 1.5;
			this.BracketPairHolder_mc.bracketPaddingX = 0;
			this.BracketPairHolder_mc.bracketPaddingY = 0;
			this.BracketPairHolder_mc.BracketStyle = "horizontal";
			this.BracketPairHolder_mc.bShowBrackets = false;
			this.BracketPairHolder_mc.bUseShadedBackground = true;
			this.BracketPairHolder_mc.ShadedBackgroundMethod = "Shader";
			this.BracketPairHolder_mc.ShadedBackgroundType = "normal";
			try
			{
				this.BracketPairHolder_mc["componentInspectorSetting"] = false;
				return;
			}
			catch(e:Error)
			{
				return;
			}
		}
	}
}
