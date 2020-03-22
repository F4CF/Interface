package
{
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import flash.ui.Keyboard;

	public class Option_Scrollbar extends MovieClip
	{

		public static const VALUE_CHANGE:String = "Option_Scrollbar::VALUE_CHANGE";


		public var Track_mc:MovieClip;

		public var Thumb_mc:MovieClip;

		public var LeftArrow_mc:MovieClip;

		public var RightArrow_mc:MovieClip;

		public var LeftCatcher_mc:MovieClip;

		public var RightCatcher_mc:MovieClip;

		public var BarCatcher_mc:MovieClip;

		private var fValue:Number;

		protected var fMinThumbX:Number;

		protected var fMaxThumbX:Number;

		private var fMinValue:Number = 0.0;

		private var fMaxValue:Number = 1.0;

		private var fStepSize:Number = 0.05;

		private var iStartDragThumb:int;

		private var fStartValue:Number;

		public function Option_Scrollbar()
		{
			super();
			this.fMinThumbX = this.Track_mc.x;
			this.fMaxThumbX = this.Track_mc.x + this.Track_mc.width - this.Thumb_mc.width;
			addEventListener(MouseEvent.CLICK,this.onClick);
			this.Thumb_mc.addEventListener(MouseEvent.MOUSE_DOWN,this.onThumbMouseDown);
		}

		public function get MinValue() : Number
		{
			return this.fMinValue;
		}

		public function set MinValue(afMinValue:Number) : *
		{
			this.fMinValue = afMinValue;
		}

		public function get MaxValue() : Number
		{
			return this.fMaxValue;
		}

		public function set MaxValue(afMaxValue:Number) : *
		{
			this.fMaxValue = afMaxValue;
		}

		public function get StepSize() : Number
		{
			return this.fStepSize;
		}

		public function set StepSize(afStepSize:Number) : *
		{
			this.fStepSize = afStepSize;
		}

		public function get value() : Number
		{
			return this.fValue;
		}

		public function set value(afValue:Number) : *
		{
			this.fValue = Math.min(Math.max(afValue,this.fMinValue),this.fMaxValue);
			var finterp:* = (this.fValue - this.fMinValue) / (this.fMaxValue - this.fMinValue);
			this.Thumb_mc.x = this.fMinThumbX + finterp * (this.fMaxThumbX - this.fMinThumbX);
		}

		public function Decrement() : *
		{
			this.value = this.value - this.fStepSize;
			dispatchEvent(new Event(VALUE_CHANGE,true,true));
		}

		public function Increment() : *
		{
			this.value = this.value + this.fStepSize;
			dispatchEvent(new Event(VALUE_CHANGE,true,true));
		}

		public function HandleKeyboardInput(event:KeyboardEvent) : *
		{
			if(event.keyCode == Keyboard.LEFT && this.value > 0)
			{
				this.Decrement();
			}
			else if(event.keyCode == Keyboard.RIGHT && this.value < 1)
			{
				this.Increment();
			}
		}

		public function onClick(event:MouseEvent) : *
		{
			if(event.target == this.LeftCatcher_mc)
			{
				this.Decrement();
			}
			else if(event.target == this.RightCatcher_mc)
			{
				this.Increment();
			}
			else if(event.target == this.BarCatcher_mc)
			{
				this.value = event.currentTarget.mouseX / this.BarCatcher_mc.width * (this.fMaxValue - this.fMinValue);
				dispatchEvent(new Event(VALUE_CHANGE,true,true));
			}
		}

		private function onThumbMouseDown(event:MouseEvent) : *
		{
			this.Thumb_mc.startDrag(false,new Rectangle(0,this.Thumb_mc.y,this.fMaxThumbX - this.fMinThumbX,0));
			stage.addEventListener(MouseEvent.MOUSE_UP,this.onThumbMouseUp);
			stage.addEventListener(MouseEvent.MOUSE_MOVE,this.onThumbMouseMove);
		}

		private function onThumbMouseMove(events:MouseEvent) : *
		{
			var offset:* = this.Thumb_mc.x - this.fMinThumbX;
			this.value = offset / (this.fMaxThumbX - this.fMinThumbX) * (this.fMaxValue - this.fMinValue);
			dispatchEvent(new Event(VALUE_CHANGE,true,true));
		}

		private function onThumbMouseUp(event:MouseEvent) : *
		{
			this.Thumb_mc.stopDrag();
			stage.removeEventListener(MouseEvent.MOUSE_UP,this.onThumbMouseUp);
			stage.removeEventListener(MouseEvent.MOUSE_MOVE,this.onThumbMouseMove);
		}


	}
}
