class gfx.managers.FocusHandler
{
	var inited = false;
	static var _instance = gfx.managers.FocusHandler.__get__instance();
	function FocusHandler()
	{
		Selection.addListener(this);
		_global.gfxExtensions = 1;
		Selection.alwaysEnableArrowKeys = true;
		Selection.disableFocusKeys = true;
		Selection.disableFocusAutoRelease = true;
		Selection.disableFocusRolloverEvent = true;
		_root._focusrect = false;
		this.currentFocusLookup = [];
		this.actualFocusLookup = [];
	}
	function initialize()
	{
		this.inited = true;
		this.inputDelegate = gfx.managers.InputDelegate.instance;
		this.inputDelegate.addEventListener("input",this,"handleInput");
	}
	function getFocus(focusIdx)
	{
		return this.currentFocusLookup[focusIdx];
	}
	function setFocus(focus, focusIdx)
	{
		if(!this.inited)
		{
			this.initialize();
		}
		while(focus.focusTarget != null)
		{
			focus = focus.focusTarget;
		}
		var _loc8_ = this.actualFocusLookup[focusIdx];
		var _loc5_ = this.currentFocusLookup[focusIdx];
		if(_loc5_ != focus)
		{
			_loc5_.focused = _loc5_.focused & (~(1 << focusIdx));
			_loc5_ = focus;
			this.currentFocusLookup[focusIdx] = focus;
			_loc5_.focused = _loc5_.focused | 1 << focusIdx;
		}
		if(_loc8_ != _loc5_ && !(_loc8_ instanceof TextField))
		{
			var _loc6_ = Selection.getControllerMaskByFocusGroup(focusIdx);
			var _loc2_ = 0;
			while(_loc2_ < System.capabilities.numControllers)
			{
				var _loc4_ = (_loc6_ >> _loc2_ & 1) != 0;
				if(_loc4_)
				{
					Selection.setFocus(_loc5_,_loc2_);
				}
				_loc2_ = _loc2_ + 1;
			}
		}
	}
	function handleInput(event)
	{
		var controllerIdx = event.details.controllerIdx;
		var focusIdx = Selection.getControllerFocusGroup(controllerIdx);
		var path = this.getPathToFocus(focusIdx);
		if(path.length == 0 || path[0].handleInput == null || path[0].handleInput(event.details,path.slice(1)) != true)
		{
			if(event.details.value == "keyUp")
			{
				return undefined;
			}
			var nav = event.details.navEquivalent;
			if(nav != null)
			{
				var focusedElem = eval(Selection.getFocus(controllerIdx));
				var actualFocus = this.actualFocusLookup[focusIdx];
				if(actualFocus instanceof TextField && focusedElem == actualFocus && this.textFieldHandleInput(nav,controllerIdx))
				{
					return undefined;
				}
				var dirH = nav == gfx.ui.NavigationCode.LEFT || nav == gfx.ui.NavigationCode.RIGHT;
				var dirV = nav == gfx.ui.NavigationCode.UP || nav == gfx.ui.NavigationCode.DOWN;
				var focusContext = focusedElem._parent;
				var focusMode = "default";
				if(dirH || dirV)
				{
					var focusProp = !dirH?"focusModeVertical":"focusModeHorizontal";
					while(focusContext)
					{
						focusMode = focusContext[focusProp];
						if(focusMode && focusMode != "default")
						{
							break;
						}
						focusContext = focusContext._parent;
					}
				}
				else
				{
					focusContext = null;
				}
				var newFocus = Selection.findFocus(nav,focusContext,focusMode == "loop",null,false,controllerIdx);
				if(newFocus)
				{
					Selection.setFocus(newFocus,controllerIdx);
				}
			}
		}
	}
	function getPathToFocus(focusIdx)
	{
		var _loc5_ = this.currentFocusLookup[focusIdx];
		var _loc3_ = _loc5_;
		var _loc4_ = [_loc3_];
		while(_loc3_)
		{
			_loc3_ = _loc3_._parent;
			if(_loc3_.handleInput != null)
			{
				_loc4_.unshift(_loc3_);
			}
			if(_loc3_ == _root)
			{
				break;
			}
		}
		return _loc4_;
	}
	function onSetFocus(oldFocus, newFocus, controllerIdx)
	{
		if(oldFocus instanceof TextField && newFocus == null)
		{
			return undefined;
		}
		var _loc2_ = Selection.getControllerFocusGroup(controllerIdx);
		var _loc6_ = this.actualFocusLookup[_loc2_];
		if(_loc6_ == newFocus)
		{
			var _loc4_ = !(newFocus instanceof TextField)?newFocus:newFocus._parent;
			var _loc5_ = _loc4_.focused;
			if(_loc5_ & 1 << _loc2_ == 0)
			{
				_loc4_.focused = _loc5_ | 1 << _loc2_;
			}
		}
		this.actualFocusLookup[_loc2_] = newFocus;
		this.setFocus(newFocus,_loc2_);
	}
	function textFieldHandleInput(nav, controllerIdx)
	{
		var _loc3_ = Selection.getCaretIndex(controllerIdx);
		var _loc4_ = Selection.getControllerFocusGroup(controllerIdx);
		var _loc2_ = this.actualFocusLookup[_loc4_];
		switch(nav)
		{
			case gfx.ui.NavigationCode.UP:
				if(!_loc2_.multiline)
				{
					return false;
				}
			case gfx.ui.NavigationCode.LEFT:
				return _loc3_ > 0;
			case gfx.ui.NavigationCode.DOWN:
				if(!_loc2_.multiline)
				{
					return false;
				}
			case gfx.ui.NavigationCode.RIGHT:
				return _loc3_ < (TextField)_loc2_.length;
			default:
				return false;
		}
	}
	static function __get__instance()
	{
		if(gfx.managers.FocusHandler._instance == null)
		{
			gfx.managers.FocusHandler._instance = new gfx.managers.FocusHandler();
		}
		return gfx.managers.FocusHandler._instance;
	}
}
