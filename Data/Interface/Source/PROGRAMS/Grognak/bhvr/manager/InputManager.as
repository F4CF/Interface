package bhvr.manager
{
	import flash.events.EventDispatcher;
	import flash.display.Stage;
	import flash.events.KeyboardEvent;
	import bhvr.events.EventWithParams;
	import bhvr.constants.GameInputs;
	import flash.ui.Keyboard;
	import bhvr.debug.Log;
	import Shared.AS3.COMPANIONAPP.CompanionAppMode;
	
	public class InputManager extends EventDispatcher
	{
		
		public static const MOVE_LEFT_CODE:int = -1;
		
		public static const MOVE_RIGHT_CODE:int = -2;
		
		public static const MOVE_UP_CODE:int = -3;
		
		public static const MOVE_DOWN_CODE:int = -4;
		
		private static var _instance:bhvr.manager.InputManager;
		 
		
		private var _standaloneMode:Boolean;
		
		private var _stage:Stage;
		
		private var _gamePaused:Boolean = false;
		
		public function InputManager(mainStage:Stage)
		{
			super();
			this._standaloneMode = !CompanionAppMode.isOn;
			this._stage = mainStage;
			_instance = this;
			if(this._standaloneMode)
			{
				this.addKeyboardListeners();
			}
		}
		
		public static function get instance() : bhvr.manager.InputManager
		{
			return _instance;
		}
		
		private function addKeyboardListeners() : void
		{
			if(this._stage)
			{
				this._stage.addEventListener(KeyboardEvent.KEY_DOWN,this.onKeyDown,false,int.MAX_VALUE,true);
				this._stage.addEventListener(KeyboardEvent.KEY_UP,this.onKeyUp,false,int.MAX_VALUE,true);
			}
		}
		
		private function removeKeyboardListeners() : void
		{
			if(this._stage)
			{
				this._stage.removeEventListener(KeyboardEvent.KEY_DOWN,this.onKeyDown);
				this._stage.removeEventListener(KeyboardEvent.KEY_UP,this.onKeyUp);
			}
		}
		
		private function onKeyDown(e:KeyboardEvent) : void
		{
			var keyCode:uint = 0;
			if(!this._gamePaused)
			{
				keyCode = e.keyCode;
				switch(keyCode)
				{
					case Keyboard.LEFT:
					case Keyboard.A:
						dispatchEvent(new EventWithParams(GameInputs.MOVE_LEFT));
						break;
					case Keyboard.RIGHT:
					case Keyboard.D:
						dispatchEvent(new EventWithParams(GameInputs.MOVE_RIGHT));
						break;
					case Keyboard.UP:
					case Keyboard.W:
						dispatchEvent(new EventWithParams(GameInputs.MOVE_UP));
						break;
					case Keyboard.DOWN:
					case Keyboard.S:
						dispatchEvent(new EventWithParams(GameInputs.MOVE_DOWN));
				}
				Log.info("onKeyDown: keyCode=" + keyCode);
			}
		}
		
		private function onKeyUp(e:KeyboardEvent) : void
		{
			var keyCode:uint = e.keyCode;
			switch(keyCode)
			{
				case Keyboard.LEFT:
				case Keyboard.A:
				case Keyboard.RIGHT:
				case Keyboard.D:
				case Keyboard.UP:
				case Keyboard.W:
				case Keyboard.DOWN:
				case Keyboard.S:
					if(!this._gamePaused)
					{
						dispatchEvent(new EventWithParams(GameInputs.STOP_MOVE,{"keyCode":keyCode}));
					}
					break;
				case Keyboard.SPACE:
				case Keyboard.ENTER:
					if(this._standaloneMode && !this._gamePaused)
					{
						dispatchEvent(new EventWithParams(GameInputs.ACCEPT));
					}
					break;
				case Keyboard.ESCAPE:
					if(this._standaloneMode)
					{
						dispatchEvent(new EventWithParams(GameInputs.PAUSE));
					}
			}
			Log.info("onKeyUp: keyCode=" + keyCode);
		}
		
		public function dispose() : void
		{
			_instance = null;
			if(this._standaloneMode)
			{
				this.removeKeyboardListeners();
			}
		}
		
		public function SetPlatform(auiPlatform:uint, abPSNButtonSwap:Boolean) : void
		{
			this._standaloneMode = false;
		}
		
		public function ProcessUserEvent(strEventName:String, abPressed:Boolean) : Boolean
		{
			var bhandled:Boolean = false;
			if(!this._gamePaused)
			{
				switch(strEventName)
				{
					case "Accept":
					case "Jump":
						if(abPressed)
						{
							dispatchEvent(new EventWithParams(GameInputs.ACCEPT));
						}
						bhandled = true;
						break;
					case "Left":
						if(abPressed)
						{
							dispatchEvent(new EventWithParams(GameInputs.MOVE_LEFT));
						}
						else
						{
							dispatchEvent(new EventWithParams(GameInputs.STOP_MOVE,{"keyCode":InputManager.MOVE_LEFT_CODE}));
						}
						bhandled = true;
						break;
					case "Right":
						if(abPressed)
						{
							dispatchEvent(new EventWithParams(GameInputs.MOVE_RIGHT));
						}
						else
						{
							dispatchEvent(new EventWithParams(GameInputs.STOP_MOVE,{"keyCode":InputManager.MOVE_RIGHT_CODE}));
						}
						bhandled = true;
						break;
					case "Up":
						if(abPressed)
						{
							dispatchEvent(new EventWithParams(GameInputs.MOVE_UP));
						}
						else
						{
							dispatchEvent(new EventWithParams(GameInputs.STOP_MOVE,{"keyCode":InputManager.MOVE_UP_CODE}));
						}
						bhandled = true;
						break;
					case "Down":
						if(abPressed)
						{
							dispatchEvent(new EventWithParams(GameInputs.MOVE_DOWN));
						}
						else
						{
							dispatchEvent(new EventWithParams(GameInputs.STOP_MOVE,{"keyCode":InputManager.MOVE_DOWN_CODE}));
						}
						bhandled = true;
				}
			}
			return bhandled;
		}
		
		public function Pause(paused:Boolean) : void
		{
			this._gamePaused = paused;
		}
	}
}
