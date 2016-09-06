package Shared.AS3
{
	import flash.display.MovieClip;
	import flash.text.TextField;
	import flash.display.InteractiveObject;
	import Shared.GlobalFunc;
	import Shared.CustomEvent;
	import flash.events.KeyboardEvent;
	import flash.ui.Keyboard;
	import flash.utils.getTimer;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	public class QuantityMenu extends MovieClip
	{
		
		private static const LabelBufferX = 3;
		
		public static const QUANTITY_CHANGED = "QuantityChanged";
		
		private static const SCROLL_STARTSPEED = 100;
		
		private static const SCROLL_TIMECOEF = 1000;
		
		private static const SCROLL_MAX = 30;
		
		public static const INV_MAX_NUM_BEFORE_QUANTITY_MENU:uint = 5;
		
		public static const CONFIRM:String = "QuantityMenu::quantityConfirmed";
		 
		
		public var Label_tf:TextField;
		
		public var Value_tf:TextField;
		
		public var TotalValue_tf:TextField;
		
		public var CapsLabel_tf:TextField;
		
		public var QuantityScrollbar_mc:Option_Scrollbar;
		
		public var QuantityBracketHolder_mc:MovieClip;
		
		private var bIsScrolling:Boolean;
		
		private var uiScrollStartTime:uint;
		
		private var uiScrollCurSpeed:uint;
		
		private var iScrollSpeed:int;
		
		protected var iQuantity:int;
		
		protected var iMaxQuantity:int;
		
		protected var iStepSize:int;
		
		protected var bOpened:Boolean;
		
		protected var prevFocusObj:InteractiveObject;
		
		protected var uiItemValue:uint = 0;
		
		public function QuantityMenu()
		{
			super();
			this.uiScrollStartTime = 0;
			this.uiScrollCurSpeed = 1;
			this.iScrollSpeed = 1;
			this.iQuantity = 1;
			this.iMaxQuantity = 1;
			this.bOpened = false;
			this.bIsScrolling = false;
			addEventListener(KeyboardEvent.KEY_DOWN,this.onKeyDown);
			addEventListener(KeyboardEvent.KEY_UP,this.onKeyUp);
			addEventListener(MouseEvent.MOUSE_WHEEL,this.onMouseWheel);
			addEventListener(Option_Scrollbar.VALUE_CHANGE,this.onValueChange);
			this.QuantityScrollbar_mc.removeEventListener(MouseEvent.CLICK,this.QuantityScrollbar_mc.onClick);
			this.QuantityScrollbar_mc.addEventListener(MouseEvent.MOUSE_DOWN,this.onArrowMouseDown);
		}
		
		public function get opened() : Boolean
		{
			return this.bOpened;
		}
		
		public function get quantity() : int
		{
			return this.iQuantity;
		}
		
		public function get prevFocus() : InteractiveObject
		{
			return this.prevFocusObj;
		}
		
		public function OpenMenu(param1:int, param2:InteractiveObject, param3:String = "", param4:* = 0) : *
		{
			this.iQuantity = param1;
			this.iMaxQuantity = param1;
			this.QuantityScrollbar_mc.MinValue = 0;
			this.QuantityScrollbar_mc.MaxValue = param1;
			this.iStepSize = Math.max(param1 / 20,1);
			this.QuantityScrollbar_mc.StepSize = this.iStepSize;
			this.QuantityScrollbar_mc.value = param1;
			this.uiItemValue = param4;
			if(param3.length)
			{
				GlobalFunc.SetText(this.Label_tf,param3,false);
			}
			this.FitBrackets();
			this.RefreshText();
			this.prevFocusObj = param2;
			this.alpha = 1;
			this.bOpened = true;
		}
		
		public function CloseMenu() : *
		{
			this.prevFocusObj = null;
			this.alpha = 0;
			this.bOpened = false;
		}
		
		private function FitBrackets() : *
		{
			var _loc1_:Number = this.Label_tf.x + this.Label_tf.width * 0.5;
			var _loc2_:Number = this.Label_tf.textWidth;
			var _loc3_:MovieClip = this.QuantityBracketHolder_mc.QuantityMenuLeftBracket_mc;
			var _loc4_:MovieClip = this.QuantityBracketHolder_mc.QuantityMenuRightBracket_mc;
			var _loc5_:MovieClip = this.QuantityBracketHolder_mc.QuantityMenuBottomBracket_mc;
			_loc3_.x = _loc1_ - _loc2_ * 0.5 - LabelBufferX - _loc3_.width - this.QuantityBracketHolder_mc.x;
			_loc4_.x = _loc1_ + _loc2_ * 0.5 + LabelBufferX + _loc4_.width - this.QuantityBracketHolder_mc.x;
			_loc5_.width = _loc4_.x - _loc3_.x;
			_loc5_.x = _loc1_ - _loc5_.width * 0.5 - this.QuantityBracketHolder_mc.x;
			if(this.QuantityScrollbar_mc.x < this.QuantityBracketHolder_mc.x + _loc3_.x + 20)
			{
				this.QuantityScrollbar_mc.x = this.QuantityBracketHolder_mc.x + _loc3_.x + 15;
				this.QuantityScrollbar_mc.width = _loc4_.x - _loc3_.x - 15;
			}
		}
		
		private function RefreshText() : *
		{
			var _loc1_:uint = 0;
			GlobalFunc.SetText(this.Value_tf,this.iQuantity.toString(),false);
			this.QuantityScrollbar_mc.value = this.iQuantity;
			if(this.TotalValue_tf != null)
			{
				_loc1_ = this.iQuantity * this.uiItemValue;
				GlobalFunc.SetText(this.TotalValue_tf,_loc1_.toString(),false);
			}
		}
		
		private function modifyQuantity(param1:int) : *
		{
			var _loc2_:int = this.iQuantity + param1;
			_loc2_ = Math.min(_loc2_,this.iMaxQuantity);
			_loc2_ = Math.max(_loc2_,1);
			if(this.iQuantity != _loc2_)
			{
				this.iQuantity = _loc2_;
				this.RefreshText();
				dispatchEvent(new CustomEvent(QUANTITY_CHANGED,_loc2_,true));
			}
		}
		
		public function onKeyDown(param1:KeyboardEvent) : *
		{
			if(param1.keyCode == Keyboard.RIGHT)
			{
				this.bIsScrolling = true;
				this.uiScrollStartTime = getTimer();
				this.iScrollSpeed = 1;
				this.modifyQuantity(1);
				addEventListener(Event.ENTER_FRAME,this.onArrowTick);
				removeEventListener(KeyboardEvent.KEY_DOWN,this.onKeyDown);
			}
			else if(param1.keyCode == Keyboard.LEFT)
			{
				this.bIsScrolling = true;
				this.uiScrollStartTime = getTimer();
				this.iScrollSpeed = -1;
				this.modifyQuantity(-1);
				addEventListener(Event.ENTER_FRAME,this.onArrowTick);
				removeEventListener(KeyboardEvent.KEY_DOWN,this.onKeyDown);
			}
		}
		
		public function onKeyUp(param1:KeyboardEvent) : *
		{
			if(param1.keyCode == Keyboard.UP || param1.keyCode == Keyboard.DOWN || param1.keyCode == Keyboard.RIGHT || param1.keyCode == Keyboard.LEFT)
			{
				this.bIsScrolling = false;
				this.uiScrollCurSpeed = 1;
				removeEventListener(Event.ENTER_FRAME,this.onArrowTick);
				addEventListener(KeyboardEvent.KEY_DOWN,this.onKeyDown);
			}
			if(param1.keyCode == Keyboard.ENTER)
			{
				dispatchEvent(new Event(CONFIRM,true,true));
			}
		}
		
		public function onMouseWheel(param1:MouseEvent) : *
		{
			if(param1.delta > 0)
			{
				this.modifyQuantity(1);
			}
			else if(param1.delta < 0)
			{
				this.modifyQuantity(-1);
			}
		}
		
		function onArrowMouseUp(param1:Event) : void
		{
			this.bIsScrolling = false;
			this.uiScrollCurSpeed = 1;
			removeEventListener(Event.ENTER_FRAME,this.onArrowTick);
			stage.removeEventListener(MouseEvent.MOUSE_UP,this.onArrowMouseUp);
		}
		
		function onArrowTick(param1:Event) : void
		{
			var _loc2_:* = undefined;
			if(this.bIsScrolling)
			{
				_loc2_ = getTimer() - this.uiScrollStartTime;
				if(_loc2_ > SCROLL_STARTSPEED)
				{
					this.uiScrollCurSpeed = this.uiScrollCurSpeed + int(Math.floor(this.uiScrollCurSpeed * (_loc2_ / SCROLL_TIMECOEF)));
					this.uiScrollCurSpeed = Math.min(this.uiScrollCurSpeed,SCROLL_MAX);
					this.modifyQuantity(this.uiScrollCurSpeed * this.iScrollSpeed);
				}
			}
		}
		
		function onValueChange(param1:Event) : void
		{
			this.iQuantity = this.QuantityScrollbar_mc.value;
			this.RefreshText();
		}
		
		public function onArrowMouseDown(param1:MouseEvent) : *
		{
			var _loc3_:MovieClip = null;
			var _loc2_:Object = param1.target;
			if(param1.target as MovieClip)
			{
				_loc3_ = param1.target as MovieClip;
				if(_loc3_ == this.QuantityScrollbar_mc.RightCatcher_mc)
				{
					this.bIsScrolling = true;
					this.uiScrollStartTime = getTimer();
					this.iScrollSpeed = 1;
					this.modifyQuantity(1);
					stage.addEventListener(MouseEvent.MOUSE_UP,this.onArrowMouseUp);
					addEventListener(Event.ENTER_FRAME,this.onArrowTick);
				}
				else if(_loc3_ == this.QuantityScrollbar_mc.LeftCatcher_mc)
				{
					this.bIsScrolling = true;
					this.uiScrollStartTime = getTimer();
					this.iScrollSpeed = -1;
					this.modifyQuantity(-1);
					stage.addEventListener(MouseEvent.MOUSE_UP,this.onArrowMouseUp);
					addEventListener(Event.ENTER_FRAME,this.onArrowTick);
				}
			}
		}
		
		public function ProcessUserEvent(param1:String, param2:Boolean) : Boolean
		{
			var _loc3_:Boolean = false;
			if(!param2)
			{
				if(param1 == "LShoulder")
				{
					this.modifyQuantity(-this.iStepSize);
					_loc3_ = true;
				}
				else if(param1 == "RShoulder")
				{
					this.modifyQuantity(this.iStepSize);
					_loc3_ = true;
				}
			}
			return _loc3_;
		}
	}
}
