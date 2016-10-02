class Components.CrossPlatformButtons extends gfx.controls.Button
{
	function CrossPlatformButtons()
	{
		super();
	}
	function onLoad()
	{
		super.onLoad();
		if(this._parent.onButtonLoad != undefined)
		{
			this._parent.onButtonLoad(this);
		}
	}
	function SetPlatform(aiPlatform, aSwapPS3)
	{
		if(aiPlatform != undefined)
		{
			this.CurrentPlatform = aiPlatform;
		}
		if(aSwapPS3 != undefined)
		{
			this.PS3Swapped = aSwapPS3;
		}
		this.RefreshArt();
	}
	function RefreshArt()
	{
		if(undefined != this.ButtonArt)
		{
			this.ButtonArt.removeMovieClip();
		}
		switch(this.CurrentPlatform)
		{
			case Shared.ButtonChange.PLATFORM_PC:
				if(this.PCButton != "None")
				{
					this.ButtonArt_mc = this.attachMovie(this.PCButton,"ButtonArt",this.getNextHighestDepth());
				}
				break;
			case Shared.ButtonChange.PLATFORM_PC_GAMEPAD:
			case Shared.ButtonChange.PLATFORM_360:
				this.ButtonArt_mc = this.attachMovie(this.XBoxButton,"ButtonArt",this.getNextHighestDepth());
				break;
			case Shared.ButtonChange.PLATFORM_PS3:
				var _loc2_ = this.PS3Button;
				if(this.PS3Swapped)
				{
					if(_loc2_ == "PS3_A")
					{
						_loc2_ = "PS3_B";
					}
					else if(_loc2_ == "PS3_B")
					{
						_loc2_ = "PS3_A";
					}
				}
				this.ButtonArt_mc = this.attachMovie(_loc2_,"ButtonArt",this.getNextHighestDepth());
		}
		this.ButtonArt_mc._x = this.ButtonArt_mc._x - this.ButtonArt_mc._width;
		this.ButtonArt_mc._y = (this._height - this.ButtonArt_mc._height) / 2;
		this.border._visible = false;
	}
	function GetArt()
	{
		return {PCArt:this.PCButton,XBoxArt:this.XBoxButton,PS3Art:this.PS3Button};
	}
	function SetArt(aPlatformArt)
	{
		this.__set__PCArt(aPlatformArt.PCArt);
		this.__set__XBoxArt(aPlatformArt.XBoxArt);
		this.__set__PS3Art(aPlatformArt.PS3Art);
		this.RefreshArt();
	}
	function __get__XBoxArt()
	{
		return null;
	}
	function __set__XBoxArt(aValue)
	{
		if(aValue != "")
		{
			this.XBoxButton = aValue;
		}
		return this.__get__XBoxArt();
	}
	function __get__PS3Art()
	{
		return null;
	}
	function __set__PS3Art(aValue)
	{
		if(aValue != "")
		{
			this.PS3Button = aValue;
		}
		return this.__get__PS3Art();
	}
	function __get__PCArt()
	{
		return null;
	}
	function __set__PCArt(aValue)
	{
		if(aValue != "")
		{
			this.PCButton = aValue;
		}
		return this.__get__PCArt();
	}
}
