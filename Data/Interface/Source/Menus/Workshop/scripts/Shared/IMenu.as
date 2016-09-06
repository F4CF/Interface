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
			addEventListener(Event.ADDED_TO_STAGE,this.onStageInit);
			addEventListener(Event.REMOVED_FROM_STAGE,this.onStageDestruct);
			addEventListener(PlatformRequestEvent.PLATFORM_REQUEST,this.onPlatformRequestEvent,true);
		}
		
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
		
		protected function onPlatformRequestEvent(param1:Event) : *
		{
			if(this.uiPlatform != PlatformChangeEvent.PLATFORM_INVALID)
			{
				(param1 as PlatformRequestEvent).RespondToRequest(this.uiPlatform,this.bPS3Switch);
			}
		}
		
		protected function onStageInit(param1:Event) : *
		{
			stage.stageFocusRect = false;
			stage.addEventListener(FocusEvent.FOCUS_OUT,this.onFocusLost);
			stage.addEventListener(FocusEvent.MOUSE_FOCUS_CHANGE,this.onMouseFocus);
		}
		
		protected function onStageDestruct(param1:Event) : *
		{
			stage.removeEventListener(FocusEvent.FOCUS_OUT,this.onFocusLost);
			stage.removeEventListener(FocusEvent.MOUSE_FOCUS_CHANGE,this.onMouseFocus);
		}
		
		public function SetPlatform(param1:uint, param2:Boolean) : *
		{
			this._uiPlatform = param1;
			this._bPS3Switch = this.bPS3Switch;
			dispatchEvent(new PlatformChangeEvent(this.uiPlatform,this.bPS3Switch));
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
		
		private function onFocusLost(param1:FocusEvent) : *
		{
			if(this._bRestoreLostFocus)
			{
				this._bRestoreLostFocus = false;
				stage.focus = param1.target as InteractiveObject;
			}
		}
		
		protected function onMouseFocus(param1:FocusEvent) : *
		{
			if(param1.target == null || !(param1.target is InteractiveObject))
			{
				stage.focus = null;
			}
			else
			{
				this._bRestoreLostFocus = true;
			}
		}
		
		public function ShrinkFontToFit(param1:TextField, param2:int) : *
		{
			var _loc5_:int = 0;
			var _loc3_:TextFormat = param1.getTextFormat();
			if(this.textFieldSizeMap[param1] == null)
			{
				this.textFieldSizeMap[param1] = _loc3_.size;
			}
			_loc3_.size = this.textFieldSizeMap[param1];
			param1.setTextFormat(_loc3_);
			var _loc4_:int = param1.maxScrollV;
			while(_loc4_ > param2 && _loc3_.size > 4)
			{
				_loc5_ = _loc3_.size as int;
				_loc3_.size = _loc5_ - 1;
				param1.setTextFormat(_loc3_);
				_loc4_ = param1.maxScrollV;
			}
		}
	}
}
