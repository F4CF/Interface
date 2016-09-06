package bhvr.manager
{
	import flash.events.EventDispatcher;
	import flash.display.Stage;
	import flash.events.KeyboardEvent;
	import bhvr.debug.Log;
	import flash.ui.Keyboard;
	import bhvr.events.EventWithParams;
	import bhvr.constatnts.GameInputs;
	import Shared.PlatformChangeEvent;
	import bhvr.constatnts.GameConstants;
	import Shared.AS3.COMPANIONAPP.CompanionAppMode;
	
	public class InputManager extends EventDispatcher
	{
		
		private static var _instance:bhvr.manager.InputManager;
		 
		
		private var _standaloneMode:Boolean;
		
		private var _leftStickSpeed:Number;
		
		private var _stage:Stage;
		
		private var _gamePaused:Boolean = false;
		
		private var _currentPlatform:uint;
		
		public function InputManager(mainStage:Stage)
		{
			this._currentPlatform = PlatformChangeEvent.PLATFORM_INVALID;
			super();
			this._standaloneMode = !CompanionAppMode.isOn;
			this._stage = mainStage;
			_instance = this;
			this._leftStickSpeed = GameConstants.leftStickSpeedPC;
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
		
		private function addKeyboardListeners() : void
		{
			if(this._stage)
			{
				this._stage.addEventListener(KeyboardEvent.KEY_DOWN,this.onKeyDown,false,0,true);
				this._stage.addEventListener(KeyboardEvent.KEY_UP,this.onKeyUp,false,0,true);
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
				Log.info("onKeyDown: keyCode=" + keyCode);
				switch(keyCode)
				{
					case Keyboard.RIGHT:
						this.OnLeftStickInput(1,0,1);
						break;
					case Keyboard.LEFT:
						this.OnLeftStickInput(-1,0,1);
						break;
					case Keyboard.UP:
						this.OnLeftStickInput(0,-1,1);
						break;
					case Keyboard.DOWN:
						this.OnLeftStickInput(0,1,1);
				}
			}
		}
		
		private function onKeyUp(e:KeyboardEvent) : void
		{
			var keyCode:uint = e.keyCode;
			switch(keyCode)
			{
				case Keyboard.ENTER:
					if(!this._gamePaused)
					{
						dispatchEvent(new EventWithParams(GameInputs.FIRE));
						dispatchEvent(new EventWithParams(GameInputs.ACCEPT));
					}
					break;
				case Keyboard.ESCAPE:
					dispatchEvent(new EventWithParams(GameInputs.PAUSE));
			}
			Log.info("onKeyUp: keyCode=" + keyCode);
		}
		
		public function setLeftStickSpeed() : void
		{
			if(this._currentPlatform == PlatformChangeEvent.PLATFORM_XB1)
			{
				this._leftStickSpeed = GameConstants.leftStickSpeedXbox;
			}
			else if(this._currentPlatform == PlatformChangeEvent.PLATFORM_PS4)
			{
				this._leftStickSpeed = GameConstants.leftStickSpeedPS4;
			}
			else
			{
				this._leftStickSpeed = GameConstants.leftStickSpeedPC;
			}
		}
		
		public function dispose() : void
		{
			_instance = null;
			if(this._standaloneMode && !this._gamePaused)
			{
				this.removeKeyboardListeners();
			}
		}
		
		public function SetPlatform(auiPlatform:uint, abPSNButtonSwap:Boolean) : void
		{
			this._currentPlatform = auiPlatform;
			if(this._standaloneMode && !this._gamePaused)
			{
				this.removeKeyboardListeners();
			}
			this._standaloneMode = false;
		}
		
		public function ProcessUserEvent(strEventName:String, abPressed:Boolean) : Boolean
		{
			var bhandled:Boolean = false;
			if(!this._gamePaused)
			{
				if((strEventName == "Accept" || strEventName == "PrimaryAttack") && !abPressed)
				{
					dispatchEvent(new EventWithParams(GameInputs.FIRE));
					dispatchEvent(new EventWithParams(GameInputs.ACCEPT));
					bhandled = true;
				}
			}
			return bhandled;
		}
		
		public function OnLeftStickInput(afXDelta:Number, afYDelta:Number, afDeltaTime:Number) : void
		{
			var time:Number = NaN;
			if(!this._gamePaused)
			{
				time = afDeltaTime * 1000;
				dispatchEvent(new EventWithParams(GameInputs.LEFT_STICK_POS_UPDATE,{
					"deltaX":afXDelta * time * this._leftStickSpeed,
					"deltaY":afYDelta * time * this._leftStickSpeed
				}));
			}
		}
		
		public function Pause(paused:Boolean) : void
		{
			this._gamePaused = paused;
		}
	}
}
