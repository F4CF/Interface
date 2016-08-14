package Shared.AS3
{
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import Shared.PlatformChangeEvent;
	import Shared.PlatformRequestEvent;

	public dynamic class BSUIComponent extends MovieClip
	{
		private var _bIsDirty:Boolean;
		private var _iPlatform:Number;
		private var _bPS3Switch:Boolean;
		private var _bAcquiredByNativeCode:Boolean;

		private var _bUseShadedBackground:Boolean = false;
		private var _shadedBackgroundType:String = "normal";
		private var _shadedBackgroundMethod:String = "Shader";

		private var _bShowBrackets:Boolean = false;
		private var _bracketLineWidth:Number = 1.5;
		private var _bracketCornerLength:Number = 6;
		private var _bracketPaddingX:Number = 0;
		private var _bracketPaddingY:Number = 0;
		private var _bracketStyle:String = "horizontal";
		private var _bracketPair:Shared.AS3.BSBracketClip;


		public function BSUIComponent()
		{
			super();
			this._bIsDirty = false;
			this._iPlatform = PlatformChangeEvent.PLATFORM_INVALID;
			this._bPS3Switch = false;
			this._bAcquiredByNativeCode = false;
			this._bracketPair = new Shared.AS3.BSBracketClip();
			addEventListener(Event.ADDED_TO_STAGE, this.onAddedToStageEvent);
		}


		// Stage Methods

		private final function onAddedToStageEvent(e:Event) : void
		{
			removeEventListener(Event.ADDED_TO_STAGE, this.onAddedToStageEvent);
			this.onAddedToStage();
			addEventListener(Event.REMOVED_FROM_STAGE, this.onRemovedFromStageEvent);
		}

		public function onAddedToStage() : void
		{
			dispatchEvent(new PlatformRequestEvent(this));
			if(stage)
			{
				stage.addEventListener(PlatformChangeEvent.PLATFORM_CHANGE, this.onSetPlatformEvent);
			}
			if(this.bIsDirty)
			{
				this.requestRedraw();
			}
		}


		private final function onRemovedFromStageEvent(e:Event) : void
		{
			removeEventListener(Event.REMOVED_FROM_STAGE, this.onRemovedFromStageEvent);
			this.onRemovedFromStage();
			addEventListener(Event.ADDED_TO_STAGE, this.onAddedToStageEvent);
		}


		public function onRemovedFromStage() : void
		{
			if(stage)
			{
				stage.removeEventListener(PlatformChangeEvent.PLATFORM_CHANGE, this.onSetPlatformEvent);
				stage.removeEventListener(Event.RENDER, this.onRenderEvent);
			}
		}


		// Render

		private final function onRenderEvent(e:Event) : void
		{
			var bBracketsDrawn:* = undefined;
			var preDrawBounds:Rectangle = null;
			var postDrawBounds:Rectangle = null;
			var arEvent:Event = e;
			removeEventListener(Event.ENTER_FRAME, this.onEnterFrameEvent, false);
			if(stage)
			{
				stage.removeEventListener(Event.RENDER, this.onRenderEvent);
			}
			if(this.bIsDirty)
			{
				this.ClearIsDirty();
				try
				{
					bBracketsDrawn = contains(this._bracketPair);
					if(bBracketsDrawn)
					{
						removeChild(this._bracketPair);
					}
					preDrawBounds = getBounds(this);
					this.redrawUIComponent();
					postDrawBounds = getBounds(this);
					this.UpdateBrackets(!bBracketsDrawn || preDrawBounds != postDrawBounds);
				}
				catch(ex:Error)
				{
					trace(this + " " + this.name + ": " + ex.getStackTrace());
				}
			}
			if(this.bIsDirty)
			{
				addEventListener(Event.ENTER_FRAME, this.onEnterFrameEvent, false, 0, true);
			}
		}


		public function UpdateBrackets(aUpdate:Boolean) : *
		{
			if(Boolean(this._bShowBrackets) && width > this.bracketCornerLength && height > this._bracketCornerLength)
			{
				if(aUpdate)
				{
					this._bracketPair.redrawUIComponent(this, this.bracketLineWidth, this.bracketCornerLength, new Point(this._bracketPaddingX, this.bracketPaddingY), this.BracketStyle);
				}
				addChild(this._bracketPair);
			}
			else
			{
				this._bracketPair.ClearBrackets();
			}
		}


		private final function onEnterFrameEvent(e:Event) : void
		{
			removeEventListener(Event.ENTER_FRAME, this.onEnterFrameEvent, false);
			if(this.bIsDirty)
			{
				this.requestRedraw();
			}
		}


		private function requestRedraw() : void
		{
			if(stage)
			{
				stage.addEventListener(Event.RENDER, this.onRenderEvent);
				addEventListener(Event.ENTER_FRAME, this.onEnterFrameEvent, false, 0, true);
				stage.invalidate();
			}
		}


		public function redrawUIComponent() : void
		{
			// override on extending class
		}


		// Platform

		private final function onSetPlatformEvent(e:Event) : *
		{
			var platformChange:PlatformChangeEvent = e as PlatformChangeEvent;
			this.SetPlatform(platformChange.uiPlatform, platformChange.bPS3Switch);
		}


		public function SetPlatform(aPlatform:Number, aPS3Switch:Boolean) : void
		{
			if(this._iPlatform != aPlatform || this._bPS3Switch != aPS3Switch)
			{
				this._iPlatform = aPlatform;
				this._bPS3Switch = aPS3Switch;
				this.SetIsDirty();
			}
		}

		// Methods

		public function SetIsDirty() : void
		{
			this._bIsDirty = true;
			this.requestRedraw();
		}


		private final function ClearIsDirty() : void
		{
			this._bIsDirty = false;
		}


		public function onAcquiredByNativeCode() : *
		{
			this._bAcquiredByNativeCode = true;
		}


		// Properties

		public function get bIsDirty() : Boolean
		{
			return this._bIsDirty;
		}


		public function get iPlatform() : Number
		{
			return this._iPlatform;
		}


		public function get bPS3Switch() : Boolean
		{
			return this._bPS3Switch;
		}


		public function get bAcquiredByNativeCode() : Boolean
		{
			return this._bAcquiredByNativeCode;
		}


		public function get bShowBrackets() : Boolean
		{
			return this._bShowBrackets;
		}


		public function set bShowBrackets(aValue:Boolean) : *
		{
			if(this.bShowBrackets != aValue)
			{
				this._bShowBrackets = aValue;
				this.SetIsDirty();
			}
		}


		public function get bracketLineWidth() : Number
		{
			return this._bracketLineWidth;
		}


		public function set bracketLineWidth(aValue:Number) : void
		{
			if(this._bracketLineWidth != aValue)
			{
				this._bracketLineWidth = aValue;
				this.SetIsDirty();
			}
		}


		public function get bracketCornerLength() : Number
		{
			return this._bracketCornerLength;
		}


		public function set bracketCornerLength(aValue:Number) : void
		{
			if(this._bracketCornerLength != aValue)
			{
				this._bracketCornerLength = aValue;
				this.SetIsDirty();
			}
		}


		public function get bracketPaddingX() : Number
		{
			return this._bracketPaddingX;
		}


		public function set bracketPaddingX(aValue:Number) : void
		{
			if(this._bracketPaddingX != aValue)
			{
				this._bracketPaddingX = aValue;
				this.SetIsDirty();
			}
		}


		public function get bracketPaddingY() : Number
		{
			return this._bracketPaddingY;
		}


		public function set bracketPaddingY(aValue:Number) : void
		{
			if(this._bracketPaddingY != aValue)
			{
				this._bracketPaddingY = aValue;
				this.SetIsDirty();
			}
		}


		public function get BracketStyle() : String
		{
			return this._bracketStyle;
		}


		public function set BracketStyle(aValue:String) : *
		{
			if(this._bracketStyle != aValue)
			{
				this._bracketStyle = aValue;
				this.SetIsDirty();
			}
		}


		public function get bUseShadedBackground() : Boolean
		{
			return this._bUseShadedBackground;
		}


		public function set bUseShadedBackground(aValue:Boolean) : *
		{
			if(this._bUseShadedBackground != aValue)
			{
				this._bUseShadedBackground = aValue;
				this.SetIsDirty();
			}
		}


		public function get ShadedBackgroundType() : String
		{
			return this._shadedBackgroundType;
		}


		public function set ShadedBackgroundType(aValue:String) : *
		{
			if(this._shadedBackgroundType != aValue)
			{
				this._shadedBackgroundType = aValue;
				this.SetIsDirty();
			}
		}


		public function get ShadedBackgroundMethod() : String
		{
			return this._shadedBackgroundMethod;
		}


		public function set ShadedBackgroundMethod(aValue:String) : *
		{
			if(this._shadedBackgroundMethod != aValue)
			{
				this._shadedBackgroundMethod = aValue;
				this.SetIsDirty();
			}
		}



	}
}
