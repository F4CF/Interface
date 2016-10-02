class gfx.controls.TextArea extends gfx.controls.TextInput
{
	var soundMap = {theme:"default",focusIn:"focusIn",focusOut:"focusOut",textChange:"textChange",scroll:"scroll"};
	var _scrollPolicy = "auto";
	var _position = 1;
	var maxscroll = 1;
	var autoScrollBar = false;
	var resetScrollPosition = false;
	function TextArea()
	{
		super();
	}
	function __get__position()
	{
		return this._position;
	}
	function __set__position(value)
	{
		this._position = value;
		this.textField.scroll = this._position;
		return this.__get__position();
	}
	function __get__scrollPolicy()
	{
		return this._scrollPolicy;
	}
	function __set__scrollPolicy(value)
	{
		this._scrollPolicy = value;
		this.updateScrollBar();
		return this.__get__scrollPolicy();
	}
	function __get__scrollBar()
	{
		return this._scrollBar;
	}
	function __set__scrollBar(value)
	{
		if(!this.initialized)
		{
			this.inspectableScrollBar = value;
			return undefined;
		}
		if(this._scrollBar == value)
		{
			return undefined;
		}
		if(this._scrollBar != null)
		{
			this._scrollBar.scrollTarget = null;
			this._scrollBar.focusTarget = null;
			this._scrollBar.removeEventListener("scroll",this,"handleScroll");
			if(this.autoScrollBar)
			{
				this._scrollBar.removeMovieClip();
			}
		}
		this.autoScrollBar = false;
		if(typeof value == "string")
		{
			this._scrollBar = (MovieClip)this._parent[value.toString()];
			if(this._scrollBar == null)
			{
				this._scrollBar = this.container.attachMovie(value.toString(),"_scrollBar",1000,{_visible:false});
				if(this._scrollBar != null)
				{
					this.autoScrollBar = true;
				}
			}
		}
		else
		{
			this._scrollBar = (MovieClip)value;
		}
		if(this._scrollBar == null)
		{
			return undefined;
		}
		this._scrollBar.focusTarget = this;
		this._scrollBar.scrollTarget = this.textField;
		this.maxscroll = this.textField.maxscroll;
		this.updateScrollBar();
		this.changeLock = true;
		this.onChanged();
		this.changeLock = false;
		return this.__get__scrollBar();
	}
	function __get__disabled()
	{
		return this._disabled;
	}
	function __set__disabled(value)
	{
		super.__set__disabled(value);
		this.updateScrollBar();
		return this.__get__disabled();
	}
	function toString()
	{
		return "[Scaleform TextArea " + this._name + "]";
	}
	function handleInput(details, pathToFocus)
	{
		if(details.value != "keyDown" && details.value != "keyHold")
		{
			return false;
		}
		var _loc2_ = details.controllerIdx;
		if(Selection.getFocus(_loc2_) == null)
		{
			Selection.setFocus(this.textField,_loc2_);
			return true;
		}
		if(this._editable)
		{
			return false;
		}
		switch(details.navEquivalent)
		{
			case gfx.ui.NavigationCode.UP:
				if(this.__get__position() == 1)
				{
					return false;
				}
				this.__set__position(Math.max(1,this.__get__position() - 1));
				return true;
			case gfx.ui.NavigationCode.DOWN:
				if(this.__get__position() == this.maxscroll)
				{
					return false;
				}
				this.__set__position(Math.min(this.maxscroll,this.__get__position() + 1));
				return true;
			case gfx.ui.NavigationCode.END:
				this.__set__position(this.maxscroll);
				return true;
			case gfx.ui.NavigationCode.HOME:
				this.__set__position(1);
				return true;
			case gfx.ui.NavigationCode.PAGE_UP:
				var _loc4_ = this.textField.bottomScroll - this.textField.scroll;
				this.__set__position(Math.max(1,this.__get__position() - _loc4_));
				return true;
			case gfx.ui.NavigationCode.PAGE_DOWN:
				_loc4_ = this.textField.bottomScroll - this.textField.scroll;
				this.__set__position(Math.min(this.maxscroll,this.__get__position() + _loc4_));
				return true;
			default:
				return false;
		}
	}
	function configUI()
	{
		super.configUI();
		Mouse.addListener(this);
		this.container = this.createEmptyMovieClip("container",1);
		this.container.scale9Grid = new flash.geom.Rectangle(20,20,1,1);
		if(this.inspectableScrollBar != "")
		{
			this.__set__scrollBar(this.inspectableScrollBar);
			this.inspectableScrollBar = null;
		}
	}
	function draw()
	{
		super.draw();
		this.container._xscale = 10000 / this._xscale;
		this.container._yscale = 10000 / this._yscale;
		if(this.autoScrollBar)
		{
			this._scrollBar._x = this.__width - this._scrollBar._width;
			this._scrollBar.height = this.__height - 1;
		}
	}
	function updateText()
	{
		super.updateText();
		this.updateScrollBar();
	}
	function updateTextField()
	{
		this.resetScrollPosition = true;
		super.updateTextField();
		if(this.textField != null)
		{
			if(this._scrollBar != null)
			{
				this._scrollBar.scrollTarget = this.textField;
			}
		}
	}
	function updateScrollBar()
	{
		this.maxscroll = this.textField.maxscroll;
		if(this._scrollBar == undefined)
		{
			return undefined;
		}
		var _loc2_ = this.constraints.getElement(this.textField);
		if(this._scrollPolicy == "on" || this._scrollPolicy == "auto" && this.textField.maxscroll > 1)
		{
			if(this.autoScrollBar && !this._scrollBar.visible)
			{
				if(_loc2_ != null)
				{
					_loc2_.metrics.right = _loc2_.metrics.right + this._scrollBar._width;
					this.constraints.update(this.__width,this.__height);
				}
				this.maxscroll = this.textField.maxscroll;
			}
			this._scrollBar.visible = true;
		}
		if(this._scrollPolicy == "off" || this._scrollPolicy == "auto" && this.textField.maxscroll == 1)
		{
			if(this.autoScrollBar && this._scrollBar.visible)
			{
				if(_loc2_ != null)
				{
					_loc2_.metrics.right = _loc2_.metrics.right - this._scrollBar._width;
					this.constraints.update(this.__width,this.__height);
				}
			}
			this._scrollBar.visible = false;
		}
		if(this._scrollBar.disabled != this._disabled)
		{
			this._scrollBar.disabled = this._disabled;
		}
	}
	function onChanged(target)
	{
		if(this.maxscroll != this.textField.maxscroll)
		{
			this.updateScrollBar();
		}
		super.onChanged(target);
	}
	function onScroller()
	{
		if(this.resetScrollPosition)
		{
			this.textField.scroll = this._position;
		}
		else
		{
			this._position = this.textField.scroll;
		}
		this.resetScrollPosition = false;
		this.dispatchEventAndSound({type:"scroll"});
	}
	function scrollWheel(delta)
	{
		this.__set__position(Math.max(1,Math.min(this.maxscroll,this._position - delta)));
	}
}
