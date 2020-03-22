package
{
	import flash.display.MovieClip;
	import flash.text.TextField;
	
	public dynamic class XPMeter extends MovieClip
	{
		 
		
		public var LeveUpTextClip:LeftToRightTextAnim;
		
		public var LevelUPBar:MeterBar;
		
		public var LevelUpBracket:MovieClip;
		
		public var NumberText:TextField;
		
		public var PlusSign:TextField;
		
		public var xptext:TextField;
		
		public function XPMeter()
		{
			super();
			this.__setProp_LevelUPBar_XPMeter_LevelUPBar_0();
		}
		
		function __setProp_LevelUPBar_XPMeter_LevelUPBar_0() : *
		{
			try
			{
				this.LevelUPBar["componentInspectorSetting"] = true;
			}
			catch(e:Error)
			{
			}
			this.LevelUPBar.BarAlpha = 1;
			this.LevelUPBar.bracketCornerLength = 6;
			this.LevelUPBar.bracketLineWidth = 1.5;
			this.LevelUPBar.bracketPaddingX = 0;
			this.LevelUPBar.bracketPaddingY = 0;
			this.LevelUPBar.BracketStyle = "horizontal";
			this.LevelUPBar.bShowBrackets = false;
			this.LevelUPBar.bUseShadedBackground = false;
			this.LevelUPBar.Justification = "left";
			this.LevelUPBar.Percent = 0;
			this.LevelUPBar.ShadedBackgroundMethod = "Shader";
			this.LevelUPBar.ShadedBackgroundType = "normal";
			try
			{
				this.LevelUPBar["componentInspectorSetting"] = false;
				return;
			}
			catch(e:Error)
			{
				return;
			}
		}
	}
}
