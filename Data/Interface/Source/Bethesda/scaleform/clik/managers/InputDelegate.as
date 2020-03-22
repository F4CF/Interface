package scaleform.clik.managers
{
	import flash.display.Stage;
	import flash.events.EventDispatcher;
	import flash.events.KeyboardEvent;
	import flash.ui.Keyboard;
	import scaleform.clik.constants.InputValue;
	import scaleform.clik.constants.NavigationCode;
	import scaleform.clik.events.InputEvent;
	import scaleform.clik.ui.InputDetails;
	import scaleform.gfx.KeyboardEventEx;
	
	public class InputDelegate extends EventDispatcher
	{
		
		private static var instance:InputDelegate;
		
		public static const MAX_KEY_CODES:uint = 1000;
		
		public static const KEY_PRESSED:uint = 1;
		
		public static const KEY_SUPRESSED:uint = 2;
		 
		
		public var stage:Stage;
		
		public var externalInputHandler:Function;
		
		protected var keyHash:Array;
		
		public function InputDelegate()
		{
			super();
			this.keyHash = [];
		}
		
		public static function getInstance() : InputDelegate
		{
			if(instance == null)
			{
				instance = new InputDelegate();
			}
			return instance;
		}
		
		public function initialize(param1:Stage) : void
		{
			this.stage = param1;
			param1.addEventListener(KeyboardEvent.KEY_DOWN,this.handleKeyDown,false,0,true);
			param1.addEventListener(KeyboardEvent.KEY_UP,this.handleKeyUp,false,0,true);
		}
		
		public function setKeyRepeat(param1:Number, param2:Boolean, param3:uint = 0) : void
		{
			var _loc4_:uint = param3 * MAX_KEY_CODES + param1;
			if(param2)
			{
				this.keyHash[_loc4_] = this.keyHash[_loc4_] & ~KEY_SUPRESSED;
			}
			else
			{
				this.keyHash[_loc4_] = this.keyHash[_loc4_] | KEY_SUPRESSED;
			}
		}
		
		public function inputToNav(param1:String, param2:Number, param3:Boolean = false, param4:* = null) : String
		{
			if(this.externalInputHandler != null)
			{
				return this.externalInputHandler(param1,param2,param4);
			}
			if(param1 == "key")
			{
				switch(param2)
				{
					case Keyboard.UP:
						return NavigationCode.UP;
					case Keyboard.DOWN:
						return NavigationCode.DOWN;
					case Keyboard.LEFT:
						return NavigationCode.LEFT;
					case Keyboard.RIGHT:
						return NavigationCode.RIGHT;
					case Keyboard.ENTER:
					case Keyboard.SPACE:
						return NavigationCode.ENTER;
					case Keyboard.BACKSPACE:
						return NavigationCode.BACK;
					case Keyboard.TAB:
						if(param3)
						{
							return NavigationCode.SHIFT_TAB;
						}
						return NavigationCode.TAB;
					case Keyboard.HOME:
						return NavigationCode.HOME;
					case Keyboard.END:
						return NavigationCode.END;
					case Keyboard.PAGE_DOWN:
						return NavigationCode.PAGE_DOWN;
					case Keyboard.PAGE_UP:
						return NavigationCode.PAGE_UP;
					case Keyboard.ESCAPE:
						return NavigationCode.ESCAPE;
					case 96:
						return NavigationCode.GAMEPAD_A;
					case 97:
						return NavigationCode.GAMEPAD_B;
					case 98:
						return NavigationCode.GAMEPAD_X;
					case 99:
						return NavigationCode.GAMEPAD_Y;
					case 100:
						return NavigationCode.GAMEPAD_L1;
					case 101:
						return NavigationCode.GAMEPAD_L2;
					case 102:
						return NavigationCode.GAMEPAD_L3;
					case 103:
						return NavigationCode.GAMEPAD_R1;
					case 104:
						return NavigationCode.GAMEPAD_R2;
					case 105:
						return NavigationCode.GAMEPAD_R3;
					case 106:
						return NavigationCode.GAMEPAD_START;
					case 107:
						return NavigationCode.GAMEPAD_BACK;
				}
			}
			return null;
		}
		
		public function readInput(param1:String, param2:int, param3:Function) : Object
		{
			return null;
		}
		
		protected function handleKeyDown(param1:KeyboardEvent) : void
		{
			var _loc2_:KeyboardEventEx = param1 as KeyboardEventEx;
			var _loc3_:uint = _loc2_ == null?uint(0):uint(_loc2_.controllerIdx);
			var _loc4_:Number = param1.keyCode;
			var _loc5_:uint = _loc3_ * MAX_KEY_CODES + _loc4_;
			var _loc6_:uint = this.keyHash[_loc5_];
			if(_loc6_ & KEY_PRESSED)
			{
				if((_loc6_ & KEY_SUPRESSED) == 0)
				{
					this.handleKeyPress(InputValue.KEY_HOLD,_loc4_,_loc3_,param1.ctrlKey,param1.altKey,param1.shiftKey);
				}
			}
			else
			{
				this.handleKeyPress(InputValue.KEY_DOWN,_loc4_,_loc3_,param1.ctrlKey,param1.altKey,param1.shiftKey);
				this.keyHash[_loc5_] = this.keyHash[_loc5_] | KEY_PRESSED;
			}
		}
		
		protected function handleKeyUp(param1:KeyboardEvent) : void
		{
			var _loc2_:KeyboardEventEx = param1 as KeyboardEventEx;
			var _loc3_:uint = _loc2_ == null?uint(0):uint(_loc2_.controllerIdx);
			var _loc4_:Number = param1.keyCode;
			var _loc5_:uint = _loc3_ * MAX_KEY_CODES + _loc4_;
			this.keyHash[_loc5_] = this.keyHash[_loc5_] & ~KEY_PRESSED;
			this.handleKeyPress(InputValue.KEY_UP,_loc4_,_loc3_,param1.ctrlKey,param1.altKey,param1.shiftKey);
		}
		
		protected function handleKeyPress(param1:String, param2:Number, param3:Number, param4:Boolean, param5:Boolean, param6:Boolean) : void
		{
			var _loc7_:InputDetails = new InputDetails("key",param2,param1,this.inputToNav("key",param2,param6),param3,param4,param5,param6);
			dispatchEvent(new InputEvent(InputEvent.INPUT,_loc7_));
		}
	}
}
