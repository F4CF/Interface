package TextEntry_fla
{
	import flash.display.MovieClip;
	import Shared.AS3.BSButtonHelp;
	import flash.text.TextField;
	
	public dynamic class TextEntryAnim_3 extends MovieClip
	{
		 
		
		public var AcceptButton_mc:BSButtonHelp;
		
		public var TextEntry_tf:TextField;
		
		public var TitleText_tf:TextField;
		
		public var CancelButton_mc:BSButtonHelp;
		
		public function TextEntryAnim_3()
		{
			super();
			this.__setProp_CancelButton_mc_TextEntryAnim_Buttons_0();
			this.__setProp_AcceptButton_mc_TextEntryAnim_Buttons_0();
		}
		
		function __setProp_CancelButton_mc_TextEntryAnim_Buttons_0() : *
		{
			try
			{
				this.CancelButton_mc["componentInspectorSetting"] = true;
			}
			catch(e:Error)
			{
			}
			this.CancelButton_mc.buttonText = "$CANCEL";
			this.CancelButton_mc.Justification = 0;
			this.CancelButton_mc.PCKey = "";
			this.CancelButton_mc.PSNButton = "PSN_B";
			this.CancelButton_mc.XenonButton = "Xenon_B";
			try
			{
				this.CancelButton_mc["componentInspectorSetting"] = false;
				return;
			}
			catch(e:Error)
			{
				return;
			}
		}
		
		function __setProp_AcceptButton_mc_TextEntryAnim_Buttons_0() : *
		{
			try
			{
				this.AcceptButton_mc["componentInspectorSetting"] = true;
			}
			catch(e:Error)
			{
			}
			this.AcceptButton_mc.buttonText = "$CONFIRM";
			this.AcceptButton_mc.Justification = 0;
			this.AcceptButton_mc.PCKey = "";
			this.AcceptButton_mc.PSNButton = "PSN_A";
			this.AcceptButton_mc.XenonButton = "Xenon_A";
			try
			{
				this.AcceptButton_mc["componentInspectorSetting"] = false;
				return;
			}
			catch(e:Error)
			{
				return;
			}
		}
	}
}
