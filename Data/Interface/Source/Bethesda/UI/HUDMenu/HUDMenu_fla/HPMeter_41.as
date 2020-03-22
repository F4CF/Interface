package HUDMenu_fla
{
	import flash.display.MovieClip;
	import flash.text.TextField;
	
	public dynamic class HPMeter_41 extends MovieClip
	{
		 
		
		public var Bracket_mc:MovieClip;
		
		public var DisplayText_tf:TextField;
		
		public var MeterBar_mc:MeterBar;
		
		public var Optional_mc:MeterBar;
		
		public var RadsBar_mc:MeterBar;
		
		public function HPMeter_41()
		{
			super();
			this.__setProp_Optional_mc_HPMeter_Optional_mc_0();
			this.__setProp_MeterBar_mc_HPMeter_MeterBar_mc_0();
			this.__setProp_RadsBar_mc_HPMeter_RadsBar_mc_0();
		}
		
		function __setProp_Optional_mc_HPMeter_Optional_mc_0() : *
		{
			try
			{
				this.Optional_mc["componentInspectorSetting"] = true;
			}
			catch(e:Error)
			{
			}
			this.Optional_mc.BarAlpha = 0.5;
			this.Optional_mc.bracketCornerLength = 6;
			this.Optional_mc.bracketLineWidth = 1.5;
			this.Optional_mc.bracketPaddingX = 0;
			this.Optional_mc.bracketPaddingY = 0;
			this.Optional_mc.BracketStyle = "horizontal";
			this.Optional_mc.bShowBrackets = false;
			this.Optional_mc.bUseShadedBackground = false;
			this.Optional_mc.Justification = "left";
			this.Optional_mc.Percent = 0;
			this.Optional_mc.ShadedBackgroundMethod = "Shader";
			this.Optional_mc.ShadedBackgroundType = "normal";
			try
			{
				this.Optional_mc["componentInspectorSetting"] = false;
				return;
			}
			catch(e:Error)
			{
				return;
			}
		}
		
		function __setProp_MeterBar_mc_HPMeter_MeterBar_mc_0() : *
		{
			try
			{
				this.MeterBar_mc["componentInspectorSetting"] = true;
			}
			catch(e:Error)
			{
			}
			this.MeterBar_mc.BarAlpha = 1;
			this.MeterBar_mc.bracketCornerLength = 6;
			this.MeterBar_mc.bracketLineWidth = 1.5;
			this.MeterBar_mc.bracketPaddingX = 0;
			this.MeterBar_mc.bracketPaddingY = 0;
			this.MeterBar_mc.BracketStyle = "horizontal";
			this.MeterBar_mc.bShowBrackets = false;
			this.MeterBar_mc.bUseShadedBackground = false;
			this.MeterBar_mc.Justification = "left";
			this.MeterBar_mc.Percent = 0;
			this.MeterBar_mc.ShadedBackgroundMethod = "Shader";
			this.MeterBar_mc.ShadedBackgroundType = "normal";
			try
			{
				this.MeterBar_mc["componentInspectorSetting"] = false;
				return;
			}
			catch(e:Error)
			{
				return;
			}
		}
		
		function __setProp_RadsBar_mc_HPMeter_RadsBar_mc_0() : *
		{
			try
			{
				this.RadsBar_mc["componentInspectorSetting"] = true;
			}
			catch(e:Error)
			{
			}
			this.RadsBar_mc.BarAlpha = 1;
			this.RadsBar_mc.bracketCornerLength = 6;
			this.RadsBar_mc.bracketLineWidth = 1.5;
			this.RadsBar_mc.bracketPaddingX = 0;
			this.RadsBar_mc.bracketPaddingY = 0;
			this.RadsBar_mc.BracketStyle = "horizontal";
			this.RadsBar_mc.bShowBrackets = false;
			this.RadsBar_mc.bUseShadedBackground = false;
			this.RadsBar_mc.Justification = "right";
			this.RadsBar_mc.Percent = 1;
			this.RadsBar_mc.ShadedBackgroundMethod = "Shader";
			this.RadsBar_mc.ShadedBackgroundType = "normal";
			try
			{
				this.RadsBar_mc["componentInspectorSetting"] = false;
				return;
			}
			catch(e:Error)
			{
				return;
			}
		}
	}
}
