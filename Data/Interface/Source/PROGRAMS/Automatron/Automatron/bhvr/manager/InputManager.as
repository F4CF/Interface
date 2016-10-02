package bhvr.manager
{
	import flash.events.EventDispatcher;
	import flash.display.Stage;
	import Shared.PlatformChangeEvent;
	import Shared.AS3.COMPANIONAPP.CompanionAppMode;
	import flash.events.KeyboardEvent;
	import bhvr.debug.Log;
	import bhvr.events.EventWithParams;
	import bhvr.constants.GameInputs;
	import bhvr.constants.GameConfig;
	import flash.ui.Keyboard;
	import bhvr.constants.GameConstants;
	
	public class InputManager extends EventDispatcher
	{
		
		public static const MOVE_LEFT_CODE:int = -1;
		
		public static const MOVE_RIGHT_CODE:int = -2;
		
		public static const MOVE_UP_CODE:int = -3;
		
		public static const MOVE_DOWN_CODE:int = -4;
		
		private static var _instance:bhvr.manager.InputManager;
		 
		
		private var _standaloneMode:Boolean;
		
		private var _leftStickSpeed:Number;
		
		private var _rightStickSpeed:Number;
		
		private var _stage:Stage;
		
		private var _gamePaused:Boolean = false;
		
		private var _currentPlatform:uint;
		
		public function InputManager(param1:Stage)
		{
			this._currentPlatform = PlatformChangeEvent.PLATFORM_INVALID;
			super();
			this._standaloneMode = !CompanionAppMode.isOn;
			this._stage = param1;
			_instance = this;
			this._leftStickSpeed = 1;
			this._rightStickSpeed = 1;
			if(this._standaloneMode)
			{
				this.addKeyboardListeners();
			}
		}
		
		public static function get instance() : bhvr.manager.InputManager
		{
			return _instance;
		}
		
		public function get currentPlatform() : uint
		{
			return this._currentPlatform;
		}
		
		public function get isKeyboardMouseVersion() : Boolean
		{
			return this._currentPlatform == PlatformChangeEvent.PLATFORM_PC_KB_MOUSE || this._currentPlatform == PlatformChangeEvent.PLATFORM_INVALID && !CompanionAppMode.isOn;
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
		
		private function onKeyDown(param1:KeyboardEvent) : void
		{
			var _loc2_:uint = 0;
			if(!this._gamePaused)
			{
				_loc2_ = param1.keyCode;
				Log.info("onKeyDown: keyCode=" + _loc2_);
				switch(_loc2_)
				{
					case Keyboard.LEFT:
					case Keyboard.A:
						dispatchEvent(new EventWithParams(GameInputs.MOVE_LEFT,{"keyCode":_loc2_}));
						break;
					case Keyboard.RIGHT:
					case Keyboard.D:
						dispatchEvent(new EventWithParams(GameInputs.MOVE_RIGHT,{"keyCode":_loc2_}));
						break;
					case Keyboard.UP:
					case Keyboard.W:
						dispatchEvent(new EventWithParams(GameInputs.MOVE_UP,{"keyCode":_loc2_}));
						break;
					case Keyboard.DOWN:
					case Keyboard.S:
						dispatchEvent(new EventWithParams(GameInputs.MOVE_DOWN,{"keyCode":_loc2_}));
						break;
					case Keyboard.SPACE:
					case Keyboard.ENTER:
						if(this._standaloneMode)
						{
							dispatchEvent(new EventWithParams(GameConfig.INPUT_MAIN_ACTION_START));
						}
				}
			}
		}
		
		private function onKeyUp(param1:KeyboardEvent) : void
		{
			var _loc2_:uint = param1.keyCode;
			Log.info("onKeyUp: keyCode=" + _loc2_);
			switch(_loc2_)
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
						dispatchEvent(new EventWithParams(GameInputs.STOP_MOVE,{"keyCode":_loc2_}));
					}
					break;
				case Keyboard.SPACE:
				case Keyboard.ENTER:
					if(this._standaloneMode && !this._gamePaused)
					{
						dispatchEvent(new EventWithParams(GameConfig.INPUT_MAIN_ACTION_STOP));
						dispatchEvent(new EventWithParams(GameInputs.ACCEPT));
					}
					break;
				case Keyboard.ESCAPE:
					if(this._standaloneMode)
					{
						dispatchEvent(new EventWithParams(GameInputs.PAUSE));
					}
			}
		}
		
		public function setLeftStickSpeed() : void
		{
			if(this._currentPlatform == PlatformChangeEvent.PLATFORM_XB1)
			{
				this._leftStickSpeed = GameConstants["leftStickSpeedXbox"] != null?Number(GameConstants["leftStickSpeedXbox"]):Number(1);
			}
			else if(this._currentPlatform == PlatformChangeEvent.PLATFORM_PS4)
			{
				this._leftStickSpeed = GameConstants["leftStickSpeedPS4"] != null?Number(GameConstants["leftStickSpeedPS4"]):Number(1);
			}
			else
			{
				this._leftStickSpeed = GameConstants["leftStickSpeedPC"] != null?Number(GameConstants["leftStickSpeedPC"]):Number(1);
			}
		}
		
		public function setRightStickSpeed() : void
		{
			if(this._currentPlatform == PlatformChangeEvent.PLATFORM_XB1)
			{
				this._rightStickSpeed = GameConstants["rightStickSpeedXbox"] != null?Number(GameConstants["rightStickSpeedXbox"]):Number(1);
			}
			else if(this._currentPlatform == PlatformChangeEvent.PLATFORM_PS4)
			{
				this._rightStickSpeed = GameConstants["rightStickSpeedPS4"] != null?Number(GameConstants["rightStickSpeedPS4"]):Number(1);
			}
			else
			{
				this._rightStickSpeed = GameConstants["rightStickSpeedPC"] != null?Number(GameConstants["rightStickSpeedPC"]):Number(1);
			}
		}
		
		public function dispose() : void
		{
			_instance = null;
			if(this._standaloneMode)
			{
				this.removeKeyboardListeners();
			}
		}
		
		public function SetPlatform(param1:uint, param2:Boolean) : void
		{
			this._currentPlatform = param1;
			this._standaloneMode = false;
		}
		
		public function ProcessUserEvent(param1:String, param2:Boolean) : Boolean
		{
			var _loc3_:Boolean = false;
			if(!this._gamePaused)
			{
				switch(param1)
				{
					case "Accept":
					case "Jump":
					case "PrimaryAttack":
						if(param2)
						{
							dispatchEvent(new EventWithParams(GameConfig.INPUT_MAIN_ACTION_START));
							dispatchEvent(new EventWithParams(GameInputs.ACCEPT));
						}
						else
						{
							dispatchEvent(new EventWithParams(GameConfig.INPUT_MAIN_ACTION_STOP));
						}
						_loc3_ = true;
						break;
					case "Left":
						if(param2)
						{
							dispatchEvent(new EventWithParams(GameInputs.MOVE_LEFT,{"keyCode":bhvr.manager.InputManager.MOVE_LEFT_CODE}));
						}
						else
						{
							dispatchEvent(new EventWithParams(GameInputs.STOP_MOVE,{"keyCode":bhvr.manager.InputManager.MOVE_LEFT_CODE}));
						}
						_loc3_ = true;
						break;
					case "Right":
						if(param2)
						{
							dispatchEvent(new EventWithParams(GameInputs.MOVE_RIGHT,{"keyCode":bhvr.manager.InputManager.MOVE_RIGHT_CODE}));
						}
						else
						{
							dispatchEvent(new EventWithParams(GameInputs.STOP_MOVE,{"keyCode":bhvr.manager.InputManager.MOVE_RIGHT_CODE}));
						}
						_loc3_ = true;
						break;
					case "Up":
						if(param2)
						{
							dispatchEvent(new EventWithParams(GameInputs.MOVE_UP,{"keyCode":bhvr.manager.InputManager.MOVE_UP_CODE}));
						}
						else
						{
							dispatchEvent(new EventWithParams(GameInputs.STOP_MOVE,{"keyCode":bhvr.manager.InputManager.MOVE_UP_CODE}));
						}
						_loc3_ = true;
						break;
					case "Down":
						if(param2)
						{
							dispatchEvent(new EventWithParams(GameInputs.MOVE_DOWN,{"keyCode":bhvr.manager.InputManager.MOVE_DOWN_CODE}));
						}
						else
						{
							dispatchEvent(new EventWithParams(GameInputs.STOP_MOVE,{"keyCode":bhvr.manager.InputManager.MOVE_DOWN_CODE}));
						}
						_loc3_ = true;
				}
			}
			return _loc3_;
		}
		
		public function OnLeftStickInput(param1:Number, param2:Number, param3:Number = 0.001) : void
		{
			var _loc4_:Number = NaN;
			if(!this._gamePaused)
			{
				_loc4_ = param3 * 1000;
				dispatchEvent(new EventWithParams(GameInputs.LEFT_STICK_POS_UPDATE,{
					"deltaX":param1 * _loc4_ * this._leftStickSpeed,
					"deltaY":param2 * _loc4_ * this._leftStickSpeed
				}));
			}
		}
		
		public function OnRightStickInput(param1:Number, param2:Number, param3:Number = 0.001) : void
		{
			var _loc4_:Number = NaN;
			if(!this._gamePaused)
			{
				_loc4_ = param3 * 1000;
				dispatchEvent(new EventWithParams(GameInputs.RIGHT_STICK_POS_UPDATE,{
					"deltaX":param1 * _loc4_ * this._rightStickSpeed,
					"deltaY":param2 * _loc4_ * this._rightStickSpeed
				}));
			}
		}
		
		public function Pause(param1:Boolean) : void
		{
			this._gamePaused = param1;
		}
	}
}
