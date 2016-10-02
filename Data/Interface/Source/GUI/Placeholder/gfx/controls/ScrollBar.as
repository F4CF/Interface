class gfx.controls.ScrollBar extends gfx.controls.ScrollIndicator
{
	var trackScrollPageSize = 1;
	var _trackMode = "scrollPage";
	var trackScrollPosition = -1;
	function ScrollBar()
	{
		super();
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
		this.gotoAndPlay(!this._disabled?"default":"disabled");
		if(this.initialized)
		{
			this.upArrow.__set__disabled(this._disabled);
			this.downArrow.__set__disabled(this._disabled);
			this.track.__set__disabled(this._disabled);
		}
		return this.__get__disabled();
	}
	function __get__position()
	{
		return super.__get__position();
	}
	function __set__position(value)
	{
		value = Math.round(value);
		if(value == this.__get__position())
		{
			return undefined;
		}
		super.__set__position(value);
		this.updateScrollTarget();
		return this.__get__position();
	}
	function __get__trackMode()
	{
		return this._trackMode;
	}
	function __set__trackMode(value)
	{
		if(value == this._trackMode)
		{
			return undefined;
		}
		this._trackMode = value;
		if(this.initialized)
		{
			this.track.autoRepeat = this.__get__trackMode() == "scrollPage";
		}
		return this.__get__trackMode();
	}
	function __get__availableHeight()
	{
		return this.track.__get__height() - this.thumb.__get__height() + this.offsetBottom + this.offsetTop;
	}
	function toString()
	{
		return "[Scaleform ScrollBar " + this._name + "]";
	}
	function configUI()
	{
		super.configUI();
		delete this.onRelease;
		if(this.upArrow)
		{
			this.upArrow.addEventListener("click",this,"scrollUp");
			this.upArrow.useHandCursor = !this._disabled;
			this.upArrow.__set__disabled(this._disabled);
			this.upArrow.focusTarget = this;
			this.upArrow.autoRepeat = true;
		}
		if(this.downArrow)
		{
			this.downArrow.addEventListener("click",this,"scrollDown");
			this.downArrow.useHandCursor = !this._disabled;
			this.downArrow.__set__disabled(this._disabled);
			this.downArrow.focusTarget = this;
			this.downArrow.autoRepeat = true;
		}
		this.thumb.addEventListener("press",this,"beginDrag");
		this.thumb.useHandCursor = !this._disabled;
		this.thumb.lockDragStateChange = true;
		this.track.addEventListener("press",this,"beginTrackScroll");
		this.track.addEventListener("click",this,"trackScroll");
		this.track.__set__disabled(this._disabled);
		this.track.autoRepeat = this.__get__trackMode() == "scrollPage";
		Mouse.addListener(this);
		var _loc3_ = this._rotation;
		this._rotation = 0;
		this.constraints = new gfx.utils.Constraints(this);
		if(this.downArrow)
		{
			this.constraints.addElement(this.downArrow,gfx.utils.Constraints.BOTTOM);
		}
		this.constraints.addElement(this.track,gfx.utils.Constraints.TOP | gfx.utils.Constraints.BOTTOM);
		this._rotation = _loc3_;
	}
	function draw()
	{
		if(this.direction == "horizontal")
		{
			this.constraints.update(this.__height,this.__width);
		}
		else
		{
			this.constraints.update(this.__width,this.__height);
		}
		if(this._scrollTarget instanceof TextField)
		{
			this.setScrollProperties(this._scrollTarget.bottomScroll - this._scrollTarget.scroll,1,this._scrollTarget.maxscroll);
		}
		else
		{
			this.updateThumb();
		}
	}
	function updateThumb()
	{
		if(!this.initialized)
		{
			this.invalidate();
			return undefined;
		}
		if(this._disabled)
		{
			return undefined;
		}
		var _loc5_ = Math.max(1,this.maxPosition - this.minPosition + this.pageSize);
		var _loc4_ = this.track.__get__height() + this.offsetTop + this.offsetBottom;
		var _loc6_ = _loc4_;
		this.thumb.__set__height(Math.max(10,Math.min(_loc4_,this.pageSize / _loc5_ * _loc6_)));
		var _loc2_ = (this._position - this.minPosition) / (this.maxPosition - this.minPosition);
		var _loc3_ = this.track._y - this.offsetTop;
		var _loc7_ = _loc2_ * this.__get__availableHeight() + _loc3_;
		this.thumb._y = Math.max(_loc3_,Math.min(this.track._y + this.track.__get__height() - this.thumb.__get__height() + this.offsetBottom,_loc7_));
		this.thumb.__set__visible(!(isNaN(_loc2_) || this.maxPosition <= 0 || this.maxPosition == Infinity));
		if(this.thumb.__get__visible())
		{
			this.track.__set__disabled(false);
			if(this.upArrow)
			{
				if(this._position == this.minPosition)
				{
					this.upArrow.__set__disabled(true);
				}
				else
				{
					this.upArrow.__set__disabled(false);
				}
			}
			if(this.downArrow)
			{
				if(this._position == this.maxPosition)
				{
					this.downArrow.__set__disabled(true);
				}
				else
				{
					this.downArrow.__set__disabled(false);
				}
			}
		}
		else
		{
			if(this.upArrow)
			{
				this.upArrow.__set__disabled(true);
			}
			if(this.downArrow)
			{
				this.downArrow.__set__disabled(true);
			}
			this.track.__set__disabled(true);
		}
	}
	function scrollUp()
	{
		this.position = this.position - this.pageScrollSize;
	}
	function scrollDown()
	{
		this.position = this.position + this.pageScrollSize;
	}
	function beginDrag()
	{
		if(this.isDragging == true)
		{
			return undefined;
		}
		this.isDragging = true;
		this.onMouseMove = this.doDrag;
		this.onMouseUp = this.endDrag;
		this.dragOffset = {y:this._ymouse - this.thumb._y};
	}
	function doDrag()
	{
		var _loc2_ = (this._ymouse - this.dragOffset.y - this.track._y) / this.__get__availableHeight();
		this.__set__position(this.minPosition + _loc2_ * (this.maxPosition - this.minPosition));
	}
	function endDrag()
	{
		delete this.onMouseUp;
		delete this.onMouseMove;
		this.isDragging = false;
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
	}
	function beginTrackScroll(e)
	{
		var _loc2_ = (this._ymouse - this.thumb.__get__height() / 2 - this.track._y) / this.__get__availableHeight();
		this.trackScrollPosition = Math.round(_loc2_ * (this.maxPosition - this.minPosition) + this.minPosition);
		if(Key.isDown(16) || this.__get__trackMode() == "scrollToCursor")
		{
			this.__set__position(this.trackScrollPosition);
			this.trackDragMouseIndex = e.controllerIdx;
			this.thumb.onPress(this.trackDragMouseIndex);
			this.dragOffset = {y:this.thumb.__get__height() / 2};
		}
	}
	function trackScroll()
	{
		if(this.isDragging || this.__get__position() == this.trackScrollPosition)
		{
			return undefined;
		}
		var _loc3_ = this.__get__position() >= this.trackScrollPosition?- this.trackScrollPageSize:this.trackScrollPageSize;
		var _loc2_ = this.__get__position() + _loc3_;
		this.__set__position(_loc3_ >= 0?Math.min(_loc2_,this.trackScrollPosition):Math.max(_loc2_,this.trackScrollPosition));
	}
	function updateScrollTarget()
	{
		if(this._scrollTarget == null)
		{
			return undefined;
		}
		if(this._scrollTarget && !this._disabled)
		{
			this._scrollTarget.scroll = this._position;
		}
	}
	function scrollWheel(delta)
	{
		this.position = this.position - delta * this.pageScrollSize;
	}
}
