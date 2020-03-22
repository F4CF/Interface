package Shared.AS3
{
	import Shared.CustomEvent;
	import flash.display.MovieClip;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import flash.ui.Keyboard;
	
	public class BSSlider extends BSUIComponent
	{
		
		public static const VALUE_CHANGED:String = "Slider::ValueChanged";
		 
		
		public var SliderBackground_mc:MovieClip;
		
		public var Marker_mc:MovieClip;
		
		public var Fill_mc:MovieClip;
		
		public var LeftArrow_mc:MovieClip;
		
		public var RightArrow_mc:MovieClip;
		
		private var _iMaxValue:uint;
		
		private var _iValue:uint;
		
		private var _iMinValue:uint;
		
		private var _fValueFillIncrement:Number;
		
		private var _fFillLength:Number;
		
		private var LEFT_X:Number;
		
		private var RIGHT_X:Number;
		
		private var _SliderMarkerBoundBox:Rectangle;
		
		private var _bIsDragging:Boolean;
		
		private var _iControllerBumperJumpSize;
		
		private var _iControllerTriggerJumpSize;
		
		public function BSSlider()
		{
			super();
			this._bIsDragging = false;
			this._iMinValue = 0;
			this._iMaxValue = 1;
			this.value = this._iMinValue;
			this._iControllerBumperJumpSize = 1;
			this._iControllerTriggerJumpSize = 3;
			this.LEFT_X = this.Fill_mc.x + 2;
			this.RIGHT_X = this.Marker_mc.x;
			this._fFillLength = this.RIGHT_X - this.LEFT_X;
			this.Marker_mc.addEventListener(MouseEvent.MOUSE_DOWN,this.onBeginDrag);
			this.Marker_mc.buttonMode = true;
			this._SliderMarkerBoundBox = new Rectangle(this.Fill_mc.x,this.Marker_mc.y,this.width,0);
		}
		
		public function get sliderWidth() : Number
		{
			return this._fFillLength;
		}
		
		public function get minValue() : uint
		{
			return this._iMinValue;
		}
		
		public function set minValue(param1:uint) : *
		{
			this._iMinValue = Math.min(param1,this._iMaxValue);
			if(this._iValue < this._iMinValue)
			{
				this.value = this._iMinValue;
			}
			this._fValueFillIncrement = this.sliderWidth / (this._iMaxValue - this._iMinValue);
			SetIsDirty();
		}
		
		public function get value() : uint
		{
			return this._iValue;
		}
		
		public function set value(param1:uint) : *
		{
			this._iValue = Math.min(Math.max(param1,this._iMinValue),this._iMaxValue);
			this.Marker_mc.x = this.markerPosition;
			dispatchEvent(new CustomEvent(VALUE_CHANGED,this.value,true,true));
			SetIsDirty();
		}
		
		public function valueJump(param1:int) : *
		{
			if(param1 < 0 && -param1 > this._iValue)
			{
				this.value = 1;
			}
			else
			{
				this.value = Math.min(Math.max(this._iValue + param1,this._iMinValue),this._iMaxValue);
			}
		}
		
		public function get maxValue() : uint
		{
			return this._iMaxValue;
		}
		
		public function set maxValue(param1:uint) : *
		{
			this._iMaxValue = Math.max(param1,1);
			if(this._iValue > this._iMaxValue)
			{
				this.value = this._iMaxValue;
			}
			this._fValueFillIncrement = this.sliderWidth / (this._iMaxValue - this._iMinValue);
			SetIsDirty();
		}
		
		public function get markerPosition() : Number
		{
			var _loc1_:Number = this._iValue / this._iMaxValue;
			var _loc2_:Number = this.LEFT_X + _loc1_ * this._fFillLength;
			return _loc2_;
		}
		
		public function get controllerBumberJumpSize() : uint
		{
			return this._iControllerBumperJumpSize;
		}
		
		public function set controllerBumberJumpSize(param1:uint) : *
		{
			this._iControllerBumperJumpSize = param1;
		}
		
		public function get controllerTriggerJumpSize() : uint
		{
			return this._iControllerTriggerJumpSize;
		}
		
		public function set controllerTriggerJumpSize(param1:uint) : *
		{
			this._iControllerTriggerJumpSize = param1;
		}
		
		private function onBeginDrag(param1:MouseEvent) : *
		{
			this.Marker_mc.startDrag(false,this._SliderMarkerBoundBox);
			this._bIsDragging = true;
			if(parent != null)
			{
				parent.addEventListener(MouseEvent.MOUSE_UP,this.onReleaseDrag);
			}
			if(parent != null)
			{
				parent.addEventListener(MouseEvent.MOUSE_MOVE,this.onValueDrag);
			}
		}
		
		private function onReleaseDrag(param1:MouseEvent) : *
		{
			if(this._bIsDragging)
			{
				this.Marker_mc.stopDrag();
				if(parent != null)
				{
					parent.removeEventListener(MouseEvent.MOUSE_UP,this.onReleaseDrag);
				}
				if(parent != null)
				{
					parent.removeEventListener(MouseEvent.MOUSE_MOVE,this.onValueDrag);
				}
				this.onValueDrag(null);
				this._bIsDragging = false;
			}
		}
		
		private function onValueDrag(param1:MouseEvent) : *
		{
			var _loc2_:uint = 0;
			if(this._bIsDragging)
			{
				_loc2_ = this.Marker_mc.x / this._fFillLength * (this._iMaxValue - this._iMinValue);
				this.value = _loc2_;
			}
		}
		
		private function onKeyDownHandler(param1:KeyboardEvent) : *
		{
			if(param1.keyCode == Keyboard.LEFT)
			{
				this.valueJump(-1);
				param1.stopPropagation();
			}
			else if(param1.keyCode == Keyboard.RIGHT)
			{
				this.valueJump(1);
				param1.stopPropagation();
			}
		}
		
		private function onMouseWheelHandler(param1:MouseEvent) : *
		{
			if(param1.delta < 0)
			{
				this.valueJump(-1);
			}
			else if(param1.delta > 0)
			{
				this.valueJump(1);
			}
			param1.stopPropagation();
		}
		
		public function onArrowClickHandler(param1:MouseEvent) : *
		{
			var _loc2_:MovieClip = param1.target as MovieClip;
			if(param1.target == this.LeftArrow_mc)
			{
				this.valueJump(-this._iControllerBumperJumpSize);
			}
			else if(param1.target == this.RightArrow_mc)
			{
				this.valueJump(this._iControllerBumperJumpSize);
			}
		}
		
		public function onSliderBarMouseClickHandler(param1:MouseEvent) : *
		{
			var _loc2_:uint = param1.currentTarget.mouseX / this._fFillLength * (this._iMaxValue - this._iMinValue);
			this.value = _loc2_;
		}
		
		public function ProcessUserEvent(param1:String, param2:Boolean) : Boolean
		{
			var _loc3_:* = false;
			if(!param2)
			{
				if(param1 == "LShoulder")
				{
					this.valueJump(-this._iControllerBumperJumpSize);
					_loc3_ = true;
				}
				else if(param1 == "RShoulder")
				{
					this.valueJump(this._iControllerBumperJumpSize);
					_loc3_ = true;
				}
				else if(param1 == "LTrigger")
				{
					this.valueJump(-this._iControllerTriggerJumpSize);
					_loc3_ = true;
				}
				else if(param1 == "RTrigger")
				{
					this.valueJump(this._iControllerTriggerJumpSize);
					_loc3_ = true;
				}
			}
			return _loc3_;
		}
		
		override public function onAddedToStage() : void
		{
			super.onAddedToStage();
			if(parent)
			{
				parent.addEventListener(KeyboardEvent.KEY_DOWN,this.onKeyDownHandler);
				parent.addEventListener(MouseEvent.MOUSE_WHEEL,this.onMouseWheelHandler);
				this.LeftArrow_mc.addEventListener(MouseEvent.CLICK,this.onArrowClickHandler);
				this.RightArrow_mc.addEventListener(MouseEvent.CLICK,this.onArrowClickHandler);
				this.SliderBackground_mc.addEventListener(MouseEvent.CLICK,this.onSliderBarMouseClickHandler);
			}
		}
		
		override public function onRemovedFromStage() : void
		{
			super.onRemovedFromStage();
			if(parent)
			{
				parent.removeEventListener(KeyboardEvent.KEY_DOWN,this.onKeyDownHandler);
				parent.removeEventListener(MouseEvent.MOUSE_WHEEL,this.onMouseWheelHandler);
				this.LeftArrow_mc.removeEventListener(MouseEvent.CLICK,this.onArrowClickHandler);
				this.RightArrow_mc.removeEventListener(MouseEvent.CLICK,this.onArrowClickHandler);
				this.SliderBackground_mc.removeEventListener(MouseEvent.CLICK,this.onSliderBarMouseClickHandler);
			}
		}
		
		override public function redrawUIComponent() : void
		{
			super.redrawUIComponent();
			var _loc1_:Number = this.markerPosition;
			this.Marker_mc.x = _loc1_;
			this.Fill_mc.width = _loc1_ - this.Fill_mc.x;
		}
	}
}
