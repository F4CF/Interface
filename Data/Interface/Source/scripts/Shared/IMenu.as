package Shared
{
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.FocusEvent;
	import flash.display.InteractiveObject;
	import flash.text.TextField;
	import flash.text.TextFormat;

	public class IMenu extends MovieClip
	{

		private var _uiPlatform:uint;
		private var _bPS3Switch:Boolean;
		private var _bRestoreLostFocus:Boolean;

		private var safeX:Number = 0.0;
		private var safeY:Number = 0.0;

		private var textFieldSizeMap:Object;


		public function IMenu()
		{
			this.textFieldSizeMap = new Object();
			super();
			this._uiPlatform = PlatformChangeEvent.PLATFORM_INVALID;
			this._bPS3Switch = false;
			this._bRestoreLostFocus = false;
			GlobalFunc.MaintainTextFormat();
			addEventListener(Event.ADDED_TO_STAGE, this.onStageInit);
			addEventListener(Event.REMOVED_FROM_STAGE, this.onStageDestruct);
			addEventListener(PlatformRequestEvent.PLATFORM_REQUEST, this.onPlatformRequestEvent, true);
		}


		protected function onPlatformRequestEvent(e:Event) : *
		{
			if(this.uiPlatform != PlatformChangeEvent.PLATFORM_INVALID)
			{
				(e as PlatformRequestEvent).RespondToRequest(this.uiPlatform, this.bPS3Switch);
			}
		}


		protected function onStageInit(e:Event) : *
		{
			stage.stageFocusRect = false;
			stage.addEventListener(FocusEvent.FOCUS_OUT, this.onFocusLost);
			stage.addEventListener(FocusEvent.MOUSE_FOCUS_CHANGE, this.onMouseFocus);
		}


		protected function onStageDestruct(e:Event) : *
		{
			stage.removeEventListener(FocusEvent.FOCUS_OUT, this.onFocusLost);
			stage.removeEventListener(FocusEvent.MOUSE_FOCUS_CHANGE, this.onMouseFocus);
		}


		public function SetPlatform(param1:uint, param2:Boolean) : *
		{
			this._uiPlatform = param1;
			this._bPS3Switch = this.bPS3Switch;
			dispatchEvent(new PlatformChangeEvent(this.uiPlatform, this.bPS3Switch));
		}


		public function SetSafeRect(param1:Number, param2:Number) : *
		{
			this.safeX = param1;
			this.safeY = param2;
			this.onSetSafeRect();
		}


		protected function onSetSafeRect() : void
		{
		}


		private function onFocusLost(e:FocusEvent) : *
		{
			if(this._bRestoreLostFocus)
			{
				this._bRestoreLostFocus = false;
				stage.focus = e.target as InteractiveObject;
			}
		}


		protected function onMouseFocus(e:FocusEvent) : *
		{
			if(e.target == null || !(e.target is InteractiveObject))
			{
				stage.focus = null;
			}
			else
			{
				this._bRestoreLostFocus = true;
			}
		}


		public function ShrinkFontToFit(aTextField:TextField, param2:int) : *
		{
			var _size:int = 0;
			var _tf:TextFormat = aTextField.getTextFormat();
			if(this.textFieldSizeMap[aTextField] == null)
			{
				this.textFieldSizeMap[aTextField] = _tf.size;
			}
			_tf.size = this.textFieldSizeMap[aTextField];
			aTextField.setTextFormat(_tf);
			var _maxScroll:int = aTextField.maxScrollV;
			while(_maxScroll > param2 && _tf.size > 4)
			{
				_size = _tf.size as int;
				_tf.size = _size - 1;
				aTextField.setTextFormat(_tf);
				_maxScroll = aTextField.maxScrollV;
			}
		}


		// Properties

		public function get uiPlatform() : uint
		{
			return this._uiPlatform;
		}

		public function get bPS3Switch() : Boolean
		{
			return this._bPS3Switch;
		}

		public function get SafeX() : Number
		{
			return this.safeX;
		}

		public function get SafeY() : Number
		{
			return this.safeY;
		}



	}
}
