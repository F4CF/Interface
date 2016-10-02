class gfx.controls.TextInput extends gfx.core.UIComponent
{
	var defaultText = "";
	var soundMap = {theme:"default",focusIn:"focusIn",focusOut:"focusOut",textChange:"textChange"};
	var _text = "";
	var _maxChars = 0;
	var _editable = true;
	var actAsButton = false;
	var hscroll = 0;
	var changeLock = false;
	function TextInput()
	{
		super();
		this.tabEnabled = !this._disabled;
		this.focusEnabled = !this._disabled;
		this.defaultTextFormat = this.textField.getNewTextFormat();
		this.defaultTextFormat.italic = true;
		this.defaultTextFormat.color = 11184810;
	}
	function __get__textID()
	{
		return null;
	}
	function __set__textID(value)
	{
		if(value != "")
		{
			this.__set__text(gfx.utils.Locale.getTranslatedString(value));
		}
		return this.__get__textID();
	}
	function __get__text()
	{
		return this._text;
	}
	function __set__text(value)
	{
		this._text = value;
		this.isHtml = false;
		this.updateText();
		return this.__get__text();
	}
	function __get__htmlText()
	{
		return this._text;
	}
	function __set__htmlText(value)
	{
		this._text = value;
		this.isHtml = true;
		this.updateText();
		return this.__get__htmlText();
	}
	function __get__editable()
	{
		return this._editable;
	}
	function __set__editable(value)
	{
		this._editable = value;
		this.tabEnabled = !this._disabled && !this._editable;
		this.updateTextField();
		return this.__get__editable();
	}
	function __get__password()
	{
		return this.textField.password;
	}
	function __set__password(value)
	{
		this._password = this.textField.password = value;
		return this.__get__password();
	}
	function __get__maxChars()
	{
		return this._maxChars;
	}
	function __set__maxChars(value)
	{
		this._maxChars = this.textField.maxChars = value;
		return this.__get__maxChars();
	}
	function __get__disabled()
	{
		return this._disabled;
	}
	function __set__disabled(value)
	{
		super.__set__disabled(value);
		this.tabEnabled = !this._disabled;
		this.focusEnabled = !this._disabled;
		if(this.initialized)
		{
			this.setMouseHandlers();
			this.setState();
			this.updateTextField();
		}
		return this.__get__disabled();
	}
	function appendText(text)
	{
		this._text = this._text + text;
		if(this.isHtml)
		{
			this.textField.html = false;
		}
		this.isHtml = false;
		this.textField.appendText(text);
	}
	function appendHtml(text)
	{
		this._text = this._text + text;
		if(!this.isHtml)
		{
			this.textField.html = true;
		}
		this.isHtml = true;
		this.textField.appendHtml(text);
	}
	function __get__length()
	{
		return this.textField.length;
	}
	function handleInput(details, pathToFocus)
	{
		if(details.value != "keyDown" && details.value != "keyHold")
		{
			return false;
		}
		var _loc2_ = details.controllerIdx;
		if(Selection.getFocus(_loc2_) != null)
		{
			return false;
		}
		Selection.setFocus(this.textField,_loc2_);
		return true;
	}
	function toString()
	{
		return "[Scaleform TextInput " + this._name + "]";
	}
	function configUI()
	{
		super.configUI();
		this.constraints = new gfx.utils.Constraints(this,true);
		this.constraints.addElement(this.textField,gfx.utils.Constraints.ALL);
		this.setState();
		this.updateTextField();
		this.setMouseHandlers();
	}
	function setState()
	{
		this.gotoAndPlay(!this._disabled?!this._focused?"default":"focused":"disabled");
	}
	function setMouseHandlers()
	{
		if(this.actAsButton == false)
		{
			return undefined;
		}
		if(this._disabled || this._focused)
		{
			delete this.onRollOver;
			delete this.onRollOut;
			delete this.onPress;
		}
		else if(this._editable)
		{
			this.onRollOver = this.handleMouseRollOver;
			this.onRollOut = this.handleMouseRollOut;
			this.onPress = this.handleMousePress;
		}
	}
	function handleMousePress(controllerIdx, keyboardOrMouse, button)
	{
		this.dispatchEvent({type:"press",controllerIdx:controllerIdx,button:button});
		Selection.setFocus(this.textField,controllerIdx);
	}
	function handleMouseRollOver(controllerIdx)
	{
		this.gotoAndPlay("default");
		this.gotoAndPlay("over");
		if(this.constraints)
		{
			this.constraints.update(this.__width,this.__height);
		}
		this.updateTextField();
		this.dispatchEvent({type:"rollOver",controllerIdx:controllerIdx});
	}
	function handleMouseRollOut(controllerIdx)
	{
		this.gotoAndPlay("default");
		this.gotoAndPlay("out");
		if(this.constraints)
		{
			this.constraints.update(this.__width,this.__height);
		}
		this.updateTextField();
		this.dispatchEvent({type:"rollOut",controllerIdx:controllerIdx});
	}
	function draw()
	{
		if(this.sizeIsInvalid)
		{
			this._width = this.__width;
			this._height = this.__height;
		}
		super.draw();
		this.constraints.update(this.__width,this.__height);
	}
	function changeFocus()
	{
		this.tabEnabled = !this._disabled;
		if(!this._focused)
		{
			this.hscroll = this.textField.hscroll;
		}
		this.setState();
		if(this.constraints)
		{
			this.constraints.update(this.__width,this.__height);
		}
		this.updateTextField();
		if(this._focused && this.textField.type == "input")
		{
			this.tabEnabled = false;
			var _loc3_ = Selection.getFocusBitmask(this);
			var _loc2_ = 0;
			while(_loc2_ < System.capabilities.numControllers)
			{
				if((_loc3_ >> _loc2_ & 1) != 0)
				{
					Selection.setFocus(this.textField,_loc2_);
					if(this.textField.noAutoSelection)
					{
						Selection.setSelection(this.textField.htmlText.length,this.textField.htmlText.length,_loc2_);
					}
					else
					{
						Selection.setSelection(0,this.textField.htmlText.length,_loc2_);
					}
				}
				_loc2_ = _loc2_ + 1;
			}
		}
		this.setMouseHandlers();
		this.textField.hscroll = this.hscroll;
	}
	function updateText()
	{
		if(this._text != "")
		{
			if(this.isHtml)
			{
				this.textField.html = true;
				this.textField.htmlText = this._text;
			}
			else
			{
				this.textField.html = false;
				this.textField.text = this._text;
			}
		}
		else
		{
			this.textField.text = "";
			if(!this._focused && this.defaultText != "")
			{
				this.textField.text = this.defaultText;
				this.textField.setTextFormat(this.defaultTextFormat);
			}
		}
	}
	function updateTextField()
	{
		if(this.textField != null)
		{
			if(!this._selectable)
			{
				this._selectable = this.textField.selectable;
			}
			this.updateText();
			this.textField.maxChars = this._maxChars;
			this.textField.noAutoSelection = true;
			this.textField.password = this._password;
			this.textField.selectable = !this._disabled?this._selectable || this._editable:false;
			this.textField.type = !(this._editable && !this._disabled)?"dynamic":"input";
			this.textField.focusTarget = this;
			this.textField.hscroll = this.hscroll;
			this.textField.addListener(this);
		}
	}
	function onChanged(target)
	{
		if(!this.changeLock)
		{
			this._text = !this.isHtml?this.textField.text:this.textField.htmlText;
			this.dispatchEventAndSound({type:"textChange"});
		}
	}
}
