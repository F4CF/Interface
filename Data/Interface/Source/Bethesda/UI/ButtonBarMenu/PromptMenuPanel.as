package
{
	import flash.display.MovieClip;

	public dynamic class PromptMenuPanel extends MovieClip
	{

		public var MessageHolder_mc:MessageHolder;


		public function PromptMenuPanel()
		{
			super();
			trace("[PromptMenuPanel](ctor)");
			this.InspectorSetting();
		}


		private function InspectorSetting():*
		{
			trace("[PromptMenuPanel](InspectorSetting)");
			try
			{
				this.MessageHolder_mc["componentInspectorSetting"] = true;
			}
			catch(error:Error)
			{
				trace("[ButtonBarMenu.swf][PromptMenuPanel](InspectorSetting) "+error.toString());
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
			}
			catch(error:Error)
			{
				trace("[ButtonBarMenu.swf][PromptMenuPanel](InspectorSetting) "+error.toString());
			}
		}


	}
}
