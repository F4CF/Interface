package ButtonBarMenu_fla
{
	import flash.display.MovieClip;
	import Shared.AS3.BSButtonHintBar;

	public dynamic class ButtonBarHolder_1 extends MovieClip
	{

		public var ButtonHintBar_mc:BSButtonHintBar;


		public function ButtonBarHolder_1()
		{
			super();
			this.__setProp_ButtonHintBar_mc_ButtonBarHolder_Layer1_0();
		}


		function __setProp_ButtonHintBar_mc_ButtonBarHolder_Layer1_0() : *
		{
			try
			{
				this.ButtonHintBar_mc["componentInspectorSetting"] = true;
			}
			catch(e:Error)
			{
				// swallow the error?
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
			catch(e:Error)
			{
				// swallow the error?
			}
		}


	}
}
