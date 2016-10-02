class TutorialMenu extends MovieClip
{
	function TutorialMenu()
	{
		super();
		this.HelpScrollingText = this.HelpText;
		this.ButtonHolder = this.ButtonArtHolder;
	}
	function InitExtensions()
	{
		this.TitleText.textAutoSize = "shrink";
		this.ButtonRect.ExitMouseButton.addEventListener("press",this,"onExitPress");
		this.ButtonRect.ExitMouseButton.SetPlatform(0,false);
		gfx.managers.FocusHandler.__get__instance().setFocus(this.HelpScrollingText,0);
	}
	function SetPlatform(aiPlatform, abPS3Switch)
	{
		this.ButtonRect.ExitGamepadButton._visible = aiPlatform != 0;
		this.ButtonRect.ExitMouseButton._visible = aiPlatform == 0;
		if(aiPlatform != 0)
		{
			this.ButtonRect.ExitGamepadButton.SetPlatform(aiPlatform,abPS3Switch);
		}
	}
	function ApplyButtonArt()
	{
		var _loc2_ = this.ButtonHolder.CreateButtonArt(this.HelpScrollingText.textField);
		if(_loc2_ != undefined)
		{
			this.HelpScrollingText.textField.html = true;
			this.HelpScrollingText.textField.htmlText = _loc2_;
		}
	}
	function onExitPress()
	{
		gfx.io.GameDelegate.call("CloseMenu",[]);
	}
}
