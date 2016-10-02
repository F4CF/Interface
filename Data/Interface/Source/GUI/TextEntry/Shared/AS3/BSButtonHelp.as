package Shared.AS3
{
	import flash.display.MovieClip;
	import flash.text.TextField;
	import Shared.IMenu;
	import flash.utils.Timer;
	import flash.events.TimerEvent;
	import flash.events.Event;
	import Shared.PlatformChangeEvent;
	import Shared.GlobalFunc;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	import flash.text.TextFieldAutoSize;
	
	public class BSButtonHelp extends MovieClip
	{
		
		static const JUSTIFY_RIGHT:uint = 0;
		
		static const JUSTIFY_LEFT:uint = 1;
		
		public static const BUTTON_INITIALIZED:String = "ButtonInitialized";
		
		private static const NameToTextMap:Object = {
			"Xenon_A":"A",
			"Xenon_B":"B",
			"Xenon_X":"C",
			"Xenon_Y":"D",
			"Xenon_Select":"E",
			"Xenon_L3":"F",
			"Xenon_L1":"G",
			"Xenon_LS":"H",
			"Xenon_L2":"I",
			"Xenon_L2R2":"J",
			"Xenon_R3":"K",
			"Xenon_R1":"L",
			"Xenon_RS":"M",
			"Xenon_R2":"N",
			"Xenon_Start":"O",
			"Xenon_R2_Alt":"X",
			"Xenon_L2_Alt":"Y",
			"Xenon_Up":"W",
			"PSN_A":"a",
			"PSN_Y":"b",
			"PSN_X":"c",
			"PSN_B":"d",
			"PSN_Select":"e",
			"PSN_L3":"f",
			"PSN_L1":"g",
			"PSN_L1R1":"h",
			"PSN_LS":"i",
			"PSN_L2":"j",
			"PSN_L2R2":"k",
			"PSN_R3":"l",
			"PSN_R1":"m",
			"PSN_RS":"n",
			"PSN_R2":"o",
			"PSN_Start":"p",
			"PSN_R2_Alt":"x",
			"PSN_L2_Alt":"y",
			"PSN_Up":"W"
		};
		 
		
		public var textField_tf:TextField;
		
		public var PCKeyHolderInstance:MovieClip;
		
		public var IconHolderInstance:MovieClip;
		
		protected var _parentClass:IMenu;
		
		protected var timer:Timer;
		
		protected var iPlatform:Number;
		
		protected var strPCKey:String;
		
		protected var strXenonButton:String;
		
		protected var strPSNButton:String;
		
		protected var uiJustification:uint;
		
		public function BSButtonHelp()
		{
			super();
			this.iPlatform = GlobalFunc.PLATFORM_XB1;
			this.uiJustification = JUSTIFY_LEFT;
			this.timer = new Timer(1,1);
			this.timer.addEventListener(TimerEvent.TIMER_COMPLETE,this.Init);
			this.timer.start();
		}
		
		protected function Init(param1:TimerEvent) : *
		{
			this.timer.removeEventListener(TimerEvent.TIMER_COMPLETE,this.Init);
			dispatchEvent(new Event(BUTTON_INITIALIZED,true));
		}
		
		public function set parentClass(param1:IMenu) : void
		{
			this._parentClass = param1;
			this._parentClass.addEventListener(PlatformChangeEvent.PLATFORM_CHANGE,this.onSetPlatform);
		}
		
		public function get PCKey() : String
		{
			return this.strPCKey;
		}
		
		public function set PCKey(param1:String) : *
		{
			this.strPCKey = param1;
			this.RefreshIcon();
		}
		
		public function get XenonButton() : String
		{
			return this.strXenonButton;
		}
		
		public function set XenonButton(param1:String) : *
		{
			this.strXenonButton = NameToTextMap[param1];
			this.RefreshIcon();
		}
		
		public function get PSNButton() : String
		{
			return this.strPSNButton;
		}
		
		public function set PSNButton(param1:String) : *
		{
			this.strPSNButton = NameToTextMap[param1];
			this.RefreshIcon();
		}
		
		public function get buttonText() : String
		{
			return this.textField_tf.text;
		}
		
		public function set buttonText(param1:String) : *
		{
			GlobalFunc.SetText(this.textField_tf,param1,true);
		}
		
		public function get Justification() : uint
		{
			return this.uiJustification;
		}
		
		public function set Justification(param1:uint) : *
		{
			var _loc2_:TextFormat = null;
			this.uiJustification = param1;
			if(this.uiJustification == JUSTIFY_LEFT)
			{
				_loc2_ = this.PCKeyHolderInstance.PCKeyAnimInstance.PCKey_tf.getTextFormat();
				_loc2_.align = TextFormatAlign.RIGHT;
				this.PCKeyHolderInstance.PCKeyAnimInstance.PCKey_tf.setTextFormat(_loc2_);
				this.PCKeyHolderInstance.PCKeyAnimInstance.PCKey_tf.autoSize = TextFieldAutoSize.RIGHT;
				this.PCKeyHolderInstance.PCKeyAnimInstance.PCKey_tf.x = -this.PCKeyHolderInstance.PCKeyAnimInstance.PCKey_tf.width;
				_loc2_ = this.IconHolderInstance.IconAnimInstance.Icon_tf.getTextFormat();
				_loc2_.align = TextFormatAlign.RIGHT;
				this.IconHolderInstance.IconAnimInstance.Icon_tf.setTextFormat(_loc2_);
				this.IconHolderInstance.IconAnimInstance.Icon_tf.autoSize = TextFieldAutoSize.RIGHT;
				this.IconHolderInstance.IconAnimInstance.Icon_tf.x = -this.IconHolderInstance.IconAnimInstance.Icon_tf.width;
				_loc2_ = this.textField_tf.getTextFormat();
				_loc2_.align = TextFormatAlign.LEFT;
				this.textField_tf.setTextFormat(_loc2_);
				this.textField_tf.autoSize = TextFieldAutoSize.LEFT;
				this.textField_tf.x = 0;
			}
			else
			{
				_loc2_ = this.PCKeyHolderInstance.PCKeyAnimInstance.PCKey_tf.getTextFormat();
				_loc2_.align = TextFormatAlign.LEFT;
				this.PCKeyHolderInstance.PCKeyAnimInstance.PCKey_tf.setTextFormat(_loc2_);
				this.PCKeyHolderInstance.PCKeyAnimInstance.PCKey_tf.autoSize = TextFieldAutoSize.LEFT;
				this.PCKeyHolderInstance.PCKeyAnimInstance.PCKey_tf.x = 0;
				_loc2_ = this.IconHolderInstance.IconAnimInstance.Icon_tf.getTextFormat();
				_loc2_.align = TextFormatAlign.LEFT;
				this.IconHolderInstance.IconAnimInstance.Icon_tf.setTextFormat(_loc2_);
				this.IconHolderInstance.IconAnimInstance.Icon_tf.autoSize = TextFieldAutoSize.LEFT;
				this.IconHolderInstance.IconAnimInstance.Icon_tf.x = 0;
				_loc2_ = this.textField_tf.getTextFormat();
				_loc2_.align = TextFormatAlign.RIGHT;
				this.textField_tf.setTextFormat(_loc2_);
				this.textField_tf.autoSize = TextFieldAutoSize.RIGHT;
				this.textField_tf.x = -this.textField_tf.width;
			}
		}
		
		public function GetButtonWidth() : uint
		{
			var _loc1_:uint = 0;
			_loc1_ = this.textField_tf.getLineMetrics(0).x + this.textField_tf.getLineMetrics(0).width;
			if(this.iPlatform == GlobalFunc.PLATFORM_PC_KB_MOUSE)
			{
				_loc1_ = _loc1_ - this.PCKeyHolderInstance.PCKeyAnimInstance.PCKey_tf.getLineMetrics(0).x;
			}
			else
			{
				_loc1_ = _loc1_ - this.IconHolderInstance.IconAnimInstance.Icon_tf.getLineMetrics(0).x;
			}
			return _loc1_;
		}
		
		public function GetPCKeyTextField() : TextField
		{
			return this.PCKeyHolderInstance.PCKeyAnimInstance.PCKey_tf;
		}
		
		public function GetIconTextField() : TextField
		{
			return this.IconHolderInstance.IconAnimInstance.Icon_tf;
		}
		
		private function RefreshIcon() : *
		{
			if(this.iPlatform == GlobalFunc.PLATFORM_PC_KB_MOUSE)
			{
				if(this.uiJustification == JUSTIFY_LEFT)
				{
					GlobalFunc.SetText(this.PCKeyHolderInstance.PCKeyAnimInstance.PCKey_tf,this.strPCKey + ")",true);
				}
				else
				{
					GlobalFunc.SetText(this.PCKeyHolderInstance.PCKeyAnimInstance.PCKey_tf,"(" + this.strPCKey,true);
				}
				this.IconHolderInstance.IconAnimInstance.Icon_tf.visible = false;
			}
			else if(this.iPlatform == GlobalFunc.PLATFORM_PC_GAMEPAD || this.iPlatform == GlobalFunc.PLATFORM_XB1)
			{
				GlobalFunc.SetText(this.PCKeyHolderInstance.PCKeyAnimInstance.PCKey_tf," ",true);
				GlobalFunc.SetText(this.IconHolderInstance.IconAnimInstance.Icon_tf,this.strXenonButton,true);
				this.IconHolderInstance.IconAnimInstance.Icon_tf.visible = true;
			}
			else if(this.iPlatform == GlobalFunc.PLATFORM_PS4)
			{
				GlobalFunc.SetText(this.PCKeyHolderInstance.PCKeyAnimInstance.PCKey_tf," ",true);
				GlobalFunc.SetText(this.IconHolderInstance.IconAnimInstance.Icon_tf,this.strPSNButton,true);
				this.IconHolderInstance.IconAnimInstance.Icon_tf.visible = true;
			}
		}
		
		public function SetButtonData(param1:String, param2:String, param3:String, param4:String) : *
		{
			this.buttonText = param1;
			this.strPCKey = param2;
			this.strXenonButton = NameToTextMap[param3];
			this.strPSNButton = NameToTextMap[param4];
			this.RefreshIcon();
		}
		
		public function onSetPlatform(param1:Event) : *
		{
			var _loc2_:PlatformChangeEvent = param1 as PlatformChangeEvent;
			this.SetPlatform(_loc2_.uiPlatform,_loc2_.bPS3Switch);
		}
		
		public function SetPlatform(param1:Number, param2:Boolean) : void
		{
			this.iPlatform = param1;
			this.RefreshIcon();
		}
		
		public function SetFlashing(param1:Boolean) : *
		{
			this.PCKeyHolderInstance.gotoAndPlay(!!param1?"Flashing":"Default");
			this.IconHolderInstance.gotoAndPlay(!!param1?"Flashing":"Default");
		}
		
		public function set useInvertedFont(param1:Boolean) : *
		{
			var _loc2_:TextFormat = this.IconHolderInstance.IconAnimInstance.Icon_tf.getTextFormat();
			_loc2_.font = !!param1?"$Controller_buttons_inverted":"$Controller_buttons";
			this.IconHolderInstance.IconAnimInstance.Icon_tf.setTextFormat(_loc2_);
		}
	}
}
