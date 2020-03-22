package Shared.AS3
{
	import Shared.CustomEvent;
	import Shared.GlobalFunc;
	import flash.display.InteractiveObject;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.ui.Keyboard;
	import flash.utils.getTimer;
	
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
		
		public function OpenMenu(aiQuantity:int, aPrevFocusObj:InteractiveObject, asLabelText:String = "", auiItemValue:* = 0) : *
		{
			this.iQuantity = aiQuantity;
			this.iMaxQuantity = aiQuantity;
			this.QuantityScrollbar_mc.MinValue = 0;
			this.QuantityScrollbar_mc.MaxValue = aiQuantity;
			this.iStepSize = Math.max(aiQuantity / 20,1);
			this.QuantityScrollbar_mc.StepSize = this.iStepSize;
			this.QuantityScrollbar_mc.value = aiQuantity;
			this.uiItemValue = auiItemValue;
			if(asLabelText.length)
			{
				GlobalFunc.SetText(this.Label_tf,asLabelText,false);
			}
			this.FitBrackets();
			this.RefreshText();
			this.prevFocusObj = aPrevFocusObj;
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
			var midX:Number = this.Label_tf.x + this.Label_tf.width * 0.5;
			var labelWidth:Number = this.Label_tf.textWidth;
			var QuantityMenuLeftBracket_mc:MovieClip = this.QuantityBracketHolder_mc.QuantityMenuLeftBracket_mc;
			var QuantityMenuRightBracket_mc:MovieClip = this.QuantityBracketHolder_mc.QuantityMenuRightBracket_mc;
			var QuantityMenuBottomBracket_mc:MovieClip = this.QuantityBracketHolder_mc.QuantityMenuBottomBracket_mc;
			QuantityMenuLeftBracket_mc.x = midX - labelWidth * 0.5 - LabelBufferX - QuantityMenuLeftBracket_mc.width - this.QuantityBracketHolder_mc.x;
			QuantityMenuRightBracket_mc.x = midX + labelWidth * 0.5 + LabelBufferX + QuantityMenuRightBracket_mc.width - this.QuantityBracketHolder_mc.x;
			QuantityMenuBottomBracket_mc.width = QuantityMenuRightBracket_mc.x - QuantityMenuLeftBracket_mc.x;
			QuantityMenuBottomBracket_mc.x = midX - QuantityMenuBottomBracket_mc.width * 0.5 - this.QuantityBracketHolder_mc.x;
			if(this.QuantityScrollbar_mc.x < this.QuantityBracketHolder_mc.x + QuantityMenuLeftBracket_mc.x + 20)
			{
				this.QuantityScrollbar_mc.x = this.QuantityBracketHolder_mc.x + QuantityMenuLeftBracket_mc.x + 15;
				this.QuantityScrollbar_mc.width = QuantityMenuRightBracket_mc.x - QuantityMenuLeftBracket_mc.x - 15;
			}
		}
		
		private function RefreshText() : *
		{
			var uitotalValue:uint = 0;
			GlobalFunc.SetText(this.Value_tf,this.iQuantity.toString(),false);
			this.QuantityScrollbar_mc.value = this.iQuantity;
			if(this.TotalValue_tf != null)
			{
				uitotalValue = this.iQuantity * this.uiItemValue;
				GlobalFunc.SetText(this.TotalValue_tf,uitotalValue.toString(),false);
			}
		}
		
		private function modifyQuantity(aiQuantity:int) : *
		{
			var newQuantity:int = this.iQuantity + aiQuantity;
			newQuantity = Math.min(newQuantity,this.iMaxQuantity);
			newQuantity = Math.max(newQuantity,1);
			if(this.iQuantity != newQuantity)
			{
				this.iQuantity = newQuantity;
				this.RefreshText();
				dispatchEvent(new CustomEvent(QUANTITY_CHANGED,newQuantity,true));
			}
		}
		
		public function onKeyDown(event:KeyboardEvent) : *
		{
			if(event.keyCode == Keyboard.RIGHT)
			{
				this.bIsScrolling = true;
				this.uiScrollStartTime = getTimer();
				this.iScrollSpeed = 1;
				this.modifyQuantity(1);
				addEventListener(Event.ENTER_FRAME,this.onArrowTick);
				removeEventListener(KeyboardEvent.KEY_DOWN,this.onKeyDown);
			}
			else if(event.keyCode == Keyboard.LEFT)
			{
				this.bIsScrolling = true;
				this.uiScrollStartTime = getTimer();
				this.iScrollSpeed = -1;
				this.modifyQuantity(-1);
				addEventListener(Event.ENTER_FRAME,this.onArrowTick);
				removeEventListener(KeyboardEvent.KEY_DOWN,this.onKeyDown);
			}
		}
		
		public function onKeyUp(event:KeyboardEvent) : *
		{
			if(event.keyCode == Keyboard.UP || event.keyCode == Keyboard.DOWN || event.keyCode == Keyboard.RIGHT || event.keyCode == Keyboard.LEFT)
			{
				this.bIsScrolling = false;
				this.uiScrollCurSpeed = 1;
				removeEventListener(Event.ENTER_FRAME,this.onArrowTick);
				addEventListener(KeyboardEvent.KEY_DOWN,this.onKeyDown);
			}
			if(event.keyCode == Keyboard.ENTER)
			{
				dispatchEvent(new Event(CONFIRM,true,true));
			}
		}
		
		public function onMouseWheel(event:MouseEvent) : *
		{
			if(event.delta > 0)
			{
				this.modifyQuantity(1);
			}
			else if(event.delta < 0)
			{
				this.modifyQuantity(-1);
			}
		}
		
		function onArrowMouseUp(e:Event) : void
		{
			this.bIsScrolling = false;
			this.uiScrollCurSpeed = 1;
			removeEventListener(Event.ENTER_FRAME,this.onArrowTick);
			stage.removeEventListener(MouseEvent.MOUSE_UP,this.onArrowMouseUp);
		}
		
		function onArrowTick(e:Event) : void
		{
			var deltaTime:* = undefined;
			if(this.bIsScrolling)
			{
				deltaTime = getTimer() - this.uiScrollStartTime;
				if(deltaTime > SCROLL_STARTSPEED)
				{
					this.uiScrollCurSpeed = this.uiScrollCurSpeed + int(Math.floor(this.uiScrollCurSpeed * (deltaTime / SCROLL_TIMECOEF)));
					this.uiScrollCurSpeed = Math.min(this.uiScrollCurSpeed,SCROLL_MAX);
					this.modifyQuantity(this.uiScrollCurSpeed * this.iScrollSpeed);
				}
			}
		}
		
		function onValueChange(e:Event) : void
		{
			this.iQuantity = this.QuantityScrollbar_mc.value;
			this.RefreshText();
		}
		
		public function onArrowMouseDown(event:MouseEvent) : *
		{
			var clicktarget:MovieClip = null;
			var otarget:Object = event.target;
			if(event.target as MovieClip)
			{
				clicktarget = event.target as MovieClip;
				if(clicktarget == this.QuantityScrollbar_mc.RightCatcher_mc)
				{
					this.bIsScrolling = true;
					this.uiScrollStartTime = getTimer();
					this.iScrollSpeed = 1;
					this.modifyQuantity(1);
					stage.addEventListener(MouseEvent.MOUSE_UP,this.onArrowMouseUp);
					addEventListener(Event.ENTER_FRAME,this.onArrowTick);
				}
				else if(clicktarget == this.QuantityScrollbar_mc.LeftCatcher_mc)
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
		
		public function ProcessUserEvent(asEvent:String, bData:Boolean) : Boolean
		{
			var bprocessed:Boolean = false;
			if(!bData)
			{
				if(asEvent == "LShoulder")
				{
					this.modifyQuantity(-this.iStepSize);
					bprocessed = true;
				}
				else if(asEvent == "RShoulder")
				{
					this.modifyQuantity(this.iStepSize);
					bprocessed = true;
				}
			}
			return bprocessed;
		}
	}
}
