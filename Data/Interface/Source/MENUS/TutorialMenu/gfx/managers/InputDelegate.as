class gfx.managers.InputDelegate extends gfx.events.EventDispatcher
{
	function InputDelegate()
	{
		super();
		Key.addListener(this);
		this.keyRepeatSuppressLookup = {};
		this.keyRepeatStateLookup = {};
	}
	function setKeyRepeat(code, value, controllerIdx)
	{
		var _loc2_ = this.getKeyRepeatSuppress(controllerIdx);
		_loc2_[code] = !value;
	}
	function readInput(type, code, scope, callBack)
	{
		return null;
	}
	function inputToNav(type, code, value)
	{
		if(type == "key")
		{
			switch(code)
			{
				case 38:
					return gfx.ui.NavigationCode.UP;
				case 40:
					return gfx.ui.NavigationCode.DOWN;
				case 37:
					return gfx.ui.NavigationCode.LEFT;
				case 39:
					return gfx.ui.NavigationCode.RIGHT;
				case 13:
					return gfx.ui.NavigationCode.ENTER;
				case 8:
					return gfx.ui.NavigationCode.BACK;
				case 9:
					return !Key.isDown(16)?gfx.ui.NavigationCode.TAB:gfx.ui.NavigationCode.SHIFT_TAB;
				case 36:
					return gfx.ui.NavigationCode.HOME;
				case 35:
					return gfx.ui.NavigationCode.END;
				case 34:
					return gfx.ui.NavigationCode.PAGE_DOWN;
				case 33:
					return gfx.ui.NavigationCode.PAGE_UP;
				case 27:
					return gfx.ui.NavigationCode.ESCAPE;
				case 96:
					return gfx.ui.NavigationCode.GAMEPAD_A;
				case 97:
					return gfx.ui.NavigationCode.GAMEPAD_B;
				case 98:
					return gfx.ui.NavigationCode.GAMEPAD_X;
				case 99:
					return gfx.ui.NavigationCode.GAMEPAD_Y;
				case 100:
					return gfx.ui.NavigationCode.GAMEPAD_L1;
				case 101:
					return gfx.ui.NavigationCode.GAMEPAD_L2;
				case 102:
					return gfx.ui.NavigationCode.GAMEPAD_L3;
				case 103:
					return gfx.ui.NavigationCode.GAMEPAD_R1;
				case 104:
					return gfx.ui.NavigationCode.GAMEPAD_R2;
				case 105:
					return gfx.ui.NavigationCode.GAMEPAD_R3;
				case 106:
					return gfx.ui.NavigationCode.GAMEPAD_START;
				case 107:
					return gfx.ui.NavigationCode.GAMEPAD_BACK;
			}
		}
	}
	function onKeyDown(controllerIdx)
	{
		var _loc2_ = Key.getCode(controllerIdx);
		var _loc4_ = this.getKeyRepeatState(controllerIdx);
		if(_loc4_[_loc2_])
		{
			var _loc5_ = this.getKeyRepeatSuppress(controllerIdx);
			if(!_loc5_[_loc2_])
			{
				this.handleKeyPress("keyHold",_loc2_,controllerIdx);
			}
		}
		else
		{
			this.handleKeyPress("keyDown",_loc2_,controllerIdx);
			_loc4_[_loc2_] = true;
		}
	}
	function onKeyUp(controllerIdx)
	{
		var _loc2_ = Key.getCode(controllerIdx);
		var _loc4_ = this.getKeyRepeatState(controllerIdx);
		_loc4_[_loc2_] = false;
		this.handleKeyPress("keyUp",_loc2_,controllerIdx);
	}
	function handleKeyPress(type, code, controllerIdx)
	{
		var _loc3_ = new gfx.ui.InputDetails("key",code,type,this.inputToNav("key",code),controllerIdx);
		this.dispatchEvent({type:"input",details:_loc3_});
	}
	function getKeyRepeatState(controllerIdx)
	{
		var _loc2_ = this.keyRepeatStateLookup[controllerIdx];
		if(!_loc2_)
		{
			_loc2_ = new Object();
			this.keyRepeatStateLookup[controllerIdx] = _loc2_;
		}
		return _loc2_;
	}
	function getKeyRepeatSuppress(controllerIdx)
	{
		var _loc2_ = this.keyRepeatSuppressLookup[controllerIdx];
		if(!_loc2_)
		{
			_loc2_ = new Object();
			this.keyRepeatSuppressLookup[controllerIdx] = _loc2_;
		}
		return _loc2_;
	}
	static function __get__instance()
	{
		if(gfx.managers.InputDelegate._instance == null)
		{
			gfx.managers.InputDelegate._instance = new gfx.managers.InputDelegate();
		}
		return gfx.managers.InputDelegate._instance;
	}
}
