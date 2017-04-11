package Shared
{
	import flash.display.InteractiveObject;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.FocusEvent;
	
	public class IMenu extends MovieClip
	{
		 
		
		private var _uiPlatform:uint;
		
		private var _bPS3Switch:Boolean;
		
		private var _bRestoreLostFocus:Boolean;
		
		private var safeX:Number = 0.0;
		
		private var safeY:Number = 0.0;
		
		public function IMenu()
		{
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
	}
}
