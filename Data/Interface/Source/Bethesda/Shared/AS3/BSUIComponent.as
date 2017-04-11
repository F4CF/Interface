package Shared.AS3
{
	import Shared.PlatformChangeEvent;
	import Shared.PlatformRequestEvent;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	public dynamic class BSUIComponent extends MovieClip
	{
		 
		
		private var _bIsDirty:Boolean;
		
		private var _iPlatform:Number;
		
		private var _bPS3Switch:Boolean;
		
		private var _bAcquiredByNativeCode:Boolean;
		
		private var _bShowBrackets:Boolean = false;
		
		private var _bUseShadedBackground:Boolean = false;
		
		private var _shadedBackgroundType:String = "normal";
		
		private var _shadedBackgroundMethod:String = "Shader";
		
		private var _bracketPair:BSBracketClip;
		
		private var _bracketLineWidth:Number = 1.5;
		
		private var _bracketCornerLength:Number = 6;
		
		private var _bracketPaddingX:Number = 0;
		
		private var _bracketPaddingY:Number = 0;
		
		private var _bracketStyle:String = "horizontal";
		
		public function BSUIComponent()
		{
			super();
			this._bIsDirty = false;
			this._iPlatform = PlatformChangeEvent.PLATFORM_INVALID;
			this._bPS3Switch = false;
			this._bAcquiredByNativeCode = false;
			this._bracketPair = new BSBracketClip();
			addEventListener(Event.ADDED_TO_STAGE,this.onAddedToStageEvent);
		}
		
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
		
		public function set bShowBrackets(param1:Boolean) : *
		{
			if(this.bShowBrackets != param1)
			{
				this._bShowBrackets = param1;
				this.SetIsDirty();
			}
		}
		
		public function get bracketLineWidth() : Number
		{
			return this._bracketLineWidth;
		}
		
		public function set bracketLineWidth(param1:Number) : void
		{
			if(this._bracketLineWidth != param1)
			{
				this._bracketLineWidth = param1;
				this.SetIsDirty();
			}
		}
		
		public function get bracketCornerLength() : Number
		{
			return this._bracketCornerLength;
		}
		
		public function set bracketCornerLength(param1:Number) : void
		{
			if(this._bracketCornerLength != param1)
			{
				this._bracketCornerLength = param1;
				this.SetIsDirty();
			}
		}
		
		public function get bracketPaddingX() : Number
		{
			return this._bracketPaddingX;
		}
		
		public function set bracketPaddingX(param1:Number) : void
		{
			if(this._bracketPaddingX != param1)
			{
				this._bracketPaddingX = param1;
				this.SetIsDirty();
			}
		}
		
		public function get bracketPaddingY() : Number
		{
			return this._bracketPaddingY;
		}
		
		public function set bracketPaddingY(param1:Number) : void
		{
			if(this._bracketPaddingY != param1)
			{
				this._bracketPaddingY = param1;
				this.SetIsDirty();
			}
		}
		
		public function get BracketStyle() : String
		{
			return this._bracketStyle;
		}
		
		public function set BracketStyle(param1:String) : *
		{
			if(this._bracketStyle != param1)
			{
				this._bracketStyle = param1;
				this.SetIsDirty();
			}
		}
		
		public function get bUseShadedBackground() : Boolean
		{
			return this._bUseShadedBackground;
		}
		
		public function set bUseShadedBackground(param1:Boolean) : *
		{
			if(this._bUseShadedBackground != param1)
			{
				this._bUseShadedBackground = param1;
				this.SetIsDirty();
			}
		}
		
		public function get ShadedBackgroundType() : String
		{
			return this._shadedBackgroundType;
		}
		
		public function set ShadedBackgroundType(param1:String) : *
		{
			if(this._shadedBackgroundType != param1)
			{
				this._shadedBackgroundType = param1;
				this.SetIsDirty();
			}
		}
		
		public function get ShadedBackgroundMethod() : String
		{
			return this._shadedBackgroundMethod;
		}
		
		public function set ShadedBackgroundMethod(param1:String) : *
		{
			if(this._shadedBackgroundMethod != param1)
			{
				this._shadedBackgroundMethod = param1;
				this.SetIsDirty();
			}
		}
		
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
		
		private final function onEnterFrameEvent(param1:Event) : void
		{
			removeEventListener(Event.ENTER_FRAME,this.onEnterFrameEvent,false);
			if(this.bIsDirty)
			{
				this.requestRedraw();
			}
		}
		
		private final function onAddedToStageEvent(param1:Event) : void
		{
			removeEventListener(Event.ADDED_TO_STAGE,this.onAddedToStageEvent);
			this.onAddedToStage();
			addEventListener(Event.REMOVED_FROM_STAGE,this.onRemovedFromStageEvent);
		}
		
		private function requestRedraw() : void
		{
			if(stage)
			{
				stage.addEventListener(Event.RENDER,this.onRenderEvent);
				addEventListener(Event.ENTER_FRAME,this.onEnterFrameEvent,false,0,true);
				stage.invalidate();
			}
		}
		
		private final function onRemovedFromStageEvent(param1:Event) : void
		{
			removeEventListener(Event.REMOVED_FROM_STAGE,this.onRemovedFromStageEvent);
			this.onRemovedFromStage();
			addEventListener(Event.ADDED_TO_STAGE,this.onAddedToStageEvent);
		}
		
		private final function onRenderEvent(param1:Event) : void
		{
			var bBracketsDrawn:* = undefined;
			var preDrawBounds:Rectangle = null;
			var postDrawBounds:Rectangle = null;
			var arEvent:Event = param1;
			removeEventListener(Event.ENTER_FRAME,this.onEnterFrameEvent,false);
			if(stage)
			{
				stage.removeEventListener(Event.RENDER,this.onRenderEvent);
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
				catch(e:Error)
				{
					trace(this + " " + this.name + ": " + e.getStackTrace());
				}
			}
			if(this.bIsDirty)
			{
				addEventListener(Event.ENTER_FRAME,this.onEnterFrameEvent,false,0,true);
			}
		}
		
		private final function onSetPlatformEvent(param1:Event) : *
		{
			var _loc2_:PlatformChangeEvent = param1 as PlatformChangeEvent;
			this.SetPlatform(_loc2_.uiPlatform,_loc2_.bPS3Switch);
		}
		
		public function UpdateBrackets(param1:Boolean) : *
		{
			if(this._bShowBrackets && width > this.bracketCornerLength && height > this._bracketCornerLength)
			{
				if(param1)
				{
					this._bracketPair.redrawUIComponent(this,this.bracketLineWidth,this.bracketCornerLength,new Point(this._bracketPaddingX,this.bracketPaddingY),this.BracketStyle);
				}
				addChild(this._bracketPair);
			}
			else
			{
				this._bracketPair.ClearBrackets();
			}
		}
		
		public function onAddedToStage() : void
		{
			dispatchEvent(new PlatformRequestEvent(this));
			if(stage)
			{
				stage.addEventListener(PlatformChangeEvent.PLATFORM_CHANGE,this.onSetPlatformEvent);
			}
			if(this.bIsDirty)
			{
				this.requestRedraw();
			}
		}
		
		public function onRemovedFromStage() : void
		{
			if(stage)
			{
				stage.removeEventListener(PlatformChangeEvent.PLATFORM_CHANGE,this.onSetPlatformEvent);
				stage.removeEventListener(Event.RENDER,this.onRenderEvent);
			}
		}
		
		public function redrawUIComponent() : void
		{
		}
		
		public function SetPlatform(param1:Number, param2:Boolean) : void
		{
			if(this._iPlatform != param1 || this._bPS3Switch != param2)
			{
				this._iPlatform = param1;
				this._bPS3Switch = param2;
				this.SetIsDirty();
			}
		}
	}
}
