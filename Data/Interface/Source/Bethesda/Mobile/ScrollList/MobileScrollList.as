package Mobile.ScrollList
{
	import Shared.AS3.BSScrollingList;
	import Shared.BGSExternalInterface;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	public class MobileScrollList extends MovieClip
	{
		
		public static const ITEM_SELECT:String = "itemSelect";
		
		public static const ITEM_RELEASE:String = "itemRelease";
		
		public static const ITEM_RELEASE_OUTSIDE:String = "itemReleaseOutside";
		
		public static const HORIZONTAL:uint = 0;
		
		public static const VERTICAL:uint = 1;
		 
		
		private var _availableRenderers:Vector.<MobileListItemRenderer>;
		
		protected var _data:Vector.<Object>;
		
		protected var _rendererRect:Rectangle;
		
		protected var _bounds:Rectangle;
		
		protected var _scrollDim:Number;
		
		protected var _deltaBetweenButtons:Number;
		
		protected var _renderers:Vector.<MobileListItemRenderer>;
		
		protected var _tempSelectedIndex:int;
		
		protected var _selectedIndex:int;
		
		protected var _position:Number;
		
		protected var _direction:uint;
		
		private var _itemRendererLinkageId:String = "MobileListItemRendererMc";
		
		protected var _background:Sprite;
		
		protected var _scrollList:Sprite;
		
		protected var _scrollMask:Sprite;
		
		protected var _touchZone:Sprite;
		
		protected var _prevIndicator:MovieClip;
		
		protected var _nextIndicator:MovieClip;
		
		protected var _mouseDown:Boolean = false;
		
		protected var _velocity:Number = 0;
		
		protected const EPSILON:Number = 0.01;
		
		protected const VELOCITY_MOVE_FACTOR:Number = 0.4;
		
		protected const VELOCITY_MOUSE_DOWN_FACTOR:Number = 0.5;
		
		protected const VELOCITY_MOUSE_UP_FACTOR:Number = 0.8;
		
		protected const RESISTANCE_OUT_BOUNDS:Number = 0.15;
		
		protected const BOUNCE_FACTOR:Number = 0.6;
		
		protected var _mouseDownPos:Number = 0;
		
		protected var _mouseDownPoint:Point;
		
		protected var _prevMouseDownPoint:Point;
		
		private var _mousePressPos:Number;
		
		private const DELTA_MOUSE_POS:int = 15;
		
		protected var _hasBackground:Boolean = false;
		
		protected var _backgroundColor:int = 15658734;
		
		protected var _noScrollShortList:Boolean = false;
		
		protected var _clickable:Boolean = true;
		
		protected var _endListAlign:Boolean = false;
		
		protected var _textOption:String;
		
		private var _elasticity:Boolean = true;
		
		public function MobileScrollList(scrollDimension:Number, deltaBetweenButtons:Number = 0, direction:uint = 1)
		{
			this._mouseDownPoint = new Point();
			this._prevMouseDownPoint = new Point();
			super();
			this._scrollDim = scrollDimension;
			this._deltaBetweenButtons = deltaBetweenButtons;
			this._direction = direction;
			this._selectedIndex = -1;
			this._tempSelectedIndex = -1;
			this._position = NaN;
			this.hasBackground = false;
			this.noScrollShortList = false;
			this._clickable = true;
			this.endListAlign = false;
			this._availableRenderers = new Vector.<MobileListItemRenderer>();
		}
		
		public function get data() : Vector.<Object>
		{
			return this._data;
		}
		
		public function get renderers() : Vector.<MobileListItemRenderer>
		{
			return this._renderers;
		}
		
		public function get selectedIndex() : int
		{
			return this._selectedIndex;
		}
		
		public function set selectedIndex(value:int) : void
		{
			var currentSelection:MobileListItemRenderer = this.getRendererAt(this._selectedIndex);
			if(currentSelection != null)
			{
				currentSelection.unselectItem();
			}
			this._selectedIndex = value;
			var renderer:MobileListItemRenderer = this.getRendererAt(this._selectedIndex);
			if(renderer != null)
			{
				renderer.selectItem();
			}
			this.setPosition();
		}
		
		public function get selectedRenderer() : MobileListItemRenderer
		{
			return this.getRendererAt(this.selectedIndex);
		}
		
		public function get position() : Number
		{
			return this._position;
		}
		
		public function set position(value:Number) : void
		{
			this._position = value;
		}
		
		public function set needFullRefresh(value:Boolean) : void
		{
			if(value)
			{
				this._selectedIndex = -1;
				this._position = NaN;
				this.setPosition();
			}
		}
		
		private function get canScroll() : Boolean
		{
			var hasShortList:Boolean = this._direction == HORIZONTAL?this._scrollList.width < this._bounds.width:this._scrollList.height < this._bounds.height;
			if(!(this.noScrollShortList && hasShortList))
			{
				return true;
			}
			return false;
		}
		
		public function get itemRendererLinkageId() : String
		{
			return this._itemRendererLinkageId;
		}
		
		public function set itemRendererLinkageId(value:String) : void
		{
			this._itemRendererLinkageId = value;
		}
		
		public function get hasBackground() : Boolean
		{
			return this._hasBackground;
		}
		
		public function set hasBackground(value:Boolean) : void
		{
			this._hasBackground = value;
		}
		
		public function get backgroundColor() : int
		{
			return this._backgroundColor;
		}
		
		public function set backgroundColor(value:int) : void
		{
			this._backgroundColor = value;
		}
		
		public function get noScrollShortList() : Boolean
		{
			return this._noScrollShortList;
		}
		
		public function set noScrollShortList(value:Boolean) : void
		{
			this._noScrollShortList = value;
		}
		
		public function get clickable() : Boolean
		{
			return this._clickable;
		}
		
		public function set clickable(value:Boolean) : void
		{
			this._clickable = value;
		}
		
		public function get endListAlign() : Boolean
		{
			return this._endListAlign;
		}
		
		public function set endListAlign(value:Boolean) : void
		{
			this._endListAlign = value;
		}
		
		public function get textOption() : String
		{
			return this._textOption;
		}
		
		public function set textOption(value:String) : void
		{
			this._textOption = value;
		}
		
		public function get elasticity() : Boolean
		{
			return this._elasticity;
		}
		
		public function set elasticity(value:Boolean) : void
		{
			this._elasticity = value;
		}
		
		public function invalidateData() : void
		{
			var i:int = 0;
			if(this._data != null)
			{
				for(i = 0; i < this._data.length; i++)
				{
					this.removeRenderer(i);
				}
			}
			if(this._scrollMask != null)
			{
				removeChild(this._scrollMask);
				this._scrollMask = null;
			}
			if(this._background != null)
			{
				removeChild(this._background);
				this._background = null;
			}
			if(this._touchZone != null)
			{
				this._scrollList.removeChild(this._touchZone);
				this._touchZone = null;
			}
			if(this._scrollList != null)
			{
				if(this._scrollList.stage != null)
				{
					this._scrollList.stage.removeEventListener(MouseEvent.MOUSE_UP,this.mouseUpHandler);
					this._scrollList.stage.removeEventListener(MouseEvent.MOUSE_MOVE,this.mouseMoveHandler);
				}
				this._scrollList.mask = null;
			}
			this._tempSelectedIndex = -1;
			this._bounds = null;
			this._data = null;
			this._renderers = null;
			this._mouseDown = false;
		}
		
		public function setData(data:Vector.<Object>) : void
		{
			var i:int = 0;
			this.invalidateData();
			this._data = data;
			if(this.endListAlign)
			{
				this._data.reverse();
			}
			this._renderers = new Vector.<MobileListItemRenderer>();
			if(this._scrollList == null)
			{
				this._scrollList = new Sprite();
				addChild(this._scrollList);
				this._scrollList.addEventListener(MouseEvent.MOUSE_DOWN,this.mouseDownHandler,false,0,true);
				this._scrollList.addEventListener(Event.ENTER_FRAME,this.enterFrameHandler,false,0,true);
			}
			for(i = 0; i < this._data.length; i++)
			{
				this._renderers.push(this.addRenderer(i,this._data[i]));
			}
			if(this._deltaBetweenButtons > 0)
			{
				this._touchZone = this.createSprite(16776960,new Rectangle(0,0,this._scrollList.width,this._scrollList.height),0);
				this._scrollList.addChildAt(this._touchZone,0);
			}
			this._bounds = this._direction == HORIZONTAL?new Rectangle(0,0,this._scrollDim,this._rendererRect.height):new Rectangle(0,0,this._rendererRect.width,this._scrollDim);
			this.createMask();
			if(this.hasBackground)
			{
				this.createBackground();
			}
			this.selectedIndex = this._selectedIndex;
			if(!this.canScroll)
			{
				if(this._prevIndicator)
				{
					this._prevIndicator.visible = false;
				}
				if(this._nextIndicator)
				{
					this._nextIndicator.visible = false;
				}
			}
			this.setDataOnVisibleRenderers();
		}
		
		public function setScrollIndicators(prevIndicator:MovieClip, nextIndicator:MovieClip) : void
		{
			this._prevIndicator = prevIndicator;
			this._nextIndicator = nextIndicator;
			if(this._prevIndicator)
			{
				this._prevIndicator.visible = false;
			}
			if(this._nextIndicator)
			{
				this._nextIndicator.visible = false;
			}
		}
		
		protected function setPosition() : void
		{
			var selectedRendererPos:Number = NaN;
			if(this._data == null)
			{
				return;
			}
			var scrollDim:Number = this._direction == HORIZONTAL?Number(this._scrollList.width):Number(this._scrollList.height);
			var boundsDim:Number = this._direction == HORIZONTAL?Number(this._bounds.width):Number(this._bounds.height);
			var scrollPos:Number = this._direction == HORIZONTAL?Number(this._scrollList.x):Number(this._scrollList.y);
			if(isNaN(this.position))
			{
				if(this.selectedIndex != -1)
				{
					selectedRendererPos = this._direction == HORIZONTAL?Number(this.selectedRenderer.x):Number(this.selectedRenderer.y);
					if(this.canScroll)
					{
						if(scrollDim - selectedRendererPos < boundsDim)
						{
							this._position = boundsDim - scrollDim;
						}
						else
						{
							this._position = -selectedRendererPos;
						}
					}
					else
					{
						this._position = !!this.endListAlign?Number(boundsDim - scrollDim):Number(0);
					}
				}
				else
				{
					if(this._direction == HORIZONTAL)
					{
						this._scrollList.x = !!this.endListAlign?Number(boundsDim - scrollDim):Number(0);
					}
					else
					{
						this._scrollList.y = !!this.endListAlign?Number(boundsDim - scrollDim):Number(0);
					}
					this.setDataOnVisibleRenderers();
					return;
				}
			}
			else if(this.canScroll)
			{
				if(this._position + scrollDim < boundsDim)
				{
					this._position = boundsDim - scrollDim;
				}
				else if(this._position > 0)
				{
					this._position = 0;
				}
			}
			else
			{
				this._position = !!this.endListAlign?Number(boundsDim - scrollDim):Number(0);
			}
			if(this._direction == HORIZONTAL)
			{
				this._scrollList.x = this._position;
			}
			else
			{
				this._scrollList.y = this._position;
			}
			this.setDataOnVisibleRenderers();
		}
		
		protected function addRenderer(position:int, data:Object) : MobileListItemRenderer
		{
			var previousRenderer:MobileListItemRenderer = null;
			var renderer:MobileListItemRenderer = this.acquireRenderer();
			renderer.reset();
			var posY:Number = 0;
			if(position > 0)
			{
				previousRenderer = this.getRendererAt(position - 1);
				posY = previousRenderer.y + previousRenderer.height + this._deltaBetweenButtons;
			}
			renderer.y = posY;
			if(this._textOption === BSScrollingList.TEXT_OPTION_MULTILINE)
			{
				this.setRendererData(renderer,data,position);
			}
			renderer.visible = true;
			return renderer;
		}
		
		protected function addRendererListeners(renderer:MobileListItemRenderer) : void
		{
			renderer.addEventListener(ITEM_SELECT,this.itemSelectHandler,false,0,true);
			renderer.addEventListener(ITEM_RELEASE,this.itemReleaseHandler,false,0,true);
			renderer.addEventListener(ITEM_RELEASE_OUTSIDE,this.itemReleaseOutsideHandler,false,0,true);
		}
		
		protected function removeRenderer(position:int) : void
		{
			var renderer:MobileListItemRenderer = this._renderers[position];
			if(renderer != null)
			{
				renderer.visible = false;
				renderer.y = 0;
				this.releaseRenderer(renderer);
			}
		}
		
		protected function removeRendererListeners(renderer:MobileListItemRenderer) : void
		{
			renderer.removeEventListener(ITEM_SELECT,this.itemSelectHandler);
			renderer.removeEventListener(ITEM_RELEASE,this.itemReleaseHandler);
			renderer.removeEventListener(ITEM_RELEASE_OUTSIDE,this.itemReleaseOutsideHandler);
		}
		
		protected function getRendererAt(position:int) : MobileListItemRenderer
		{
			if(this._data == null || this._renderers == null || position > this._data.length - 1 || position < 0)
			{
				return null;
			}
			if(this.endListAlign)
			{
				return this._renderers[this._data.length - 1 - position];
			}
			return this._renderers[position];
		}
		
		private function acquireRenderer() : MobileListItemRenderer
		{
			var renderer:MobileListItemRenderer = null;
			if(this._availableRenderers.length > 0)
			{
				return this._availableRenderers.pop();
			}
			renderer = FlashUtil.getLibraryItem(this,this._itemRendererLinkageId) as MobileListItemRenderer;
			this._scrollList.addChild(renderer);
			if(this._rendererRect === null)
			{
				this._rendererRect = new Rectangle(renderer.x,renderer.y,renderer.width,renderer.height);
			}
			this.addRendererListeners(renderer);
			return renderer;
		}
		
		private function releaseRenderer(renderer:MobileListItemRenderer) : void
		{
			this._availableRenderers.push(renderer);
		}
		
		protected function resetPressState(renderer:MobileListItemRenderer) : void
		{
			if(renderer != null && renderer.data != null)
			{
				if(this.selectedIndex == renderer.data.id)
				{
					renderer.selectItem();
				}
				else
				{
					renderer.unselectItem();
				}
			}
		}
		
		protected function itemSelectHandler(e:EventWithParams) : void
		{
			var renderer:MobileListItemRenderer = null;
			var rendererId:int = 0;
			if(this.clickable)
			{
				renderer = e.params.renderer as MobileListItemRenderer;
				rendererId = renderer.data.id;
				this._mousePressPos = this._direction == MobileScrollList.HORIZONTAL?Number(stage.mouseX):Number(stage.mouseY);
				this._tempSelectedIndex = rendererId;
				renderer.pressItem();
			}
		}
		
		protected function itemReleaseHandler(e:EventWithParams) : void
		{
			var renderer:MobileListItemRenderer = null;
			var rendererId:int = 0;
			if(this.clickable)
			{
				renderer = e.params.renderer as MobileListItemRenderer;
				rendererId = renderer.data.id;
				if(this._tempSelectedIndex == rendererId)
				{
					this.selectedIndex = rendererId;
					this.dispatchEvent(new EventWithParams(MobileScrollList.ITEM_SELECT,{"renderer":renderer}));
				}
			}
		}
		
		protected function itemReleaseOutsideHandler(e:EventWithParams) : void
		{
			var renderer:MobileListItemRenderer = null;
			if(this.clickable)
			{
				renderer = e.params.renderer as MobileListItemRenderer;
				this.resetPressState(renderer);
				this._tempSelectedIndex = -1;
			}
		}
		
		protected function createMask() : void
		{
			this._scrollMask = this.createSprite(16711935,new Rectangle(this._bounds.x,this._bounds.y,this._bounds.width,this._bounds.height));
			addChild(this._scrollMask);
			this._scrollMask.mouseEnabled = false;
			this._scrollList.mask = this._scrollMask;
		}
		
		protected function createBackground() : void
		{
			this._background = this.createSprite(this.backgroundColor,new Rectangle(this._bounds.x,this._bounds.y,this._bounds.width,this._bounds.height));
			this._background.x = this._bounds.x;
			this._background.y = this._bounds.y;
			addChildAt(this._background,0);
		}
		
		protected function createSprite(color:int, rect:Rectangle, alpha:Number = 1) : Sprite
		{
			var sprite:* = new Sprite();
			sprite.graphics.beginFill(color,alpha);
			sprite.graphics.drawRect(rect.x,rect.y,rect.width,rect.height);
			sprite.graphics.endFill();
			return sprite;
		}
		
		protected function enterFrameHandler(e:Event) : void
		{
			var velocityFactor:* = undefined;
			var scrollDim:Number = NaN;
			var maxDim:Number = NaN;
			var scrollPos:Number = NaN;
			var bouncing:Number = NaN;
			if(this._bounds != null && this.canScroll)
			{
				velocityFactor = !!this._mouseDown?this.VELOCITY_MOUSE_DOWN_FACTOR:this.VELOCITY_MOUSE_UP_FACTOR;
				this._velocity = this._velocity * velocityFactor;
				scrollDim = this._direction == HORIZONTAL?Number(this._scrollList.width):Number(this._scrollList.height);
				maxDim = this._direction == HORIZONTAL?Number(this._bounds.width):Number(this._bounds.height);
				scrollPos = this._direction == HORIZONTAL?Number(this._scrollList.x):Number(this._scrollList.y);
				if(!this._mouseDown)
				{
					bouncing = 0;
					if(scrollPos >= 0 || scrollDim <= maxDim)
					{
						if(this.elasticity)
						{
							bouncing = -scrollPos * this.BOUNCE_FACTOR;
							this._position = scrollPos + this._velocity + bouncing;
						}
						else
						{
							this._position = 0;
						}
					}
					else if(scrollPos + scrollDim <= maxDim)
					{
						if(this.elasticity)
						{
							bouncing = (maxDim - scrollDim - scrollPos) * this.BOUNCE_FACTOR;
							this._position = scrollPos + this._velocity + bouncing;
						}
						else
						{
							this._position = maxDim - scrollDim;
						}
					}
					else
					{
						this._position = scrollPos + this._velocity;
					}
					if(Math.abs(this._velocity) > this.EPSILON || bouncing != 0)
					{
						if(this._direction == HORIZONTAL)
						{
							this._scrollList.x = this._position;
						}
						else
						{
							this._scrollList.y = this._position;
						}
						this.setDataOnVisibleRenderers();
					}
				}
				if(this._prevIndicator)
				{
					this._prevIndicator.visible = scrollPos < 0;
				}
				if(this._nextIndicator)
				{
					this._nextIndicator.visible = scrollPos > maxDim - scrollDim;
				}
			}
		}
		
		protected function mouseDownHandler(e:MouseEvent) : void
		{
			if(!this._mouseDown && this.canScroll)
			{
				this._mouseDownPoint = new Point(e.stageX,e.stageY);
				this._prevMouseDownPoint = new Point(e.stageX,e.stageY);
				this._mouseDown = true;
				this._mouseDownPos = this._direction == HORIZONTAL?Number(this._scrollList.x):Number(this._scrollList.y);
				this._scrollList.stage.addEventListener(MouseEvent.MOUSE_UP,this.mouseUpHandler,false,0,true);
				this._scrollList.stage.addEventListener(MouseEvent.MOUSE_MOVE,this.mouseMoveHandler,false,0,true);
				BGSExternalInterface.call(null,"OnScrollingStarted");
			}
		}
		
		protected function mouseMoveHandler(e:MouseEvent) : void
		{
			var point:Point = null;
			var nextScrollListPos:Number = NaN;
			if(this._mouseDown && this.canScroll)
			{
				if(!isNaN(e.stageX) && !isNaN(e.stageY))
				{
					point = new Point(e.stageX,e.stageY);
					if(this._direction == HORIZONTAL)
					{
						nextScrollListPos = point.x - this._prevMouseDownPoint.x;
						if(this._scrollList.x >= this._bounds.x || this._scrollList.x <= this._bounds.x - (this._scrollList.width - this._bounds.width))
						{
							if(this.elasticity)
							{
								this._scrollList.x = this._scrollList.x + nextScrollListPos * this.RESISTANCE_OUT_BOUNDS;
							}
							else if(!(this._scrollList.x >= this._bounds.x && nextScrollListPos > 0 || this._scrollList.x <= this._bounds.x - (this._scrollList.width - this._bounds.width) && nextScrollListPos < 0))
							{
								this._scrollList.x = this._scrollList.x + nextScrollListPos;
							}
						}
						else
						{
							this._scrollList.x = this._scrollList.x + nextScrollListPos;
						}
						this._position = this._scrollList.x;
						if(Math.abs(point.x - this._mousePressPos) > this.DELTA_MOUSE_POS)
						{
							this.resetPressState(this.getRendererAt(this._tempSelectedIndex));
							this._tempSelectedIndex = -1;
						}
						this._velocity = this._velocity + (point.x - this._prevMouseDownPoint.x) * this.VELOCITY_MOVE_FACTOR;
					}
					else
					{
						nextScrollListPos = point.y - this._prevMouseDownPoint.y;
						if(this._scrollList.y >= this._bounds.y || this._scrollList.y <= this._bounds.y - (this._scrollList.height - this._bounds.height))
						{
							if(this.elasticity)
							{
								this._scrollList.y = this._scrollList.y + nextScrollListPos * this.RESISTANCE_OUT_BOUNDS;
							}
							else if(!(this._scrollList.y >= this._bounds.y && nextScrollListPos > 0 || this._scrollList.y <= this._bounds.y - (this._scrollList.height - this._bounds.height) && nextScrollListPos < 0))
							{
								this._scrollList.y = this._scrollList.y + nextScrollListPos;
							}
						}
						else
						{
							this._scrollList.y = this._scrollList.y + nextScrollListPos;
						}
						this._position = this._scrollList.y;
						if(Math.abs(point.y - this._mousePressPos) > this.DELTA_MOUSE_POS)
						{
							this.resetPressState(this.getRendererAt(this._tempSelectedIndex));
							this._tempSelectedIndex = -1;
						}
						this._velocity = this._velocity + (point.y - this._prevMouseDownPoint.y) * this.VELOCITY_MOVE_FACTOR;
					}
					this._prevMouseDownPoint = point;
				}
				if(isNaN(this.mouseX) || isNaN(this.mouseY) || this.mouseY < this._bounds.y || this.mouseY > this._bounds.height + this._bounds.y || this.mouseX < this._bounds.x || this.mouseX > this._bounds.width + this._bounds.x)
				{
					this.mouseUpHandler(null);
				}
				this.setDataOnVisibleRenderers();
			}
		}
		
		protected function mouseUpHandler(e:MouseEvent) : void
		{
			if(this._mouseDown && this.canScroll)
			{
				this._mouseDown = false;
				this._scrollList.stage.removeEventListener(MouseEvent.MOUSE_UP,this.mouseUpHandler);
				this._scrollList.stage.removeEventListener(MouseEvent.MOUSE_MOVE,this.mouseMoveHandler);
				BGSExternalInterface.call(null,"OnScrollingStopped");
			}
		}
		
		private function setDataOnVisibleRenderers() : void
		{
			var rendererPosition:Number = NaN;
			for(var i:int = 0; i < this._renderers.length; i++)
			{
				if(this._renderers[i].data === null)
				{
					rendererPosition = this._scrollList.y + this._renderers[i].y;
					if(rendererPosition < this._bounds.y + this._bounds.height && rendererPosition + this._renderers[i].height > this._bounds.y)
					{
						this.setRendererData(this._renderers[i],this.data[i],i);
					}
				}
			}
		}
		
		private function setRendererData(renderer:MobileListItemRenderer, data:Object, index:int) : void
		{
			data.id = index;
			data.textOption = this._textOption;
			renderer.setData(data);
		}
		
		public function destroy() : void
		{
			this.invalidateData();
		}
	}
}
