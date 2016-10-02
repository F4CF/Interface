class gfx.controls.Slider extends gfx.core.UIComponent
{
	var liveDragging = false;
	var state = "default";
	var soundMap = {theme:"default",focusIn:"focusIn",focusOut:"focusOut",change:"change"};
	var _minimum = 0;
	var _maximum = 10;
	var _value = 0;
	var _snapInterval = 1;
	var _snapping = false;
	var trackPressed = false;
	var thumbPressed = false;
	var offsetLeft = 0;
	var offsetRight = 0;
	function Slider()
	{
		super();
		this.tabChildren = false;
		this.focusEnabled = this.tabEnabled = !this._disabled;
	}
	function __get__maximum()
	{
		return this._maximum;
	}
	function __set__maximum(value)
	{
		this._maximum = value;
		this.invalidate();
		return this.__get__maximum();
	}
	function __get__minimum()
	{
		return this._minimum;
	}
	function __set__minimum(value)
	{
		this._minimum = value;
		this.invalidate();
		return this.__get__minimum();
	}
	function __get__value()
	{
		return this._value;
	}
	function __set__value(value)
	{
		this._value = this.lockValue(value);
		this.invalidate();
		return this.__get__value();
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
		this.focusEnabled = this.tabEnabled = !this._disabled;
		if(!this.initialized)
		{
			return undefined;
		}
		this.thumb.__set__disabled(this.track.__set__disabled(this._disabled));
		this.invalidate();
		return this.__get__disabled();
	}
	function __get__position()
	{
		return this._value;
	}
	function __set__position(value)
	{
		this.__set__value(value);
		return this.__get__position();
	}
	function __get__snapping()
	{
		return this._snapping;
	}
	function __set__snapping(value)
	{
		this._snapping = value;
		this.invalidate();
		return this.__get__snapping();
	}
	function __get__snapInterval()
	{
		return this._snapInterval;
	}
	function __set__snapInterval(value)
	{
		this._snapInterval = value;
		this.invalidate();
		return this.__get__snapInterval();
	}
	function handleInput(details, pathToFocus)
	{
		var _loc2_ = details.value == "keyDown" || details.value == "keyHold";
		switch(details.navEquivalent)
		{
			case gfx.ui.NavigationCode.RIGHT:
				if(_loc2_)
				{
					this.value = this.value + this._snapInterval;
					this.dispatchEventAndSound({type:"change"});
				}
				break;
			case gfx.ui.NavigationCode.LEFT:
				if(_loc2_)
				{
					this.value = this.value - this._snapInterval;
					this.dispatchEventAndSound({type:"change"});
				}
				break;
			case gfx.ui.NavigationCode.HOME:
				if(!_loc2_)
				{
					this.__set__value(this.minimum);
					this.dispatchEventAndSound({type:"change"});
				}
				break;
			case gfx.ui.NavigationCode.END:
				if(!_loc2_)
				{
					this.__set__value(this.maximum);
					this.dispatchEventAndSound({type:"change"});
				}
				break;
			default:
				return false;
		}
		return true;
	}
	function toString()
	{
		return "[Scaleform Slider " + this._name + "]";
	}
	function configUI()
	{
		this.thumb.addEventListener("press",this,"beginDrag");
		this.track.addEventListener("press",this,"trackPress");
		this.thumb.focusTarget = this.track.focusTarget = this;
		this.thumb.__set__disabled(this.track.__set__disabled(this._disabled));
		this.thumb.lockDragStateChange = true;
		this.initSize();
		this.constraints = new gfx.utils.Constraints(this);
		this.constraints.addElement(this.track,gfx.utils.Constraints.LEFT | gfx.utils.Constraints.RIGHT);
		Mouse.addListener(this);
	}
	function draw()
	{
		this.gotoAndPlay(!this._disabled?!this._focused?"default":"focused":"disabled");
		if(!this._disabled)
		{
			if(!this.thumbPressed)
			{
				this.thumb.__set__displayFocus(this._focused != 0);
			}
			if(!this.trackPressed)
			{
				this.track.__set__displayFocus(this._focused != 0);
			}
		}
		this.constraints.update(this.__width,this.__height);
		this.updateThumb();
	}
	function changeFocus()
	{
		this.invalidate();
	}
	function updateThumb()
	{
		if(this._disabled)
		{
			return undefined;
		}
		var _loc2_ = this.__width - this.offsetLeft - this.offsetRight;
		this.thumb._x = (this._value - this._minimum) / (this._maximum - this._minimum) * _loc2_ - this.thumb._width / 2 + this.offsetLeft;
	}
	function beginDrag(event)
	{
		this.thumbPressed = true;
		Selection.setFocus(this.thumb,event.controllerIdx);
		this.dragOffset = {x:this._xmouse - this.thumb._x - this.thumb._width / 2};
		this.onMouseMove = this.doDrag;
		this.onMouseUp = this.endDrag;
	}
	function doDrag()
	{
		var _loc3_ = this._xmouse - this.dragOffset.x;
		var _loc4_ = this.__width - this.offsetLeft - this.offsetRight;
		var _loc2_ = this.lockValue((_loc3_ - this.offsetLeft) / _loc4_ * (this._maximum - this._minimum) + this._minimum);
		this.updateThumb();
		if(this.__get__value() == _loc2_)
		{
			return undefined;
		}
		this._value = _loc2_;
		if(this.liveDragging)
		{
			this.dispatchEventAndSound({type:"change"});
		}
	}
	function endDrag()
	{
		delete this.onMouseUp;
		delete this.onMouseMove;
		if(!this.liveDragging)
		{
			this.dispatchEventAndSound({type:"change"});
		}
		if(this.trackDragMouseIndex != undefined)
		{
			if(!this.thumb.hitTest(_root._xmouse,_root._ymouse))
			{
				this.thumb.onReleaseOutside(this.trackDragMouseIndex);
			}
			else
			{
				this.thumb.onRelease(this.trackDragMouseIndex);
			}
		}
		delete this.trackDragMouseIndex;
		this.thumbPressed = false;
		this.trackPressed = false;
		this.invalidate();
	}
	function trackPress(e)
	{
		this.trackPressed = true;
		Selection.setFocus(this.track,e.controllerIdx);
		var _loc3_ = this.__width - this.offsetLeft - this.offsetRight;
		var _loc2_ = this.lockValue((this._xmouse - this.offsetLeft) / _loc3_ * (this._maximum - this._minimum) + this._minimum);
		if(this.__get__value() == _loc2_)
		{
			return undefined;
		}
		this.__set__value(_loc2_);
		if(this.liveDragging)
		{
			this.dispatchEventAndSound({type:"change"});
		}
		this.trackDragMouseIndex = e.controllerIdx;
		this.thumb.onPress(this.trackDragMouseIndex);
		this.dragOffset = {x:0};
	}
	function lockValue(value)
	{
		value = Math.max(this._minimum,Math.min(this._maximum,value));
		if(!this.__get__snapping())
		{
			return value;
		}
		return Math.round(value / this.__get__snapInterval()) * this.__get__snapInterval();
	}
	function scrollWheel(delta)
	{
		if(this._focused)
		{
			this.value = this.value - delta * this._snapInterval;
			this.dispatchEventAndSound({type:"change"});
		}
	}
}
