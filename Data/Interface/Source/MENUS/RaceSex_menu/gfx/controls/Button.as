class gfx.controls.Button extends gfx.core.UIComponent
{
	var state = "up";
	var toggle = false;
	var doubleClickEnabled = false;
	var autoRepeat = false;
	var lockDragStateChange = false;
	var soundMap = {theme:"default",focusIn:"focusIn",focusOut:"focusOut",select:"select",rollOver:"rollOver",rollOut:"rollOut",press:"press",doubleClick:"doubleClick",click:"click"};
	var _selected = false;
	var _autoSize = "none";
	var _disableFocus = false;
	var _disableConstraints = false;
	var doubleClickDuration = 250;
	var buttonRepeatDuration = 100;
	var buttonRepeatDelay = 100;
	var pressedByKeyboard = false;
	var stateMap = {up:["up"],over:["over"],down:["down"],release:["release","over"],out:["out","up"],disabled:["disabled"],selecting:["selecting","over"],kb_selecting:["kb_selecting","up"],kb_release:["kb_release","out","up"],kb_down:["kb_down","down"]};
	function Button()
	{
		super();
		this.focusEnabled = this.tabEnabled = !this._disableFocus?!this._disabled:false;
		if(this.inspectableGroupName != null && this.inspectableGroupName != "")
		{
			this.__set__group(this.inspectableGroupName);
		}
	}
	function __get__labelID()
	{
		return null;
	}
	function __set__labelID(value)
	{
		if(value != "")
		{
			this.__set__label(gfx.utils.Locale.getTranslatedString(value));
		}
		return this.__get__labelID();
	}
	function __get__label()
	{
		return this._label;
	}
	function __set__label(value)
	{
		this._label = value;
		if(this.initialized)
		{
			if(this.textField != null)
			{
				this.textField.text = this._label;
			}
			if(this.__get__autoSize() != "none")
			{
				this.sizeIsInvalid = true;
			}
			this.updateAfterStateChange();
		}
		return this.__get__label();
	}
	function __get__disabled()
	{
		return this._disabled;
	}
	function __set__disabled(value)
	{
		if(this._disabled == value)
		{
			return undefined;
		}
		super.__set__disabled(value);
		this.clearRepeatInterval();
		this.focusEnabled = this.tabEnabled = !this._disableFocus?!this._disabled:false;
		this.setState(!this._disabled?"up":"disabled");
		return this.__get__disabled();
	}
	function __get__selected()
	{
		return this._selected;
	}
	function __set__selected(value)
	{
		if(this._selected == value)
		{
			return undefined;
		}
		this._selected = value;
		if(!this._disabled)
		{
			if(!this._focused)
			{
				this.setState(!(this.__get__displayFocus() && this.focusIndicator == null)?"up":"over");
			}
			else if(this.pressedByKeyboard && this.focusIndicator != null)
			{
				this.setState("kb_selecting");
			}
			else
			{
				this.setState("selecting");
			}
		}
		else
		{
			this.setState("disabled");
		}
		if(this.dispatchEvent != null)
		{
			this.dispatchEventAndSound({type:"select",selected:this._selected});
		}
		return this.__get__selected();
	}
	function __get__groupName()
	{
		return this._group != null?this._group.name:null;
	}
	function __set__groupName(value)
	{
		this.__set__group(value);
		return this.__get__groupName();
	}
	function __get__group()
	{
		return this._group;
	}
	function __set__group(value)
	{
		var _loc2_ = (gfx.controls.ButtonGroup)value;
		if(typeof value == "string")
		{
			_loc2_ = this._parent["_buttonGroup_" + value];
			if(_loc2_ == null)
			{
				this._parent["_buttonGroup_" + value] = _loc2_ = new gfx.controls.ButtonGroup(value.toString(),this._parent);
			}
		}
		if(this._group == _loc2_)
		{
			return undefined;
		}
		if(this._group != null)
		{
			this._group.removeButton(this);
		}
		this._group = _loc2_;
		if(this._group != null)
		{
			_loc2_.addButton(this);
		}
		return this.__get__group();
	}
	function __get__disableFocus()
	{
		return this._disableFocus;
	}
	function __set__disableFocus(value)
	{
		this._disableFocus = value;
		this.focusEnabled = this.tabEnabled = !this._disableFocus?!this._disabled:false;
		return this.__get__disableFocus();
	}
	function __get__disableConstraints()
	{
		return this._disableConstraints;
	}
	function __set__disableConstraints(value)
	{
		this._disableConstraints = value;
		return this.__get__disableConstraints();
	}
	function __get__autoSize()
	{
		return this._autoSize;
	}
	function __set__autoSize(value)
	{
		if(this._autoSize == value)
		{
			return undefined;
		}
		this._autoSize = value;
		if(this.initialized)
		{
			this.sizeIsInvalid = true;
			this.validateNow();
		}
		return this.__get__autoSize();
	}
	function setSize(width, height)
	{
		super.setSize(width,height);
	}
	function handleInput(details, pathToFocus)
	{
		if((var _loc0_ = details.navEquivalent) !== gfx.ui.NavigationCode.ENTER)
		{
			return false;
		}
		var _loc2_ = details.controllerIdx;
		if(details.value == "keyDown" || details.value == "keyHold")
		{
			if(!this.pressedByKeyboard)
			{
				this.handlePress(_loc2_);
			}
		}
		else
		{
			this.handleRelease(_loc2_);
		}
		return true;
	}
	function toString()
	{
		return "[Scaleform Button " + this._name + "]";
	}
	function configUI()
	{
		this.constraints = new gfx.utils.Constraints(this,true);
		if(!this._disableConstraints)
		{
			this.constraints.addElement(this.textField,gfx.utils.Constraints.ALL);
		}
		super.configUI();
		if(this._autoSize != "none")
		{
			this.sizeIsInvalid = true;
		}
		this.onRollOver = this.handleMouseRollOver;
		this.onRollOut = this.handleMouseRollOut;
		this.onPress = this.handleMousePress;
		this.onRelease = this.handleMouseRelease;
		this.onReleaseOutside = this.handleReleaseOutside;
		this.onDragOver = this.handleDragOver;
		this.onDragOut = this.handleDragOut;
		if(this.focusIndicator != null && !this._focused && this.focusIndicator._totalFrames == 1)
		{
			this.focusIndicator._visible = false;
		}
		this.updateAfterStateChange();
	}
	function draw()
	{
		if(this.sizeIsInvalid)
		{
			this.alignForAutoSize();
			this._width = this.__width;
			this._height = this.__height;
		}
		if(this.initialized)
		{
			this.constraints.update(this.__width,this.__height);
		}
	}
	function updateAfterStateChange()
	{
		if(!this.initialized)
		{
			return undefined;
		}
		if(this.textField != null && this._label != null)
		{
			this.textField.text = this._label;
		}
		this.validateNow();
		if(this.constraints != null)
		{
			this.constraints.update(this.__get__width(),this.__get__height());
		}
		this.dispatchEvent({type:"stateChange",state:this.state});
	}
	function calculateWidth()
	{
		if(this.constraints == null)
		{
			this.invalidate();
			return 0;
		}
		var _loc2_ = this.constraints.getElement(this.textField).metrics;
		var _loc3_ = this.textField.textWidth + _loc2_.left + _loc2_.right + 5;
		return _loc3_;
	}
	function alignForAutoSize()
	{
		if(!this.initialized || this._autoSize == "none" || this.textField == null)
		{
			return undefined;
		}
		var _loc2_ = this.__width;
		this.__set__width(this.calculateWidth());
		switch(this._autoSize)
		{
			case "right":
				var _loc3_ = this._x + _loc2_;
				this._x = _loc3_ - this.__width;
				break;
			case "center":
				var _loc4_ = this._x + _loc2_ / 2;
				this._x = _loc4_ - this.__width / 2;
		}
	}
	function setState(state)
	{
		this.state = state;
		var _loc5_ = this.getStatePrefixes();
		var _loc3_ = this.stateMap[state];
		if(_loc3_ == null || _loc3_.length == 0)
		{
			return undefined;
		}
		do
		{
			var _loc4_ = _loc5_.pop().toString();
			var _loc2_ = _loc3_.length - 1;
			while(_loc2_ >= 0)
			{
				this.gotoAndPlay(_loc4_ + _loc3_[_loc2_]);
				_loc2_ = _loc2_ - 1;
			}
		}
		while(_loc5_.length > 0);
		
		this.updateAfterStateChange();
	}
	function getStatePrefixes()
	{
		return !this._selected?[""]:["selected_",""];
	}
	function changeFocus()
	{
		if(this._disabled)
		{
			return undefined;
		}
		if(this.focusIndicator == null)
		{
			this.setState(!(this._focused || this._displayFocus)?"out":"over");
			if(this.pressedByKeyboard && !this._focused)
			{
				this.pressedByKeyboard = false;
			}
		}
		if(this.focusIndicator != null)
		{
			if(this.focusIndicator._totalframes == 1)
			{
				this.focusIndicator._visible = this._focused != 0;
			}
			else
			{
				this.focusIndicator.gotoAndPlay(!this._focused?"hide":"show");
				this.focusIndicator.gotoAndPlay("state" + this._focused);
			}
			if(this.pressedByKeyboard && !this._focused)
			{
				this.setState("kb_release");
				this.pressedByKeyboard = false;
			}
		}
	}
	function handleMouseRollOver(controllerIdx)
	{
		if(this._disabled)
		{
			return undefined;
		}
		if(!this._focused && !this._displayFocus || this.focusIndicator != null)
		{
			this.setState("over");
		}
		this.dispatchEventAndSound({type:"rollOver",controllerIdx:controllerIdx});
	}
	function handleMouseRollOut(controllerIdx)
	{
		if(this._disabled)
		{
			return undefined;
		}
		if(!this._focused && !this._displayFocus || this.focusIndicator != null)
		{
			this.setState("out");
		}
		this.dispatchEventAndSound({type:"rollOut",controllerIdx:controllerIdx});
	}
	function handleMousePress(controllerIdx, keyboardOrMouse, button)
	{
		if(this._disabled)
		{
			return undefined;
		}
		if(!this._disableFocus)
		{
			Selection.setFocus(this,controllerIdx);
		}
		this.setState("down");
		this.dispatchEventAndSound({type:"press",controllerIdx:controllerIdx,button:button});
		if(this.autoRepeat)
		{
			this.buttonRepeatInterval = setInterval(this,"beginButtonRepeat",this.buttonRepeatDelay,controllerIdx,button);
		}
	}
	function handlePress(controllerIdx)
	{
		if(this._disabled)
		{
			return undefined;
		}
		this.pressedByKeyboard = true;
		this.setState(this.focusIndicator != null?"kb_down":"down");
		this.dispatchEventAndSound({type:"press",controllerIdx:controllerIdx});
	}
	function handleMouseRelease(controllerIdx, keyboardOrMouse, button)
	{
		if(this._disabled)
		{
			return undefined;
		}
		clearInterval(this.buttonRepeatInterval);
		delete this.buttonRepeatInterval;
		if(this.doubleClickEnabled)
		{
			if(this.doubleClickInterval == null)
			{
				this.doubleClickInterval = setInterval(this,"doubleClickExpired",this.doubleClickDuration);
			}
			else
			{
				this.doubleClickExpired();
				this.dispatchEventAndSound({type:"doubleClick",controllerIdx:controllerIdx,button:button});
				this.setState("release");
				return undefined;
			}
		}
		this.setState("release");
		this.handleClick(controllerIdx,button);
	}
	function handleRelease(controllerIdx)
	{
		if(this._disabled)
		{
			return undefined;
		}
		this.setState(this.focusIndicator != null?"kb_release":"release");
		this.handleClick(controllerIdx);
		this.pressedByKeyboard = false;
	}
	function handleClick(controllerIdx, button)
	{
		if(this.toggle)
		{
			this.__set__selected(!this._selected);
		}
		this.dispatchEventAndSound({type:"click",controllerIdx:controllerIdx,button:button});
	}
	function handleDragOver(controllerIdx, button)
	{
		if(this._disabled || this.lockDragStateChange)
		{
			return undefined;
		}
		if(this._focused || this._displayFocus)
		{
			this.setState(this.focusIndicator != null?"kb_down":"down");
		}
		else
		{
			this.setState("over");
		}
		this.dispatchEvent({type:"dragOver",controllerIdx:controllerIdx,button:button});
	}
	function handleDragOut(controllerIdx, button)
	{
		if(this._disabled || this.lockDragStateChange)
		{
			return undefined;
		}
		if(this._focused || this._displayFocus)
		{
			this.setState(this.focusIndicator != null?"kb_release":"release");
		}
		else
		{
			this.setState("out");
		}
		this.dispatchEvent({type:"dragOut",controllerIdx:controllerIdx,button:button});
	}
	function handleReleaseOutside(controllerIdx, button)
	{
		this.clearRepeatInterval();
		if(this._disabled)
		{
			return undefined;
		}
		if(this.lockDragStateChange)
		{
			if(this._focused || this._displayFocus)
			{
				this.setState(this.focusIndicator != null?"kb_release":"release");
			}
			else
			{
				this.setState("kb_release");
			}
		}
		this.dispatchEvent({type:"releaseOutside",state:this.state,button:button});
	}
	function doubleClickExpired()
	{
		clearInterval(this.doubleClickInterval);
		delete this.doubleClickInterval;
	}
	function beginButtonRepeat(controllerIdx, button)
	{
		this.clearRepeatInterval();
		this.buttonRepeatInterval = setInterval(this,"handleButtonRepeat",this.buttonRepeatDuration,controllerIdx,button);
	}
	function handleButtonRepeat(controllerIdx, button)
	{
		this.dispatchEventAndSound({type:"click",controllerIdx:controllerIdx,button:button});
	}
	function clearRepeatInterval()
	{
		clearInterval(this.buttonRepeatInterval);
		delete this.buttonRepeatInterval;
	}
}
