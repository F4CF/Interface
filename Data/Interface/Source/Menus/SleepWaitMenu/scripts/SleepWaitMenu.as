package
{
	import Shared.IMenu;
	import flash.text.TextField;
	import flash.display.MovieClip;
	import Shared.AS3.BSButtonHintBar;
	import Shared.AS3.BSButtonHintData;
	import flash.display.InteractiveObject;
	import Shared.GlobalFunc;
	import flash.events.MouseEvent;
	import flash.events.KeyboardEvent;
	import flash.ui.Keyboard;
	
	public class SleepWaitMenu extends IMenu
	{
		 
		
		public var BGSCodeObj:Object;
		
		public var HoursLabel_tf:TextField;
		
		public var CurrentTime_tf:TextField;
		
		public var Label_tf:TextField;
		
		public var Value_tf:TextField;
		
		public var UpArrow_mc:MovieClip;
		
		public var DownArrow_mc:MovieClip;
		
		public var Function_tf:TextField;
		
		public var BracketPairHolder_mc:MovieClip;
		
		public var BGRect_mc:MovieClip;
		
		public var FadeInBackground_mc:MovieClip;
		
		public var ButtonHintBar_mc:BSButtonHintBar;
		
		public var LowerBracket_mc:MovieClip;
		
		public var UpperBracket_mc:MovieClip;
		
		public var TestBar_mc:MovieClip;
		
		private var AcceptButton:BSButtonHintData;
		
		private var CancelButton:BSButtonHintData;
		
		protected var iHours:int;
		
		protected var iMaxHours:int;
		
		protected var bSleeping:Boolean;
		
		protected var bWaiting:Boolean;
		
		protected var bOpened:Boolean;
		
		protected var prevFocusObj:InteractiveObject;
		
		private var FunctionToValueDelta;
		
		public function SleepWaitMenu()
		{
			this.AcceptButton = new BSButtonHintData("$OK","Enter","PSN_A","Xenon_A",1,this.onAcceptPressed);
			this.CancelButton = new BSButtonHintData("$CANCEL","Tab","PSN_B","Xenon_B",1,this.onCancelPressed);
			super();
			this.BGSCodeObj = new Object();
			this.PopulateButtonBar();
			this.iHours = 8;
			this.iMaxHours = 24;
			this.bOpened = false;
			this.bWaiting = false;
			stage.focus = this;
			addEventListener(KeyboardEvent.KEY_DOWN,this.onKeyDownCallback);
			addEventListener(MouseEvent.MOUSE_WHEEL,this.onMouseWheel);
			this.DownArrow_mc.addEventListener(MouseEvent.MOUSE_DOWN,this.onArrowClick);
			this.UpArrow_mc.addEventListener(MouseEvent.MOUSE_DOWN,this.onArrowClick);
			this.FunctionToValueDelta = this.Value_tf.x - this.Function_tf.x;
			this.__setProp_BGRect_mc_Wait_mc_Brackets_0();
			this.__setProp_ButtonHintBar_mc_Wait_mc_ButtonHintBar_mc_0();
		}
		
		private function PopulateButtonBar() : void
		{
			var _loc1_:Vector.<BSButtonHintData> = new Vector.<BSButtonHintData>();
			_loc1_.push(this.AcceptButton);
			_loc1_.push(this.CancelButton);
			this.ButtonHintBar_mc.SetButtonHintData(_loc1_);
		}
		
		public function get sleeping() : Boolean
		{
			return this.bSleeping;
		}
		
		public function get waiting() : Boolean
		{
			return this.bWaiting;
		}
		
		public function set waiting(param1:Boolean) : *
		{
			this.bWaiting = param1;
		}
		
		public function get opened() : Boolean
		{
			return this.bOpened;
		}
		
		public function get prevFocus() : InteractiveObject
		{
			return this.prevFocusObj;
		}
		
		public function set hours(param1:int) : *
		{
			this.iHours = param1;
		}
		
		public function get hours() : *
		{
			return this.iHours;
		}
		
		public function SetSleeping(param1:Boolean) : *
		{
			this.bSleeping = param1;
			if(this.bSleeping)
			{
				GlobalFunc.SetText(this.Function_tf,"$SleepPrompt",false);
			}
			else
			{
				GlobalFunc.SetText(this.Function_tf,"$WaitPrompt",false);
			}
			this.RefreshText(true);
		}
		
		private function onAcceptPressed() : void
		{
			this.BGSCodeObj.Accept();
		}
		
		private function onCancelPressed() : void
		{
			this.BGSCodeObj.Cancel();
		}
		
		public function SetWaiting(param1:Boolean) : *
		{
			this.bWaiting = param1;
			this.AcceptButton.ButtonEnabled = !param1;
		}
		
		public function ModifyHours(param1:int) : *
		{
			this.iHours = this.iHours + param1;
			if(this.iHours < 0)
			{
				this.iHours = 0;
			}
			if(this.iHours > this.iMaxHours)
			{
				this.iHours = this.iMaxHours;
			}
			this.RefreshText(false);
		}
		
		private function RefreshText(param1:Boolean) : *
		{
			var _loc2_:* = undefined;
			var _loc3_:* = undefined;
			var _loc4_:* = undefined;
			GlobalFunc.SetText(this.Value_tf,this.iHours.toString(),false);
			if(this.iHours == 1)
			{
				GlobalFunc.SetText(this.HoursLabel_tf,"$hour.",false);
			}
			else
			{
				GlobalFunc.SetText(this.HoursLabel_tf,"$hours.",false);
			}
			if(param1)
			{
				_loc2_ = this.Function_tf.textWidth + this.HoursLabel_tf.textWidth + this.Value_tf.width;
				_loc3_ = (1280 - _loc2_) / 2;
				_loc4_ = _loc3_ + this.Function_tf.textWidth;
				this.Function_tf.x = _loc4_ - this.Function_tf.width;
				this.Value_tf.x = _loc4_;
				this.HoursLabel_tf.x = this.Value_tf.x + this.Value_tf.width;
				this.UpArrow_mc.x = this.DownArrow_mc.x = this.Value_tf.x + this.Value_tf.width / 2;
			}
		}
		
		private function onArrowClick(param1:MouseEvent) : void
		{
			this.ChangeHour(param1.currentTarget == this.UpArrow_mc);
		}
		
		public function onKeyDownCallback(param1:KeyboardEvent) : *
		{
			if(param1.keyCode == Keyboard.UP)
			{
				this.ChangeHour(true);
			}
			else if(param1.keyCode == Keyboard.DOWN)
			{
				this.ChangeHour(false);
			}
		}
		
		public function onMouseWheel(param1:MouseEvent) : *
		{
			this.ChangeHour(param1.delta > 0);
		}
		
		private function ChangeHour(param1:Boolean) : *
		{
			if(!this.bWaiting)
			{
				if(param1 && this.iHours < this.iMaxHours)
				{
					this.iHours++;
					this.RefreshText(false);
				}
				else if(!param1 && this.iHours > 1)
				{
					this.iHours--;
					this.RefreshText(false);
				}
			}
		}
		
		public function ProcessUserEvent(param1:String, param2:Boolean) : *
		{
			if(!this.bWaiting && !param2)
			{
				if(param1 == "LTrigger")
				{
					this.iHours = this.iHours - 5;
					if(this.iHours < 1)
					{
						this.iHours = 1;
					}
					this.RefreshText(false);
				}
				else if(param1 == "RTrigger")
				{
					this.iHours = this.iHours + 5;
					if(this.iHours > this.iMaxHours)
					{
						this.iHours = this.iMaxHours;
					}
					this.RefreshText(false);
				}
			}
		}
		
		public function SetCurrentTime(param1:String) : *
		{
			this.CurrentTime_tf.text = param1;
		}
		
		public function FadeInBackgroundRect() : *
		{
			this.FadeInBackground_mc.gotoAndPlay("fadeIn");
		}
		
		function __setProp_BGRect_mc_Wait_mc_Brackets_0() : *
		{
			try
			{
				this.BGRect_mc["componentInspectorSetting"] = true;
			}
			catch(e:Error)
			{
			}
			this.BGRect_mc.bracketCornerLength = 6;
			this.BGRect_mc.bracketLineWidth = 1.5;
			this.BGRect_mc.bracketPaddingX = 0;
			this.BGRect_mc.bracketPaddingY = 0;
			this.BGRect_mc.BracketStyle = "horizontal";
			this.BGRect_mc.bShowBrackets = false;
			this.BGRect_mc.bUseShadedBackground = true;
			this.BGRect_mc.ShadedBackgroundMethod = "Shader";
			this.BGRect_mc.ShadedBackgroundType = "normal";
			try
			{
				this.BGRect_mc["componentInspectorSetting"] = false;
				return;
			}
			catch(e:Error)
			{
				return;
			}
		}
		
		function __setProp_ButtonHintBar_mc_Wait_mc_ButtonHintBar_mc_0() : *
		{
			try
			{
				this.ButtonHintBar_mc["componentInspectorSetting"] = true;
			}
			catch(e:Error)
			{
			}
			this.ButtonHintBar_mc.BackgroundAlpha = 1;
			this.ButtonHintBar_mc.BackgroundColor = 0;
			this.ButtonHintBar_mc.bracketCornerLength = 6;
			this.ButtonHintBar_mc.bracketLineWidth = 1.5;
			this.ButtonHintBar_mc.BracketStyle = "horizontal";
			this.ButtonHintBar_mc.bRedirectToButtonBarMenu = false;
			this.ButtonHintBar_mc.bShowBrackets = false;
			this.ButtonHintBar_mc.bUseShadedBackground = true;
			this.ButtonHintBar_mc.ShadedBackgroundMethod = "Shader";
			this.ButtonHintBar_mc.ShadedBackgroundType = "normal";
			try
			{
				this.ButtonHintBar_mc["componentInspectorSetting"] = false;
				return;
			}
			catch(e:Error)
			{
				return;
			}
		}
	}
}
