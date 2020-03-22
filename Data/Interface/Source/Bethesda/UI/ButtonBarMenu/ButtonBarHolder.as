package
{
	import Shared.AS3.BSButtonHintBar;
	import flash.display.MovieClip;

	public dynamic class ButtonBarHolder extends MovieClip
	{

		public var ButtonHintBar_mc:BSButtonHintBar;


		public function ButtonBarHolder()
		{
			super();
			trace("[ButtonBarHolder](ctor)");
			this.InspectorSetting();
		}


		private function InspectorSetting():*
		{
			trace("[ButtonBarHolder](InspectorSetting)");
			try
			{
				this.ButtonHintBar_mc["componentInspectorSetting"] = true;
			}
			catch(error:Error)
			{
				trace("[ButtonBarMenu.swf][ButtonBarHolder](InspectorSetting) "+error.toString());
			}
			this.ButtonHintBar_mc.BackgroundAlpha = 1;
			this.ButtonHintBar_mc.BackgroundColor = 0;
			this.ButtonHintBar_mc.bracketCornerLength = 6;
			this.ButtonHintBar_mc.bracketLineWidth = 1.5;
			this.ButtonHintBar_mc.BracketStyle = "horizontal";
			this.ButtonHintBar_mc.bRedirectToButtonBarMenu = false;
			this.ButtonHintBar_mc.bShowBrackets = true;
			this.ButtonHintBar_mc.bUseShadedBackground = true;
			this.ButtonHintBar_mc.ShadedBackgroundMethod = "Shader";
			this.ButtonHintBar_mc.ShadedBackgroundType = "normal";
			try
			{
				this.ButtonHintBar_mc["componentInspectorSetting"] = false;
			}
			catch(error:Error)
			{
				trace("[ButtonBarMenu.swf][ButtonBarHolder](InspectorSetting) "+error.toString());
			}
		}


	}
}
